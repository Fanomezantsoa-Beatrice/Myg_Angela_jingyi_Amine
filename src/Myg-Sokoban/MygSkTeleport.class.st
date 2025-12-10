Class {
	#name : 'MygSkTeleport',
	#superclass : 'MygSkGround',
	#instVars : [
		'partner'
	],
	#category : 'Myg-Sokoban-Model',
	#package : 'Myg-Sokoban',
	#tag : 'Model'
}

{ #category : 'default encoding' }
MygSkTeleport class >> textualMapCharacter [
    ^ $T
]

{ #category : 'action' }
MygSkTeleport >> bringIn: aSkMovable going: aDirection [
     
    "非玩家（箱子）进来：当普通地板处理"

    (aSkMovable isPlayer) ifFalse: [
        ^ super bringIn: aSkMovable going: aDirection ].

    "先执行普通的进入逻辑（计步、推箱子等全走原来的流程）"
    (super bringIn: aSkMovable going: aDirection) ifFalse: [ ^ false ].

    "普通移动成功后，再执行传送"
    self teleportPlayer: aSkMovable.
    ^ true

]

{ #category : 'testing' }
MygSkTeleport >> isTeleport [
    ^ true

]

{ #category : 'as yet unclassified' }
MygSkTeleport >> otherTeleport [
	^ self board teleports
		detect: [:t | t ~~ self ]
		ifNone: [ nil ]

]

{ #category : 'accessing' }
MygSkTeleport >> partner [
    ^ partner
]

{ #category : 'as yet unclassified' }
MygSkTeleport >> teleportPlayer: aPlayer [

	| board previous position other |
	
	"cooldown: avoid bouncing loop"
	(aPlayer teleportCooldown = true) ifTrue: [ ^ self ].

	aPlayer teleportCooldown: true.

	board := self board.

	previous := aPlayer position.

	other := self otherTeleport ifNil: [ ^ self ].

	aPlayer basicPosition: other position.

	board updatePositionOf: aPlayer from: previous.

	"Clear cooldown after one cycle"
	aPlayer teleportCooldown: false.



]
