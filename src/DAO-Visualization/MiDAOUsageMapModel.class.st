Class {
	#name : 'MiDAOUsageMapModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'entities'
	],
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'as yet unclassified' }
MiDAOUsageMapModel >> childrenOf: anEntity [

	^ anEntity attributes
]
