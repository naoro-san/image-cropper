; Gets a list of the opened images, get the first one and returns the directory where it is
; (returns the file path without the filename)
(define (script-function-get-image-dir)
	(let*
		(
			(image (vector-ref (cadr (gimp-image-list)) 0)) ; Get the first image of the gimp image list
			                                                ; gimp-image-list returns a vector and then
			                                                ; vector-ref is used to obtain the index 0 of such vector
			(imagePath (car (gimp-image-get-filename image))) ; Get the path of that image
			(imageBaseName ; Get the image name without the path (ex. "example.png")
			               ; To make is compatible with Linux and Windows it breaks the string with both '/' and '\'
			               ; and gets the last string (the filename)
				(car (last-pair (strbreakup (car (last-pair (strbreakup imagePath "/"))) "\\")))
			)
			; Gets the lenght of both the filename and the full path (including filename)
			; then substract both strings to obtain the length of path without filename
			(imageBaseNameLength (string-length imageBaseName))
			(imagePathLength (string-length imagePath))
			(pathLength (- imagePathLength imageBaseNameLength))
		)
		(substring imagePath 0 pathLength)
	)
)

(define (script-function-crop-image image width height)
	(let*
		(
			(croppedImage (car (gimp-image-duplicate image)))
			(drawable (car (gimp-image-get-active-drawable croppedImage)))
			(origWidth (car (gimp-image-width image)))
			(origHeight (car (gimp-image-height image)))

			(croppedWidth
				(if (= width 0)
					origWidth ; If given width is 0, use full width (don't crop)
					(if (> width origWidth)
						origWidth ; If given width is greater than image width, use image width
						width
					)
				)
			)
			(croppedHeight
				(if (= height 0)
					origHeight ; If given height is  0, use full height (don't crop)
					(if (> height origHeight)
						origHeight ; If given (crop) height is greater than image height, use image height
						height
					)
				)
			)

			(offsetX (/ (- origWidth croppedWidth) 2)) ; Offset is set so image is horizontally centered
			(offsetY (/ (- origHeight croppedHeight) 2)) ; Offset is set so image is vertically centered  
		)
		(
			; Crops the image
			(gimp-image-crop croppedImage croppedWidth croppedHeight offsetX offsetY)
			croppedImage
		)
)

(define (script-comic-page-formatter width height)
	(let*
		(
			; Check if there is an image opened, if so obtain its path and process all the images within that path
			; otherwise, process all the images in the current path (it is then assumed the script is run in
			; non interactive mode from the proper directory)

			; Get the list of files, if it's greater than 0 then means a file is open
			(imageOpened (> 0 (car (gimp-image-list))))
			(filePath 
				(if imageOpened
					(script-function-get-image-dir)
					""
				)
			)
			(filesToFind (string-append filePath "*.png"))
			; First obtain a list with all the png files
			(fileList (cadr (file-glob filesToFind 1)))
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
				; Used to debug, removed to use it in non interactive mode
				;(gimp-display-new srcImage) 
				;(gimp-display-new croppedImage)
				; Saves the image, maybe use  file-jpeg-save or file-png-save
				(outputPath (string-append filePath outputFilename))
				(gimp-file-save 1 croppedImage drawable outputPath outputPath)
				
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
	"<Image>/Script-Fu/Comic Fromatter"
	"Given an input image and size (width, height)
	crops the original image to the given size. The
	cropped image is centered."
	"Naoro"
	"copyright 2019, Naoro"
	"March 31, 2019"
	"RGB*, GRAY*"
	SF-VALUE "width" "800"
	SF-VALUE "height" "1280"
)
