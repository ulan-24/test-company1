#!/bin/bash 

echo $0 
if [ "$0" = "$BASH_SOURCE" ] 
then 
   echo "$0: Please source this file." 
   echo "e.g. source ./setenv configurations/data-rnd-us-vet1-v1" 
   return 1 
fi 

# if [ -z "$1" ] 
# then 
#    echo "terraform { " > backend.tf 
#    echo "backend \"s3\" {}" >> backend.tf
#    echo "}" >> backend.tf
#    cat backend.tf
#    return 0
# fi

if [ -z "$1" ] 
then 
   echo "setenv: You must provide the name of the configuration file." 
   echo "e.g. source ./setenv configurations/data-rnd-us-vet1-v1" 
   return 1 
fi 


# Get directory we are running from 

DIR=$(pwd) 
DATAFILE="$DIR/$1" 
if [ ! -d "$DIR/configurations" ]; then 
    echo "setenv: Must be run from the root directory of the terraform project." 
    return 1 
fi 

if [ ! -f "$DATAFILE" ]; then 
    echo "setenv: Configuration file not found: $DATAFILE" 
    return 1 
fi


# Get env from DATAFILE 

S3BUCKETREGION=$(sed -nr 's/^\s*s3_bucket_region\s*=\s*"([^"]*)".*$/\1/p' "$DATAFILE") 

S3BUCKET=$(sed -nr 's/^\s*s3_bucket\s*=\s*"([^"]*)".*$/\1/p' "$DATAFILE") 

S3FOLDERPROJECT=$(sed -nr 's/^\s*s3_folder_project\s*=\s*"([^"]*)".*$/\1/p' "$DATAFILE")

S3FOLDERNAME=$(sed -nr 's/^\s*s3_folder_name\s*=\s*"([^"]*)".*$/\1/p' "$DATAFILE") 

S3TFSTATEFILE=$(sed -nr 's/^\s*s3_tfstate_file\s*=\s*"([^"]*)".*$/\1/p' "$DATAFILE") 


if [ -z "$S3BUCKETREGION" ] 

then 

   echo "setenv: 's3_bucket_region' variable not set in configuration file." 

   return 1 

fi 

if [ -z "$S3BUCKET" ] 

then 

   echo "setenv: 's3_bucket' variable not set in configuration file." 

   return 1 

fi 

if [ -z "$S3FOLDERPROJECT" ] 

then 

  echo "setenv: 's3_folder_project' variable not set in configuration file." 

  return 1 

fi 

if [ -z "$S3FOLDERNAME" ] 

then 

   echo "setenv: 's3_folder_name' variable not set in configuration file." 

   return 1 

fi 

if [ -z "$S3TFSTATEFILE" ] 

then 

   echo "setenv: 's3_tfstate_file' variable not set in configuration file." 

   echo "e.g. s3_tfstate_file=\"infrastructure.tfstate\"" 

return 1 

fi 

cat << EOF > "$DIR/backend.tf" 
terraform { 
backend "s3" { 
region = "${S3BUCKETREGION}" 
bucket = "${S3BUCKET}" 
key = "${S3FOLDERPROJECT}/${S3FOLDERNAME}/${S3TFSTATEFILE}" 
  } 
} 
EOF


# variables to be set

# s3_bucket_region
# s3_bucket
# s3_folder_project
# s3_folder_name
# s3_tfstate_file


cat backend.tf 
rm -rf .terraform/backend.tfstate
terraform init