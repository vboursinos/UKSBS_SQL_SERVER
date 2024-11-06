-- Create the database if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'StagingFinance')
BEGIN
    CREATE DATABASE StagingFinance;
END
GO

USE [StagingFinance];

SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER ON;

-- Drop the table if it already exists
IF EXISTS (SELECT * FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[USR_REP_PromptPaymentsReport_All]'))
BEGIN
    DROP TABLE [dbo].[USR_REP_PromptPaymentsReport_All];
END
GO

CREATE TABLE [dbo].[USR_REP_PromptPaymentsReport_All](
    [MySortOrder] [int] NULL,
    [ReportData] [char](3) NULL,
    [ReportDataType] [varchar](50) NULL,
    [PaymentYear] [int] NULL,
    [PaymentMonthNumber] [int] NULL,
    [PaymentPeriod] [varchar](7) NULL,
    [PaymentMonth] [nvarchar](35) NULL,
    [SetOfBooksName] [nvarchar](30) NULL,
    [Payments] [bigint] NULL,
    [PaymentsLessThan3WDays] [bigint] NULL,
    [PaymentsLessThan3WDaysPC] [decimal](4, 1) NULL,
    [PaymentsLessThan30CDays] [bigint] NULL,
    [PaymentsLessThan30CDaysPC] [decimal](4, 1) NULL,
    [PaymentsOver30CDays] [bigint] NULL,
    [PaymentsOver30CDaysPC] [decimal](4, 1) NULL,
    [PaymentsOver3WDaysAverageWDaysToPay] [decimal](8, 1) NULL,
    [PaymentsValue] [money] NULL,
    [PaymentsLessThan3WDaysValue] [money] NULL,
    [PaymentsLessThan3WDaysValuePC] [decimal](4, 1) NULL,
    [PaymentsLessThan30CDaysValue] [money] NULL,
    [PaymentsLessThan30CDaysValuePC] [decimal](4, 1) NULL,
    [PaymentsOver30CDaysValue] [money] NULL,
    [PaymentsOver30CDaysValuePC] [decimal](4, 1) NULL,
    [StandardPayments] [bigint] NULL,
    [StandardPaymentsLessThan3WDays] [bigint] NULL,
    [StandardPaymentsLessThan3WDaysPC] [decimal](4, 1) NULL,
    [StandardPaymentsLessThan30CDays] [bigint] NULL,
    [StandardPaymentsLessThan30CDaysPC] [decimal](4, 1) NULL,
    [StandardPaymentsOver30CDays] [bigint] NULL,
    [StandardPaymentsOver30CDaysPC] [decimal](4, 1) NULL,
    [StandardPaymentsOver3WDaysAverageWDaysToPay] [decimal](8, 1) NULL,
    [StandardPaymentsValue] [money] NULL,
    [StandardPaymentsLessThan3WDaysValue] [money] NULL,
    [StandardPaymentsLessThan3WDaysValuePC] [decimal](4, 1) NULL,
    [StandardPaymentsLessThan30CDaysValue] [money] NULL,
    [StandardPaymentsLessThan30CDaysValuePC] [decimal](4, 1) NULL,
    [StandardPaymentsOver30CDaysValue] [money] NULL,
    [StandardPaymentsOver30CDaysValuePC] [decimal](4, 1) NULL,
    [GPCPayments] [bigint] NULL,
    [GPCPaymentsValue] [money] NULL
) ON [PRIMARY];

