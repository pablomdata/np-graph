// Query Tuning Examples

// Example 1: Naive example
MATCH (p {name: 'Tom Hanks'})
RETURN p


// Reduce the AllNodesScan by specifying node type
MATCH (p:Person {name: 'Tom Hanks'})
RETURN p

// Query above cannot be improved, but we can add an index to the db
CREATE INDEX FOR (p:Person) ON (p.name)

// Example 2: Partial matching
PROFILE
MATCH (p:Person) -[:ACTED_IN]-> (m:Movie) 
WHERE p.name STARTS WITH 'Tom' 
RETURN p.name, count(m)


// Index used in aggregation/order by queries
PROFILE 
MATCH (p:Person)-[:ACTED_IN]->(m:Movie) 
WHERE p.name STARTS WITH 'Tom' 
RETURN p.name, count(m) ORDER BY p.name

// Effect of USING: Not much :) 
PROFILE 
MATCH (p:Person)-[:ACTED_IN]->(m:Movie) 
USING INDEX p:Person(name)
WHERE p.name STARTS WITH 'Tom' 
RETURN p.name, count(m) ORDER BY p.name


// In some cases (e.g. EXISTS queries), Neo4j cannot use the index to sort, so an extra step is needed
PROFILE 
MATCH (p:Person)-[:ACTED_IN]->(m:Movie) 
USING INDEX p:Person(name)
WHERE EXISTS (p.name)
RETURN p.name, count(m) ORDER BY p.name


// Avoid aggregation using default index construction for min/max
MATCH(p:Person)-[:ACTED_IN]->(m:Movie) 
RETURN min(p.name) as name


// Information about property type helps Neo to sort by using the index structure
PROFILE 
MATCH(p:Person)-[:ACTED_IN]->(m:Movie) 
WHERE p.name STARTS WITH '' // this permits Neo to recover the type of property
RETURN min(p.name) as name

// Passing hints

// USING SCAN : Force Neo to scan all node properties
PROFILE 
MATCH (p:Person)-[:ACTED_IN]->(m:Movie) 
USING SCAN p:Person
WHERE EXISTS (p.name)
RETURN p.name, count(m)

// Also in Neo: USING JOIN (?)



