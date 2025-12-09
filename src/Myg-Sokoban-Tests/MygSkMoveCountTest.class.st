Class {
	#name : 'MygSkMoveCountTest',
	#superclass : 'TestCase',
	#instVars : [
		'boardElement',
		'board'
	],
	#category : 'Myg-Sokoban-Tests',
	#package : 'Myg-Sokoban-Tests'
}

{ #category : 'running' }
MygSkMoveCountTest >> setUp [
    super setUp.

    board := MygSkGameManager importFromString:
'########
#@     #
########'.

    boardElement := MygSkBoardElement new.
    boardElement board: board.



]

{ #category : 'tests' }
MygSkMoveCountTest >> testInitialMoveCountIsZero [
    self assert: board moveCount equals: 0.
    self assert: board gameManager currentMoveCount equals: 0.

]

{ #category : 'tests' }
MygSkMoveCountTest >> testMoveCountIncreasesAfterOneMove [
    | event oldBoard oldManager |

    oldBoard := board moveCount.
    oldManager := board gameManager currentMoveCount.

    event := BlKeyDownEvent new.
    event keyName: #RIGHT.

    boardElement manageEvent: event.

    self assert: board moveCount equals: oldBoard + 1.
    self assert: board gameManager currentMoveCount equals: oldManager + 1.

]
