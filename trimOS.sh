#!/bin/sh

set -o pipefail

# Help function
trim_os_help() {
    cat << EOF
Script to enable/disable HostOS services.
$0 <OPTION>

Options:
  -h, --help
  -e enable services
  -d disable services
EOF
}

# Parse arguments
while [ $# -gt 0 ]; do
    arg="$1"

    case $arg in
        -h|--help)
            trim_os_help
            exit 0
            ;;
        -e)
            action="enable"
            ;;
        -d)
            action="disable"
            ;;
        *)
            echo "ERROR: Unrecognized option $1."
            exit 1
            ;;
    esac
    shift
done

if [ -z $action ]; then
        echo "Please pass action. Enable or Disable"
        trim_os_help
        exit 1
fi


#Disable some stuff
list="resin-supervisor update-resin-supervisor update-resin-supervisor.timer rollback-altboot rollback-health resin-proxy-config avahi-daemon bluetooth hciuart os-sshkeys os-networkmanager resin-hostname bind-var-lib-bluetooth resin-persistent-logs bind-etc-resin-supervisor"

# Disable more stuff
# list="resin-supervisor update-resin-supervisor update-resin-supervisor.timer rollback-altboot rollback-health resin-proxy-config avahi-daemon bluetooth hciuart os-sshkeys os-networkmanager resin-hostname bind-var-lib-bluetooth resin-persistent-logs bind-etc-resin-supervisor os-config os-config-devicekey ModemManager plymouth-start os-udevrules chronyd balena-device-uuid sshdgenkeys resin-init"

# Disable even more stuff!
# list="resin-supervisor update-resin-supervisor update-resin-supervisor.timer rollback-altboot rollback-health resin-proxy-config avahi-daemon bluetooth hciuart os-sshkeys os-networkmanager resin-hostname bind-var-lib-bluetooth resin-persistent-logs bind-etc-resin-supervisor os-config os-config-devicekey ModemManager plymouth-start os-udevrules chronyd balena-device-uuid sshdgenkeys resin-init plymouth-read-write resin-filesystem-expand sys-kernel-debug.mount rollback-clear-bootcount balena-host.socket"

# Disable even even more stuff!
# list="resin-supervisor update-resin-supervisor update-resin-supervisor.timer rollback-altboot rollback-health resin-proxy-config avahi-daemon bluetooth hciuart os-sshkeys os-networkmanager resin-hostname bind-var-lib-bluetooth resin-persistent-logs bind-etc-resin-supervisor os-config os-config-devicekey ModemManager plymouth-start os-udevrules chronyd balena-device-uuid sshdgenkeys resin-init plymouth-read-write resin-filesystem-expand sys-kernel-debug.mount rollback-clear-bootcount balena-host.socket bind-var-lib-chrony systemd-update-utmp bind-etc-udev-rules.d bind-etc-hostname"

# Disable vpn even. Are you really sure?
# list="resin-supervisor update-resin-supervisor update-resin-supervisor.timer rollback-altboot rollback-health resin-proxy-config avahi-daemon bluetooth hciuart os-sshkeys os-networkmanager resin-hostname bind-var-lib-bluetooth resin-persistent-logs bind-etc-resin-supervisor os-config os-config-devicekey ModemManager plymouth-start os-udevrules chronyd balena-device-uuid sshdgenkeys resin-init plymouth-read-write resin-filesystem-expand sys-kernel-debug.mount rollback-clear-bootcount balena-host.socket bind-var-lib-chrony systemd-update-utmp bind-etc-udev-rules.d bind-etc-hostname bind-etc-openvpn openvpn timeinit-timestamp prepare-openvpn"

# Disable everything? Write bare-metal assembly code ;)

# Mount filesystem as read-write

mount -o remount,rw /

for i in $list; do
        if [ "$action" = "disable" ]; then
                systemctl stop "$i"
                systemctl $action "$i"
                systemctl mask "$i"
        else
                systemctl unmask "$i"
                systemctl $action "$i"
                systemctl daemon-reload
                systemctl start "$i"
        fi

        if [ "$i" = "resin-supervisor" ]; then
                balena rm -f resin-supervisor
        fi

done

systemctl daemon-reload

# Mount filesystem as read-only
mount -o remount,ro /
