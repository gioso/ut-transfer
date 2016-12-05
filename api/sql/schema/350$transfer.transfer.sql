CREATE TABLE [transfer].[transfer](
    transferId bigint IDENTITY(1000,1) NOT NULL,
    transferTypeId bigint NOT NULL,
    transferIdAcquirer varchar(50),
    transferIdIssuer varchar(50),
    transferIdMerchant varchar(50),
    transferDateTime datetime NOT NULL,
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
    sourceAccount varchar(50),
    destinationAccount varchar(50),
    expireTime datetime,
    expireCount int,
    reversed bit NOT NULL,
    retryTime datetime,
    retryCount int,
    issuerTxState smallint,
    acquirerTxState smallint,
    merchantTxState smallint,
    destinationPort varchar(50),
    transferCurrency varchar(3) NOT NULL,
    transferAmount money NOT NULL,
    acquirerFee money,
    issuerFee money,
    transferFee money,
    issuerErrorType varchar(50),
    issuerErrorMessage varchar(250),
    reversalErrorType varchar(50),
    reversalErrorMessage varchar(250),
    acquirerErrorType varchar(50),
    acquirerErrorMessage varchar(250),
    merchantErrorType varchar(50),
    merchantErrorMessage varchar(250),
    description varchar(250),
    udfAcquirer XML,
    udfIssuer XML,
    udfTransfer XML,
    CONSTRAINT [pkTransferTransfer] PRIMARY KEY CLUSTERED ([transferId] ASC),
    CONSTRAINT [fkTransferTransfer_TransferType] FOREIGN KEY([transferTypeId]) REFERENCES [core].[itemName] ([itemNameId])
)