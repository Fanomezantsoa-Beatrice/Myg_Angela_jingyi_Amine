Class {
	#name : 'MygSkMoveCountTest',
	#superclass : 'TestCase',
	#instVars : [
		'board'
	],
	#category : 'Myg-Sokoban-Tests',
	#package : 'Myg-Sokoban-Tests'
}

{ #category : 'running' }
MygSkMoveCountTest >> setUp [

	super setUp.
	MygSkTarget resetCounter.
	
	board := MygSkBoard createWithBoard:
		         ((MygLevelImporter
			          fromString: '#####
#@  #
#   #
#####'
			          fromPackage: MygSkBoard package) do: [ :each | each configured ]).
]

{ #category : 'tests' }
MygSkMoveCountTest >> testInitialMoveCountIsZero [
    self assert: board moveCount equals: 0.
]

{ #category : 'tests' }
MygSkMoveCountTest >> testPlayerCannotMoveIntoWall [
    | player startPos |

    player := board player.
    startPos := player position.

    "往左边是墙，应该动不了（具体看你地图，必要的话把 fromString 那张图改一下）"
    board moveSteps: { CpDirection west }.

    self assert: player position equals: startPos.
]

{ #category : 'tests' }
MygSkMoveCountTest >> testPlayerMovesRight [
    | player startPos |

    player := board player.
    startPos := player position.

    board moveSteps: { CpDirection east }.

    self assert: player position equals: startPos + (1 @ 0).

]

{ #category : 'tests' }
MygSkMoveCountTest >> testRegisterMoveIncreasesCount [
    | old |

    old := board moveCount.
    board registerMove.
    self assert: board moveCount equals: old + 1.

]
