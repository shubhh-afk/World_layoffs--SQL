-- Data Cleaning

SELECT * 
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null Values or Blank Values
-- 4. Remove any columns

-- Creating a separate table and copy all the data from layoffs table.
CREATE TABLE layoffs_staging
LIKE layoffs; 

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1. Removing Duplicates ----------------------------------------------------

SELECT *, 
ROW_NUMBER() OVER 
(
PARTITION BY company, industry, total_laid_off, 
percentage_laid_off,`date`
) AS row_num
FROM layoffs_staging;
/*
Here we used Row_Number() function OVER PARTITION BY
We partitioned rows with these columns - company, industry, total_laid_off, 
percentage_laid_off,`date`.
When row_num = 1 then there are no duplicates,
if row_num > 1 then there are duplicates.
*/

-- create cte to check if row_num > 1;
WITH duplicates_cte AS
(
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, 
percentage_laid_off, `date`) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;

-- Cross checking if they are duplicates or not
SELECT *
FROM layoffs_staging
WHERE company = 'Oda';

/* After cross-check, there are some duplicates, but some columns have 
slightly different value.
*/

-- We have to include every column in PARTITION BY
WITH duplicates_cte AS
(
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` date DEFAULT NULL,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Now we have to remove only the duplicates from the table
-- To do this we have to create another table with same data but with added column row_num.
-- We will create the table then copy all the data obtained from cte select statement and 
-- insert it to the new table

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

-- Deleting the rows with row_num > 1. These are the duplicates.
DELETE
FROM layoffs_staging2
WHERE row_num > 1;


-- 2. Standardizing the data -----------------------------------------------------------------------

SELECT company, TRIM(company)
FROM layoffs_staging2;

-- updated the company column with trimmed comapny names removing any spaces
UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- change incorrect location names 
-- DÃ¼sseldorf to Düsseldorf
-- FlorianÃ³polis to Florianópolis
-- MalmÃ¶ to Malmo

UPDATE layoffs_staging2
SET location = CASE 
    WHEN location = 'DÃ¼sseldorf' THEN 'Düsseldorf'
    WHEN location = 'FlorianÃ³polis' THEN 'Florianópolis'
    WHEN location = 'MalmÃ¶' THEN 'Malmo'
    ELSE location
END;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- Here Crypto industry is written in 3 different ways, we have to replace them with standard one.

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Checking country column for any errors

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- "United States." has a trailing period "." 
-- Change it to "United states"

-- TRIM(TRAILING) function removes '.' trailing period from the end.
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

SELECT DISTINCT stage
FROM layoffs_staging2
ORDER BY 1;

-- The date column is of text datatype, we have to change it into date format

SELECT `date`,
str_to_date(`date`,'%m/%d/%Y') -- This function converts the text in given date format, dosen't change the datatype.
FROM layoffs_staging2;

-- change the date format 
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`,'%m/%d/%Y');

-- to really change the datatype of "date" column from text to date, we have to ALTER the column.
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_staging2;

-- NOTE- ALWAYS CONVERT THE DATE COLUMN INTO PROPER DATE FORMAT AND THEN CONVERT THE DATATYPE TO AVOID ANY
-- POTENTIAL DATA LOSS. 
-- ** Do not ALTER datatype of a column on the raw data table. **

-- 3. ELIMINATING OR POPULATING NULL VALUES -----------------------------------------------------------------------------

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR industry = '';

-- Checking if the columns with missing data can be populated or not?
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- After checking, we have 2 rows, where one industry column is blank and other has data.
-- This can be the case for other rows too. So we can populate the relevant data in the Null/blank columns. 


-- This query identifies companies in the layoffs_staging2 table where:
-- - One row has a missing or empty 'industry' value (NULL or ''),
-- - And another row for the same company has a valid 'industry' value (not NULL).
-- The purpose is to find and possibly correct missing 'industry' values based on existing data.

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '') 
AND t2.industry IS NOT NULL;

-- Set industry = NULL where value is blank. 
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- SET null industry values of t1 to their respective industry value(not null) from t2. 
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;


SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; -- These are the rows that may not be usefull.

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; -- Deleted those rows

SELECT * FROM layoffs_staging2;
-- We don't need the row_num column anymore

-- 4. Removing extra columns ---------------------------------------
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- 1. Removed Duplicates ✅
-- 2. Standardized the data ✅
-- 3. Null Values or Blank Values Populated and Eliminated ✅
-- 4. Removed any columns ✅




































