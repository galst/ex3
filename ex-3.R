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

#betweenness
betweenness <- betweenness(gtc_graph, v=V(gtc_graph))
betweenness

#closeness
closeness <- closeness(gtc_graph, vids=V(gtc_graph))
closeness

#eigenvector
#TODO:

#cluster louvain
set.seed(1)
cl <- cluster_louvain(graph)
cl
plot(graph, vertex.color=membership(cl))

#cluster edge betweenness
set.seed(1)
ceb <- cluster_edge_betweenness(graph)
ceb
plot(graph, vertex.color=membership(ceb))


#facebook data mining
#using this: https://www.youtube.com/watch?v=EDuAj7lYp0w tutorial

install.packages("Rfacebook")
install.packages("tm")
install.packages("RCurl")
install.packages("SnowballC")
install.packages("wordcloud")

library(Rfacebook)
library(tm)
library(RCurl)
library(SnowballC)
library(wordcloud)

app_id <- "219936741834182"
app_secret <- "1e8ad2627d99702754e9487af039a571"
fb_oauth <- fbOAuth(app_id, app_secret)
access_token <- "EAADICANevcYBALERIpywySq2x3YZBNBU9Wr2jR4ZA8Vsh5aQTWtngZAsIZAMi8zFRroGCEVkJBI9ab1ZBpLws3KYrxQhnVZB4DDm6yML9vZCDHAb4HJZACgZAjUca67Jyl3t7klRQfNRUMuYp8oldMeLKzPZAhucyCXscZD"

nike_page <- getPage(page="nike", token=access_token)
nike_post <- getPost(post=nike_page$id[1], n=100, token=access_token)
nike_message <- (nike_post$comments)$message

docs <- Corpus(VectorSource(nike_message))

toSpace <- content_transformer(function(x,pattern) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

#Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))

#Remove numbers
docs <- tm_map(docs, removeNumbers)

#Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))

#Remove punctuations
docs <- tm_map(docs, removePunctuation)

#Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)

#Text stemming
docs <- tm_map(docs, stemDocument)

#Word counts
tdm <- TermDocumentMatrix(docs)
m <- as.matrix(tdm)
v <- sort(rowSums(m), decreasing=TRUE)
d <- data.frame(word=names(v), freq=v)
head(d, 10)

#Draw word cloud
wordcloud(words=d$word, freq=d$freq, min.freq=1, max.words=200, random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))

#Transform data into an adjacency matrix
#using this: https://rdatamining.wordpress.com/2012/05/17/an-example-of-social-network-analysis-with-r-using-package-igraph/

tdm <- TermDocumentMatrix(docs)
freq_terms <- findFreqTerms(tdm, lowfreq=10)
tdm <- tdm[freq_terms, ]
m <- as.matrix(tdm)
m[m >= 1] <- 1
tm <- m %*% t(m)

#Create the graph
#build a graph from the above matrix
graph <- graph.adjacency(tm, weighted=T, mode="undirected")
#remove loops
graph <- simplify(graph)
#set labels and degrees of vertices
V(graph)$label <- V(graph)$name
V(graph)$degree <- degree(graph)
#design the graph
V(graph)$label.cex <- 2.2 * V(graph)$degree / max(V(graph)$degree)+ .2
V(graph)$label.color <- rgb(0, 0, .2, .8)
V(graph)$frame.color <- NA
egam <- (log(E(graph)$weight)+.4) / max(log(E(graph)$weight)+.4)
E(graph)$color <- rgb(.5, .5, 0, egam)
E(graph)$width <- egam

layout <- layout.fruchterman.reingold(graph)
plot(graph, layout=layout)

#betweenness
betweenness <- betweenness(graph, v=V(graph))
betweenness

#closeness
closeness <- closeness(graph, vids=V(graph))
closeness

#eigenvector
#TODO:

#cluster louvain
set.seed(1)
cl <- cluster_louvain(graph)
cl
plot(graph, vertex.color=membership(cl))

#cluster edge betweenness
set.seed(1)
ceb <- cluster_edge_betweenness(graph)
ceb
plot(graph, vertex.color=membership(ceb))


