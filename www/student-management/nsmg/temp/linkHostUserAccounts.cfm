<!--- ------------------------------------------------------------------------- ----
	
	File:		linkHostUserAccounts.cfm
	Author:		Marcus Melo
	Date:		May 2, 2012
	Desc:		
	
	Updated: 	Links Host - User Accounts

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	    
    <cfsetting requesttimeout="9999">
    
    <cfscript>
		// Create CBC Object
		c = createObject("component","extensions.components.cbc");
	</cfscript>
    
    <cfquery name="qGetActiveHostFamilies" datasource="#APPLICATION.DSN#">
    	SELECT
        	hostID
        FROM
        	smg_hosts
    	WHERE
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>
    
    <cfscript>
		// Get Active Users
		
		// Get Active Hosts

			/*
			c.qGetMotherCBCUnderUser = getValidHostCBCSubmittedUnderUser(
				firstName=qGetHost.motherFirstName,
				lastName=qGetHost.motherLastName,
				dob=qGetHost.motherDOB,
				ssn=qGetHost.motherSSN
			);

			// Cross Data - Get CBC submitted under USER
			c.qGetFatherCBCUnderUser = getValidHostCBCSubmittedUnderUser(
				firstName=qGetHost.fatherFirstName,
				lastName=qGetHost.fatherLastName,
				dob=qGetHost.fatherDOB,
				ssn=qGetHost.fatherSSN
			);
			*/
	</cfscript>


</cfsilent>    







