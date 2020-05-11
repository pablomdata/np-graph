## Load nodes into Neo4j
WITH  "https://github.com/jpmaldonado/np-graph/raw/master/data/" AS  base
WITH base + "social-nodes.csv" AS uri 
LOAD CSV WITH HEADERS FROM uri AS row 
MERGE (: User {id: row.id})



## Load relationships into Neo4j
WITH  "https://github.com/jpmaldonado/np-graph/raw/master/data/" AS base
WITH base + "social-relationships.csv" AS uri 
LOAD CSV WITH HEADERS FROM uri AS row 
MATCH (source:User {id: row.src}) 
MATCH (destination:User {id: row.dst}) 
MERGE (source)-[: FOLLOWS]->( destination)
