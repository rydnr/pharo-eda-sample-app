"
**Class**

I'm a baseline to load PharoEDA Sample App.

**Responsibilities**

Guide Metacello to load PharoEDA-Sample-App with its dependencies.

**Collaborators**

Metacello
"
Class {
	#name : #BaselineOfPharoEDASampleApp,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoEDASampleApp
}

{ #category : #meta }
BaselineOfPharoEDASampleApp class >> declareGroupsIn: spec [

	spec
		group: 'core' with: #( #'EDASA-Application' #'EDASA-Domain' #'EDASA-Tools');
		group: 'tests'
		with: #( #'EDASA-Domain-Tests' #'EDASA-Application-Tests' );
		group: 'publishing'
		with: #( 'core' 'tests' 'Pillar' 'PillarCore' 'PillarDocumentModel'
			   'PillarMicro' );
		group: 'default' with: #( 'core' 'tests' )
]

{ #category : #meta }
BaselineOfPharoEDASampleApp class >> declarePackagesIn: spec [

	spec
		package: #'EDASA-Domain'
		with: [ spec requires: #( 'PharoEDA' ) ];
		package: #'EDASA-Domain-Tests'
		with: [ spec requires: #( 'EDASA-Domain' ) ];
		package: #'EDASA-Application'
		with: [ spec requires: #( 'EDASA-Domain' ) ];
		package: #'EDASA-Application-Tests'
		with: [ spec requires: #( 'EDASA-Application' ) ];
		package: #'EDASA-Tools'
		with: [ spec requires: #( 'PharoEDATools' ) ]
]

{ #category : #dependencies }
BaselineOfPharoEDASampleApp class >> includePharoEDA: spec [
	spec
		baseline: 'PharoEDA'
		with: [ spec repository: 'github://rydnr/pharo-eda:settings' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDASampleApp class >> includePharoEDATools: spec [
	spec
		baseline: 'PharoEDATools'
		with: [ spec repository: 'github://rydnr/pharo-eda-tools:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDASampleApp class >> includePillar: spec [
	spec
		baseline: 'Pillar'
			with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ];
		baseline: 'PillarCore'
			with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ];
		baseline: 'PillarDocumentModel'
			with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ];
		baseline: 'PillarExporter'
			with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ];
		baseline: 'PillarMicro'
			with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ];
		baseline: 'PillarApp'
			with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ].
	^ spec
]

{ #category : #baselines }
BaselineOfPharoEDASampleApp >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec blessing: #baseline.
		spec postLoadDoIt: #postload:package:.
		self class includePharoEDA: spec;
		 includePharoEDATools: spec;
		 includePillar: spec;
		 declarePackagesIn: spec;
		 declareGroupsIn: spec ]
]

{ #category : #hooks }
BaselineOfPharoEDASampleApp >> postload: loader package: packageSpec [

	| location |
	location := (IceRepository registry detect: [ :each | 
		             each name = 'pharo-eda-sample-app' ]) location.
	EDACIconProvider addDefaultLocation: location / 'resources' / 'icons'.
	EDACTranslationProvider addDefaultLocation:
		location / 'resources' / 'l10n'
]
