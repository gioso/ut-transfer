CREATE PROCEDURE [transfer].[partner.list] -- this sp gets the transfer partners for dropdowns
    @meta core.metaDataTT READONLY -- information for the user that makes the operation
AS
DECLARE @userId BIGINT = (SELECT [auth.actorId] FROM @meta)

-- checks if the user has a right to make the operation
DECLARE @actionID VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID), @RETURN INT = 0
EXEC @RETURN = [user].[permission.check] @actionId = @actionID, @objectId = NULL, @meta = @meta
IF @RETURN != 0
BEGIN
    RETURN 55555
END

SELECT 'partner' AS resultSetName

SELECT partnerId, name AS partnerName
FROM transfer.partner
