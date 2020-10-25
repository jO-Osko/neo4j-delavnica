from py2neo import Graph

graph = Graph(password="password")

results = graph.run("MATCH (n:Movie) RETURN n")
for r in results:
    print(r)

print(graph.run("MATCH (n:Movie) WHERE n.title=$name RETURN n", {"name": "Top Gun"}))

