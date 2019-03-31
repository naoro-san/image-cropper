(define (script-image-cropper image width height name)
  (let*
    (
     (srcImage (car (file-png-load 0 image image)))
     (croppedImage (car (gimp-image-duplicate srcImage)))
     (drawable (car (gimp-image-get-active-drawable croppedImage)))
     (origWidth (car (gimp-image-width srcImage)))
     (origHeight (car (gimp-image-height srcImage)))
     (offsetX
       (if (< width 0)
         0 ; If given (crop) width is less than 0, use full width (don't crop)
         (if (> width origWidth)
           origWidth ; If givien (crop) width is greater than image width
                     ; Crop all the image width
                     ; Should be replaced to give an error and exit
           (/ (- origWidth width) 2) ; Offset is set so image is horizontally centered
         )
       )
     )
     (offsetY
       (if (< height 0)
         0 ; If given (crop) height is less than 0, use full height (don't crop)
         (if (> width origHeight)
           origHeight ; If givien (crop) height is greater than image height
                     ; Crop all the image height
                     ; Should be replaced to give an error and exit
           (/ (- origHeight height) 2) ; Offset is set so image is vertically centered
         )
       )
     )
    )
    ; Crops the image
    (gimp-image-crop croppedImage width height offsetX offsetY)
    
    ; Used to debug, removed to use it in non interactive mode
    ;(gimp-display-new srcImage) 
    ;(gimp-display-new croppedImage)

    ; Saves the image, maybe use  file-jpeg-save or file-png-save
    (gimp-file-save 1 croppedImage drawable name name)
    ; (file-jpeg-save
    ;   1
    ;   srcImage
    ;   (car (gimp-image-get-active-drawable srcImage))
    ;   name
    ;   name
    ;   0.8
    ;   0
    ;   0
    ;   0
    ;   ""
    ;   0
    ;   0
    ;   0
    ;   0
    ; )
  )
)
(script-fu-register
  "script-image-cropper"
  "Image crop"
  "Given an input image and size (width, height)
  crops the original image to the given size. The
  cropped image is centered."
  "Naoro"
  "copyright 2019, Naoro"
  "March 31, 2019"
  "RGB*, GRAY*"
  SF-STRING "Filename" ""
  SF-VALUE "width" "100"
  SF-VALUE "height" "100"
  SF-STRING "Save file" ""
)
