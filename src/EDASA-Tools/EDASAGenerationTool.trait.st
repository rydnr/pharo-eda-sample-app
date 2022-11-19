Trait {
	#name : #EDASAGenerationTool,
	#traits : 'EDACSourceCodeHelper + EDATCheckerHelper',
	#classTraits : 'EDACSourceCodeHelper classTrait + EDATCheckerHelper classTrait',
	#category : #'EDASA-Tools'
}

{ #category : #testing }
EDASAGenerationTool >> isAggregate: word for: appPrefix from: predefinedAggregates inApplication: anEDAApplication [
	| result aggregate |
	aggregate := anEDAApplication eventClassPrefix , word capitalized.
	result := (Smalltalk hasClassNamed: aggregate asSymbol)
		ifTrue: [ (EDAAggregateRoot subclasses select: [ :cls | cls = (self class environment at: aggregate asSymbol) ]) size = 1 ]
		ifFalse: [ predefinedAggregates includes: (self toCamelCase: word asCamelCase) ].
	^ result
]

{ #category : #testing }
EDASAGenerationTool >> isAggregate: word inApplication: anEDAApplication [

	^ self
		  isAggregate: word
		  for: anEDAApplication commandClassPrefix
		  from: anEDAApplication predefinedAggregates
		inApplication: anEDAApplication
]

{ #category : #testing }
EDASAGenerationTool >> isCommand: fileName [
	^ fileName parent parent basename = 'commands'
]

{ #category : #testing }
EDASAGenerationTool >> listAllContractFiles: type forVersion: anInteger inApplication: anEDAApplication [

	| folder |
	folder := anEDAApplication contractsFolder / type
	          / ('v' , anInteger greaseString).
	^ folder children select: [ :file | 
		  file basename endsWithSubCollection: '.example.json' ]
]

{ #category : #testing }
EDASAGenerationTool >> readCommandFromContract: aString version: anInteger inApplication: anEDAApplication [

	^ self readFromContract: aString type: 'commands' version: anInteger inApplication: anEDAApplication
]

{ #category : #testing }
EDASAGenerationTool >> readEventFromContract: aString version: anInteger inApplication: anEDAApplication [
	^ self readFromContract: aString type: 'events' version: anInteger inApplication: anEDAApplication
]

{ #category : #testing }
EDASAGenerationTool >> readFromContract: aString type: type version: anInteger inApplication: anEDAApplication [
	| file result |
	file := FileSystem workingDirectory / anEDAApplication name / 'contracts' / type / ('v' , anInteger greaseString) / aString.
	file := file exists
		ifTrue: [ file ]
		ifFalse: [ FileSystem workingDirectory / anEDAApplication name / 'contracts' / type / ('v' , anInteger greaseString)
				/ (aString , '.example.json') ].
	result := file exists
		ifTrue: [ self readFromContract: [ file ] ]
		ifFalse: [ nil ].
	^ result
]

{ #category : #testing }
EDASAGenerationTool >> removeContractFileSuffix: aString [ 

	^ aString copyWithRegex: '\.example\.json$' matchesReplacedWith: ''
]

{ #category : #testing }
EDASAGenerationTool >> retrieveAggregateFromExistingAggregateMethod: json inApplication: anEDAApplication [

	| result aux |
	result := nil.
	aux := (json at: #meta) at: #type ifAbsent: [ nil ].
	aux
		ifNotNil: [ :arg | 
			| handlerScanner command |
			command := anEDAApplication eventClassPrefix , (self toCamelCase: aux).
			handlerScanner := EDAPragmaCommandHandlerMethodsScanner
				scannerPragma: #useAsCommandHandlerFor:
				from: EDAAggregateRoot.
			(handlerScanner allCommandHandlerMethods
				select: [ :assoc | (self classExists: command) and: [ assoc key = (self class environment at: command asSymbol ifAbsent: [ nil ] ) ] ])
				do: [ :item | result := self removePrefix: anEDAApplication eventClassPrefix from: item value methodClass greaseString ] ].
	^ result
]

{ #category : #testing }
EDASAGenerationTool >> retrieveAggregateFromFile: fileName inApplication: anEDAApplication [

	| result |
	result := self
		          retrieveAggregateFromFileIfPossible: fileName
		          inApplication: anEDAApplication.
	(result isNil and: [ (self isCommand: fileName) not ]) ifTrue: [ 
		| commandFile |
		commandFile := self
			               retrieveCommandFileFromEventFile: fileName
			               inApplication: anEDAApplication.
		commandFile ifNotNil: [ :file | 
			result := self
				          retrieveAggregateFromFileIfPossible: file
				          inApplication: anEDAApplication ] ].
	result ifNil: [ EDATUnsupportedFile new signal ].
	^ result
]

{ #category : #testing }
EDASAGenerationTool >> retrieveAggregateFromFileIfPossible: fileName inApplication: anEDAApplication [

	| result stream contents json |
	fileName exists
		ifTrue: [ 
			stream := fileName readStream.
			contents := stream contents.
			stream close.
			json := NeoJSONReader fromString: contents.
			result := self retrieveAggregateFromAggregateKey: json.
			result ifNil: [ 
				result := self
					          retrieveAggregateFromExistingAggregateMethod: json
					          inApplication: anEDAApplication ].
			result ifNil: [ 
				result := self
					          retrieveAggregateFromCommandType: json ].
			result ifNil: [ 
				result := self
					          retrieveAggregateFromFileName: fileName
					          inApplication: anEDAApplication ] ]
		ifFalse: [ result := nil ].
	^ result
]

{ #category : #testing }
EDASAGenerationTool >> retrieveAggregateFromFileName: file inApplication: anEDAApplication [
	| result aux found |
	found := false.
	aux := '\.example\.json$' asRegexIgnoringCase copy: file basename replacingMatchesWith: ''.
	(aux allRegexMatches: '([^.]*)')
		do: [ :word | 
			(self isAggregate: word)
				ifTrue: [ found := true.
					result := word capitalized ] ].
	^ result
]

{ #category : #testing }
EDASAGenerationTool >> retrieveAggregateIdAttributeFor: aggregate inApplication: anEDAApplication [
	| result methods |
	methods := (self
		retrieveMethodsInClass: (Smalltalk at: (anEDAApplication commandClassPrefix , aggregate) asSymbol) name
		withPragma: 'aggregateId') collect: [ :m | m selector ].
	methods isEmpty
		ifTrue: [ result := nil ]
		ifFalse: [ result := methods first ].
	^ result
]

{ #category : #testing }
EDASAGenerationTool >> retrieveCommandFile: aString version: anInteger inApplication: anEDAApplication [
	^ self retrieveFile: aString type: 'commands' version: anInteger inApplication: anEDAApplication
]

{ #category : #testing }
EDASAGenerationTool >> retrieveCommandFileFromEventFile: fileName inApplication: anEDAApplication [
	| version |
	version := fileName parent basename.
	^ fileName parent parent parent / 'commands' / version / ((self commandNameFor: (self removeSuffix: '.example.json' fromFileName: fileName)) , '.example.json')
]

{ #category : #testing }
EDASAGenerationTool >> retrieveFile: aString type: type version: anInteger inApplication: anEDAApplication [
	| result |
	result := FileSystem workingDirectory / anEDAApplication name / 'contracts' / type / ('v' , anInteger asString) / aString.
	result exists
		ifFalse: [ result := FileSystem workingDirectory / anEDAApplication name / 'contracts' / type / ('v' , anInteger asString) / (aString , '.example.json') ].
	result exists
		ifFalse: [ result := nil ].
	^ result
]
