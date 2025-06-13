Class {
	#name : 'MiDAOUsageMapBrowser',
	#superclass : 'MiAbstractVisualizationBrowser',
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'world menu' }
MiDAOUsageMapBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : 'world menu' }
MiDAOUsageMapBrowser class >> menuItem [

	^ #FilesBrowser
]

{ #category : 'world menu' }
MiDAOUsageMapBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 7
]

{ #category : 'instance creation' }
MiDAOUsageMapBrowser class >> newModel [
	^ MiDAOUsageMapModel new.
]

{ #category : 'instance creation' }
MiDAOUsageMapBrowser class >> open [

	<script>
	^ super open
]

{ #category : 'specs' }
MiDAOUsageMapBrowser class >> title [
	^ 'DAO Usage'
]

{ #category : 'specs' }
MiDAOUsageMapBrowser class >> windowSize [

	^ 900 @ 700
]

{ #category : 'testing' }
MiDAOUsageMapBrowser >> canFollowEntity: aCollection [

	^ aCollection isMooseObject and: [
		  aCollection isCollection and: [
			  aCollection allSatisfy: [ :entity | entity usesFamixTrait: FamixTWithAttributes ] ] ]
]

{ #category : 'actions' }
MiDAOUsageMapBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel entities: anEntity asMooseGroup.
	
	self runVisualization
]

{ #category : 'initialization' }
MiDAOUsageMapBrowser >> initializeLayout [

	self layout: (SpScrollableLayout with: (SpBoxLayout newTopToBottom
				  add: mainPresenter;
				  yourself))
]

{ #category : 'initialization' }
MiDAOUsageMapBrowser >> initializePresenters [

	specModel browser: self.

	mainPresenter := self instantiate: self class daoVisualizationClass.

	self initializeLayout
]

{ #category : 'accessing' }
MiDAOUsageMapBrowser >> miSelectedItem [
	^ specModel entities
]
