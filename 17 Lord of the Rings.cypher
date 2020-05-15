// Store all the graph in the Graph Catalog
CALL gds.graph.create('whole-graph','*', '*')

// Connected components
CALL gds.wcc.stream('whole-graph') 
YIELD nodeId, componentId 
RETURN componentId, count(*) as size

// Create graph with only INTERACT relationships (edges)
CALL gds.graph.create('interactions', 'Node', ['INTERACTS_1', 'INTERACTS_2', 'INTERACTS_3'])


// Keep also nodes
CALL gds.wcc.stream('interactions') 
YIELD nodeId, componentId
RETURN componentId, count(*) as size, collect(gds.util.asNode(nodeId).Label) as ids


// Keep also nodes (only from first book)
CALL gds.wcc.stream('interactions', {relationshipTypes:['INTERACTS_1']}) 
YIELD nodeId, componentId
RETURN componentId, count(*) as size, collect(gds.util.asNode(nodeId).Label) as ids

// Undirected weighted graph
CALL gds.graph.create('lotr', 
						['Person', 'Thing'], 
						{INTERACTS_1: {type:'INTERACTS_1', orientation: 'UNDIRECTED', properties:['weight']}});

// PageRank
CALL gds.pageRank.stream('lotr', {relationshipWeightProperty: 'weight'}) 
YIELD nodeId, score 
RETURN DISTINCT gds.util.asNode(nodeId).Label, score
ORDER BY score DESC


// Community Detection - Louvain
CALL gds.louvain.stream('lotr', {relationshipWeightProperty: 'weight'}) 
YIELD nodeId, communityId 
RETURN communityId, collect(DISTINCT gds.util.asNode(nodeId).Label) AS members
