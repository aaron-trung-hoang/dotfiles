#!/bin/bash

echo "=== Starting installation of packages and apps for Ubuntu ==="


# Install apt packages defined in 'apt_packages' file
sudo xargs -a ./ubuntu/apt_packages apt install -y

echo "--Snap--"
# Read the list of applications from file 'snap_apps'
while IFS=: read -r app_name app_classic || [ -n "$app_name" ]; do
  # Skip empty lines
  if [ -z "$app_name" ]; then
    continue
  fi
  
  echo "Installing $app_name..."
  if [ "$app_classic" == "classic" ]; then
    sudo snap install "$app_name" --classic
  else
    sudo snap install "$app_name"
  fi
done < ./ubuntu/snap_apps

echo "Installation completed!"
