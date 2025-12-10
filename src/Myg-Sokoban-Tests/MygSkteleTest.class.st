Class {
	#name : 'MygSkteleTest',
	#superclass : 'TestCase',
	#instVars : [
		'board'
	],
	#category : 'Myg-Sokoban-Tests',
	#package : 'Myg-Sokoban-Tests'
}

{ #category : 'running' }
MygSkteleTest >> setUp [

	super setUp.
	MygSkTarget resetCounter.
	
	board := MygSkBoard createWithBoard:
		         ((MygLevelImporter
			          fromString: '#####
#@T  #
# T  #
#####'
			          fromPackage: MygSkBoard package) do: [ :each | each configured ]).
]

{ #category : 'tests' }
MygSkteleTest >> testTeleportBasic [
	| p |
	p := board player.

	p move: CpEastDirection new.

	self assert: p position equals: 3@3.



]
