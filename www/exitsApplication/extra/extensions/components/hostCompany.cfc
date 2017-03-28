<!--- ------------------------------------------------------------------------- ----
	
	File:		hostCompany.cfc
	Author:		Marcel
	Date:		December 08, 2010
	Desc:		This holds the functions needed for the host company

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="hostCompany"
	output="false" 
	hint="A collection of functions for the host company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="hostCompany" output="false" hint="Returns the initialized HostCompany object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>
    
    <cffunction name="getHostCompanies" access="remote" returntype="query" hint="Gets a list of host companies">
    	<cfargument name="companyID" default="0" hint="companyID is not required">
        <cfargument name="hostID" default="0" hint="hostID is not required">
        
        <cfquery name="qGetHostCompanies" datasource="#APPLICATION.DSN.Source#">
        	SELECT *
            FROM extra_hostcompany
            WHERE name != ""
            <cfif VAL(ARGUMENTS.companyID)>
            	AND companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
            </cfif>
            <cfif VAL(ARGUMENTS.hostID)>
            	AND hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
            </cfif>
             AND active = 1
            ORDER BY name
        </cfquery>
        
        <cfreturn qGetHostCompanies>
    
    </cffunction>
    	
	<cffunction name="getJobTitle" access="remote" returntype="query" hint="Gets a list of job titles for a given host company">
        <cfargument name="hostcompanyID" default="0">

        <cfquery name="qGetJobTitle" 
        	datasource="MySQL">
            SELECT
                ID,
                title
            FROM
                extra_jobs
            WHERE
            	1 = 1
            	<cfif Val(ARGUMENTS.hostcompanyID)>
                AND
                	hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostcompanyID#">
                </cfif>
            ORDER BY
                title
        </cfquery>        
        
        <cfscript>
			qNewGetJobTitle = QueryNew("ID, title");
			
			QueryAddRow(qNewGetJobTitle, 1);
			QuerySetCell(qNewGetJobTitle, "ID", 0);	
			QuerySetCell(qNewGetJobTitle, "title", "---- Select a Job Title ----");
			
			For ( i=1; i LTE qGetJobTitle.recordCount; i=i+1 ) {
				QueryAddRow(qNewGetJobTitle, 1);
				QuerySetCell(qNewGetJobTitle, "ID", qGetJobTitle.ID[i]);	
				QuerySetCell(qNewGetJobTitle, "title", qGetJobTitle.title[i]);
			}
			
			return qNewGetJobTitle;
		</cfscript>
        
	</cffunction>
    
    <cffunction name="getHostCompanyInfo" access="remote" returntype="struct" hint="Gets Host Company Info based on Host Company ID in struct Format">
    	<cfargument name="hostCompanyID" type="numeric" required="yes">
        <cfargument name="candidateID" type="numeric" required="no" default="0"> <!--- This is used to get confirmation and j1 postions based on a candidate --->
        
        <cfquery name="qGetHCInfo" datasource="MySql">
        	SELECT
            	eh.*,
                ec.confirmed,
                ep.numberPositions,
                epc.confirmation_phone
          	FROM extra_hostcompany eh
			LEFT OUTER JOIN extra_confirmations ec ON ec.hostID = eh.hostCompanyID
           		AND ec.programID = (SELECT programID FROM extra_candidates WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#"> LIMIT 1)
          	LEFT OUTER JOIN extra_j1_positions ep ON ep.hostID = eh.hostCompanyID
       			AND ep.programID = (SELECT programID FROM extra_candidates WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#"> LIMIT 1)
          	LEFT OUTER JOIN extra_program_confirmations epc ON epc.hostID = eh.hostCompanyID
         		AND epc.programID = ep.programID
           	WHERE
            	eh.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostCompanyID#">
          	ORDER BY
            	epc.confirmation_phone DESC
          	LIMIT 1
        </cfquery>
        
        <cfscript>
			result = StructNew();
			result.hasCompany = 0;
			result.authenticationSecretaryOfState = 0;
			result.authenticationDepartmentOfLabor = 0;
			result.authenticationGoogleEarth = 0;
			result.AUTHENTICATIONINCORPORATION = 0;
			result.AUTHENTICATIONCERTIFICATEOFEXISTENCE = 0;
			result.AUTHENTICATIONCERTIFICATEOFREINSTATEMENT = 0;
			result.AUTHENTICATIONDEPARTMENTOFSTATE = 0;
			result.AUTHENTICATIONBUSINESSLICENSENOTAVAILABLE = 0;
			result.AUTHENTICATIONSECRETARYOFSTATEEXPIRATION = "";
			result.AUTHENTICATIONDEPARTMENTOFLABOREXPIRATION = "";
			result.AUTHENTICATIONGOOGLEEARTHEXPIRATION = "";
			result.AUTHENTICATIONINCORPORATIONEXPIRATION = "";
			result.AUTHENTICATIONCERTIFICATEOFEXISTENCEEXPIRATION = "";
			result.AUTHENTICATIONCERTIFICATEOFREINSTATEMENTEXPIRATION = "";
			result.AUTHENTICATIONDEPARTMENTOFSTATEEXPIRATION = "";
			result.EIN = "";
			result.WC = 0;
			result.WCE = "";
			result.WC_CARRIERNAME = "";
			result.WC_CARRIERPHONE = "";
			result.WC_POLICYNUMBER = "";
			result.CONFIRMED = 0;
			result.POSITIONS = 0;
			result.PHONECONFIRMATION = "";
			result.WARNINGSTATUS = 0;
			result.WARNINGNOTES = "";
			
			if (qGetHCInfo.recordCount) {
				result.hasCompany = 1;
				result.authenticationSecretaryOfState = qGetHCInfo.authentication_secretaryOfState;
				result.authenticationDepartmentOfLabor = qGetHCInfo.authentication_departmentOfLabor;
				result.authenticationGoogleEarth = qGetHCInfo.authentication_googleEarth;
				result.AUTHENTICATIONINCORPORATION = qGetHCInfo.authentication_incorporation;
				result.AUTHENTICATIONCERTIFICATEOFEXISTENCE = qGetHCInfo.authentication_certificateOfExistence;
				result.AUTHENTICATIONCERTIFICATEOFREINSTATEMENT = qGetHCInfo.authentication_certificateOfReinstatement;
				result.AUTHENTICATIONDEPARTMENTOFSTATE = qGetHCInfo.authentication_departmentOfState;
				result.AUTHENTICATIONBUSINESSLICENSENOTAVAILABLE = qGetHCInfo.authentication_businessLicenseNotAvailable;
				result.AUTHENTICATIONSECRETARYOFSTATEEXPIRATION = qGetHCInfo.authentication_secretaryOfStateExpiration;
				result.AUTHENTICATIONDEPARTMENTOFLABOREXPIRATION = qGetHCInfo.authentication_departmentOfLaborExpiration;
				result.AUTHENTICATIONGOOGLEEARTHEXPIRATION = qGetHCInfo.authentication_googleEarthExpiration;
				result.AUTHENTICATIONINCORPORATIONEXPIRATION = qGetHCInfo.authentication_incorporationExpiration;
				result.AUTHENTICATIONCERTIFICATEOFEXISTENCEEXPIRATION = qGetHCInfo.authentication_certificateOfExistenceExpiration;
				result.AUTHENTICATIONCERTIFICATEOFREINSTATEMENTEXPIRATION = qGetHCInfo.authentication_certificateOfReinstatementExpiration;
				result.AUTHENTICATIONDEPARTMENTOFSTATEEXPIRATION = qGetHCInfo.authentication_departmentOfStateExpiration;
				result.EIN = qGetHCInfo.EIN;
				result.WC = qGetHCInfo.workmenscompensation;
				result.WCE = DateFormat(qGetHCInfo.WCDateExpired, 'mm/dd/yyyy');
				result.WC_CARRIERNAME = qGetHCInfo.WC_carrierName;
				result.WC_CARRIERPHONE = qGetHCInfo.WC_carrierPhone;
				result.WC_POLICYNUMBER = qGetHCInfo.WC_policyNumber;
				result.CONFIRMED = qGetHCInfo.confirmed;
				result.POSITIONS = qGetHCInfo.numberPositions;
				result.PHONECONFIRMATION = DateFormat(qGetHCInfo.confirmation_phone, 'mm/dd/yyyy');
				result.WARNINGSTATUS = qGetHCInfo.warningStatus;
				result.WARNINGNOTES = qGetHCInfo.warningNotes;
			}
			return result;
		</cfscript>
        
    </cffunction>
    
	<!--- Start of Auto Suggest --->
    <cffunction name="remoteLookUpHostComp" access="remote" returnFormat="json" output="false" hint="Remote function to get host families, returns an array">
        <cfargument name="searchString" type="string" default="" hint="Search is not required">
        <cfargument name="maxRows" type="numeric" required="false" default="30" hint="Max Rows is not required" />
        <cfargument name="companyID" default="#CLIENT.companyID#" hint="CompanyID is not required">
        
        <cfscript>
			var vReturnArray = arrayNew(1);
		</cfscript>
        
        <cfquery 
			name="qRemoteLookUpHost" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	hostCompanyID,
					CAST( 
                    	CONCAT(                      
                            name,
                            ' (##',
                            hostCompanyID,
                            ') - ',
                            supervisor                  
						) 
					AS CHAR) AS displayName
                FROM 
                	extra_hostcompany
                WHERE           
                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 

				<cfif IsNumeric(ARGUMENTS.searchString)>
                    AND
                    	hostCompanyID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                <cfelse>
                    AND 
                       	(
                        	name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                         OR
                         	supervisor LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.searchString#%">
                        )
				</cfif>	

                ORDER BY 
                    name

				LIMIT 
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.maxRows#" />                 
        </cfquery>

		<cfscript>
			// Loop through query
            For ( i=1; i LTE qRemoteLookUpHost.recordCount; i=i+1 ) {

				vUserStruct = structNew();
				vUserStruct.hostCompID = qRemoteLookUpHost.hostCompanyID[i];
				vUserStruct.displayName = qRemoteLookUpHost.displayName[i];
				
				ArrayAppend(vReturnArray,vUserStruct);
            }
			
			return vReturnArray;
        </cfscript>

    </cffunction>
    
    <!--- Update / Insert program related confirmations --->
    <cffunction name="updateInsertProgramConfirmations" access="public" returntype="void" output="no">
    	<cfargument name="hostID" required="yes">
        <cfargument name="programID" required="yes">
        <cfargument name="confirmation_phone" default="">
        
        <cfquery name="qGetProgramConfirmations" datasource="#APPLICATION.DSN.Source#">
        	SELECT *
            FROM extra_program_confirmations
            WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
            AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
        </cfquery>
        
        <cfif VAL(qGetProgramConfirmations.recordCount)>
        	<cfquery datasource="#APPLICATION.DSN.Source#">
            	UPDATE extra_program_confirmations
                <cfif IsDate(ARGUMENTS.confirmation_phone)>
                	SET confirmation_phone = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.confirmation_phone#">
                <cfelse>
                	SET confirmation_phone = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetProgramConfirmations.confirmation_phone#">
                </cfif>
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetProgramConfirmations.id#">
            </cfquery>
        <cfelse>
        	<cfquery datasource="#APPLICATION.DSN.Source#">
            	INSERT INTO extra_program_confirmations (
                	hostID,
                    programID,
                    confirmation_phone)
               	VALUES (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">,
            		<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.confirmation_phone#" null="#NOT ISDATE(ARGUMENTS.confirmation_phone)#">
                )
            </cfquery>
        </cfif>
        
    </cffunction>
    
    
    <cffunction name="getTotalAndActivePlacements" access="remote" returnFormat="json" hint="Gets a list of host companies">
    	<cfargument name="companyID" default="0" required="yes" />
        <cfargument name="programID" default="0" required="yes" />
        
        <cfset returnValue = "" />
        
        <cfquery name="qGetActivePrograms" datasource="#APPLICATION.DSN.Source#">
            SELECT p.programID, p.startDate, p.programName,
                j.numberPositions, j.verifiedDate,
                conf.confirmed, conf.confirmedDate
            FROM smg_programs p
            INNER JOIN smg_companies c ON c.companyID = p.companyID
            LEFT OUTER JOIN extra_j1_positions j ON j.programID = p.programID
                AND j.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
            LEFT OUTER JOIN extra_confirmations conf ON conf.programID = p.programID
                AND conf.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
            WHERE dateDiff(p.endDate,NOW()) >= <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND p.is_deleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND p.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
            AND p.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
            ORDER BY p.startDate ASC
        </cfquery>
        
        
        <cfquery name="qGetActivePlacements" datasource="#APPLICATION.DSN.Source#">
            SELECT COUNT(ecpc.candCompID) as total
            FROM extra_candidate_place_company ecpc
            INNER JOIN extra_candidates c ON c.candidateID = ecpc.candidateID
                AND c.cancel_date IS NULL
            WHERE ecpc.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
            AND c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
            AND ecpc.status = 1
        </cfquery>
        
        <cfscript>
			
			vStudentStruct = structNew();
			vStudentStruct.code = 0;
			vStudentStruct.text = "";
				
			if ((qGetActivePrograms.numberPositions NEQ "") && (qGetActivePrograms.numberPositions NEQ 0) && (qGetActivePrograms.numberPositions <= qGetActivePlacements.total)) {
				vStudentStruct.code = 1;
				vStudentStruct.text = "The Host Company has already reached the total number of available J1 positions!";
			}
			
			return vStudentStruct;
		</cfscript>
    
    </cffunction>


    <cffunction name="getAllPlacements" access="remote" returnFormat="json" hint="Gets a list of host companies">
        <cfargument name="hostID" default="0" required="yes" />
        
        <cfset returnValue = "" />
        
        <cfquery name="qGetAllPlacements" datasource="#APPLICATION.DSN.Source#">
            SELECT c.candidateID
            FROM extra_candidate_place_company ecpc
            INNER JOIN extra_candidates c ON c.candidateID = ecpc.candidateID
                AND c.cancel_date IS NULL
            WHERE ecpc.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
        </cfquery>
        
        <cfscript>
            return qGetAllPlacements;
        </cfscript>
    
    </cffunction>

    <cffunction name="deleteCompany" access="remote" returnFormat="json" hint="Gets a list of host companies">
        <cfargument name="hostID" default="0" required="yes" />
        
        <cfset returnValue = "" />
        
        <cfquery name="deleteCompany" datasource="#APPLICATION.DSN.Source#">
            UPDATE extra_hostcompany
            SET active = 0
            WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
        </cfquery>
        
        <cfscript>
            return 1;
        </cfscript>
    
    </cffunction>

</cfcomponent>
