# image-cropper
Image cropper script for gimp
# Installation
## Linux:
Copy script-image-cropper.scm into ~/.gimp-[version]/scripts
# Usage:
Originally created to use in non-interactive mode.
```
gimp -i -b '(script-image-cropper [SRC] [WIDTH] [HEIGHT] [DEST])' -b '(gimp-quit 0)'
```

Example:
```
gimp -i -b '(script-image-cropper "p01.png" 800 400 "p01.jpg")' -b '(gimp-quit 0)'
```

In this example an original image p01.png is cropped to a 800px width and 400px height and saved into p01.jpg
