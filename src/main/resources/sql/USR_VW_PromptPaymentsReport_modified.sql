USE [StagingFinance];

SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER ON;

-- Drop the view if it already exists
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[USR_VW_PromptPaymentsReport]'))
BEGIN
    DROP VIEW [dbo].[USR_VW_PromptPaymentsReport];
END
GO
--ALTER VIEW [dbo].[USR_VW_PromptPaymentsReport]
CREATE VIEW [dbo].[USR_VW_PromptPaymentsReport]
AS
--BEGIN
    --exec StagingFinance.dbo.USR_Refill_PaymentsHeld_Additional;  
    --exec StagingFinance.dbo.USR_Refill_APInvoices_Additional;  
    --exec USR_Refill_REP_PaymentsData

    SELECT 
        PaymentYear,
        PaymentMonthNumber,
        CONVERT(char(4), PaymentYear) + '-' + RIGHT('00' + CONVERT(varchar(2), PaymentMonthNumber), 2) AS PaymentPeriod,
        CONVERT(char(4), PaymentYear) + ' ' + PaymentMonth AS PaymentMonth,
        SetOfBooksName,

        Payments,
        PaymentsLessThan3Days AS PaymentsLessThan3WDays,
        CASE WHEN Payments = 0 THEN 0 ELSE CONVERT(decimal(8,1), PaymentsLessThan3Days / Payments * 100) END AS PaymentsLessThan3WDaysPC,
        PaymentsLessThan30Days AS PaymentsLessThan30CDays,
        CASE WHEN Payments = 0 THEN 0 ELSE CONVERT(decimal(8,1), 100 * PaymentsLessThan30Days / Payments) END AS PaymentsLessThan30CDaysPC,
        Payments - PaymentsLessThan30Days AS PaymentsOver30CDays,
        CASE WHEN Payments = 0 THEN 0 ELSE CONVERT(decimal(8,1), 100 * (Payments - PaymentsLessThan30Days) / Payments) END AS PaymentsOver30CDaysPC,
        CASE WHEN (Payments - PaymentsLessThan3Days) = 0 THEN 0 ELSE CONVERT(decimal(8,1), (PaymentsOver3DaysTotalDaysToPay / (Payments - PaymentsLessThan3Days))) END AS PaymentsOver3WDaysAverageWDaysToPay,

        PaymentsValue,
        PaymentsLessThan3DaysValue AS PaymentsLessThan3WDaysValue,
        CASE WHEN PaymentsValue = 0 THEN 0 ELSE CONVERT(decimal(8,1), PaymentsLessThan3DaysValue / PaymentsValue * 100) END AS PaymentsLessThan3WDaysValuePC,
        PaymentsLessThan30DaysValue AS PaymentsLessThan30CDaysValue,
        CASE WHEN PaymentsValue = 0 THEN 0 ELSE CONVERT(decimal(8,1), 100 * PaymentsLessThan30DaysValue / PaymentsValue) END AS PaymentsLessThan30CDaysValuePC,
        PaymentsValue - PaymentsLessThan30DaysValue AS PaymentsOver30CDaysValue,
        CASE WHEN PaymentsValue = 0 THEN 0 ELSE CONVERT(decimal(8,1), 100 * (PaymentsValue - PaymentsLessThan30DaysValue) / PaymentsValue) END AS PaymentsOver30CDaysValuePC,

        StandardPayments,
        StandardPaymentsLessThan3Days AS StandardPaymentsLessThan3WDays,
        CASE WHEN StandardPayments = 0 THEN 0 ELSE CONVERT(decimal(8,1), StandardPaymentsLessThan3Days / StandardPayments * 100) END AS StandardPaymentsLessThan3WDaysPC,
        StandardPaymentsLessThan30Days AS StandardPaymentsLessThan30CDays,
        CASE WHEN StandardPayments = 0 THEN 0 ELSE CONVERT(decimal(8,1), 100 * StandardPaymentsLessThan30Days / StandardPayments) END AS StandardPaymentsLessThan30CDaysPC,
        StandardPayments - StandardPaymentsLessThan30Days AS StandardPaymentsOver30CDays,
        CASE WHEN StandardPayments = 0 THEN 0 ELSE CONVERT(decimal(8,1), 100 * (StandardPayments - StandardPaymentsLessThan30Days) / StandardPayments) END AS StandardPaymentsOver30CDaysPC,
        CASE WHEN (StandardPayments - StandardPaymentsLessThan3Days) = 0 THEN 0 ELSE CONVERT(decimal(8,1), (StandardPaymentsOver3DaysTotalDaysToPay / (StandardPayments - StandardPaymentsLessThan3Days))) END AS StandardPaymentsOver3WDaysAverageWDaysToPay,

        StandardPaymentsValue,
        StandardPaymentsLessThan3DaysValue AS StandardPaymentsLessThan3WDaysValue,
        CASE WHEN StandardPaymentsValue = 0 THEN 0 ELSE CONVERT(decimal(8,1), StandardPaymentsLessThan3DaysValue / StandardPaymentsValue * 100) END AS StandardPaymentsLessThan3WDaysValuePC,
        StandardPaymentsLessThan30DaysValue AS StandardPaymentsLessThan30CDaysValue,
        CASE WHEN StandardPaymentsValue = 0 THEN 0 ELSE CONVERT(decimal(8,1), 100 * StandardPaymentsLessThan30DaysValue / StandardPaymentsValue) END AS StandardPaymentsLessThan30CDaysValuePC,
        StandardPaymentsValue - StandardPaymentsLessThan30DaysValue AS StandardPaymentsOver30CDaysValue,
        CASE WHEN StandardPaymentsValue = 0 THEN 0 ELSE CONVERT(decimal(8,1), 100 * (StandardPaymentsValue - StandardPaymentsLessThan30DaysValue) / StandardPaymentsValue) END AS StandardPaymentsOver30CDaysValuePC,

        GPCPayments,
        GPCPaymentsValue

    FROM
    (
        SELECT -- Individual Councils, Individual months since January 2019
            DATEPART(year, ChequeDateDate) AS PaymentYear,
            DATEPART(month, ChequeDateDate) AS PaymentMonthNumber,
            DATENAME(month, ChequeDateDate) AS PaymentMonth,
            SetOfBooksName,

            COUNT(*) AS Payments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN 1 ELSE 0 END)) AS PaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 THEN 1 ELSE 0 END)) AS PaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS PaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(AmountPaid)) AS PaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPayments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 AND StatusLookupCode <> 'GPC' THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS StandardPaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode = 'GPC' THEN 1 ELSE 0 END)) AS GPCPayments,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode = 'GPC' THEN AmountPaid ELSE 0 END)) AS GPCPaymentsValue
        FROM 
            StagingFinance.dbo.USR_REP_PaymentsData
        WHERE
            SourceSystem = 'UKRI'
            AND ChequeDateDate >= '01 Jan 2019'
        GROUP BY
            SetOfBooksName,
            DATEPART(year, ChequeDateDate),
            DATEPART(month, ChequeDateDate),
            DATENAME(month, ChequeDateDate)

        UNION

        SELECT -- UKRI (UKSBS excluded), Individual months since January 2019
            DATEPART(year, ChequeDateDate) AS PaymentYear,
            DATEPART(month, ChequeDateDate) AS PaymentMonthNumber,
            DATENAME(month, ChequeDateDate) AS PaymentMonth,
            'UKRI',

            COUNT(*) AS Payments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN 1 ELSE 0 END)) AS PaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 THEN 1 ELSE 0 END)) AS PaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS PaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(AmountPaid)) AS PaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan30DaysTotalValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPayments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 AND StatusLookupCode <> 'GPC' THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS StandardPaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode = 'GPC' THEN 1 ELSE 0 END)) AS GPCPayments,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode = 'GPC' THEN AmountPaid ELSE 0 END)) AS GPCPaymentsValue

        FROM 
            StagingFinance.dbo.USR_REP_PaymentsData
        WHERE
            SourceSystem = 'UKRI'
            AND SetOfBooksName NOT IN ('UKSBS')
            AND ChequeDateDate >= '01 Jan 2019'
        GROUP BY
            DATEPART(year, ChequeDateDate),
            DATEPART(month, ChequeDateDate),
            DATENAME(month, ChequeDateDate)

        UNION

        SELECT -- ROE, Individual months since January 2019
            DATEPART(year, ChequeDateDate) AS PaymentYear,
            DATEPART(month, ChequeDateDate) AS PaymentMonthNumber,
            DATENAME(month, ChequeDateDate) AS PaymentMonth,
            'ROE',

            COUNT(*) AS Payments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN 1 ELSE 0 END)) AS PaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 THEN 1 ELSE 0 END)) AS PaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS PaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(AmountPaid)) AS PaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan30DaysTotalValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPayments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 AND StatusLookupCode <> 'GPC' THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS StandardPaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode = 'GPC' THEN 1 ELSE 0 END)) AS GPCPayments,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode = 'GPC' THEN AmountPaid ELSE 0 END)) AS GPCPaymentsValue

        FROM 
            StagingFinance.dbo.USR_REP_PaymentsData
        WHERE
            SourceSystem = 'UKRI'
            AND ChequeDateDate >= '01 Jan 2019'
        GROUP BY
            DATEPART(year, ChequeDateDate),
            DATEPART(month, ChequeDateDate),
            DATENAME(month, ChequeDateDate)

        UNION

        SELECT -- Individual Councils, Calendar YTD
            DATEPART(year, ChequeDateDate) AS PaymentYear,
            0 AS PaymentMonthNumber,
            'Calendar YTD' AS PaymentMonth,
            SetOfBooksName,

            COUNT(*) AS Payments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN 1 ELSE 0 END)) AS PaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 THEN 1 ELSE 0 END)) AS PaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS PaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(AmountPaid)) AS PaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPayments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 AND StatusLookupCode <> 'GPC' THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS StandardPaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode = 'GPC' THEN 1 ELSE 0 END)) AS GPCPayments,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode = 'GPC' THEN AmountPaid ELSE 0 END)) AS GPCPaymentsValue

        FROM 
            StagingFinance.dbo.USR_REP_PaymentsData
        WHERE
            SourceSystem = 'UKRI'
            AND (YEAR(ChequeDateDate) = DATEPART(year, GETDATE()) OR (YEAR(ChequeDateDate) + 1 = DATEPART(year, GETDATE()) AND ChequeDateDate <= DATEADD(year, -1, GETDATE())))
        GROUP BY
            SetOfBooksName,
            DATEPART(year, ChequeDateDate)

        UNION

        SELECT -- UKRI (UKSBS excluded), Calendar YTD
            DATEPART(year, ChequeDateDate) AS PaymentYear,
            0 AS PaymentMonthNumber,
            'Calendar YTD' AS PaymentMonth,
            'UKRI' AS SetOfBooksName,

            COUNT(*) AS Payments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN 1 ELSE 0 END)) AS PaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 THEN 1 ELSE 0 END)) AS PaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS PaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(AmountPaid)) AS PaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPayments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 AND StatusLookupCode <> 'GPC' THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS StandardPaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode = 'GPC' THEN 1 ELSE 0 END)) AS GPCPayments,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode = 'GPC' THEN AmountPaid ELSE 0 END)) AS GPCPaymentsValue

        FROM 
            StagingFinance.dbo.USR_REP_PaymentsData
        WHERE
            SourceSystem = 'UKRI'
            AND SetOfBooksName NOT IN ('UKSBS')
            AND (YEAR(ChequeDateDate) = DATEPART(year, GETDATE()) OR (YEAR(ChequeDateDate) + 1 = DATEPART(year, GETDATE()) AND ChequeDateDate <= DATEADD(year, -1, GETDATE())))
        GROUP BY
            DATEPART(year, ChequeDateDate)

        UNION

        SELECT -- ROE, Calendar YTD
            DATEPART(year, ChequeDateDate) AS PaymentYear,
            0 AS PaymentMonthNumber,
            'Calendar YTD' AS PaymentMonth,
            'ROE' AS SetOfBooksName,

            COUNT(*) AS Payments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN 1 ELSE 0 END)) AS PaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 THEN 1 ELSE 0 END)) AS PaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS PaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(AmountPaid)) AS PaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPayments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 AND StatusLookupCode <> 'GPC' THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS StandardPaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode = 'GPC' THEN 1 ELSE 0 END)) AS GPCPayments,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode = 'GPC' THEN AmountPaid ELSE 0 END)) AS GPCPaymentsValue

        FROM 
            StagingFinance.dbo.USR_REP_PaymentsData
        WHERE
            SourceSystem = 'UKRI'
            AND (YEAR(ChequeDateDate) = DATEPART(year, GETDATE()) OR (YEAR(ChequeDateDate) + 1 = DATEPART(year, GETDATE()) AND ChequeDateDate <= DATEADD(year, -1, GETDATE())))
        GROUP BY
            DATEPART(year, ChequeDateDate)

        UNION

        SELECT -- Individual Councils, Financial YTD
            YEAR(DATEADD(month, -3, ChequeDateDate)) AS PaymentFinancialYear,
            0 AS PaymentMonthNumber,
            'Financial YTD' AS PaymentMonth,
            SetOfBooksName,

            COUNT(*) AS Payments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN 1 ELSE 0 END)) AS PaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 THEN 1 ELSE 0 END)) AS PaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS PaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(AmountPaid)) AS PaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPayments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 AND StatusLookupCode <> 'GPC' THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS StandardPaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode = 'GPC' THEN 1 ELSE 0 END)) AS GPCPayments,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode = 'GPC' THEN AmountPaid ELSE 0 END)) AS GPCPaymentsValue

        FROM 
            StagingFinance.dbo.USR_REP_PaymentsData
        WHERE
            SourceSystem = 'UKRI'
            AND (
                YEAR(DATEADD(month, -3, ChequeDateDate)) = YEAR(DATEADD(month, -3, GETDATE()))
                OR (
                    YEAR(DATEADD(month, -3, ChequeDateDate)) = YEAR(DATEADD(month, -3, GETDATE())) - 1 
                    AND ChequeDateDate < DATEADD(year, -1, GETDATE())
                )
            )
        GROUP BY
            YEAR(DATEADD(month, -3, ChequeDateDate)),
            SetOfBooksName

        UNION

        SELECT -- UKRI (UKSBS excluded), Financial YTD
            YEAR(DATEADD(month, -3, ChequeDateDate)) AS PaymentFinancialYear,
            0 AS PaymentMonthNumber,
            'Financial YTD' AS PaymentMonth,
            'UKRI' AS SetOfBooksName,

            COUNT(*) AS Payments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN 1 ELSE 0 END)) AS PaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 THEN 1 ELSE 0 END)) AS PaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS PaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(AmountPaid)) AS PaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 THEN AmountPaid ELSE 0 END)) AS PaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPayments,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan3Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN 1 ELSE 0 END)) AS StandardPaymentsLessThan30Days,
            CONVERT(decimal(8,1), SUM(CASE WHEN AdjustedWorkingDaysToPay > 3 AND StatusLookupCode <> 'GPC' THEN AdjustedWorkingDaysToPay ELSE 0 END)) AS StandardPaymentsOver3DaysTotalDaysToPay,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsValue,
            CONVERT(money, SUM(CASE WHEN AdjustedWorkingDaysToPay <= 3 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan3DaysValue,
            CONVERT(money, SUM(CASE WHEN DaysToPay <= 30 AND StatusLookupCode <> 'GPC' THEN AmountPaid ELSE 0 END)) AS StandardPaymentsLessThan30DaysValue,

            CONVERT(decimal(8,1), SUM(CASE WHEN StatusLookupCode = 'GPC' THEN 1 ELSE 0 END)) AS GPCPayments,
            CONVERT(money, SUM(CASE WHEN StatusLookupCode = 'GPC' THEN AmountPaid ELSE 0 END)) AS GPCPaymentsValue

        FROM 
            StagingFinance.dbo.USR_REP_PaymentsData
        WHERE
            SourceSystem = 'UKRI'
            AND SetOfBooksName NOT IN ('UKSBS')
            AND (
                YEAR(DATEADD(month, -3, ChequeDateDate)) = YEAR(DATEADD(month, -3, GETDATE()))
                OR (
                    YEAR(DATEADD(month, -3, ChequeDateDate)) = YEAR(DATEADD(month, -3, GETDATE())) - 1 
                    AND ChequeDateDate < DATEADD(year, -1, GETDATE())
                )
            )
        GROUP BY
            YEAR(DATEADD(month, -3, ChequeDateDate))
    ) AS MySub;
--END;

