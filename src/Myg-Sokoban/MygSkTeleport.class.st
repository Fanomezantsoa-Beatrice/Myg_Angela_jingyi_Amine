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
    "找到和我成对的另一个 teleport（同一个 board 上）"
    | ts |
    ts := self board teleports.
    ts size < 2 ifTrue: [ ^ nil ].  "没有成对的就不传送"
    ^ ts detect: [:t | t ~~ self] ifNone: [ nil ]

]

{ #category : 'accessing' }
MygSkTeleport >> partner [
    ^ partner
]

{ #category : 'as yet unclassified' }
MygSkTeleport >> teleportPlayer: aPlayer [

	| board prev other |
	"Already teleported this move?"
	(aPlayer teleportCooldown) ifTrue: [ ^ self ].

	aPlayer teleportCooldown: true.


	board := self board.

	"Find the other teleport"
	other := self otherTeleport.
	other ifNil: [ ^ self ].

	"Teleport"
	prev := aPlayer position.
	aPlayer basicPosition: other position.
	board updatePositionOf: aPlayer from: prev.


]
