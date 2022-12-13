Class {
	#name : #EDASABookCreated,
	#superclass : #EDASABookEvent,
	#instVars : [
		'author',
		'year',
		'isbn',
		'title'
	],
	#category : #'EDASA-Domain-Book'
}

{ #category : #'generated-v1' }
EDASABookCreated class >> latestVersion [

	^ 1

]

{ #category : #'generated-v1' }
EDASABookCreated class >> ofTenant: theTenant withAggregateId: theId commandId: theCommandId andAttributes: theAttrs [

	| result | 
	result := super ofTenant: theTenant withAggregateId: theId commandId: theCommandId andAttributes: theAttrs.

	theAttrs at: 'author' ifPresent: [ :v | result author: v ].
	theAttrs at: 'year' ifPresent: [ :v | result year: v ].
	theAttrs at: 'isbn' ifPresent: [ :v | result isbn: v ].
	theAttrs at: 'title' ifPresent: [ :v | result title: v ].
	^ result
]

{ #category : #'generated-v1' }
EDASABookCreated >> author [

	^ author
]

{ #category : #'generated-v1' }
EDASABookCreated >> author: newValue [

	author := newValue
]

{ #category : #'generated-v1' }
EDASABookCreated >> isbn [

	^ isbn
]

{ #category : #'generated-v1' }
EDASABookCreated >> isbn: newValue [

	isbn := newValue
]

{ #category : #'generated-v1' }
EDASABookCreated >> semanticEquals: anInstance [

	^ self class = anInstance class and: [ self id = anInstance id and: [ self author = anInstance author and: [  self id = anInstance id and: [  self isbn = anInstance isbn and: [  self tenant = anInstance tenant and: [  self title = anInstance title and: [  self version = anInstance version and: [  self year = anInstance year and: [  self aggregateRootClass = anInstance aggregateRootClass ] ] ] ] ] ] ]] ].
]

{ #category : #'generated-v1' }
EDASABookCreated >> semanticHash [

    ^ self class greaseString hash bitXor:( self id hash bitXor: ((self author hash bitXor: (self id hash bitXor: (self isbn hash bitXor: (self tenant hash bitXor: (self title hash bitXor: (self version hash bitXor: (self year hash bitXor: self aggregateRootClass hash)))))))))
]

{ #category : #'generated-v1' }
EDASABookCreated >> title [

	^ title
]

{ #category : #'generated-v1' }
EDASABookCreated >> title: newValue [

	title := newValue
]

{ #category : #'generated-v1' }
EDASABookCreated >> year [

	^ year
]

{ #category : #'generated-v1' }
EDASABookCreated >> year: newValue [

	year := newValue
]
