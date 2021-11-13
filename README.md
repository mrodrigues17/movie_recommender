# Content-Based Movie Recommender System
- Used data take from [IMDb](https://datasets.imdbws.com/) to do feature engineering and create sparse matrices.
- Using cosine similarity, users select a vector of interest by indicating a movie title they like to get movie titles similar to the title they entered. The user can also specify the number of movies returned.
- UI file: controls user interface included the ability to select movie titles and the number of recommendations
- Server file: creates the output for the Shiny application
- data cleaning file: reads data from IMDb files and performs filtering and feature transformations

The application is available [here](https://maxrodrigues5591.shinyapps.io/Movie_Recommender/)
