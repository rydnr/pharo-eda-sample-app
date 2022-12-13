"
I'm a class to show how an EDAApplication can be customized.

I do nothing, I'm useless, I have no responsibilities nor collaborators.

I only exist to illustrate how to write custom EDAApplication subclasses.
"
Class {
	#name : #EDASASampleApplication,
	#superclass : #EDAApplication,
	#category : #'EDASA-Application'
}

{ #category : #'instance creation' }
EDASASampleApplication class >> all [

	self sample1; sample2; sample3
]

{ #category : #accessing }
EDASASampleApplication class >> applicationName [

	^ 'Sample'
]

{ #category : #'instance creation' }
EDASASampleApplication class >> sample1 [

	^ EDASABookApplication sample1
]

{ #category : #'instance creation' }
EDASASampleApplication class >> sample2 [

	^ self
		  withName: 'Sample-2'
		  description: 'Sample 2'
		  andIconName: #app2
]

{ #category : #'instance creation' }
EDASASampleApplication class >> sample3 [

	^ self
		  withName: 'Sample-3'
		  description: 'Sample 3'
		  andIconName: #app3
]

{ #category : #subclassresponsibility }
EDASASampleApplication >> commandClassPrefix [

	^ 'EDASA'
]

{ #category : #subclassresponsibility }
EDASASampleApplication >> eventBaseClass [

	^ EDASABaseEvent
]

{ #category : #subclassresponsibility }
EDASASampleApplication >> eventClassPrefix [

	^ 'EDASA'
]

{ #category : #'reset - events' }
EDASASampleApplication >> resetEventSubscriptions [

	
]

{ #category : #'setup - events' }
EDASASampleApplication >> setupEventSubscriptions [
]
