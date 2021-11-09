library(dplyr)
library(tidyverse)
library(splitstackshape)
library(class)
library(doBy)
library(pdist)
library(data.table)
library(caret)
library(lsa)
library(Matrix)
library(DT)
options(scipen=999)

shinyServer(function(input, output,session) {
#content based recommender system 

df_movies_analysis_genres <- fread("df_movies_analysis_genres.csv")
df_movies_vars_matrix <- as.matrix(fread("df_movies_scaled.csv"))
genresMatrix <- as.matrix(fread("genres.csv"))

updateSelectizeInput(session,selected="", 'movie', choices = sort(df_movies_analysis_genres$primaryTitle), server = TRUE)
  

output$df_movies_analysis_table = DT::renderDataTable({
  validate(
    need(input$movie != "", "Please type a movie")
        )
        
  validate(
    need(input$num_val != "" & input$num_val!=0 & input$num_val%%1==0, "Please enter an integer for number of recommended movies")
        )
        
        directorWriterMatrix <- df_movies_analysis_genres[,c("directorName","writerName")] %>% sparse.model.matrix(~.-1,.) #sparse matrix of director and writer
        
        M <- cbind(df_movies_vars_matrix,genresMatrix,directorWriterMatrix)
        
        v <- as.vector(M[which(df_movies_analysis_genres$primaryTitle == input$movie),])
        cosSim <- as.vector(( M %*% v ) / sqrt( sum(v*v) * rowSums(M*M) ))
        ii <- match(sort(cosSim, decreasing=TRUE)[2:(input$num_val+1)],cosSim)
        
        df_movies_analysis_genres$numVotes <- format(df_movies_analysis_genres$numVotes,big.mark=",")
        df_movies_analysis_table = df_movies_analysis_genres[ii,c("primaryTitle","startYear","genres","averageRating","numVotes","directorName","writerName")]
        colnames(df_movies_analysis_table) = c("Movie Title","Release Year","Genres", "Average IMDB rating","Number of IMDB Votes", "Director","Writer")
        
        DT::datatable(df_movies_analysis_table,options = list(lengthChange=FALSE, pageLength = 25,searching=FALSE))
  
  })

})


