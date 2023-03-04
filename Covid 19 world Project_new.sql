
SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
ORDER BY 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4

-- Select data we are going to be using

SELECT [location], [date], total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
ORDER BY 1,2

-- Looking at Total cases Vs Total Death

SELECT [location], [date], total_cases, total_deaths, CAST(total_deaths as decimal(18,4)) / CAST(total_cases as decimal(18,4))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE [location] = 'Canada' AND continent is not NULL
ORDER BY 1,2


-- Looking at Total cases Vs Population

SELECT [location], [date], population, total_cases, CAST(total_cases as decimal(18,4)) / CAST(population as decimal(18,4))*100 AS InfectedPercentage
FROM PortfolioProject..CovidDeaths
WHERE [location] = 'Canada' AND continent is not NULL
ORDER BY 1,2


-- Looking at Countries with highest infection rate compared to Population

SELECT [location], population, MAX(total_cases) AS HighestInfectionCount, MAX(CAST(total_cases as decimal(18,4)) / CAST(population as decimal(18,4))*100) AS InfectedPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
--WHERE [location] = 'Canada'
GROUP BY [location], population
ORDER BY InfectedPercentage DESC


-- Looking at Countries with highest Death count per Population

SELECT [location], MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
--WHERE [location] = 'Canada'
GROUP BY [location]
ORDER BY TotalDeathCount DESC


-- Looking at Continent with highest Death count per Population

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
--WHERE [location] = 'Canada'
GROUP BY [continent]
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as decimal)) AS Total_deaths, SUM(CAST(new_deaths as decimal)) / SUM(new_cases)*100 AS DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
--GROUP BY [date]
ORDER BY 1,2


-- GLOBAL NUMBERS PER DAY

SELECT [date], SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as decimal)) AS Total_deaths, SUM(CAST(new_deaths as decimal)) / SUM(new_cases)*100 AS DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
GROUP BY [date]
ORDER BY 1,2

-- Looking at Total population Vs Total Vaccination

SELECT dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations, 
SUM(CONVERT(decimal, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
ORDER BY 2,3


--- Using CTE

WITH PopVsVac (Continent, location, data, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations, 
SUM(CONVERT(decimal, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
From PopVsVac


--Using TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
new_vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations, 
SUM(CONVERT(decimal, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


-- Creating view to store data for later visualization

CREATE view PercentPopulationVaccinated AS
SELECT dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations, 
SUM(CONVERT(decimal, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
--ORDER BY 2,3


SELECT *
From PercentPopulationVaccinated


-- Looking at Total Population Vs Total Death

SELECT dea.continent, dea.[location], dea.[date], dea.population, dea.total_deaths, 
SUM(CONVERT(decimal, dea.total_deaths)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleDead
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
ORDER BY 2,3


--- Using CTE

WITH PopVsDea (Continent, location, data, population, total_deaths, RollingPeopleDead)
AS
(
SELECT dea.continent, dea.[location], dea.[date], dea.population, dea.total_deaths, 
SUM(CONVERT(decimal, dea.total_deaths)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleDead
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleDead/population)*100
From PopVsDea


--Using TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationDead
CREATE TABLE #PercentPopulationDead
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
total_deaths NUMERIC,
RollingPeopleDead NUMERIC
)

INSERT INTO #PercentPopulationDead
SELECT dea.continent, dea.[location], dea.[date], dea.population, dea.total_deaths, 
SUM(CONVERT(decimal, dea.total_deaths)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleDead
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleDead/population)*100
From #PercentPopulationDead


-- Creating view to store data for later visualization

CREATE view PercentPopulationDead AS
SELECT dea.continent, dea.[location], dea.[date], dea.population, dea.total_deaths, 
SUM(CONVERT(decimal, dea.total_deaths)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleDead
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
--ORDER BY 2,3


SELECT *
From PercentPopulationDead







-- Looking at Total Population Vs Total Infection Cases

SELECT dea.continent, dea.[location], dea.[date], dea.population, dea.total_cases, 
SUM(CONVERT(decimal, dea.total_cases)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleInfected
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
ORDER BY 2,3


--- Using CTE

WITH PopVsInf (Continent, location, data, population, total_cases, RollingPeopleInfected)
AS
(
SELECT dea.continent, dea.[location], dea.[date], dea.population, dea.total_cases, 
SUM(CONVERT(decimal, dea.total_cases)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleInfected
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleInfected/population)*100
From PopVsInf


--Using TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationInfected
CREATE TABLE #PercentPopulationInfected
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
total_cases NUMERIC,
RollingPeopleInfected NUMERIC
)

INSERT INTO #PercentPopulationInfected
SELECT dea.continent, dea.[location], dea.[date], dea.population, dea.total_cases, 
SUM(CONVERT(decimal, dea.total_cases)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleInfected
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleInfected/population)*100
From #PercentPopulationInfected


-- Creating view to store data for later visualization

CREATE view PercentPopulationInfected AS
SELECT dea.continent, dea.[location], dea.[date], dea.population, dea.total_cases, 
SUM(CONVERT(decimal, dea.total_cases)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleInfected
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
--ORDER BY 2,3


SELECT *
From PercentPopulationInfected

