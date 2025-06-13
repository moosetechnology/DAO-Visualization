Class {
	#name : 'MiDAOUsageMapBuilder',
	#superclass : 'HSimpleVisualizationBuilder',
	#instVars : [
		'highlightShapes',
		'nodeStyle',
		'widthMetricThreshold'
	],
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'as yet unclassified' }
MiDAOUsageMapBuilder >> doubleClickExpandCollapse: aShape [

	aShape model expandCollapse
]
