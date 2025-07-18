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

{ #category : 'building - graph' }
MiDAOUsageMapBuilder >> applyLayout [

	RSFlowLayout new
		gapSize: 20;
		on: self canvas nodes
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapBuilder >> automaticColor [

	self mapModel automaticColor
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> build [

	self applyLayout.
	rootNode := HNode new.

	rootNode addAll: self createClientRootNodes.

	self renderIn: self container.

	^ self container
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> buildClientRootNodeFrom: anEntity [

	^ HNode new
		  rawModel: anEntity;
		  name: anEntity fullDisplayString;
		  style: self nodeStyle;
		  addAll: (self buildDAOChildrenNodesFrom: anEntity);
		  color: (self colorFromEntity: anEntity);
		  yourself
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> buildDAOChildrenNodeFromEntity: anEntity from: parentClass [

	^ HNode new
		  rawModel: anEntity;
		  name: (self informationFor: anEntity from: parentClass);
		  style: self nodeStyle;
		  addAll: (self buildDAOChildrenNodesFrom: anEntity);
		  color: MiDAOUsageMapStyle color;
		  yourself
]

{ #category : 'building' }
MiDAOUsageMapBuilder >> buildDAOChildrenNodesFrom: anEntity [

	^ ((self mapModel usedEntitiesBy: anEntity) collect: [ :childEntity |
		   self buildDAOChildrenNodeFromEntity: childEntity from: anEntity ]) sort: #name ascending
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapBuilder >> colorFromEntity: anEntity [

	anEntity isClass ifTrue: [
		^ Color r: 212 / 255 g: 220 / 255 b: 220 / 255 ].
	anEntity isAttribute ifTrue: [
		^ Color r: 85 / 255 g: 114 / 255 b: 114 / 255 ].
	^ Smalltalk ui theme baseColor alpha: 0.7
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> colorFromTags: tags [
	tags ifNil:  [ ^ Color colorFrom: 'f5f5f5' ].
	(tags isCollection and: [ tags isEmpty ]) ifTrue: [ ^ Color colorFrom: 'f5f5f5' ].
	(tags isCollection and: [ tags size = 1 ]) ifTrue: [ ^ self colorFromTags: tags anyOne ].
	tags isCollection ifTrue: [ ^ Color black ].

	(tags isTag and: [ tags isHidden ]) ifTrue: [ ^ Color colorFrom: 'f5f5f5' ].
	tags isTag ifTrue: [ ^ tags color ].
	^ Error signal: 'A famixTag was expected'
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

{ #category : 'default' }
MiDAOUsageMapBuilder >> defaultTagLegendBuilder [
	^ MiDAOTagLegendBuilder new
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> elements [
	^ self mapModel entities
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> highlightManager [

	^ highlightManager ifNil: [
		  highlightManager := MiDAOHighlightManager new
			                      mapBuilder: self;
			                      yourself ]
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> iconForTag: aTag [

	self flag: 'move to model?'.
	^ self application iconForTag: aTag
]

{ #category : 'computing' }
MiDAOUsageMapBuilder >> informationFor: anEntity from: parentClass [

	^ String streamContents: [ :stream |
		  | nbUsers nbTotalInvocations nbLocalInvocations |
		  nbUsers := mapModel numberOfClientsFor: anEntity.

		  nbTotalInvocations := mapModel numberOfAllInvocationsFor: anEntity.

		  nbLocalInvocations := self mapModel
			                        numberOfInvocationFor: anEntity
			                        from: parentClass.

		  stream
			  << anEntity fullDisplayString asText allBold asString;
			  cr;
			  << nbUsers asString;
			  << ' user';
			  << (nbUsers = 1
					   ifTrue: [ '' ]
					   ifFalse: [ 's' ]);
			  cr;
			  << nbTotalInvocations asString;
			  << ' total invocation';
			  << (nbTotalInvocations = 1
					   ifTrue: [ '' ]
					   ifFalse: [ 's' ]);
			  cr;
			  << nbLocalInvocations asString;
			  << ' local invocation';
			  << (nbLocalInvocations = 1
					   ifTrue: [ '' ]
					   ifFalse: [ 's' ]) ]
]

{ #category : 'hooks' }
MiDAOUsageMapBuilder >> initialize [

	super initialize.
	self menuManager: self defaultMenuManager.
	self legendTagBuilder: self defaultTagLegendBuilder.
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

	"baseNode ifNotNil: [ ^ baseNode announcer ]."
	baseNode := RSComposite new
		            @ self popup;
		            @
			            (HGhostDraggable new color:
					             Smalltalk ui theme caretColor);
		            @ self menuInteraction;
		           
		            @ RSNodeOnTopWhenPositionChanged new;
		            @ HResizeParentWhenChildMoves new;
		            yourself.

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

	^ nodeStyle ifNil: [
		  nodeStyle := MiDAOUsageMapStyle new model: self mapModel ]
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
	aCanvas @ self menuManager.

	aCanvas
		when: RSExtentChangedEvent send: #applyLayout to: self.

	self legendTagBuilder
		container: aCanvas;
		build.

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
	self renderLinesIn: aCanvas.
	self layoutOn: rootShapes parent: rootNode
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapBuilder >> updateClientColor: aClient fromTag: aTag [
1halt.

	(self canvas deepShapesFromModel: aClient) do: [ :shape |
		shape color: aTag color ].


	self canvas signalUpdate
]

{ #category : 'update' }
MiDAOUsageMapBuilder >> updateShapeColors [
	self canvas allChildren
		select: [ :shape | shape model notNil ]
		thenDo: [ :shape | shape color: (self colorFromTags: shape model tag) ].
	self canvas signalUpdate.
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> visualization [
	^ visualization
]

{ #category : 'accessing' }
MiDAOUsageMapBuilder >> visualization: aVisualization [
	visualization := aVisualization
]
