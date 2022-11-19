Class {
	#name : #EDASABook,
	#superclass : #EDAAggregateRoot,
	#category : #'EDASA-Domain'
}

{ #category : #'as yet unclassified' }
EDASABook >> handleCreateBookv1: aCommand [

	<useAsCommandHandlerFor: #EDASACreateBook>
	self flag: #TODO
]
