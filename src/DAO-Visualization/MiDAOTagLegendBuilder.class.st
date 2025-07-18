"
I build a legend for MiDAO tags, suitable for display in a visualization context.
"
Class {
	#name : 'MiDAOTagLegendBuilder',
	#superclass : 'RSBuilder',
	#instVars : [
		'tags',
		'mapBuilder'
	],
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'hooks' }
MiDAOTagLegendBuilder >> boxLabelExtent [
	^ 25@15
]

{ #category : 'hooks' }
MiDAOTagLegendBuilder >> checkBoxFor: aTag [
	^ self iconNamed: (aTag isHidden  
		ifTrue: [ #checkboxUnselected ]
		ifFalse: [ #checkboxSelected ])
]

{ #category : 'highlighting' }
MiDAOTagLegendBuilder >> highlightLegend: evt [
	| shape |
	self flag: #FIXME.
	"self unhighlight: evt.
	#unhighlight: is not implemented and I don't understand what should be ungighlighted"

	shape := evt shape.
	shape border: (RSBorder new width: 2; color: Color gray).
	evt canvas propertyAt: #tagCheck put: shape.
	evt signalUpdate.
]

{ #category : 'hooks' }
MiDAOTagLegendBuilder >> legendBottomLine [
	"explains the form of the innerBoxes (width based on number of dependencies)"

	| box marker arrow label |
	box := RSBox new
		       extent: self boxLabelExtent;
		       color: MiDAOUsageMapStyle color;
		       cornerRadius: 2;
		       width: 35;
		       yourself.
	marker := RSShapeFactory arrow
		          size: 10;
		          color: Color black;
		          yourself.
	arrow := RSLine new
		         startPoint: 0 @ 0;
		         endPoint: self boxLabelExtent x @ 0;
		         color: Color black;
		         marker: marker;
		         yourself.
	label := RSLabel new
		         text: 'Total number of invocations';
		         color: Color black;
		         yourself.
	RSVerticalLineLayout new
		gapSize: 5;
		on: {
				box.
				arrow }.
	RSHorizontalLineLayout new
		gapSize: 5;
		on: {
				label.
				{
					box.
					arrow } asGroup }.
	^ {
		  box.
		  arrow.
		  label } asGroup asShape
]

{ #category : 'enumerating' }
MiDAOTagLegendBuilder >> legendDo: aShape [

	aShape shapes last translateBy: 0 @ 15.
	aShape
		adjustToChildren;
		padding: 10;
		when: RSMouseMove send: #yourself to: self;
		color: ((Color colorFrom: 'f4f4f4') alpha: 0.9);
		border: (RSBorder new
				 color: Color lightGray;
				 width: 0.5)
]

{ #category : 'hooks' }
MiDAOTagLegendBuilder >> legendTagLine: aTag [ 
	| label icon checkBox line |
	checkBox := RSBitmap new
		model: aTag;
		form: (self checkBoxFor: aTag);
		when: RSMouseEnter send: #highlightLegend: to: self; 
		when: RSMouseLeave send: #unhighlightLegend: to: self; 
		when: RSMouseClick send: #toggleTag: to: self; 
		yourself.
	icon := RSBitmap new form: (mapBuilder iconForTag: aTag).
	label := RSLabel new
		text: aTag name;
		color: Color black;
		yourself.

	line := { checkBox. icon. label } asGroup asShape.
	RSHorizontalLineLayout new
		gapSize: 5 ;
		alignMiddle ;
		on: line children.
	line adjustToChildren.

	^ line
]

{ #category : 'accessing' }
MiDAOTagLegendBuilder >> legendTitle [
	^ 'Legend'
]

{ #category : 'accessing' }
MiDAOTagLegendBuilder >> mapBuilder [

	^ mapBuilder
]

{ #category : 'accessing' }
MiDAOTagLegendBuilder >> mapBuilder: anObject [

	mapBuilder := anObject
]

{ #category : 'removing' }
MiDAOTagLegendBuilder >> removeOldLegend [

	| canvas legendShape |
	canvas := self canvas.
	legendShape := canvas fixedShapes
		               detect: [ :shape | shape class = RSComposite ]
		               ifNone: [ nil ].
	legendShape ifNil: [ ^ self ].
	tags := nil.
	canvas removeInteractionIfPresent: self class.
	legendShape remove
]

{ #category : 'rendering' }
MiDAOTagLegendBuilder >> renderIn: aCanvas [

	| legend |
	self removeOldLegend.

	legend := RSLegend new
		          container: aCanvas;
		          yourself.

	shapes := RSGroup new.
	shapes addAll:
		(self tags collect: [ :tag | self legendTagLine: tag ]).
	shapes add: self legendBottomLine.
	legend shapes ifNotNil: [ :collection | collection addAll: shapes ].

	legend layout vertical gapSize: 2.
	legend defaultTitle
		color: Color black;
		fontSize: 12.

	legend
		legendDo: [ :l | self legendDo: l ];
		beFixedWithTitle: self legendTitle;
		build
]

{ #category : 'accessing' }
MiDAOTagLegendBuilder >> specModel [
	^ mapBuilder mapModel
]

{ #category : 'accessing' }
MiDAOTagLegendBuilder >> tags [

	^ tags ifNil: [ tags := self specModel tagList ]
]

{ #category : 'hooks' }
MiDAOTagLegendBuilder >> toggleTag: evt [
	| checkBox tag |
	checkBox := evt shape.
	tag := checkBox model.
	self flag: 'Hidding tag is part of its normal API ?!?'.
	tag toggleVisibility.
	checkBox form: (self checkBoxFor: tag).
	mapBuilder updateShapeColors.
	evt signalUpdate.
	
	
]

{ #category : 'highlighting' }
MiDAOTagLegendBuilder >> unhighlightLegend: evt [
	evt canvas
		propertyAt: #tagCheck
		ifPresent: [ :s | s border: nil ];
		removeKey: #tagCheck.
	evt signalUpdate.
]
