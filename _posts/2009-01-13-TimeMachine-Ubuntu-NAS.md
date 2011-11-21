---
layout: posts
title: TimeMachine + Ubuntu NAS
---
So after a few months of hem-hawing around, I finally implemented a respectable backup solution for my Mac.  It's getting old enough (almost 4 years) that I'm starting to worry about random hardware failures, so having a reliable backup is very important.

At home, I have a computer running Ubuntu Linux that I use as a file/media/print server.  It has four 250 GB drives in a RAID5 configuration.  Since RAID5 can be rebuilt if a drive dies, I feel like this is a pretty safe place to store backups, although eventually I hope to have an offsite backup (ex: Amazon S3) as well.

A while back a little command that would let TimeMachine use network drive started floating around the Internet:

    defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1

I already had SAMBA set up, but I had some problems, so I ended up following this tutorial — which I highly recommend — and setting up netatalk so I could share the volume over AFP.  Looking back, I don't think SAMBA was the problem, I think the issue was with creating the initial backup disk image. I had to make the image locally and copy it over, as is explained in the troubleshooting section, but after that everything worked perfectly.