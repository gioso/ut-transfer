CREATE TABLE [transfer].[transfer](
    transferId bigint IDENTITY(1000,1) NOT NULL,
    transferTypeId bigint NOT NULL,
    acquirerCode varchar(50),
    transferIdAcquirer varchar(50),
    transferIdLedger varchar(50),
    transferIdIssuer varchar(50),
    transferIdMerchant varchar(50),
    transferDateTime datetime2(0) NOT NULL,
    localDateTime varchar(14),
    settlementDate date,
    channelId bigint NOT NULL,
    channelType varchar(50) NOT NULL,
    ordererId bigint,
    merchantId varchar(50),
    merchantInvoice varchar(50),
    merchantPort varchar(50),
    merchantType varchar(50),
    cardId bigint,
    cardBin int NULL,
    sourceAccount varchar(50),
    destinationAccount varchar(50),
    expireTime datetime,
    expireCount int,
    reversed bit NOT NULL,
    retryTime datetime,
    retryCount int,
    ledgerTxState smallint,
    issuerTxState smallint,
    acquirerTxState smallint,
    merchantTxState smallint,
    issuerId varchar(50),
    issuerChannelId char(4) NULL,
    ledgerId varchar(50),
    transferCurrency varchar(3) NOT NULL,
    transferAmount money NOT NULL,
    acquirerFee money,
    issuerFee money,
    transferFee money,
    issuerResponseCode varchar(10), 
    issuerResponseMessage varchar(250),
    networkData varchar(20) NULL,
    originalRequest NVARCHAR(MAX) NULL,
    originalResponse NVARCHAR(MAX) NULL,
    stan char(6) NULL,
    transactionCategoryCode char(1) NULL,
    processingCode char(6) NULL,
    posEntryMode char(3) NULL,
    posData varchar(25) NULL,
    originalTransferId bigint NULL,
    isPreauthorization bit NULL,
    cleared bit NULL,
    clearingStatusId char(6) NULL,
    captureModeId char(4) NULL,
    description varchar(250), 
    createdOn DATETIMEOFFSET (7), 
    updatedBy BIGINT,
    updatedOn DATETIMEOFFSET (7),
    CONSTRAINT [pkTransferTransfer] PRIMARY KEY CLUSTERED ([transferId] ASC),
    CONSTRAINT [fkTransferTransfer_TransferType] FOREIGN KEY([transferTypeId]) REFERENCES [core].[itemName] ([itemNameId])
)