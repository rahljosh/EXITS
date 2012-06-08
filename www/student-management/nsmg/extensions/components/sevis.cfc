<!--- ------------------------------------------------------------------------- ----
	
	File:		sevis.cfc
	Author:		Marcus Melo
	Date:		June, 08 2012
	Desc:		This holds the SEVIS Functions

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="sevis"
	output="false" 
	hint="A collection of user defined functions">


	<!--- Return the initialized UDF object --->
	<cffunction name="Init" access="public" returntype="sevis" output="No" hint="Returns the initialized SEVIS object">

		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>

	</cffunction>


	<cffunction name="insertBatch" access="public" returntype="struct" output="false" hint="Inserts SEVIS batch information, returns a structure with batchID and SEVIS batch ID">
    	<cfargument name="companyID" hint="companyID is required">
        <cfargument name="companyShort" hint="companyShort is required">
        <cfargument name="totalStudents" hint="totalStudents is required">
        <cfargument name="type" hint="type is required - new/school_update/host_update/amend/activate/end">
        <cfargument name="newStartDate" default="" hint="newStartDate is NOT required">
        <cfargument name="newEndDate" default="" hint="newEndDate is NOT required">
		
        <cfscript>
			// Structure
			sBatchInfo = StructNew();
			// Calculate total of zeros to be added to string
			vSetAdditionalZeros = '';
			// String containing total of zeros
			vZeroString = "";
		</cfscript>
		
        <cfquery 
        	result="newRecord"
			datasource="#APPLICATION.dsn#">
                INSERT INTO 
                    smg_sevis 
                (
                    companyID, 
                    createdBy, 
                    dateCreated, 
                    totalStudents, 
                    type,
                    newStartDate,
                    newEndDate
                )
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">, 
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.totalStudents#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.type#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.newStartDate#" null="#NOT isDate(ARGUMENTS.newStartDate)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.newEndDate#" null="#NOT isDate(ARGUMENTS.newEndDate)#">
                )
        </cfquery>
		
        <cfscript>
			// Set SEVIS Batch ID - 13 digit 
			vSetAdditionalZeros = 13 - LEN(newRecord.GENERATED_KEY) - LEN(ARGUMENTS.companyShort);
			
			// Loop through query
            For ( i=1; i LTE vSetAdditionalZeros; i=i+1 ) {
				vZeroString = vZeroString & 0;
            }
			
			// Return Table Sevis ID
			sBatchInfo.newRecord = newRecord.GENERATED_KEY;
			
			// Return 13 Digit SEVIS BatchID
			sBatchInfo.sevisBatchID = ARGUMENTS.companyShort & "-" & vZeroString & newRecord.GENERATED_KEY;
			
			return sBatchInfo;
		</cfscript>
	</cffunction>


	<cffunction name="getBatchHistory" access="public" returntype="query" output="false" hint="Retrieves batch information">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="isActive" default="1" hint="isActive is not required">
        
        <cfquery 
        	name="qGetBatchHistory"
			datasource="#APPLICATION.dsn#">
                SELECT 
                	studentID,
                    hostID,
                    school_name, 
                    start_date, 
                    end_date 
                FROM 
                	smg_sevis_history  
                WHERE 
                	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
				AND 
                	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isActive)#">                    
                ORDER BY 
                	historyid DESC
				LIMIT 1                    
            </cfquery>            
		            
		<cfreturn qGetBatchHistory>
	</cffunction>


	<cffunction name="insertBatchHistory" access="public" returntype="void" output="false" hint="Inserts SEVIS history information">
    	<cfargument name="batchID" hint="batchID is required">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="hostID" hint="hostID is required">
        <cfargument name="schoolName" hint="schoolName is required">
        <cfargument name="startDate" hint="startDate is required">
        <cfargument name="endDate" hint="endDate is required">

        <cfquery 
			datasource="#APPLICATION.dsn#">
                INSERT INTO 
                    smg_sevis_history 
                    (
                        batchID, 
                        studentID, 
                        hostID, 
                        school_name, 
                        start_date,
                        end_date
                    )
                VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.batchID#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.schoolName#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.startDate#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.endDate#">
                    )
        </cfquery>

	</cffunction>


	<cffunction name="displayHostFamilyName" access="public" returntype="string" output="false" hint="Displays Host Family Information (father/mother)">
    	<cfargument name="fatherFirstName" default="" hint="fatherFirstName">
        <cfargument name="fatherLastName" default="" hint="fatherLastName">
        <cfargument name="motherFirstName" default="" hint="motherFirstName">
        <cfargument name="motherLastName" default="" hint="motherLastName">

		<cfscript>
			// Format Bravo, Joe and Bravo, Jane	
			
			// Declare Variables		
			var vReturnHostFamilyName = '';
			
			// Father and Mother Names
			if ( LEN(ARGUMENTS.fatherFirstName) AND LEN(ARGUMENTS.fatherLastName) AND LEN(ARGUMENTS.motherFirstName) AND LEN(ARGUMENTS.motherLastName) ) {				
				vReturnHostFamilyName = ARGUMENTS.fatherLastName & ', ' & ARGUMENTS.fatherFirstName & ' and ' & ARGUMENTS.motherLastName & ', ' & ARGUMENTS.motherFirstName;
			// Father only
			} else if ( LEN(ARGUMENTS.fatherFirstName) AND LEN(ARGUMENTS.fatherLastName) ) {
				
				vReturnHostFamilyName = ARGUMENTS.fatherLastName & ', ' & ARGUMENTS.fatherFirstName;
			// Mother Only
			} else if ( LEN(ARGUMENTS.motherFirstName) AND LEN(ARGUMENTS.motherLastName) ) {				
				vReturnHostFamilyName = ARGUMENTS.motherLastName & ', ' & ARGUMENTS.motherFirstName;
			}
			
			// Return Host Family Formatted Name
			return(vReturnHostFamilyName);
        </cfscript>
		   
	</cffunction>


</cfcomponent>