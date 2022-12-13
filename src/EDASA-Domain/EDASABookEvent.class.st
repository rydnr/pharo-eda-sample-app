Class {
	#name : #EDASABookEvent,
	#superclass : #EDASABaseEvent,
	#category : #'EDASA-Domain'
}

{ #category : #meta }
EDASABookEvent class >> aggregateRootClass [

	<eventStoreCollection: 'Book'>
	^ EDASABook
]
