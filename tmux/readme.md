# How to use tmux on MSI systems

Todd Knutson  
2020-09-09



## Introduction

When connecting to remote systems using `ssh`, sometimes the connection can fail or you many need to shutdown your computer and reconnect later. Using tmux will (1) allow your remote session to continue running even if your connection is broken, and (2) will allow you to reconnect to your "still running" terminal session later. In addition, tmux has many other features that GNU Screen does not easily offer. Most importantly, reconnecting to a tmux session will update your environment variables (e.g. `DISPLAY`, `SSH_AUTH_SOCK`) in new windows. This makes reconnecting to X11 windows and using ssh key forwarding work after reconnecting.



### Disclaimer 


This is how I do it. I am not a networking expert, so there might be better or more useful ways of accomplishing the same goal. Also, this example is focused on connecting a MacBook to MSI's linux servers. Using a Windows computer might require some differences. 


I am using some special flags in my `ssh` commands (e.g. `-Y -A -t -X -C`) or my `qsub` commands (e.g. `-X -v DISPLAY`) to allow for X11 forwarding (you may want or not need these flags?). 


## Connect to UMN network via VPN

To use MSI systems, you'll need to be on campus or connected to the UMN network using the VPN (split tunnel is fine). Below is a link to information about setting up a VPN connection from UMN OIT. The "AnyConnect" software method seems to work well.

* [https://it.umn.edu/service-details/virtual-private-network-vpn](https://it.umn.edu/service-details/virtual-private-network-vpn)



## Connect to MSI login node

Replace `USERNAME` with your MSI username.

```
ssh -Y -A USERNAME@login.msi.umn.edu
```




## Connect to HPC login node (`mesabi` or `mangi`)

* Run an `ssh` command to connect to an HPC node:

	```
	ssh -t -X -C mesabi
	```


Running the above command will direct your connection to one of multiple possible login hosts automatically (`ln0001`, `ln0002`, etc. on mesabi; or `ln1001` or `ln1002` on mangi). We need to remember which exact hostname was used for our connection. Running the `hostname` command will tell us.

```
hostname
# ln0001
```






## Load the `tmux` software

After connecting to the MSI HPC login node, we need to load the `tmux` software. MSI has an old tmux version (1.8) installed at `/bin/tmux`. I have installed the latest version (3.1b) as a personal module -- but you can load my version or install it yourself. Loading my version will automatically load a dependency library (libevent). 


```
module load /home/lmnp/knut0297/software/modulesfiles/tmux/3.1b_centos6
```


If you don't want to access the software via the modules system, you can simply run the commands below, or add them to your `~/.bashrc` file so tmux is available automatically when you start any terminal session.


```
export PATH="/home/lmnp/knut0297/software/modules/tmux/3.1b_centos6/bin:$PATH"
export LD_LIBRARY_PATH="/home/lmnp/knut0297/software/modules/libevent/2.1.12_centos6/lib:$LD_LIBRARY_PATH"
```


Alternatively, you can install your own version of tmux. This is how I installed it [version 3.1b](https://github.umn.edu/knut0297/modules_install_notes/blob/main/tmux_3.1b_centos6_install_notes.sh).




## Start a tmux session


Start a new session and provide the session with a descriptive name. I tend to name the session the name of the group I'm working with (e.g. `lmnp`) or the current date (e.g. `2020-09-09`).

```
tmux new -s lmnp
```

This will clear your terminal window and you are now running inside a tmux session. 

* Do any work as usual on the HPC nodes, including launching batch jobs, etc.
* Or you can start an interactive job:

	```
	qsub -I -X -v DISPLAY -q interactive -l walltime=1:00:00,nodes=1:ppn=1,mem=4GB 
	```


## Navigating the `tmux` interface

Tmux uses a mechanism called "key bindings" to navigate or manipulate the program through a variety of commands. All tmux commands are initiated with a `PREFIX` keystroke. The default tmux `PREFIX` is `C-b` (i.e. holding down the `Ctrl` key and pressing the letter `b`). After you initiate the `PREFIX`, then you can type other tmux commands. 

* To see a list of all possible commands, type `PREFIX ?`.
	* Verbosely: hold down the `Ctrl` key and press the letter `b`. Release keys. Then type the question mark by holding down `Shift` and `?` keys. Release keys. Review commands and press `q` to escape.
* To create new windows (e.g. tabs), type `PREFIX c`.
* Switch between windows (e.g. tabs), type `PREFIX` followed by the window number (e.g `2`)
* See all available sessions and windows, type `PREFIX w`. Use the arrow keys and return key to select a different window.
* Exit a window (i.e. kill the window, not the session), type `PREFIX` `&`
* Split a window into two vertical panes, type `PREFIX` `%`. Then you can switch between each pane by typing `PREFIX` and the left `←` or right arrow key `→`.




### Great shortcuts and tricks

* [tmuxcheatsheet](https://tmuxcheatsheet.com/?q=&hPP=100&idx=tmux_cheats&p=0&is_v=1)
* [tmux-cheats](https://gist.github.com/Starefossen/5955406) (note: this page uses a `C-a` `PREFIX` key binding, so make sure you use your `PREFIX`)




## Disconnect from your tmux session


* If you lose your network connection for any reason, your session is still be running on MSI. Thus, disconnecting from your tmux session could occur by accident (e.g. VPN timeout). 
* Alternatively, you can manually disconnect/detach by typing: `PREFIX` `d`



## Reconnect to your tmux session

If you lose your internet connection, you can reconnect/reattach to your "still running" session on the HPC node. 

* Close your "broken connection" terminal window/tab in your Terminal.app or iTerm2.app
* Open a new terminal window/tab
* Connect to MSI:

	```
	ssh -Y -A USERNAME@login.msi.umn.edu
	```
	
* Remember your original MSI HPC login (e.g. `ln0001` on `mesabi`) node hostname and directly connect to it using the hostname format below:

	```
	ssh in-ln0001.mesabi.msi.umn.edu
	```

* Reattach the tmux session currently running on that host:
	
	```
	# module load tmux software as described above, if necessary
	tmux attach
	```

* If you had multiple sessions/windows running, you can browse any of them by typing: `PREFIX` `w`. Use arrow keys and return key to select.




### Restore important environment variables

When you connect to a server (e.g. MSI) using `ssh-agent` forwarding and/or X11 enabled, certain environment variables get set, including `DISPLAY` and `SSH_AUTH_SOCK`. These variables contain information that is needed to properly display an X11 window (e.g. for interactive R graphics) or access keys provided by the `ssh-agent` (e.g. push/pull to github).

If you reattach to an old tmux session, these environment variables are NOT updated with the latest correct values in your _old windows_. However, any _new windows_ that get created will inherit the latest correct values and X11/ssh keys should work. 

However, you can manually update these environment variables inside the _old windows_ by running the following commands so they contain the latest values:

```
eval $(tmux showenv -s SSH_CONNECTION); eval $(tmux showenv -s SSH_AUTH_SOCK); eval $(tmux showenv -s DISPLAY)
```


#### Special note for R users

If you reattach to a session running an R console, your X11 `DISPLAY` will be old and X11 windows will not work properly. I have not been able to solve this problem for an R console that was running on a compute node. However, the procedure below works for R consoles running on Stratus:

* Open a new tmux window (tab). This will inherit the proper `DISPLAY` variable when printed in bash: `echo $DISPLAY`. 
* Copy the variable's value (e.g. `localhost:13.0`)
* Go back to your _old window_ still running an R console. Explicitly set the `DISPLAY` variable in that console using the R function: `Sys.setenv(DISPLAY = "localhost:13.0")`
* Test your X11 window by running creating a simple plot, `plot(1:10, 1:10)`, which should open the X11 window. 
* If that does not work -- Quit your Terminal.app/iTerm2.app and repeat the steps above (I'm not sure why it works when repeated...?)




## Delete all tmux sessions

You can delete all tmux sessions from the HPC login host by running the following command:

```
tmux kill-session
```

## Best practices

When using `tmux`, all of MSI's best practices still apply. In particular, you should not use any login nodes (`login.msi.umn.edu` or `mesabi/mangi.msi.umn.edu`) to run CPU or memory intensive tasks. Your `tmux` sessions will persist until you kill them (or until the login nodes are rebooted on maintenance day).

When using `tmux` on a Stratus VM, you are always connected to your full compute resources. In this case, leaving your active, CPU-intensive, processes running in a `tmux` session over long timeframes makes the most sense.



### Ideal use-cases for `tmux` on MSI:

* Starting an interactive PBS job on a compute node. This gives you the benefit of using compute resources and being able to detach/attach to your active session. Like any other interactive job, request only the walltime needed to complete your tasks. Tmux will keep your session alive, but when your PBS job walltime ends, the prompt will return to the login node.
* Launching and monitoring batch PBS jobs.
* Browsing the filesystem.
* Viewing or editing scripts (split panes are great for this).
* Pushing/pulling from GitHub.
* Using multiple terminal windows at one time (e.g. for viewing many different filesystem locations) without having to ssh connect for each window.




## `.tmux.conf` Advanced (but very helpful) 


Tmux can be heavily modified using a configuration text file, saved as `~/.tmux.conf` in your home directory (e.g. on MSI's primary panasas storage location). I have provided a bare-bones example in this repo with some changes that I find helpful. 

For example, the scrolling behavior can be improved, tab bar colors can be changed, and window numbering can be altered. Feel free to copy/paste this example into your home directory and use it with tmux!

* Example file provided here: [`~/.tmux.conf`](./.tmux.conf)






## References

[LinkedIn learning videos (free for UMN)](https://www.linkedin.com/learning/linux-multitasking-at-the-command-line/introduction-to-tmux?resume=false&u=42740356)

[https://leanpub.com/the-tao-of-tmux/read](https://leanpub.com/the-tao-of-tmux/read)

[https://readthedocs.org/projects/tmuxguide/downloads/pdf/latest/](https://readthedocs.org/projects/tmuxguide/downloads/pdf/latest/)

[https://thoughtbot.com/blog/a-tmux-crash-course](https://thoughtbot.com/blog/a-tmux-crash-course)

[https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)

[https://thoughtbot.com/upcase/tmux](https://thoughtbot.com/upcase/tmux)

[https://phoenixnap.com/kb/tmux-tutorial-install-commands](https://phoenixnap.com/kb/tmux-tutorial-install-commands)
