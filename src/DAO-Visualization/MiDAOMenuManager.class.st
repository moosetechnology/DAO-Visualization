"
I create a menu for each element and the main canvas in MiCoUsageMapBuilder.
"
Class {
	#name : 'MiDAOMenuManager',
	#superclass : 'RSInteraction',
	#instVars : [
		'mapBuilder'
	],
	#category : 'DAO-Visualization-Roassal3',
	#package : 'DAO-Visualization',
	#tag : 'Roassal3'
}

{ #category : 'hooks' }
MiDAOMenuManager >> clickOn: aRSMouseClick [ 
	aRSMouseClick metaKeyPressed
	  ifFalse: [ ^ self ].
	mapBuilder specModel quickTaggingOn: aRSMouseClick shape model.
	aRSMouseClick signalUpdate
]

{ #category : 'building - menus' }
MiDAOMenuManager >> contractLabel: aString [
	| contractor |
	contractor := LbCContractor new.
	contractor  addStrategy: (LbCEllipsisStrategy new 
		separator: '...';
		upTo: 50;
		yourself).
	^ contractor reduce: aString
]

{ #category : 'building - menus' }
MiDAOMenuManager >> createGlobalMenuOn: menu [
	(menu
		add: 'Auto-coloring containers'
			target: mapBuilder
			selector: #automaticColor
			argumentList: #())
		icon: (self iconNamed: #smallPaint).
	
]

{ #category : 'building - menus' }
MiDAOMenuManager >> createMenu: aMenuMorph onBox: aMiCoBox [

	aMenuMorph
		addTitle:
			aMiCoBox type , ': <' , (self contractLabel: aMiCoBox name) , '>';
		add: 'Tags'
		subMenu: (self fillTagMenu: MenuMorph new for: aMiCoBox);
		add: 'Inspect' target: aMiCoBox selector: #mooseInspect
]

{ #category : 'building - menus' }
MiDAOMenuManager >> createMenu: menu onShape: aShape [
	aShape isShape
		ifTrue: [ self createMenu: menu onBox: aShape model ]
		ifFalse: [ self createGlobalMenuOn: menu ]
]

{ #category : 'initialization' }
MiDAOMenuManager >> defaultMenuInteraction [

	^ RSMenuActivable new
		  menuDo: [ :menu :aShape | self createMenu: menu onShape: aShape ];
		  yourself
]

{ #category : 'building - menus' }
MiDAOMenuManager >> fillTagMenu: menu for: aMiCoBox [
	"Fill #menu on #aMiCoBox with all tag names (not hidden tags)"
	self mapBuilder tags
		select: [ :aTag | aTag isHidden not ]
		thenDo: [ :aTag |
			(menu 
				add: aTag name
					target: (mapBuilder specModel)
					selector: #setTag:onInnerBox:
					argumentList: { aTag . aMiCoBox })
				icon: (self iconFormFor: aTag) ].
		aMiCoBox tag ifNotNil: [ 
			menu addLine.
			(menu 
				add: 'Remove tag'
					target: mapBuilder
					selector: #setTag:onInnerBox:
					argumentList: { nil. aMiCoBox })
				icon: (self iconNamed: 'remove')
			 ].
	^ menu
]

{ #category : 'building - menus' }
MiDAOMenuManager >> iconFormFor: aMiCoTag [

	^ (FormCanvas extent: 15 asPoint)
		  fillColor: aMiCoTag color;
		  form
]

{ #category : 'accessing' }
MiDAOMenuManager >> mapBuilder [

	^ mapBuilder
]

{ #category : 'accessing' }
MiDAOMenuManager >> mapBuilder: anObject [

	mapBuilder := anObject
]

{ #category : 'hooks' }
MiDAOMenuManager >> onShape: aShape [
	aShape
		addInteraction: self defaultMenuInteraction ;
		when: RSMouseLeftClick send: #clickOn: to: self
]

{ #category : 'dependencies' }
MiDAOMenuManager >> release [
	super release.
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]
