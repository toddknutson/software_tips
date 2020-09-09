# Software tips and tricks

This repo contains various scripts or "help" files that might be useful for setting up software configurations or basic usage examples. Let me know if you see any errors or have better ideas!

The local repo is located here:

    /home/lmnp/knut0297/software/tips


## Rclone

`rclone` is like `rsync` for transferring data between cloud platforms (e.g. panasas, ceph, Google Drive, etc.).


[Rclone example](rclone/readme.md)


## Terminal multiplexers (GNU Screen or tmux) 

I use *GNU Screen* or *tmux* to manage my ssh connections to MSI. This way, if my network connection breaks, or I need to bring my laptop to a meeting, my MSI interactive session can continue running in the background. I can even reconnect to that session. Screen is fairly simple to get running, but tmux is more powerful and worth the extra work setting up. 

* [GNU Screen example](gnu_screen/readme.md)  
* [tmux example](tmux/readme.md)


## R Markdown

I like to create reports using R Markdown syntax. These files can be rendered using R and other software on MSI systems. 

[R Markdown example](rmarkdown/readme.md)





## SSH Keys

This is how I set up `ssh` keys to connect to MSI systems.

[ssh keys example](ssh_keys/readme.md)





