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

    Instance Variables
	backgroundLayer:		<Object>
	board:		<Object>
	directionDict:		<Object>
	foregroundLayer:		<Object>


    Implementation Points
"
Class {
	#name : 'MygSkBoardElement',
	#superclass : 'BlElement',
	#instVars : [
		'board',
		'moveLabel',
		'backgroundLayer',
		'foregroundLayer',
		'directionDict',
		'space'
	],
	#category : 'Myg-Sokoban-UI',
	#package : 'Myg-Sokoban',
	#tag : 'UI'
}

{ #category : 'as yet unclassified' }
MygSkBoardElement class >> openBoardTest [

	^ self openWithModel: MygSkBoard boardTest
]

{ #category : 'as yet unclassified' }
MygSkBoardElement class >> openWithModel: aSkBoard [

	self new openWithModel: aSkBoard.
]

{ #category : 'as yet unclassified' }
MygSkBoardElement >> allBoxElements [
    "返回棋盘上所有的 MygSkBoxElement（每个格子）"

    ^ self foregroundLayer children

]

{ #category : 'accessing' }
MygSkBoardElement >> backgroundLayer [ 

	^ backgroundLayer
]

{ #category : 'accessing' }
MygSkBoardElement >> backgroundLayer: aBlElement [

	backgroundLayer := aBlElement 
]

{ #category : 'initialization' }
MygSkBoardElement >> board [ 
	^ board
]

{ #category : 'initialization' }
MygSkBoardElement >> board: aSkBoard [

	board := aSkBoard.
	self constraintsDo: [ :c |
		c frame vertical alignCenter.
		c horizontal matchParent.
		c vertical fitContent ].
	self
		initializeBackgroundLayer;
		initializeForegroundLayer
]

{ #category : 'initialization' }
MygSkBoardElement >> boardPreview: aSkBoard [

	board := aSkBoard.
	self loseFocus.
	self constraintsDo: [ :c |
		c frame vertical alignCenter.
		c horizontal matchParent.
		c vertical fitContent ].
	self
		initializeBackgroundLayerPreview;
		initializeForegroundLayerPreview.
	board := nil
]

{ #category : 'accessing' }
MygSkBoardElement >> directionDict [

	^ directionDict
]

{ #category : 'private' }
MygSkBoardElement >> elementsToUpdateAtPosition: aPoint goingIn: aCpDirection [

	| layer elements playerElement neighborElement nextNeighborElement |
	layer := self foregroundLayer.
	playerElement := (layer childWithId: aPoint asString) firstChild.
	neighborElement := (layer childWithId:
		                    (aCpDirection * aPoint) asString) firstChild.
	elements := {
		            playerElement.
		            neighborElement } asOrderedCollection.
	(neighborElement board grid at: neighborElement positionInField)
		class = MygSkWall ifFalse: [
		nextNeighborElement := (layer childWithId:
			                        (aCpDirection * (aCpDirection * aPoint))
				                        asString) firstChild.
		elements add: nextNeighborElement ].
	^ elements
]

{ #category : 'accessing' }
MygSkBoardElement >> foregroundLayer [

	^ foregroundLayer
]

{ #category : 'accessing' }
MygSkBoardElement >> foregroundLayer: aBlElement [

	foregroundLayer := aBlElement 
]

{ #category : 'initialization' }
MygSkBoardElement >> initialize [

	super initialize.
	self initializeDirectionDict.
	self
		background: (BlBackground paint: Color transparent);
		layout: BlFrameLayout new;
		addEventHandlerOn: BlKeyDownEvent
		do: [ :anEvent | self manageEvent: anEvent ];
		requestFocus
]

{ #category : 'accessing' }
MygSkBoardElement >> initializeBackgroundLayer [

	| layer |
	layer := BlElement new
		         background: Color transparent;
		         layout: (BlGridLayout horizontal
				          columnCount: board width;
				          cellSpacing: 2);
		         constraintsDo: [ :c |
			         c horizontal matchParent.
			         c vertical matchParent ].
	self addChild: layer.
	self board do: [ :aBox |
		| boxElement tmpBox container |
		tmpBox := aBox.
		(aBox class inheritsFrom: MygSkMovable) ifTrue: [
			tmpBox := aBox background ].
		boxElement := (MygSkBoxElement box: tmpBox)
			              positionInField: aBox position;
			              board: board.
		container := BlElement new
			             layout: BlSquaredLayout new;
			             constraintsDo: [ :c |
				             c frame vertical alignCenter.
				             c horizontal matchParent.
				             c vertical matchParent ];
			             addChild: boxElement;
			             clipChildren: false.
		layer addChild: container.
		boxElement updateBackgroundColor ].

	self backgroundLayer: layer
]

{ #category : 'accessing' }
MygSkBoardElement >> initializeBackgroundLayerPreview [

	| layer |
	layer := BlElement new
		         background: Color transparent;
		         layout: (BlGridLayout horizontal columnCount: board width);
		         constraintsDo: [ :c |
			         c horizontal matchParent.
			         c vertical fitContent ].
	self addChild: layer.
	self board do: [ :aBox |
		| boxElement tmpBox container |
		tmpBox := aBox.
		(aBox class inheritsFrom: MygSkMovable) ifTrue: [
			tmpBox := aBox background ].
		boxElement := (MygSkBoxElement box: tmpBox)
			              positionInField: aBox position;
			              board: board.
		container := BlElement new
			             layout: BlSquaredLayout new;
			             constraintsDo: [ :c |
				             c frame vertical alignCenter.
				             c horizontal matchParent.
				             c vertical fitContent ];
			             addChild: boxElement;
			             clipChildren: false.
		layer addChild: container.
		boxElement updateBackgroundColor ].

	self backgroundLayer: layer
]

{ #category : 'initialization' }
MygSkBoardElement >> initializeDirectionDict [

	directionDict := {
		        (#DOWN -> CpDirection south).
		        (#UP -> CpDirection north).
		        (#LEFT -> CpDirection west).
		        (#RIGHT -> CpDirection east) } asDictionary.
]

{ #category : 'accessing' }
MygSkBoardElement >> initializeForegroundLayer [

	| layer |
	layer := BlElement new
		         background: Color transparent;
		         layout: (BlGridLayout horizontal
				          columnCount: board width;
				          cellSpacing: 2);
		         constraintsDo: [ :c |
			         c horizontal matchParent.
			         c vertical fitContent ].
	self addChild: layer.
	self board do: [ :aBox |
		| boxElement tmpBox container |
		tmpBox := aBox.
		(aBox class inheritsFrom: MygSkMovable) ifFalse: [
			tmpBox := MygSkGround new ].
		boxElement := (MygSkBoxElement box: tmpBox)
			              positionInField: aBox position;
			              board: board.
		container := BlElement new
			             layout: BlSquaredLayout new;
			             constraintsDo: [ :c |
				             c frame vertical alignCenter.
				             c horizontal matchParent.
				             c vertical fitContent ];
			             addChild: boxElement;
			clipChildren: false.

		layer addChild: container as: aBox position asString.
		boxElement updateBackgroundColor ].

	self foregroundLayer: layer
]

{ #category : 'accessing' }
MygSkBoardElement >> initializeForegroundLayerPreview [

	| layer |
	layer := BlElement new
		         background: Color transparent;
		         layout: (BlGridLayout horizontal
				          columnCount: board width);
		         constraintsDo: [ :c |
			         c horizontal matchParent.
			         c vertical fitContent ].
	self addChild: layer.
	self board do: [ :aBox |
		| boxElement tmpBox container |
		tmpBox := aBox.
		(aBox class inheritsFrom: MygSkMovable) ifFalse: [
			tmpBox := MygSkGround new ].
		boxElement := (MygSkBoxElement box: tmpBox)
			              positionInField: aBox position;
			              board: board.
		container := BlElement new
			             layout: BlSquaredLayout new;
			             constraintsDo: [ :c |
				             c frame vertical alignCenter.
				             c horizontal matchParent.
				             c vertical fitContent ];
			             addChild: boxElement;
			             clipChildren: false.

		layer addChild: container as: aBox position asString.
		boxElement updateBackgroundColor ].

	self foregroundLayer: layer
]

{ #category : 'testing' }
MygSkBoardElement >> isTeleport [
    "当前格子的背景是不是一个传送门？"
    ^ self backgroundLayer isTeleport

]

{ #category : 'initialization' }
MygSkBoardElement >> manageEvent: anEvent [

    | player moved direction neighborElement elements |

    "快捷键：重置 / 关闭窗口"
    anEvent key name = #SPACE ifTrue: [ ^ self resetBoard ].
    anEvent key name = #ESCAPE ifTrue: [ ^ self space close ].
    board isFinished ifTrue: [ ^ self ].

    "1. 找到玩家和方向"
    player := self board player.
    direction := self directionDict
                    at: anEvent key name
                    ifAbsent: [ ^ self ].   "不是方向键就直接返回"

    "2. 要刷新的格子（当前 + 前方）"
    elements := self
                    elementsToUpdateAtPosition: player position
                    goingIn: direction.
    neighborElement := elements second.

    "3. 真正移动玩家 / 推箱子"
    moved := player move: direction.

    "4. 移动成功：步数 +1 + 更新 UI 文本"
    moved ifTrue: [
        self board moveCount: self board moveCount + 1.
        moveLabel text: ('Moves: ', self board moveCount asString) asRopedText
    ].

    "5. 如果踩到传送门，就传送，然后结束（不用下面的动画）"
    (moved and: [ neighborElement isTeleport ]) ifTrue: [
        self teleportPlayer: player fromTeleport: neighborElement.
        ^ self
    ].

    "6. 推箱子动画 / 普通刷新"
    (moved and: [ neighborElement box class = MygSkBox ])
        ifTrue: [
            | animation |
            animation := neighborElement
                boxAnimationMovingInDirection: direction.
            neighborElement addAnimation:
                (animation onFinishedDo: [
                    neighborElement resetAnimation.
                    self updateElements: elements ]) ]
        ifFalse: [
            self updateElements: elements ].


]

{ #category : 'opening' }
MygSkBoardElement >> openWithModel: aSkBoard [

    "不要写 | space | 这一行！！"
    "这里直接给实例变量 space 赋值"
    space := BlSpace new.
    space extent: 500 @ 500.
    space resizable: false.

    space root layout: BlFrameLayout new.
    space root addChild: self.

    self board: aSkBoard.

 moveLabel := BlTextElement new.
moveLabel text: 'Moves: 0' asRopedText.
    space root addChild: moveLabel.

    space show.
]

{ #category : 'initialization' }
MygSkBoardElement >> resetBoard [

	self space close.
	self board reset
]

{ #category : 'as yet unclassified' }
MygSkBoardElement >> teleportPlayer: aPlayer fromTeleport: aBoxElement [
    "玩家站在 aBoxElement（一个传送门格子）上时，把他传送到另外一个传送门。"

    | otherTeleport targetPosition elementsToUpdate |

    "1. 找到另外一个传送门格子"
    otherTeleport := self allBoxElements
        detect: [ :each |
            each ~~ aBoxElement
                and: [ each isTeleport ] ]
        ifNone: [ ^ self ].   "只有一个 T 的话，什么都不做"

    "2. 得到目标位置（model 上的坐标）"
    targetPosition := otherTeleport model position.

    "3. 改玩家的 model 位置"
    aPlayer position: targetPosition.

    "4. 刷新两个传送门所在的格子"
    elementsToUpdate := { aBoxElement. otherTeleport }.
    self updateElements: elementsToUpdate.

]

{ #category : 'private' }
MygSkBoardElement >> updateElements: anOrderedCollection [

	anOrderedCollection do: [ :each | each boxForForeground updateBackgroundColor ]
]

{ #category : 'as yet unclassified' }
MygSkBoardElement >> updateMoveLabel [
    moveLabel text: ('Moves: ', self board moveCount asString) asRopedText.

]
