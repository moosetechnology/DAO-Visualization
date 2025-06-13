Class {
	#name : 'MiDAOUsageMapStyle',
	#superclass : 'HDefaultStyle',
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

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
		       extent: rect extent + 20;
		       cornerRadius: self cornerRadius;
		       color: (self colorFor: node);
		       border: (self borderFor: node);
		       yourself.
	shape add: box.
	box pushBack.
	shape schildren: #(  ).

	shape
		propertyAt: #background put: box;
		adjustToChildren
]

{ #category : 'hooks' }
MiDAOUsageMapStyle >> buildCompositeFullNodeIn: shape [

	| childrenShapes node titleGroup title titleBox children boxChildren list |
	node := shape model.
	titleGroup := self labelAndIconFor: node.
	titleBox := RSBox new
		            extent: titleGroup extent + 20;
		            color: (self colorFor: node);
		            position: titleGroup position;
		            cornerRadius: self cornerRadius;
		            yourself.
	title := RSComposite new
		         add: titleBox;
		         addAll: titleGroup;
		         adjustToChildren;
		         yourself.
	shape propertyAt: #background put: titleBox.
	childrenShapes := node children collect: #asShape as: RSGroup.
	self layoutOn: childrenShapes parent: node.

	shape schildren: childrenShapes.
	childrenShapes do: [ :child | child sparent: shape ].
	children := childrenShapes asShape padding: 10.
	children useRTree.
	childrenShapes do: [ :child | child model position: child position ].
	title width < children width
		ifTrue: [
			titleBox width: children width.
			title adjustToChildren ]
		ifFalse: [ children width: title width ].
	boxChildren := self boxChildrenFor: node.

	list := self titleLocation = #below
		        ifTrue: [
			        {
				        children.
				        title } ]
		        ifFalse: [
			        {
				        title.
				        children } ].

	RSVerticalLineLayout new
		gapSize: 0;
		on: list.

	boxChildren
		cornerRadius: self cornerRadius;
		fromRectangle: children encompassingRectangle.

	shape
		add: title;
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
