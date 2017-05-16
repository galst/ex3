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
#betweenness
betweenness <- betweenness(gtc_graph, v=V(gtc_graph))
betweenness
```

     addison       altman      arizona        avery        colin        denny 
    44.08333     76.00000      0.00000      0.00000      0.00000      0.00000 
       derek         finn         grey         hank        izzie        karev 
    17.95000      0.00000     46.86667      0.00000     47.95000     95.26667 
      kepner         lexi mrs. seabury        nancy       olivia     o'malley 
     0.00000     36.00000      0.00000      0.00000      4.95000     54.41667 
        owen      preston        sloan        steve       torres         yang 
    60.00000      0.00000    115.36667      0.00000     67.15000     43.00000 

Sloan has the highest betweeness centrality with 115.36667

#### Closeness
The closeness of a node is a measure of centrality in a network, calculated as the sum of the length of the shortest paths between the node and all other nodes in the graph. 
``` r
#closeness
closeness <- closeness(gtc_graph, vids=V(gtc_graph))
closeness
```
     addison       altman      arizona        avery        colin        denny 
     0.016949153  0.013698630  0.012658228  0.011494253  0.007751938  0.010989011 
       derek         finn         grey         hank        izzie        karev 
     0.013698630  0.010101010  0.012987013  0.010989011  0.014492754  0.016949153 
      kepner         lexi mrs. seabury        nancy       olivia     o'malley 
    0.012345679  0.015384615  0.012345679  0.012345679  0.013698630  0.015873016 
        owen      preston        sloan        steve       torres         yang 
    0.011235955  0.007751938  0.016949153  0.010101010  0.017543860  0.009345794 
    
Torress has the highest closeness centrality with 0.017543860

#### Eigenvector
Eigenvector is a measure of the influence of a node in a network. It assigns relative scores to all nodes in the network based on the concept that connections to high-scoring nodes contribute more to the score of the node in question than equal connections to low-scoring nodes.
``` r

```


Sloan has the highest Eigenvector measure with 

## Question 1.b

### 1 - Louvain Clustering
The Louvain Method for community detection is a method to extract communities from large networks created by Vincent Blondel, Jean-Loup Guillaume, Renaud Lambiotte and Etienne Lefebvre.[1] The method is a greedy optimization method that appears to run in time O(n log n).

``` r
#cluster louvain
set.seed(1)
cl <- cluster_louvain(graph)
cl
```

     IGRAPH clustering multi level, groups: 6, mod: 0.59
     + groups:
       $`1`
       [1] "bailey" "ben"    "tucker"

       $`2`
       [1] "addison" "derek"   "finn"    "grey"    "steve"  

       $`3`
       [1] "avery" "lexi"  "nancy" "sloan"

       $`4`
       + ... omitted several groups/vertices

#### Graph Painting

``` r
plot(graph, vertex.color=membership(cl))
```

![](images/cluster1.png)

#### Number of Communities

We can see from the table provided above that the number of communities = **6**

#### Modularity Score

We can see from the table provided above that the modularity score = **0.59**


### 2 - Girvan-Newman Clustering
The Girvan–Newman algorithm detects communities by progressively removing edges from the original network. The connected components of the remaining network are the communities. Instead of trying to construct a measure that tells us which edges are the most central to communities, the Girvan–Newman algorithm focuses on edges that are most likely "between" communities.

``` r
#cluster edge betweenness
set.seed(1)
ceb <- cluster_edge_betweenness(graph)
ceb
```
     IGRAPH clustering edge betweenness, groups: 7, mod: 0.58
     + groups:
       $`1`
       [1] "addison"      "avery"        "karev"        "kepner"       "lexi"        
       [6] "mrs. seabury" "nancy"        "sloan"       

       $`2`
       [1] "adele"       "chief"       "ellis grey"  "susan grey"  "thatch grey"

       $`3`
       [1] "altman"  "colin"   "owen"    "preston" "yang"   

       + ... omitted several groups/vertices
   
       
#### Graph Painting
``` r
plot(graph, vertex.color=membership(ceb))
```

#### Number of Communities
We can see from the table provided above that the number of communities = **7**

#### Modularity Score
We can see from the table provided above that the modularity score = **0.58**



## Question 2.a
