Class {
	#name : #EDASATestBookCreated,
	#superclass : #EDASABookCreated,
	#traits : 'EDATTestEvent',
	#classTraits : 'EDATTestEvent classTrait',
	#category : #'EDASA-Domain-Tests-Book'
}

{ #category : #'generated-v1' }
EDASATestBookCreated class >> fromEvent: newEvent [


	| result |
	result := self new.
	result tenant: newEvent tenant.
	result id: '<ANYTHING>'.
	result commandId: newEvent commandId.
	result version: newEvent class latestVersion.
	result aggregateRootVersion: newEvent aggregateRootVersion.
	result timestamp: '<ANYTHING>'.
	result author: newEvent author.
	result isbn: newEvent isbn.
	result title: newEvent title.
	result year: newEvent year.
	^ result
]

{ #category : #'generated-v1' }
EDASATestBookCreated >> = anInstance [

	^  (anInstance class isKindOf: EDASABookCreated class) and: [
		(self attribute: self aggregateRootClass matches: anInstance aggregateRootClass) and: [
		(self attribute: self tenant matches: anInstance tenant) and: [
				(self attribute: self id named: 'id' matches: anInstance id) and: [
					(self attribute: self aggregateRootVersion matches: anInstance aggregateRootVersion) and: [
						(self attribute: self timestamp named: 'timestamp' matches: anInstance timestamp) and: [
							(self attribute: self commandId named: 'correlationId' matches: anInstance commandId) and: [
								 (self attribute: self author named: 'author' matches: anInstance author) and: [  (self attribute: self isbn named: 'isbn' matches: anInstance isbn) and: [  (self attribute: self title named: 'title' matches: anInstance title) and: [  (self attribute: self year named: 'year' matches: anInstance year) ] ] ]
						]
						]
					]
				]
			]
		]
	]

]
