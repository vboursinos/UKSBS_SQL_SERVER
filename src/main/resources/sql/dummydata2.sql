USE [StagingFinance];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

-- Declare a counter for the loop
DECLARE @Counter INT = 1

-- Declare a seed for the random number generator
DECLARE @Seed INT = ABS(CHECKSUM(NEWID())) % 1000

-- Loop to insert 1000 rows
WHILE @Counter <= 2000
BEGIN
    -- Set the random seed for this iteration
    SET @Seed = @Seed + @Counter;

    INSERT INTO [dbo].[USR_REP_PaymentsData] (
        SourceSystem, ChequeID, ChequeNumber, ChequeAmount, ChequeCurrency, ChequeAmountCurrency,
        ExchangeRate, ChequeDateDate, ChequeDate, StatusLookupCode, InvoiceID, InvoiceNumber,
        InvoiceDateDate, InvoiceDate, InvoiceReceivedDateDate, InvoiceReceivedDate, InvoiceCancelledDateDate,
        InvoiceCancelledDate, InvoiceAmount, InvoiceCurrencyCode, InvoiceExchangeRate, AmountPaid,
        InvoiceDescription, PayGroupLookupCode, PayGroupName, PayGroupDescription, SupplierID,
        SupplierName, SupplierSiteID, SupplierSiteCode, SupplierNumber, InvoicePaymentID,
        InvoiceBaseAmount, PaymentBaseAmount, PaymentNumber, PaymentMethodName, DiscountLost,
        DiscountTaken, AccountingPeriod, PostedFlag, AccrualPostedFlag, CashPostedFlag,
        ReversalInvoicePaymentID, ReversalFlag, SetOfBooksID, SetOfBooksName, RemitToSupplierName,
        RemitToSupplierID, RemitToSupplierSite, RemitToSupplierSiteID, AccountingDateDate, AccountingDate,
        CreatedBy, CreationDateDate, CreationDate, LastUpdatedBy, LastUpdatedLogin,
        LastUpdatedDateDate, LastUpdatedDate, DaysOnHold, WorkingDaysOnHold, DisputedDaysOnHold,
        DisputedWorkingDaysOnHold, ComplianceDaysOnHold, ComplianceWorkingDaysOnHold, DaysToPay,
        WorkingDaysToPay, AdjustedWorkingDaysToPay
    )
    VALUES (
        'UKRI', -- SourceSystem
        @Counter, -- ChequeID
        @Counter * 10, -- ChequeNumber
        RAND(@Seed) * 1000, -- ChequeAmount
        'USD', -- ChequeCurrency
        RAND(@Seed) * 1000, -- ChequeAmountCurrency
        RAND(@Seed), -- ExchangeRate
        DATEADD(DAY, -@Counter, GETDATE()), -- ChequeDateDate
        CONVERT(VARCHAR(11), DATEADD(DAY, -@Counter, GETDATE()), 106), -- ChequeDate
        'Active', -- StatusLookupCode
        @Counter, -- InvoiceID
        'INV' + CAST(@Counter AS VARCHAR(10)), -- InvoiceNumber
        DATEADD(DAY, -@Counter, GETDATE()), -- InvoiceDateDate
        CONVERT(VARCHAR(11), DATEADD(DAY, -@Counter, GETDATE()), 106), -- InvoiceDate
        DATEADD(DAY, -@Counter, GETDATE()), -- InvoiceReceivedDateDate
        CONVERT(VARCHAR(11), DATEADD(DAY, -@Counter, GETDATE()), 106), -- InvoiceReceivedDate
        NULL, -- InvoiceCancelledDateDate
        NULL, -- InvoiceCancelledDate
        RAND(@Seed) * 1000, -- InvoiceAmount
        'USD', -- InvoiceCurrencyCode
        RAND(@Seed), -- InvoiceExchangeRate
        RAND(@Seed) * 1000, -- AmountPaid
        'Description', -- InvoiceDescription
        'GroupCode', -- PayGroupLookupCode
        'GroupName', -- PayGroupName
        'GroupDescription', -- PayGroupDescription
        @Counter, -- SupplierID
        'SupplierName', -- SupplierName
        RAND(@Seed) * 100, -- SupplierSiteID
        'SiteCode', -- SupplierSiteCode
        'SupplierNumber', -- SupplierNumber
        @Counter, -- InvoicePaymentID
        RAND(@Seed) * 1000, -- InvoiceBaseAmount
        RAND(@Seed) * 1000, -- PaymentBaseAmount
        @Counter, -- PaymentNumber
        'MethodName', -- PaymentMethodName
        RAND(@Seed) * 10, -- DiscountLost
        RAND(@Seed) * 10, -- DiscountTaken
        '2023-01', -- AccountingPeriod
        'Y', -- PostedFlag
        'N', -- AccrualPostedFlag
        'N', -- CashPostedFlag
        NULL, -- ReversalInvoicePaymentID
        'N', -- ReversalFlag
        @Counter, -- SetOfBooksID
        'BooksName', -- SetOfBooksName
        'RemitName', -- RemitToSupplierName
        @Counter, -- RemitToSupplierID
        'RemitSite', -- RemitToSupplierSite
        @Counter, -- RemitToSupplierSiteID
        DATEADD(DAY, -@Counter, GETDATE()), -- AccountingDateDate
        CONVERT(VARCHAR(11), DATEADD(DAY, -@Counter, GETDATE()), 106), -- AccountingDate
        @Counter, -- CreatedBy
        DATEADD(DAY, -@Counter, GETDATE()), -- CreationDateDate
        CONVERT(VARCHAR(11), DATEADD(DAY, -@Counter, GETDATE()), 106), -- CreationDate
        @Counter, -- LastUpdatedBy
        @Counter, -- LastUpdatedLogin
        DATEADD(DAY, -@Counter, GETDATE()), -- LastUpdatedDateDate
        CONVERT(VARCHAR(11), DATEADD(DAY, -@Counter, GETDATE()), 106), -- LastUpdatedDate
        0, -- DaysOnHold
        0, -- WorkingDaysOnHold
        0, -- DisputedDaysOnHold
        0, -- DisputedWorkingDaysOnHold
        0, -- ComplianceDaysOnHold
        0, -- ComplianceWorkingDaysOnHold
        RAND(@Seed) * 30, -- DaysToPay
        RAND(@Seed) * 30, -- WorkingDaysToPay
        RAND(@Seed) * 30 -- AdjustedWorkingDaysToPay
    );

    -- Increment the counter
    SET @Counter = @Counter + 1;
END;
