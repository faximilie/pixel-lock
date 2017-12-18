#!/bin/bash
# How to use:
#
# Just place a .lock_overlay.png in your home folder to overlay whatever you want
# Nicked from: https://gist.github.com/x421/ba39ca927c88b2e0ae5c and modified to suit me (and also write to /tmp/)

#TODO:
#	Parse arguments
#	Write documentation

# The lock overlay location
lock_overlay="/home/kitty/.lock_overlay.png"

# The amount to pixelate the background by
pixelation_ammount=10


# The total x space of the displays
totalx=0

# Calculate the scale down amount as a %
((scale_down=100/pixelation_ammount))

#calculate the scale up amount as a %
((scale_up=100*pixelation_ammount))

#Get list of connected displays
displays=$(xrandr | grep -w connected)


# Take a screenshot 
scrot /tmp/before_blur.png


# Loop through displays and add up their X values
while read -r display ; do
	#Use awk to seperate the x values from the rest of the command output
	((totalx += $(awk 'BEGIN {FS="[ ,x]"}; {print $4}' <<< $display)))
done <<< $displays


# Get the lock overlay image's x size
lock_overlay_x=$(identify $lock_overlay | awk 'BEGIN {FS="[ ,x]"}; {print $3}')


#scale screenshot down, and then back up to achieve the pixel grid effect
convert -scale $scale_down% -scale $scale_up% /tmp/before_blur.png /tmp/lockbg.png

# Calculate the lock overlay offset to center it
((offset=$totalx/2 - $lock_overlay_x/2))

# Attach the lock overlay to the pixelated screenshot in the center
convert -gravity west -geometry +$offset -composite /tmp/lockbg.png ~/.lock_overlay.png /tmp/lockfinal.png

# Remove non-needed image files
rm /tmp/before_blur.png /tmp/lockbg.png

# Call i3lock with the final background
i3lock -u -i /tmp/lockfinal.png

# Remove the final lock screen
rm /tmp/lockfinal.png
