"
This class contains tests
"
Class {
	#name : 'MygSkGameLogic',
	#superclass : 'TestCase',
	#instVars : [
		'board'
	],
	#category : 'Myg-Sokoban-Tests',
	#package : 'Myg-Sokoban-Tests'
}

{ #category : 'running' }
MygSkGameLogic >> setUp [

	super setUp.
	MygSkTarget resetCounter.
	board := MygSkBoard createWithBoard:
		         ((MygLevelImporter
			          fromString: '#@$ . #'
			          fromPackage: MygSkBoard package) do: [ :each | each configured ]).
]

{ #category : 'tests' }
MygSkGameLogic >> testBoxMatchesTarget [
    | box target |
    box := MygSkBox new.
    target := MygSkTarget new.
    box pairId: 1.
    target pairId: 1.
    self assert: box isPaired.
    self assert: target isPaired.
    self assert: box pairId equals: target pairId.
]

{ #category : 'tests' }
MygSkGameLogic >> testIsFinished [

	self deny: board isFinished.
	board player moveEast.
	board player moveEast.
	self assert: board isFinished
]

{ #category : 'tests' }
MygSkGameLogic >> testIsFinishedThenUnfinish [

	self deny: board isFinished.
	board player moveEast.
	board player moveEast.
	self assert: board isFinished.
	board player moveEast.
	self deny: board isFinished
]

{ #category : 'tests' }
MygSkGameLogic >> testMoveSteps [

	self deny: board isFinished.
	board moveSteps: {
			CpDirection east.
			CpDirection east }.
	self assert: board isFinished
]

{ #category : 'tests' }
MygSkGameLogic >> testMultipleTargetsHaveIncrementedNumbers [
	"Test that multiple targets have incremented numbers"
	| target1 target2 target3 |
	
	Transcript show: '==> Test starting'; cr.
	
	target1 := MygSkTarget new.
	Transcript show: 'target1 number: ', target1 number asString; cr.
	
	target2 := MygSkTarget new.
	Transcript show: 'target2 number: ', target2 number asString; cr.
	
	target3 := MygSkTarget new.
	Transcript show: 'target3 number: ', target3 number asString; cr.
	
	self assert: target1 number equals: 1.
	self assert: target2 number equals: 2.
	self assert: target3 number equals: 3
]
