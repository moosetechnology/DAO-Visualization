Class {
	#name : 'MiDAOUsageMapPresenter',
	#superclass : 'MiPresenter',
	#instVars : [
		'specModel',
		'daoVisualisation'
	],
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'accessing' }
MiDAOUsageMapPresenter class >> daoVisualizationClass [
	^ MiDAOUsageMapVisualization
]

{ #category : 'accessing' }
MiDAOUsageMapPresenter >> model [

	^ specModel
]

{ #category : 'accessing' }
MiDAOUsageMapPresenter >> model: anObject [

	specModel := anObject
]

{ #category : 'accessing' }
MiDAOUsageMapPresenter >> visualization [

	^ daoVisualisation
]
