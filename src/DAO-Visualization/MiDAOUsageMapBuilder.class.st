"
I am a class which is responsible to create all nodes and links in DAOUsageMap visualization.
"
Class {
	#name : 'MiDAOUsageMapBuilder',
	#superclass : 'HSimpleVisualizationBuilder',
	#instVars : [
		'highlightManager',
		'highlightShapes',
		'nodeStyle',
		'legendTagBuilder',
		'highlightedShapes',
		'menuManager',
		'visualization'
	],
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'hooks' }
MiDAOUsageMapBuilder >> addDAOInteractions: aShape [

	aShape
		when: RSMouseLeftClick
		do: [ :evt |
			self highlightManager resetHighlights.
			self highlightManager highlightClass: evt shape model rawModel ]
		for: self
]

{ #category : 'hooks' }
MiDAOUsageMapBuilder >> addInteractionsToShape: aShape [

	| node |
	aShape announcer: self nodeAnnouncer.

	aShape model level > 1 ifTrue: [ self addDAOInteractions: aShape ].
	node := aShape model.
	node
		removeInteractionIfPresent: self class;
		when: HCollapseEvent
		do: [ :evt | self rebuildShape: aShape ]
		for: self;
		when: HExpandEvent
		do: [ :evt | self rebuildRootShape: aShape ]
		for: self
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> application [

	^self mapModel currentApplication
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
MiDAOUsageMapBuilder >> createClientRootNodes [

	^ (mapModel allClients
		   collect: [ :e | self buildClientRootNodeFrom: e ]
		   thenReject: [ :node | node isNil ]) sort: [ :a :b |
		  (a rawModel perform: self mapModel widthMetric)
		  > (b rawModel perform: self mapModel widthMetric) ]
]

{ #category : 'default' }
MiDAOUsageMapBuilder >> defaultMenuManager [
	^ MiDAOMenuManager new
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

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> legendTagBuilder [
	^ legendTagBuilder
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> legendTagBuilder: aMiCoTagLegendBuilder [ 
	legendTagBuilder := aMiCoTagLegendBuilder.
	legendTagBuilder mapBuilder: self.
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> menuManager [

	^ menuManager
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> menuManager: anObject [

	menuManager := anObject.
	menuManager mapBuilder: self.
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
MiDAOUsageMapBuilder >> visualization [
	^ visualization
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> visualization: aVisualization [
	visualization := aVisualization
]
