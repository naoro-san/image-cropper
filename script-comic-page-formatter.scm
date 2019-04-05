(define (script-comic-page-formatter width height)
	(let*
		(
		 	; First obtain a list with all the png files
			(fileList (cadr (file-glob "*.png" 1)))
		)
		(while (not (null? fileList)) ; Process every file on the list
		; TODO Only process the files which are actual comic pages
		; for instance process only files starting with 'p', 'page', 'panel' or so.
			(let*
				(
				 	; Gets the current filename and obtain its base name (without path and extension)
					(filename (car fileList))
					(baseName (car (last-pair (strbreakup (car (last-pair (strbreakup (car (strbreakup filename ".")) "/"))) "\\"))))
					(baseNameLength (string-length baseName))

					; Generate the name of the new file to be created (with prefix 'publish_' and 'jpeg' extension)
					(outputBaseName (string-append "publish_" baseName))
					(outputFilename (string-append outputBaseName ".jpg")) ; File is saved in jpg
					                                                       ; Since it's to publish on internet
					                                                       ; it doesn't matter to use a lossy format
					(srcImage (car (file-png-load 0 filename filename)))
					(croppedImage (car (gimp-image-duplicate srcImage)))
					(drawable (car (gimp-image-get-active-drawable croppedImage)))
					(origWidth (car (gimp-image-width srcImage)))
					(origHeight (car (gimp-image-height srcImage)))

					(croppedWidth
						(if (< width 0)
							origWidth ; If given (crop) width is less than 0, use full width (don't crop)
							(if (> width origWidth)
								origWidth ; If given width is greater than image width, use image width
								width
							)
						)
					)
					(croppedHeight
						(if (< height 0)
							origHeight ; If given (crop) height is less than 0, use full height (don't crop)
							(if (> height origHeight)
								origHeight ; If given (crop) height is greater than image height, use image height
								height
							)
						)
					)

					(offsetX (/ (- origWidth croppedWidth) 2)) ; Offset is set so image is horizontally centered
					(offsetY (/ (- origHeight croppedHeight) 2)) ; Offset is set so image is vertically centered  
				)
				; Crops the image
				(gimp-image-crop croppedImage croppedWidth croppedHeight offsetX offsetY)
				; Used to debug, removed to use it in non interactive mode
				;(gimp-display-new srcImage) 
				;(gimp-display-new croppedImage)
				; Saves the image, maybe use  file-jpeg-save or file-png-save
				(gimp-file-save 1 croppedImage drawable outputFilename outputFilename)
				
				; Cleanup
				(gimp-image-delete srcImage)
				(gimp-image-delete croppedImage)
			)
			(set! fileList (cdr fileList))
		)
	)
)
(script-fu-register
	"script-comic-page-formatter"
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
