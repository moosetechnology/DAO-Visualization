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

{ #category : 'hooks' }
MiDAOUsageMapBuilder >> addInteractionsToShape: aShape [

	| node |
	aShape announcer: self nodeAnnouncer.
	node := aShape model.
	node
		removeInteractionIfPresent: self class;
		when: HCollapseEvent do: [ :evt |
			self rebuildShape: aShape.
			self normalizeShapes.
			self relayout: self container nodes parent: rootNode ]
		for: self;
		when: HExpandEvent
		do: [ :evt | self rebuildRootShape: aShape ]
		for: self
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> build [

	rootNode := HNode new.

	rootNode addAll: self createRootNodes.

	self renderIn: self container.

	^ self container
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> buildChildrenNodesFrom: anEntity [

	(anEntity usesFamixTrait: FamixTWithAttributes) ifFalse: [ ^ #(  ) ].

	^ ((self mapModel childrenOf: anEntity) collect: [ :childEntity |
		   self buildNodeFromEntity: childEntity ]) sort: #name ascending
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> buildNodeFromEntity: anEntity [

	^ HNode new
		  rawModel: anEntity;
		  name: anEntity fullDisplayString;
		  style: self nodeStyle;
		  addAll: (self buildChildrenNodesFrom: anEntity);
		  color: (self colorFromEntity: anEntity);
		  collapse;
		  yourself
]

{ #category : 'properties' }
MiDAOUsageMapBuilder >> childrenOf: anEntity [

	^ mapModel childrenOf: anEntity
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapBuilder >> colorFromEntity: anEntity [

	anEntity isClass ifTrue: [
		^ Color r: 212 / 255 g: 220 / 255 b: 220 / 255 ].
	anEntity isAttribute ifTrue: [
		^ Color r: 85 / 255 g: 114 / 255 b: 114 / 255 ].
	^ Smalltalk ui theme baseColor alpha: 0.7
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> createRootNodes [
	^ (self elements
		collect: [ :c | self buildNodeFromEntity: c ])
		sort: [ :a :b |
			(a rawModel perform: self mapModel widthMetric)
				> (b rawModel perform: self mapModel widthMetric) ]

]

{ #category : 'as yet unclassified' }
MiDAOUsageMapBuilder >> doubleClickExpandCollapse: aShape [

	aShape model expandCollapse
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> elements [
	^ self mapModel entities
]

{ #category : 'visiting' }
MiDAOUsageMapBuilder >> highlightableLinkedShapes [

	^ highlightShapes ifNil: [
		  highlightShapes := RSHighlightable new
			                     highlightShapes: [ :shape |
				                     | list |
				                     list := Set new.
				                     shape connectedLines do: [ :line |
						                     shape = line from
							                     ifTrue: [
								                     list add:
										                     (line to propertyAt: #background) ]
							                     ifFalse: [
								                     list add:
										                     (line from propertyAt: #background) ] ].
				                     list asOrderedCollection ];
			                     when: RSHighlightEvent do: [ :evt |
				                     | color |
				                     color := Color fromHexString: '9DD0B3'.
				                     highlightable
					                     record: evt shape
					                     selector: #color
					                     value: color ]
			                     for: self;
			                     when: RSUnHighlightEvent
			                     do: [ :evt |
				                     highlightable
					                     restore: evt shape
					                     selector: #color ]
			                     for: self;
			                     yourself ]
]

{ #category : 'hooks' }
MiDAOUsageMapBuilder >> nodeAnnouncer [
	"plug new events here"

	baseNode ifNotNil: [ ^ baseNode announcer ].
	baseNode := RSComposite new
		            @ self popup;
		            @
			            (HGhostDraggable new color:
					             Smalltalk ui theme caretColor);
		            @ self menuInteraction;
		            @ self highlightable;
		            @ self highlightableLinkedShapes;
		            @ RSNodeOnTopWhenPositionChanged new;
		            @ HResizeParentWhenChildMoves new;
		            yourself.

	baseNode
		when: RSMouseDoubleLeftClick
		do: [ :event | self doubleClickExpandCollapse: event shape ]
		for: self.

	^ baseNode announcer
]

{ #category : 'hooks' }
MiDAOUsageMapBuilder >> nodeLayout [

	^ RSFlowLayout new
		  gapSize: 3;
		  yourself
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> nodeStyle [

	^ nodeStyle ifNil: [ nodeStyle := MiDAOUsageMapStyle new ]
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> nodeStyle: anObject [

	^ nodeStyle := anObject 
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> normalizeMetric: metric threshold: threshold [
	"When all elements are homogeneous, we want to show that the difference is small by making them look similar. They are considered homogeneous when the difference between the min and max values of the metric is below the threshold."

	| min max |
	"start by finding min and max"
	min := SmallInteger maxVal.
	max := 0.
	self container nodes do: [ :shape |
		| value |
		value := shape model rawModel perform: metric.
		min := min min: value.
		max := max max: value ].

	"widen the domain by the difference if it is below the threshold, which reduces the effective range and thus makes the elements more similar"
	^ NSScale linear domain: (max - min > threshold
			   ifTrue: [
				   {
					   min.
					   max } ]
			   ifFalse: [
				   {
					   (min - max / 2 + min).
					   (max - min / 2 + max) } ])
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> normalizeShapes [

	self normalizeWidth.
	self container nodes do: [ :canvasShape |
		canvasShape model isExpanded ifFalse: [
			RSVerticalLineLayout new alignCenter on: canvasShape children.
			canvasShape adjustToChildren ] ]
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> normalizeWidth [

	| widthMetric scale |
	widthMetric := mapModel widthMetric.
	scale := self
		         normalizeMetric: widthMetric
		         threshold: self widthMetricThreshold.
	scale range: { 20. 400 }.
	self container nodes do: [ :each |
		(each propertyAt: #background) width:
			(scale scale: (each model rawModel perform: widthMetric)) ]
]

{ #category : 'rendering' }
MiDAOUsageMapBuilder >> renderIn: aCanvas [

	| rootShapes |
	aCanvas color: Smalltalk ui theme backgroundColor.

	rootShapes := self childrenShapes: aCanvas.
	shapes := rootShapes flatCollect: [ :s | s withAllSChildren ].
	self addInteractions: shapes.
	aCanvas schildren: rootShapes.
	aCanvas addAll: rootShapes.
	aCanvas @ self menuInteraction.
	rootNode
		when: HNodeAddedEvent
		do: [ :evt |
			| newShape |
			newShape := (self shapeFor: evt newChild) sparent: aCanvas.
			newShape position: aCanvas camera position.
			rootShapes add: newShape.
			aCanvas add: newShape.
			aCanvas signalUpdate ]
		for: self.

	self normalizeShapes.
	self renderLinesIn: aCanvas.
	self layoutOn: rootShapes parent: rootNode
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> widthMetricThreshold [

	^ widthMetricThreshold ifNil: [ widthMetricThreshold := 10 ]
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> widthMetricThreshold: anObject [

	widthMetricThreshold := anObject
]
