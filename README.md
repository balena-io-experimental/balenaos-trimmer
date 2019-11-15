## WIP

## Introduction

balenaOS has a minimal overhead. But quite a few people have asked for ways to trim the OS even more.

This can be somewhat benefitial for slow devices like pi0. Or for people who want to radically improve boot time by gutting things out.

Being able to selectively disable various 'features' of the OS via balenaCloud is on the to-do list.

However, here is a script that literally guts various services of the OS.

It can be used as a starting point for trimming the OS down further.

What/how the script works is purposefully not documented at the moment.

You **NEED** to understand what the script does before trying to use it.

And you really need to be comfortable with balenaOS to know. Checkout the [balenaOS masterclass](https://github.com/balena-io-projects/balenaos-masterclass)

### How to use

Download the script onto your device in the `/mnt/data/` folder

**IMPORTANT: Modify script to suit your app/needs**

Do note: You are in unchartered/untested territory

##### Disable Services

```
bash -x /mnt/data/trimOS.sh -d
```

##### Enable Services

```
bash -x /mnt/data/trimOS.sh -e
```

## How do I know which services to disable?

Run on device

```
systemd-analyze plot > /mnt/data/bootplot.svg
```

`scp` the file to your local laptop

`scp /mnt/data/bootplot username@laptop-ip:/path-on-laptop`

Open the file in a browser and have a look at the dependency chain.

Keep in mind, various services depend on each other. You can't just pluck them out randomly.
e.g. if you disable `resin-net-config`, `dnsmasq` won't work.

Also, if you disable vpn, I'm assuming you have a way to go back into the device to re-enable it if needed.
