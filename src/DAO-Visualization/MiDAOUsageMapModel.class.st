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

{ #category : 'accessing' }
MiDAOUsageMapModel >> entities [
	^ entities
]

{ #category : 'accessing' }
MiDAOUsageMapModel >> entities: anObject [
	entities := anObject
]

{ #category : 'accessing' }
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

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> widthMetric [

	^ #numberOfAttributes
]
