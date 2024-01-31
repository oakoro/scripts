CREATE FUNCTION [dbo].[Get_DateList_uft] (
         @PartofDate as VARCHAR(10), --year, month, week, day, hour, minute
         @StartDate AS SMALLDATETIME,
         @EndDate  AS SMALLDATETIME = TIMESTAMP
 
)
   RETURNS TABLE AS RETURN
/******************************************************************************
*   SP Name: Get_DateList_uft
* File Name: Get_DateList_uft.sql
*   Created: 01/25/2007, Jim Evans
*      Desc: Returns a table on Date at the year, month, week, day, hour, or minute level.
*      Note: The number generator CTE came from a 2007 SQL Magazine article by Itzik Ben-Gan.
*  Modified:
*
* Example:
      SELECT DateList FROM dbo.Get_DateList_uft('DAY','20170101',NULL) AS DateListTbl;
      SELECT DateList FROM dbo.Get_DateList_uft('Hour','20170101',NULL) AS DateListTbl;
******************************************************************************/
--Convert time stamps to 00:00:00.000
WITH 
   LIST0 (Numbers) AS (SELECT 0 UNION ALL SELECT 0),                     --2 rows
   LIST1 (Numbers) AS (SELECT 0 FROM LIST0 A CROSS JOIN LIST0 B),        --4 rows
   LIST2 (Numbers) AS (SELECT 0 FROM LIST1 AS A CROSS JOIN LIST1 AS B),  --16 rows
   LIST3 (Numbers) AS (SELECT 0 FROM LIST2 AS A CROSS JOIN LIST2 AS B),  --256 rows
   LIST4 (Numbers) AS (SELECT 0 FROM LIST3 AS A CROSS JOIN LIST3 AS B),  --65536 rows
   LIST5 (Numbers) AS (SELECT 0 FROM LIST4 AS A CROSS JOIN LIST4 AS B)   --4294967296 rows
 
   SELECT @StartDate as 'DateList' --bring Start date back in because ROW_NUMBER() starts at 1!
   UNION ALL
   SELECT 
   TOP (CASE @PartofDate
         WHEN 'DAY' THEN DATEDIFF(DAY,@StartDate,COALESCE(@EndDate,GETDATE()))
         WHEN 'HOUR' THEN DATEDIFF (HOUR,@StartDate,COALESCE(@EndDate,GETDATE()))
         WHEN 'YEAR' THEN DATEDIFF (YEAR,@StartDate,COALESCE(@EndDate,GETDATE()))
         WHEN 'MONTH' THEN DATEDIFF (MONTH,@StartDate,COALESCE(@EndDate,GETDATE()))
         WHEN 'WEEK' THEN DATEDIFF (WEEK,@StartDate,COALESCE(@EndDate,GETDATE()))
         WHEN 'MINUTE' THEN DATEDIFF (MINUTE,@StartDate,COALESCE(@EndDate,GETDATE()))
      END)
      (CASE @PartofDate
         WHEN 'DAY' THEN DATEADD(DAY,ROW_NUMBER() OVER (ORDER BY Numbers), @StartDate)
         WHEN 'HOUR' THEN DATEADD(HOUR,ROW_NUMBER() OVER (ORDER BY Numbers), @StartDate)
         WHEN 'YEAR' THEN DATEADD(YEAR,ROW_NUMBER() OVER (ORDER BY Numbers), @StartDate)
         WHEN 'MONTH' THEN DATEADD(MONTH,ROW_NUMBER() OVER (ORDER BY Numbers), @StartDate)
         WHEN 'WEEK' THEN DATEADD(WEEK,ROW_NUMBER() OVER (ORDER BY Numbers), @StartDate)
         WHEN 'MINUTE' THEN DATEADD(MINUTE,ROW_NUMBER() OVER (ORDER BY Numbers), @StartDate)
      END) AS DateList
   FROM LIST5
GO
 
--Test the Function call
SELECT DateList FROM dbo.Get_DateList_uft('DAY','20190101','20191231') AS DateListTbl;
SELECT DateList FROM dbo.Get_DateList_uft('Hour','2019-01-01 00:00:00',NULL) AS DateListTbl;
GO