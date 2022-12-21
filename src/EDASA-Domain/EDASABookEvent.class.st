Class {
	#name : #EDASABookEvent,
	#superclass : #EDASABaseEvent,
	#category : #'EDASA-Domain-Book'
}

{ #category : #meta }
EDASABookEvent class >> aggregateRootClass [

	<eventStoreCollection: 'Book'>
	^ EDASABook
]
