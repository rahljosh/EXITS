<!--- ------------------------------------------------------------------------- ----
	
	File:		encryptHostFamilySSN.cfm
	Author:		Marcus Melo
	Date:		August 2, 2012
	Desc:		Encrypting Host Family SSN numbers
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <cfquery name="qGetHostFatherNotEncryptedSSN" datasource="#APPLICATION.DSN#">
        SELECT 
            hostID,
            fatherSSN
        FROM 
            smg_hosts
        WHERE 
			fatherSSN != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        AND
        	CHAR_LENGTH(fatherSSN) < <cfqueryparam cfsqltype="cf_sql_integer" value="20">
        ORDER BY
        	hostID
    </cfquery>
    
    <cfquery name="qGetHostMotherNotEncryptedSSN" datasource="#APPLICATION.DSN#">
        SELECT 
            hostID,
            motherSSN
        FROM 
            smg_hosts
        WHERE 
			motherSSN != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        AND
        	CHAR_LENGTH(motherSSN) < <cfqueryparam cfsqltype="cf_sql_integer" value="20">
        ORDER BY
        	hostID
    </cfquery>

</cfsilent>

<cfoutput>

	<!--- Host Father --->
	<cfloop query="qGetHostFatherNotEncryptedSSN">
    	
        <cfscript>
			// Remove Blank Spaces
			vSetFatherSSN = ReplaceNoCase(qGetHostFatherNotEncryptedSSN.fatherSSN, " ", "", "ALL");
			
			// Remove Dashs
			vSetFatherSSN = ReplaceNoCase(vSetFatherSSN, "-", "", "ALL");

			// Make sure we have a SSN number (9 digits) and add dashes
			if ( LEN(vSetFatherSSN) EQ 9 ) {
				
				vLastSixDigits = Right(vSetFatherSSN, 6);
				vSetFatherSSN = Left(vSetFatherSSN, 3) & "-" &  Left(vLastSixDigits, 2) & "-" & Right(vLastSixDigits, 4);	
				
			} else  {
				
				// Try to Decrypt
				vSetFatherSSN = APPLICATION.CFC.UDF.decryptVariable(vSetFatherSSN);
				
			}
		</cfscript>
		
		<cfquery datasource="#APPLICATION.DSN#">
			UPDATE
            	smg_hosts
            SET
            	fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(vSetFatherSSN)#">
                
            WHERE
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostFatherNotEncryptedSSN.hostID#">
		</cfquery>
                
        <p>Host Father - ###qGetHostFatherNotEncryptedSSN.hostID# - #vSetFatherSSN#</p>    
    	
    </cfloop>
    
    
	<!--- Host Mother --->
    <cfloop query="qGetHostMotherNotEncryptedSSN">
    	
        <cfscript>
			// Remove Blank Spaces
			vSetMotherSSN = ReplaceNoCase(qGetHostMotherNotEncryptedSSN.MotherSSN, " ", "", "ALL");
			
			// Remove Dashs
			vSetMotherSSN = ReplaceNoCase(vSetMotherSSN, "-", "", "ALL");

			// Make sure we have a SSN number (9 digits) and add dashes
			if ( LEN(vSetMotherSSN) EQ 9 ) {
				
				vLastSixDigits = Right(vSetMotherSSN, 6);
				vSetMotherSSN = Left(vSetMotherSSN, 3) & "-" &  Left(vLastSixDigits, 2) & "-" & Right(vLastSixDigits, 4);	
				
			} else  {
				
				// Try to Decrypt
				vSetMotherSSN = APPLICATION.CFC.UDF.decryptVariable(vSetMotherSSN);
				
			}
		</cfscript>
		
		<cfquery datasource="#APPLICATION.DSN#">
			UPDATE
            	smg_hosts
            SET
            	MotherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(vSetMotherSSN)#">
                
            WHERE
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostMotherNotEncryptedSSN.hostID#">
		</cfquery>
                
        <p>Host Mother - ###qGetHostMotherNotEncryptedSSN.hostID# - #vSetMotherSSN#</p>    
    	
    </cfloop>
    
    <p>Complete</p>
    
</cfoutput>