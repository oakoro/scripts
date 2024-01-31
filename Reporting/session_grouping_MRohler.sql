;with cte
as
(
select startdatetime, DATEPART(hh,startdatetime)'Hour',DATEPART(dd,startdatetime)'Day', DATEPART(ww,startdatetime)'Week',DATEPART(yy,startdatetime)'Year',
ROW_NUMBER() over (partition by DATEPART(yy,startdatetime) order by DATEPART(yy,startdatetime),DATEPART(ww,startdatetime) ,DATEPART(dd,startdatetime), DATEPART(hh,startdatetime) asc ) AS RowNum
from dbo.BPASession)
select Hour, Day, Week, Year, count(RowNum) 'TotalSession' from cte
group by  Hour, Day, Week, Year
order by Year desc, Week desc, Day desc, Hour desc
