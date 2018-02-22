CREATE TABLE [transfer].[transfer](
    transferId BIGINT IDENTITY(1000,1) NOT NULL,
    transferTypeId BIGINT NOT NULL,
    acquirerCode VARCHAR(50),
    transferIdAcquirer VARCHAR(50),
    transferIdLedger VARCHAR(50),
    transferIdIssuer VARCHAR(50),
    transferIdMerchant VARCHAR(50),
    transferDateTime DATETIME NOT NULL,
    localDateTime VARCHAR(14),
    settlementDate DATE,
    channelId BIGINT NOT NULL,
    channelType VARCHAR(50) NOT NULL,
    ordererId BIGINT,
    merchantId VARCHAR(50),
    merchantInvoice VARCHAR(50),
    merchantPort VARCHAR(50),
    merchantType VARCHAR(50),
    cardId BIGINT,
    credentialId VARCHAR(50),
    sourceAccount VARCHAR(50),
    destinationAccount VARCHAR(50),
    expireTime DATETIME,
    expireCount INT,
    expireCountLedger INT,
    reversed BIT NOT NULL,
    reversedLedger BIT NOT NULL,
    retryTime DATETIME,
    retryCount INT,
    ledgerTxState SMALLINT,
    issuerTxState SMALLINT,
    acquirerTxState SMALLINT,
    merchantTxState SMALLINT,
    issuerId VARCHAR(50),
    ledgerId VARCHAR(50),
    transferCurrency VARCHAR(3) NOT NULL,
    transferAmount MONEY NOT NULL,
    acquirerFee MONEY,
    issuerFee MONEY,
    transferFee MONEY,
    retrievalReferenceNumber VARCHAR(12),
    description VARCHAR(250),
    issuerSerialNumber BIGINT,
    replacementAmount MONEY,
    replacementAmountCurrency VARCHAR(3),
    actualAmount MONEY,
    actualAmountCurrency VARCHAR(3),
    settlementAmount MONEY,
    settlementAmountCurrency VARCHAR(3),
    processorFee MONEY,
    CONSTRAINT [pkTransferTransfer] PRIMARY KEY CLUSTERED ([transferId] ASC),
    CONSTRAINT [fkTransferTransfer_TransferType] FOREIGN KEY([transferTypeId]) REFERENCES [core].[itemName] ([itemNameId])
)
