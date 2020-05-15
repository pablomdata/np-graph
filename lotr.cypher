// Import ontology

LOAD CSV WITH HEADERS FROM 
"https://raw.githubusercontent.com/morethanbooks/projects/master/LotR/ontologies/ontology.csv" as row 
FIELDTERMINATOR "\t" 
WITH row, CASE row.type WHEN 'per' THEN 'Person' 
                        WHEN 'gro' THEN 'Group' 
                        WHEN 'thin'THEN 'Thing' 
                        WHEN 'pla' THEN 'Place' 
                        END as label 
CALL apoc.create.nodes(['Node',label], [apoc.map.clean(row,['type','subtype'],[null,""])]) YIELD node 
WITH node, row.subtype as class 
MERGE (c:Class{id:class}) 
MERGE (node)-[:PART_OF]->(c)


// Import relationships

UNWIND ['1','2','3'] as book 
LOAD CSV WITH HEADERS FROM 
"https://raw.githubusercontent.com/morethanbooks/projects/master/LotR/tables/networks-id-volume" + book + ".csv" AS row 
MATCH (source:Node{id:coalesce(row.IdSource,row.Source)})
MATCH (target:Node{id:coalesce(row.IdTarget,row.Target)})
CALL apoc.create.relationship(source, "INTERACTS_" + book, 
     {weight:toInteger(row.Weight)}, target) YIELD rel
RETURN distinct true