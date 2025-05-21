Class {
	#name : 'MiDAOUsageMapStyle',
	#superclass : 'HDefaultStyle',
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'hooks' }
MiDAOUsageMapStyle >> labelFor: anHNode [

	^ self baseLabel copy
		  text: ''
]
