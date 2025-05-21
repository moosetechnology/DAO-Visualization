Class {
	#name : 'MiDAOUsageMapStyle',
	#superclass : 'HDefaultStyle',
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'hooks' }
MiDAOUsageMapStyle >> cornerRadius [

	^ 2
]

{ #category : 'hooks' }
MiDAOUsageMapStyle >> labelFor: anHNode [

	^ self baseLabel copy
		  text: ''
]
