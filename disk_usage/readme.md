# How to find disk usage using Krona

Todd Knutson
2021-11-30


## Introduction 

Frequently, I want to find disk usage stats for a directory that includes many small or large files. This can easily be done using the unix command `du`, but is difficult to explore the usage in a easy way. `Krona` uses `du` in the background, but then generates a useful tree diagram HTML file. This allows you to dig into the files and directories, displaying their size and age. A similar tool is available for macOS, called [DaisyDisk](https://daisydiskapp.com). 



## Access the `Krona` software

Unfortunately, this tool is not installed as a system wide module on MSI. However, you can get access in the following ways:
 
* Install `Krona` in your home directory. See the software documentation [here](https://github.com/marbl/Krona/wiki). This is [how I installed the tool](https://github.umn.edu/knut0297org/modules_install_notes/blob/main/krona_2.7.plus42commits.noextrafiles_install_notes.sh)

* Load my personal module:
	
	```
	# Run the following command to load my module
	# This will not change your $MODULEPATH variable
	
	MODULEPATH=/home/lmnp/knut0297/software/modulesfiles module load krona/2.7.plus42commits.noextrafiles
	```


## Usage tips


```
mkdir -p /home/lmnp/knut0297/software/tips/disk_usage
cd /home/lmnp/knut0297/software/tips/disk_usage

MY_BIG_DIR="/home/lmnp/knut0297/software/tips"

ImportDiskUsage.pl $MY_BIG_DIR

# The output file is always named "du.krona.html"
# Change output filename
mv du.krona.html $(basename $MY_BIG_DIR).html
```



Open the HTML file in a web browser and explore!

See an example output files: 

* [./tips.html](./tips.html)
* [http://marbl.github.io/Krona/examples/du.krona.html](http://marbl.github.io/Krona/examples/du.krona.html)





