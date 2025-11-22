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
	"Return a Form (image) with the number drawn on it"
	| baseIcon form canvas textPosition |
	
	baseIcon := MygSkBoxElement targetIcon.
	form := baseIcon copy.  "Copy to not modify the original"
	
	"Draw the number on the form"
	canvas := FormCanvas on: form.
	textPosition := (form width // 2 - 8) @ (form height // 2 - 10).
	
	canvas 
		drawString: number asString
		at: textPosition
		font: (LogicalFont familyName: 'Arial' pointSize: 18)
		color: Color white.
	
	^ form
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
