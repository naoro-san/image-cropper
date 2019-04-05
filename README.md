# image-cropper
Image cropper script for gimp.  
There are two different scrips, the first one 'script-image-cropper.scm' can be used to crop an image.  
The second script, the main purpose of this project, 'script-comic-page-formatter.scm' crops all the (png) images in the current dir to the given size and saves them as jpg images with the prefix 'publish_', which can then be published on a webcomic site (Tapas, Webtoons, etc).
# TODO list
- [] Scale images if they are too wide (more than 800 px for Webtoons and 940 px for Tapas)
- [] Split images if they are too long (1280 px for Webtoons and 
- [] Process only pages (files starting with 'p', 'page' or another predefined name)
# Installation
## Linux:
Copy script files (*.scm) into ~/.gimp-[version]/scripts
Update: This can be done with the Makefile using ``make install`` (Gimp version might be set to the right one, by default it uses 2.8)
## Windows:
Pending...
# Usage:
## script-image-cropper.scm
Originally created to use in non-interactive mode.
```
gimp -i -b '(script-image-cropper [SRC] [WIDTH] [HEIGHT] [DEST])' -b '(gimp-quit 0)'
```

Example:
```
gimp -i -b '(script-image-cropper "p01.png" 800 400 "p01.jpg")' -b '(gimp-quit 0)'
```

In this example an original image p01.png is cropped to a 800px width and 400px height and saved into p01.jpg

## script-comic-page-formatter.scm
Pending...
