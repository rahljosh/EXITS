<cfsetting requesttimeout="600">

<!--- Get all host fathers that do not have a currently valid CBC but do have an authorization from April 1st to June 26th 2013 --->
<cfquery name="qGetFathers" datasource="#APPLICATION.DSN#">
	SELECT h.*
    FROM smg_hosts h
    WHERE h.hostID NOT IN (
    	SELECT hostID 
        FROM smg_hosts_cbc 
        WHERE hostID = h.hostID 
        AND cbc_type = "father" 
        AND date_expired > NOW())
    AND h.hostID IN (
        SELECT foreignID 
        FROM document 
        WHERE foreignTable="smg_hosts" 
        AND documentTypeID="hostFatherCBCAuthorization" 
        AND dateCreated BETWEEN "2013-04-01 00:00:00" AND "2013-06-27 00:00:00")
    AND h.fatherfirstname != ""
    AND h.fatherlastname != ""
    AND h.fatherSSN != ""
    AND h.fatherDOB != ""
</cfquery>

<!--- Add CBC records for those fathers --->
<cfloop query="qGetFathers">
	<cfscript>
		APPLICATION.CFC.CBC.insertHostCBC(
			hostID=qGetFathers.hostID,
			cbcType="father",
			seasonID=10, // Hard coded to AYP 13/14
			companyID=qGetFathers.companyID,
			dateAuthorized=NOW());
	</cfscript>
</cfloop>

<!--- Get all host mothers that do not have a currently valid CBC but do have an authorization from April 1st to June 26th 2013 --->
<cfquery name="qGetMothers" datasource="#APPLICATION.DSN#">
	SELECT h.*
    FROM smg_hosts h
    WHERE h.hostID NOT IN (
    	SELECT hostID 
        FROM smg_hosts_cbc 
        WHERE hostID = h.hostID 
        AND cbc_type = "mother" 
        AND date_expired > NOW())
    AND h.hostID IN (
        SELECT foreignID 
        FROM document 
        WHERE foreignTable="smg_hosts" 
        AND documentTypeID="hostMotherCBCAuthorization" 
        AND dateCreated BETWEEN "2013-04-01 00:00:00" AND "2013-06-27 00:00:00")
    AND h.motherFirstName != ""
    AND h.motherLastName != ""
    AND h.motherSSN != ""
    AND h.motherDOB != ""
</cfquery>

<!--- Add CBC records for those mothers --->
<cfloop query="qGetMothers">
	<cfscript>
		APPLICATION.CFC.CBC.insertHostCBC(
			hostID=qGetMothers.hostID,
			cbcType="mother",
			seasonID=10, // Hard coded to AYP 13/14
			companyID=qGetMothers.companyID,
			dateAuthorized=NOW());
	</cfscript>
</cfloop>

<!--- Get all host members that do not have a currently valid CBC but do have an authorization from April 1st to June 26th 2013 --->
<cfquery name="qGetMembers" datasource="#APPLICATION.DSN#">
	SELECT c.*, h.companyID
    FROM smg_host_children c
    INNER JOIN smg_hosts h ON h.hostID = c.hostID
    WHERE c.childID NOT IN (
          SELECT familyID 
          FROM smg_hosts_cbc 
          WHERE familyID = c.childID 
          AND cbc_type = "member" 
          AND date_expired > NOW())
    AND c.childID IN (
        SELECT foreignID 
        FROM document 
        WHERE foreignTable="smg_host_children" 
        AND documentTypeID="hostMemberCBCAuthorization" 
        AND dateCreated BETWEEN "2013-04-01 00:00:00" AND "2013-06-27 00:00:00")
</cfquery>

<!--- Add CBC records for those members --->
<cfloop query="qGetMembers">
	<cfscript>
		APPLICATION.CFC.CBC.insertHostCBC(
			hostID=qGetMembers.hostID,
			familyMemberID=qGetMembers.childID,
			cbcType="member",
			seasonID=10, // Hard coded to AYP 13/14
			companyID=qGetMembers.companyID,
			dateAuthorized=NOW());
	</cfscript>
</cfloop>