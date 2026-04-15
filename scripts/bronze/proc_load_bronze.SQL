
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


