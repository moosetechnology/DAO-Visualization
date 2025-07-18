"
A model for the DAOUsageMap browser
"
Class {
	#name : 'MiDAOUsageMapModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'entities',
		'scale'
	],
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'accessing' }
MiDAOUsageMapModel >> allClients [
	^ (self entities flatCollect: [ :e | self clientsOf: e ]) asSet asOrderedCollection
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> automaticColor [

	self changeTagsDuring: [ 
		self allClients
			do: [:client | self automaticColorForClient: client ].
	]
	
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> automaticColorForClient: aClient [

	| daos tags |
	daos := (aClient attributes collect: #declaredType) select: [ :type | self entities includes: type ].
	
	tags := (daos flatCollect: [ :dao | dao allTags ]) asSet asOrderedCollection.
	tags ifEmpty: [ ^ self ].
	tags size > 1 ifTrue: [ ^ self ].

	self removeTagOn: aClient.
	aClient tagWith: tags first
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> changeTagsDuring: aBlockClosure [
	| lastTag |
	lastTag := self selectedTag.
	aBlockClosure value.
	self selectedTag: lastTag
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> clientsOf: anEntity [

	^ (anEntity allClients
		   collect: [ :client | client parentType ]
		   thenReject: [ :client | client name endsWith: 'Test' ]) asSet
		  asOrderedCollection
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> entities [
	^ entities
]

{ #category : 'accessing' }
MiDAOUsageMapModel >> entities: anObject [
	entities := anObject
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> miSelectedItem [
	^ self entities
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> numberOfAllInvocationsFor: anEntity [

	^ self allClients inject: 0 into: [ :sum :client |
		  sum + (self numberOfInvocationFor: anEntity from: client) ]
]

{ #category : 'utils' }
MiDAOUsageMapModel >> numberOfClientsFor: anEntity [

	^ (self clientsOf: anEntity) size
]

{ #category : 'building' }
MiDAOUsageMapModel >> numberOfInvocationFor: anEntity from: aClient [

	^ (aClient queryAllOutgoingInvocations select: [ :invocation |
		   invocation candidates first parentType = anEntity ]) size
]

{ #category : 'removing' }
MiDAOUsageMapModel >> removeTagOn: aMooseEntity [
	aMooseEntity allTags
		detect: [ :aTag | aTag isHidden not ]
		ifOne: [ :aTag | aTag removeReference: aMooseEntity ]
		ifNone: [ "nothing" ]
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> scale [
	^ scale ifNil: [
		  | invocs |
		  invocs := self entities asOrderedCollection collect: [ :entity |
			            self numberOfAllInvocationsFor: entity. ].

		  scale := NSScale linear
			           range: { 10. 100 };
			           domain: {
					           invocs min.
					           invocs max } ]
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> usedEntitiesBy: aClient [

	^ (aClient attributes collect: #declaredType) select: [ :each |
		  self entities includes: each ]
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> widthMetric [

	^ #numberOfAttributes
]
