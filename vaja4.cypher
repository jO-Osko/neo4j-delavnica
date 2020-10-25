CREATE (n:Movie {title: "Forrest Gump"})
RETURN n;

CREATE (:Person {name:"Robin Wright"})

// Dobi ju ven


// Nastavljanje novih lastnosti

MATCH (m:Movie) 
WHERE m.released < 1995
SET m:OldMovie
return m

MATCH (m:Movie) 
WHERE m.released < 1995
SET m:OldMovie
return m

MATCH (m:Movie)
return DISTINCT labels(m);

// poračunaj število igralcev posameznega filma
// To zapiši
// Dodaj jim oznako :BigMovie

MATCH (p)-[:ACTED_IN]->(m)
WITH count(p) as cnt, m
SET m.numOfAct = cnt
RETURN m, cnt;

MATCH (m:Movie)
WHERE m.numOfAct > 2
SET m:BigCast
RETURN m;

CALL db.schema.visualization;

// Zgeneriraj vse stare filme

MATCH (p:OldMovie)
REMOVE p:OldMovie;

// Najdi igralca, ki je igral najmlajši

MATCH (p:Person) -[:ACTED_IN]->(m:Movie)
WITH min(p.born) as minBorn, m
MATCH (p:Person{born:minBorn}) -[:ACTED_IN]->(m:Movie) 
REturn m.title, minBorn , collect(p)

// vse je JSON...
MATCH (p:Person{name:"Tom Hanks"})
SET p += {buu:"buuu"}

// APOC
// Najprej ga naloži v bazo

CALL apoc.trigger.add

// Error, pojdi v nastavitve in poglej

CALL apoc.trigger.add("check-old", "UNWIND $createdNodes AS n MATCH (n:Movie) WHERE n.released < 1990 SET n:OldMovie", {phase:"after"})

// Better
// UNWIND apoc.trigger.nodesByLabel({assignedLabels}, 'Movie')

// Druga opcija
CALL
{MATCH (p:Person)-[:REVIEWED]->(m:Movie)
RETURN  m}
MATCH (m) WHERE m.released=2000
RETURN m.title, m.released


// Nafilajmo

MATCH (m:Movie)
WHERE m.title = 'Forrest Gump'
MATCH (p:Person)
WHERE p.name = 'Tom Hanks' OR p.name = 'Robin Wright' OR p.name = 'Gary Sinise'
CREATE (p)-[:ACTED_IN]->(m)

MATCH (m:Movie)
WHERE m.title = 'Forrest Gump'
MATCH (p:Person)
WHERE p.name = 'Robert Zemeckis'
CREATE (p)-[:DIRECTED]->(m)

MATCH (p1:Person)
WHERE p1.name = 'Tom Hanks'
MATCH (p2:Person)
WHERE p2.name = 'Gary Sinise'
CREATE (p1)-[:HELPED]->(p2)

MATCH (p:Person)-[rel:ACTED_IN]->(m:Movie)
WHERE m.title = 'Forrest Gump'
SET rel.roles =
CASE p.name
  WHEN 'Tom Hanks' THEN ['Forrest Gump']
  WHEN 'Robin Wright' THEN ['Jenny Curran']
  WHEN 'Gary Sinise' THEN ['Lieutenant Dan Taylor']
END


MATCH (p1:Person)-[rel:HELPED]->(p2:Person)
WHERE p1.name = 'Tom Hanks' AND p2.name = 'Gary Sinise'
SET rel.research = 'war history'


MATCH (:Person)-[rel:HELPED]-(:Person)
DELETE rel

// Kakšna je sedaj shema
call db.propertyKeys
call db.schema

MATCH (p:Person)-[rel:ACTED_IN]->(m:Movie)
WHERE m.title = 'Forrest Gump' AND p.name = 'Gary Sinise'
SET rel.roles =['Lt. Dan Taylor']

MATCH (p1:Person)-[rel:HELPED]->(p2:Person)
WHERE p1.name = 'Tom Hanks' AND p2.name = 'Gary Sinise'
REMOVE rel.research

MATCH (m:Movie)
WHERE m.title = 'Forrest Gump'
DELETE m

MATCH (m:Movie)
WHERE m.title = 'Forrest Gump'
DETACH DELETE m

// Merge
// Insert or update
MERGE (m:Movie {title: 'Forrest Gump'})
SET m.released = 1994
RETURN m

MERGE (m:Movie {title: 'Forrest Gump'})
ON CREATE SET m.released = 1994
ON MATCH SET m.tagline = "Box of choice"
RETURN m

MERGE (p:Production {title: 'Forrest Gump'})
ON CREATE SET p.year = 1994
RETURN p

// Take care
MERGE (p:Person {name: 'Robert Zemeckis'})-[:DIRECTED]->(m {title: 'Forrest Gump'})
// Kaj to naredi -> Bad practice

MATCH (p:Person {name: 'Robert Zemeckis'})--()
WHERE NOT EXISTS (p.born)
DETACH DELETE p

MATCH (m)
WHERE m.title = 'Forrest Gump' AND labels(m) = []
DETACH DELETE m

// Proper:
MATCH (p:Person), (m:Movie)
WHERE p.name = 'Robert Zemeckis' AND m.title = 'Forrest Gump'
MERGE (p)-[:DIRECTED]->(m)
// Match and then merge on relation


MATCH (p:Person), (m:Movie)
WHERE p.name IN ['Tom Hanks','Gary Sinise', 'Robin Wright']
      AND m.title = 'Forrest Gump'
MERGE (p)-[:ACTED_IN]->(m)


// Indeksi

CREATE INDEX FOR (p:Person) ON (p.born)

CREATE INDEX FOR (p:Person) ON (p.born, p.name)

CREATE CONSTRAINT ON (movie:Movie) ASSERT movie.title IS UNIQUE;

CALL db.indexes;