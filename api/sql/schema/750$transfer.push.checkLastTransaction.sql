ALTER PROCEDURE [transfer].[push.checkLastTransaction]
    @channelId bigint,
    @sernum char(4),
    @status char(1),
    @notes1 int,
    @notes2 int,
    @notes3 int,
    @notes4 int,
    @confirm bit,
    @errorMap core.indexedMapTT READONLY
AS
SET NOCOUNT ON
DECLARE @callParams XML

BEGIN TRY

    DECLARE
        @lastTx int,
        @lastSernum varchar(4),
        @lastNotes1 int,
        @lastNotes2 int,
        @lastNotes3 int,
        @lastNotes4 int,
        @lastAcquirerState int,
        @lastIssuerState int,

        @details XML = @callParams,
        @responseCode varchar(3)

    SELECT TOP 1
        @lastTx = t.transferId,
        @lastSernum = e.udfDetails.value('(/root/sernum)[1]', 'varchar(4)'),
        @lastAcquirerState = t.acquirerTxState,
        @lastIssuerState = t.issuerTxState,
        @lastNotes1 = e.udfDetails.value('(/root/type1Notes)[1]', 'int'),
        @lastNotes2 = e.udfDetails.value('(/root/type2Notes)[1]', 'int'),
        @lastNotes3 = e.udfDetails.value('(/root/type3Notes)[1]', 'int'),
        @lastNotes4 = e.udfDetails.value('(/root/type4Notes)[1]', 'int')
    FROM
        [transfer].[transfer] t
    LEFT JOIN
        [transfer].[event] e ON e.transferId = t.transferId AND e.source = 'acquirer' AND e.type = 'transfer.requestAcquirer'
    WHERE
        t.channelId = @channelId
    ORDER BY
        t.transferId DESC

    IF @lastAcquirerState IS NULL AND @lastTx IS NOT NULL
    BEGIN
        SET @responseCode = ISNULL((SELECT [value] from @errorMap WHERE [key] = 'atm.lastTransactionTimeout'), '96')
        SET @details.modify('insert <responseCode>{sql:variable("@responseCode")}</responseCode> into (/params)[1]')

        EXEC [transfer].[push.abortAcquirer]
            @transferId = @lastTx,
            @type = 'atm.lastTransactionTimeout',
            @message = 'ATM timed out waiting for response',
            @details = @details
    END ELSE
    IF @lastAcquirerState=1 AND @lastIssuerState=2
    BEGIN
        IF @lastSernum IS NULL
        BEGIN
            SET @responseCode = ISNULL((SELECT [value] from @errorMap WHERE [key] = 'atm.lastTransactionMissingSernum'), '96')
            SET @details.modify('insert <responseCode>{sql:variable("@responseCode")}</responseCode> into (/params)[1]')

            EXEC [transfer].[push.errorAcquirer]
                @transferId = @lastTx,
                @type = 'atm.lastTransactionMissingSernum',
                @message = 'Missing last transaction serial number',
                @details = @details
        END ELSE
        IF @lastSernum != @sernum
        BEGIN
            IF @confirm = 1
            BEGIN
                SET @responseCode = ISNULL((SELECT [value] from @errorMap WHERE [key] = 'atm.lastTransactionUnexpectedSernum'), '96')
                SET @details.modify('insert <responseCode>{sql:variable("@responseCode")}</responseCode> into (/params)[1]')

                EXEC [transfer].[push.errorAcquirer]
                    @transferId = @lastTx,
                    @type = 'atm.lastTransactionUnexpectedSernum',
                    @message = 'Unexpected last transaction serial number',
                    @details = @details
            END ELSE
            BEGIN
                SET @responseCode = ISNULL((SELECT [value] from @errorMap WHERE [key] = 'atm.lastTransactionNoReply'), '96')
                SET @details.modify('insert <responseCode>{sql:variable("@responseCode")}</responseCode> into (/params)[1]')

                EXEC [transfer].[push.failAcquirer]
                    @transferId = @lastTx,
                    @type = 'atm.lastTransactionNoReply',
                    @message = 'ATM did not receive transaction reply',
                    @details = @details
            END
        END else
        IF @lastNotes1 != @notes1 OR @lastNotes2 != @notes2 OR @lastNotes3 != @notes3 OR @lastNotes4 != @notes4
        BEGIN
            IF @confirm = 1
            BEGIN
                SET @responseCode = ISNULL((SELECT [value] from @errorMap WHERE [key] = 'atm.lastTransactionUnexpectedDispense'), '96')
                SET @details.modify('insert <responseCode>{sql:variable("@responseCode")}</responseCode> into (/params)[1]')

                EXEC [transfer].[push.errorAcquirer]
                    @transferId = @lastTx,
                    @type = 'atm.lastTransactionUnexpectedDispense',
                    @message = 'Unexpected last dispense',
                    @details = @details
            END ELSE
            IF @notes1 = 0 AND @notes2 = 0 AND @notes3 = 0 AND @notes4 = 0
                BEGIN
                    SET @responseCode = ISNULL((SELECT [value] from @errorMap WHERE [key] = 'atm.lastTransactionZeroDispense'), '96')
                    SET @details.modify('insert <responseCode>{sql:variable("@responseCode")}</responseCode> into (/params)[1]')

                    EXEC [transfer].[push.failAcquirer]
                        @transferId = @lastTx,
                        @type = 'atm.lastTransactionZeroDispense',
                        @message = 'ATM did not dispense any money',
                        @details = @details
                END
            else
                SET @responseCode = ISNULL((SELECT [value] from @errorMap WHERE [key] = 'atm.lastTransactionDifferentDispense'), '96')
                SET @details.modify('insert <responseCode>{sql:variable("@responseCode")}</responseCode> into (/params)[1]')

                EXEC [transfer].[push.errorAcquirer]
                    @transferId = @lastTx,
                    @type = 'atm.lastTransactionDifferentDispense',
                    @message = 'ATM dispensed different amount',
                    @details = @details
        END else
        BEGIN
            SET @responseCode = '00'
            SET @details.modify('insert <responseCode>{sql:variable("@responseCode")}</responseCode> into (/params)[1]')

            EXEC [transfer].[push.confirmAcquirer]
                @transferId = @lastTx,
                @transferIdAcquirer = NULL,
                @type = NULL,
                @message = NULL,
                @details = @details
        END
    end

    EXEC core.auditCall @procid = @@PROCID, @params = @callParams
END TRY
BEGIN CATCH
    if @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    EXEC core.error
    RETURN 55555
END CATCH
