library(dplyr)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(gdata)
library(scales)
library(plotly)
library(shinythemes)
library(dashboardthemes)


ui <- fluidPage(
  theme = shinytheme("flatly"),


  titlePanel("Content Based Movie Recommender"),
  fluidRow(column(width=10,"Using data from IMDb, this application finds movies similar to the one entered using cosine similarity.
                  Movies are ordered with the most similar movies at the top.")),
  br(),
  fluidRow(column(width=4,
  selectizeInput("movie",
                 label = h5("Type the name of a movie"),
                 choices = NULL,selected=NULL, multiple = F,options = list(placeholder = 'e.g. The Matrix',create = FALSE,maxOptions = 20000)),

  
  ),column(width=4,
           numericInput("num_val",h5("Number of recommended movies"),min=1,value=10)
           
           )),
  
      column(11,DT::dataTableOutput("df_movies_analysis_table"))
  
)



