# Neo4j

## Vaja 1 (GUI)

- Zaženi movies.html
- Delo z miško:
  - Node clicking
  - Barvanje
  - Izbira povezav
  - Izbira zvezdic
  - Premikanje ...
  - Nastavitev Limita (brez ukazov)
  - Splošen GUI
- Samostojno [movies.html](./movies.html)

## Vaja 2 (Cypher)

- `Match`: ukazi v [vaja2.cypher](./vaja2.cypher)
- Samostojno [cypher.html](./cypher.html).

## Vaja 3 (UNWIND, WITH..., multiple hops)

- [vaja3.cypher](./vaja3.cypher)

## Vaja 4 (CREATE, MERGEE ITD)

- [vaja4.cypher](./vaja4.cypher)

## Vaja 5

Uporabe na različnih grafih:

- <https://portal.graphgist.org/graph_gists/flight-analyzer/source>
- CSV loading: <https://github.com/neo4j-contrib/training-v2/blob/master/ExerciseGuides/exercise-guides/advanced-cypher/05.adoc>

## Vaja 6
[//]: # (https://medium.com/neo4j/using-the-neo4j-graph-database-and-cypher-to-solve-this-brain-teaser-why-argue-350fde86da14)

Preštej trikotnike

```cypher
// Manually create triangle graph with 3 triangles for 3 levels
MATCH (n) DETACH DELETE n;  // DELETE existing data
// CREATE :Nodes (triangle intersections)
CREATE  (zero:Point {pID: 0}), 
(one:Point {pID: 1}),     (two:Point {pID: 2}), 
(three:Point {pID: 3}),   (four:Point {pID: 4}), 
(five:Point {pID: 5}),    (six:Point {pID: 6}), 
(seven:Point {pID: 7}),   (eight:Point {pID: 8}), 
(nine:Point {pID: 9}),    (ten:Point {pID: 10}),  
(eleven:Point {pID: 11}), (twelve:Point {pID: 12}) 
// CREATE :RELATIONSHIPS (lines between intersections)
CREATE (zero)-[:DOWN]->(one), 
  (zero)-[:DOWN]->(two), 
  (zero)-[:DOWN]->(three), 
  (zero)-[:DOWN]->(four)
CREATE (one)-[:ACROSS]->(two),  (one)-[:DOWN]->(five)
CREATE (two)-[:ACROSS]->(three), (two)-[:DOWN]->(six)
CREATE (three)-[:ACROSS]->(four), (three)-[:DOWN]->(seven)
CREATE (four)-[:DOWN]->(eight)
CREATE (five)-[:ACROSS]->(six), (five)-[:DOWN]->(nine)
CREATE (six)-[:ACROSS]->(seven), (six)-[:DOWN]->(ten)
CREATE (seven)-[:ACROSS]->(eight), (seven)-[:DOWN]->(eleven)
CREATE (eight)-[:DOWN]->(twelve)
CREATE (nine)-[:ACROSS]->(ten)
CREATE (ten)-[:ACROSS]->(eleven)
CREATE (eleven)-[:ACROSS]->(twelve)
```

```cypher
MATCH (n) SET n.origTri = True
MATCH (top:Point) 
WHERE NOT ( (top:Point)<--(:Point) ) 
MATCH path=(top)-[:DOWN*]->(:Point)-[:ACROSS*]->(:Point)<-[:DOWN*]-(top)
WITH path
CALL apoc.refactor.cloneSubgraphFromPaths([path], {skipProperties:["origTri"]}) 
YIELD input, output, error
RETURN input, output, error;
```

Vzeto iz: <https://medium.com/neo4j/using-the-neo4j-graph-database-and-cypher-to-solve-this-brain-teaser-why-argue-350fde86da14>

## Vaja 7

Python: [pyneo.py](./pyneo.py)
