Class {
	#name : #EDASACreateBook,
	#superclass : #EDACommand,
	#instVars : [
		'author',
		'year',
		'isbn',
		'title'
	],
	#category : #'EDASA-Domain-Book'
}

{ #category : #'generated-v1' }
EDASACreateBook class >> aggregateRootClass [

	^ EDASABook

]

{ #category : #'generated-v1' }
EDASACreateBook class >> latestVersion [

	^ 1

]

{ #category : #'generated-v1' }
EDASACreateBook class >> ofTenant: theTenant withCommandId: theCommandId aggregateRootVersion: theVersion andAttributes: theAttributes [

	<sample1CommandName: #CREATE_BOOK>
	| result |
	result := super ofTenant: theTenant withCommandId: theCommandId aggregateRootVersion: theVersion andAttributes: theAttributes.
	result version: 1.

	theAttributes at: 'author' ifPresent: [ :v | result author: v ].
	theAttributes at: 'year' ifPresent: [ :v | result year: v ].
	theAttributes at: 'isbn' ifPresent: [ :v | result isbn: v ].
	theAttributes at: 'title' ifPresent: [ :v | result title: v ].
	^ result
]

{ #category : #'generated-v1' }
EDASACreateBook >> author [

	^ author
]

{ #category : #'generated-v1' }
EDASACreateBook >> author: newValue [

	author := newValue
]

{ #category : #'generated-v1' }
EDASACreateBook >> isbn [

	^ isbn
]

{ #category : #'generated-v1' }
EDASACreateBook >> isbn: newValue [

	isbn := newValue
]

{ #category : #'generated-v1' }
EDASACreateBook >> retrieveAggregateRootClass [

	^ self class aggregateRootClass

]

{ #category : #'generated-v1' }
EDASACreateBook >> semanticEquals: anInstance [

	^ self class = anInstance class and: [ self id = anInstance id and: [ self author = anInstance author and: [  self isbn = anInstance isbn and: [  self title = anInstance title and: [  self year = anInstance year ] ] ]] ].
]

{ #category : #'generated-v1' }
EDASACreateBook >> semanticHash [

    ^ self class greaseString hash bitXor:( self id hash bitXor: ((self author hash bitXor: (self isbn hash bitXor: (self title hash bitXor: self year hash)))))
]

{ #category : #'generated-v1' }
EDASACreateBook >> title [

	^ title
]

{ #category : #'generated-v1' }
EDASACreateBook >> title: newValue [

	title := newValue
]

{ #category : #'generated-v1' }
EDASACreateBook >> year [

	^ year
]

{ #category : #'generated-v1' }
EDASACreateBook >> year: newValue [

	year := newValue
]
