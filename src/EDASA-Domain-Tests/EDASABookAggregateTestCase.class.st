Class {
	#name : #EDASABookAggregateTestCase,
	#superclass : #BabyMock2TestCase,
	#traits : 'EDATDomainBDD + EDASATBookTestHelper',
	#classTraits : 'EDATDomainBDD classTrait + EDASATBookTestHelper classTrait',
	#category : #'EDASA-Domain-Tests-Book'
}

{ #category : #'generated-v1' }
EDASABookAggregateTestCase >> testCreateBook [

	| command event |
	command := self buildCreateBookSampleCommand.
	event := self buildBookCreatedSampleEventWithId: '<ANYTHING>' andCommandId: command commandId.
	event aggregateRootVersion: command aggregateRootVersion + 1.	self
		givenAggregate: #EDASABook
			withEvents: OrderedCollection new
			whenReceiveCommand: command
			thenEvent: event

]
