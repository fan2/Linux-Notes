#!/bin/bash

# https://www.amsys.co.uk/bash-scripting-examples-2/

## Load Variables ##
CurrentLocation=$(networksetup -getcurrentlocation)
CheckForAutoLocation=$(networksetup -listlocations | grep -c "Automatic")

################################################################

if [ "$CurrentLocation" != "Automatic" ]
then
    echo "Current location is not Automatic"
    echo "Unexpected value, has this been run before?"
    exit 1
else
    echo "Current location is Automatic"
    echo "Continuing Script"
fi

################################################################

if [ "$CheckForAutoLocation" != "0" ]
then
    echo "Automatic location does not exist"
    echo "Unexpected value, has this been run before?"
    exit 1
else
    echo "Automatic location is present"
    echo "Continuing Script"
fi

################################################################

echo "Creating Home location and auto populating network interfaces"
if ! networksetup –createlocation "Home" populate;
then
    currentdate=$(date)
    echo "Creating Home location failed. Please Investigate."
    exit 1
else
    currentdate=$(date)
    echo "Home location created fine, continuing script"
fi

################################################################

echo "Switching to the new Home location"
if ! networksetup –switchtolocation "Home";
then
    currentdate=$(date)
    echo "Switching to the Home location failed. Please Investigate."
    exit 1
else
    currentdate=$(date)
    echo "Home location switched fine, continuing script"
fi

################################################################

echo "Deleting the Automatic location"
if ! networksetup –deletelocation "Automatic";
then
    currentdate=$(date)
    echo "Deleting the Automatic location failed. Please Investigate."
    exit 1
else
    currentdate=$(date)
    echo "Automatic location deleted fine, continuing script"
fi

exit 0
