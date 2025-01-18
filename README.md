# Global Layoffs Data Analysis 

This project focuses on analyzing global layoffs data from the years 2020 to 2023 using MySQL. The primary objective was to clean a raw dataset containing layoff records and conduct an exploratory data analysis (EDA) to extract valuable insights regarding trends in layoffs across various companies, industries, countries, and years. The project showcases data cleaning, transformation, and the use of SQL to conduct analysis and present meaningful results.

## Project Breakdown

### 1. **Data Cleaning**

The raw dataset required significant cleaning to ensure its readiness for analysis. Key steps in the data cleaning process included:

- **Removing Duplicates**: Identified and removed duplicate entries that could have skewed the analysis.
- **Standardizing Data**: Ensured consistency in column names, data formats, and values to improve dataset readability and usability.
- **Handling Null and Blank Values**: Managed missing or blank entries to ensure the integrity and accuracy of the data.
- **Removing Irrelevant Columns**: Eliminated columns that did not contribute to the analysis or were redundant.

These cleaning steps were crucial in transforming the raw data into a structured format for further exploration.

### 2. **Exploratory Data Analysis (EDA)**

After cleaning, the data was subjected to a series of analytical queries to uncover meaningful insights. Key analyses included:

- **Companies that Raised Millions, Laid Off 100%, and Shut Down**: Focused on companies that raised substantial funding but later faced 100% layoffs or shut down operations.
- **Companies with 100% Layoffs**: Identified and analyzed companies that had to lay off their entire workforce.
- **Total Layoffs Industry-Wise**: Analyzed the layoffs by industry, highlighting sectors most impacted by workforce reductions.
- **Total Layoffs Country-Wise**: Provided insights into layoffs based on geographical regions and countries.
- **Yearly Layoff Trends**: Analyzed trends in layoffs year by year to observe the overall trajectory and spikes in layoffs.
- **Rolling Sum of Layoffs (Monthly)**: Calculated the rolling sum of layoffs on a month-to-month basis for each year to observe seasonal trends and patterns.
- **Top Layoff Companies Per Year**: Ranked companies based on the total number of layoffs each year, showcasing those with the most significant impact.

### 3. **Insights and Findings**

The analysis revealed several noteworthy trends, including:

- Industries such as technology, retail, and hospitality saw the highest number of layoffs.
- Certain countries, especially in North America and Europe, were most affected by large-scale layoffs.
- A distinct pattern of layoffs emerged during economic downturns or global events, such as the COVID-19 pandemic.

## Technologies Used

- **MySQL**: The entire project was carried out using MySQL for data storage, querying, and analysis.
- **SQL Queries**: Complex SQL queries were used for data cleaning, aggregation, and to perform the exploratory analysis.
  
## Project Outcomes

This project demonstrates proficiency in:

- Data cleaning and transformation techniques in SQL.
- Creating insightful queries to analyze large datasets and extract actionable insights.
- Understanding of trends and patterns in global layoffs and their impact on various sectors and regions.
