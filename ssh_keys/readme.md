# How to use SSH Keys on MSI systems

Todd Knutson  
2020-07-18  



## Introduction

When connecting to remote systems using an `ssh` key, instead of a password, is more secure and makes connecting easier after set up. Everything in this document was adapted from various online sources. Thus, the content here will be very specific to how I set up my keys to work with MSI systems.


### What computer are you talking about?

When working on multiple computers/hosts, it can be confusing to know where these instructions are designed to be entered. The following will precede each command to indicate which computer the commands should be entered:


Below indicates the command prompt for your local laptop Mac:

```
(local-Mac)$ 
```

Below indicates the command prompt for a MSI login node:

```
(login01.msi.umn.edu)$ 
```




## Connect to UMN network via VPN

To use MSI systems, you'll need to be on campus or connected to the UMN network using the VPN (split tunnel is fine). Below is a link to information about setting up a VPN connection from UMN OIT. The "AnyConnect" software method seems to work well.

* [https://it.umn.edu/service-details/virtual-private-network-vpn](https://it.umn.edu/service-details/virtual-private-network-vpn)






## Create a key-pair

This only needs to be done once -- alternatively, you can use an existing key-pair that you control. I have created a single key-pair that is stored on my local Mac computer (in the `~/.ssh` directory) to access multiple servers. I like to name my key files by combining the default name (id_rsa) with a unique value (mykey1): "id_rsa_mykey1". This allows me to keep track of various keys if I ever need to create new ones or use multiple keys.


* Create a new key-pair by starting the interactive program: `ssh-keygen`:

	```
	(local-Mac)$ cd $HOME
	(local-Mac)$ ssh-keygen -b 4096 -f $HOME/.ssh/id_rsa_mykey1	
	```
	
	
* Enter passphrase: Use a long passphrase (it can contain spaces and ideally would not use standard dictionary words). We'll set this up so you will NOT need to type the passphrase every time you ssh to a host. If you're using a Mac, we'll add your passphrase to your macOS-Keychain, so you will not need to type the passphrase after reboots either!


	```
	(local-Mac)$ XXXXXXXXXXXXXXXXXXXXXXXXXXX
	```

* Add a comment to the key (which will help you find it later). I just use the key name:

	```
	(local-Mac)$ ssh-keygen -f $HOME/.ssh/id_rsa_mykey1 -o -c -C "id_rsa_mykey1"
	```

## Copy your public key to MSI login host

Basically, we need to add our public key to the `$HOME/.ssh/authorized_keys` file that is located on the MSI server in your home .ssh directory. There are a multiple ways to do this. Below are two options:

* Copy/paste the text from your public key on your local Mac, to the authorized_keys on the host. 
	
	```
	# On your local Mac: 
	# print the public key using cat function
	# highlight text
	# copy the entire line to your clipboard
	(local-Mac)$ cat $HOME/.ssh/id_rsa_mykey1.pub
	
	
	# Log into MSI host
	(local-Mac)$ ssh USER@login.msi.umn.edu
	
	# Open the authorized keys file
	(login01.msi.umn.edu)$ nano $HOME/.ssh/authorized_keys
	
	# Paste your clipboard text at the end of this file. 
	# Save (Ctrl - X)

	```

* Or use the ssh copy tool:

	```
	(local-Mac)$ ssh-copy-id -i $HOME/.ssh/id_rsa_mykey1 USER@login.msi.umn.edu
	
	```







## Optimize your `ssh` connection 

You can specify additional `ssh` settings for your connection in two ways: (1) key-value pairs in a `~/.ssh/config` file, or (2) list flags on the command line




* Create an ssh config file
	
	```
	(local-Mac)$ nano ~/.ssh/config
	```
	
	Copy and paste the following parameters inside this file. Specify the filename of your IdentityFile (i.e. your private key file created above). Then save.
	
	```
	Host *github*
	        ForwardX11 no
	
	Host *
		GatewayPorts no
		StrictHostKeyChecking ask
		ForwardAgent yes # equivalent to -A on command line
		ForwardX11 yes # equivalent to -X on the command line
		ForwardX11Trusted yes # equivalent to -Y on the command line		
		RequestTTY force # equivalent to -t on command line
		ServerAliveInterval 15
		ServerAliveCountMax 28800
		AddKeysToAgent yes
		UseKeychain yes
		IdentityFile ~/.ssh/id_rsa_mykey1 # this is the path to your private key
		NoHostAuthenticationForLocalhost yes
		XAuthLocation /opt/X11/bin/xauth # make sure this is correct on your system
		Compression yes # equivalent to -C on command line
	```
		




* Use flags on the command line (only the essential flags specified)
	
	```
	(local-Mac)$ ssh -i $HOME/.ssh/id_rsa_mykey1 -A -Y USER@login.msi.umn.edu
	```






## Test the connection using your key

* If you did not create an ssh config file that specifies your private key, use the `-i` flag when connecting

	```
	(local-Mac)$ ssh -i $HOME/.ssh/id_rsa_mykey1 USER@login.msi.umn.edu
	```


* If you specified your IdentityFile in your ssh config file (you don't need to specify it again on the command line):
(local-Mac)$ ssh USER@login.msi.umn.edu

	```
	(local-Mac)$ ssh USER@login.msi.umn.edu
	```








## References


[MSI - How to set up ssh keys](https://www.msi.umn.edu/support/faq/how-do-i-setup-ssh-keys)  
[Lean Crew Blog](https://leancrew.com/all-this/2017/02/ssh-keys/)
