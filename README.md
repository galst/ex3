Assignment 3 
================

Gal Bar 200462133, Gal Steimberg 201253572


## Question 1.a

#### Data Preprocessing
We would like to preprocess the data into a graph to better understand it. By picturing the data as a graph we will be able to take the largest connectivity component and answer question 1a accordingly.
The following is the code we used to create the graph seen below it.

``` r
install.packages("igraph")
library(igraph)

#read the given .csv files from the local path
relations <- read.csv(file="C:/src/Academy/ga_edgelist.csv", header=T, sep=",")
actors <- read.csv(file="C:/src/Academy/ga_actors.csv", header=T, sep=",")

#create the graph data frame from the fetched data
graph <- graph.data.frame(relations, directed=FALSE, vertices=actors)

#create a subgraph with the greatest tethering component
gtc <- which.max(components(graph)$csize)
subv <- V(graph)[which(components(graph)$membership==gtc)]
gtc_graph <- induced.subgraph(graph=graph, vids=subv)

#seperate into two groups by gender
women <- which(V(gtc_graph)$gender=="F")
V(gtc_graph)$color <- "green"
V(gtc_graph)$color[women] <- "red"

#print the graph
plot(gtc_graph)
```

![](images/preprocess.png)


As seen in the graph, we extracted the largest component in the graph. Let's calculate the scores for each measure requested.

#### Betweeness
For every pair of vertices in a connected graph, there exists at least one shortest path between the vertices such that either the number of edges that the path passes through (for unweighted graphs) or the sum of the weights of the edges (for weighted graphs) is minimized. The betweenness centrality for each vertex is the number of these shortest paths that pass through the vertex.
``` r

```


#### Closeness
The closeness of a node is a measure of centrality in a network, calculated as the sum of the length of the shortest paths between the node and all other nodes in the graph. 
``` r

```


#### Eigenvector
Eigenvector is a measure of the influence of a node in a network. It assigns relative scores to all nodes in the network based on the concept that connections to high-scoring nodes contribute more to the score of the node in question than equal connections to low-scoring nodes.
``` r

```


## Question 1.b

### 1 - Louvain Clustering
The Louvain Method for community detection is a method to extract communities from large networks created by Vincent Blondel, Jean-Loup Guillaume, Renaud Lambiotte and Etienne Lefebvre.[1] The method is a greedy optimization method that appears to run in time O(n log n).

#### Graph Painting


#### Number of Communities


#### Modularity Score


### 2 - Girvan-Newman Clustering
The Girvan–Newman algorithm detects communities by progressively removing edges from the original network. The connected components of the remaining network are the communities. Instead of trying to construct a measure that tells us which edges are the most central to communities, the Girvan–Newman algorithm focuses on edges that are most likely "between" communities.

#### Graph Painting


#### Number of Communities


#### Modularity Score
