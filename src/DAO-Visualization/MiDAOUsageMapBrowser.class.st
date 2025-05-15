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
