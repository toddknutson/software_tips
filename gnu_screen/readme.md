# How to use GNU Screen on MSI systems

Todd Knutson  
2020-03-19  



## Introduction

When connecting to remote systems using `ssh`, sometimes the connection can fail or you many need to shutdown your computer and reconnect later. Using GNU Screen will (1) allow your remote session to continue running even if your connection is broken, and (2) will allow you to reconnect to your "still running" terminal session later.


This is how I do it. I am not a networking expert, so there might be better or more useful ways of accomplishing the same goal.

NOTE: I am using some special flags in my `ssh` commands (e.g. `-Y -A -t -X -C`) or my `srun` commands (e.g. `--x11`) to allow for X11 forwarding (you may want or not need these flags?). 

## Connect to UMN network via VPN

To use MSI systems, you'll need to be on campus or connected to the UMN network using the VPN (split tunnel is fine). Below is a link to information about setting up a VPN connection from UMN OIT. The "AnyConnect" software method seems to work well.

* [https://it.umn.edu/service-details/virtual-private-network-vpn](https://it.umn.edu/service-details/virtual-private-network-vpn)



## Connect to MSI HPC login node

Replace `USERNAME` with your MSI username.

```
ssh -Y -A USERNAME@mangi.msi.umn.edu
```



Running the above command will direct your connection to one of multiple possible HPC login hosts automatically (`ln0001`, `ln0002`, etc. on mesabi; or `ln1001` or `ln1002` on mangi). We need to remember which exact hostname was used for our connection. Running the `hostname` command will tell us.

```
hostname
# ln1001
```



## Start a GNU Screen session

After connecting to the MSI login node, start a new GNU Screen session and provide the session with a descriptive name. I tend to name the session the current date with a letter suffix (e.g. `2020-03-19a`).

```
screen -S 2020-03-19a
```

This will clear your terminal window and you are now running inside a GNU Screen session. However, you're still only connected to the MSI login node.



* Do any work as usual on the HPC nodes, including launching batch jobs, etc.
* Or you can start an interactive job:

	```	
	srun --pty --x11 --nodes=1 --ntasks-per-node=1 --tmp=16G --partition=interactive --mem=8gb --cpus-per-task=1 --time=1:00:00 bash -i
	```


## Reconnect to your terminal session

* Close your "broken connection" terminal window/tab in your Terminal.app or iTerm2.app
* Open a new terminal window/tab
* Remember your original MSI HPC login (e.g. `ln1001` on `mangi`) node hostname and directly connect to it using steps below:

	```
	ssh -Y -A USERNAME@mangi.msi.umn.edu
	
	# If you connect to a different login node (e.g. ln1002, instead of ln1001), ssh to the original node:
	ssh ln1001
	```

* List the GNU Screen sessions currently running on that host:
	
	```
	screen -ls
	# There is a screen on:
	# 	27223.2020-03-19a	(Detached)
	# 1 Socket in /var/run/screen/S-knut0297.
	```

* If you have multiple screen sessions running, find the name of the session that you want to re-attach (e.g. `2020-03-19a`).
* To reconnect to a screen session, replace SESSIONNAME below with the full session name including the prefixed numbers (e.g. `27223.2020-03-19a`):

	```
	screen -rd SESSIONNAME
	```

* You should now be reconnected to your "still running" terminal session on the HPC node.





## Delete all screen sessions

You can delete all screen sessions from the login host by running the following command on a MSI login node (e.g. `login01`, `login02`, or `login03`). Note: you can have GNU Screen sessions on any of the three nodes. Use `screen -ls` to see what sessions are still running.

```
screen -ls | cut -d. -f1 | grep -v "screens\|Sockets" | awk '{print $1}' | xargs -I{} screen -X -S {} quit
```

That is a lot to remember, so I created an alias by adding the following to my `~/.bashrc` file. Then I simply run `screenclean` to wipe out any old sessions.

```
alias screenclean='screen -ls | cut -d. -f1 | grep -v "screens\|Sockets" | awk '{print $1}' | xargs -I{} screen -X -S {} quit'
```





## References

[https://www.gnu.org/software/screen/](https://www.gnu.org/software/screen/)

[https://wiki.msi.umn.edu/display/TS/IRC+and+Screen](https://wiki.msi.umn.edu/display/TS/IRC+and+Screen)

[https://wiki.msi.umn.edu/pages/viewpage.action?pageId=2853359](https://wiki.msi.umn.edu/pages/viewpage.action?pageId=2853359)

