--EDA: Exploratory Data Analysis
--Looking at Total Cases vs Total Deaths
-- Find Death Percentage: shows likelihood of dying if you contrcat covid in your country
SELECT 
location,
date,
total_cases,
total_deaths,
ROUND((total_deaths/total_cases)*100,2) as deathrate
FROM coviddeaths
ORDER BY 1,2; 

-- Looking at the total cases vs poopulation
--Shows what percentage of population got Covid
SELECT 
continent,
date,
population,
total_cases,
(total_cases/population)*100 as infection_rate
FROM coviddeaths
ORDER BY 1,2; 

--Looking at Countries with Highest Infection Rate compared to Population
SELECT 
continent, 
population,
mAX((total_cases/population)*100) as infection_rate
FROM coviddeaths
WHERE (total_cases/population)*100 IS NOT NULL
GROUP BY 1, 2
ORDER BY infection_rate DESC;

--Showing Countries with Highest Death Count per Population 
SELECT 
continent, 
MAX(total_deaths) as total
FROM coviddeaths
WHERE continent IS NOT NULL AND total_deaths IS NOT NULL
GROUP BY 1
ORDER BY total DESC;

--Showing Countries with Highest Death Rate Count per Population 
SELECT 
continent, 
MAX((total_deaths/total_cases)*100) as death_rate
FROM coviddeaths
WHERE continent IS NOT NULL AND total_deaths IS NOT NULL
GROUP BY 1
ORDER BY death_rate DESC;

--Lets break things down by continent
--Showing continents with the highest death count
SELECT
location,
MAX(total_deaths) as maxtotaldeaths
FROM coviddeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY 2 DESC;

--Global Numbers per Continent
SELECT
continent,
SUM(new_cases) as total_cases,
SUM(new_deaths) as total_deaths,
sum(new_deaths)/sum(new_cases)*100 AS percentagedeathrate
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 4 DESC;

--Total Amount of People in the World that got vaccinated
SELECT
v.continent,
sum(c.population),
sum(v.total_vaccinations)
FROM coviddeaths c
JOIN covidvaccinations v
ON c.location = v.location AND c.date = v.date
WHERE v.continent IS NOT NULL
GROUP BY v.continent
ORDER BY 3 DESC; 

--Amount of New Vaccination per Country
SELECT
v.continent, 
v.location, 
v.date,
c.population, 
v.new_vaccinations,
SUM(v.new_vaccinations) OVER (PARTITION BY v.location ORDER BY v.date) as rolling_people_vaccinated
FROM coviddeaths c
JOIN covidvaccinations v
ON c.location = v.location AND c.date = v.date
WHERE v.continent IS NOT NULL
ORDER BY 2,3;

--How many people in total were vaccinated per country using CTE
WITH t1 AS (
SELECT
v.continent, 
v.location, 
v.date,
c.population, 
v.new_vaccinations,
SUM(v.new_vaccinations) OVER (PARTITION BY v.location ORDER BY v.date) as rolling_people_vaccinated
FROM coviddeaths c
JOIN covidvaccinations v
ON c.location = v.location AND c.date = v.date
WHERE v.continent IS NOT NULL
ORDER BY 2,3
)

SELECT
t1.location,
MAX(t1.rolling_people_vaccinated) AS total_vaccination
FROM t1
WHERE t1.new_vaccinations IS NOT NULL
GROUP BY 1
ORDER BY total_vaccination DESC ;

-- PERCENTAGE INCREASE OF PEOPLE VACCINATED PER COUNTRY
SELECT
v.continent, 
v.location, 
v.date,
c.population, 
v.new_vaccinations,
SUM(v.new_vaccinations) OVER (PARTITION BY v.location ORDER BY v.date) AS rolling_people_vaccinated,
SUM(v.new_vaccinations) OVER (PARTITION BY v.location ORDER BY v.date)/c.population *100
FROM coviddeaths c
JOIN covidvaccinations v
ON c.location = v.location AND c.date = v.date
WHERE v.continent IS NOT NULL
ORDER BY 2,3;

--Moving Average of Daily New Deaths for each country
SELECT 
location,
date,
total_cases,
new_deaths,
SUM(new_deaths) OVER (PARTITION BY location ORDER BY date),
SUM(new_deaths) OVER (PARTITION BY location ORDER BY date)/total_cases *100
FROM coviddeaths
ORDER BY 1; 
























