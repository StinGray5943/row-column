--solving SQL Query _Rows to Column in SQL
WITH Pivot_data as 
		(select *
		from
			(
			   select location as locations ,
			   continent as continent ,
			   convert (bigint, total_deaths) as totaldeaths 
				from  personal..CovidDeath 
			) as covid_data

		pivot 
			(
			sum(totaldeaths) 
			for  continent in ([North America], [Asia], [Africa], [Oceania],  
								   [South America], [Europe])
			) as pivot_table 
		UNION 

		select *
		from
			(
			   select 'Ztotal' as locations ,
			   continent as continent ,
			   convert (bigint, total_deaths) as totaldeaths 
				from  personal..CovidDeath 
			) as covid_data 

		pivot 
			(
			sum(totaldeaths) 
			for  continent in ([North America], [Asia], [Africa], [Oceania], 
								   [South America], [Europe])
			) as pivot_table ), 

  Final_data as 

	   ( select locations,
	      coalesce ([North America],0) as North_America ,
		  coalesce ([Asia],0) as Asia,
		  coalesce ( [Africa],0) as Africa,
		  coalesce ([Oceania],0) as Oceania,
		  coalesce ([South America],0) as South_America,
		  coalesce ( [Europe],0) as  Europe
		 from pivot_data)
select 
  *,
  case 
  when locations ='ZTOTAL' then ''
  else (North_America+Asia+Africa+Oceania+South_America+Europe)
  end as Total 
from Final_data
