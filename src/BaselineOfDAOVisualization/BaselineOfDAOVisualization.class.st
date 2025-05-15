Class {
	#name : 'BaselineOfDAOVisualization',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDAOVisualization',
	#package : 'BaselineOfDAOVisualization'
}

{ #category : 'baselines' }
BaselineOfDAOVisualization >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Packages" spec package: 'DAO-Visualization' ]
]
