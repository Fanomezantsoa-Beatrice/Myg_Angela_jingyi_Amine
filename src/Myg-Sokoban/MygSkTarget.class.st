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
    | baseIcon bigForm canvas textPosition font text fontSize textWidth textHeight |

    baseIcon := MygSkBoxElement targetIcon.
    bigForm := baseIcon scaledIntoFormOfSize: 200@200.

    text := number asString.

    "Start with large font size and shrink until it fits"
    fontSize := bigForm height.
    [
        font := (LogicalFont familyName: 'Arial' pointSize: fontSize) emphasized: 2.
        textWidth := font widthOfString: text.
        textHeight := font ascent.
        (textWidth > bigForm width or: [ textHeight > bigForm height ])
    ] whileTrue: [ fontSize := fontSize - 2 ].

    textPosition := ((bigForm width - textWidth) // 2)
                    @ ((bigForm height - textHeight) // 2).

    canvas := FormCanvas on: bigForm.

    "Thicker black outline"
    -3 to: 3 do: [ :dx |
        -3 to: 3 do: [ :dy |
            canvas 
                drawString: text
                at: textPosition + (dx @ dy)
                font: font
                color: Color black ] ].

    "Main text in bright white or yellow"
    canvas 
        drawString: text
        at: textPosition
        font: font
        color: Color white.  "or Color yellow"

    ^ bigForm

]

{ #category : 'action' }
MygSkTarget >> bringIn: aSkMovable going: aDirection [
	"Only accept boxes if they come in the correct order"
	<action>
	| nextTargetToFill |
	
	"Check if it's a box trying to enter"
	aSkMovable class = MygSkBox ifFalse: [ 
		^ super bringIn: aSkMovable going: aDirection ].
	
	"Get the next target number that should be filled"
	nextTargetToFill := self board nextTargetNumberToFill.
	
	"If this is not the next target, block the move"
	self number ~= nextTargetToFill ifTrue: [ ^ false ].
	
	"Otherwise, allow the move"
	^ super bringIn: aSkMovable going: aDirection
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
