Class {
	#name : 'PairStrategy',
	#superclass : 'Object',
	#instVars : [
		'pairId'
	],
	#category : 'Myg-Sokoban',
	#package : 'Myg-Sokoban'
}

{ #category : 'testing' }
PairStrategy >> isPaired [
    ^ pairId notNil
]

{ #category : 'testing' }
PairStrategy >> isUnpaired [
    ^ pairId isNil
]

{ #category : 'testing' }
PairStrategy >> pairId [
    ^ pairId
]

{ #category : 'testing' }
PairStrategy >> pairId: anId [
    pairId := anId
]
