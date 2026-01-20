--select max(instancetime),min(instancetime) from BPAScheduleLog

 select instancetime, DATEPART(YEAR,instancetime)[YEAR],DATEPART(QUARTER,instancetime)[QUARTER],
   DATEPART(MONTH,instancetime)[MONTH],DATEDIFF(DAY,instancetime,GETDATE())'Age'
   FROM [dbo].BPAScheduleLog
   order by instancetime,DATEPART(MONTH,instancetime) ,DATEPART(QUARTER,instancetime)


   delete BPAScheduleLog
   where DATEDIFF(DAY,instancetime,GETDATE()) > 14
   /*
   >200 == 455475
   >100 == 492095
   >50 == 252784
   >14 == 177650

   */