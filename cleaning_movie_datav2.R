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

df_name <- read_tsv('name.basics.tsv.gz', na = "\\N", quote = '') #read in file with names of people in film
df_crew <- read_tsv('title.crew.tsv.gz', na = "\\N", quote = '') #file with movie as id and associated director and writer
df_crew$directors <- gsub(",.*$", "", df_crew$directors) #taking only first director for each movie for now
df_crew$writers <- gsub(",.*$", "", df_crew$writers) #taking only first director for each movie for now

directors <- df_crew %>% #select only director id and movie id
        select(tconst,directors)

writers <- df_crew %>% #select only writer id and movie id
  select(tconst,writers)

df_directors <- left_join(directors,df_name, by = c("directors"="nconst"))%>% #dataframe of director name and movie id
        select(tconst,primaryName) %>%
        rename(directorName=primaryName)

df_writers <- left_join(writers,df_name, by = c("writers"="nconst"))%>% #dataframe of writer name and movie id
        select(tconst,primaryName) %>%
        rename(writerName=primaryName)


df_ratings <- read_tsv('title.ratings.tsv.gz', na = "\\N", quote = '')
df_title <- read_tsv('title.basics.tsv.gz', na = "\\N", quote = '')
df_movies <- df_title[df_title$titleType=="movie",]
df_movies_joined <- inner_join(df_movies, df_ratings,
                               by = c("tconst" = "tconst"))

df_movies_joined <- df_movies_joined[df_movies_joined$isAdult==0,] #subset movies that are not adult
df_movies_joined <- df_movies_joined[df_movies_joined$numVotes>3000,] #minimum number of votes of 2000

df_movies_joined <- left_join(df_movies_joined,df_directors,by=c("tconst" = "tconst")) #get director names
df_movies_joined <- left_join(df_movies_joined,df_writers,by=c("tconst" = "tconst")) #get writer names

df_movies_analysis <- df_movies_joined[,c("primaryTitle","startYear","runtimeMinutes","genres","averageRating","numVotes","directorName","writerName")]

#######
n_occur <- data.frame(table(df_movies_analysis$primaryTitle))
titles_more_than_one_occurence <- n_occur[n_occur$Freq>1,] #indicate movie titles where the title occurs more than once. Below appends release year to duplicate titles

df_movies_joined_multiple_titles <- left_join(df_movies_analysis,titles_more_than_one_occurence, by = c("primaryTitle"="Var1")) #left join to get flag records with more than one occurence
df_movies_joined_multiple_titles[!is.na(df_movies_joined_multiple_titles$Freq), ]$primaryTitle = 
  paste(df_movies_joined_multiple_titles[!is.na(df_movies_joined_multiple_titles$Freq), ]$primaryTitle, 
        as.character(df_movies_joined_multiple_titles[!is.na(df_movies_joined_multiple_titles$Freq), ]$startYear)) #where freq is not na, paste the movie release year to the end of the title

df_movies_analysis <- df_movies_joined_multiple_titles[,1:ncol(df_movies_joined_multiple_titles)-1]
df_movies_analysis <- df_movies_analysis[complete.cases(df_movies_analysis),]

df_movies_analysis_info <- df_movies_analysis[,c("primaryTitle","startYear","genres","averageRating","numVotes","directorName","writerName")]
write.csv(df_movies_analysis,"df_movies_analysis_genres.csv",row.names = FALSE)


df_movies_analysis <- splitstackshape::cSplit_e(df_movies_analysis, "genres", sep = ',', fill = 0, type = "character") #make dummy variables out of genre
df_movies_analysis <- df_movies_analysis %>% select(-genres)
df_movies_analysis_to_write <- df_movies_analysis[,6:ncol(df_movies_analysis)]
df_movies_analysis_genres <- df_movies_analysis_to_write[,3:ncol(df_movies_analysis_to_write)]

write.csv(df_movies_analysis_to_write,"df_movies_analysis.csv",row.names = FALSE)
write.csv(df_movies_analysis_genres,"genres.csv",row.names = FALSE)


df_movies_other_vars <- df_movies_analysis[,c("startYear","runtimeMinutes","averageRating","numVotes")]

pp = preProcess(df_movies_other_vars, method = "range")
df_movies_scaled <- predict(pp,df_movies_other_vars)
write.csv(df_movies_scaled,"df_movies_scaled.csv",row.names = FALSE)





















