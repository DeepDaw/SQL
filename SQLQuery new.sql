select * from census..Data1$
select * from census..Sheet1$

Select top 3 d.State ,d.Population,  d.District  from
( select*, RANK() OVER (Partition By c.state order by c.population desc)as rnk from 
(select  a.sex_ratio, a.State ,b.Population,b.District from Census..Data1$ a inner join Census..Sheet1$ b 
on a.District=b.District) c) d ;