
SELECT *
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
-- WHERE continent IS NOT NULL
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Population

SELECT location, date, total_cases, population, (total_cases/population)*100 AS infection_rate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at countries with highest infection rates
SELECT location, population, MAX(total_cases) AS highest_infection_count, (MAX(total_cases)/population)*100 AS infection_rate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC


-- Showing countries with highest death count

SELECT location, population, MAX(total_cases) AS highest_infection_count, (MAX(total_cases)/population)*100 AS infection_rate, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 5 DESC

-- Breaking things down by continents

	SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_death_count
	FROM PortfolioProject.dbo.CovidDeaths
	WHERE continent IS NOT NULL
	GROUP BY continent
	ORDER BY 2 DESC

	-- Global Numbers

	SELECT SUM(new_cases) AS world_new_cases, SUM(cast(new_deaths AS INT)) AS world_new_deaths, SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 AS new_death_rate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

-- Date wise global numbers

	SELECT date, SUM(new_cases) AS world_new_cases, SUM(cast(new_deaths AS INT)) AS world_new_deaths, SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 AS new_death_rate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- Looking at Total Population vs Total Vaccinations using CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, aggregate_new_vaccinations)
AS 
(
SELECT dea.continent, dea.location, dea.date, vac.population, new_vaccinations,
SUM(CONVERT(INT, new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) AS aggregate_new_vaccinations
FROM PortfolioProject.dbo.CovidDeaths vac
JOIN PortfolioProject.dbo.CovidVaccinations dea
ON vac.location = dea.location
AND vac.date = dea.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (aggregate_new_vaccinations/population)*100 AS percent_people_vaccinated
FROM PopvsVac
ORDER BY 2,3

-- Using Temp Table

DROP TABLE IF EXISTS #PercentagePeopleVaccinated
CREATE TABLE #PercentagePeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
aggregate_new_vaccinations numeric
)
INSERT INTO #PercentagePeopleVaccinated
SELECT dea.continent, dea.location, dea.date, vac.population, new_vaccinations,
SUM(CONVERT(bigint, new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) AS aggregate_new_vaccinations
FROM PortfolioProject.dbo.CovidDeaths vac
JOIN PortfolioProject.dbo.CovidVaccinations dea
ON vac.location = dea.location
AND vac.date = dea.date
WHERE dea.continent IS NOT NULL

SELECT *, (aggregate_new_vaccinations/population)*100 AS percent_people_vaccinated
FROM #PercentagePeopleVaccinated
--ORDER BY 2,3


--Creating View for visualisations

CREATE VIEW PercentagePeopleVaccinated AS
SELECT dea.continent, dea.location, dea.date, vac.population, new_vaccinations,
SUM(CONVERT(INT, new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) AS aggregate_new_vaccinations
FROM PortfolioProject.dbo.CovidDeaths vac
JOIN PortfolioProject.dbo.CovidVaccinations dea
ON vac.location = dea.location
AND vac.date = dea.date
WHERE dea.continent IS NOT NULL