# How to view PDFs on MSI

Todd Knutson
2021-02-19


## Introduction 

Often times we'd like to view PDFs or other images (e.g. PNG, JPEG) stored on MSI's tier1 Panasas storage (i.e. our home directory). There are many ways to access these image files, including downloading the file to your local computer or transferring it to another storage platform (e.g. ceph, Google Drive, Box, etc.) for viewing or sharing. 

However, if you have X11 forwarding enabled, you can view the PDF directly using a software tool called `mupdf-x11`. 


## Access the `mupdf-x11` software

Unfortunately, this tool is not installed as a system wide module on MSI. However, you can get access in the following ways:
 
* Install `mupdfx11` in your home directory. See the software documentation [here](https://www.mupdf.com/docs/building.html). This is [how I compiled the tool](https://github.umn.edu/knut0297org/modules_install_notes/blob/main/mupdf_1.18_install_notes.sh) (please note, that I created a symlink `mupdf-x11` --> `mupdf` for easier typing). 
* Load my personal module:
	
	```
	# Run the following command to load my module
	# This will not change your $MODULEPATH variable
	
	MODULEPATH=/home/lmnp/knut0297/software/modulesfiles module load mupdf
	```
* If you want persistent access to my tool, add the following to your `PATH` variable:

	```
	export "PATH=/home/lmnp/knut0297/software/modules/mupdf/1.18/build/bin:$PATH"
	```

## Usage tips

### View a PDF

* Type the following and hit return. 
* An X11 window should open with your file displayed. 
* Close the X11 window displaying your image, or type `CTRL-c` in the terminal to stop viewing.

	```
	mupdf myfile.pdf
	```

### View the manual

* The manual contains a list of "key bindings" that are helpful for zooming or changing the image view. 
* For example, click on the X11 window, and type `SHIFT-z` to fit the image to the current X11 window size. 

	```
	man mupdf
	```



