/*
============================================================================================
This Code Creates a DDL script for the bronze layer and by running this code you are 
redefining the structure of the bronze layer 
and also building a stored procedure for extracting data from a CSV files
We are using here TRUNC & INSERT method
============================================================================================
*/





IF OBJECT_ID('bronze.crm_cust_info' , 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id INT ,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date Date
);


IF OBJECT_ID('bronze.crm_prd_info' , 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
	prd_id			 INT ,
	prd_key			 VARCHAR(50),
	prd_nm			 VARCHAR(50),
	prd_cost		 INT,
	prd_line		 VARCHAR(50),
	prd_start_dt	 DATE,
	prd_end_dt		 DATE
);



IF OBJECT_ID('bronze.crm_sales_details' , 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num		NVARCHAR(50),
	sls_prd_key		NVARCHAR(50),
	sls_cust_id		INT,
	sls_order_dt	INT,
	sls_ship_dt		INT,
	sls_due_dt		INT,
	sls_sales		INT,
	sls_quantity	INT,
	sls_price	    INT
)



IF OBJECT_ID('bronze.erp_loc_a101' , 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
)



IF OBJECT_ID('bronze.erp_cust_az12' , 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
	cid NVARCHAR(50),
	bdate DATE ,
	gen NVARCHAR(50)
)



IF OBJECT_ID('bronze.erp_px_cat_g1v2 ' , 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2 ;
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id				NVARCHAR(50),
	cat		NVARCHAR(50),
	subcat		NVARCHAR(50),
	maintenance		NVARCHAR(50)
)





-- EXTRACT THE DATA FROM CSV FILES TO OUT TABLES
-- BULK INSERT : inserting large data not iteration one by one used with csv and exol files
-- WE will put them all in a stored procedure so we can run this every day to put data in dwh daily


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

	DECLARE @start_time DATETIME , @end_time DATETIME, @batch_start_time DATETIME , @batch_end_time DATETIME
	BEGIN TRY

		PRINT('==============================');
		PRINT('Loading bronze layer');
		PRINT('==============================');

		PRINT('-------------------------------');
		PRINT('Loading CRM Tables');
		PRINT('-------------------------------');

		set @batch_start_time = GETDATE();

		set @start_time = GETDATE();
		PRINT('>> Truncating Table:bronze.crm_cust_info');
		TRUNCATE TABLE bronze.crm_cust_info; -- THIS STEP IN ORDER NOT TO UPLOAD THE DATATWICE AS (AS LONG AS U R RUNNING IT WILL ADD ROWS)

		PRINT('>> Inserting Data Into Table:bronze.crm_cust_info');
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\mohos\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
		print('>> Load Duration For bronze.crm_cust_info:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR));


		set @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info; -- THIS STEP IN ORDER NOT TO UPLOAD THE DATATWICE AS (AS LONG AS U R RUNNING IT WILL ADD ROWS)
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\mohos\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
		print('>> Load Duration For bronze.crm_prd_info:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR));


		set @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details; -- THIS STEP IN ORDER NOT TO UPLOAD THE DATATWICE AS (AS LONG AS U R RUNNING IT WILL ADD ROWS)
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\mohos\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
		print('>> Load Duration For bronze.crm_sales_details:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR));


		PRINT('-------------------------------');
		PRINT('Loading ERP Tables');
		PRINT('-------------------------------');

		set @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101; -- THIS STEP IN ORDER NOT TO UPLOAD THE DATATWICE AS (AS LONG AS U R RUNNING IT WILL ADD ROWS)
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\mohos\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
		print('>> Load Duration For bronze.erp_loc_a101:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR));


		set @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12; -- THIS STEP IN ORDER NOT TO UPLOAD THE DATATWICE AS (AS LONG AS U R RUNNING IT WILL ADD ROWS)
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\mohos\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
		print('>> Load Duration For bronze.erp_cust_az12:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR));



		set @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2; -- THIS STEP IN ORDER NOT TO UPLOAD THE DATATWICE AS (AS LONG AS U R RUNNING IT WILL ADD ROWS)
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\mohos\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
	);
	set @end_time = GETDATE();
		print('>> Load Duration For bronze.erp_px_cat_g1v2:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR));


	set @batch_end_time = GETDATE();
	print('Batch Loading Duration :'+CAST(datediff(second,@batch_start_time,@batch_end_time) AS NVARCHAR));

	END TRY
	BEGIN CATCH
		PRINT('ERROR Occured During Loading Bronze Layer :'+CAST(ERROR_MESSAGE() AS NVARCHAR));
	END CATCH
END

EXEC bronze.load_bronze


