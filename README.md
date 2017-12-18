# Pixel-lock

Pixel-lock is a script that will pixelate your current screen, attach an overlay and lock your screen using i3lock

## Usage
This script requires `imagemagik` and `i3lock` to be installed to work correctly.

Currently there are no command line options, so to make changes you will need to edit the script.

To lock the screen simply call the lock script
```bash
bash lock.sh
```
It relies on a file being located in your home directory called `.lock_overlay.png`
