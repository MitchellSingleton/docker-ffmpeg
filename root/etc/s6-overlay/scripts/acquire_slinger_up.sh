#!/usr/bin/with-contenv bash
echo "=== Starting acquire_slinger_up.sh ==="
# This one-shot script is a dependacy and will run first.
# It will check if the requested version has been downloaded and if not download it
# It will check if the downloaded file has been unzipped and if not unzip
# It will check if the desired binaries are copied into place with the correct permissions

#filename to download
var_filename=slingbox_server.py

#URL to download the current python script file
var_url=https://raw.githubusercontent.com/GerryDazoo/Slinger/main/${var_filename}

#test if PATH_VAR is zero length or not set, if so use default, if not use the passed variable
if [ -z "${PATH_VAR}" ]; then
   var_path="/tmp"
else
   var_path="${PATH_VAR}"
fi

mkdir -p ${var_path}

#future check if file already exists so that downloading can be skipped - only works if download location is persistant
echo " testing if ${var_path}/${var_filename} exists"
if [ ! -f ${var_path}/${var_filename} ]; then
    echo "  ${var_path}/${var_filename} not found, downloading"
    # to allow saving download to path, change directory first.
    #future investigate curl version and --output-dir flag
    cd ${var_path}
    curl -L -o ${var_filename} ${var_url}
    cd /
    #future add check for download success
else
    echo "  file exists"
fi

#filename to download
var_config1=config.ini
var_config2=unified_config.ini

#URL to download the example config files
var_url1=https://raw.githubusercontent.com/GerryDazoo/Slinger/main/${var_config1}
var_url2=https://raw.githubusercontent.com/GerryDazoo/Slinger/main/${var_config2}

#future check if file already exists so that downloading can be skipped - only works if download location is persistant
echo " testing if either ${var_path}/example_${var_config1} or ${var_path}/example_${var_config2} exists"
if [ ! -f ${var_path}/${var_config1} -o ! ${var_path}/${var_config2} ]; then
    echo "  not found, downloading"
    # to allow saving download to path, change directory first.
    #future investigate curl version and --output-dir flag
    cd ${var_path}
    curl -L -o example_${var_config1} ${var_url1}
    curl -L -o example_${var_config2} ${var_url2}
    cd /
    #future add check for download success
else
    echo "  both example configuration files exist"
fi

echo "=== exiting acquire_slinger_up.sh ==="
