"
This browser displays the usage relationships of DAOs across various clients (such as services and repositories). It allows for a clear visualization of how data access objects are consumed by different parts of the system.
This Moose-based visualization helps identify coupling patterns, potential design flaws, and areas for architectural improvement, facilitating better maintainability and refactoring decisions.
"
Class {
	#name : 'MiDAOUsageMapBrowser',
	#superclass : 'MiAbstractVisualizationBrowser',
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'accessing' }
MiDAOUsageMapBrowser class >> daoVisualizationClass [

	^ MiDAOUsageMapVisualization
]

{ #category : 'world menu' }
MiDAOUsageMapBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : 'world menu' }
MiDAOUsageMapBrowser class >> menuItem [

	^ #DAOBrowser
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
MiDAOUsageMapBrowser >> initializePresenters [

	specModel browser: self.

	mainPresenter := self instantiate: self class daoVisualizationClass.
]

{ #category : 'accessing' }
MiDAOUsageMapBrowser >> miSelectedItem [
	^ specModel entities
]

{ #category : 'as yet unclassified' }
MiDAOUsageMapBrowser >> updateClientColor: aClient fromTag: aTag [
	mainPresenter updateClientColor: aClient fromTag: aTag
]
