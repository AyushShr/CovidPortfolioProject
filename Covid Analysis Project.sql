Select *
From PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations$
--Order by 3,4



SELECT location,date, total_cases,new_cases, total_deaths,population
From PortfolioProject..CovidDeaths$
order by 1,2

-- Total cases vs total deaths


SELECT location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where location like '%India%'
order by 1,2


--Total cases vs Population
--precentage that got covid

SELECT location,date, total_cases,population, (total_cases/population)*100 as Infected
From PortfolioProject..CovidDeaths$
where location like '%India%'
order by 1,2


--countries with heigest infection rate

SELECT location,population, MAX(total_cases) as HeigestInfectionCount , MAX((total_cases/population))*100
	as PercentageInfected
From PortfolioProject..CovidDeaths$
GROUP BY location,population
order by PercentageInfected desc

 --Countries heigest death count

 Select location, MAX(cast(total_deaths as int)) as TotalDeaths
 From PortfolioProject..CovidDeaths$
 where continent is null
 Group by location
 Order by TotalDeaths desc

--Continent with heigest death count
 Select location, MAX(cast(total_deaths as int)) as TotalDeaths
 From PortfolioProject..CovidDeaths$
 where continent is null
 Group by location
 Order by TotalDeaths desc
 

 --Golbal numbers by date

 Select date, Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(CAST(new_deaths as int))
		/SUM(new_cases)*100 as DeathPercentage
 From PortfolioProject..CovidDeaths$
 where continent is not null
 Group by date
 Order by 1,2


 --Total population vs Vaccinations 
 Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
	,Sum(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY 
	dea.location, dea.Date)as RollingPeopleVaccinated
 From PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
order by 2,3


--CTE

WITH PopvsVac(Continent, location, date,population,new_vaccinations,RollingPeopleVaccinated)
as(
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
	,Sum(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY 
	dea.location, dea.Date)as RollingPeopleVaccinated
 From PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
)
Select*, (RollingPeopleVaccinated/population)*100 as percentage
FROM PopvsVac


--Temp Table
DROP Table if exists PercentageofPeopleVaccinated
Create Table PercentageofPeopleVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentageofPeopleVaccinated
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
	,Sum(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY 
	dea.location, dea.Date)as RollingPeopleVaccinated
 From PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null

Select*
From PercentageofPeopleVaccinated

CREATE VIEW PercentagepopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
	,Sum(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY 
	dea.location, dea.Date)as RollingPeopleVaccinated
 From PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null

