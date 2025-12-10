Class {
	#name : 'MygSkTeleport',
	#superclass : 'MygSkGround',
	#category : 'Myg-Sokoban-Model',
	#package : 'Myg-Sokoban',
	#tag : 'Model'
}

{ #category : 'default encoding' }
MygSkTeleport class >> textualMapCharacter [
    ^ $T

]

{ #category : 'testing' }
MygSkTeleport >> backgroundRepresentation [
    ^ super backgroundRepresentation

]

{ #category : 'action' }
MygSkTeleport >> bringIn: aMovable going: aDirection [
    "当玩家走到传送门上时，先正常走到当前传送门，
     再把他传送到另一个传送门的位置。"

    | board previousPosition otherTeleport |

    board := aMovable board.

    "先把玩家移动到当前传送门这格"
    previousPosition := aMovable position.
    aMovable position: self position.
    board updatePositionOf: aMovable from: previousPosition.

    "在整个棋盘上找 *另一个* 传送门"
    otherTeleport := nil.
    board do: [ :each |
        (each isTeleport and: [ each ~= self ]) ifTrue: [
            otherTeleport := each ] ].

    "找到就再传送一次"
    otherTeleport ifNotNil: [
        previousPosition := aMovable position.
        aMovable position: otherTeleport position.
        board updatePositionOf: aMovable from: previousPosition ].

]

{ #category : 'testing' }
MygSkTeleport >> isTeleport [
    ^ true

]

{ #category : 'testing' }
MygSkTeleport >> textualMapCharacter [
    ^ $W 
]
