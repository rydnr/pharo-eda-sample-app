Class {
	#name : #EDASABookApplication,
	#superclass : #EDAApplication,
	#category : #'EDASA-Application'
}

{ #category : #accessing }
EDASABookApplication class >> applicationName [

	^ 'Book'
]

{ #category : #'instance creation' }
EDASABookApplication class >> sample1 [

	^ self
		  withName: 'Sample-1'
		  description: 'Sample 1'
		  andIconName: #app1
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
