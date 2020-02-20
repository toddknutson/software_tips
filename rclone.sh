#!/bin/bash

# MSI version:
module load rclone/1.38
# Or you can use Todd's version (slightly newer) -- I think some advanced options
# are only available in the newer version.:
# module load /home/lmnp/knut0297/software/modulesfiles/rclone/1.46


#######################################################################
# UMN GOOGLE DRIVE
#######################################################################

# ---------------------------------------------------------------------
# Make rclone config file (only needs to be done once)
# ---------------------------------------------------------------------

# This will create or modify a config file located here:
cat $HOME/.config/rclone/rclone.conf


rclone config
# ANSWERS:
# n (new remote connection)
# todds_umn_gdrive (provide it a "remote" name)
# 9 (google drive)
# <leave blank>
# <leave blank>
# n (copy/paste link into browser, authorize google drive to use UMN account)
# n (not team drive)
# y (yes this is OK)
# q (quit)



# ---------------------------------------------------------------------
# Push a file from panasas to google drive
# ---------------------------------------------------------------------



# Upload entire directory called "data" to google drive (inside google drive folders 
# called "Work_MSI/Projects" -- both dirs do not need to already be created in google drive)
rclone copy -v data todds_umn_gdrive:Work_MSI/Projects/data

# Upload entire contents of a directory called "data" to google drive (inside google drive 
# folders "Work_MSI/Projects")
rclone copy -v data todds_umn_gdrive:Work_MSI/Projects

# Copy a single file located at the relative path "data/file.txt" on panasas to a dir on google drive called Projects.
rclone copy -v data/file.txt todds_umn_gdrive:Work_MSI/Projects



# ---------------------------------------------------------------------
# Copy files from google drive to panasas
# ---------------------------------------------------------------------


# Copy entire folder called "data" from google drive to a new dir called "data" in my current working dir on panasas
rclone copy -v todds_umn_gdrive:Work_MSI/Projects/data ./data

# Copy entire contents of a folder called "data" on google drive to my current working dir on panasas
rclone copy -v todds_umn_gdrive:Work_MSI/Projects/data .

# Copy a single file located at the full path "Work_MSI/Projects/file.txt" on google drive to my current working dir on panasas
rclone copy -v todds_umn_gdrive:Work_MSI/Projects/file.txt .





#######################################################################
# UMN TIER2 (CEPH)
#######################################################################


# ---------------------------------------------------------------------
# Make rclone config file (only needs to be done once)
# ---------------------------------------------------------------------

# NOTE: you can get your access_keys from a the bottom of this website (you must be logged in).
# https://www.msi.umn.edu/content/second-tier-storage

rclone config
# ANSWERS:
# n (new remote connection)
# todds_umn_ceph (provide it a "remote" name)
# 4 (Amazon S3 Compliant Storage Provider (AWS, Alibaba, Ceph, Digital Ocean, Dreamhost, IBM COS, Minio, etc))
# 3 (Ceph)
# 1 (Enter AWS credentials in the next step)
# (copy/paste "access_key_id" from msi.umn.edu)
# (copy/paste "secret_access_key" from msi.umn.edu)
# 1 (Use this if unsure. Will use v4 signatures and an empty region.)
# s3.msi.umn.edu (Endpoint for S3 API)
# <leave blank -- press enter> (location_constraint)
# 1 ("private")
# n (no, do not edit advanced config)
# y (yes, this is OK)
# q (quit)




# ---------------------------------------------------------------------
# Push a file from panasas to ceph
# ---------------------------------------------------------------------

# Upload entire directory called "data" to ceph (inside ceph "directories" called Bucket_Work_MSI/Projects)
rclone copy -v data todds_umn_ceph:Bucket_Work_MSI/Projects/data

# Upload entire contents of directory called "data" to ceph (inside ceph "bucket/directories" called Bucket_Work_MSI/Projects)
rclone copy -v data todds_umn_ceph:Bucket_Work_MSI/Projects

# Copy a single file located at the relative path "data/file.txt" on panasas to a dir on ceph called "Bucket_Work_MSI/Projects".
rclone copy -v data/file.txt todds_umn_ceph:Bucket_Work_MSI/Projects



# ---------------------------------------------------------------------
# Copy files from ceph to panasas
# ---------------------------------------------------------------------

# Copy entire folder called "data" from ceph to a new dir called "data" in my current working dir on panasas
rclone copy -v todds_umn_ceph:Bucket_Work_MSI/Projects/data ./data

# Copy entire contents of a folder called "data" on ceph to my current working dir on panasas
rclone copy -v todds_umn_ceph:Bucket_Work_MSI/Projects/data .

# Copy a single file located at the full path "Bucket_Work_MSI/Projects/file.txt" on ceph to my current working dir on panasas
rclone copy -v todds_umn_ceph:Bucket_Work_MSI/Projects/file.txt .





#######################################################################
# MORE EXAMPLES
#######################################################################

# How to push one really large file (1 TB) from panasas to ceph:
# This will disable the automatic checksum check that occurs by rclone -- but instead, you can verify it by size (see next command).
rclone copy -v --s3-disable-checksum --s3-chunk-size 1G --s3-upload-concurrency 10 -c --ignore-checksum very_large_file.tar.gz todds_umn_ceph:Bucket_Work_MSI/Projects

# A quick check that uses the --size-only flag, otherwise it checks the md5sum hash
rclone check -vv --size-only --one-way very_large_file.tar.gz todds_umn_ceph:Bucket_Work_MSI/Projects




#######################################################################
# Useful commands
#######################################################################

# Below, replace "remote" with your remote config name (e.g. todds_umn_gdrive, or todds_umn_ceph)

rclone --help
# List all your remote locations (google drive, ceph)
rclone listremotes
rclone help flags
rclone lsd remote: # (e.g. rclone lsd todds_umn_gdrive: )





