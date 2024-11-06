-- Create the database if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'StagingFinance')
BEGIN
    CREATE DATABASE StagingFinance;
END
GO

USE [StagingFinance];

SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER ON;

-- Drop constraints if they exist
IF EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_USR_REP_PaymentsData_InvoiceID]'))
BEGIN
    ALTER TABLE [dbo].[USR_REP_PaymentsData] DROP CONSTRAINT [DF_USR_REP_PaymentsData_InvoiceID];
END

IF EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_USR_REP_PaymentsData_DisputedDaysOnHold]'))
BEGIN
    ALTER TABLE [dbo].[USR_REP_PaymentsData] DROP CONSTRAINT [DF_USR_REP_PaymentsData_DisputedDaysOnHold];
END

IF EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_USR_REP_PaymentsData_DisputedWorkingDaysOnHold]'))
BEGIN
    ALTER TABLE [dbo].[USR_REP_PaymentsData] DROP CONSTRAINT [DF_USR_REP_PaymentsData_DisputedWorkingDaysOnHold];
END

IF EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_USR_REP_PaymentsData_ComplianceDaysOnHold]'))
BEGIN
    ALTER TABLE [dbo].[USR_REP_PaymentsData] DROP CONSTRAINT [DF_USR_REP_PaymentsData_ComplianceDaysOnHold];
END

IF EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_USR_REP_PaymentsData_ComplianceWorkingDaysOnHold]'))
BEGIN
    ALTER TABLE [dbo].[USR_REP_PaymentsData] DROP CONSTRAINT [DF_USR_REP_PaymentsData_ComplianceWorkingDaysOnHold];
END

-- Drop the table if it already exists
IF EXISTS (SELECT * FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[USR_REP_PaymentsData]'))
BEGIN
    DROP TABLE [dbo].[USR_REP_PaymentsData];
END
GO

CREATE TABLE [dbo].[USR_REP_PaymentsData](
    [SourceSystem] [varchar](10) NOT NULL,
    [ChequeID] [bigint] NOT NULL,
    [ChequeNumber] [bigint] NULL,
    [ChequeAmount] [money] NULL,
    [ChequeCurrency] [varchar](10) NULL,
    [ChequeAmountCurrency] [money] NULL,
    [ExchangeRate] [float] NULL,
    [ChequeDateDate] [date] NULL,
    [ChequeDate] [varchar](11) NULL,
    [StatusLookupCode] [nvarchar](25) NULL,
    [InvoiceID] [bigint] NOT NULL,
    [InvoiceNumber] [nvarchar](50) NULL,
    [InvoiceDateDate] [date] NULL,
    [InvoiceDate] [varchar](11) NULL,
    [InvoiceReceivedDateDate] [date] NULL,
    [InvoiceReceivedDate] [varchar](11) NULL,
    [InvoiceCancelledDateDate] [date] NULL,
    [InvoiceCancelledDate] [varchar](11) NULL,
    [InvoiceAmount] [money] NULL,
    [InvoiceCurrencyCode] [varchar](10) NULL,
    [InvoiceExchangeRate] [float] NULL,
    [AmountPaid] [money] NULL,
    [InvoiceDescription] [nvarchar](240) NULL,
    [PayGroupLookupCode] [nvarchar](25) NULL,
    [PayGroupName] [nvarchar](100) NULL,
    [PayGroupDescription] [nvarchar](1000) NULL,
    [SupplierID] [bigint] NULL,
    [SupplierName] [nvarchar](240) NULL,
    [SupplierSiteID] [float] NULL,
    [SupplierSiteCode] [nvarchar](15) NULL,
    [SupplierNumber] [nvarchar](30) NULL,
    [InvoicePaymentID] [bigint] NOT NULL,
    [InvoiceBaseAmount] [float] NULL,
    [PaymentBaseAmount] [float] NULL,
    [PaymentNumber] [bigint] NOT NULL,
    [PaymentMethodName] [nvarchar](100) NULL,
    [DiscountLost] [float] NULL,
    [DiscountTaken] [float] NULL,
    [AccountingPeriod] [nvarchar](15) NOT NULL,
    [PostedFlag] [nvarchar](1) NOT NULL,
    [AccrualPostedFlag] [nvarchar](1) NULL,
    [CashPostedFlag] [nvarchar](1) NULL,
    [ReversalInvoicePaymentID] [bigint] NULL,
    [ReversalFlag] [nvarchar](1) NULL,
    [SetOfBooksID] [bigint] NOT NULL,
    [SetOfBooksName] [nvarchar](30) NULL,
    [RemitToSupplierName] [nvarchar](240) NULL,
    [RemitToSupplierID] [bigint] NULL,
    [RemitToSupplierSite] [nvarchar](240) NULL,
    [RemitToSupplierSiteID] [bigint] NULL,
    [AccountingDateDate] [date] NULL,
    [AccountingDate] [varchar](11) NULL,
    [CreatedBy] [bigint] NULL,
    [CreationDateDate] [date] NULL,
    [CreationDate] [varchar](11) NULL,
    [LastUpdatedBy] [bigint] NOT NULL,
    [LastUpdatedLogin] [bigint] NULL,
    [LastUpdatedDateDate] [date] NULL,
    [LastUpdatedDate] [varchar](11) NULL,
    [DaysOnHold] [int] NOT NULL,
    [WorkingDaysOnHold] [int] NOT NULL,
    [DisputedDaysOnHold] [int] NOT NULL,
    [DisputedWorkingDaysOnHold] [int] NOT NULL,
    [ComplianceDaysOnHold] [int] NOT NULL,
    [ComplianceWorkingDaysOnHold] [int] NOT NULL,
    [DaysToPay] [int] NULL,
    [WorkingDaysToPay] [int] NULL,
    [AdjustedWorkingDaysToPay] [int] NULL
);

ALTER TABLE [dbo].[USR_REP_PaymentsData] ADD  CONSTRAINT [DF_USR_REP_PaymentsData_InvoiceID]  DEFAULT ((0)) FOR [InvoiceID];

ALTER TABLE [dbo].[USR_REP_PaymentsData] ADD  CONSTRAINT [DF_USR_REP_PaymentsData_DisputedDaysOnHold]  DEFAULT ((0)) FOR [DisputedDaysOnHold];

ALTER TABLE [dbo].[USR_REP_PaymentsData] ADD  CONSTRAINT [DF_USR_REP_PaymentsData_DisputedWorkingDaysOnHold]  DEFAULT ((0)) FOR [DisputedWorkingDaysOnHold];

ALTER TABLE [dbo].[USR_REP_PaymentsData] ADD  CONSTRAINT [DF_USR_REP_PaymentsData_ComplianceDaysOnHold]  DEFAULT ((0)) FOR [ComplianceDaysOnHold];

ALTER TABLE [dbo].[USR_REP_PaymentsData] ADD  CONSTRAINT [DF_USR_REP_PaymentsData_ComplianceWorkingDaysOnHold]  DEFAULT ((0)) FOR [ComplianceWorkingDaysOnHold];

