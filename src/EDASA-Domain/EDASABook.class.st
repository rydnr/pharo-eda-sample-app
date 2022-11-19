Class {
	#name : #EDASABook,
	#superclass : #EDAAggregateRoot,
	#instVars : [
		'author',
		'year',
		'isbn',
		'title'
	],
	#category : #'EDASA-Domain-Book'
}

{ #category : #'generated-v1' }
EDASABook >> applyBookCreatedv1: anEvent [

	self id: anEvent id.
	self author: anEvent author.
	self isbn: anEvent isbn.
	self title: anEvent title.
	self year: anEvent year.

]

{ #category : #'generated-v1' }
EDASABook >> author [

	^ author
]

{ #category : #'generated-v1' }
EDASABook >> author: newValue [

	author := newValue
]

{ #category : #'generated-v1' }
EDASABook >> handleCreateBook: aCommand [
	<useAsCommandHandlerFor: #EDASACreateBook>

	| theTenant theId theCommandId theAttrs |
	theId := UUID new greaseString.
	theTenant := aCommand tenant.
	theCommandId := aCommand commandId.
	theAttrs := self class buildCommonArgsForCommand: aCommand.
	aCommand author ifNotNil: [ :v | theAttrs at: 'author' put: v ].
	aCommand year ifNotNil: [ :v | theAttrs at: 'year' put: v ].
	aCommand isbn ifNotNil: [ :v | theAttrs at: 'isbn' put: v ].
	aCommand title ifNotNil: [ :v | theAttrs at: 'title' put: v ].
	^ EDASABookCreated
		ofTenant: theTenant withAggregateId: theId commandId: theCommandId andAttributes: theAttrs

]

{ #category : #'command handling' }
EDASABook >> handleCreateBookv1: aCommand [

	<useAsCommandHandlerFor: #EDASACreateBook>
	self flag: #TODO
]

{ #category : #'generated-v1' }
EDASABook >> isbn [

	^ isbn
]

{ #category : #'generated-v1' }
EDASABook >> isbn: newValue [

	isbn := newValue
]

{ #category : #'generated-v1' }
EDASABook >> retrieveBookRepository [

	^ EDASABookRepository uniqueInstance

]

{ #category : #'generated-v1' }
EDASABook >> semanticEquals: anInstance [

	^ self class = anInstance class and: [ self id = anInstance id and: [ self author = anInstance author and: [  self year = anInstance year and: [  self id = anInstance id and: [  self title = anInstance title and: [  self isbn = anInstance isbn ] ] ] ]] ].
]

{ #category : #'generated-v1' }
EDASABook >> semanticHash [

    ^ self class greaseString hash bitXor:( self id hash bitXor: ((self author hash bitXor: (self year hash bitXor: (self id hash bitXor: (self title hash bitXor: self isbn hash))))))
]

{ #category : #'generated-v1' }
EDASABook >> title [

	^ title
]

{ #category : #'generated-v1' }
EDASABook >> title: newValue [

	title := newValue
]

{ #category : #'generated-v1' }
EDASABook >> year [

	^ year
]

{ #category : #'generated-v1' }
EDASABook >> year: newValue [

	year := newValue
]
