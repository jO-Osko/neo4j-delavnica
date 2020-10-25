MATCH (n)
RETURN n
LIMIT 25;

MATCH (n:Movie)
RETURN n
LIMIT 25;

CALL db.schema.visualization;
CALL db.propertyKeys;
CALL db.labels;

MATCH (n:Movie)-->(:Movie)
RETURN n;

MATCH (p:Person)-->(q) RETURN q LIMIT 30;

MATCH (p:Person)<--(q)
RETURN q,p;

MATCH (p:Person)<--(q)
RETURN p;

MATCH (m:Movie) 
RETURN m.title AS `movie title`, m.released AS released, m.tagline AS tagLine;

MATCH (p:Person)-[:ACTED_IN]->(m:Movie) RETURN p,m;

MATCH (p:Person)-[:PRODUCED]->(m:Movie) RETURN p,m;

MATCH r=(p:Person)-[:PRODUCED|:DIRECTED]->(m:Movie)
RETURN r;

MATCH r=(p:Person{name:"Tom Hanks"})-[:PRODUCED|:DIRECTED]->(m:Movie)
RETURN r;

// Bolj zapletene poizvedbe
// Vsi, ki so tak igrali kot režirali

MATCH (p:Person)-[:ACTED_IN]->(m), (p)-[:DIRECTED]->(m)
RETURN p,m;

MATCH (p:Person)-[:ACTED_IN]->(m)<-[:DIRECTED]-(p)
RETURN p,m;

MATCH (p:Person)-[:ACTED_IN]->(m)
WHERE p.name STARTS WITH ("Tom")
RETURN p,m;

// EXPLAIN

// Agregacije
MATCH (p:Person)-[:ACTED_IN]->(m)<-[:DIRECTED]-(p)
RETURN p
ORDER BY p.born
LIMIT 1

MATCH (p)-[:ACTED_IN]->(m)
RETURN m, count(p)

//

MATCH (n)<-[:DIRECTED]-(p:Person)-[:ACTED_IN]->(m)
// WHERE m = n
RETURN DISTINCT p.name

//

// Rešitve vaj:


MATCH (p1:Person)-[:ACTED_IN]->(m:Movie)
WHERE p1.born > 1970
RETURN m;

MATCH (p1:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(p2:Person)
WHERE p1.born > 1970 AND p2.born < 1970 AND m.rating > 30
RETURN m;

MATCH (n:Person)-[r:REVIEWED]->(m:Movie) 
WHERE r.rating > 50
return n,m

MATCH (n:Person)-[r:REVIEWED]->(m:Movie) 
WHERE r.rating > 2 AND (NOT (n)-[:FOLLOWS]->(:Person))
return n,m

MATCH (k)<-[:FOLLOWS]-(n:Person)-[r:REVIEWED]->(m:Movie) 
WHERE r.rating > 2
return n,m,k

MATCH (n)<-[:DIRECTED]-(p:Person)-[:ACTED_IN]->(m)
// WHERE m = n
RETURN DISTINCT p.name

MATCH (p1:Person{name:"Tom Hanks"})-[r:ACTED_IN]->(m:Movie)
UNWIND(r.roles) as rr
RETURN rr, m.title

MATCH (p1:Person)-[:DIRECTED]->(m:Movie)<-[:DIRECTED]-(p2:Person)
WHERE p1 <> p2 
RETURN p1, p2, m


// 2.12
MATCH (:Person)-[r:REVIEWED]->(m:Movie)
WHERE toLower(r.summary) CONTAINS 'fun'
RETURN  m.title, r.summary, r.rating;

MATCH (a:Person)-[rel]->(m:Movie)
WHERE exists(rel.rating)
RETURN a, m;

MATCH (a:Person)-[r:ACTED_IN]->(m:Movie)
WHERE m.title in r.roles
RETURN  m.title, a.name