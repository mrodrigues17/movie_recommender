# Content Based Movie Recommender System
Using data take from IMDb (https://datasets.imdbws.com/), I did some initial data filtering and transformations to create sparse matrices to apply cosine similarity. Cosine similarity takes a vector of interest (subsetted by the movie title indicated by the user) and returns the cosine of the angle between all other vectors in the projected multidimensional space. Smaller angles indicate higher similarity, so similarity scores are sorted with the most similar options returned to the user. The user can also specify the number of movies returned.
 - UI file: controls user interface included the ability to select movie titles and the number of recommendations
 - Server file: creates the output for the Shiny application
 - data cleaning file: reads data from IMDb files and performs filtering and feature transformations

The application is available here: https://maxrodrigues5591.shinyapps.io/Movie_Recommender/
