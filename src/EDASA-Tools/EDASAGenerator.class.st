Class {
	#name : #EDASAGenerator,
	#superclass : #Object,
	#traits : 'EDATGenerationTool + EDACLogging + EDACLanguageHelper',
	#classTraits : 'EDATGenerationTool classTrait + EDACLogging classTrait + EDACLanguageHelper classTrait',
	#category : #'EDASA-Tools'
}

{ #category : #api }
EDASAGenerator >> packages [

	^ OrderedCollection with: 'EDASA-Domain' with: 'EDASA-Domain-Tests'
]
