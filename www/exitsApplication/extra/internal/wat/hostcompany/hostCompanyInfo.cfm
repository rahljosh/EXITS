<!--- ------------------------------------------------------------------------- ----
	
	File:		hostCompanyInfo.cfm
	Author:		Marcus Melo
	Date:		November 04, 2010
	Desc:		Host Family Information

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	
    
  	<!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="extensions.components.udf" jsclassname="UDFComponent">

    <!--- Param variables --->
    <cfparam name="URL.hostCompanyID" default="0">
	<!--- FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.hostCompanyID" default="0">
    <cfparam name="FORM.name" default="">
    <cfparam name="FORM.business_typeID" default="">
    <cfparam name="FORM.businessTypeOther" default="">
    <!--- Work Site Address --->
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <!--- HQ Address --->
    <cfparam name="FORM.hqAddress" default="">
    <cfparam name="FORM.hqCity" default="">
    <cfparam name="FORM.hqState" default="">
    <cfparam name="FORM.hqZip" default="">
    <!--- Housing Information --->
    <cfparam name="FORM.isHousingProvided" default="0">
	<cfparam name="FORM.housingProvidedInstructions" default="">    
    <cfparam name="FORM.housing_options" default="">
    <cfparam name="FORM.housing_cost" default="">
    <cfparam name="FORM.housing_deposit" default="">
    <cfparam name="FORM.housingAddress" default="">
    <cfparam name="FORM.housingCity" default="">
    <cfparam name="FORM.housingState" default="">
    <cfparam name="FORM.housingZip" default="">
    <cfparam name="FORM.housingProviderName" default="">
    <cfparam name="FORM.housingPhone" default="">
    <cfparam name="FORM.housingEmail" default="">
	<!--- Primary Contact --->  
    <cfparam name="FORM.owner" default="">  
    <cfparam name="FORM.supervisor" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.phoneExt" default="">
    <cfparam name="FORM.cellPhone" default="">
    <cfparam name="FORM.fax" default="">
    <cfparam name="FORM.email" default="">
    <!--- Supervisor --->
    <cfparam name="FORM.isSupervisorShown" default="0"> 
    <cfparam name="FORM.supervisor_name" default="">
    <cfparam name="FORM.supervisor_phone" default="">
    <cfparam name="FORM.supervisor_phoneExt" default="">
    <cfparam name="FORM.supervisor_cellPhone" default="">
    <cfparam name="FORM.supervisor_email" default="">
    <!--- Additional Supervisor --->
    <cfparam name="FORM.addNewSupervisor" default="0">
    <cfparam name="FORM.new_supervisor_name" default="">
   	<cfparam name="FORM.new_supervisor_phone" default="">
    <cfparam name="FORM.new_supervisor_phoneExt" default="">
    <cfparam name="FORM.new_supervisor_cellPhone" default="">
    <cfparam name="FORM.new_supervisor_email" default="">
    <!--- Other Information --->    
    <cfparam name="FORM.personJobOfferName" default="">
    <cfparam name="FORM.personJobOfferTitle" default="">
    <cfparam name="FORM.EIN" default="">
	<cfparam name="FORM.workmensCompensation" default="">
    <cfparam name="FORM.WC_carrierName" default="">
    <cfparam name="FORM.WC_carrierPhone" default="">
    <cfparam name="FORM.WC_policyNumber" default="">
    <cfparam name="FORM.WCDateExpired" default="">
    <cfparam name="FORM.homepage" default="">
    <cfparam name="FORM.observations" default="">
    <cfparam name="FORM.warningStatus" default="0">
    <cfparam name="FORM.warningNotes" default="">
    <!--- Authentications --->
    <cfparam name="FORM.authentication_secretaryOfState" default="0">
    <cfparam name="FORM.authentication_departmentOfLabor" default="0">
	<cfparam name="FORM.authentication_googleEarth" default="0">
    <cfparam name="FORM.authentication_incorporation" default="0">
    <cfparam name="FORM.authentication_certificateOfExistence" default="0">
    <cfparam name="FORM.authentication_certificateOfReinstatement" default="0">
    <cfparam name="FORM.authentication_departmentOfState" default="0">
    <cfparam name="FORM.authentication_secretaryOfStateExpiration" default="">
    <cfparam name="FORM.authentication_departmentOfLaborExpiration" default="">
    <cfparam name="FORM.authentication_googleEarthExpiration" default="">
    <cfparam name="FORM.authentication_incorporationExpiration" default="">
    <cfparam name="FORM.authentication_certificateOfExistenceExpiration" default="">
    <cfparam name="FORM.authentication_certificateOfReinstatementExpiration" default="">
    <cfparam name="FORM.authentication_departmentOfStateExpiration" default="">
    <cfparam name="FORM.authentication_businessLicenseNotAvailable" default="0">
	<!--- Arrival Information --->    
    <cfparam name="FORM.isPickUpProvided" default="0">
    <cfparam name="FORM.arrivalAirport" default="">
	<cfparam name="FORM.arrivalAirportCity" default="">    
    <cfparam name="FORM.arrivalAirportState" default="">     
    <cfparam name="FORM.arrivalPickUpHours" default="">
    <cfparam name="FORM.arrivalInstructions" default="">
    <cfparam name="FORM.pickUpContactName" default="">    
    <cfparam name="FORM.pickUpContactPhone" default="">    
    <cfparam name="FORM.pickUpContactEmail" default="">
    <cfparam name="FORM.pickUpContactHours" default="">
    <cfparam name="FORM.arrivalPickUpDays" default="">
    <cfparam name="FORM.arrivalPickUpCost" default="">
    <cfparam name="FORM.pickUpNotes" default="">
    
    <!--- Fields to check if file has been uploaded / deleted (to display message instead of reloading) --->
    <cfparam name="FORM.authentication_secretaryOfStateFileChange" default="0">
    <cfparam name="FORM.authentication_departmentOfLaborFileChange" default="0">
    <cfparam name="FORM.authentication_googleEarthFileChange" default="0">
    <cfparam name="FORM.authentication_workmensCompensationFileChange" default="0">
    
    <cfscript>
		vGoogleMaps = '';
	</cfscript>
    
    <cfquery name="qGetHostCompanyInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	eh.hostCompanyID, 
            eh.business_typeID, 
            eh.name, 
            eh.address, 
            eh.city, 
			eh.state, 
            eh.zip, 
            eh.hqAddress, 
            eh.hqCity, 
            eh.hqState, 
            eh.hqZip,
            eh.housingAddress, 
            eh.housingCity, 
            eh.housingState, 
            eh.housingZip,
            eh.phone,
            eh.phoneExt,
            eh.cellPhone, 
            eh.fax, 
            eh.email,
            eh.owner, 
            eh.supervisor,
            eh.isSupervisorShown,
            eh.supervisor_name, 
            eh.supervisor_phone, 
            eh.supervisor_phoneExt,
            eh.supervisor_cellPhone, 
            eh.supervisor_email, 
            eh.homepage, 
            eh.personJobOfferName,
            eh.personJobOfferTitle, 
            eh.authentication_secretaryOfState,
            eh.authentication_departmentOfLabor, 
            eh.authentication_googleEarth,
            eh.authentication_incorporation,
            eh.authentication_certificateOfExistence,
            eh.authentication_certificateOfReinstatement,
            eh.authentication_departmentOfState,
            eh.authentication_secretaryOfStateExpiration, 
            eh.authentication_departmentOfLaborExpiration,
            eh.authentication_googleEarthExpiration,
            eh.authentication_incorporationExpiration,
            eh.authentication_certificateOfExistenceExpiration,
            eh.authentication_certificateOfReinstatementExpiration,
            eh.authentication_departmentOfStateExpiration,
            eh.authentication_businessLicenseNotAvailable,
            eh.EIN,
            eh.workmensCompensation,
            eh.WC_carrierName,
            eh.WC_carrierPhone,
            eh.WC_policyNumber, 
            eh.WCDateExpired, 
            eh.observations,
            eh.housing_options, 
            eh.housing_cost, 
            eh.housing_deposit,
            eh.housingProviderName,
            eh.housingPhone,
            eh.housingEmail,
            eh.picture_type,
            eh.enteredBy, 
            eh.entryDate, 
            eh.isHousingProvided,
            eh.housingProvidedInstructions, 
            eh.isPickUpProvided,
            eh.arrivalAirport, 
            eh.arrivalAirportCity, 
            eh.arrivalAirportState,
            eh.arrivalPickUpHours, 
            eh.arrivalInstructions, 
            eh.pickUpContactName,
            eh.pickUpContactPhone, 
            eh.pickUpContactEmail, 
            eh.pickUpContactHours,
            eh.arrivalPickUpDays,
            eh.arrivalPickUpCost,
            eh.pickUpNotes,
            eh.warningStatus,
            eh.warningNotes,
            et.business_type as typeBusiness, 
            s.stateName,
            workSiteS.stateName as hqStateName,
            housingS.stateName as housingStateName,
            airportS.stateName as arrivalAirportStateName            
        FROM extra_hostcompany eh
        LEFT OUTER JOIN smg_states s ON eh.state = s.ID
        LEFT OUTER JOIN smg_states workSiteS ON eh.hqState = workSiteS.ID
        LEFT OUTER JOIN smg_states housingS ON eh.housingState = housingS.ID
        LEFT OUTER JOIN smg_states airportS ON eh.arrivalAirportState = airportS.ID
        LEFT OUTER JOIN extra_typebusiness et ON et.business_typeID = eh.business_typeID
        WHERE eh.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
    </cfquery>
	
    <cfquery name="qGetenteredBy" datasource="#APPLICATION.DSN.Source#">
        SELECT firstname, lastname
        FROM smg_users
        WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostCompanyInfo.enteredBy)#"> 
    </cfquery>
    
    <cfquery name="qGetJobs" datasource="#APPLICATION.DSN.Source#">
    	SELECT id, title, hours, description, wage, wage_type, classification
        FROM extra_jobs
        WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostCompanyInfo.hostCompanyID)#">
    </cfquery> 
    
    <cfquery name="qGetHousing" datasource="#APPLICATION.DSN.Source#">
    	SELECT ID, type
        FROM extra_housing
        WHERE isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        ORDER BY type					
    </cfquery>

    <cfquery name="qGetBusinessType" datasource="#APPLICATION.DSN.Source#">
        SELECT business_typeID, business_type
        FROM extra_typebusiness
		ORDER BY business_type            
    </cfquery>

    <cfquery name="qGetStateList" datasource="#APPLICATION.DSN.Source#">
        SELECT id, state, stateName
        FROM smg_states
      	ORDER BY stateName
    </cfquery>

    <cfquery name="qGetWorkSiteState" dbtype="query">
        SELECT id, state, stateName
        FROM qGetStateList
      	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostCompanyInfo.state)#">
    </cfquery>
    
    <cfquery name="qGetActivePrograms" datasource="#APPLICATION.DSN.Source#">
    	SELECT p.programID, p.startDate, p.programName,
        	j.numberPositions, j.verifiedDate,
            conf.confirmed, conf.confirmedDate
      	FROM smg_programs p
        INNER JOIN smg_companies c ON c.companyID = p.companyID
        LEFT OUTER JOIN extra_j1_positions j ON j.programID = p.programID
			AND j.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostCompanyInfo.hostCompanyID)#">
       	LEFT OUTER JOIN extra_confirmations conf ON conf.programID = p.programID
        	AND conf.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostCompanyInfo.hostCompanyID)#">
      	WHERE dateDiff(p.endDate,NOW()) >= <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND p.is_deleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND p.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
        GROUP BY p.programID
        ORDER BY p.startDate ASC
    </cfquery>
    
    <cfquery name="qGetProgramParticipation" datasource="#APPLICATION.DSN.Source#">
    	SELECT p.programID, p.programName
        FROM smg_programs p, extra_candidate_place_company ecpc, extra_candidates c
        WHERE p.programID = c.programID
        AND c.candidateID = ecpc.candidateID
        AND c.cancel_date IS NULL
        AND ecpc.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostCompanyInfo.hostCompanyID)#">
        GROUP BY p.programName
        ORDER BY p.startDate DESC
    </cfquery>
    
    <!--- Get database records for authentication files --->
    <cfquery name="qGetAuthenticationFile" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostauthenticationfiles
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
        AND (dateExpires >= <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
        OR dateExpires IS NULL)
        ORDER BY dateAdded DESC
    </cfquery>
    
    <cfquery name="qGetSecretaryOfStateFile" dbtype="query">
    	SELECT *
        FROM qGetAuthenticationFile
        WHERE authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="secretaryOfState">
    </cfquery>
    
    <cfquery name="qGetDepartmentOfLaborFile" dbtype="query">
    	SELECT *
        FROM qGetAuthenticationFile
        WHERE authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departmentOfLabor">
    </cfquery>
    
    <cfquery name="qGetGoogleEarthFile" dbtype="query">
    	SELECT *
        FROM qGetAuthenticationFile
        WHERE authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="googleEarth">
    </cfquery>
    
    <cfquery name="qGetWorkmensCompensationFile" dbtype="query">
    	SELECT *
        FROM qGetAuthenticationFile
        WHERE authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="workmensCompensation">
    </cfquery>
    
    <cfquery name="qGetIncorporationFile" dbtype="query">
    	SELECT *
        FROM qGetAuthenticationFile
        WHERE authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="incorporation">
    </cfquery>
    
    <cfquery name="qGetCertificateOfExistenceFile" dbtype="query">
    	SELECT *
        FROM qGetAuthenticationFile
        WHERE authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="certificateOfExistence">
    </cfquery>
    
    <cfquery name="qGetCertificateOfReinstatementFile" dbtype="query">
    	SELECT *
        FROM qGetAuthenticationFile
        WHERE authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="certificateOfReinstatement">
    </cfquery>
    
    <cfquery name="qGetDepartmentOfStateFile" dbtype="query">
    	SELECT *
        FROM qGetAuthenticationFile
        WHERE authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departmentOfState">
    </cfquery>
    <!--- End of get database records for authentication files --->
    
    <cfquery name="qGetAdditonalDocuments" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM document
        WHERE foreignTable = "extra_hostCompany"
        AND foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostCompanyID)#">
        AND documentTypeID = 42
        AND isDeleted = 0
    </cfquery>
    
    <cfquery name="qGetAdditionalSupervisors" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostcompany_supervisor
        WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostCompanyID)#">
        AND isDeleted = 0
    </cfquery>
                
    <!--- FORM Submitted --->
    <cfif FORM.submitted>
    
        <cfquery name="qCheckForDuplicates" datasource="#APPLICATION.DSN.Source#">
            SELECT hostCompanyID, name
            FROM extra_hostcompany
            WHERE name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.name#">
			AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">                
            <cfif VAL(FORM.hostCompanyID)>
                AND hostCompanyID != <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hostCompanyID#">
            </cfif>
        </cfquery>
        
        <!--- Data Validation --->
		<cfscript>
            // Check required Fields
            if ( qCheckForDuplicates.recordCount ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('It seems this host company has been entered in the database as follow <a href="?curdoc=hostcompany/hostCompanyInfo&hostcompanyid=#qCheckForDuplicates.hostCompanyID#">#qCheckForDuplicates.name# (###qCheckForDuplicates.hostCompanyID#)</a>');
            }
			
            if ( NOT LEN(FORM.name) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Business name is required');
            }
			
            if ( NOT VAL(FORM.business_typeID) AND FORM.business_typeID NEQ 'Other' ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Business type is required');
            }

            if ( FORM.business_typeID EQ 'Other' AND NOT LEN(FORM.businessTypeOther) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('You selected other as business type, please specify');
            }
			
			if ( NOT LEN(FORM.address) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Address is required');
            }
		</cfscript>

		<!--- Check if we need to insert business type --->
        <cfif LEN(FORM.businessTypeOther) AND FORM.business_typeID EQ 'Other'>
            
            <cfquery name="qCheckBusinessType" datasource="#APPLICATION.DSN.Source#">
                SELECT business_typeID, business_type 
                FROM extra_typebusiness
                WHERE business_type LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.businessTypeOther#">
            </cfquery>
                                
            <!--- Found a match for business type --->
            <cfif qCheckBusinessType.recordCount>
            
                <cfscript>
                    // Set New Business Type
                    FORM.business_typeID = qCheckBusinessType.business_typeID;
                </cfscript>
            
            <cfelse>
            
                <cfquery result="newBusinessType" datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO
                        extra_typebusiness 
                    (
                        business_type
                    ) 
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.businessTypeOther#">
                    )
                </cfquery>
                
                <cfscript>
                    // Set New Business Type
                    FORM.business_typeID = newBusinessType.GENERATED_KEY;
                </cfscript>
                
            </cfif>
            
        </cfif>
        
        <!--- // Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
        
			<cfif VAL(FORM.hostCompanyID)>
            

                <!--- Update --->
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 
                        extra_hostcompany 
                    SET 
                        name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.name#">,
                        business_typeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.business_typeID#">,
                        <!--- Work Site Address --->
                        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.address)#">,
                        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.city)#">,
                        state = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(FORM.state)#">,
                        zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.zip)#">,
                        <!--- HQ Address --->
                        hqAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.hqAddress)#">,
                        hqCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.hqCity)#">,
                        hqState = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(FORM.hqState)#">,
                        hqZip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.hqZip)#">,
                        <!--- Housing Information --->
                        isHousingProvided = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#VAL(FORM.isHousingProvided)#">,
                        housingProvidedInstructions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housingProvidedInstructions#">,
                        housing_options = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housing_options#">,
                        housing_cost = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.housing_cost)#">,
                        housing_deposit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.housing_deposit)#">,
                        housingAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingAddress)#">,
                        housingCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingCity)#">,
                        housingState = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.housingState)#">,
                        housingZip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingZip)#">,
                        housingProviderName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingProviderName)#">,
                        housingPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingPhone)#">,
                        housingEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingEmail)#">,
                        <!--- Contact --->
                        owner = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.owner#">,
                        supervisor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor#">,
                        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        phoneExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phoneExt#">,
                        cellPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cellPhone#">,
                        fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <!--- Supervisor --->
                        isSupervisorShown = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isSupervisorShown)#">,
                        supervisor_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_name#">,
                        supervisor_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_phone#">,
                        supervisor_phoneExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_phoneExt#">,
                        supervisor_cellPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_cellPhone#">,
                        supervisor_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_email#">,
                        <!--- Other Information --->
                        personJobOfferName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferName#">,
                        personJobOfferTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferTitle#">,
                        authentication_secretaryOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_secretaryOfState)#">,
                        authentication_departmentOfLabor = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_departmentOfLabor)#">,
                        authentication_googleEarth = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_googleEarth)#">,
                        authentication_incorporation = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_incorporation)#">,
                        authentication_certificateOfExistence = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_certificateOfExistence)#">,
                        authentication_certificateOfReinstatement = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_certificateOfReinstatement)#">,
                        authentication_departmentOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_departmentOfState)#">,
                        authentication_secretaryOfStateExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_secretaryOfStateExpiration#">,
                        authentication_departmentOfLaborExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_departmentOfLaborExpiration#">,
                        authentication_googleEarthExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_googleEarthExpiration#">,
                        authentication_incorporationExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_incorporationExpiration#">,
						authentication_certificateOfExistenceExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_certificateOfExistenceExpiration#">,
						authentication_certificateOfReinstatementExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_certificateOfReinstatementExpiration#">,
						authentication_departmentOfStateExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_departmentOfStateExpiration#">,
                        authentication_businessLicenseNotAvailable = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.authentication_businessLicenseNotAvailable#">,
                        EIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.EIN#">,
                        workmensCompensation = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.workmensCompensation#" null="#NOT IsNumeric(FORM.workmensCompensation)#">,
                        WC_carrierName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_carrierName#">,
                        WC_carrierPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_carrierPhone#">,
                        WC_policyNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_policyNumber#">,
                        WCDateExpired = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.WCDateExpired#" null="#NOT IsDate(FORM.WCDateExpired)#">,
                        homepage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homepage#">,
                        observations = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.observations#">,
                        <!--- Arrival Information --->
                        isPickUpProvided = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isPickUpProvided)#">,
                        arrivalAirport = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrivalAirport#">,
                        arrivalAirportCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrivalAirportCity#">,
                        arrivalAirportState = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.arrivalAirportState#">,
                        arrivalPickUpHours = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrivalPickUpHours#">,
                        arrivalInstructions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrivalInstructions#">,
                        pickUpContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pickUpContactName#">,
                        pickUpContactPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pickUpContactPhone#">,
                        pickUpContactEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pickUpContactEmail#">,
                        pickUpContactHours = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pickUpContactHours#">,
                        arrivalPickUpDays = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrivalPickUpDays#">,
                        arrivalPickUpCost = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ReReplace(FORM.arrivalPickUpCost, '[^\d.]', '','ALL'))#">,
                        pickUpNotes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.pickUpNotes#">,
                        warningStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.warningStatus)#">,
                        warningNotes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.warningNotes#">
                    WHERE
                        hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">
                </cfquery>
                
                
                <!--- Update previously added supervisors --->
                <cfloop query="qGetAdditionalSupervisors">
                	<cfquery datasource="#APPLICATION.DSN.Source#">
                    	UPDATE extra_hostcompany_supervisor
                        SET
                        	name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['supervisor_name_' & qGetAdditionalSupervisors.ID]#">,
                            officePhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['supervisor_phone_' & qGetAdditionalSupervisors.ID]#">,
                            officePhoneExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['supervisor_phoneExt_' & qGetAdditionalSupervisors.ID]#">,
                            mobilePhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['supervisor_cellPhone_' & qGetAdditionalSupervisors.ID]#">,
                            email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['supervisor_email_' & qGetAdditionalSupervisors.ID]#">,
                            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM['supervisor_delete_' & qGetAdditionalSupervisors.ID]#">
                      	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetAdditionalSupervisors.ID#">
                    </cfquery>
                </cfloop>
                
                <!--- Add a new supervisor if there is one --->
                <cfif VAL(FORM.addNewSupervisor)>
                    <cfquery datasource="#APPLICATION.DSN.Source#">
                        INSERT INTO extra_hostcompany_supervisor (
                            hostCompanyID,
                            name,
                            officePhone,
                            officePhoneExt,
                            mobilePhone,
                            email)
                        VALUES (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.new_supervisor_name#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.new_supervisor_phone#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.new_supervisor_phoneExt#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.new_supervisor_cellPhone#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.new_supervisor_email#">)
                    </cfquery>
                </cfif>
                
                <!--- Update authentication file expiration dates --->
                
                <!--- These are to enable the expiration dates to be updated on items that have expired but were added within the past day.
				This is helpful because the expiration date is set on upload and if it is shown as expired it could not otherwise be updated. --->
                <cfif NOT VAL(qGetSecretaryOfStateFile.recordCount)>
                	<cfquery name="qGetSecretaryOfStateFile" datasource="#APPLICATION.DSN.Source#">
                    	SELECT id
                        FROM extra_hostauthenticationfiles
                        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
                        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="secretaryOfState">
                        AND dateAdded >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-1,NOW())#">
                    </cfquery>
                </cfif>
                <cfif NOT VAL(qGetDepartmentOfLaborFile.recordCount)>
                	<cfquery name="qGetDepartmentOfLaborFile" datasource="#APPLICATION.DSN.Source#">
                    	SELECT id
                        FROM extra_hostauthenticationfiles
                        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
                        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departmentOfLabor">
                        AND dateAdded >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-1,NOW())#">
                    </cfquery>
                </cfif>
                <cfif NOT VAL(qGetGoogleEarthFile.recordCount)>
                	<cfquery name="qGetGoogleEarthFile" datasource="#APPLICATION.DSN.Source#">
                    	SELECT id
                        FROM extra_hostauthenticationfiles
                        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
                        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="googleEarth">
                        AND dateAdded >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-1,NOW())#">
                    </cfquery>
                </cfif>
                <cfif NOT VAL(qGetWorkmensCompensationFile.recordCount)>
                	<cfquery name="qGetWorkmensCompensationFile" datasource="#APPLICATION.DSN.Source#">
                    	SELECT id
                        FROM extra_hostauthenticationfiles
                        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
                        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="workmensCompensation">
                        AND dateAdded >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-1,NOW())#">
                    </cfquery>
                </cfif>
                <cfif NOT VAL(qGetIncorporationFile.recordCount)>
                	<cfquery name="qGetIncorporationFile" datasource="#APPLICATION.DSN.Source#">
                    	SELECT id
                        FROM extra_hostauthenticationfiles
                        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
                        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="incorporation">
                        AND dateAdded >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-1,NOW())#">
                    </cfquery>
                </cfif>
                <cfif NOT VAL(qGetCertificateOfExistenceFile.recordCount)>
                	<cfquery name="qGetCertificateOfExistenceFile" datasource="#APPLICATION.DSN.Source#">
                    	SELECT id
                        FROM extra_hostauthenticationfiles
                        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
                        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="certificateOfExistence">
                        AND dateAdded >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-1,NOW())#">
                    </cfquery>
                </cfif>
                <cfif NOT VAL(qGetCertificateOfReinstatementFile.recordCount)>
                	<cfquery name="qGetCertificateOfReinstatementFile" datasource="#APPLICATION.DSN.Source#">
                    	SELECT id
                        FROM extra_hostauthenticationfiles
                        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
                        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="certificateOfReinstatement">
                        AND dateAdded >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-1,NOW())#">
                    </cfquery>
                </cfif>
                <cfif NOT VAL(qGetDepartmentOfStateFile.recordCount)>
                	<cfquery name="qGetDepartmentOfStateFile" datasource="#APPLICATION.DSN.Source#">
                    	SELECT id
                        FROM extra_hostauthenticationfiles
                        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
                        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departmentOfState">
                        AND dateAdded >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-1,NOW())#">
                    </cfquery>
                </cfif>
                
                <!--- These are the actual updates --->
                <cfquery datasource="#APPLICATION.DSN.Source#">
                	UPDATE extra_hostauthenticationfiles
                    SET dateExpires = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_secretaryOfStateExpiration#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetSecretaryOfStateFile.id)#">
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN.Source#">
                	UPDATE extra_hostauthenticationfiles
                    SET dateExpires = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_departmentOfLaborExpiration#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetDepartmentOfLaborFile.id)#">
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN.Source#">
                	UPDATE extra_hostauthenticationfiles
                    SET dateExpires = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_googleEarthExpiration#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetGoogleEarthFile.id)#">
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN.Source#">
                	UPDATE extra_hostauthenticationfiles
                    SET dateExpires = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.WCDateExpired#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetWorkmensCompensationFile.id)#">
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN.Source#">
                	UPDATE extra_hostauthenticationfiles
                    SET dateExpires = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_incorporationExpiration#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetIncorporationFile.id)#">
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN.Source#">
                	UPDATE extra_hostauthenticationfiles
                    SET dateExpires = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_certificateOfExistenceExpiration#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCertificateOfExistenceFile.id)#">
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN.Source#">
                	UPDATE extra_hostauthenticationfiles
                    SET dateExpires = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_certificateOfReinstatementExpiration#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCertificateOfReinstatementFile.id)#">
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN.Source#">
                	UPDATE extra_hostauthenticationfiles
                    SET dateExpires = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_departmentOfStateExpiration#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetDepartmentOfStateFile.id)#">
                </cfquery>
                
                <!--- End update authentication file expiration dates --->
                
                <!--- Update/Insert J1 Positions --->
                <cfloop query="qGetActivePrograms">
                    
                    <cfquery name="qCheckRecords" datasource="#APPLICATION.DSN.Source#">
                    	SELECT *
                       	FROM extra_j1_positions
                       	WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompanyInfo.hostCompanyID#">
                        AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetActivePrograms.programID#">
                    </cfquery>
                    
                    <cfscript>
						number = evaluate("##FORM.numberPositions_" & programID & "##");
						date = evaluate("##FORM.j1Date_" & programID & "##");
					</cfscript>
                    
                    <cfif qCheckRecords.recordCount>
                    	<cfquery datasource="#APPLICATION.DSN.Source#">
                        	UPDATE extra_j1_positions
                           	SET
                            	numberPositions = <cfqueryparam cfsqltype="cf_sql_integer" value="#number#">
                                <cfif isDate('#date#')>
                                	,verifiedDate = <cfqueryparam cfsqltype="cf_sql_date" value="#date#">
                               	<cfelse>
                                	,verifiedDate = NULL
                             	</cfif>
                          	WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompanyInfo.hostCompanyID#">
                            AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetActivePrograms.programID#">
                        </cfquery>
                   	<cfelse>
                    	<cfquery datasource="#APPLICATION.DSN.Source#">
                        	INSERT INTO
                            	extra_j1_positions
                           		(
                                	hostID,
                                    programID,
                                    numberPositions,
                                    verifiedDate
                                )
                          	VALUES
                            	(
                                	<cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompanyInfo.hostCompanyID#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetActivePrograms.programID#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#number#">
                                    <cfif isDate('#date#')>
                                    	, <cfqueryparam cfsqltype="cf_sql_date" value="#date#">
                                   	<cfelse>
                                    	, NULL
                                    </cfif>
                                )
                        </cfquery>
                    </cfif>
                    
                </cfloop>
                <!--- End Update / Insert J1 Positions --->
                
                <!--- Update / Insert Confirmations --->
                <cfloop query="qGetActivePrograms">
                    
                    <cfquery name="qCheckRecords" datasource="#APPLICATION.DSN.Source#">
                    	SELECT *
                       	FROM extra_confirmations
                       	WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompanyInfo.hostCompanyID#">
                        AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetActivePrograms.programID#">
                    </cfquery>
                    
                    <cfscript>
						number = evaluate("##FORM.confirmation_" & programID & "##");
						date = evaluate("##FORM.confirmationDate_" & programID & "##");
					</cfscript>
                    
                    <cfif qCheckRecords.recordCount>
                    	<cfquery datasource="#APPLICATION.DSN.Source#">
                        	UPDATE extra_confirmations
                           	SET
                            	confirmed = <cfqueryparam cfsqltype="cf_sql_integer" value="#number#">
                                <cfif isDate('#date#')>
                                	,confirmedDate = <cfqueryparam cfsqltype="cf_sql_date" value="#date#">
                              	<cfelse>
                                	,confirmedDate = NULL
                             	</cfif>
                          	WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompanyInfo.hostCompanyID#">
                            AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetActivePrograms.programID#">
                        </cfquery>
                   	<cfelse>
                    	<cfquery datasource="#APPLICATION.DSN.Source#">
                        	INSERT INTO
                            	extra_confirmations
                           		(
                                	hostID,
                                    programID,
                                    confirmed,
                                    confirmedDate
                                )
                          	VALUES
                            	(
                                	<cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompanyInfo.hostCompanyID#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetActivePrograms.programID#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#number#">
                                    <cfif isDate('#date#')>
                                    	, <cfqueryparam cfsqltype="cf_sql_date" value="#date#">
                                  	<cfelse>
                                    	, NULL
                                    </cfif>
                                )
                        </cfquery>
                    </cfif>
                    
                </cfloop>
                <!--- End Update / Insert Confirmations --->
                
                <!--- Add History Record --->
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO extra_hostinfohistory (
                        hostID,
                        changedBy,
                        dateChanged,
                        personJobOfferName,
                        personJobOfferTitle,
                        EIN,
                        workmensCompensation,
                        WC_carrierName,
                        WC_carrierPhone,
                        WC_policyNumber,
                        WCDateExpired,
                        homepage,
                        observations,
                        authentication_secretaryOfState,
                        authentication_departmentOfLabor,
                        authentication_googleEarth,
                        authentication_incorporation,
                        authentication_certificateOfExistence,
                        authentication_certificateOfReinstatement,
                        authentication_departmentOfState,
                        authentication_secretaryOfStateExpiration,
                        authentication_departmentOfLaborExpiration,
                        authentication_googleEarthExpiration,
                        authentication_incorporationExpiration,
                        authentication_certificateOfExistenceExpiration,
                        authentication_certificateOfReinstatementExpiration,
                        authentication_departmentOfStateExpiration,
                        authentication_businessLicenseNotAvailable )
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferTitle#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.EIN#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.workmensCompensation#" null="#NOT IsNumeric(FORM.workmensCompensation)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_carrierName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_carrierPhone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_policyNumber#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.WCDateExpired#" null="#NOT IsDate(FORM.WCDateExpired)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homepage#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.observations#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_secretaryOfState)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_departmentOfLabor)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_googleEarth)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_incorporation)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_certificateOfExistence)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_certificateOfReinstatement)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_departmentOfState)#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_secretaryOfStateExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_departmentOfLaborExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_googleEarthExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_incorporationExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_certificateOfExistenceExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_certificateOfReinstatementExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_departmentOfStateExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.authentication_businessLicenseNotAvailable#"> )
                </cfquery>
                
                <cfquery name="qGetNewHistoryID" datasource="#APPLICATION.DSN.Source#">
                	SELECT historyID
                    FROM extra_hostinfohistory
                    WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">
                    ORDER BY historyID DESC
                    LIMIT 1
                </cfquery>
                
                <cfloop query="qGetActivePrograms">
                
                	<cfscript>
						confirmedNumber = evaluate("##FORM.confirmation_" & programID & "##");
						confirmedNewDate = evaluate("##FORM.confirmationDate_" & programID & "##");
						j1Number = evaluate("##FORM.numberPositions_" & programID & "##");
						j1NewDate = evaluate("##FORM.j1Date_" & programID & "##");
					</cfscript>
                
                	<cfquery datasource="#APPLICATION.DSN.Source#">
                        INSERT INTO extra_hostseasonhistory (
                            hostHistoryID,
                            programID,
                            j1Date,
                            confirmedDate,
                            j1Positions,
                            confirmed )
                      	VALUES (
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewHistoryID.historyID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetActivePrograms.programID)#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#j1NewDate#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#confirmedNewDate#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(j1Number)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(confirmedNumber)#"> )
                    </cfquery>
                    
                </cfloop>
                <!--- End Add History Record --->
                
            <cfelse>

				<!--- Insert Host Company --->                  
                <cfquery result="newRecord" datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO 
                        extra_hostcompany 
                    (
                        companyID,
                        name,
                        business_typeID,
                        <!--- Work Site Address --->
                        address,
                        city,
                        state,
                        zip,
                        <!--- HQ Address --->
                        hqAddress,
                        hqCity,
                        hqState,
                        hqZip,
                        <!--- Housing Information --->
                        isHousingProvided,
                        housingProvidedInstructions,
                        housing_options,
                        housing_cost,
                        housing_deposit,
                        housingAddress,
                        housingCity,
                        housingState,
                        housingZip,
                        housingProviderName,
                        housingPhone,
                        housingEmail,
                        <!--- Contact --->
                        supervisor,
                        phone,
                        phoneExt,
                        cellPhone,
                        fax,
                        email,
                        <!--- Supervisor --->
                        owner,
                        isSupervisorShown,
                        supervisor_name,
                        supervisor_phone,
                        supervisor_phoneExt,
                        supervisor_cellPhone,
                        supervisor_email,
                        <!--- Other Information --->
                        personJobOfferName,
                        personJobOfferTitle,
                       	authentication_secretaryOfState,
                        authentication_departmentOfLabor,
                        authentication_googleEarth,
                        authentication_incorporation,
                        authentication_certificateOfExistence,
                        authentication_certificateOfReinstatement,
                        authentication_departmentOfState,
                        authentication_secretaryOfStateExpiration,
                        authentication_departmentOfLaborExpiration,
                        authentication_googleEarthExpiration,
                        authentication_incorporationExpiration,
                        authentication_certificateOfExistenceExpiration,
                        authentication_certificateOfReinstatementExpiration,
                        authentication_departmentOfStateExpiration,
                        authentication_businessLicenseNotAvailable,
                        EIN,
                        workmensCompensation,
                        WC_carrierName,
                        WC_carrierPhone,
                        WC_policyNumber,
                        WCDateExpired,
                        homepage,
                        observations,
                        warningStatus,
                        warningNotes,
                        <!--- Arrival Information --->
                        isPickUpProvided,
                        arrivalAirport,
                        arrivalAirportCity,
                        arrivalAirportState,
                        arrivalPickUpHours,
                        arrivalInstructions,
                        pickUpContactName,
                        pickUpContactPhone,
                        pickUpContactEmail,
                        pickUpContactHours,
                        arrivalPickUpDays,
                        arrivalPickUpCost,
                        pickUpNotes,
                        <!--- Record Information --->
                        entryDate,
                        enteredBy
                    )                
                    VALUES 
                    (
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.name#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.business_typeID#">,
                        <!--- Work Site Address --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.address)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.city)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(FORM.state)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.zip)#">,
                        <!--- HQ Address --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.hqAddress)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.hqCity)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(FORM.hqState)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.hqZip)#">,
						<!--- Housing Information --->
                        <cfqueryparam cfsqltype="cf_sql_tinyint" value="#FORM.isHousingProvided#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housingProvidedInstructions#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housing_options#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.housing_cost)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.housing_deposit)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingAddress)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingCity)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(FORM.housingState)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingZip)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingProviderName)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingPhone)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.housingEmail)#">,
                        <!--- Contact --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phoneExt#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cellPhone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <!--- Supervisor --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.owner#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isSupervisorShown)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_phoneExt#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_cellPhone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_email#">,
						<!--- Other Information --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferTitle#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_secretaryOfState)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_departmentOfLabor)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_googleEarth)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_incorporation)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_certificateOfExistence)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_certificateOfReinstatement)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_departmentOfState)#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_secretaryOfStateExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_departmentOfLaborExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_googleEarthExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_incorporationExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_certificateOfExistenceExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_certificateOfReinstatementExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_departmentOfStateExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.authentication_businessLicenseNotAvailable#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.EIN#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.workmensCompensation#" null="#NOT IsNumeric(FORM.workmensCompensation)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_carrierName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_carrierPhone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_policyNumber#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.WCDateExpired#" null="#NOT IsDate(FORM.WCDateExpired)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homepage#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.observations#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.warningStatus)#">,
                        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.warningNotes#">,
                        <!--- Arrival Information --->
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isPickUpProvided)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrivalAirport#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrivalAirportCity#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.arrivalAirportState#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrivalPickUpHours#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrivalInstructions#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pickUpContactName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pickUpContactPhone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pickUpContactEmail#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pickUpContactHours#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrivalPickUpDays#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ReReplace(FORM.arrivalPickUpCost, '[^\d.]', '','ALL'))#">,
                        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.pickUpNotes#">,
                        <!--- Record Information --->
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                    )
                </cfquery>
                
                <!--- Get the host company id that was just added --->
                <cfquery name="qGetNewHost" datasource="#APPLICATION.DSN.Source#">
                	SELECT hostcompanyid
                    FROM extra_hostcompany
                    ORDER BY hostcompanyid DESC
                    LIMIT 1
                </cfquery>
                
                <!--- Insert J1 Positions --->
                <cfloop query="qGetActivePrograms">
                    <cfscript>
						number = evaluate("##FORM.numberPositions_" & programID & "##");
						date = evaluate("##FORM.j1Date_" & programID & "##");
					</cfscript>
                    <cfquery datasource="#APPLICATION.DSN.Source#">
               			INSERT INTO extra_j1_positions (
                            hostID,
                            programID,
                            numberPositions,
                            verifiedDate )
                  		VALUES (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewHost.hostCompanyID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetActivePrograms.programID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(number)#">,
                            <cfif isDate('#date#')>
                                <cfqueryparam cfsqltype="cf_sql_date" value="#date#">
                            <cfelse>
                                NULL
                            </cfif> )
                 	</cfquery>
                </cfloop>
                <!--- End Insert J1 Positions --->
                
                <!--- Insert Confirmations --->
                <cfloop query="qGetActivePrograms">
                    <cfscript>
						number = evaluate("##FORM.confirmation_" & programID & "##");
						date = evaluate("##FORM.confirmationDate_" & programID & "##");
					</cfscript>
                    <cfquery datasource="#APPLICATION.DSN.Source#">
                        INSERT INTO extra_confirmations (
                            hostID,
                            programID,
                            confirmed,
                            confirmedDate )
                        VALUES (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewHost.hostCompanyID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetActivePrograms.programID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(number)#">,
                            <cfif isDate('#date#')>
                                <cfqueryparam cfsqltype="cf_sql_date" value="#date#">
                            <cfelse>
                                NULL
                            </cfif> )
                    </cfquery>
                </cfloop>
                <!--- End Update / Insert Confirmations --->
                
                <!--- Add History Record --->
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO extra_hostinfohistory (
                        hostID,
                        changedBy,
                        dateChanged,
                        personJobOfferName,
                        personJobOfferTitle,
                        EIN,
                        workmensCompensation,
                        WC_carrierName,
                        WC_carrierPhone,
                        WC_policyNumber,
                        WCDateExpired,
                        homepage,
                        observations,
                        authentication_secretaryOfState,
                        authentication_departmentOfLabor,
                        authentication_googleEarth,
                        authentication_incorporation,
                        authentication_certificateOfExistence,
                        authentication_certificateOfReinstatement,
                        authentication_departmentOfState,
                        authentication_secretaryOfStateExpiration,
                        authentication_departmentOfLaborExpiration,
                        authentication_googleEarthExpiration,
                        authentication_incorporationExpiration,
                        authentication_certificateOfExistenceExpiration,
                        authentication_certificateOfReinstatementExpiration,
                        authentication_departmentOfStateExpiration,
                        authentication_businessLicenseNotAvailable )
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetNewHost.hostCompanyID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferTitle#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.EIN#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.workmensCompensation#" null="#NOT IsNumeric(FORM.workmensCompensation)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_carrierName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_carrierPhone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_policyNumber#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.WCDateExpired#" null="#NOT IsDate(FORM.WCDateExpired)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homepage#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.observations#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_secretaryOfState)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_departmentOfLabor)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_googleEarth)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_incorporation)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_certificateOfExistence)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_certificateOfReinstatement)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_departmentOfState)#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_secretaryOfStateExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_departmentOfLaborExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_googleEarthExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_incorporationExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_certificateOfExistenceExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_certificateOfReinstatementExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.authentication_departmentOfStateExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.authentication_businessLicenseNotAvailable#">)
                </cfquery>
                <!--- End Add History Record --->
                
                <cfscript>
					// Set new host company ID
					FORM.hostCompanyID = newRecord.GENERATED_KEY;
				</cfscript>
                
            </cfif> <!--- hostCompanyID --->
            
			<cfscript>
                // Set Page Message
                SESSION.pageMessages.Add("Form successfully submitted.");
                
                // Reload page with updated information
                location("#CGI.SCRIPT_NAME#?curdoc=hostCompany/hostCompanyInfo&hostCompanyID=#FORM.hostCompanyID#", "no");
            </cfscript>
    
    	</cfif> <!--- errors --->
        
    <cfelse>
    
 		<cfscript>
			// Set FORM Values
			// Escape Double Quotes
			FORM.name = APPLICATION.CFC.UDF.escapeQuotes(qGetHostCompanyInfo.name);
			FORM.business_typeID = qGetHostCompanyInfo.business_typeID;
			// Work Site Address
			FORM.address = qGetHostCompanyInfo.address;
			FORM.city = qGetHostCompanyInfo.city;
			FORM.state = qGetHostCompanyInfo.state;
			FORM.zip = qGetHostCompanyInfo.zip;
			// HQ Address
			FORM.hqAddress = qGetHostCompanyInfo.hqAddress;
			FORM.hqCity = qGetHostCompanyInfo.hqCity;
			FORM.hqState = qGetHostCompanyInfo.hqState;
			FORM.hqZip = qGetHostCompanyInfo.hqZip;
			// Housing Information
			FORM.isHousingProvided = qGetHostCompanyInfo.isHousingProvided;
			FORM.housingProvidedInstructions = qGetHostCompanyInfo.housingProvidedInstructions;
			FORM.housing_options = qGetHostCompanyInfo.housing_options;
			FORM.housing_cost = qGetHostCompanyInfo.housing_cost;
			FORM.housing_deposit = qGetHostCompanyInfo.housing_deposit;
			FORM.housingAddress = qGetHostCompanyInfo.housingAddress;
			FORM.housingCity = qGetHostCompanyInfo.housingCity;
			FORM.housingState = qGetHostCompanyInfo.housingState;
			FORM.housingZip = qGetHostCompanyInfo.housingZip;
			FORM.housingProviderName = qGetHostCompanyInfo.housingProviderName;
			FORM.housingPhone = qGetHostCompanyInfo.housingPhone;
			FORM.housingEmail = qGetHostCompanyInfo.housingEmail;
			// Primary Contact
			FORM.owner = qGetHostCompanyInfo.owner;
			FORM.supervisor = qGetHostCompanyInfo.supervisor;
			FORM.phone = qGetHostCompanyInfo.phone;
			FORM.phoneExt = qGetHostCompanyInfo.phoneExt;
			FORM.cellPhone = qGetHostCompanyInfo.cellPhone;
			FORM.fax = qGetHostCompanyInfo.fax;
			FORM.email = qGetHostCompanyInfo.email;
			// Supervisor
			FORM.isSupervisorShown = qGetHostCompanyInfo.isSupervisorShown;
			FORM.supervisor_name = qGetHostCompanyInfo.supervisor_name;
			FORM.supervisor_phone = qGetHostCompanyInfo.supervisor_phone;
			FORM.supervisor_phoneExt = qGetHostCompanyInfo.supervisor_phoneExt;
			FORM.supervisor_cellPhone = qGetHostCompanyInfo.supervisor_cellPhone;
			FORM.supervisor_email = qGetHostCompanyInfo.supervisor_email;
			// Other Information
			FORM.personJobOfferName = qGetHostCompanyInfo.personJobOfferName;
			FORM.personJobOfferTitle = qGetHostCompanyInfo.personJobOfferTitle;
			FORM.authentication_secretaryOfState = qGetHostCompanyInfo.authentication_secretaryOfState;
			FORM.authentication_departmentOfLabor = qGetHostCompanyInfo.authentication_departmentOfLabor;
			FORM.authentication_googleEarth = qGetHostCompanyInfo.authentication_googleEarth;
			FORM.authentication_incorporation = qGetHostCompanyInfo.authentication_incorporation;
			FORM.authentication_certificateOfExistence = qGetHostCompanyInfo.authentication_certificateOfExistence;
			FORM.authentication_certificateOfReinstatement = qGetHostCompanyInfo.authentication_certificateOfReinstatement;
			FORM.authentication_departmentOfState = qGetHostCompanyInfo.authentication_departmentOfState;
			FORM.authentication_secretaryOfStateExpiration = qGetHostCompanyInfo.authentication_secretaryOfStateExpiration;
			FORM.authentication_departmentOfLaborExpiration = qGetHostCompanyInfo.authentication_departmentOfLaborExpiration;
			FORM.authentication_googleEarthExpiration = qGetHostCompanyInfo.authentication_googleEarthExpiration;
			FORM.authentication_incorporationExpiration = qGetHostCompanyInfo.authentication_incorporationExpiration;
			FORM.authentication_certificateOfExistenceExpiration = qGetHostCompanyInfo.authentication_certificateOfExistenceExpiration;
			FORM.authentication_certificateOfReinstatementExpiration = qGetHostCompanyInfo.authentication_certificateOfReinstatementExpiration;
			FORM.authentication_departmentOfStateExpiration = qGetHostCompanyInfo.authentication_departmentOfStateExpiration;
			FORM.authentication_businessLicenseNotAvailable = qGetHostCompanyInfo.authenticatioN_businessLicenseNotAvailable;
			FORM.EIN = qGetHostCompanyInfo.EIN;
			FORM.workmensCompensation = qGetHostCompanyInfo.workmensCompensation;
			FORM.WC_carrierName = qGetHostCompanyInfo.WC_carrierName;
			FORM.WC_carrierPhone = qGetHostCompanyInfo.WC_carrierPhone;
			FORM.WC_policyNumber = qGetHostCompanyInfo.WC_policyNumber;
			FORM.WCDateExpired = qGetHostCompanyInfo.WCDateExpired;
			FORM.homepage = qGetHostCompanyInfo.homepage;
			FORM.observations = qGetHostCompanyInfo.observations;
			FORM.warningStatus = qGetHostCompanyInfo.warningStatus;
			FORM.warningNotes = qGetHostCompanyInfo.warningNotes;
			// Arrival Information
			FORM.isPickUpProvided = qGetHostCompanyInfo.isPickUpProvided;
			FORM.arrivalAirport = qGetHostCompanyInfo.arrivalAirport;
			FORM.arrivalAirportCity  = qGetHostCompanyInfo.arrivalAirportCity;  
			FORM.arrivalAirportState = qGetHostCompanyInfo.arrivalAirportState;      
			FORM.arrivalPickUpHours = qGetHostCompanyInfo.arrivalPickUpHours;
			FORM.arrivalInstructions = qGetHostCompanyInfo.arrivalInstructions;
			FORM.pickUpContactName = qGetHostCompanyInfo.pickUpContactName;  
			FORM.pickUpContactPhone = qGetHostCompanyInfo.pickUpContactPhone;    
			FORM.pickUpContactEmail = qGetHostCompanyInfo.pickUpContactEmail;
			FORM.pickUpContactHours = qGetHostCompanyInfo.pickUpContactHours;
			FORM.arrivalPickUpDays = qGetHostCompanyInfo.arrivalPickUpDays;
			FORM.arrivalPickUpCost = qGetHostCompanyInfo.arrivalPickUpCost;
			FORM.pickUpNotes = qGetHostCompanyInfo.pickUpNotes;
		</cfscript>

		<cfscript>
			/**********
				Google --> http://www.google.com/maps?q=4301+West+Vine+Street,+Kissimmee,+FL+34741&hl=en&t=h&z=16
				Output --> http://www.google.com/maps?q=4301+W+Vine+St,+Kissimmee,+FL+34741&hl=en&t=h&z=16
			**********/
			
			if ( LEN(FORM.address) AND LEN(FORM.city) AND LEN(qGetWorkSiteState.state) ) {
				// Address
				vGoogleMapsAddress = ReplaceNoCase( ReplaceNoCase(FORM.address, ' ', '+', "All"), ',', '', "All") & ',';
				
				// City
				vGoogleMapsAddress = vGoogleMapsAddress & '+' & ReplaceNoCase(FORM.city, ' ', '+', "All") & ',';
				
				// State
				vGoogleMapsAddress = vGoogleMapsAddress & '+' & ReplaceNoCase(qGetWorkSiteState.state, ' ', '+', "All");
				
				// Zip Code
				if ( LEN(FORM.hqZip) ) {
					vGoogleMapsAddress = vGoogleMapsAddress & '+' & ReplaceNoCase(FORM.zip, ' ', '+', "All");
				}
				
				// Set Up Google Maps Link
				vGoogleMaps = 'http://www.google.com/maps?q=' & vGoogleMapsAddress & '&hl=en&t=h&z=16';
			}
        </cfscript>
        
    </cfif>

</cfsilent>

<script language="javascript" src="../linked/js/ajaxUpload.js"></script>

<script language="JavaScript">

	$(document).ready(function() {
		// $(".formField").attr("disabled","disabled");
		
		
    	checkHousingOnLoad();

		
		showHideBusinessTypeOther();
		displayPickUpInfo();
		//showSupervisor();
		
		// Get Host Company Value // If 0, we are inserting a new host company // Set page to add/edit mode
		if ( $("#hostCompanyID").val() == 0 ) {
			readOnlyEditPage();
		}

		<cfif SESSION.formErrors.length()>
			// There are errors / display edit page
			readOnlyEditPage();
		</cfif>
	});
	
	var jsCopyAddress = function () {
		isChecked = $("#copyAddress").attr('checked');
		if ( isChecked ) {
			$("#hqAddress").val($("#address").val());
			$("#hqCity").val($("#city").val());
			$("#hqState").val($("#state").val());
			$("#hqZip").val($("#zip").val());
			$("#trZipLookUpHQ").fadeOut();
		} else {
			$("#hqAddress").val("");
			$("#hqCity").val("");
			$("#hqState").val("");
			$("#hqZip").val("");
		}
	}

	var jsCopyContact = function () {
		isChecked = $("#copyContact").attr('checked');
		if ( isChecked ) {
			$("#supervisor_name").val($("#supervisor").val());
			$("#supervisor_phone").val($("#phone").val());
			$("#supervisor_cellPhone").val($("#cellPhone").val());
			$("#supervisor_email").val($("#email").val());
		} else {
			$("#supervisor_name").val("");
			$("#supervisor_phone").val("");
			$("#supervisor_cellPhone").val("");
			$("#supervisor_email").val("");
		}
	}

	var displayPickUpInfo = function() { 
		// Get PickUp Info
		getPickUpInfo = $('input:radio[name=isPickUpProvided]:checked').val();
		if ( getPickUpInfo == 1 ) {
			$(".pickUpInfo").fadeIn("fast");
		} else {
			//erase data
			$("#arrivalPickUpHours").val("");
			$("#arrivalPickUpDays").val("");
			$("#arrivalInstructions").val("");
			$("#pickUpContactName").val("");
			$("#pickUpContactPhone").val("");
			$("#pickUpContactEmail").val("");
			$("#pickUpContactHours").val("");
			$(".pickUpInfo").fadeOut("fast");
		}
	}

	// Show/hide request placement
	var showHideBusinessTypeOther = function() { 
		
		getSelectedOption = $("#business_typeID").val();
		if ( getSelectedOption == 'Other' ) {
			// Show Business Type Other
			$("#rowBusinessTypeID").slideDown("fast");
		} else {
			// Hide Business Type Other
			$("#rowBusinessTypeID").slideUp("fast");
			// Clear Field
			$("#businessTypeOther").val("");
		}
		
	}
	
	// Fomat Phone Number
	jQuery(function($){
	   $("#phone").mask("(999)999-9999");
	   $("#cellPhone").mask("(999)999-9999");
	   $("#fax").mask("(999)999-9999");
	   $("#supervisor_phone").mask("(999)999-9999");
	   $("#supervisor_cellPhone").mask("(999)999-9999");
	   $("#pickUpContactPhone").mask("(999)999-9999");
	   $("#WC_carrierPhone").mask("(999)999-9999");
	   $(".phone").mask("(999)999-9999");
	});	
	// --> 
	
	// Function to find the index in an array of the first entry with a specific value. 
	// It is used to get the index of a column in the column list. 
	Array.prototype.findIdx = function(value){ 
		for (var i=0; i < this.length; i++) { 
			if (this[i] == value) { 
				return i; 
			} 
		} 
	} 

	// Create an instance of the proxy. 
	var udf = new UDFComponent();
 
	var verifyAddress = function() { 
		// Check required Fields
		var errorMessage = "";
		if($("#name").val() == ''){
			errorMessage = (errorMessage + 'Please enter the Business Name. \n')
		}
		if($("#business_typeID").val() == 0){
			errorMessage = (errorMessage + 'Please select the Business Type. \n')
		}
		if($("#address").val() == ''){
			errorMessage = (errorMessage + 'Please enter the Work Site Address. \n')
		}
		if($("#city").val() == ''){
			errorMessage = (errorMessage + 'Please enter the Work Site City. \n')
		}
		if($("#state").val() == 0){
			errorMessage = (errorMessage + 'Please enter the Work Site State. \n')
		}
		if($("#zip").val() == ''){
			errorMessage = (errorMessage + 'Please enter the Work Site Zip. \n')
		}
		if($("#hqAddress").val() == ''){
			errorMessage = (errorMessage + 'Please enter the HQ Address. \n')
		}
		if($("#hqCity").val() == ''){
			errorMessage = (errorMessage + 'Please enter the HQ City. \n')
		}
		if($("#hqState").val() == 0){
			errorMessage = (errorMessage + 'Please enter the HQ State. \n')
		}
		if($("#hqZip").val() == ''){
			errorMessage = (errorMessage + 'Please enter the HQ Zip. \n')
		}
		if (errorMessage != "") {
			alert(errorMessage);
		} else {
			// FORM Variables
			var address = $.trim($("#address").val());
			var city = $.trim($("#city").val());
			var state = $.trim($("#state").val());
			var zip = $.trim($("#zip").val());
			
			// Address verification is broken (It was based on Google Maps API v2) commented out until working.
			$("#hostCompany").submit();
			
			// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
			//udf.setCallbackHandler(checkAddress); 
			//udf.setErrorHandler(myErrorHandler);
			//udf.addressLookup(address,city,state,zip,"232");
		}
	} 


    var confirmDelete = function() { 
        console.log('confirmDelete');
        $.ajax({
            url: "../../extensions/components/hostCompany.cfc?method=getAllPlacements",
            dataType: "json",
            data: { 
                hostID: $("#hostCompanyID").val()
            },
            success: function(data) {
                //console.log(data.DATA);
                //console.log(data.DATA.length);
               if (data.DATA.length > 0 ) {
                    alert("Company cannot be deleted, Candidates placement:\n " + data.DATA);
                    //console.log(data.DATA);
                } else {
                    //console.log('Clean');
                    if (confirm("Are you sure you want to delete this company?")) {
                        window.open("../../extensions/components/hostCompany.cfc?method=deleteCompany&companyID="+ $("#hostCompanyID").val(), $("#hostCompanyID").val(), "width=10, height=10");
                        $.ajax({
                            url: "../../extensions/components/hostCompany.cfc?method=deleteCompany",
                            dataType: "json",
                            data: { 
                                hostID: $("#hostCompanyID").val()
                            },
                            success: function(data) {
                                //console.log(data.DATA);
                                //console.log(data.DATA.length);
                                alert("Company Deleted");
                            }
                        })
                    }
                }
            }
        })
    }


	// Callback function to handle the results returned by the getHostLeadList function and populate the table. 
	var checkAddress = function(googleResponse) { 

		var isAddressVerified = googleResponse.ISVERIFIED;
		var inputState = googleResponse.INPUTSTATE;
	
		if ( isAddressVerified == 1 ) {
		
			// Get Data Back	
			var streetAddress = googleResponse.ADDRESS;
			var city = googleResponse.CITY;
			var state = googleResponse.STATE;
			var zip = googleResponse.ZIP
			zip = zip.substring('zip='.length);
			var verifiedStateID = googleResponse.VERIFIEDSTATEID;
			
			if ((streetAddress == $.trim($("#address").val())) && (city == $.trim($("#city").val())) && (state == inputState) && (zip == $.trim($("#zip").val())))
			{
				callCheckHQAddress();
			} else {
				$(function() {
					$( "#dialog:ui-dialog" ).dialog( "destroy" );
					$( "#dialog-approveAddress-confirm" ).empty();
					$( "#dialog-approveAddress-confirm" ).append(
						"<table width='100%'>" +
							"<tr width='100%'><td width='50%'>Verified Address:</td><td width='50%'>Input Address:</td></tr>" +
							"<tr><td>" + streetAddress + "</td><td>" + $("#address").val() + "</td></tr>" +
							"<tr><td>" + city + ", " + state + " " + zip + "</td><td>" + $("#city").val() + ", " + inputState + " " + $("#zip").val() + "</td></tr>" +
						"</table>");
					$( "#dialog-approveAddress-confirm").dialog({
						resizable: false,
						height:230,
						width:400,
						modal: true,
						buttons: {
							"Use verified": function() {
								$("#address").val(streetAddress);
								$("#city").val(city);
								$("#state").val(verifiedStateID);
								$("#zip").val(zip);
								$( this ).dialog( "close" );
								callCheckHQAddress();
							},
							"Use input": function() {
								$( this ).dialog( "close" );
								callCheckHQAddress();
							},
							"Go back": function() {
								$( this ).dialog( "close" );
							}
						}
					});
				});
			}
		} else {
			$(function() {
				$( "#dialog:ui-dialog" ).dialog( "destroy" );
				$( "#dialog-canNotVerify-confirm" ).empty();
				$( "#dialog-canNotVerify-confirm" ).append("We could not verify the following address:<br />" + $("#address").val() + "<br />" + $("#city").val() + ", " + inputState + " " + $("#zip").val());
				$( "#dialog-canNotVerify-confirm").dialog({
					resizable: false,
					height:230,
					width:400,
					modal: true,
					buttons: {
						"Use anyway": function() {
							$( this ).dialog( "close" );
							callCheckHQAddress();
						},
						"Go back": function() {
							$( this ).dialog( "close" );
						}
					}
				});
			});
		}
	}
	
	var callCheckHQAddress = function() {
		var hqAddress = $.trim($("#hqAddress").val());
		var hqCity = $.trim($("#hqCity").val());
		var hqState = $.trim($("#hqState").val());
		var hqZip = $.trim($("#hqZip").val());
		
		udf.setCallbackHandler(checkHQAddress); 
		udf.setErrorHandler(myErrorHandler);
		udf.addressLookup(hqAddress,hqCity,hqState,hqZip,"232");
	}
	
	// Callback function to handle the results returned by the getHostLeadList function and populate the table. 
	var checkHQAddress = function(googleResponse) { 

		var isAddressVerified = googleResponse.ISVERIFIED;
		var inputState = googleResponse.INPUTSTATE;

		if ( isAddressVerified == 1 ) {
		
			// Get Data Back	
			var streetAddress = googleResponse.ADDRESS;
			var hqCity = googleResponse.CITY;
			var hqState = googleResponse.STATE;
			var hqZip = googleResponse.ZIP;
			hqZip = hqZip.substring('zip='.length);
			var verifiedStateID = googleResponse.VERIFIEDSTATEID;
				
			if ((streetAddress == $.trim($("#hqAddress").val())) && (hqCity == $.trim($("#hqCity").val())) && (hqState == inputState) && (hqZip == $.trim($("#hqZip").val())))
			{
				$("#hostCompany").submit();
			} else {
				$(function() {
					$( "#dialog:ui-dialog" ).dialog( "destroy" );
					$( "#dialog-approveAddress-confirmHQ" ).empty();
					$( "#dialog-approveAddress-confirmHQ" ).append(
						"<table width='100%'>" +
							"<tr width='100%'><td width='50%'>Verified Address:</td><td width='50%'>Input Address:</td></tr>" +
							"<tr><td>" + streetAddress + "</td><td>" + $("#hqAddress").val() + "</td></tr>" +
							"<tr><td>" + hqCity + ", " + hqState + " " + hqZip + "</td><td>" + $("#hqCity").val() + ", " + inputState + " " + $("#hqZip").val() + "</td></tr>" +
						"</table>");
					$( "#dialog-approveAddress-confirmHQ").dialog({
						resizable: false,
						height:230,
						width:400,
						modal: true,
						buttons: {
							"Use verified": function() {
								$( this ).dialog( "close" );
								$("#hqAddress").val(streetAddress);
								$("#hqCity").val(hqCity);
								$("#hqState").val(verifiedStateID);
								$("#hqZip").val(hqZip);
								$("#hostCompany").submit();
							},
							"Use input": function() {
								$( this ).dialog( "close" );
								$("#hostCompany").submit();
							},
							"Go back": function() {
								$( this ).dialog( "close" );
							}
						}
					});
				});
			}
		} else {
			$(function() {
				$( "#dialog:ui-dialog" ).dialog( "destroy" );
				$( "#dialog-canNotVerify-confirmHQ" ).empty();
				$( "#dialog-canNotVerify-confirmHQ" ).append("We could not verify the following address:<br />" + $("#hqAddress").val() + "<br />" + $("#hqCity").val() + ", " + inputState + " " + $("#hqZip").val());
				$( "#dialog-canNotVerify-confirmHQ").dialog({
					resizable: false,
					height:230,
					width:400,
					modal: true,
					buttons: {
						"Use anyway": function() {
							$( this ).dialog( "close" );
							$("#hostCompany").submit();
						},
						"Go back": function() {
							$( this ).dialog( "close" );
						}
					}
				});
			});
		}	
	}
	
	// store state ID's so it can be dynamically changed
	var states = [];
	<cfoutput>
		<cfloop query="qGetStateList">
			states.push({
				key: #id#,
				value: '#state#'
			});
		</cfloop>
	</cfoutput>
	
	// Get the city and state based on the zip code
	var getLocationByZipCode = function(ID) {
		var zipcode = $("#"+ID).val();
		$.getJSON('http://ziptasticapi.com/'+zipcode,function(address) {
			if (!address['error']) {
				city = address['city'];
				state = 0;
				$.each(states, function(k,v) {
					if (v.value == address['state']) {
						state = k;
					}
				});
				if (ID.substring(0,2) == "hq") {
					$("#hqCity").val(city.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();}));
					$("#hqState").val(state);
					$("#hqZip").val(zipcode);
				} else {
					$("#city").val(city.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();}));
					$("#state").val(state);
					$("#zip").val(zipcode);
				}
			} else {
				alert("Please verify your zip code");
			}												  
		});
	}

	// Error handler for the asynchronous functions. 
	var myErrorHandler = function(statusCode, statusMsg) { 
		alert('Status: ' + statusCode + ', ' + statusMsg); 
	}
	
	$().ready(function() {
		var hostCompanyID = $('#hostCompanyID').val();
		var secretaryOfState = $('#authentication_secretaryOfStateExpiration').attr('value');
		var departmentOfLabor = $('#authentication_departmentOfLaborExpiration').val();
		var googleEarth = $('#authentication_googleEarthExpiration').val();
		var workmensCompensation = $('#WCDateExpired').val();
		var incorporation = $('#authentication_incorporationExpiration').val();
		var certificateOfExistence = $('#authentication_certificateOfExistenceExpiration').val();
		var certificateOfReinstatement = $('#authentication_certificateOfReinstatementExpiration').val();
		var departmentOfState = $('#authentication_departmentOfStateExpiration').val();
	   	new AjaxUpload('secretary_of_state_upload', {
			action: '../wat/hostCompany/imageUploadPrint.cfm?option=upload&type=secretaryOfState&hostCompanyID='+hostCompanyID+'&expirationDate='+secretaryOfState,
			name: 'image'
  		});
		new AjaxUpload('department_of_labor_upload', {
			action: '../wat/hostCompany/imageUploadPrint.cfm?option=upload&type=departmentOfLabor&hostCompanyID='+hostCompanyID+'&expirationDate='+departmentOfLabor,
			name: 'image'
 		});
		new AjaxUpload('google_earth_upload', {
			action: '../wat/hostCompany/imageUploadPrint.cfm?option=upload&type=googleEarth&hostCompanyID='+hostCompanyID+'&expirationDate='+googleEarth,
			name: 'image'
  		});
		new AjaxUpload('workmens_compensation_upload', {
			action: '../wat/hostCompany/imageUploadPrint.cfm?option=upload&type=workmensCompensation&hostCompanyID='+hostCompanyID+'&expirationDate='+workmensCompensation,
			name: 'image'
  		});
		new AjaxUpload('incorporation_upload', {
			action: '../wat/hostCompany/imageUploadPrint.cfm?option=upload&type=incorporation&hostCompanyID='+hostCompanyID+'&expirationDate='+incorporation,
			name: 'image'
  		});
		new AjaxUpload('certificate_of_existence_upload', {
			action: '../wat/hostCompany/imageUploadPrint.cfm?option=upload&type=certificateOfExistence&hostCompanyID='+hostCompanyID+'&expirationDate='+certificateOfExistence,
			name: 'image'
  		});
		new AjaxUpload('certificate_of_reinstatement_upload', {
			action: '../wat/hostCompany/imageUploadPrint.cfm?option=upload&type=certificateOfReinstatement&hostCompanyID='+hostCompanyID+'&expirationDate='+certificateOfReinstatement,
			name: 'image'
  		});
		new AjaxUpload('department_of_state_upload', {
			action: '../wat/hostCompany/imageUploadPrint.cfm?option=upload&type=departmentOfState&hostCompanyID='+hostCompanyID+'&expirationDate='+departmentOfState,
			name: 'image'
  		});
		new AjaxUpload('additional_document', {
			action: '../wat/hostCompany/addViewRemoveDocuments.cfm?option=upload&hostCompanyID='+hostCompanyID,
			name: 'fileData',
			onComplete: function() {
				window.location.reload();	
			}
  		});
	});
	
	// Popup to print image that is referenced by the input file type.
	var printAuthenticationFile = function(id) {
		var printURL = document.URL.substring(0, document.URL.indexOf("/index.cfm")) + "/hostcompany/imageUploadPrint.cfm?option=print&fileID="+id;
		window.open(printURL, "File", "width=800, height=600").print();
	}
	
	// Popup to print a document that has been uploaded
	var printDocument = function(id) {
		var printURL = document.URL.substring(0, document.URL.indexOf("/index.cfm")) + "/hostcompany/addViewRemoveDocuments.cfm?option=view&documentID="+id;
		window.open(printURL, "File", "width=800, height=600").print();
	}
	
	// Popup to print all authentication files (will only show pdf files)
	var printMainAuthenticationFiles = function(id1,id2,id3) {
		var hostCompanyID = $('#hostCompanyID').val();
		var printURL = document.URL.substring(0,document.URL.indexOf("/index.cfm")) 
			+ "/hostcompany/imageUploadPrint.cfm?option=printAll&hostCompanyID="+hostCompanyID+"&fileID="+id1+"&fileID2="+id2+"&fileID3="+id3;
		window.open(printURL, "File", "width=800, height=600");
	}
	
	// Popup to print all authentication files, including the additional authentications (will only show pdf files)
	var printAllAuthenticationFiles = function(id1,id2,id3,id4,id5,id6,id7) {
		var hostCompanyID = $('#hostCompanyID').val();
		var printURL = document.URL.substring(0,document.URL.indexOf("/index.cfm")) 
			+ "/hostcompany/imageUploadPrint.cfm?option=printAll&hostCompanyID="+hostCompanyID+"&fileID="+id1+"&fileID2="+id2+"&fileID3="+id3+"&fileID4="+id4+"&fileID5="+id5+"&fileID6="+id6+"&fileID7="+id7;
		window.open(printURL, "File", "width=800, height=600");
	}
	
	// Delete the file that has been uploaded
	var deleteAuthenticationFile = function(id) {
		if (confirm("Are you sure you want to delete this file?")) {
			var deleteURL = document.URL;
			deleteURL = deleteURL.substring(0, deleteURL.indexOf("/index.cfm"));
			deleteURL += "/hostcompany/imageUploadPrint.cfm?option=delete&fileID="+id;
			window.open(deleteURL, id, "width=10, height=10");
		}
	}
	
	// Delete the document that has been uploaded
	var deleteDocument = function(id) {
		if (confirm("Are you sure you want to delete this file?")) {
			var deleteURL = document.URL;
			deleteURL = deleteURL.substring(0, deleteURL.indexOf("/index.cfm"));
			deleteURL += "/hostcompany/addViewRemoveDocuments.cfm?option=delete&documentID="+id;
			window.open(deleteURL, id, "width=10, height=10");
		}
	}
	
	// Function to change hidden input field of dynamic confirmation boxes
	var changeBox = function(program) {
		var currentValue = $("#confirmation_" + program).val();
		currentValue = (currentValue * -1) + 1;
		$("#confirmation_" + program).val(currentValue);
	}
	
	var changeAuthenticationAvailable = function() {
		var currentValue = $("#authentication_businessLicenseNotAvailable").val();
		if (currentValue == 0) {
			$("#authentication_businessLicenseNotAvailable").attr("value", 1);
			$(".additionalAuthentications").removeAttr("style");
			// This is to prevent displaying readOnly fields when changing this option.
			$(".readOnly").css("display","none");
		} else {
			$("#authentication_businessLicenseNotAvailable").attr("value", 0);
			$(".additionalAuthentications").css("display","none");
		}
	}
	
	//open window
	function openWindow(url, width, height) {
		newWindow=window.open(url, "NewWindow", "width=" + width + ",height="+height+", location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes"); 
		if (window.focus) {
			newWindow.focus();
		}
	}
	
	// Shows or hides the new supervisor menu. It should not add one if it is hidden.
	function showHideNewSupervisor() {
		if ($('#addNewSupervisor').val() == 0) {
			$('.newSupervisor').show();
			$("#addNewSupervisor").val(1);
		} else {
			$('.newSupervisor').hide();
			$("#addNewSupervisor").val(0);
		}
	}
	
	function alternateValue(formID) {
		$('#'+formID).val(($('#'+formID).val()-1)*(-1));
	}
	
</script>

<cfoutput>

<!--- Modal Dialogs --->

<!--- Approve Address - Modal Dialog Box --->
<div id="dialog-approveAddress-confirmHQ" title="Do you want to approve this HQ Address?" style="font-size:12px;" class="displayNone"></div>

<!--- Can Not Verify Address - Modal Dialog Box --->
<div id="dialog-canNotVerify-confirmHQ" title="We could not verify the HQ Address." style="font-size:12px;" class="displayNone"></div>
    
<!--- Approve Address - Modal Dialog Box --->
<div id="dialog-approveAddress-confirm" title="Do you want to approve this Work Site Address?" style="font-size:12px;" class="displayNone"></div>

<!--- Can Not Verify Address - Modal Dialog Box --->
<div id="dialog-canNotVerify-confirm" title="We could not verify the Work Site Address." style="font-size:12px;" class="displayNone"></div>

<!--- TABLE HOLDER --->
<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##F4F4F4">
    <tr>
        <td bordercolor="##FFFFFF">

			<!--- TABLE HEADER --->
            <table width="95%" cellpadding="0" cellspacing="0" border="0" align="center" height="25" bgcolor="##E4E4E4">
                <tr bgcolor="##E4E4E4">
                	<td class="title1">&nbsp; &nbsp; Host Company Information</td>
                </tr>
            </table>

			<br />
            
            <table width="800px" align="center" cellpadding="0" cellspacing="0">	
                <tr>
                    <td valign="top">

						<!--- Page Messages --->
                        <gui:displayPageMessages 
                            pageMessages="#SESSION.pageMessages.GetCollection()#"
                            messageType="section"
                            />
                        
                        <!--- Form Errors --->
                        <gui:displayFormErrors 
                            formErrors="#SESSION.formErrors.GetCollection()#"
                            messageType="section"
                            />
                            
					</td>
				</tr>
			</table>
                                                
            <form name="hostCompany" id="hostCompany" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
            <input type="hidden" name="submitted" value="1">
            <input type="hidden" name="hostCompanyID" id="hostCompanyID" value="#VAL(qGetHostCompanyInfo.hostCompanyID)#">
            
            <!--- TOP SECTION --->
            <table width="800px" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##ffffff">	
                <tr>
                    <td valign="top">

                        <!--- HOST COMPANY INFO - READ ONLY --->
                        <table width="100%" align="center" cellpadding="2" class="readOnly">
                            <tr>
                                <td align="center" colspan="2" class="title1"><p>#FORM.name# (###qGetHostCompanyInfo.hostCompanyID#)</td>
                            </tr>
                            <tr>
                                <td width="40%" align="right" class="style1"><strong>Business Type:</strong></td>
                                <td class="style1">#qGetHostCompanyInfo.typebusiness#</td>
                            </tr>
                            <!--- Office View Only ---> 
							<cfif ListFind("1,2,3,4", CLIENT.userType)>
                            <tr>
                                <td align="right" class="style1"><strong>Date of Entry:</strong></td>
                                <td class="style1">#DateFormat(qGetHostCompanyInfo.entrydate, "mm/dd/yyyy")#</td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>Entered by:</strong></td>
                                <td class="style1">#qGetenteredBy.firstname# #qGetenteredBy.lastname#</td>
                            </tr>
                            </cfif>
                        </table>

                        <!--- HOST COMPANY INFO - EDIT PAGE --->
                        <table width="100%" align="center" cellpadding="2" class="editPage">
                            <tr>
                                <td width="40%" align="right" class="style1"><strong>Business Name:</strong> </td>
                                <td><input type="text" id="name" name="name" value="#FORM.name#" class="style1" size="50" maxlength="250"></td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>Business Type:</strong></td>
                                <td>
                                    <select id="business_typeID" name="business_typeID" id="business_typeID" class="style1" onchange="showHideBusinessTypeOther();">
                                        <option value="0"></option>
                                        <option value="Other" <cfif FORM.business_typeID EQ 'Other'>selected="selected"</cfif> >-- Other --</option>
                                        <cfloop query="qGetBusinessType">
                                            <option value="#qGetBusinessType.business_typeID#" <cfif qGetBusinessType.business_typeID EQ FORM.business_typeID>selected="selected"</cfif> >#qGetBusinessType.business_type#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            <tr id="rowBusinessTypeID" class="hiddenField">
                                <td align="right" class="style1"><strong>Specity if Other:</strong> </td>
                                <td>
                                	<input 
                                    	type="text" 
                                        id="businessTypeOther" 
                                        name="businessTypeOther" 
                                        id="businessTypeOther" 
                                        value="#FORM.businessTypeOther#" 
                                        class="style1" 
                                        size="35" 
                                        maxlength="100">
                            	</td>
                            </tr>
                        </table>

                    </td>
                </tr>													
            </table>
            <!--- END OF TOP SECTION --->
            
            <br />                                    

			<!--- INFORMATION SECTION --->
            <table width="800px" border="0" cellpadding="0" cellspacing="0" align="center">	
                <tr>
                    <!--- LEFT SECTION --->
                    <td width="49%" valign="top">

                        <!--- ADDRESS --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                            	&nbsp;:: Work Site Address
                                            
                                                <!--- Google Maps Link --->
                                                <cfif LEN(vGoogleMaps)>
                                                    &nbsp; - &nbsp; <a href="#vGoogleMaps#" class="style2" target="_blank">[ Google Maps ]</a>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Address:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.address#</span>
                                                <input type="text" name="address" id="address" value="#FORM.address#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>City</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.city#</span>
                                                <input type="text" name="city" id="city" value="#FORM.city#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>		
                                        <tr>
                                            <td class="style1" align="right"><strong>State:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetHostCompanyInfo.stateName#</span>
                                                <select name="state" id="state" class="style1 editPage">
                                              		<option value="0"></option>
                                              		<cfloop query="qGetStateList">
		                                                <option value="#qGetStateList.id#" <cfif qGetStateList.id eq FORM.state>selected</cfif>>#qGetStateList.stateName#</option>
        	                                      	</cfloop>
	                                            </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Zip:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.zip#</span>
                                                <input type="text" name="zip" id="zip" value="#FORM.zip#" class="style1 editPage" size="10" maxlength="5" onblur="getLocationByZipCode(this.id);">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table> 
                        
                        <br />

                        <!--- HQ ADDRESS --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">
									
                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: HQ Address</td>
                                        </tr>
                                        <tr class="editPage">
                                        	<td class="style1" align="right"><input type="checkbox" name="copyAddress" id="copyAddress" class="style1 editPage" onclick="jsCopyAddress();" /></td>
                                            <td class="style1"><strong><label for="copyAddress">Same as Main Address</label></strong></td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Address:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.hqAddress#</span>
                                                <input type="text" name="hqAddress" id="hqAddress" value="#FORM.hqAddress#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>City</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.hqCity#</span>
                                                <input type="text" name="hqCity" id="hqCity" value="#FORM.hqCity#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>		
                                        <tr>
                                            <td class="style1" align="right"><strong>State:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetHostCompanyInfo.hqStateName#</span>
                                                <select name="hqState" id="hqState" class="style1 editPage">
                                              		<option value="0"></option>
                                              		<cfloop query="qGetStateList">
		                                                <option value="#qGetStateList.id#" <cfif qGetStateList.id eq FORM.hqState>selected</cfif>>#qGetStateList.stateName#</option>
        	                                      	</cfloop>
	                                            </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Zip:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.hqZip#</span>
                                                <input 
                                                	type="text" 
                                                    name="hqZip" 
                                                    id="hqZip" 
                                                    value="#FORM.hqZip#" 
                                                    class="style1 editPage" 
                                                    size="10" 
                                                    maxlength="5" 
                                                    onblur="getLocationByZipCode(this.id);">
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table> 
                        
                        <br />
                        
                        <!--- JOBS --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="4" class="style2" bgcolor="##8FB6C9">&nbsp;:: Jobs</td>
                                        </tr>
                                        <tr>
                                            <td class="style1"><strong><u>Job Title</u></strong></td>
                                            <td class="style1"><strong><u>SEVIS</u></strong></td>
                                            <td class="style1"><strong><u>Wage</u></strong></td>
                                            <td class="style1"><strong><u>Hours/Week</u></strong></td>
                                        </tr>
                                        <cfloop query="qGetJobs">
                                            <tr bgcolor="###iif(qGetJobs.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                                                <td class="style1">
													<a href="javascript:openWindow('hostcompany/jobInfo.cfm?ID=#id#&hostCompanyID=#qGetHostCompanyInfo.hostCompanyID#', 300, 600);">
	                                                    #qGetJobs.title#
                                                </td>
                                                <td  class="style1">#classification#</td>
                                                <td class="style1">#qGetJobs.wage# / #qGetJobs.wage_type#</td>
                                                <td class="style1">#qGetJobs.hours#</td>
                                                <td class="style1">
                                                    <!--- Office View Only ---> 
                                                    <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                        <a href="javascript:openWindow('hostcompany/jobDelete.cfm?jobID=#qGetJobs.id#', 600, 300);"><img border="0" src="../pics/deletex.gif"/></a>
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </cfloop>
                                        <cfif VAL(qGetHostCompanyInfo.hostCompanyID) AND ListFind("1,2,3,4", CLIENT.userType)>
                                            <tr>
                                                <td colspan="3" align="center">
                                                    <a href="javascript:openWindow('hostcompany/jobInfo.cfm?hostCompanyID=#qGetHostCompanyInfo.hostCompanyID#', 600, 300);" > 
                                                        <img src="../pics/add-job.gif" width="64" height="20" border="0" />
                                                    </a>
                                                </td>
                                            </tr>
                                        </cfif>
                                    </table>

                                </td>
                            </tr>
                        </table> 

                        <br />
                        
                        <!--- HOUSING --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Housing Information</td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Is Housing Provided?</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">
                                                    <cfif ListFind("0,1", FORM.isHousingProvided)>
                                                        #YesNoFormat(VAL(FORM.isHousingProvided))#
                                                    <cfelseif FORM.isHousingProvided EQ 2>
                                                        Other (third party)
                                                    </cfif>
                                                </span>
                                                <input 
                                                	type="radio" 
                                                    name="isHousingProvided" 
                                                    id="isHousingProvidedNo" 
                                                    value="0" 
                                                    class="style1 editPage" onchange="checkHousingOnChange()"
													<cfif FORM.isHousingProvided EQ 0> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isHousingProvidedNo">No</label>
                                                <input 
                                                	type="radio" 
                                                    name="isHousingProvided" 
                                                    id="isHousingProvidedYes" 
                                                    value="1" 
                                                    class="style1 editPage" onchange="checkHousingOnChange()"
													<cfif FORM.isHousingProvided EQ 1> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isHousingProvidedYes">Yes</label>
                                                <input 
                                                type="radio" 
                                                name="isHousingProvided" 
                                                id="isHousingProvidedWillAssist" 
                                                value="2" 
                                                class="style1 editPage"  onchange="checkHousingOnChange()"
												<cfif FORM.isHousingProvided EQ 2> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isHousingProvidedWillAssist">Other (third party)</label>
                                            </td>
                                        </tr>
                                        </table>
                                        
                                        
                                        
                                        <div id="HousingDIV">
                                        <table>
                                        <tr>
                                            <td class="style1" align="right" valign="top"><strong>Type:</strong></td>
                                            <td>
                                            	<table>
                                                	<cfloop query="qGetHousing">
														<cfif qGetHousing.currentrow MOD 2 EQ 1><tr></cfif>
                                                        <td width="20px" class="style1"> 
                                                            <input 
                                                                type="checkbox" 
                                                                name="housing_options" 
                                                                id="housing_options#qGetHousing.id#" 
                                                                value="#qGetHousing.id#" 
                                                                class="formField" 
                                                                disabled 
                                                                <cfif ListFind(FORM.housing_options, qGetHousing.id)>checked</cfif> /> 
                                                        </td>
                                                        <td class="style1"><label for="housing_options#qGetHousing.id#">#qGetHousing.type#</label></td>
                                                        <cfif qGetHousing.currentrow MOD 2 EQ 0></tr></cfif>
                                                    </cfloop>
                                                </table>
                                            </td>
                                      	</tr>
                                        <tr>
                                            <td class="style1" align="right" valign="top"><strong>Provider Name:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.housingProviderName#</span>
                                                <input type="text" name="housingProviderName" id="housingProviderName" value="#FORM.housingProviderName#" class="style1 editPage" size="35" maxlength="100"></td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" valign="top"><strong>Email:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.housingEmail#</span>
                                                <input type="text" name="housingEmail" id="housingEmail" value="#FORM.housingEmail#" class="style1 editPage" size="35" maxlength="100"></td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" valign="top"><strong>Phone:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.housingPhone#</span>
                                                <input type="text" name="housingPhone" id="housingPhone" value="#FORM.housingPhone#" class="style1 editPage phone" size="35" maxlength="100"></td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Address:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.housingAddress#</span>
                                                <input type="text" name="housingAddress" id="housingAddress" value="#FORM.housingAddress#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>City</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.housingCity#</span>
                                                <input type="text" name="housingCity" id="housingCity" value="#FORM.housingCity#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>		
                                        <tr>
                                            <td class="style1" align="right"><strong>State:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetHostCompanyInfo.housingStateName#</span>
                                                <select name="housingState" id="housingState" class="style1 editPage">
                                              		<option value="0"></option>
                                              		<cfloop query="qGetStateList">
		                                                <option value="#qGetStateList.id#" <cfif qGetStateList.id eq FORM.housingState>selected</cfif>>#qGetStateList.stateName#</option>
        	                                      	</cfloop>
	                                            </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Zip:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.housingZip#</span>
                                                <input 
                                                	type="text" 
                                                    name="housingZip" 
                                                    id="housingZip" 
                                                    value="#FORM.housingZip#" 
                                                    class="style1 editPage" 
                                                    size="10" 
                                                    maxlength="5" 
                                                    onblur="getLocationByZipCode(this.id);">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" valign="top"><strong>Housing Instructions:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.housingProvidedInstructions#</span>
                                                <textarea name="housingProvidedInstructions" id="housingProvidedInstructions" class="style1 editPage" cols="35" rows="4">#Trim(FORM.housingProvidedInstructions)#</textarea>
                                            </td>
                                        </tr>
                                        
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Cost/Week:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">
                                                    #DollarFormat(VAL(qGetHostCompanyInfo.housing_cost))#
                                                </span>
                                                <input type="text" name="housing_cost" value="#FORM.housing_cost#" class="style1 editPage" size="35" maxlength="10">
                                            </td>
										</tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Deposit:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">
                                                    #DollarFormat(VAL(qGetHostCompanyInfo.housing_deposit))#
                                                </span>
                                                <input type="text" name="housing_deposit" value="#FORM.housing_deposit#" class="style1 editPage" size="35" maxlength="10">
                                            </td>
										</tr>
                                        </table>
                                        </div>
                                        
                                        

                                </td>
                            </tr>
                        </table> 

                        <br />
                        
                        <!--- PICK UP/ARRIVAL INFORMATION --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                            	&nbsp;:: Arrival Information
                                          		<!--- Office View Only ---> 
												<cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                    <span style="float:right; padding-right:20px;">
                                                        <a href="javascript:openWindow('hostCompany/arrivalInformationPrint.cfm?hostID=#URL.hostCompanyID#',800,600);" class="style2">[ Print ]</a>
                                                    </span>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="37%" class="style1" align="right"><strong>Airport/Station Code:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.arrivalAirport#</span>
                                                <input type="text" name="arrivalAirport" id="arrivalAirport" value="#FORM.arrivalAirport#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="37%" class="style1" align="right"><strong>Airport/Station City:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.arrivalAirportCity#</span>
                                                <input type="text" name="arrivalAirportCity" id="arrivalAirportCity" value="#FORM.arrivalAirportCity#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="37%" class="style1" align="right"><strong>Airport/Station State:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#qGetHostCompanyInfo.arrivalAirportStateName#</span>
                                                <select name="arrivalAirportState" id="arrivalAirportState" class="style1 editPage">
                                              		<option value="0"></option>
                                              		<cfloop query="qGetStateList">
		                                                <option value="#qGetStateList.ID#" <cfif qGetStateList.ID eq FORM.arrivalAirportState>selected</cfif>>#qGetStateList.stateName#</option>
        	                                      	</cfloop>
	                                            </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="37%" class="style1" align="right"><strong>Is pick-up available?</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#YesNoFormat(VAL(FORM.isPickUpProvided))#</span>
                                                <input 
                                                	type="radio" 
                                                    name="isPickUpProvided" 
                                                    id="isPickUpProvidedNo" 
                                                    value="0" 
                                                    class="style1 editPage" 
                                                    onclick="displayPickUpInfo();" 
													<cfif FORM.isPickUpProvided EQ 0> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isPickUpProvidedNo">No</label>
                                                <input 
                                                	type="radio" 
                                                    name="isPickUpProvided" 
                                                    id="isPickUpProvidedYes" 
                                                    value="1" 
                                                    class="style1 editPage" 
                                                    onclick="displayPickUpInfo();" 
													<cfif VAL(FORM.isPickUpProvided)> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isPickUpProvidedYes">Yes</label>
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="37%" class="style1" align="right"><strong>Pick Up Days:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.arrivalPickUpDays#</span>
                                                <textarea name="arrivalPickUpDays" id="arrivalPickUpDays" class="style1 editPage" cols="35" rows="4">#FORM.arrivalPickUpDays#</textarea>
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="37%" class="style1" align="right"><strong>Pick Up Hours:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.arrivalPickUpHours#</span>
                                                <textarea name="arrivalPickUpHours" id="arrivalPickUpHours" class="style1 editPage" cols="35" rows="4">#FORM.arrivalPickUpHours#</textarea>
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="37%" class="style1" align="right"><strong>Cost:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#DollarFormat(VAL(FORM.arrivalPickUpCost))#</span>
                                                <input type="text" name="arrivalPickUpCost" id="arrivalPickUpCost" class="style1 editPage" size="35" maxlength="100" value="#DollarFormat(VAL(FORM.arrivalPickUpCost))#"/>
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td class="style1" align="right" valign="top"><strong>Instructions:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.arrivalInstructions#</span>
                                                <textarea name="arrivalInstructions" id="arrivalInstructions" class="style1 editPage" cols="35" rows="4">#FORM.arrivalInstructions#</textarea>
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="37%" class="style1" align="right"><strong>Contact Name:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.pickUpContactName#</span>
                                                <input type="text" name="pickUpContactName" id="pickUpContactName" value="#FORM.pickUpContactName#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="37%" class="style1" align="right"><strong>Contact Phone:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.pickUpContactPhone#</span>
                                                <input type="text" name="pickUpContactPhone" id="pickUpContactPhone" value="#FORM.pickUpContactPhone#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="37%" class="style1" align="right"><strong>Contact Email:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.pickUpContactEmail#</span>
                                                <input type="text" name="pickUpContactEmail" id="pickUpContactEmail" value="#FORM.pickUpContactEmail#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="37%" class="style1" align="right"><strong>Hours of Contact:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.pickUpContactHours#</span>
                                                <textarea name="pickUpContactHours" id="pickUpContactHours" class="style1 editPage" cols="35" rows="4">#FORM.pickUpContactHours#</textarea>
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="37%" class="style1" align="right"><strong>Notes:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.pickUpNotes#</span>
                                                <textarea name="pickUpNotes" id="pickUpNotes" class="style1 editPage" cols="35" rows="4">#FORM.pickUpNotes#</textarea>
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table>
                        
                        <br />

                	</td>        
					<!--- END OF LEFT SECTION --->
				
					<!--- DIVIDER --->
                    <td width="2%" valign="top">&nbsp;</td>
                	
                    <!--- RIGHT SECTION --->	    
                    <td width="49%" valign="top">

                        <!--- CONTACT INFO --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Contact Information</td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Owner/General Manger:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.owner#</span>
                                                <input type="text" name="owner" id="owner" value="#FORM.owner#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Primary Contact:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.supervisor#</span>
                                                <input type="text" name="supervisor" id="supervisor" value="#FORM.supervisor#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Office Phone:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.phone#</span>
                                                <input type="text" name="phone" id="phone" value="#FORM.phone#" class="style1 editPage" size="20" maxlength="50">
                                                ext.
                                                <span class="readOnly">#FORM.phoneExt#</span>
                                                <input type="text" name="phoneExt" id="phoneExt" value="#FORM.phoneExt#" class="style1 editPage" size="5" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Mobile Phone:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.cellPhone#</span>
                                                <input type="text" name="cellPhone" id="cellPhone" value="#FORM.cellPhone#" class="style1 editPage" size="35" maxlength="50">
                                            </td>
                                        </tr>                                        
                                        <tr>
                                            <td class="style1" align="right"><strong>Fax:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">
                                                	#FORM.fax# &nbsp;
                                                    <a href="javascript:openWindow('hostcompany/fax_cover.cfm?hostCompanyID=#qGetHostCompanyInfo.hostCompanyID#', 600, 800);">
                                                        <img src="../pics/fax-cover.gif" alt="Fax Cover Page" border="0" />
                                                    </a>
                                                </span>
                                                <input type="text" name="fax" id="fax" value="#FORM.fax#" class="style1 editPage" size="35" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Email:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.email#</span>
                                                <input type="text" name="email" id="email" value="#FORM.email#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        
                                        <!--- Supervisor --->
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                                &nbsp;:: Supervisor Information
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1 editPage" align="center" colspan="2">
                                            	<input type="checkbox" name="copyContact" id="copyContact" class="style1 editPage" onclick="jsCopyContact();" />
                                            	<strong class="editPage">Same as Above</strong>
                                          	</td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Supervisor:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.supervisor_name#</span>
                                                <input type="text" name="supervisor_name" id="supervisor_name" value="#FORM.supervisor_name#" class="style1 editPage" size="35" maxlength="100">
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Office Phone:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.supervisor_phone#</span>
                                                <input type="text" name="supervisor_phone" id="supervisor_phone" value="#FORM.supervisor_phone#" class="style1 editPage" size="20" maxlength="100">
                                                ext.
                                                <span class="readOnly">#FORM.supervisor_phoneExt#</span>
                                                <input type="text" name="supervisor_phoneExt" id="supervisor_phoneExt" value="#FORM.supervisor_phoneExt#" class="style1 editPage" size="5" maxlength="10">
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Mobile Phone:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.supervisor_cellPhone#</span>
                                                <input type="text" name="supervisor_cellPhone" id="supervisor_cellPhone" value="#FORM.supervisor_cellPhone#" class="style1 editPage" size="35" maxlength="100">
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Email:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.supervisor_email#</span>
                                                <input type="text" name="supervisor_email" id="supervisor_email" value="#FORM.supervisor_email#" class="style1 editPage" size="35" maxlength="100">
                                            </td>                                            
                                        </tr>
                                        
                                        <!--- Additional Supervisors --->
                                        <cfloop query="qGetAdditionalSupervisors">
                                            <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                                <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                                    &nbsp;:: Additional Supervisor Information
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><strong>Supervisor:&nbsp;</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qGetAdditionalSupervisors.name#</span>
                                                    <input 
                                                    	type="text" 
                                                        name="supervisor_name_#qGetAdditionalSupervisors.ID#"
                                                        value="#qGetAdditionalSupervisors.name#" 
                                                        class="style1 editPage" 
                                                        size="35" 
                                                        maxlength="100">
                                                </td>                                            
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><strong>Office Phone:&nbsp;</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qGetAdditionalSupervisors.officePhone#</span>
                                                    <input 
                                                    	type="text" 
                                                        name="supervisor_phone_#qGetAdditionalSupervisors.ID#" 
                                                        value="#qGetAdditionalSupervisors.officePhone#" 
                                                        class="style1 editPage phone" 
                                                        size="20" 
                                                        maxlength="100">
                                                    ext.
                                                    <span class="readOnly">#qGetAdditionalSupervisors.officePhoneExt#</span>
                                                    <input 
                                                    	type="text" 
                                                        name="supervisor_phoneExt_#qGetAdditionalSupervisors.ID#"
                                                        value="#qGetAdditionalSupervisors.officePhoneExt#" 
                                                        class="style1 editPage" 
                                                        size="5" 
                                                        maxlength="10">
                                                </td>                                            
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><strong>Mobile Phone:&nbsp;</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qGetAdditionalSupervisors.mobilePhone#</span>
                                                    <input 
                                                    	type="text" 
                                                        name="supervisor_cellPhone_#qGetAdditionalSupervisors.ID#"
                                                        value="#qGetAdditionalSupervisors.mobilePhone#" 
                                                        class="style1 editPage phone" 
                                                        size="35" 
                                                        maxlength="100">
                                                </td>                                            
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><strong>Email:&nbsp;</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qGetAdditionalSupervisors.email#</span>
                                                    <input 
                                                    	type="text" 
                                                        name="supervisor_email_#qGetAdditionalSupervisors.ID#"
                                                        value="#qGetAdditionalSupervisors.email#" 
                                                        class="style1 editPage" 
                                                        size="35" 
                                                        maxlength="100">
                                                </td>                                            
                                            </tr>
                                            <tr class="editPage">
                                                <td class="style1" align="right"><strong>Delete:&nbsp;</strong></td>
                                                <td class="style1">
                                                	<input type="hidden" name="supervisor_delete_#qGetAdditionalSupervisors.ID#" id="supervisor_delete_#qGetAdditionalSupervisors.ID#" value="0" />
                                                    <input 
                                                    	type="checkbox" 
                                                        class="style1 editPage" 
                                                        onclick="alternateValue('supervisor_delete_#qGetAdditionalSupervisors.ID#')" />
                                                </td>                                            
                                            </tr>
                                      	</cfloop>
                                        
                                        <!--- Add Additional Supervisor --->
                                        <tr class="editPage">
                                        	<td colspan="2" class="style1" align="center"><a href="##" onclick="showHideNewSupervisor();">[ Add Supervisor ]</a></td>
                                        </tr>
                                        <input type="hidden" name="addNewSupervisor" id="addNewSupervisor" value="#FORM.addNewSupervisor#" />
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF" class="newSupervisor" style="display:none;">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                                &nbsp;:: New Supervisor Information
                                            </td>
                                        </tr>
                                        <tr class="newSupervisor" style="display:none;">
                                            <td class="style1" align="right"><strong>Supervisor:&nbsp;</strong></td>
                                            <td class="style1">
                                                <input type="text" name="new_supervisor_name" id="new_supervisor_name" class="style1 editPage" size="35" maxlength="100">
                                            </td>                                            
                                        </tr>
                                        <tr class="newSupervisor" style="display:none;">
                                            <td class="style1" align="right"><strong>Office Phone:&nbsp;</strong></td>
                                            <td class="style1">
                                                <input type="text" name="new_supervisor_phone" id="new_supervisor_phone"  class="style1 editPage phone" size="20" maxlength="100">
                                                ext.
                                                <input type="text" name="new_supervisor_phoneExt" id="new_supervisor_phoneExt" class="style1 editPage" size="5" maxlength="10">
                                            </td>                                            
                                        </tr>
                                        <tr class="newSupervisor" style="display:none;">
                                            <td class="style1" align="right"><strong>Mobile Phone:&nbsp;</strong></td>
                                            <td class="style1">
                                                <input type="text" name="new_supervisor_cellPhone" id="new_supervisor_cellPhone" class="style1 editPage phone" size="35" maxlength="100">
                                            </td>                                            
                                        </tr>
                                        <tr class="newSupervisor" style="display:none;">
                                            <td class="style1" align="right"><strong>Email:&nbsp;</strong></td>
                                            <td class="style1">
                                                <input type="text" name="new_supervisor_email" id="new_supervisor_email" class="style1 editPage" size="35" maxlength="100">
                                            </td>                                            
                                        </tr>
                                        
                                    </table>

                                </td>
                            </tr>
                        </table> 
                        
                        <br />

                        <!--- Other Information --->
                        <cfif CLIENT.userType NEQ 8>
                        
                            <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td bordercolor="##FFFFFF">
    
                                        <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                            <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                                <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                                	&nbsp;:: Other Information
													<!--- Office View Only ---> 
                                                    <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                        <span style="float:right; padding-right:20px;">
                                                            <a href="javascript:openWindow('hostCompany/hostCompanyInfoHistory.cfm?hostID=#URL.hostCompanyID#',1000,500);" class="style2">[ History ]</a>
                                                        </span>
                                                    </cfif>
                                             	</td>
                                            </tr>
                                            <tr>
                                                <td width="35%" class="style1" align="right"><strong>Person Signing Job Offer:</strong></td>
                                                <td class="style1" bordercolor="##FFFFFF">
                                                    <span class="readOnly">#FORM.personJobOfferName#</span>
                                                    <input type="text" name="personJobOfferName" id="personJobOfferName" value="#FORM.personJobOfferName#" class="style1 editPage" size="35" maxlength="100">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><strong>Title:</strong></td>
                                                <td class="style1" bordercolor="##FFFFFF">
                                                    <span class="readOnly">#FORM.personJobOfferTitle#</span>
                                                    <input type="text" name="personJobOfferTitle" id="personJobOfferTitle" value="#FORM.personJobOfferTitle#" class="style1 editPage" size="35" maxlength="100">
                                                </td>
                                            </tr>
                                            
                                            <!--- Confirmation of Terms --->
                                            <tr>
                                                <td class="style1" colspan="2">
                                                    <table width="100%" cellpadding="3" cellspacing="3" align="center" style="border:1px solid ##C7CFDC; background-color:##F7F7F7;">
                                                        <tr>
                                                            <td colspan="2">
                                                            	<strong style="width:100%">
                                                                	<span style="margin-left:38%">Confirmation Of Terms</span>
                                                                    <span style="float:right">
                                                                    	<a href="javascript:openWindow('hostCompany/confirmationHistory.cfm?hostID=#URL.hostCompanyID#',400,500);" class="style1">[ History ]</a>
                                                                  	</span>
                                                              	</strong>
                                                                <u><p style="text-align:right; margin-right:10px;">Verification Date</p></u>
                                                            </td>
                                                        </tr>
                                                        <cfloop query="qGetActivePrograms">
                                                            <tr>
                                                                <td class="style1" align="right" width="30%"><strong>#programName#:</strong></td>
                                                                <td class="style1" bordercolor="##FFFFFF" width="70%">
                                                                    <table width="100%">
                                                                        <tr>
                                                                        	<td width="30%">
                                                                            	<input type="hidden" value="#VAL(confirmed)#" name="confirmation_#programID#" id="confirmation_#programID#" />
                                                                                <input class="editPage"
                                                                                	type="checkbox"
																					<cfif confirmed EQ 1>checked</cfif>
                                                                                    onchange="changeBox(<cfoutput>#programID#</cfoutput>);" />
                                                                               	<input class="readOnly"
                                                                                	type="checkbox"
                                                                                    disabled="disabled"
																					<cfif confirmed EQ 1>checked</cfif> />
                                                                        	</td>
                                                                  			<td width="70%" align="right">
                                                                            	<table width="100%">
                                                                                	<tr>
                                                                                    	<td width="60%" align="right">
                                                                                        </td>
                                                                                        <td width="40%" align="right">
                                                                                            <span class="editPage">
                                                                                                <input 
                                                                                                    type="text" 
                                                                                                    name="confirmationDate_#programID#" 
                                                                                                    id="confirmationDate_#programID#" 
                                                                                                    value="#DateFormat(confirmedDate,'mm/dd/yyyy')#" 
                                                                                                    class="style1 datePicker editPage" />
                                                                                            </span>
                                                                                            <span class="readOnly">
                                                                                                <cfif LEN(confirmedDate)>
                                                                                                    #DateFormat(confirmedDate,'mm/dd/yyyy')#
                                                                                                </cfif>
                                                                                            </span>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    
                                                                </td>
                                                            </tr>
                                                        </cfloop>
                                                	</table>
                                             	</td>
                                         	</tr>
                                            <!--- End Confirmation of Terms --->
                                            
                                            <!--- J1 Positions --->
                                            <tr>
                                                <td class="style1" colspan="2">
                                                    <table width="100%" cellpadding="3" cellspacing="3" align="center" style="border:1px solid ##C7CFDC; background-color:##F7F7F7;">
                                                        <tr>
                                                            <td colspan="2">
                                                            	<strong style="width:100%">
                                                                	<span style="margin-left:38%">Available J1 Positions</span>
                                                                    <span style="float:right">
                                                                    	<a href="javascript:openWindow('hostCompany/j1History.cfm?hostID=#URL.hostCompanyID#',400,500);" class="style1">[ History ]</a>
                                                                  	</span>
                                                              	</strong>
                                                                <u><p style="text-align:right; margin-right:10px;">Verification Date</p></u>
                                                            </td>
                                                        </tr>
                                                        <cfloop query="qGetActivePrograms">
                                                            <tr>
                                                                <td class="style1" align="right" width="30%"><strong>#programName#:</strong></td>
                                                                <td class="style1" bordercolor="##FFFFFF" width="70%">
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td width="30%">
                                                                                <select name="numberPositions_#programID#" id="numberPositions_#programID#" class="style1 editPage">
                                                                                    <cfloop from="0" to="100" index="j">
                                                                                        <option value="#j#" <cfif numberPositions EQ '#j#'>selected</cfif>>#j#</option>
                                                                                    </cfloop>
                                                                                </select>
                                                                                <span class="readOnly">#numberPositions#</span>
                                                                            </td>
                                                                            <td width="70%" align="right">
                                                                            	<table width="100%">
                                                                                	<tr>
                                                                                    	<td width="60%" align="right">
                                                                                      	</td>
                                                                                        <td width="40%" align="right">
                                                                                            <span class="editPage">
                                                                                                <input type="text"
                                                                                                    name="j1Date_#programID#"
                                                                                                    id="j1Date_#programID#"
                                                                                                    value="#DateFormat(verifiedDate,'mm/dd/yyyy')#"
                                                                                                    class="style1 datePicker editPage" />
                                                                                            </span>
                                                                                            <span class="readOnly">
                                                                                                <cfif LEN(verifiedDate)>
                                                                                                    #DateFormat(verifiedDate,'mm/dd/yyyy')#
                                                                                                </cfif>
                                                                                            </span>
                                                                                     	</td>
                                                                                  	</tr>
                                                                              	</table>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    
                                                                </td>
                                                            </tr>
                                                        </cfloop>
                                                	</table>
                                             	</td>
                                         	</tr>
                                            <!--- End J1 Positions --->
                                            
                                            <!--- Authentications --->
                                            <tr>
                                                <td class="style1" colspan="2">
                                                    <table width="100%" cellpadding="3" cellspacing="3" align="center" style="border:1px solid ##C7CFDC; background-color:##F7F7F7;">
                                                        <tr>
                                                            <td colspan="2">
                                                                <strong style="width:100%">
                                                                	<span style="margin-left:38%">Authentication</span>
                                                                    <span style="float:right">
                                                                    	<a href="javascript:openWindow('hostCompany/authenticationHistory.cfm?hostID=#URL.hostCompanyID#',980,500);" class="style1">[ History ]</a>
                                                                  	</span>
                                                              	</strong>
                                                                <br/>
                                                                <i style="font-size:9px;">These documents normally will expire at the end of the recruitment year.</i>
                                                                <span style="margin-left:37%"><u>Expiration Date</u></span>
                                                                <span style="float:right"><u>File Uploaded</u></span>
                                                            </td>
                                                        </tr>
                                                        <!--- Business License (Secretary of State) --->
                                                        <tr>
                                                            <td class="style1" align="right" width="30%">
                                                            	<label for="authentication_secretaryOfState"><strong>Business License:</strong></label>
                                                                <br />
                                                            	<i>Not Available:</i>
                                                                <input 
                                                                	type="hidden"
                                                                    id="authentication_businessLicenseNotAvailable"
                                                                    name="authentication_businessLicenseNotAvailable"
                                                                    value="#VAL(FORM.authentication_businessLicenseNotAvailable)#" />
                                                                <input
                                                                    id="businessLicenseNotAvailable" 
                                                                    name="businessLicenseNotAvailable" 
                                                                    class="formField" 
                                                                    disabled="disabled"
                                                                    type="checkbox"
                                                                    onclick="changeAuthenticationAvailable()"
                                                                    <cfif VAL(FORM.authentication_businessLicenseNotAvailable)>checked </cfif> />
                                                          	</td>
                                                            <td class="style1" width="70%">
                                                                <input 
                                                                	type="checkbox" 
                                                                    name="authentication_secretaryOfState" 
                                                                    id="authentication_secretaryOfState" 
                                                                    value="1" 
                                                                    class="formField" 
                                                                    disabled 
																	<cfif VAL(FORM.authentication_secretaryOfState)> checked </cfif> />
                                                                <span class="editPage">
                                                                    <input 
                                                                    	type="text" 
                                                                        name="authentication_secretaryOfStateExpiration" 
                                                                        id="authentication_secretaryOfStateExpiration" 
                                                                        value="#DateFormat(authentication_secretaryOfStateExpiration, 'mm/dd/yyyy')#" 
                                                                        class="style1 datePicker editPage" />
                                                                  	<cfif VAL(URL.hostCompanyID)>
																		<cfif VAL(qGetSecretaryOfStateFile.recordCount)>
                                                                        	<a
                                                                                href="##" 
                                                                                class="editPage"
                                                                                onclick="deleteAuthenticationFile('#qGetSecretaryOfStateFile.id#')"
                                                                                style="float:right; cursor:pointer">
                                                                                DELETE
                                                                            </a>
                                                                          	<input type="hidden" id="secretary_of_state_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                       	<cfelse>
                                                                          	<a
                                                                            	href="##" 
                                                                                class="editPage" 
                                                                                value="Upload" 
                                                                                name="secretary_of_state_upload" 
                                                                                id="secretary_of_state_upload" 
                                                                                style="float:right; cursor:pointer">
                                                                          		UPLOAD
                                                                           	</a>
                                                                        </cfif>
                                                                   	<cfelse>
                                                                 		<input type="hidden" id="secretary_of_state_upload"/><!--- This is to prevent errors with ajaxUpload --->  
                                                                  	</cfif>						
                                                                </span>
                                                                <span class="readOnly">
                                                                    <cfif FORM.authentication_secretaryOfStateExpiration NEQ "">
                                                                        <cfif FORM.authentication_secretaryOfStateExpiration LT NOW()>
                                                                            <span style="color:red;">
                                                                            	#DateFormat(FORM.authentication_secretaryOfStateExpiration, "mm/dd/yyyy")#
                                                                           	</span>
                                                                        <cfelse>
                                                                            #DateFormat(FORM.authentication_secretaryOfStateExpiration, "mm/dd/yyyy")#
                                                                        </cfif>
                                                                    </cfif>
                                                                    <span style="float:right;">
																		<cfif VAL(qGetSecretaryOfStateFile.recordCount)>
                                                                            <a 
                                                                                href="##"
                                                                                class="readOnly" 
                                                                                onclick="printAuthenticationFile('#qGetSecretaryOfStateFile.id#')" 
                                                                                style="cursor:pointer;">
                                                                                PRINT
                                                                            </a>
                                                                        <cfelse>
                                                                            <p class="readOnly">NO FILE</p>
                                                                        </cfif>
                                                                    </span>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        
                                                        <!--- Additional authentication (displayed when business license is not available) --->
                                                        <!--- Incorporation --->
                                                        <tr class="additionalAuthentications" <cfif NOT VAL(FORM.authentication_businessLicenseNotAvailable)>style="display:none"</cfif>>
                                                            <td class="style1" align="right"><label for="authentication_incorporation"><strong>Incorporation:</strong></label></td>
                                                           	<td class="style1">
                                                            	<input 
                                                                	type="checkbox" 
                                                                    name="authentication_incorporation" 
                                                                    id="authentication_incorporation" 
                                                                    value="1" 
                                                                    class="formField" 
                                                                    disabled 
																	<cfif VAL(FORM.authentication_incorporation)> checked </cfif> />
                                                             	<span class="editPage">
                                                                    <input 
                                                                    	type="text" 
                                                                        name="authentication_incorporationExpiration" 
                                                                        id="authentication_incorporationExpiration" 
                                                                        value="#DateFormat(authentication_incorporationExpiration, 'mm/dd/yyyy')#" 
                                                                        class="style1 datePicker editPage" />
                                                                  	<cfif VAL(URL.hostCompanyID)>
																		<cfif VAL(qGetIncorporationFile.recordCount)>
                                                                        	<a
                                                                                href="##" 
                                                                                class="editPage"
                                                                                onclick="deleteAuthenticationFile('#qGetIncorporationFile.id#')"
                                                                                style="float:right; cursor:pointer">
                                                                                DELETE
                                                                            </a>
                                                                      		<input type="hidden" id="incorporation_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                        <cfelse>
                                                                          	<a
                                                                            	href="##" 
                                                                                class="editPage" 
                                                                                value="Upload" 
                                                                                name="incorporation_upload" 
                                                                                id="incorporation_upload" 
                                                                                style="float:right; cursor:pointer">
                                                                          		UPLOAD
                                                                           	</a>
                                                                        </cfif>
                                                                   	<cfelse>
                                                                    	<input type="hidden" id="incorporation_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                 	</cfif>									
                                                                </span>
                                                                <span class="readOnly">
                                                                	<cfif FORM.authentication_incorporationExpiration NEQ "">
                                                                  		<span <cfif FORM.authentication_incorporationExpiration LT NOW()>style="color:red;"</cfif>>
                                                                            #DateFormat(FORM.authentication_incorporationExpiration, "mm/dd/yyyy")#
                                                                        </span>
                                                                    </cfif>
                                                                    <span style="float:right;">
																		<cfif VAL(qGetIncorporationFile.recordCount)>
                                                                            <a 
                                                                                href="##"
                                                                                class="readOnly" 
                                                                                onclick="printAuthenticationFile('#qGetIncorporationFile.id#')" 
                                                                                style="cursor:pointer;">
                                                                                PRINT
                                                                            </a>
                                                                        <cfelse>
                                                                            <p class="readOnly">NO FILE</p>
                                                                        </cfif>
                                                                    </span>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <!--- Certificate Of Existence --->
                                                        <tr class="additionalAuthentications" <cfif NOT VAL(FORM.authentication_businessLicenseNotAvailable)>style="display:none"</cfif>>
                                                            <td class="style1" align="right"><label for="authentication_certificateOfExistence"><strong>Certificate of Existence:</strong></label></td>
                                                           	<td class="style1">
                                                            	<input 
                                                                	type="checkbox" 
                                                                    name="authentication_certificateOfExistence" 
                                                                    id="authentication_certificateOfExistence" 
                                                                    value="1" 
                                                                    class="formField" 
                                                                    disabled 
																	<cfif VAL(FORM.authentication_certificateOfExistence)> checked </cfif> />
                                                             	<span class="editPage">
                                                                    <input 
                                                                    	type="text" 
                                                                        name="authentication_certificateOfExistenceExpiration" 
                                                                        id="authentication_certificateOfExistenceExpiration" 
                                                                        value="#DateFormat(authentication_certificateOfExistenceExpiration, 'mm/dd/yyyy')#" 
                                                                        class="style1 datePicker editPage" />
                                                                  	<cfif VAL(URL.hostCompanyID)>
																		<cfif VAL(qGetCertificateOfExistenceFile.recordCount)>
                                                                        	<a
                                                                                href="##" 
                                                                                class="editPage"
                                                                                onclick="deleteAuthenticationFile('#qGetCertificateOfExistenceFile.id#')"
                                                                                style="float:right; cursor:pointer">
                                                                                DELETE
                                                                            </a>
                                                                      		<input type="hidden" id="certificate_of_existence_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                        <cfelse>
                                                                          	<a
                                                                            	href="##" 
                                                                                class="editPage" 
                                                                                value="Upload" 
                                                                                name="certificate_of_existence_upload" 
                                                                                id="certificate_of_existence_upload" 
                                                                                style="float:right; cursor:pointer">
                                                                          		UPLOAD
                                                                           	</a>
                                                                        </cfif>
                                                                   	<cfelse>
                                                                    	<input type="hidden" id="certificate_of_existence_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                 	</cfif>									
                                                                </span>
                                                                <span class="readOnly">
                                                                	<cfif FORM.authentication_certificateOfExistenceExpiration NEQ "">
                                                                  		<span <cfif FORM.authentication_certificateOfExistenceExpiration LT NOW()>style="color:red;"</cfif>>
                                                                            #DateFormat(FORM.authentication_certificateOfExistenceExpiration, "mm/dd/yyyy")#
                                                                        </span>
                                                                    </cfif>
                                                                    <span style="float:right;">
																		<cfif VAL(qGetCertificateOfExistenceFile.recordCount)>
                                                                            <a 
                                                                                href="##"
                                                                                class="readOnly" 
                                                                                onclick="printAuthenticationFile('#qGetCertificateOfExistenceFile.id#')" 
                                                                                style="cursor:pointer;">
                                                                                PRINT
                                                                            </a>
                                                                        <cfelse>
                                                                            <p class="readOnly">NO FILE</p>
                                                                        </cfif>
                                                                    </span>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <!--- Certificate Of Reinstatement --->
                                                        <tr class="additionalAuthentications" <cfif NOT VAL(FORM.authentication_businessLicenseNotAvailable)>style="display:none"</cfif>>
                                                            <td class="style1" align="right"><label for="authentication_certificateOfReinstatement"><strong>Certificate of Reinstatement:</strong></label></td>
                                                           	<td class="style1">
                                                            	<input 
                                                                	type="checkbox" 
                                                                    name="authentication_certificateOfReinstatement" 
                                                                    id="authentication_certificateOfReinstatement" 
                                                                    value="1" 
                                                                    class="formField" 
                                                                    disabled 
																	<cfif VAL(FORM.authentication_certificateOfReinstatement)> checked </cfif> />
                                                             	<span class="editPage">
                                                                    <input 
                                                                    	type="text" 
                                                                        name="authentication_certificateOfReinstatementExpiration" 
                                                                        id="authentication_certificateOfReinstatementExpiration" 
                                                                        value="#DateFormat(authentication_certificateOfReinstatementExpiration, 'mm/dd/yyyy')#" 
                                                                        class="style1 datePicker editPage" />
                                                                  	<cfif VAL(URL.hostCompanyID)>
																		<cfif VAL(qGetCertificateOfReinstatementFile.recordCount)>
                                                                        	<a
                                                                                href="##" 
                                                                                class="editPage"
                                                                                onclick="deleteAuthenticationFile('#qGetCertificateOfReinstatementFile.id#')"
                                                                                style="float:right; cursor:pointer">
                                                                                DELETE
                                                                            </a>
                                                                      		<input type="hidden" id="certificate_of_reinstatement_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                        <cfelse>
                                                                          	<a
                                                                            	href="##" 
                                                                                class="editPage" 
                                                                                value="Upload" 
                                                                                name="certificate_of_reinstatement_upload" 
                                                                                id="certificate_of_reinstatement_upload" 
                                                                                style="float:right; cursor:pointer">
                                                                          		UPLOAD
                                                                           	</a>
                                                                        </cfif>
                                                                   	<cfelse>
                                                                    	<input type="hidden" id="certificate_of_reinstatement_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                 	</cfif>									
                                                                </span>
                                                                <span class="readOnly">
                                                                	<cfif FORM.authentication_certificateOfReinstatementExpiration NEQ "">
                                                                  		<span <cfif FORM.authentication_certificateOfReinstatementExpiration LT NOW()>style="color:red;"</cfif>>
                                                                            #DateFormat(FORM.authentication_certificateOfReinstatementExpiration, "mm/dd/yyyy")#
                                                                        </span>
                                                                    </cfif>
                                                                    <span style="float:right;">
																		<cfif VAL(qGetCertificateOfReinstatementFile.recordCount)>
                                                                            <a 
                                                                                href="##"
                                                                                class="readOnly" 
                                                                                onclick="printAuthenticationFile('#qGetCertificateOfReinstatementFile.id#')" 
                                                                                style="cursor:pointer;">
                                                                                PRINT
                                                                            </a>
                                                                        <cfelse>
                                                                            <p class="readOnly">NO FILE</p>
                                                                        </cfif>
                                                                    </span>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <!--- Department Of State --->
                                                        <tr class="additionalAuthentications" <cfif NOT VAL(FORM.authentication_businessLicenseNotAvailable)>style="display:none"</cfif>>
                                                            <td class="style1" align="right"><label for="authentication_certificateOfReinstatement"><strong>Department of State:</strong></label></td>
                                                           	<td class="style1">
                                                            	<input 
                                                                	type="checkbox" 
                                                                    name="authentication_departmentOfState" 
                                                                    id="authentication_departmentOfState" 
                                                                    value="1" 
                                                                    class="formField" 
                                                                    disabled 
																	<cfif VAL(FORM.authentication_departmentOfState)> checked </cfif> />
                                                             	<span class="editPage">
                                                                    <input 
                                                                    	type="text" 
                                                                        name="authentication_departmentOfStateExpiration" 
                                                                        id="authentication_departmentOfStateExpiration" 
                                                                        value="#DateFormat(authentication_departmentOfStateExpiration, 'mm/dd/yyyy')#" 
                                                                        class="style1 datePicker editPage" />
                                                                  	<cfif VAL(URL.hostCompanyID)>
																		<cfif VAL(qGetDepartmentOfStateFile.recordCount)>
                                                                        	<a
                                                                                href="##" 
                                                                                class="editPage"
                                                                                onclick="deleteAuthenticationFile('#qGetDepartmentOfStateFile.id#')"
                                                                                style="float:right; cursor:pointer">
                                                                                DELETE
                                                                            </a>
                                                                      		<input type="hidden" id="department_of_state_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                        <cfelse>
                                                                          	<a
                                                                            	href="##" 
                                                                                class="editPage" 
                                                                                value="Upload" 
                                                                                name="department_of_state_upload" 
                                                                                id="department_of_state_upload" 
                                                                                style="float:right; cursor:pointer">
                                                                          		UPLOAD
                                                                           	</a>
                                                                        </cfif>
                                                                   	<cfelse>
                                                                    	<input type="hidden" id="department_of_state_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                 	</cfif>									
                                                                </span>
                                                                <span class="readOnly">
                                                                	<cfif FORM.authentication_departmentOfStateExpiration NEQ "">
                                                                  		<span <cfif FORM.authentication_departmentOfStateExpiration LT NOW()>style="color:red;"</cfif>>
                                                                            #DateFormat(FORM.authentication_departmentOfStateExpiration, "mm/dd/yyyy")#
                                                                        </span>
                                                                    </cfif>
                                                                    <span style="float:right;">
																		<cfif VAL(qGetDepartmentOfStateFile.recordCount)>
                                                                            <a 
                                                                                href="##"
                                                                                class="readOnly" 
                                                                                onclick="printAuthenticationFile('#qGetDepartmentOfStateFile.id#')" 
                                                                                style="cursor:pointer;">
                                                                                PRINT
                                                                            </a>
                                                                        <cfelse>
                                                                            <p class="readOnly">NO FILE</p>
                                                                        </cfif>
                                                                    </span>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <!--- End Additional authentication (displayed when business license is not available) --->
                                                                                                      
                                                        <!--- Department of Labor --->
                                                        <tr>
                                                            <td class="style1" align="right"><label for="authentication_departmentOfLabor"><strong>Department of Labor:</strong></label></td>
                                                            <td class="style1">
                                                                <input 
                                                                	type="checkbox" 
                                                                    name="authentication_departmentOfLabor" 
                                                                    id="authentication_departmentOfLabor" 
                                                                    value="1" 
                                                                    class="formField" 
                                                                    disabled 
																	<cfif VAL(FORM.authentication_departmentOfLabor)> checked </cfif> />
                                                      			<span class="editPage">
                                                                    <input 
                                                                    	type="text" 
                                                                        name="authentication_departmentOfLaborExpiration" 
                                                                        id="authentication_departmentOfLaborExpiration" 
                                                                        value="#DateFormat(authentication_departmentOfLaborExpiration, 'mm/dd/yyyy')#" 
                                                                        class="style1 datePicker editPage" />
                                                                  	<cfif VAL(URL.hostCompanyID)>
																		<cfif VAL(qGetDepartmentOfLaborFile.recordCount)>
                                                                        	<a
                                                                                href="##" 
                                                                                class="editPage"
                                                                                onclick="deleteAuthenticationFile('#qGetDepartmentOfLaborFile.id#')"
                                                                                style="float:right; cursor:pointer">
                                                                                DELETE
                                                                            </a>
                                                                      		<input type="hidden" id="department_of_labor_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                        <cfelse>
                                                                          	<a
                                                                            	href="##" 
                                                                                class="editPage" 
                                                                                value="Upload" 
                                                                                name="department_of_labor_upload" 
                                                                                id="department_of_labor_upload" 
                                                                                style="float:right; cursor:pointer">
                                                                          		UPLOAD
                                                                           	</a>
                                                                        </cfif>
                                                                   	<cfelse>
                                                                    	<input type="hidden" id="department_of_labor_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                 	</cfif>									
                                                                </span>
                                                                <span class="readOnly">
                                                                	<cfif FORM.authentication_departmentOfLaborExpiration NEQ "">
                                                                        <cfif FORM.authentication_departmentOfLaborExpiration LT NOW()>
                                                                            <span style="color:red;">
                                                                            	#DateFormat(FORM.authentication_departmentOfLaborExpiration, "mm/dd/yyyy")#
                                                                           	</span>
                                                                        <cfelse>
                                                                            #DateFormat(FORM.authentication_departmentOfLaborExpiration, "mm/dd/yyyy")#
                                                                        </cfif>
                                                                    </cfif>
                                                                    <span style="float:right;">
																		<cfif VAL(qGetDepartmentOfLaborFile.recordCount)>
                                                                            <a 
                                                                                href="##"
                                                                                class="readOnly" 
                                                                                onclick="printAuthenticationFile('#qGetDepartmentOfLaborFile.id#')" 
                                                                                style="cursor:pointer;">
                                                                                PRINT
                                                                            </a>
                                                                        <cfelse>
                                                                            <p class="readOnly">NO FILE</p>
                                                                        </cfif>
                                                                    </span>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <!--- Google Earth --->
                                                        <tr>
                                                            <td class="style1" align="right"><label for="authentication_googleEarth"><strong>Google Earth:</strong></label></td>
                                                            <td class="style1">
                                                                <input 
                                                                	type="checkbox" 
                                                                    name="authentication_googleEarth" 
                                                                    id="authentication_googleEarth" 
                                                                    value="1" 
                                                                    class="formField" 
                                                                    disabled 
																	<cfif VAL(FORM.authentication_googleEarth)> checked </cfif> />
                                                              	<span class="editPage">
                                                                    <input 
                                                                    	type="text" 
                                                                        name="authentication_googleEarthExpiration" 
                                                                        id="authentication_googleEarthExpiration" 
                                                                        value="#DateFormat(authentication_googleEarthExpiration, 'mm/dd/yyyy')#" 
                                                                        class="style1 datePicker editPage" />
                                                                  	<cfif VAL(URL.hostCompanyID)>
																		<cfif VAL(qGetGoogleEarthFile.recordCount)>
                                                                            <a
                                                                                href="##" 
                                                                                class="editPage"
                                                                                onclick="deleteAuthenticationFile('#qGetGoogleEarthFile.id#')"
                                                                                style="float:right; cursor:pointer">
                                                                                DELETE
                                                                            </a>
                                                                           	<input type="hidden" id="google_earth_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                        <cfelse>
                                                                            <a
                                                                            	href="##" 
                                                                                class="editPage" 
                                                                                value="Upload" 
                                                                                name="google_earth_upload" 
                                                                                id="google_earth_upload" 
                                                                                style="float:right; cursor:pointer">
                                                                          		UPLOAD
                                                                           	</a>
                                                                        </cfif>
                                                                   	<cfelse>
                                                                    	<input type="hidden" id="google_earth_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                                 	</cfif>						
                                                                </span>
                                                                <span class="readOnly">
                                                                	<cfif FORM.authentication_googleEarthExpiration NEQ "">
                                                                        <cfif FORM.authentication_googleEarthExpiration LT NOW()>
                                                                            <span style="color:red;">
                                                                            	#DateFormat(FORM.authentication_googleEarthExpiration, "mm/dd/yyyy")#
                                                                           	</span>
                                                                        <cfelse>
                                                                            #DateFormat(FORM.authentication_googleEarthExpiration, "mm/dd/yyyy")#
                                                                        </cfif>
                                                                    </cfif>
                                                                    <span style="float:right;">
																		<cfif VAL(qGetGoogleEarthFile.recordCount)>
                                                                            <a 
                                                                                href="##"
                                                                                class="readOnly" 
                                                                                onclick="printAuthenticationFile('#qGetGoogleEarthFile.id#')" 
                                                                                style="cursor:pointer;">
                                                                                PRINT
                                                                            </a>
                                                                        <cfelse>
                                                                            <p class="readOnly">NO FILE</p>
                                                                        </cfif>
                                                                    </span>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                        	<td colspan="2">
                                                            	<cfif NOT VAL(FORM.authentication_businessLicenseNotAvailable)>
                                                                    <a 
                                                                        href="##" 
                                                                        onclick="printMainAuthenticationFiles(
                                                                            '#VAL(qGetSecretaryOfStateFile.id)#',
                                                                            '#VAL(qGetDepartmentOfLaborFile.id)#',
                                                                            '#VAL(qGetGoogleEarthFile.id)#');" 
                                                                        class="style1" 
                                                                        style="float:right">
                                                                        [PRINT ALL]
                                                                    </a>
                                                              	<cfelse>
                                                                	<a 
                                                                        href="##" 
                                                                        onclick="printAllAuthenticationFiles(
                                                                            '#VAL(qGetSecretaryOfStateFile.id)#',
                                                                            '#VAL(qGetIncorporationFile.id)#',
                                                                            '#VAL(qGetCertificateOfExistenceFile.id)#',
                                                                            '#VAL(qGetCertificateOfReinstatementFile.id)#',
                                                                            '#VAL(qGetDepartmentOfStateFile.id)#',
                                                                            '#VAL(qGetDepartmentOfLaborFile.id)#',
                                                                            '#VAL(qGetGoogleEarthFile.id)#');" 
                                                                        class="style1" 
                                                                        style="float:right">
                                                                        [PRINT ALL]
                                                                    </a>
                                                                </cfif>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                        	<td colspan="2">
                                                            	<i style="font-size:9px; float:right;">Only pdf files will display with print all.</i>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            
                                            <tr>
                                                <td class="style1" align="right"><strong>EIN:</strong></td>
                                                <td class="style1" bordercolor="##FFFFFF">
                                                    <span class="readOnly">#FORM.EIN#</span>
                                                    <input type="text" name="EIN" id="EIN" value="#FORM.EIN#" class="style1 editPage" size="35" maxlength="100">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><strong>Worker's Compensation Certificate:</strong></td>
                                                <td class="style1" bordercolor="##FFFFFF">
                                                    <span class="readOnly">
                                                        <cfif ListFind("0,1", FORM.workmensCompensation)>
                                                            #YesNoFormat(VAL(FORM.workmensCompensation))#
                                                        <cfelseif FORM.workmensCompensation EQ 2>
                                                            N/A
                                                        </cfif>
                                                        <span style="float:right;">
															<cfif VAL(qGetWorkmensCompensationFile.recordCount)>
                                                                <a 
                                                                    href="##"
                                                                    class="readOnly" 
                                                                    onclick="printAuthenticationFile('#qGetWorkmensCompensationFile.id#')" 
                                                                    style="cursor:pointer;">
                                                                    PRINT
                                                                </a>
                                                            <cfelse>
                                                                <span class="readOnly">NO FILE</span>
                                                            </cfif>
                                                            <a href="javascript:openWindow('hostCompany/workmensCompensationHistory.cfm?hostID=#URL.hostCompanyID#',980,500);" class="style1">[ History ]</a>
                                                      	</span>
                                                    </span>
                                                    <select name="workmensCompensation" id="workmensCompensation" class="style1 editPage selfPlacementField"> 
                                                        <option value="" <cfif NOT LEN(FORM.workmensCompensation)>selected</cfif> ></option>
                                                        <option value="0" <cfif FORM.workmensCompensation EQ 0>selected</cfif> >No</option>
                                                        <option value="1" <cfif FORM.workmensCompensation EQ 1>selected</cfif> >Yes</option>                                                    
                                                        <option value="2" <cfif FORM.workmensCompensation EQ 2>selected</cfif> >N/A</option>
                                                    </select>
                                                    <cfif VAL(URL.hostCompanyID)>
														<cfif VAL(qGetWorkmensCompensationFile.recordCount)>
                                                           	<a
                                                                href="##" 
                                                                class="editPage"
                                                                onclick="deleteAuthenticationFile('#qGetWorkmensCompensationFile.id#')"
                                                                style="float:right; cursor:pointer">
                                                                DELETE
                                                            </a>
                                                           	<input type="hidden" id="workmens_compensation_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                        <cfelse>
                                                          	<a
                                                                href="##" 
                                                                class="editPage" 
                                                                value="Upload" 
                                                                name="workmens_compensation_upload" 
                                                                id="workmens_compensation_upload" 
                                                                style="float:right; cursor:pointer">
                                                                UPLOAD
                                                            </a>
                                                        </cfif>
                                                  	<cfelse>
                                                    	<input type="hidden" id="workmens_compensation_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                                 	</cfif>
                                                </td>
                                            </tr>
                                            <tr>
                                            	<td class="style1" align="right"><strong>Carrier Name:</strong></td>
                                                <td class="style1" bordercolor="##FFFFFF">
                                                	<span class="readOnly">
                                                    	#FORM.WC_carrierName#
                                                    </span>
                                                    <input 
                                                        type="text" 
                                                        name="WC_carrierName" 
                                                        id="WC_carrierName" 
                                                        value="#FORM.WC_carrierName#"
                                                        class="style1 editPage selfPlacementField" 
                                                        size="35" 
                                                        maxlength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                            	<td class="style1" align="right"><strong>Carrier Phone:</strong></td>
                                                <td class="style1" bordercolor="##FFFFFF">
                                                	<span class="readOnly">
                                                   		#FORM.WC_carrierPhone#
                                                    </span>
                                                    <input 
                                                        type="text" 
                                                        name="WC_carrierPhone" 
                                                        id="WC_carrierPhone" 
                                                        value="#FORM.WC_carrierPhone#"
                                                        class="style1 editPage selfPlacementField" 
                                                        size="35" 
                                                        maxlength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                            	<td class="style1" align="right"><strong>Policy Number:</strong></td>
                                                <td class="style1" bordercolor="##FFFFFF">
                                                	<span class="readOnly">
                                                    	#FORM.WC_policyNumber#
                                                    </span>
                                                    <input 
                                                        type="text" 
                                                        name="WC_policyNumber" 
                                                        id="WC_policyNumber" 
                                                        value="#FORM.WC_policyNumber#"
                                                        class="style1 editPage selfPlacementField" 
                                                        size="35" 
                                                        maxlength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><strong>WC Expiration Date:</strong></td>
                                                <td class="style1" bordercolor="##FFFFFF">
                                                    <span class="readOnly">
                                                        <cfif IsDate(FORM.WCDateExpired) AND FORM.WCDateExpired GT NOW()>
                                                            #DateFormat(FORM.WCDateExpired, 'mm/dd/yyyy')#
                                                       	<cfelseif IsDate(FORM.WCDateExpired)>
                                                      		<font color="red">Expired</font>
                                                        <cfelse>
                                                            Workmen's compensation is missing.
                                                        </cfif>
                                                    </span>
                                                    <input 
                                                        type="text" 
                                                        name="WCDateExpired" 
                                                        id="WCDateExpired" 
                                                        value="#DateFormat(WCDateExpired, 'mm/dd/yyyy')#"
                                                        class="style1 datePicker editPage selfPlacementField" 
                                                        size="35" 
                                                        maxlength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><strong>Homepage:&nbsp;</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly"><a href="#FORM.homepage#" target="_blank">#FORM.homepage#</a></span>
                                                    <input type="text" name="homepage" value="#FORM.homepage#" class="style1 editPage" size="35" maxlength="100">
                                                </td>                                            
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right" valign="top"><strong>Observations:&nbsp;</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#FORM.observations#</span>
                                                    <textarea name="observations" class="style1 editPage" cols="35" rows="4">#FORM.observations#</textarea>
                                                </td>                                            
                                            </tr> 
                                        </table>
    
                                    </td>
                                </tr>
                            </table> 
                            
                            <br />
                        
							<!--- PROGRAM PARTICIPATION --->
                            <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td>
                                        <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                            <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                                <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Program Participation</td>
                                            </tr>
                                            <cfloop query="qGetProgramParticipation">
                                                <cfquery name="qGetIncidents" datasource="#APPLICATION.DSN.Source#">
                                                    SELECT i.*
                                                    FROM extra_incident_report i
                                                    INNER JOIN extra_candidates c ON c.candidateID = i.candidateID
                                                    INNER JOIN smg_programs p ON p.programID = c.programID
                                                        AND p.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetProgramParticipation.programID#">
                                                    WHERE i.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompanyInfo.hostCompanyID#">
                                                </cfquery>
                                                <cfquery name="qGetIncidentsGrouped" datasource="#APPLICATION.DSN.Source#">
                                                    SELECT i.*
                                                    FROM extra_incident_report i
                                                    INNER JOIN extra_candidates c ON c.candidateID = i.candidateID
                                                    INNER JOIN smg_programs p ON p.programID = c.programID
                                                        AND p.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetProgramParticipation.programID#">
                                                    WHERE i.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompanyInfo.hostCompanyID#">
                                                    GROUP BY i.subject
                                                    ORDER BY i.subject
                                                </cfquery>
                                                <!--- Determines if this host company was a primary, secondary, or both placement types for this program. --->
                                                                                               
                                                <cfquery name="qGetPlacements" datasource="#APPLICATION.DSN.Source#">
                                                    SELECT ecpc.candCompID, c.status, ecpc.isSecondary
                                                    FROM extra_candidate_place_company ecpc
                                                    INNER JOIN extra_candidates c ON c.candidateID = ecpc.candidateID
                                                        AND c.cancel_date IS NULL
                                                    WHERE ecpc.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompanyInfo.hostCompanyID#">
                                                    AND c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetProgramParticipation.programID#">
                                                    AND ecpc.status = 1
                                                </cfquery>
                                                <tr>
                                                    <td class="style1" valign="top">
                                                        <a href="index.cfm?curdoc=reports/students_hired_per_company_wt&hostCompanyID=#qGetHostCompanyInfo.hostCompanyID#&programID=#programID#">#programName#</a>
                                                        <br/>
                                                        
                                                        <cfset placementType = "" />
                                                        <cfset placementActive = 0 />
                                                        <cfset placementInactive = 0 />
                                                        
                                                        <cfloop query="qGetPlacements" >
                                                        	<cfif qGetPlacements.isSecondary EQ 0 AND placementType EQ "" >
                                                        		<cfset placementType = "Primary Placement" />
                                                            <cfelseif qGetPlacements.isSecondary EQ 1 AND placementType EQ "" >
                                                            	<cfset placementType = "Secondary Placement" />
                                                            <cfelseif qGetPlacements.isSecondary EQ 0 AND placementType EQ "Secondary Placement" >
                                                        		<cfset placementType = "Primary/Secondary Placement" />
                                                            <cfelseif qGetPlacements.isSecondary EQ 1 AND placementType EQ "Primary Placement" >
                                                            	<cfset placementType = "Primary/Secondary Placement" />
                                                            </cfif>
                                                            
                                                            <cfif qGetPlacements.status EQ 0 >
                                                            	<cfset placementInactive = placementInactive + 1 />
                                                            <cfelse>
                                                            	<cfset placementActive = placementActive + 1 />
                                                            </cfif>
                                                        </cfloop>
                                                        
                                                        	#placementType# (Active: #placementActive# / Inactive: #placementInactive#)
                                                                                                              
                                                    </td>
                                                    <td class="style1" valign="top">
                                                        <a href="index.cfm?curdoc=reports/incidentReport&hostCompanyID=#qGetHostCompanyInfo.hostCompanyID#&programID=#programID#">
                                                            Incidents: #VAL(qGetIncidents.recordCount)#
                                                        </a>
                                                        <br/>
                                                        <cfloop query="qGetIncidentsGrouped">
                                                            <cfquery name="qGetIncidentsPerSubject" dbtype="query">
                                                                SELECT *
                                                                FROM qGetIncidents
                                                                WHERE subject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetIncidentsGrouped.subject#">
                                                            </cfquery>
                                                            #qGetIncidentsGrouped.subject#: #VAL(qGetIncidentsPerSubject.recordCount)#<br/>
                                                        </cfloop>
                                                    </td>
                                                </tr>
                                            </cfloop>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            
                            <br />
                            
                            <!--- ADDITIONAL DOCUMENTS --->
                            <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td>
                                        <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                            <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                                <td class="style2" bgcolor="##8FB6C9">&nbsp;:: Additional Documents</td>
                                            </tr>
                                            <tr>
                                                <td class="style1" valign="top" align="center">
                                                    <cfif VAL(URL.hostCompanyID)>
                                                        <a href="##" class="editPage" value="Upload" name="additional_document" id="additional_document" style="cursor:pointer">
                                                            UPLOAD NEW FILE
                                                        </a>
                                                    <cfelse>
                                                        <input type="hidden" id="additional_document"/><!--- This is to prevent errors with ajaxUpload --->
                                                    </cfif>
                                                </td>
                                            </tr>
                                            <cfloop query="qGetAdditonalDocuments">
                                                <tr>
                                                    <td class="style1" valign="top" align="left">
                                                        <a href="##" onclick="printDocument('#id#')" style="cursor:pointer;">
                                                            #clientName#
                                                        </a>
                                                        <a href="##" class="editPage" onclick="deleteDocument('#id#')" style="float:right; cursor:pointer">
                                                            DELETE
                                                        </a>
                                                        <input type="hidden" id="additional_document"/><!--- This is to prevent errors with ajaxUpload --->
                                                    </td>
                                                </tr>
                                            </cfloop>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                                            
                            <br />
                            
                            <!--- Vetting --->
                            <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td>
                                        <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                            <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                                <td colspan="3" class="style2" bgcolor="##8FB6C9">&nbsp;:: Vetting</td>
                                            </tr>
                                            <cfset vettingTotal = 0 />
                                            <cfloop query="qGetProgramParticipation">
                                                <tr <cfif vettingTotal GT 0>style="display:none" class="vettingAllSeasons"</cfif>>
                                                    <td class="style1" valign="top">
                                                        #programName#
                                                    </td>
                                                    <td class="style1" valign="top">
                                                    	<form></form>
														<form action="index.cfm?curdoc=reports/hostCompanySelfPlacementConfirmation" method="post" id="hostCompanyReportForm">
															<input type="hidden" name="hostCompanyID" value="#qGetHostCompanyInfo.hostCompanyID#" />
                                                            <input type="hidden" name="programID" value="#programID#" />
															<input type="hidden" name="submitted" value="1" />
                                                        </form>
                                                        <a href="##" onclick="document.getElementById('hostCompanyReportForm').submit(); return false;">Host Company Report</a>
                                                    </td>
                                                    <td class="style1" valign="top">
                                                    	<form action="index.cfm?curdoc=reports/selfPlacementConfirmation" method="post" id="intRepReportForm">
                                                            <input type="hidden" name="programID" value="#programID#" />
															<input type="hidden" name="submitted" value="1" />
                                                        </form>
                                                        <a href="##" onclick="document.getElementById('intRepReportForm').submit(); return false;">Int. Rep. Report</a>
                                                    </td>
                                                </tr>
                                                <cfif vettingTotal EQ 0>
                                                <tr id="btnvettingAllSeasons">
                                                	<td class="style1" valign="top" style="text-align:center" colspan="3"><a href="" onclick="$('.vettingAllSeasons').toggle(); $('##btnvettingAllSeasons').hide();  return false;" >Show All Seasons</a></td>
                                                </tr>
                                                </cfif>
                                                <cfset vettingTotal = vettingTotal + 1 />
                                            </cfloop>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            
                            <br />
                            
                            <!--- Host Company Warning --->
                            <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td>
                                        <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                            <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                                <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Warning</td>
                                            </tr>
                                            <tr>
                                                <td class="style1" valign="top" align="left">
                                                    <span class="readOnly">#YesNoFormat(FORM.warningStatus)#</span>
                                                    <input type="checkbox" name="warningStatus" class="style1 editPage" value="1" <cfif FORM.warningStatus EQ 1>checked="checked"</cfif> />
                                                </td>
                                                <td class="style1" valign="top" align="left">
                                                    <span class="readOnly">#FORM.warningNotes#</span>
                                                    <textarea name="warningNotes" class="style1 editPage" cols="35" rows="4">#FORM.warningNotes#</textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                                            
                            <br />
                            
                    	</cfif>
                        
    				</td>
				</tr>
			</table>                                    
            <!--- END OF INFORMATION SECTION ---> 
            
            <br/>
            
			<!---- EDIT/UPDATE BUTTONS ---->
            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                <table width="800px" border="0" cellpadding="0" cellspacing="0" align="center">	
                    <tr>
                        <td align="center">
                            
                            <!---- EDIT BUTTON ---->
                            <div class="readOnly">  
                                <img src="../pics/delete.gif" onclick="confirmDelete(#qGetHostCompanyInfo.hostCompanyID#);" /> &nbsp; &nbsp;  &nbsp; &nbsp;                          
                                <img src="../pics/edit.gif" onClick="readOnlyEditPage();">
                            </div>
                            
                            <!---- UPDATE BUTTON ----> 
                            <div class="editPage">                            
                                
                                <cfif VAL(qGetHostCompanyInfo.hostCompanyID)>
                                    <img src="../pics/update.gif" style="cursor:pointer" onclick="javascript:verifyAddress();" />
								<cfelse>
                                    <img src="../pics/save.gif" style="cursor:pointer" onclick="javascript:verifyAddress();" />
                                </cfif>                                    
                            </div>
                            
                        </td>
                    </tr>
                </table>
                <br />
            </cfif>
			
            </form>
            
		</td>		
	</tr>
</table>
<!--- END OF TABLE HOLDER --->

</cfoutput>

<script>
function checkHousingOnChange() {
	if ($("input[name=isHousingProvided]:checked").val() == 0) {
		$("#HousingDIV").css("display","none");
	} else {
		$("#HousingDIV").css("display","block");
	}
	$(".readOnly").css("display","none");
}
function checkHousingOnLoad() {
	if ($("input[name=isHousingProvided]:checked").val() == 0) {
		$("#HousingDIV").css("display","none");
	} else {
		$("#HousingDIV").css("display","block");
	}
}



</script>

