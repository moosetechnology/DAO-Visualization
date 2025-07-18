"
This class provides the highlight system for MiDAOUsageMapBuilder, when there is a mouse left click on an inner box (kind-of permanent highlight)
"
Class {
	#name : 'MiDAOHighlightManager',
	#superclass : 'RSInteraction',
	#instVars : [
		'mapBuilder',
		'highlightedShapes'
	],
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'hooks' }
MiDAOHighlightManager >> highlightClass: aClass [

	highlightedShapes := mapBuilder shapes select: [ :shape |
		                     shape model rawModel = aClass ].
	highlightedShapes do: [ :shape |
		(shape propertyAt: #background) color: self class highlightColor ]
]

{ #category : 'initialization' }
MiDAOHighlightManager >> resetHighlights [

	highlightedShapes do: [ :shape | (shape propertyAt: #background) color: MiDAOUsageMapStyle color ].
	highlightedShapes := OrderedCollection new
]
