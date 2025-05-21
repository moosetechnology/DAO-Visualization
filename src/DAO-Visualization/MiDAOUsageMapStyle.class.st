Class {
	#name : 'MiDAOUsageMapStyle',
	#superclass : 'HDefaultStyle',
	#category : 'DAO-Visualization',
	#package : 'DAO-Visualization'
}

{ #category : 'private' }
MiDAOUsageMapStyle >> colorFor: node [

	^ node color ifNil: [ Smalltalk ui theme baseColor alpha: 0.7 ]
]

{ #category : 'hooks' }
MiDAOUsageMapStyle >> cornerRadius [

	^ 2
]

{ #category : 'hooks' }
MiDAOUsageMapStyle >> labelFor: anHNode [

	^ self baseLabel copy
		  text: ''
]
