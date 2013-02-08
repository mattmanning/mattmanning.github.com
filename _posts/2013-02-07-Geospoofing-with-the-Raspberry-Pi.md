---
layout: posts
title: Geospoofing with the Raspberry Pi
---

Many online services, especially media services, use IP addresses to determine your physical location and then use that information to determine the level or type of service you can get. For example, Netflix offers different movies to those outside of the United States and professional sports streaming services enforce regional blackouts to protect TV contracts. These types of practices violate the spirit of the free and open Internet. Unfortunately, they are legal, since the U.S. government has never passed comprehensive net neutrality legislation.

The good news is, we can circumvent these unfair practices with technology in a rather straightforward way using a virtual private network (VPN). Many people are already familiar with VPN technology as it is used heavily in the corporate world to provide secure external access to a local network without opening up that network to everyone on the public Internet. A side effect of VPN usage is that requests appear to originate from the private network's IP address, rather than your own. You can use this to your advantage to "geospoof" your physical location.

This works great if you're spoofing on a general-purpose computing device that you control like a laptop, but what if you want to use something closed, like an AppleTV, game console, or network-connected TV? In this case, things get much more tricky. In most cases these devices won't let you install arbitrary software like a VPN client or let you have too much control over networking. Enter the Raspberry Pi.

The [Raspberry Pi](http://www.raspberrypi.org/faqs) is a credit-card sized, low power computer on a single board that costs about $35. It was originally designed to be a cheap computer for education, but it's seen a boom in the maker market, too. My friend, Mike, gave me one for Christmas, and it's been really fun to tinker with.

The Raspberry Pi Foundation releases a special version of Debian Linux optimized for the Pi called [Raspbian](http://www.raspberrypi.org/faqs). A $35 Linux computer is hard to beat. Here's a step-by-step guide for how I turned my Raspberry Pi into a geospoofing VPN gateway.

Setting up the Raspberry Pi
===========================

First you need to start with a fresh install of Raspian "wheezy." You can download it [here](http://www.raspberrypi.org/downloads) and find a guide for writing the image to an SD card [here](http://elinux.org/RPi_Easy_SD_Card_Setup).

The first time you boot the computer, you'll be taken to the configuration tool, raspi-config. It looks something like this.

![raspi-config menu screen](/images/raspi-config.png)

Since you'll be using this computer as a network device, you'll want to change the default password here for security reasons. Turning on the ssh server is also necessary unless you intend to keep the Pi hooked up to a monitor, keyboard, and mouse permanently.

At some point you'll want to upgrade all the software on your Pi using the commands:

    sudo apt-get update
    sudo apt-get upgrade

The upgrade command will take quite a while though, so you might want to kick it off at night before you go to bed or before you go to work in the morning. I don't have the kind of patience to sit around and wait for something like that to finish :)

Installing and configuring OpenVPN
==================================

The next step is to install some VPN software. You can install OpenVPN with the following command:

    sudo apt-get install openvpn

Now you'll want to get access to a VPN server in a geographically beneficial area. I've had good results with [PrivateTunnel](https://www.privatetunnel.com). They're cheap, and they have servers in San Jose, Chicago, London, Zurich, and Montreal. Once you choose a server location, you can download its related configuration file. Copy this file to the Raspberry Pi, and save it as `/etc/openvpn/server.conf`.

You'll want to make a couple of edits to this file. So open it with `nano`:

    sudo nano /etc/openvpn/server.conf

Right before the first certificate add the line:

    redirect-gateway

and further down in the file, change the line:

    dev tun

to:

    dev tun0

Save this file, then restart OpenVPN with the command:

    sudo /etc/init.d/openvpn restart

Configuring iptables
====================

Now that you have VPN software set up, the next step is to turn the Pi into a router. You can do this using the Linux utility, [`iptables`](http://wiki.debian.org/iptables). Download [this file](/share/iptables.test.rules) and save it on your Raspberry Pi as `/etc/iptables.test.rules`. Load its rules using the command:

    sudo iptables-restore < /etc/iptables.test.rules

This is the way you usually test iptables rules. We know that these work, so go ahead and save them into your permanent config file with the command:

    sudo iptables-save > /etc/iptables.up.rules

We want these rules to be loaded every time the Pi boots, so create a new file:

    sudo nano /etc/network/if-pre-up.d/iptables

and add these lines to it:

    #!/bin/bash
    /sbin/iptables-restore < /etc/iptables.up.rules

Save the file and then make it executable:

    chmod +x /etc/network/if-pre-up.d/iptables

Enable IP forwarding
====================

Finally, we need to enable IP forwarding by editing one more config file. Open up the file:

    sudo nano /etc/sysctl.conf

and uncomment the line:

    net.ipv4.ip_forward = 1

Now reboot your Raspberry Pi with the command:

    sudo reboot

Testing
=======

If everything was done correctly, you should now be able to use the Raspberry Pi as a VPN gateway. On another computer on the same local network, visit [WhatIsMyIPAddress.com](http://whatismyipaddress.com/). Note your current IP address and physical location on the map.

Now, change your computer's router to be the Raspberry Pi's IP address on the local network. If you don't know it's address, you can find it by running the command:

    ifconfig

on the Pi. I'm on a Mac and my Pi's IP address is 10.0.1.22, so my network config looks like this:

![Network Preferences](/images/network-config.png)

If you're on Windows I think "Router" is called "Default Gateway". Now, reload WhatIsMyIPAddress in your browser. You should now see the IP address of your VPN and its location reflected on the map. You're geospoofing!

Now all you have to do is set the router (or gateway) on your closed devices like AppleTV and Xbox 360 to the Raspberry Pi's IP address and you can access content available only in your VPN's location.

Using the gateway selectively
=============================

PrivateTunnel is priced relatively easily, but if you're doing things like streaming video, it's really easy to eat up your data transfer allotment very quickly. Luckily many services use only a single authentication request to determine your location. If you find this to be the case with your service, you can edit your OpenVPN configuration to only send requests to certain IP addresses through the VPN instead of all of them.

To do that, open up the config file:

    sudo nano /etc/openvpn/server.conf

Comment out the line:

    #redirect-gateway

and right below it add these lines:

    # Ignore routes given to us by OpenVPN Server:
    route-nopull
    # Route authentication IP through VPN:
    route 184.72.247.194 255.255.255.255

Now restart OpenVPN

    sudo /etc/init.d/openvpn restart

In this example, I've used the IP address of another IP address checking site, [myipaddress.com](http://myipaddress.com). If you've set everything up correctly, you should be able to reload WhatIsMyIPAddress.com and see your actual IP address, but load myipaddress.com and see the VPN's IP address. Once you get this working, you can use the route command to send requests to any IP addresses you want through the VPN!