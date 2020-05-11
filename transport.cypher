## Load nodes into Neo4j

WITH 
"https://github.com/jpmaldonado/np-graph/raw/master/data/" AS 
base
WITH base + "transport-nodes.csv" AS uri
LOAD CSV WITH HEADERS FROM uri AS row 
MERGE (place:Place {id:row.id}) 
SET place.latitude = toFloat( row.latitude), 
place.longitude = toFloat( row.latitude), 
place.population = toInteger( row.population)
```


## Load relationships into Neo4j

WITH 
"https://github.com/jpmaldonado/np-graph/raw/master/data/" AS 
base
WITH base + "transport-relationships.csv" AS uri
LOAD CSV WITH HEADERS FROM uri AS row
MATCH (origin:Place {id: row.src})
MATCH (destination:Place {id: row.dst})
MERGE (origin)-[:EROAD 
	{distance: toInteger(row.cost)}]->( destination)