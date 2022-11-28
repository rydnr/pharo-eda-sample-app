Class {
	#name : #EDASABookRepository,
	#superclass : #EDAAggregateRepository,
	#category : #'EDASA-Domain-Book'
}

{ #category : #setup }
EDASABookRepository class >> belongTo: anEDAApplication [

	^ anEDAApplication isKindOf: EDASASampleApplication
]
