Class {
	#name : #EDASABookIntegrationTestCase,
	#superclass : #Object,
	#category : #'EDASA-Application-Tests'
}

{ #category : #'generated-v1' }
EDASABookIntegrationTestCase >> testCreateBook [

	| aggregateRootId previousEvents command commandMessage expectedEvent expectedMessage expectedRoutingKey |
	previousEvents := OrderedCollection new.
	command := self buildCreateBookSampleCommand.
	commandMessage := self readCreateBookFromFile.
	aggregateRootId := command aggregateRootId.
	expectedEvent := self buildBookCreatedSampleEventWithId: aggregateRootId andCommandId: command commandId.
	expectedMessage := self readBookCreatedFromFile.
	expectedRoutingKey := 'book.created'.
	"TODO: Add XXXCreated events to previousEvents collection,"
	"one for each dependency, if any. Do not forget to change "
	"protocol so the generator skips overriding your changes!"
	self flag: #TODO.
	self
		givenPreviousEvents: previousEvents ofTenant: command tenant
		whenReceiveCommandMessage: commandMessage
		thenStoreEvent: expectedEvent
		andPublishEventMessage: expectedMessage
		withRoutingKey: expectedRoutingKey

]
