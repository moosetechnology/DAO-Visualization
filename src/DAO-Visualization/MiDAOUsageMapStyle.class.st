"
I am a style definition used by the DAOUsageMap visualization builder.
"
Class {
	#name : 'MiDAOUsageMapStyle',
	#superclass : 'HDefaultStyle',
	#instVars : [
		'model'
	],
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'accessing' }
MiDAOUsageMapStyle class >> color [
	^ Smalltalk ui theme baseColor alpha: 0.7
]

{ #category : 'hooks' }
MiDAOUsageMapStyle >> boxChildrenColorFor: anHNode [

	^ anHNode level odd
		  ifTrue: [ Color lightGray ]
		  ifFalse: [ Color veryLightGray ]
]

{ #category : 'hooks' }
MiDAOUsageMapStyle >> buildCompositeEmptyNodeIn: shape [

	| node box rect |
	node := shape model.
	shape addAll: (self labelAndIconFor: node).
	rect := shape children encompassingRectangle.
	box := RSBox new
		       position: rect floatCenter;
		       size: 10;
		       cornerRadius: self cornerRadius;
		       color: (self colorFor: node);
		       border: (self borderFor: node);
		       yourself.
	node level > 1 ifTrue: [
		box width: (self model scale scale:
				 (self model numberOfAllInvocationsFor: node rawModel)) ].
	shape add: box.
	box pushBack.
	shape schildren: #(  ).

	shape
		propertyAt: #background put: box;
		adjustToChildren
]

{ #category : 'hooks' }
MiDAOUsageMapStyle >> buildCompositeFullNodeIn: shape [

	| childrenShapes node children boxChildren |
	node := shape model.
	childrenShapes := node children collect: #asShape as: RSGroup.
	self layoutOn: childrenShapes parent: node.

	shape schildren: childrenShapes.
	childrenShapes do: [ :child | child sparent: shape ].
	children := childrenShapes asShape padding: 10.
	children useRTree.
	childrenShapes do: [ :child | child model position: child position ].
	boxChildren := self boxChildrenFor: node.

	boxChildren
		cornerRadius: self cornerRadius;
		fromRectangle: children encompassingRectangle.

	shape
		add: boxChildren;
		add: children.
	shape adjustToChildren
]

{ #category : 'private' }
MiDAOUsageMapStyle >> colorFor: node [

	^ node color ifNil: [ Smalltalk ui theme baseColor alpha: 0.7 ]
]

{ #category : 'hooks' }
MiDAOUsageMapStyle >> cornerRadius [

	^ 2
]

{ #category : 'hooks' }
MiDAOUsageMapStyle >> labelFor: anHNode [

	^ self baseLabel copy
		  text: ''
]
