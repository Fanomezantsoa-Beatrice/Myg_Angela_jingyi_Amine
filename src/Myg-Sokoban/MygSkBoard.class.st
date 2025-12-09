"
I represent a 2 dimensional space of elements. In fact, internally I maintain a list of elements so that I can simply push and pop elements when the movable elements are moving. An alternate strategy would be to always keep the currently occupied one to restore after. 
It looks like a space tradeoff and we do not have space problem. 

Todo:
- revisit position (rename position into basic + position with update)
- game logic
-- all on target

Extensions
- Make sure that we cannot push multiple boxes.
- Count the number of move.
- Support game replay or revert.
"
Class {
	#name : 'MygSkBoard',
	#superclass : 'MygBoard',
	#instVars : [
		'player',
		'boxes',
		'moveCount',
		'ended',
		'gameManager'
	],
	#category : 'Myg-Sokoban-Model',
	#package : 'Myg-Sokoban',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
MygSkBoard class >> boardTest [

	^ self createWithBoard: (MygSkGameManager importFromString: self microban1TestBoard).
]

{ #category : 'initialization' }
MygSkBoard class >> createWithBoard: aCTNewArray2D [

	^ self new
		  configureGrid: aCTNewArray2D;
		  yourself
]

{ #category : 'initialization' }
MygSkBoard class >> createWithBoard: aCTNewArray2D managedBy: aSkGameManager [

	^ (self createWithBoard: aCTNewArray2D)
		  gameManager: aSkGameManager;
		  yourself
]

{ #category : 'example' }
MygSkBoard class >> example [ 
	<sampleInstance>
	
	^ MygLevelImporter fromString: '    #####
    #   #
    #$  #
  ###  $##
  #  $ $ #
### # ## #   ######
#   # ## #####  ..#
# $  $          ..#
##### ### #@##  ..#
    #     #########
    #######' fromPackage: self package
]

{ #category : 'mazes' }
MygSkBoard class >> microban1TestBoard [
	"sasquatch/sokoban/microban.html"

	^ '####
# .#
#  ###
#*@  #
#  $ #
#  ###
####'
]

{ #category : 'printing' }
MygSkBoard >> asciiString [ 

	^ String streamContents: [ :st |
		self printOn: st ]	

]

{ #category : 'low level access' }
MygSkBoard >> at: anInteger at: anInteger2 [

	^ grid at: anInteger @ anInteger2
]

{ #category : 'low level access' }
MygSkBoard >> at: anInteger at: anInteger2 put: anElement [

	grid at: anInteger @ anInteger2 put: anElement
]

{ #category : 'low level access' }
MygSkBoard >> atColumn: anInteger atRow: anInteger2 [

	^ grid at: anInteger @ anInteger2
]

{ #category : 'low level access' }
MygSkBoard >> atColumn: anInteger atRow: anInteger2 put: anElement [

	grid at: anInteger @ anInteger2 put: anElement
]

{ #category : 'accessing' }
MygSkBoard >> atPosition: aCpPositionable [ 
	^ (grid at: aCpPositionable x @ aCpPositionable y)
]

{ #category : 'accessing' }
MygSkBoard >> boxes [ 

	^ boxes
]

{ #category : 'accessing' }
MygSkBoard >> boxes: aCollection [

	boxes := aCollection 
]

{ #category : 'accessing' }
MygSkBoard >> configureGrid: aCTNewArray2D [

	super configureGrid: aCTNewArray2D.
	self
		setBoxes;
		setPlayer
]

{ #category : 'building' }
MygSkBoard >> do: aBlock [

	grid do: aBlock
]

{ #category : 'ending' }
MygSkBoard >> endGame [

	ended ifTrue: [ ^ self ].
	ended := true.
	gameManager ifNotNil: [ gameManager registerLevel ]
]

{ #category : 'accessing' }
MygSkBoard >> ended [ 

	^ ended 
]

{ #category : 'accessing' }
MygSkBoard >> gameManager [ 
	
	^ gameManager 
]

{ #category : 'accessing' }
MygSkBoard >> gameManager: aSkGameManager [

	gameManager:= aSkGameManager 
]

{ #category : 'accessing' }
MygSkBoard >> height [
	^ grid height
]

{ #category : 'initialization' }
MygSkBoard >> initialize [

	super initialize.
	ended := false.
	boxes := OrderedCollection new.
	moveCount := 0.
	
	
]

{ #category : 'testing' }
MygSkBoard >> isFinished [

	^ self boxes allSatisfy: [ :each | each background isTarget ]
]

{ #category : 'accessing' }
MygSkBoard >> moveCount [
    ^ moveCount


]

{ #category : 'accessing' }
MygSkBoard >> moveCount: aNumber [
    moveCount := aNumber


]

{ #category : 'move' }
MygSkBoard >> moveSteps: aCollectionOfDirection [

	aCollectionOfDirection do: [ :each | player move: each ]
]

{ #category : 'as yet unclassified' }
MygSkBoard >> otherTeleportFor: aTeleportElement [
    | teleports |
    teleports := self teleportElements.
    ^ teleports
        detect: [:each | each ~~ aTeleportElement]
        ifNone: [ aTeleportElement ]  "sécurité si mal configuré"
]

{ #category : 'as yet unclassified' }
MygSkBoard >> otherTeleportPositionFrom: aPoint [
    | teleports |
    teleports := self teleportPositions.
    teleports size = 2 ifFalse: [ ^ aPoint ].  "sécurité si la map est mal faite"
    ^ teleports
        detect: [:pos | pos ~= aPoint]
        ifNone: [ aPoint ]

]

{ #category : 'as yet unclassified' }
MygSkBoard >> otherTeleportThan: aTeleport [
    | all |
    all := self teleports.
    ^ all detect: [ :each | each ~= aTeleport ]
        ifNone: [ nil ]

]

{ #category : 'accessing' }
MygSkBoard >> player [
	^ player
]

{ #category : 'printing' }
MygSkBoard >> printOn: aStream [

	(1 to: grid height)
		do: [ :rowNumber |
			1 to: grid width do: [ :columnNumber |
				| el elClass |
				el := self atColumn: columnNumber atRow: rowNumber.
				elClass := (el class inheritsFrom: MygSkMovable)
					           ifFalse: [ el class ]
					           ifTrue: [
						           el background class = MygSkGround
							           ifTrue: [ el class ]
							           ifFalse: [
							           self class environment at:
								           (el class asString , 'OnTarget') asSymbol] ].
				aStream nextPut: elClass textualMapCharacter ] ]
		separatedBy: [ aStream cr ]
]

{ #category : 'initialization' }
MygSkBoard >> reset [

	self gameManager launchAgain
]

{ #category : 'initialization' }
MygSkBoard >> setBoxes [

	self boxes: (grid select: [ :e | e class = MygSkBox ]).
]

{ #category : 'initialization' }
MygSkBoard >> setPlayer [

	player := grid contents detect: #isPlayer
]

{ #category : 'as yet unclassified' }
MygSkBoard >> teleportElements [
    "Retourne la liste des tuiles de type téléporteur sur le plateau"
    ^ self allElements select: [:each | each isTeleport]
]

{ #category : 'as yet unclassified' }
MygSkBoard >> teleportPlayer [
    | playerElement sourcePos destPos destBackground |

    playerElement := player.        
    playerElement ifNil: [ ^ self ].

    sourcePos := playerElement position.
    sourcePos ifNil: [ ^ self ].

    destPos := self otherTeleportPositionFrom: sourcePos.
    destPos = sourcePos ifTrue: [ ^ self ].  

    
    self
        atColumn: sourcePos x
        atRow: sourcePos y
        put: playerElement background.

    
    destBackground := self
        atColumn: destPos x
        atRow: destPos y.

   
    playerElement
        background: destBackground;
        position: destPos.

    
    self
        atColumn: destPos x
        atRow: destPos y
        put: playerElement.

]

{ #category : 'as yet unclassified' }
MygSkBoard >> teleportPositions [
    | positions |
    positions := OrderedCollection new.
    1 to: self width do: [:col |
        1 to: self height do: [:row |
            ((self atColumn: col atRow: row) isTeleport)
                ifTrue: [ positions add: col@row ] ] ].
    ^ positions

]

{ #category : 'as yet unclassified' }
MygSkBoard >> teleports [
    "返回本棋盘上所有传送门格子（通常是 2 个）。"
    | collection |
    collection := OrderedCollection new.
    self do: [ :each |
        (each isTeleport) ifTrue: [ collection add: each ] ].
    ^ collection asArray

]

{ #category : 'move' }
MygSkBoard >> updatePositionOf: aSkMovable from: previousPosition [
    "Put back the previous position element."

    self
        atColumn: previousPosition x
        atRow: previousPosition y
        put: aSkMovable background.

    "put the current position element as previous background of the moving element."
    aSkMovable background:
        (self
            atColumn: aSkMovable position x
            atRow: aSkMovable position y).

    "finally place the moving element to its new location"
    self
        atColumn: aSkMovable position x
        atRow: aSkMovable position y
        put: aSkMovable.

    "=== si c'est le joueur et qu'il est sur un téléport, on téléporte ==="
    (aSkMovable == player and: [ aSkMovable background isTeleport ])
        ifTrue: [
            self teleportPlayer
        ].

    self isFinished ifTrue: [ self endGame ].

]

{ #category : 'accessing' }
MygSkBoard >> width [
	^ grid width
]
