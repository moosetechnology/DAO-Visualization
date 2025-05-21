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
