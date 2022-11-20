Trait {
	#name : #EDASATBookTestHelper,
	#category : #'EDASA-Domain-Tests-Book'
}

{ #category : #'generated-v1' }
EDASATBookTestHelper classSide >> ofTenant: newTenant withAggregateId: newId commandId: newCommandId andAttributes: newAttributes [

	| result | 
	result := self new.
	result id: UUID new asString.
	result commandId: newCommandId.
	result timestamp: DateAndTime now asUTC.
	result author: (newAttributes at: 'author').
	result isbn: (newAttributes at: 'isbn').
	result title: (newAttributes at: 'title').
	result year: (newAttributes at: 'year').
	^ result
]

{ #category : #'generated-v1' }
EDASATBookTestHelper >> buildBookCreatedEventFromFile: aFile [

	| eventMessage eventJson eventMeta eventBody evtAttributes evtCommandId evtTenant evtId evtTimestamp |
	eventMessage := self readFile: aFile.
	eventJson := NeoJSONReader fromString: eventMessage.
	eventMeta := eventJson at: #meta.
	eventBody := eventJson at: #body.
	evtAttributes := Dictionary new.
	evtAttributes at: 'version' put: (eventMeta at: 'version').
	evtAttributes at: 'aggregateRootVersion' put: (eventBody at: 'version').
	evtTenant := eventBody at: 'tenant'.
	evtId := eventBody at: 'id'.
	evtCommandId := eventMeta at: 'correlationId' ifAbsent: [ 'missing' ].
	evtTimestamp := eventBody at: 'timestamp' ifAbsent: [ nil ].
	evtTimestamp ifNil: [ evtTimestamp := eventMeta at: 'timestamp' ifAbsent: [ nil ] ].
	evtTimestamp ifNotNil: [ :t | evtAttributes at: 'timestamp' put: evtTimestamp ].
	eventBody at: 'author' ifPresent: [ :v | evtAttributes at: 'author' put: v ].
	eventBody at: 'isbn' ifPresent: [ :v | evtAttributes at: 'isbn' put: v ].
	eventBody at: 'title' ifPresent: [ :v | evtAttributes at: 'title' put: v ].
	eventBody at: 'year' ifPresent: [ :v | evtAttributes at: 'year' put: v ].
	^ EDASABookCreated ofTenant: evtTenant withAggregateId: evtId commandId: evtCommandId andAttributes: evtAttributes

]

{ #category : #'generated-v1' }
EDASATBookTestHelper >> buildBookCreatedSampleEventWithId: evtId andCommandId: inputCommandId [

	| result |
	result := EDASATestBookCreated fromEvent: (self buildBookCreatedEventFromFile: self readBookCreatedFromFile).
	result id: evtId.
	result commandId: inputCommandId.
	^ result

]

{ #category : #'generated-v1' }
EDASATBookTestHelper >> buildCreateBookSampleCommand [

    | commandMessage commandJson commandMeta commandBody cmdTenant cmdCommandId cmdVersion cmdContractVersion cmdAttributes result |
	commandMessage := self readCreateBookFromFile.
	commandJson := NeoJSONReader fromString: commandMessage.
	commandMeta := commandJson at: #meta.
	commandBody := commandJson at: #body.
	cmdTenant := commandBody at: 'tenant' ifPresent: [ :v | v ] ifAbsent: [ nil ].
	cmdCommandId := commandMeta at: 'id' ifPresent: [ :v | v ] ifAbsent: [ UUID new greaseString ].
	cmdAttributes := Dictionary new.
	cmdContractVersion := commandMeta at: 'version' ifAbsent: [ 1 ].
	cmdAttributes at: 'version' put: cmdContractVersion.
	cmdVersion := commandBody at: 'version' ifAbsent: [ 0 ].
	cmdAttributes at: 'aggregateRootVersion' put: cmdVersion.
	commandBody at: 'author' ifPresent: [ :v | cmdAttributes at: 'author' put: v ].
	commandBody at: 'isbn' ifPresent: [ :v | cmdAttributes at: 'isbn' put: v ].
	commandBody at: 'tenant' ifPresent: [ :v | cmdAttributes at: 'tenant' put: v ].
	commandBody at: 'title' ifPresent: [ :v | cmdAttributes at: 'title' put: v ].
	commandBody at: 'year' ifPresent: [ :v | cmdAttributes at: 'year' put: v ].
	result := EDASACreateBook ofTenant: cmdTenant withCommandId: cmdCommandId aggregateRootVersion: cmdVersion andAttributes: cmdAttributes.
	commandBody at: 'id' ifPresent: [ :v | result aggregateRootId: v ].
	result version: cmdContractVersion.
	result aggregateRootVersion: cmdVersion.
	^ result

]

{ #category : #'generated-v1' }
EDASATBookTestHelper >> readBookCreatedFromFile [

	^ self readFile: (FileSystem disk workingDirectory  / 'Sample-1' / 'contracts' / 'events' / 'v1' / 'book-created.example.json')

]

{ #category : #'generated-v1' }
EDASATBookTestHelper >> readCreateBookFromFile [

	^ self readFile: (FileSystem disk workingDirectory  / 'Sample-1' / 'contracts' / 'commands' / 'v1' / 'create-book.example.json')

]
