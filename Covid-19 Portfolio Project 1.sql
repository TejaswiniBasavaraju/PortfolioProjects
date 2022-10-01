select *
from Portfolioproject..CovidDeaths
order by 3,4

select *
from Portfolioproject..Covidvaccinations
order by 3,4

--select data that we are going to be using

select Location,date,total_cases,new_cases,total_deaths,population
from Portfolioproject..CovidDeaths
order by 1,3

--Looking at Total cases vs TotalDeaths

select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from Portfolioproject..CovidDeaths
where location like '%india%'
order by 1,2

--Looking at Total cases vs population
--Shows what percentage population got covid
select Location,date,total_cases,total_deaths,population,(total_cases/population)*100 as DeathPercentage
from Portfolioproject..CovidDeaths
where location like '%india%'
order by 1,2

--Looking at countries with highest infection rate compared to population
--descending order
select Location,population,MAX(total_cases) as HighestInfectionCount,MAX(total_cases/population)*100 as PercentagePopulationInfected
from Portfolioproject..CovidDeaths
Group by Location,population
order by PercentagePopulationInfected desc

--Looking at countries with highest infection rate compared to population
--ascending order

select Location,population,MAX(total_cases) as HighestInfectionCount,MAX(total_cases/population)*100 as PercentagePopulationInfected
from Portfolioproject..CovidDeaths
Group by Location,population
order by PercentagePopulationInfected asc

--Showing countries with highest Death count per population

select location,MAX(cast (total_deaths as int)) as TotaldeathCount
from Portfolioproject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by location
order by TotaldeathCount desc


--lets BREAK THINGS DOWN BY Continent

select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolioproject..CovidDeaths
where continent is null
Group by location
order by TotalDeathCount desc

--Global numbers

select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Portfolioproject..CovidDeaths
where continent is not null
--Group by date
order by 1,2

select *
from Portfolioproject..CovidDeaths dea
join Portfolioproject..CovidVaccinations vac on
vac.location=dea.location and dea.date=vac.date

--looking at total populaion vs vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.Location order by dea.location,dea.date) as RollingPeoplevaccinated--,(RollindPeoplevaccinated/population)*100
from Portfolioproject..CovidDeaths dea
join Portfolioproject..CovidVaccinations vac 
on vac.location=dea.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

--USE CTE
with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.Location order by dea.location,dea.date) as RollingPeoplevaccinated--,(RollindPeoplevaccinated/population)*100
from Portfolioproject..CovidDeaths dea
join Portfolioproject..CovidVaccinations vac 
on vac.location=dea.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *
from PopvsVac