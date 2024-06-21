/**
Stage type
Action performed
Spy mode of element used
Element type used
Count of occurrences in process

Example
Read; Read text; AA; Web element; 14
**/

BEGIN TRY 

   IF OBJECT_ID('tempdb..#AllData') IS NOT NULL
		DROP TABLE #AllData;
	IF OBJECT_ID('tempdb..#ElementData') IS NOT NULL
		DROP TABLE #ElementData;

	CREATE TABLE #AllData (ProcessId varchar(200), ProcessName varchar(128), ProcessType char ,XmlData xml)
	INSERT INTO #AllData 
	(ProcessId , ProcessName, ProcessType, XmlData )
	SELECT objc.processid, objc.name, objc.ProcessType, cast( objc.[processxml] as xml)
	  FROM [dbo].[BPAProcess] objc
	  WHERE objc.[processxml] IS NOT NULL
	  AND try_cast(objc.[processxml] as XML) IS NOT NULL


	 CREATE TABLE #ElementData (XmlData xml, ProcessId varchar(200), ProcessName varchar(128), ProcessType char , ElementName VARCHAR(128), ElementType VARCHAR(128), ElementId VARCHAR(128), IsRegion bit)
	;WITH elementData
	AS
	(
		SELECT element.query('./*') query 
			,allData.ProcessId AS ObjectId
			,allData.ProcessName AS ObjectName
			,allData.ProcessType
			,element.value('(element/@name)[1]','VARCHAR(128)') AS ElementName
			,element.value('(element/type/text())[1]','VARCHAR(128)') AS ElementType
			,element.value('(id/text())[1]','VARCHAR(128)') AS ElementId
			,0 AS IsRegion
		FROM #AllData as allData
			CROSS APPLY allData.XmlData.nodes('process/appdef/element') AS t(element)
		WHERE allData.ProcessType = 'O'
		AND element.value('(element/@name)[1]','VARCHAR(128)') IS NOT NULL

		UNION ALL

		SELECT groupedElements.query('./*') query
			,elementData.ObjectId
			,elementData.ObjectName 
			,elementData.ProcessType
			,groupedElements.value('(@name)[1]','VARCHAR(128)') AS ElementName
			,groupedElements.value('(type/text())[1]','VARCHAR(128)') AS ElementType
			,groupedElements.value('(id/text())[1]','VARCHAR(128)') AS ElementId
			,0 AS IsRegion
		FROM elementData 
			CROSS APPLY query.nodes('./group/element') AS t2(groupedElements)
		WHERE elementData.ProcessType = 'O'
		AND groupedElements.value('(element/@name)[1]','VARCHAR(128)') IS NOT NULL

		UNION ALL

		SELECT elements.query('./*') query
			,elementData.ObjectId
			,elementData.ObjectName 
			,elementData.ProcessType
			,elements.value('(@name)[1]','VARCHAR(128)') AS ElementName
			,elements.value('(type/text())[1]','VARCHAR(128)') AS ElementType
			,elements.value('(id/text())[1]','VARCHAR(128)') AS ElementId
			,0 AS IsRegion
		FROM elementData 
			CROSS APPLY query.nodes('./element') AS t2(elements)
		WHERE elementData.ProcessType = 'O'
		AND elements.value('(element/@name)[1]','VARCHAR(128)') IS NOT NULL
	)
	INSERT INTO #ElementData 
	SELECT * FROM elementData

	;WITH regionData
	AS
	(
		SELECT region.query('./*') query 
			,allData.ProcessId AS ObjectId
			,allData.ProcessName AS ObjectName
			,allData.ProcessType
			,region.value('(element/@name)[1]','VARCHAR(128)') AS ElementName
			,region.value('(element/type/text())[1]','VARCHAR(128)') AS ElementType
			,region.value('(id/text())[1]','VARCHAR(128)') AS ElementId
			,1 AS IsRegion
		FROM #AllData as allData
			CROSS APPLY allData.XmlData.nodes('process/appdef/element/region-container/region') AS t(region)
		WHERE allData.ProcessType = 'O'

		UNION ALL

		SELECT regions.query('./*') query
			,regionData.ObjectId
			,regionData.ObjectName 
			,regionData.ProcessType
			,regions.value('(@name)[1]','VARCHAR(128)') AS ElementName
			,regions.value('(type/text())[1]','VARCHAR(128)') AS ElementType
			,regions.value('(id/text())[1]','VARCHAR(128)') AS ElementId
			,1 AS IsRegion
		FROM regionData 
			CROSS APPLY query.nodes('./region') AS t2(regions)
		WHERE regionData.ProcessType = 'O'

		UNION ALL

		SELECT elements.query('./*') query
			,regionData.ObjectId
			,regionData.ObjectName 
			,regionData.ProcessType
			,elements.value('(@name)[1]','VARCHAR(128)') AS ElementName
			,elements.value('(type/text())[1]','VARCHAR(128)') AS ElementType
			,elements.value('(id/text())[1]','VARCHAR(128)') AS ElementId
			,0 AS IsRegion
		FROM regionData 
			CROSS APPLY query.nodes('./element') AS t2(elements)
		WHERE regionData.ProcessType = 'O'
	)
	INSERT INTO #ElementData 
	SELECT * FROM regionData
	
	;WITH actionData 
	AS 
	(
		SELECT allData.ProcessId,
			   allData.ProcessName,
			   action.value('(@name)[1]','VARCHAR(128)') AS ActionName,
			   action.value('(@type)[1]','VARCHAR(128)') AS ActionType,
			   action.value('(subsheetid/text())[1]','VARCHAR(128)') AS SubsheetId,
			   action.value('(step/@stage)[1]','VARCHAR(128)') AS StepStageName,
			   action.value('(step/element/@id)[1]','VARCHAR(128)') AS ElementId,
			   action.value('(step/action/id/text())[1]','VARCHAR(128)') AS ActionId
		FROM #AllData allData
			CROSS APPLY allData.XmlData.nodes('/process/stage') AS t(action)
		WHERE allData.ProcessType = 'O'
	) 
	, processData 
	AS 
	(
		SELECT allData.ProcessId,
			   allData.ProcessName,
			   s.value('(@type)[1]','VARCHAR(128)') AS StageType,
			   s.value('(resource/@object)[1]','VARCHAR(128)') AS ObjectName,
			   s.value('(resource/@action)[1]','VARCHAR(128)') AS ObjectActionName,
			   parentAction.SubsheetId AS ObjectActionSubSheetId
		FROM #AllData allData
			CROSS APPLY allData.XmlData.nodes('/process/stage') AS t(s)
            INNER JOIN (SELECT allData.ProcessName,
							   parentSheet.value('(@name)[1]','VARCHAR(128)') AS ActionName,
							   parentSheet.value('(subsheetid/text())[1]','VARCHAR(128)') AS SubsheetId
								FROM #AllData allData
									CROSS APPLY allData.XmlData.nodes('/process/stage') AS t(parentSheet)
							    WHERE allData.ProcessType = 'O'
								AND parentSheet.value('(@type)[1]','VARCHAR(128)') = 'SubSheetInfo'
								) parentAction ON parentAction.ProcessName = s.value('(resource/@object)[1]','VARCHAR(128)') AND parentAction.ActionName = s.value('(resource/@action)[1]','VARCHAR(128)')
		WHERE allData.ProcessType = 'P'
	) 
	SELECT a.ActionType as stagetype, 
	       a.ActionId as action, 
		   CASE
				WHEN e.ElementType LIKE 'UIA%' THEN 'UIA'
				WHEN e.ElementType LIKE 'SAP%' THEN 'SAP'
				WHEN e.ElementType LIKE 'AA%' THEN 'AA'
				WHEN e.ElementType LIKE 'Java%' THEN 'Java'
				WHEN e.ElementType LIKE 'Aisa%' THEN 'SmartVision'
				WHEN e.ElementType LIKE '%Web%' THEN 'Browser'
				WHEN e.IsRegion = 1 THEN 'RegionMode'
				ELSE 'Win32'
		   END AS spymode,
		   e.ElementType AS elementtype, 
		  COUNT(*) AS occurences
	FROM processData p
	INNER JOIN actionData a ON a.SubsheetId = p.ObjectActionSubSheetId
	INNER JOIN #ElementData e ON e.ElementId = a.ElementId
	WHERE a.ActionId IS NOT NULL
	GROUP BY a.ActionType, a.ActionId,  e.ElementType, e.IsRegion

	DROP TABLE #AllData
	DROP TABLE #ElementData
END TRY  
BEGIN CATCH  
      SELECT   
        ERROR_NUMBER() AS ErrorNumber  
       ,ERROR_MESSAGE() AS ErrorMessage;  

	   IF OBJECT_ID('tempdb..#AllData') IS NOT NULL
		DROP TABLE #AllData;
	   IF OBJECT_ID('tempdb..#ElementData') IS NOT NULL
		DROP TABLE #ElementData;
END CATCH  


