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

{ #category : #accessing }
EDASASampleApplication class >> applicationName [

	^ 'Sample'
]

{ #category : #accessing }
EDASASampleApplication class >> sample1 [

	^ self
		  withName: 'Sample-1'
		  description: 'Sample 1'
		  andIconName: #app1
]

{ #category : #accessing }
EDASASampleApplication class >> sample2 [

	^ self
		  withName: 'Sample-2'
		  description: 'Sample 2'
		  andIconName: #app2
]

{ #category : #'reset - events' }
EDASASampleApplication >> resetEventSubscriptions [

	
]

{ #category : #'setup - events' }
EDASASampleApplication >> setupEventSubscriptions [
]
