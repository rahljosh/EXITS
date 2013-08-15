<!--- ------------------------------------------------------------------------- ----
	
	File:		encryptSSN.cfm
	Author:		Marcus Melo
	Date:		August 2, 2012
	Desc:		Encrypts Host Family (father/mother/member) and 
				users and user members SSN
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Host Father --->
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
    </cfquery>
    
    <!--- Host Mother --->
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
    </cfquery>
    
    <!--- Host Member --->
    <cfquery name="qGetHostMemberNotEncryptedSSN" datasource="#APPLICATION.DSN#">
        SELECT 
            childID,
            SSN
        FROM 
            smg_host_children
        WHERE 
			SSN != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        AND
        	CHAR_LENGTH(SSN) < <cfqueryparam cfsqltype="cf_sql_integer" value="20">
    </cfquery>
    
	<!--- User --->
    <cfquery name="qGetUserNotEncryptedSSN" datasource="#APPLICATION.DSN#">
        SELECT 
            userID,
            SSN
        FROM 
            smg_users
        WHERE 
			SSN != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        AND
        	CHAR_LENGTH(SSN) < <cfqueryparam cfsqltype="cf_sql_integer" value="20">
    </cfquery>

	<!--- User Member --->
    <cfquery name="qGetUserMemberNotEncryptedSSN" datasource="#APPLICATION.DSN#">
        SELECT 
            ID,
            SSN
        FROM 
            smg_user_family
        WHERE 
			SSN != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        AND
        	CHAR_LENGTH(SSN) < <cfqueryparam cfsqltype="cf_sql_integer" value="20">
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
            	fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(vSetFatherSSN)#">,
                dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        		updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
            WHERE
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostFatherNotEncryptedSSN.hostID#">
		</cfquery>
                
        <p>Host Father - ###qGetHostFatherNotEncryptedSSN.hostID# - #vSetFatherSSN#</p>    
    	
    </cfloop>
    
    <p>***  Host Father SSN Update Complete * ***</p>
	<!--- End of Host Father --->

    
    
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
            	MotherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(vSetMotherSSN)#">,
                dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        		updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
            WHERE
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostMotherNotEncryptedSSN.hostID#">
		</cfquery>
                
        <p>Host Mother - ###qGetHostMotherNotEncryptedSSN.hostID# - #vSetMotherSSN#</p>    
    	
    </cfloop>
    
    <p>*** Host Mother SSN Update Complete ***</p>
	<!--- End of Host Mother --->


    
	<!--- Host Member --->
    <cfloop query="qGetHostMemberNotEncryptedSSN">
    	
        <cfscript>
			// Remove Blank Spaces
			vSetHostMemberSSN = ReplaceNoCase(qGetHostMemberNotEncryptedSSN.SSN, " ", "", "ALL");
			
			// Remove Dashs
			vSetHostMemberSSN = ReplaceNoCase(vSetHostMemberSSN, "-", "", "ALL");

			// Make sure we have a SSN number (9 digits) and add dashes
			if ( LEN(vSetHostMemberSSN) EQ 9 ) {
				
				vLastSixDigits = Right(vSetHostMemberSSN, 6);
				vSetHostMemberSSN = Left(vSetHostMemberSSN, 3) & "-" &  Left(vLastSixDigits, 2) & "-" & Right(vLastSixDigits, 4);	
				
			} else  {
				
				// Try to Decrypt
				vSetHostMemberSSN = APPLICATION.CFC.UDF.decryptVariable(vSetHostMemberSSN);
				
			}
		</cfscript>
		
		<cfquery datasource="#APPLICATION.DSN#">
			UPDATE
            	smg_host_children
            SET
            	SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(vSetHostMemberSSN)#">
            WHERE
            	childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostMemberNotEncryptedSSN.childID#">
		</cfquery>
                
        <p>Host Member - ###qGetHostMemberNotEncryptedSSN.childID# - #vSetHostMemberSSN#</p>    
    	
    </cfloop>
    
    <p>*** Host Member SSN Update Complete ***</p>
    <!--- End of Host Member --->
    
    
    
	<!--- User --->
    <cfloop query="qGetUserNotEncryptedSSN">
    	
        <cfscript>
			// Remove Blank Spaces
			vSetUserSSN = ReplaceNoCase(qGetUserNotEncryptedSSN.SSN, " ", "", "ALL");
			
			// Remove Dashs
			vSetUserSSN = ReplaceNoCase(vSetUserSSN, "-", "", "ALL");

			// Make sure we have a SSN number (9 digits) and add dashes
			if ( LEN(vSetUserSSN) EQ 9 ) {
				
				vLastSixDigits = Right(vSetUserSSN, 6);
				vSetUserSSN = Left(vSetUserSSN, 3) & "-" &  Left(vLastSixDigits, 2) & "-" & Right(vLastSixDigits, 4);	
				
			} else  {
				
				// Try to Decrypt
				vSetUserSSN = APPLICATION.CFC.UDF.decryptVariable(vSetUserSSN);
				
			}
		</cfscript>
		
		<cfquery datasource="#APPLICATION.DSN#">
			UPDATE
            	smg_users
            SET
            	SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(vSetUserSSN)#">
            WHERE
            	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUserNotEncryptedSSN.userID#">
		</cfquery>
                
        <p>User - ###qGetUserNotEncryptedSSN.userID# - #vSetUserSSN#</p>    
    	
    </cfloop>
    
    <p>*** User SSN Update Complete ***</p>
    <!--- End of User --->
    
    
    
	<!--- User Member --->
    <cfloop query="qGetUserMemberNotEncryptedSSN">
    	
        <cfscript>
			// Remove Blank Spaces
			vSetUserMemberSSN = ReplaceNoCase(qGetUserMemberNotEncryptedSSN.SSN, " ", "", "ALL");
			
			// Remove Dashs
			vSetUserMemberSSN = ReplaceNoCase(vSetUserMemberSSN, "-", "", "ALL");

			// Make sure we have a SSN number (9 digits) and add dashes
			if ( LEN(vSetUserMemberSSN) EQ 9 ) {
				
				vLastSixDigits = Right(vSetUserMemberSSN, 6);
				vSetUserMemberSSN = Left(vSetUserMemberSSN, 3) & "-" &  Left(vLastSixDigits, 2) & "-" & Right(vLastSixDigits, 4);	
				
			} else  {
				
				// Try to Decrypt
				vSetUserMemberSSN = APPLICATION.CFC.UDF.decryptVariable(vSetUserMemberSSN);
				
			}
		</cfscript>
		
		<cfquery datasource="#APPLICATION.DSN#">
			UPDATE
            	smg_user_family
            SET
            	SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(vSetUserMemberSSN)#">
            WHERE
            	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUserMemberNotEncryptedSSN.ID#">
		</cfquery>
                
        <p>User Member - ###qGetUserMemberNotEncryptedSSN.ID# - #vSetUserMemberSSN#</p>    
    	
    </cfloop>
    
    <p>*** User Member SSN Update Complete ***</p>
    <!--- End of User Member --->
    
</cfoutput>