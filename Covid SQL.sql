



SELECT location,date, total_cases, new_cases, total_deaths, population
FROM PROJECT..Coviddeaths
ORDER BY 1,2

-- Looking at Total Cases Vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country 

SELECT location,date, total_cases, total_deaths, (Total_deaths/total_cases)*100 AS DeathPercentage
FROM PROJECT..Coviddeaths
WHERE location LIKE '%asia%'
ORDER BY 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population contracted Covid

SELECT location,date,population, total_cases, (Total_deaths/population)*100 AS DeathPercentage
FROM PROJECT..Coviddeaths
WHERE location LIKE '%asia%'
ORDER BY 1,2


-- Looking at Countries with Highest Ifection Rate compared to Population

SELECT location,population,MAX( total_cases)AS HighestInfectionCount, MAX((Total_deaths/population))*100 AS PercentPopulationInfected
FROM PROJECT..Coviddeaths
GROUP by Location, Population
ORDER BY PercentPopulationInfected 

-- Showing Countries with  Death Count per Population

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM PROJECT..Coviddeaths
GROUP by Location
ORDER BY TotalDeathCount DESC



-- Showing continents with the highest death counts 

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM PROJECT..Coviddeaths
WHERE continent IS NOT NULL
GROUP by continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

SELECT date ,SUM(new_cases)AS total_cases, SUM(cast(new_deaths as int))AS total_deaths,SUM(cast(new_deaths as int))/
SUM(New_cases)*100 AS DeathPercentage
FROM PROJECT..Coviddeaths
WHERE continent IS NOT NULL
Group By date
ORDER BY 1,2

--  Looking at Total Population Vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
SUM(int,vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated,
(RollingPeopleVaccinated/population)*100
FROM Coviddeaths dea
JOIN CovidVaccinations vac ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL
order by 2,3


-- TEMP TABLE
DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
SUM(int,vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated,
(RollingPeopleVaccinated/population)*100
FROM Coviddeaths dea
JOIN CovidVaccinations vac ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL
order by 2,3

-- Creating View to store data for visulations

CREATE VIEW DeathCount as 
SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM PROJECT..Coviddeaths
WHERE continent IS NOT NULL
GROUP by continent


SELECT *
FROM deathcount