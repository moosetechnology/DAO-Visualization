Class {
	#name : 'MiDAOUsageMapVisualization',
	#superclass : 'MiAbstractHierarchicalVisualization',
	#instVars : [
		'model'
	],
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'running' }
MiDAOUsageMapVisualization >> buildInCanvas: aCanvas [
	owner model entities ifNil: [ ^ self ].

	builder := MiDAOUsageMapBuilder new
		           mapModel: owner model;
		           container: aCanvas;
		           yourself.
	builder build.
	
	^ aCanvas @ RSCanvasController new noLegend
]
