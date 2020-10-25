// Povprečna starost vseh igralcev, ki so bili hkrati tudi režiserji

// Ukaz WITH prenese podatke v novo poizvedbo

MATCH (n:Person)
WITH count(n) as count
RETURN 'Person' as label, count
UNION ALL
MATCH (n:Movie)
WITH count(n) as count
RETURN 'Movie' as label, count;

MATCH (n:Person)
RETURN {label:'Person', count: count(n)} as info
UNION ALL
MATCH (n:Movie)
RETURN {label:'Movie', count: count(n)} as info;

// Povprečna starost igralcev, ki so tudi režiserji

MATCH (n)<-[:DIRECTED]-(p:Person)-[:ACTED_IN]->(m)
WITH DISTINCT p as pd
RETURN avg(pd.born);

// Pri istem filmu
MATCH (n)<-[:DIRECTED]-(p:Person)-[:ACTED_IN]->(m)
WHERE m = n
WITH DISTINCT p as pd
RETURN avg(pd.born);

// Število igralcev rojenih pred 1970 za posamezen film
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.born > 1970
RETURN count(p) as `mm`, m.title;

MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.born > 1970
WITH count(p) as num, m
WHERE num >=3
RETURN num as `mm`, m.title;

MATCH (p1:Person{name:"Tom Hanks"})-[r:ACTED_IN]->(m:Movie)
UNWIND(r.roles) as rr
RETURN rr, m.title;

// Najdimo filme v katerih igra 5 najstarejših igralcev
MATCH (p:Person)-[:ACTED_IN]->()
WITH p
ORDER BY p.born LIMIT 5
match (p:Person)-[:ACTED_IN]->(m:Movie)
RETURN m, p.born;

// Optional MATCH
// Najdi vse reviewerje za katere velja:
// Reviewali so vsaj en film in sledijo nekemu drugemu reviewerju
// Če sta oba reviewala isti film ga prikaži
// Dodaj dodatni WHERE, če je zadeva prelahka
MATCH (a:Person)-[:REVIEWED]->(:Movie),
      (a:Person)-[:FOLLOWS]->(b:Person)
OPTIONAL MATCH (a:Person)-[:REVIEWED]->(m:Movie)<-[:REVIEWED]-(b:Person)
WITH a, m, b
RETURN a, b, m;


// Multiple hops
MATCH (p1)-[:FOLLOWS]->(p2)
return p2, p1;

MATCH (p1)-[:FOLLOWS]->(p2)
return p2;

MATCH (p1)-[:FOLLOWS*2]-(p2)
WHERE p1.name STARTS WITH "Ja"
return p2, p1;

MATCH (p1)-[:ACTED_IN*2]-(p2)
WHERE p1.name = "Tom Hanks"
return p2, p1;

// Make a pattern

MATCH p=(p1)-[:ACTED_IN*2]-(p2)
WHERE p1.name = "Tom Hanks"
return p;

// Kevin Bacon
MATCH p = shortestPath((bacon:Person {name:"Kevin Bacon"}) -[:ACTED_IN*]-(p2:Person))
WHERE bacon <> p2
RETURN length(p), p2.name;

//

MATCH p = shortestPath((bacon:Person {name:"Kevin Bacon"}) -[:ACTED_IN*]-(p2:Person))
WHERE bacon <> p2
WITH length(p) as l, p2
ORDER BY l DESC
RETURN l, p2.name;

// Filmi, kjer so vsi igralci bili starejši od x
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE m.released > 1970
WITH m, collect(p) as actors
WHERE ALL (a in actors WHERE a.born > 1955)
UNWIND actors as act_u
return m, act_u



