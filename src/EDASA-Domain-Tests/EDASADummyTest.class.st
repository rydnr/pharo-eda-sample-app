Class {
	#name : #EDASADummyTest,
	#superclass : #TestCase,
	#instVars : [
		'a',
		'b'
	],
	#category : #'EDASA-Domain-Tests'
}

{ #category : #tests }
EDASADummyTest >> testTautology [
	self assert: true
]
