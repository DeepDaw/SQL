select * from Census.dbo.data1;

select * from Census.dbo.data2;

/*1.number of rows into our dataset */

select count(*) from Census..data1
select count(*) from Census..data2

/*2. dataset found for jharkhand and bihar */

select * from Census..data1 where state in ('Jharkhand' ,'Bihar')

/*3. population of India */

select sum(population) as Population from Census..data2

/*4. avg growth */

select state,avg(growth)*100 avg_growth from Census..data1 group by state;

/*5. avg sex ratio */

select state,round(avg(sex_ratio),0) avg_sex_ratio from Census..data1 group by state order by avg_sex_ratio desc;

/*6. avg literacy rate */
 
select state,round(avg(literacy),0) avg_literacy_ratio from Census..data1 
group by state having round(avg(literacy),0)>90 order by avg_literacy_ratio desc ;

/*7. top 3 state showing highest growth ratio */


select state,avg(growth)*100 avg_growth from Census..data1 group by state order by avg_growth desc limit 3;


/*8. total males and females */

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from Census..data1 a inner join Census..data2 b on a.district=b.district ) c) d
group by d.state;

/*9. total literacy rate */


select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from Census..data1 a 
inner join Census..data2 b on a.district=b.district) d) c
group by c.state

/*10. population in previous census */


select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from Census..data1 a inner join Census..data2 b on a.district=b.district) d) e
group by e.state)m



/*11. output top 3 districts from each state with highest literacy rate */


select a.* from
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from Census..data1) a

where a.rnk in (1,2,3) order by state


/*12. name of the highest population distrct from each state */

Select  d.State ,d.Population,d.District  from
( select*, RANK() OVER (Partition By c.state order by c.population desc)as rnk from 
(select  a.sex_ratio, a.State ,b.Population,b.District from Census..Data1 a inner join Census..data2 b 
on a.District=b.District) c) d where rnk=1;

/*13. Top 3 states with higesht population in  district */

Select top 3 d.State ,d.Population,  d.District  from
( select*, RANK() OVER (Partition By c.state order by c.population desc)as rnk from 
(select  a.sex_ratio, a.State ,b.Population,b.District from Census..Data1 a inner join Census..Data2 b 
on a.District=b.District) c) d ;
