USE [StagingFinance];

-- Drop the stored procedure if it already exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USR_Refill_REP_Schema_PromptPay_ToOptimise]') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[USR_Refill_REP_Schema_PromptPay_ToOptimise];
END
GO

CREATE PROCEDURE [dbo].[USR_Refill_REP_Schema_PromptPay_ToOptimise]
AS
BEGIN
    -- Truncate the target table
    TRUNCATE TABLE StagingFinance.dbo.USR_REP_PromptPaymentsReport_All;

    -- Insert data into the target table
    INSERT INTO StagingFinance.dbo.USR_REP_PromptPaymentsReport_All
    (
        MySortOrder, ReportData, ReportDataType,
        PaymentYear, PaymentMonthNumber, PaymentPeriod, PaymentMonth, SetOfBooksName, 
        Payments, PaymentsLessThan3WDays, PaymentsLessThan3WDaysPC, PaymentsLessThan30CDays, PaymentsLessThan30CDaysPC, 
        PaymentsOver30CDays, PaymentsOver30CDaysPC, PaymentsOver3WDaysAverageWDaysToPay, 
        PaymentsValue, PaymentsLessThan3WDaysValue, PaymentsLessThan3WDaysValuePC, 
        PaymentsLessThan30CDaysValue, PaymentsLessThan30CDaysValuePC, PaymentsOver30CDaysValue, PaymentsOver30CDaysValuePC, 
        StandardPayments, StandardPaymentsLessThan3WDays, StandardPaymentsLessThan3WDaysPC, 
        StandardPaymentsLessThan30CDays, StandardPaymentsLessThan30CDaysPC, 
        StandardPaymentsOver30CDays, StandardPaymentsOver30CDaysPC, 
        StandardPaymentsOver3WDaysAverageWDaysToPay, 
        StandardPaymentsValue, StandardPaymentsLessThan3WDaysValue, 
        StandardPaymentsLessThan3WDaysValuePC, 
        StandardPaymentsLessThan30CDaysValue, StandardPaymentsLessThan30CDaysValuePC, 
        StandardPaymentsOver30CDaysValue, StandardPaymentsOver30CDaysValuePC, 
        GPCPayments, GPCPaymentsValue
    )
    SELECT 
        ROW_NUMBER() OVER (ORDER BY PaymentPeriod DESC, PaymentMonth, SetOfBooksName) AS MySortOrder,
        'ROE' AS ReportData,
        CASE 
            WHEN PaymentMonthNumber > 0 THEN 'Month'
            WHEN PaymentMonth LIKE '%Financial Year' THEN 'Financial Year'
            WHEN PaymentMonth LIKE '%Financial YTD' THEN 'Financial YTD'
            WHEN PaymentMonth LIKE '%Calendar Year%' THEN 'Calendar Year'
            WHEN PaymentMonth LIKE '%Calendar YTD%' THEN 'Calendar YTD'
            ELSE 'Unknown' 
        END AS ReportDataType,
        PaymentYear, PaymentMonthNumber, PaymentPeriod, PaymentMonth, SetOfBooksName, 
        Payments, PaymentsLessThan3WDays, PaymentsLessThan3WDaysPC, 
        PaymentsLessThan30CDays, PaymentsLessThan30CDaysPC, 
        PaymentsOver30CDays, PaymentsOver30CDaysPC, 
        PaymentsOver3WDaysAverageWDaysToPay, 
        PaymentsValue, PaymentsLessThan3WDaysValue, 
        PaymentsLessThan3WDaysValuePC, 
        PaymentsLessThan30CDaysValue, PaymentsLessThan30CDaysValuePC, 
        PaymentsOver30CDaysValue, PaymentsOver30CDaysValuePC, 
        StandardPayments, StandardPaymentsLessThan3WDays, 
        StandardPaymentsLessThan3WDaysPC, 
        StandardPaymentsLessThan30CDays, StandardPaymentsLessThan30CDaysPC, 
        StandardPaymentsOver30CDays, StandardPaymentsOver30CDaysPC, 
        StandardPaymentsOver3WDaysAverageWDaysToPay, 
        StandardPaymentsValue, StandardPaymentsLessThan3WDaysValue, 
        StandardPaymentsLessThan3WDaysValuePC, 
        StandardPaymentsLessThan30CDaysValue, StandardPaymentsLessThan30CDaysValuePC, 
        StandardPaymentsOver30CDaysValue, StandardPaymentsOver30CDaysValuePC, 
        GPCPayments, GPCPaymentsValue
    FROM
        StagingFinance.dbo.USR_VW_PromptPaymentsReport
--        StagingFinance.dbo.USR_REP_PaymentsData
END;

-- Execute the stored procedure
--EXEC [dbo].[USR_Refill_REP_Schema_PromptPay_ToOptimise];