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
