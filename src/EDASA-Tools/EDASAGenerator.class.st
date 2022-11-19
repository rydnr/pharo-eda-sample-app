Class {
	#name : #EDASAGenerator,
	#superclass : #Object,
	#traits : 'EDASAGenerationTool + EDACLogging + EDACLanguageHelper',
	#classTraits : 'EDASAGenerationTool classTrait + EDACLogging classTrait + EDACLanguageHelper classTrait',
	#category : #'EDASA-Tools'
}

{ #category : #configuration }
EDASAGenerator class >> excludedContracts [

	^ #( )
]

{ #category : #api }
EDASAGenerator >> generateAllForVersion: aVersion inApplication: anEDAApplication [

	| commands |
	commands := self
		            listAllContractFiles: 'commands'
		            forVersion: aVersion
		            inApplication: anEDAApplication.
	commands do: [ :file | 
		(self isExcluded: file) ifFalse: [ 
			| generator anAggregate |
			anAggregate := self
				               retrieveAggregateFromFile: file
				               inApplication: anEDAApplication.
			generator := EDATCompositeGenerator
				             fromExampleFile: file
				             version: aVersion
				             application: anEDAApplication
				             aggregate: anAggregate
				             commandNameResolver:
				             EDATDefaultEnglishCommandNameResolver new
				             andEventNameResolver:
				             EDATDefaultEnglishEventNameResolver new.
			generator generate ] ]
]

{ #category : #api }
EDASAGenerator >> generateAllInApplication: anEDAApplication [

	^ (1 to: (self retrieveMaxVersionInApplication: anEDAApplication))
		  do: [ :i | 
		  self generateAllForVersion: i inApplication: anEDAApplication ]
		  displayingProgress: [ :i | 
		  'Generating code based on contracts version ' , i greaseString ]
]

{ #category : #api }
EDASAGenerator >> isExcluded: file [
	^ self class excludedContracts anySatisfy: [ :c | (c , '.example.json') = file basename ]
]

{ #category : #api }
EDASAGenerator >> regenerateAllForVersion: version inApplication: anEDAApplication [

	self removeAllForVersion: version inApplication: anEDAApplication.
	^ self generateAllForVersion: version inApplication: anEDAApplication
]

{ #category : #api }
EDASAGenerator >> regenerateAllInApplication: anEDAApplication [

	self removeAllInApplication: anEDAApplication.
	self generateAllInApplication: anEDAApplication
]

{ #category : #api }
EDASAGenerator >> removeAllForVersion: version inApplication: anEDAApplication [

	#( 'EDASA-Domain' 'EDASA-Domain-Tests' ) asOrderedCollection do: [ 
		:pkg | 
		(RPackageOrganizer default packageNamed: pkg) definedClassesDo: [ 
			:cls | 
			| clz |
			clz := self class environment at: cls.
			(clz methodsInProtocol: (self generatedProtocolFor: version)) do: [ 
				:method | clz removeSelector: method selector ].
			(clz class methodsInProtocol: (self generatedProtocolFor: version)) 
				do: [ :method | clz class removeSelector: method selector ] ] ]
]

{ #category : #api }
EDASAGenerator >> removeAllInApplication: anEDAApplication [

	^ (1 to: (self retrieveMaxVersionInApplication: anEDAApplication))
		  do: [ :i | 
		  self removeAllForVersion: i inApplication: anEDAApplication ]
		  displayingProgress: [ :i | 
			  'Removing generated code for contracts version ' , i greaseString ]
]

{ #category : #api }
EDASAGenerator >> retrieveMaxVersionInApplication: anEDAApplication [

	| block commandVersion eventVersion |
	block := [ :subfolder | 
	         ((anEDAApplication contractsFolder
	           / subfolder directoriesMatching: 'v*') collect: [ :d | 
		          (self removePrefix: 'v' from: d basename) greaseInteger ])
		         asSortedCollection last ].
	commandVersion := block value: 'commands'.
	eventVersion := block value: 'events'.
	commandVersion = eventVersion ifFalse: [ 
		self logErrorMessage: 'Maximum command version (' , commandVersion
			, ') and maximum event version (' , eventVersion , ') mismatch' ].
	^ commandVersion max: eventVersion
]
