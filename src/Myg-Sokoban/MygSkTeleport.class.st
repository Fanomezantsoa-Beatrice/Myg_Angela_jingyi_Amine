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

{ #category : 'testing' }
MygSkTeleport >> isTeleport [
    ^ true

]

{ #category : 'accessing' }
MygSkTeleport >> partner [
    ^ partner
]
