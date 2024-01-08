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

#URL to download the current python script file
var_url1=https://raw.githubusercontent.com/GerryDazoo/Slinger/main/${var_filename}
var_url1=https://raw.githubusercontent.com/GerryDazoo/Slinger/main/${var_filename}

#download the example files
https://raw.githubusercontent.com/GerryDazoo/Slinger/main/config.ini
https://raw.githubusercontent.com/GerryDazoo/Slinger/main/unified_config.ini



#future check if file already exists so that downloading can be skipped - only works if download location is persistant
echo " testing if ${var_path}/${var_filename} exists"
if [ ! -f ${var_path}/${var_filename} ]; then
    echo "  ${var_path}/${var_filename} not found, downloading"
    mkdir -p ${var_path}
    # to allow saving download to path, change directory first.
    #future investigate curl version and --output-dir flag
    cd ${var_path}
    curl -L -o ${var_filename} ${var_url}
    cd /
    #future add check for download success
else
    echo "  file exists"
fi

#derive version from filename
var_version=${var_filename%.*}
#var_version=AirConnect-1.6.2
#var_version=${var_version#*-}
#var_version=1.6.2

# test if desired binaries exist
# if not, extract and copy files to path (to persist) and to the container
# cleanup the extracted files
echo " testing if either ${var_path}/${var_version}/airupnp-${ARCH_VAR} or ${var_path}/${var_version}/aircast-${ARCH_VAR} does not exist"
if [ ! -f ${var_path}/${var_version}/airupnp-${ARCH_VAR} -o ! -f ${var_path}/${var_version}/aircast-${ARCH_VAR} ]; then
    echo "  extracting required executables: airupnp-${ARCH_VAR} aircast-${ARCH_VAR}"
    unzip -o ${var_path}/${var_filename} airupnp-${ARCH_VAR} aircast-${ARCH_VAR} -d ${var_path}/${var_version}/
fi

ls -la ${var_path}/${var_version}/
if [ ${MAXTOKEEP_VAR} -eq 0 ]; then
   echo " MAXTOKEEP_VAR is set to zero or not set, skipping cleanup"
else
   echo " MAXTOKEEP_VAR is set to ${MAXTOKEEP_VAR}, will keep the most recent ${MAXTOKEEP_VAR} .zip files and directories"
   var_max=${MAXTOKEEP_VAR}
   cd ${var_path}
   n=0
   # only keep X versions of file
   echo " checking for files and directories to clean up"
   ls -1t *.zip |
   while read file; do
      n=$((n+1))
      if [ $n -gt $var_max ]; then
          echo "  removing ${file}"
          rm "${file}"
      fi
   done
   n=0
   # only keep X versions of directories
   ls -1dt */ |
   while read directory; do
      n=$((n+1))
      if [ $n -gt $var_max ]; then
          echo "  removing ${directory}"
          rm -r "$directory"
      fi
   done
   n=0
   cd /
fi

# copy specified binaries into place unless skipped by kill variable
if [ "$AIRUPNP_VAR" != "kill" ]; then
    echo " copying ${var_path}/${var_version}/airupnp-${ARCH_VAR} to /bin/airupnp-${ARCH_VAR}"
    cp ${var_path}/${var_version}/airupnp-${ARCH_VAR} /bin/airupnp-${ARCH_VAR} \
    && chmod +x /bin/airupnp-$ARCH_VAR
else
    echo " AIRUPNP_VAR variable set to \"kill\", not enabling airupnp service and removing any previous airupnp executables from /bin"
    rm /bin/airupnp-* 2> /dev/null
fi

# copy specified binaries into place unless skipped by kill variable
if [ "$AIRCAST_VAR" != "kill" ]; then
    echo " copying ${var_path}/${var_version}/aircast-${ARCH_VAR} to /bin/aircast-${ARCH_VAR}"
    cp ${var_path}/${var_version}/aircast-${ARCH_VAR} /bin/aircast-${ARCH_VAR} \
    && chmod +x /bin/aircast-$ARCH_VAR
else
    echo " AIRCAST_VAR variable set to \"kill\", not enabling aircast service and removing any previous aircast executables from /bin"
    rm /bin/aircast-* 2> /dev/null
fi

echo " executable usage:"
if [ -f /bin/airupnp-${ARCH_VAR} ]; then
/bin/airupnp-$ARCH_VAR -h
elif [ -f /bin/aircast-$ARCH_VAR ]; then
/bin/aircast-$ARCH_VAR -h
fi

echo "=== exiting acquire_airconnect_up.sh ==="
