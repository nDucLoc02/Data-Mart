


USE LOCKHEED_MARTIN_SYNAPSE

DECLARE @output nvarchar(max)
DECLARE @REPORT_DATE DATE = (SELECT CONVERT(DATE,GETDATE()))
DECLARE @MAX_DATE    DATE = (SELECT MAX(orderdate) FROM [Sales].[Orders])



--================================================================================================================================================== 
/*
=================================================================CUSTOMER REPORT - AUTHOR: Lộc ==================================================          
*/
--==================================================================================================================================================


DECLARE @current datetime;
SET @current = getdate()
SET @output = format(@current,'hh:mm:ss')
raiserror('start %s',0,1,@output) with nowait;


IF OBJECT_ID ('TEMPDB..[#CUSTOMER_PROFILE]','U') IS NOT NULL DROP TABLE [#CUSTOMER_PROFILE]

--MIS_DATE = REPORT_DATE = BALANCE_DATE

SELECT  
       [MIS_DATE]      = @REPORT_DATE
	  ,[PERIOD]        = CONVERT(NVARCHAR(7),@REPORT_DATE,23)
	  ,[CUSTOMER_CODE] = CustomerID
	  ,[CUSTOMER_NAME] = CustomerName
INTO [#CUSTOMER_PROFILE]
FROM [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Customers] 

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('CUSTOMER_PROFILE_DONE %s',0,1,@output) with nowait;


IF OBJECT_ID ('TEMPDB..[#CUSTOMER_DATA]','U') IS NOT NULL DROP TABLE [#CUSTOMER_DATA] 

SELECT
      [MIS_DATE]                     = @REPORT_DATE
	 ,[CUSTOMER_CODE]                = X1.custid
	  --TOTAL ORDERIDS 
	 ,[TOTAL_ORDERID_CURRENT_DATE]           = COUNT(DISTINCT CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = @MAX_DATE THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_ORDERID_1_MONTH_AGO]            = COUNT(DISTINCT CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-1,@MAX_DATE) THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_ORDERID_2_MONTH_AGO]            = COUNT(DISTINCT CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-2,@MAX_DATE) THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_ORDERID_3_MONTH_AGO]            = COUNT(DISTINCT CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-3,@MAX_DATE) THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_ORDERID_4_MONTH_AGO]            = COUNT(DISTINCT CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-4,@MAX_DATE) THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_ORDERID_5_MONTH_AGO]            = COUNT(DISTINCT CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-5,@MAX_DATE) THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_ORDERID_6_MONTH_AGO]            = COUNT(DISTINCT CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-6,@MAX_DATE) THEN CONCAT(X2.productid,X2.orderid) END)
	 --TOTAL REVENUE 
	 ,[TOTAL_REVENUE_CURRENT_DATE]           = ISNULL(SUM(CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = @MAX_DATE THEN X2.unitprice * X2.qty END),0)
	 ,[TOTAL_REVENUE_1_MONTH_AGO]            = ISNULL(SUM(CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-1,@MAX_DATE) THEN X2.unitprice * X2.qty END),0)
	 ,[TOTAL_REVENUE_2_MONTH_AGO]            = ISNULL(SUM(CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-2,@MAX_DATE) THEN X2.unitprice * X2.qty END),0)
	 ,[TOTAL_REVENUE_3_MONTH_AGO]            = ISNULL(SUM(CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-3,@MAX_DATE) THEN X2.unitprice * X2.qty END),0)
	 ,[TOTAL_REVENUE_4_MONTH_AGO]            = ISNULL(SUM(CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-4,@MAX_DATE) THEN X2.unitprice * X2.qty END),0)
	 ,[TOTAL_REVENUE_5_MONTH_AGO]            = ISNULL(SUM(CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-5,@MAX_DATE) THEN X2.unitprice * X2.qty END),0)
	 ,[TOTAL_REVENUE_6_MONTH_AGO]            = ISNULL(SUM(CASE WHEN X1.shippeddate IS NOT NULL AND X1.orderdate = DATEADD(MONTH,-6,@MAX_DATE) THEN X2.unitprice * X2.qty END),0)

	 --TOTAL SHIPPED ORDERIDS CURRENT DATE 
	 ,[TOTAL_SHIPPED_ORDERID_CURRENT_DATE]   = COUNT(DISTINCT CASE WHEN X1.orderdate = @MAX_DATE                   AND X1.shippeddate IS NOT NULL THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_SHIPPED_ORDERID_1_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X1.orderdate = DATEADD(MONTH,-1,@MAX_DATE) AND X1.shippeddate IS NOT NULL THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_SHIPPED_ORDERID_2_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X1.orderdate = DATEADD(MONTH,-2,@MAX_DATE) AND X1.shippeddate IS NOT NULL THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_SHIPPED_ORDERID_3_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X1.orderdate = DATEADD(MONTH,-3,@MAX_DATE) AND X1.shippeddate IS NOT NULL THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_SHIPPED_ORDERID_4_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X1.orderdate = DATEADD(MONTH,-4,@MAX_DATE) AND X1.shippeddate IS NOT NULL THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_SHIPPED_ORDERID_5_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X1.orderdate = DATEADD(MONTH,-5,@MAX_DATE) AND X1.shippeddate IS NOT NULL THEN CONCAT(X2.productid,X2.orderid) END)
	 ,[TOTAL_SHIPPED_ORDERID_6_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X1.orderdate = DATEADD(MONTH,-6,@MAX_DATE) AND X1.shippeddate IS NOT NULL THEN CONCAT(X2.productid,X2.orderid) END)
INTO [#CUSTOMER_DATA]
FROM [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X1
LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X2 ON X1.orderid = X2.orderid
GROUP BY X1.custid  


set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('CUSTOMER_DATA_DONE %s',0,1,@output) with nowait;


IF OBJECT_ID ('[LOCKHEED_MARTIN_SYNAPSE].[Sales].[CUSTOMER_REPORT]','U') IS NOT NULL DROP TABLE [LOCKHEED_MARTIN_SYNAPSE].[Sales].[CUSTOMER_REPORT] 

SELECT
      X1.MIS_DATE 
	 ,X1.[PERIOD]
	 ,X1.CUSTOMER_CODE 
     ,X2.[TOTAL_ORDERID_CURRENT_DATE]
     ,X2.[TOTAL_ORDERID_1_MONTH_AGO] 
     ,X2.[TOTAL_ORDERID_2_MONTH_AGO] 
     ,X2.[TOTAL_ORDERID_3_MONTH_AGO] 
     ,X2.[TOTAL_ORDERID_4_MONTH_AGO] 
     ,X2.[TOTAL_ORDERID_5_MONTH_AGO] 
     ,X2.[TOTAL_ORDERID_6_MONTH_AGO] 
     ,X2.[TOTAL_REVENUE_CURRENT_DATE]
     ,X2.[TOTAL_REVENUE_1_MONTH_AGO]  
     ,X2.[TOTAL_REVENUE_2_MONTH_AGO]  
     ,X2.[TOTAL_REVENUE_3_MONTH_AGO]  
     ,X2.[TOTAL_REVENUE_4_MONTH_AGO]  
     ,X2.[TOTAL_REVENUE_5_MONTH_AGO]  
     ,X2.[TOTAL_REVENUE_6_MONTH_AGO]  
     ,X2.[TOTAL_SHIPPED_ORDERID_CURRENT_DATE]
     ,X2.[TOTAL_SHIPPED_ORDERID_1_MONTH_AGO] 
     ,X2.[TOTAL_SHIPPED_ORDERID_2_MONTH_AGO] 
     ,X2.[TOTAL_SHIPPED_ORDERID_3_MONTH_AGO] 
     ,X2.[TOTAL_SHIPPED_ORDERID_4_MONTH_AGO] 
     ,X2.[TOTAL_SHIPPED_ORDERID_5_MONTH_AGO] 
     ,X2.[TOTAL_SHIPPED_ORDERID_6_MONTH_AGO] 
INTO [LOCKHEED_MARTIN_SYNAPSE].[Sales].[CUSTOMER_REPORT]
FROM [#CUSTOMER_PROFILE] X1
INNER JOIN [#CUSTOMER_DATA] X2 ON X1.MIS_DATE = X2.MIS_DATE AND X1.CUSTOMER_CODE = X2.CUSTOMER_CODE

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('CUSTOMER_REPORT %s',0,1,@output) with nowait;


--================================================================================================================================================== 
/*
=================================================================KPI REPORT - AUTHOR: Lộc =======================================================       
*/
--==================================================================================================================================================



IF OBJECT_ID ('[LOCKHEED_MARTIN_SYNAPSE].[Sales].[KPI_REPORT]','U') IS NOT NULL DROP TABLE [LOCKHEED_MARTIN_SYNAPSE].[Sales].[KPI_REPORT]


SELECT 
       MIS_DATE                       = @REPORT_DATE
      ,EMPLOYEE_NAME                  = CONCAT(X1.FirstName,' ',X1.LastName)
	  ,JOB_TITLE                      = X1.JOBTITLE
	  ,TOTAL_ORDERID                  = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL THEN CONCAT(X3.productid,X3.orderid) END)
	  ,TOTAL_ORDERID_2020             = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND YEAR(X2.orderdate) = YEAR(DATEADD(YEAR,-2,@MAX_DATE))  THEN CONCAT(X3.productid,X3.orderid) END)
	  ,TOTAL_ORDERID_2021             = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND YEAR(X2.orderdate) = YEAR(DATEADD(YEAR,-1,@MAX_DATE))  THEN CONCAT(X3.productid,X3.orderid) END)
	  ,TOTAL_ORDERID_2022             = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND YEAR(X2.orderdate) = YEAR(DATEADD(YEAR, 0,@MAX_DATE))  THEN CONCAT(X3.productid,X3.orderid) END)

	  ,[TOTAL_ORDERID_CURRENT_DATE]   = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = @MAX_DATE THEN CONCAT(X3.productid,X3.orderid) END)
	  ,[TOTAL_ORDERID_1_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-1,@MAX_DATE) THEN CONCAT(X3.productid,X3.orderid) END)
	  ,[TOTAL_ORDERID_2_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-2,@MAX_DATE) THEN CONCAT(X3.productid,X3.orderid) END)
	  ,[TOTAL_ORDERID_3_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-3,@MAX_DATE) THEN CONCAT(X3.productid,X3.orderid) END)
	  ,[TOTAL_ORDERID_4_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-4,@MAX_DATE) THEN CONCAT(X3.productid,X3.orderid) END)
	  ,[TOTAL_ORDERID_5_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-5,@MAX_DATE) THEN CONCAT(X3.productid,X3.orderid) END)
	  ,[TOTAL_ORDERID_6_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-6,@MAX_DATE) THEN CONCAT(X3.productid,X3.orderid) END)
	  ,[TOTAL_ORDERID_7_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-7,@MAX_DATE) THEN CONCAT(X3.productid,X3.orderid) END)
	  ,[TOTAL_ORDERID_8_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-8,@MAX_DATE) THEN CONCAT(X3.productid,X3.orderid) END)
	  ,[TOTAL_ORDERID_9_MONTH_AGO]    = COUNT(DISTINCT CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-9,@MAX_DATE) THEN CONCAT(X3.productid,X3.orderid) END)

	  ,[TOTAL_REVENUE]				  = SUM(CASE WHEN X2.shippeddate IS NOT NULL															THEN X3.unitprice * X3.qty ELSE 0 END)
	  ,[TOTAL_REVENUE_2020]           = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND YEAR(X2.orderdate) = YEAR(DATEADD(YEAR,-2,@MAX_DATE))  THEN X3.unitprice * X3.qty ELSE 0 END)
	  ,[TOTAL_REVENUE_2021]           = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND YEAR(X2.orderdate) = YEAR(DATEADD(YEAR,-1,@MAX_DATE))  THEN X3.unitprice * X3.qty ELSE 0 END)
	  ,[TOTAL_REVENUE_2022]           = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND YEAR(X2.orderdate) = YEAR(DATEADD(YEAR, 0,@MAX_DATE))  THEN X3.unitprice * X3.qty ELSE 0 END)

	 ,[TOTAL_REVENUE_CURRENT_DATE]    = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = @MAX_DATE THEN X3.unitprice * X3.qty END)
	 ,[TOTAL_REVENUE_1_MONTH_AGO]     = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-1,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_2_MONTH_AGO]     = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-2,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_3_MONTH_AGO]     = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-3,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_4_MONTH_AGO]     = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-4,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_5_MONTH_AGO]     = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-5,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_6_MONTH_AGO]     = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-6,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_7_MONTH_AGO]     = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-7,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_8_MONTH_AGO]     = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-8,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_9_MONTH_AGO]     = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-9,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_10_MONTH_AGO]    = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-10,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_11_MONTH_AGO]    = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-11,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
	 ,[TOTAL_REVENUE_12_MONTH_AGO]    = SUM(CASE WHEN X2.shippeddate IS NOT NULL AND X2.orderdate = DATEADD(MONTH,-12,@MAX_DATE) THEN X3.unitprice * X3.qty ELSE 0 END)
INTO [LOCKHEED_MARTIN_SYNAPSE].[Sales].[KPI_REPORT]
FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),X1.JOBTITLE

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('KPI_REPORT %s',0,1,@output) with nowait;

--================================================================================================================================================== 
/*
=================================================================TOP 5 STAFF REPORT - AUTHOR: Lộc ===============================================  
*/
--==================================================================================================================================================


IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_CURRENT_DATE]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_CURRENT_DATE]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_CURRENT_DATE' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_CURRENT_DATE]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = @MAX_DATE
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_CURRENT_DATE_DONE %s',0,1,@output) with nowait;

IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_1_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_1_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_1_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_1_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-1,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_1_MONTH_AGO_DONE %s',0,1,@output) with nowait;


IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_2_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_2_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_2_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_2_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-2,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_2_MONTH_AGO_DONE %s',0,1,@output) with nowait;


IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_3_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_3_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_3_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_3_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-3,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_3_MONTH_AGO_DONE %s',0,1,@output) with nowait;

IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_4_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_4_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_4_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_4_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-4,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_4_MONTH_AGO_DONE %s',0,1,@output) with nowait;


IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_5_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_5_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_5_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_5_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-5,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_5_MONTH_AGO_DONE %s',0,1,@output) with nowait;


IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_6_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_6_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_6_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_6_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-6,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]


set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_6_MONTH_AGO_DONE %s',0,1,@output) with nowait;

IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_7_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_7_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_7_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_7_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-7,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]


set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_7_MONTH_AGO_DONE %s',0,1,@output) with nowait;


IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_8_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_8_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_8_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_8_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-8,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]


set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_8_MONTH_AGO_DONE %s',0,1,@output) with nowait;



IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_9_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_9_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_9_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_9_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-9,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]


set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_9_MONTH_AGO_DONE %s',0,1,@output) with nowait;


IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_10_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_10_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_10_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_10_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-10,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]


set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_10_MONTH_AGO_DONE %s',0,1,@output) with nowait;


IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_11_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_11_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_11_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_11_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-11,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_11_MONTH_AGO_DONE %s',0,1,@output) with nowait;



IF OBJECT_ID ('TEMPDB..[#TOTAL_REVENUE_TOP5_STAFFS_12_MONTH_AGO]','U') IS NOT NULL DROP TABLE [#TOTAL_REVENUE_TOP5_STAFFS_12_MONTH_AGO]


SELECT
        DIMENSION = 'TOTAL_REVENUE_TOP5_STAFFS_12_MONTH_AGO' 
	   ,X.[PERIOD]
	   ,[REVENUE]   = SUM(X.[REVENUE])
INTO [#TOTAL_REVENUE_TOP5_STAFFS_12_MONTH_AGO]
FROM 
            (
				SELECT
					   MIS_DATE          = @REPORT_DATE      
					  ,[PERIOD]          = CONVERT(NVARCHAR(7),X2.orderdate,23)
					  ,[EMPLOYEE_NAME]   = CONCAT(X1.FirstName,' ',X1.LastName)
					  ,[REVENUE]         = SUM(X3.unitprice * X3.qty)
					  ,RANK_             = ROW_NUMBER() OVER (ORDER BY SUM(X3.unitprice * X3.qty) DESC)
				FROM [LOCKHEED_MARTIN_SYNAPSE].[HR].[Employees] X1
				LEFT JOIN [LOCKHEED_MARTIN_SYNAPSE].[Sales].[Orders] X2 ON X1.EmployeeID = X2.empid 
				LEFT JOIN[LOCKHEED_MARTIN_SYNAPSE].[Sales].[OrderDetails] X3 ON X2.orderid = X3.orderid
				WHERE X2.orderdate = DATEADD(MONTH,-12,@MAX_DATE)
				GROUP BY CONCAT(X1.FirstName,' ',X1.LastName),CONVERT(NVARCHAR(7),X2.orderdate,23)
			) X
WHERE X.RANK_ < 6
GROUP BY X.[PERIOD]


set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOTAL_REVENUE_TOP5_STAFFS_12_MONTH_AGO_DONE %s',0,1,@output) with nowait;


IF OBJECT_ID ('[LOCKHEED_MARTIN_SYNAPSE].[HR].[TOP_5_STAFF]','U') IS NOT NULL DROP TABLE [LOCKHEED_MARTIN_SYNAPSE].[HR].[TOP_5_STAFF]


SELECT
       MIS_DATE     = @REPORT_DATE   
	  ,PIVOT_TABLE.*
INTO [LOCKHEED_MARTIN_SYNAPSE].[HR].[TOP_5_STAFF]
FROM 
              (
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_1_MONTH_AGO]  UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_2_MONTH_AGO] 	UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_3_MONTH_AGO]	UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_4_MONTH_AGO]	UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_5_MONTH_AGO]	UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_6_MONTH_AGO]	UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_7_MONTH_AGO]	UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_8_MONTH_AGO]	UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_9_MONTH_AGO]	UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_10_MONTH_AGO]	UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_11_MONTH_AGO]	UNION ALL 
					SELECT * FROM [#TOTAL_REVENUE_TOP5_STAFFS_12_MONTH_AGO]	
			  ) AS PV 
			  PIVOT 
					 (SUM(REVENUE) FOR DIMENSION IN (
													[TOTAL_REVENUE_TOP5_STAFFS_1_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_2_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_3_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_4_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_5_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_6_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_7_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_8_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_9_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_10_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_11_MONTH_AGO]
												   ,[TOTAL_REVENUE_TOP5_STAFFS_12_MONTH_AGO] )
																				
				      ) AS  PIVOT_TABLE 


					 

set @output =  convert(char(8),dateadd(s,datediff(s,@current,getdate()),'1900-01-01'),8)
set @current = getdate()
raiserror('TOP_5_STAFF_DONE - OLIVER IS DONE %s',0,1,@output) with nowait;






