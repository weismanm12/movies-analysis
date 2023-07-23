# IMDb-analysis

## Table of Contents
1. [Introduction](#introduction)
2. [Process](#process)
3. [Extracting, Cleaning and Validating Raw Data with Python](#cleaning)
4. [Creating PostgreSQL Database and Loading Cleaned Data](#database-creation-loading)
5. [Analyzing Movies Database via SQL and Python](#analysis)

## Introduction
<a name="introduction"><a/>

In this project I will be extracting public movie data from the popular movie and tv show database IMDb. IMDb contains information related to movies, tv shows, actors, actresses, and other visual entertainment content. For the purpose of this project I will be focusing exclusively on data related to movies.

The [data related to IMDb](https://developer.imdb.com/non-commercial-datasets/) is publicaly available for non-commercial use on IMDb's website. In this project, I extracted, cleaned, and normalized this data and created a PostgreSQL database called "movies" to store this data locally. I then performed analysis to find trends in movie production, audience reception, and actor likeness.

---
## Process
<a name="process"><a/>

### 1. Extracting, Cleaning, and Validating Raw Data with Python
   - Raw data was extracted from IMDb dataset, cleaned, and transformed into a format optimal for analysis of movie data.
### 2. Creating PostgreSQL database and loading cleaned data
   - After the data was properly transformed and normalized, a PostgreSQL database called `movies` was created for optimal storage and retrieval
### 3. Analyzing PostgeSQL database via SQL and Python
   - The newly created movies database was analyzed using SQL to extract the necessary data and Python to transform/visualize results

---
## Extracting, Cleaning, and Validating Raw Data with Python
<a name="cleaning"><a/>

The first step of this project involved extracted the datasets from IMDb, cleaning the data, and structuring the data in a format optimized for storage in a SQL database and analysis. Below is an abbrevated version of this process. To view the full process along with the Python code, see the [Raw Data Cleaning Jupyter Notebook](https://nbviewer.org/github/weismanm12/imdb-analysis/blob/main/raw_data_cleaning.ipynb#loading-and-viewing-raw-data).

### Raw Data ER Model

See the conceptual relational model of all the files extracted from IMDb. Note that this ER model is based on my interpretation and is unofficial.

![original model](original_model.png)

#### Table Descriptions
- **title.basics**:Data related to all titles in IMDB database. Includes movies, tv show episodes, live action plays, etc.
- **name.basics**: Data related to all individuals who have participated in the production of a title. Includes actors/actresses, writers, directors, costume designers, etc.
- **title.principals**: Mapping table between the name.basics table and title.basics table. A record exists for every individual involved in a title.
- **title.ratings**: Contains the average rating and number of votes for records in the "titles" Table. This is a one-to-one optional relationship, meaning an individual title could have a max of one record in the "ratings" table, but could not have one as well. Since this is a one-to-one relationship, these two tables should be combined.
- **title.akas**: Contains all alternative titles for a local region/country for each unique record in "title.basics" table.

To view more details about these tables and their respective columns see the [Raw Data Dictionary](raw_data_dictionary.ipynb).

### Cleaning, Validation and Transformation Process
Though this data comes from a reputable source, thorough cleaning and validation was needed. The data contained in these files was cleaned and validated by filtering out non-movie related data, removing invalid data, and ensuring no duplicates where necessary. The data was also transformed by removing unnecessary columns, combining certain tables, and unnesting array data types using associative tables. To view the full process, see the [Raw Data Cleaning Jupyter Notebook](https://nbviewer.org/github/weismanm12/imdb-analysis/blob/main/raw_data_cleaning.ipynb#loading-and-viewing-raw-data).

### Transformed ER Model

See a visual representation of the structure of the transformed data. This also serves as the structure of the PostgreSQL database created in the next step.

![updated_model](updated_model.png)

#### Table Descriptions
- **movies**: Contains all movies in IMDb database and relevant information about each movie.
- **actors**: Stores information related to actors in movies.
- **movie_cast**: Mapping table between actors and movies tables identifying all actors in every movie.
- **genres**: Contains all distinct genres a movie can be tagged as.
- **movie_genres**: Mapping table between movies and genres table identifying all genres a movie has.

To view more details about these tables and their respective columns see the [Updated Data Dictionary](updated_data_dictionary.ipynb).

---
## Creating PostgreSQL Database and Loading Cleaned Data
<a name="database-creation-loading"><a/>

After the raw data was thoroughly cleaned and transformed, a PostgreSQL database called `movies` was created for storage. To view the SQL code, view the [Database Creation Script](database_creation_script.sql). 

The cleaned data was then loaded into the movies database via sqlalchemy. See the this process in the [Data Loading Jupyter Notebook](data_loading.ipynb).

---
## Analyzing Movies Database via SQL and Python
<a name="analysis"><a/>

The newly created `movies` database containing information related to movies and actors was then explored to find insights. This analysis revealed trends in movie production, genre popularity, correlation between movie attributes and average rating, and actor popularity. See an abbreviated version of this analysis below.

Please note that the below analysis does not contain any code. **If you would like to see the extended analysis including the SQL and Python code**, see the [Analysis Jupyter Notebook](https://nbviewer.org/github/weismanm12/imdb-analysis/blob/main/analysis.ipynb). Additionally, all visualtions can be found in the [Analysis Visualizations folder](Analysis%Visualizations) and all datasets can be found in the [Analysis Datasets folder](Analysis%Datasets).

### Selecting a Sample Dataset

The movies contained in the `movies` database contains an extension number of movies, however, the awareness and accessibility of these films very greatly. This awareness/accessibility can be measured by the number of reviews a movie has received. See a histogram showing this distribution below.

<p align="center">
  <img src="./Analysis%20Visualizations/histogram_of_number_of_ratings.png" alt="hist of movie ratings">
</p>

It can be seen that there is extreme variance in the number of ratings each movie has received, with the majority have less than 500 ratings. However, we are most interested in well-known productions on the opposite end of the spectrum. For this reason, only movies **within the top 10\% in terms of the number of ratings a movie has received partitioned by the decade will be considered**. Partitioning by the decade helps account for the older movies receiving less ratings than newer movies.

___

### Movie Production Over Time

<p align="center">
  <img src="./Analysis%20Visualizations/movies_released_by_year.png" alt="movie_production">
</p>

The line chart depicts movie production trends over time, highlighting significant developments around 1915, minimal change until the millennium, a steep decline during the Great Depression in 1929, and exponential growth from the 2000s. Notably, the COVID-19 pandemic caused a slight dip in 2020, impacting movie production in the subsequent years, which is gradually recovering to pre-pandemic levels.

___

### Movie Production by Genre

<p align="center">
  <img src="./Analysis%20Visualizations/movies_released_by_genre.png" alt="production_by_genre">
</p>

Genre production analysis reveals interesting insights into the movie industry's diversity. Drama leads with 28.1%, followed by Comedy (16.1%) and Action (9.1%). Crime and Romance genres hold nearly identical shares at 9.0% and 8.6%, respectively. Thriller and Adventure occupy significant portions with 7.8% and 6.4% each. Horror and Mystery equally share 6.4% of the film industry. Lastly, Biography contributes 3.0% to the cinematic world. These percentages showcase the filmmakers' diverse use of genres and creative abilities.

<br />

### Movies Production by Genre Pairs

<p align="center">
  <img src="./Analysis%20Visualizations/movies_released_by_genre_pairs.png" alt="production_by_genre pairs">
</p>

Any movie can have multiple genres, creating subgenres which consist of combinations of individual genres. Above we can see the popularity of these pairs in movie production. Among these, Drama frequently pairs with Romance, Comedy, and Thriller genres, creating engaging narratives. Additionally, Crime and Mystery genres often complement each other, forming intriguing crime thriller stories. This exploration showcases filmmakers' creativity in blending genres to craft compelling and entertaining films.

___

### Audience Preference by Genre

<p align="center">
  <img src="./Analysis%20Visualizations/weighted_average_movie_rating_by_genre.png" alt="production_by_genre pairs">
</p>

Above we can see the weighted average rating each movie genre typically receives. Biographies stand out as the highest rated genre, followed be dramas and crime movies. However, all genres are fairly close in terms of average rating.

Note that a weighted average was calculated by factoring in the percentile each movie ranked in in terms of the number of reviews it received. Movies in the higher percentiles within each genre had a larger impact on the aveerage rating than those with fewer. Additionally, only genres within the top ten most produced (found in the analysis of movie production by genre) were considered.

<br />

### Audience Reception by Genre Pairs

<p align="center">
  <img src="./Analysis%20Visualizations/heatmap_of_weighted_average_movie_rating_by_genre_pairs.png" alt="genre_pairs_ratings">
</p>

This heatmap shows the average ratings of the top 10 movie genres produced by pairs. We can see that most pairs are fairly close in rating, with biographies standing out as among the highest rated, other than its pair with Horror, which is typically the most disliked movie genre.

The same weighting system was used to calculate average rating for pairs of genres as singlular movie genre weighting.

___

### Movie Length and Reception

<p align="center">
  <img src="./Analysis%20Visualizations/distribution_of_movie_ratings_by_length_in_minutes.png" alt="length_vs_rating">
</p>

The scatterplot indicates a weak positive correlation (correlation coefficient of 0.28) between movie length and average rating, implying that longer movies tend to receive slightly higher ratings on average. However, correlation does not imply causation, and other factors like genre and cast may influence ratings. The majority of movies fall within the 1-3 hour length, and the correlation mainly applies to movies in this range.

___

### Most Favored Actors

<p align="center">
  <img src="./Analysis%20Visualizations/top_rated_movie_actors.png" alt="popular_actors">
</p>

This bar chart reveals the actors in which the movies the individuals appear in have the highest average rating. Toshirô Mifune tops the list with an average rating of 7.71, followed by Leonardo DiCaprio in second place with a rating of 7.42. The remaining actors share similar average ratings, with Charles Laughton and Walter Brennan tied for third at 7.20. James Stewart, Anthony Quinn, Ingrid Bergman, Claude Rains, Brad Pitt, and Jean Arthur also receive consistently high ratings, ranging from 7.12 to 7.16, indicating widespread audience appreciation for their performances.

Note that this visualization was filtered to only contain well-known actors in American Cinema. A list was scraped from [this article ranking the top 1000 actors and actresses](https://www.imdb.com/list/ls058011111/?sort=list_order,asc&mode=detail) on the IMDb website.

<br />

### Longest Tenured Actors

<p align="center">
  <img src="./Analysis%20Visualizations/most_individual_acting_credits.png" alt="most_acting_credits">
</p>

This visualization shows the actors with the most acting roles. Robert De Niro leads with 86 credits, followed closely by Bruce Willis (85) and John Wayne (84). Nicolas Cage and Samuel L. Jackson also have impressive numbers (83 and 73 credits). Many other actors have substantial credits, highlighting their prolific careers and contributions to the film industry.

This list was also filtered for well known actors in American Cinema using the list of the [top 1000 actors and actresses](https://www.imdb.com/list/ls058011111/?sort=list_order,asc&mode=detail).

___

### Finding the Most Acclaimed Movies of All Time

<p align="center">
  <img src="./Analysis%20Visualizations/top_rated_movies_of_all_time.png" alt="top_movies">
</p>

The top rated movies of IMDb can be seen in this visualization. "The Shawshank Redemption" and "The Godfather," are the two highest rated films, with ratings of 9.3 and 9.2, respectively. The remaining films follow close behing, with multiple films receiving average ratings of 9.0 and the rest receiving ratings just under 9.0 (note that ties were broken by votes received). It can also be seen that films from five different decades made the top 15, showing the excellence of film making over time.

Note that only films among the highest in terms of the number of ratings received were considered. The sample data used within this data was further filtered to only include those within the top 1% of ratings in their respective decade, ensuring that only widely admired films were considered.
