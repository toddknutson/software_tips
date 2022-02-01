

# How to use Rclone on MSI systems.

Todd Knutson   
2020-05-22    
last update: 2020-12-10


## Introduction

Rclone is a data transfer tool that moves files from `source` to `destination`, where these locations can be your local drive, or one of many different cloud storage providers (e.g. Google Drive, Amazon S3, Tier2-Ceph, or many others). For example, I use `rclone` on MSI systems to move data from Tier1 (Panasas) to Tier2-Ceph or UMN's Google Drive account. 


## Software 

MSI has an `rclone` module installed on their system. Alternatively, you can load Todd's `rclone` module (which is newer and contains some recently added advanced features). 

	MODULEPATH=/home/lmnp/knut0297/software/modulesfiles module load rclone/1.52.2


## UMN Google Drive

### Configure the remote connection

* Create (or modify) an rclone config file. This process only needs to be done once. The resulting config file is stored in your home directory.

		rclone config
		cat $HOME/.config/rclone/rclone.conf



* `rclone config` ANSWERS:

	* n (new remote connection)
	* name> todds_umn_gdrive (provide it a "remote" name)
	* storage> 13 (google drive)
	* client_id> (leave blank, or follow the steps below)
	* client_secret> (leave blank, or follow the steps below)
	* scope> 1 (Full access all files, excluding Application Data Folder)
	* root_folder_id> (leave blank)
	* service_account_file> (leave blank)
	* Edit advanced config> No
	* Remote config> No (headless machine)
	* Please go to the following link> (copy/paste link into browser, authorize google drive to use UMN account, copy the verification code provided by Google, paste back into terminal prompt)
	* Configure this as a team drive> No (not team drive)
	* y (Yes this is OK)
	* q (quit)



#### How to generate personal `client_id` and `client_secret` values

If you get any "rate limit exceeded" errors when using the `rclone` config above, you might want to create your own personal client id to use with `rclone`. This is pretty simple to set-up following the directions below:

Rclone documentation: [https://rclone.org/drive/#making-your-own-client-id](https://rclone.org/drive/#making-your-own-client-id). 

For example:

* Access the Google Cloud Platform website (using any of your Google accounts, choose a personal Google account if the Google Cloud Platform is not available for your UMN acct.)
* Agree to the terms and select country
* Click the "Create Project" button
    * Provide a project name (e.g. "Todds-Google-rclone")
    * Organization (choose "No organization")
    * Click Create button
* Click the "+ Enable APIs and Services" button near the top of page
    * In the API Library search box, search for "Google Drive API"
    * Select this API and click "Enable"
* In the left-hand sidebar of the page, choose the "Credentials" tab 
    * Near the top of the page, click "Create Cedentials"
    * Choose "OAuth client ID"
    * Click "Configure Consent Screen" button
    * Choose "External", click "Create" button
    * Enter an App name (e.g. rclone) and enter your email address in two locations
    * Click "Save and Continue"
* Choose the "Credentials" tab on the left side bar
* Click "Create Credentials" button again at the top of the screen
* Choose "OAuth client id"
* Choose Application type: "Desktop app"
* Choose a name (default name is fine)
* Click the "Create" button
* Copy/paste/save the provided "client_id" and "client_secret" values and use them when creating an rclone config (see above section)
	    
	    


### Push a file from panasas to google drive




* Upload entire directory called `data` to google drive (inside google drive folders called "Work_MSI/Projects" -- both dirs do not need to already be created in google drive).

		rclone copy -v data todds_umn_gdrive:Work_MSI/Projects/data

* Upload entire contents of a directory called "data" to google drive (inside google drive folders "Work_MSI/Projects")

		rclone copy -v data todds_umn_gdrive:Work_MSI/Projects

* Copy a single file located at the relative path "data/file.txt" on panasas to a dir on google drive called Projects.

		rclone copy -v data/file.txt todds_umn_gdrive:Work_MSI/Projects




### Copy files from Google Drive to Panasas



* Copy entire folder called "data" from google drive to a new dir called "data" in my current working dir on panasas.

		rclone copy -v todds_umn_gdrive:Work_MSI/Projects/data ./data

* Copy entire contents of a folder called "data" on google drive to my current working dir on panasas.

		rclone copy -v todds_umn_gdrive:Work_MSI/Projects/data .

* Copy a single file located at the full path "Work_MSI/Projects/file.txt" on google drive to my current working dir on panasas.

		rclone copy -v todds_umn_gdrive:Work_MSI/Projects/file.txt .






## UMN Tier2 (CEPH)


### Configure the remote connection


* Create (or modify) an rclone config file. This process only needs to be done once. The resulting config file is stored in your home directory. 
**NOTE: you can get your access_keys from a the bottom of this website (you must be logged in). [https://www.msi.umn.edu/content/second-tier-storage](https://www.msi.umn.edu/content/second-tier-storage)**. You may also be able to get these values by running: `s3info -u $USER`

		rclone config
		cat $HOME/.config/rclone/rclone.conf


* `rclone config` ANSWERS:
	* n (new remote connection)
	* name> todds_umn_ceph (provide it a "remote" name)
	* Storage> 4 (Amazon S3 Compliant Storage Provider (AWS, Alibaba, Ceph, Digital Ocean, Dreamhost, IBM COS, Minio, etc))
	* provider> 3 (Ceph)
	* env_auth> 1 (Enter AWS credentials in the next step)
	* access_key_id> (copy/paste "access_key_id" from msi.umn.edu)
	* secret_access_key> (copy/paste "secret_access_key" from msi.umn.edu)
	* region> 1 (Use this if unsure. Will use v4 signatures and an empty region.)
	* endpoint> s3.msi.umn.edu (Endpoint for S3 API)
	* location_constraint> (leave blank)
	* acl> 1 ("private")
	* server_side_encryption> 1 (none)
	* sse_kms_key_id> 1 (none)
	* n (no, do not edit advanced config)
	* y (yes, this is OK)
	* q (quit)





### Push a file from panasas to ceph


* Upload entire directory called "data" to ceph (inside ceph "directories" called Bucket_Work_MSI/Projects)

		rclone copy -v data todds_umn_ceph:Bucket_Work_MSI/Projects/data

* Upload entire contents of directory called "data" to ceph (inside ceph "bucket/directories" called Bucket_Work_MSI/Projects)

		rclone copy -v data todds_umn_ceph:Bucket_Work_MSI/Projects

* Copy a single file located at the relative path "data/file.txt" on panasas to a dir on ceph called "Bucket_Work_MSI/Projects".

		rclone copy -v data/file.txt todds_umn_ceph:Bucket_Work_MSI/Projects




### Copy files from ceph to panasas


* Copy entire folder called "data" from ceph to a new dir called "data" in my current working dir on panasas

		rclone copy -v todds_umn_ceph:Bucket_Work_MSI/Projects/data ./data

* Copy entire contents of a folder called "data" on ceph to my current working dir on panasas

		rclone copy -v todds_umn_ceph:Bucket_Work_MSI/Projects/data .

* Copy a single file located at the full path "Bucket_Work_MSI/Projects/file.txt" on ceph to my current working dir on panasas

		rclone copy -v todds_umn_ceph:Bucket_Work_MSI/Projects/file.txt .






## Gene Expression Omnibus (GEO)

Uploading data to the [GEO](https://www.ncbi.nlm.nih.gov/geo) database can be tedious. Rclone can connect to the public FTP server and manage the data transfer. 

### Configure the remote connection


* Create (or modify) an rclone config file. This process only needs to be done once. The resulting config file is stored in your home directory. **NOTE: the HOST, USERNAME, and PASSWORD are the same for everyone (public connection).** But where you transfer the files will be specific to each user. After logging into the GEO website, find your personal upload directory name here: [https://www.ncbi.nlm.nih.gov/geo/info/submissionftp.html](https://www.ncbi.nlm.nih.gov/geo/info/submissionftp.html).

		rclone config
		cat $HOME/.config/rclone/rclone.conf


* `rclone config` ANSWERS:
	* n (new remote connection)
	* name> todds_geo (provide it a "remote" name)
	* Storage> ftp (FTP Connection)
	* host> ftp-private.ncbi.nlm.nih.gov
	* user> geoftp
	* port> (Leave blank for default, press Enter)
	* FTP password> y (Yes type in my own password)
	* password> rebUzyi1 (Enter the password)
	* password> rebUzyi1 (Confirm the password)
	* tls> (Leave blank for default, press Enter)
	* explicit_tls> (Leave blank for default, press Enter)
	* n (no, do not edit advanced config)
	* y (yes, this is OK)
	* q (quit)




### Push a file from panasas to the GEO FTP server

* Copy a single file (or a symlinked file) located at the relative path "data/file.txt" on panasas to a directory on GEO FTP called "uploads/toddknutson_ABCDEFGHIJKLMNOP".

		rclone copy -v --copy-links data/file.txt todds_geo:uploads/toddknutson_ABCDEFGHIJKLMNOP




# Examples

### How to push one really large file (1 TB) from panasas to ceph:

* This will disable the automatic checksum check that occurs by rclone -- but instead, you can verify it by size (see next command).

		rclone copy -v --s3-disable-checksum --s3-chunk-size 1G --s3-upload-concurrency 10 -c --ignore-checksum very_large_file.tar.gz todds_umn_ceph:Bucket_Work_MSI/Projects

* A quick check that uses the --size-only flag, otherwise it checks the md5sum hash

		rclone check -vv --size-only --one-way very_large_file.tar.gz todds_umn_ceph:Bucket_Work_MSI/Projects


* Copy files directly from one "remote" to another "remote." For example, copy "file.txt" on ceph to google drive (skipping panasas all together)

		rclone copy -v todds_umn_ceph:Bucket_Work_MSI/Projects/file.txt todds_umn_gdrive:Work_MSI/Projects







# Useful commands


* Below, replace "remote" with your remote config name (e.g. todds_umn_gdrive, or todds_umn_ceph)

		rclone --help

* List all your remote locations (google drive, ceph), show all flag options, and list only directories.

		rclone listremotes
	
		rclone help flags
		rclone lsd remote: # (e.g. rclone lsd todds_umn_gdrive: )





