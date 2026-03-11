# Netflix-SQL-Analysis

This repository contains SQL queries and analysis performed on the Netflix Shows & Movies dataset extracted from Kaggle.

## Dataset

- Source: [Netflix Shows & Movies on Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)
- Rows: ~8,800
- Columns:
  - `show_id` – Unique ID for each title
  - `type` – Movie or TV Show
  - `title` – Name of the show or movie
  - `director` – Director(s) of the title
  - `cast` – List of main actors
  - `country` – Country where the title was produced
  - `date_added` – Date Netflix added the title
  - `release_year` – Original release year
  - `rating` – Content rating (e.g., PG-13, TV-MA)
  - `duration` – Duration in minutes (for movies) or seasons (for TV Shows)
  - `listed_in` – Genres/categories
  - `description` – Brief description of the title

**Note:** The dataset is sourced directly from Kaggle. Columns may contain NULL values for some titles.

## How to Use

1. Import `netflix_titles.csv` into your preferred SQL database (PostgreSQL recommended).  
2. Execute the `.sql` file in order, or run queries individually to explore different aspects of the dataset.  
3. The file contains queries with comments explaining the purpose and expected output.
