-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

-- Maximum number of layoff & maximum layoff percentage
SELECT MAX(total_laid_off) as maximum_laid_off
FROM layoffs_staging2;

-- Companies with 100% (1) layoffs

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Companies with 100% layoffs which raised funds in millions.

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies with their total number of layoffs

SELECT company, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Total number layoffs industry-wise

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Total number layoffs country-wise
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- Total number of layoffs per every year
SELECT YEAR(`date`) AS year_wise, SUM(total_laid_off) as total_layoffs
FROM layoffs_staging2
GROUP BY year_wise
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Rolling Sum of layoffs based on the month-wise in a particular year

SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE  SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
WHERE  SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
)
SELECT `month`,
total_layoff,
SUM(total_layoff) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_total;


-- Companies lay off per year 

SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- TOTAL LAYOFFS BY THE COMPANIES EVERY YEAR ORDERD BY TOTAL NUMBER OF LAYOFFS PER YEAR
SELECT company,YEAR(`date`) AS years, SUM(total_laid_off) AS total_lay_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Rank companies based on total laid offs partitioned by years.

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Rankings
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Rankings ASC;

-- Top 5 Companies Ranked based on total lay off per year.
 
WITH Company_Year AS
(
SELECT company,
YEAR(`date`) as years, 
SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2 
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Rankings
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Rankings <= 5; -- Top 5 Companies Ranked based on total lay off per year. 
;










