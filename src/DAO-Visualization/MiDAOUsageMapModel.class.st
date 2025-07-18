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
MiDAOUsageMapModel >> childrenOf: anEntity [

	^ anEntity attributes
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
MiDAOUsageMapModel >> widthMetric [

	^ #numberOfAttributes
]
