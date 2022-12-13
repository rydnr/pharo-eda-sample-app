Class {
	#name : #EDASABookApplication,
	#superclass : #EDAApplication,
	#category : #'EDASA-Application'
}

{ #category : #accessing }
EDASABookApplication class >> applicationName [

	^ 'Book'
]

{ #category : #subclassresponsibility }
EDASABookApplication >> commandClassPrefix [

	^ 'EDASA'
]

{ #category : #subclassresponsibility }
EDASABookApplication >> eventBaseClass [

	^ EDASABookEvent
]

{ #category : #subclassresponsibility }
EDASABookApplication >> eventClassPrefix [

	^ 'EDASA'
]

{ #category : #initialization }
EDASABookApplication >> resetEventSubscriptions [

	
]

{ #category : #'setup - events' }
EDASABookApplication >> setupEventSubscriptions [

	
]
