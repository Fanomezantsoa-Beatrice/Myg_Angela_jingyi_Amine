"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : 'MygSkTarget',
	#superclass : 'MygSkObject',
	#instVars : [
		'number'
	],
	#classVars : [
		'TargetCounter'
	],
	#category : 'Myg-Sokoban-Model',
	#package : 'Myg-Sokoban',
	#tag : 'Model'
}

{ #category : 'class initialization' }
MygSkTarget class >> initialize [
	"Initialize the class variable - called once when class is loaded"
	TargetCounter := 0
]

{ #category : 'class initialization' }
MygSkTarget class >> nextNumber [

	TargetCounter := TargetCounter + 1.
	^ TargetCounter
]

{ #category : 'class initialization' }
MygSkTarget class >> resetCounter [
	"Reset counter to 0"
	TargetCounter := 0
]

{ #category : 'default encoding' }
MygSkTarget class >> textualMapCharacter [ 

	^ $.
]

{ #category : 'accessing' }
MygSkTarget >> backgroundRepresentation [
	| baseIcon bigForm canvas textPosition font text fontSize offset |
	
	baseIcon := MygSkBoxElement targetIcon.
	bigForm := baseIcon scaledIntoFormOfSize: 200@200.
	fontSize := bigForm height // 2.
	
	font := (LogicalFont familyName: 'Arial' pointSize: fontSize) emphasized: 1.
	text := number asString.
	
	textPosition := ((bigForm width - (font widthOfString: text)) // 2) 
	                @ ((bigForm height - font height) // 2).
	
	canvas := FormCanvas on: bigForm.
	
	"Dessiner le texte plusieurs fois avec des décalages pour simuler du gras"
	-2 to: 2 do: [ :dx |
		-2 to: 2 do: [ :dy |
			offset := dx @ dy.
			canvas 
				drawString: text
				at: textPosition + offset
				font: font
				color: Color black ] ].
	
	"Dessiner le texte final en jaune vif par-dessus"
	canvas 
		drawString: text
		at: textPosition
		font: font
		color: Color yellow.
	
	^ bigForm
]

{ #category : 'accessing' }
MygSkTarget >> initialize [
	super initialize.
	number := self class nextNumber
]

{ #category : 'move' }
MygSkTarget >> isTarget [ 
	^ true
]

{ #category : 'accessing' }
MygSkTarget >> number [
	^ number
]

{ #category : 'accessing' }
MygSkTarget >> number: anInteger [
	number := anInteger
]
