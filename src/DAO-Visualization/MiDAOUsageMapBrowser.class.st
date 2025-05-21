Class {
	#name : 'MiDAOUsageMapBrowser',
	#superclass : 'MiAbstractVisualizationBrowser',
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'accessing' }
MiDAOUsageMapBrowser class >> mapClass [
	^ MiDAOUsageMapPresenter
]

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

	| uniqType confirm |
	aCollection isCollection ifFalse: [ ^false ].

	"for example, this allows to open on an empty collection
	 (to propagate entities later)"
	aCollection ifEmpty: [ ^true ].

	uniqType := aCollection anyOne class.
	(aCollection allSatisfy: [ :e | (e class = uniqType) ])
		ifFalse: [
			confirm := UIManager default
				confirm: 'DistributionMap is intend to work on _one_ kind of entity (and their direct ''children'').
You are propagating several different kinds of entities.
Are you sure you want to continue ?
(That might result in unecessary lengthy computation)'.
			confirm ifFalse: [ ^false ]
		].

	^true
]

{ #category : 'accessing' }
MiDAOUsageMapBrowser >> daoPresenter [
	^ mainPresenter
]
