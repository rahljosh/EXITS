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
    <cfajaxproxy cfc="extra.extensions.components.udf" jsclassname="UDFComponent">

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
	<!--- Primary Contact --->    
    <cfparam name="FORM.supervisor" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.cellPhone" default="">
    <cfparam name="FORM.fax" default="">
    <cfparam name="FORM.email" default="">
    <!--- Supervisor --->    
    <cfparam name="FORM.supervisor_name" default="">
    <cfparam name="FORM.supervisor_phone" default="">
    <cfparam name="FORM.supervisor_cellPhone" default="">
    <cfparam name="FORM.supervisor_email" default="">
    <!--- Other Information --->    
    <cfparam name="FORM.personJobOfferName" default="">
    <cfparam name="FORM.personJobOfferTitle" default="">
    <cfparam name="FORM.authenticationType" default="">
    <cfparam name="FORM.EIN" default="">
	<cfparam name="FORM.workmensCompensation" default="">
    <cfparam name="FORM.WCDateExpired" default="">
    <cfparam name="FORM.homepage" default="">
    <cfparam name="FORM.observations" default="">
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
    
    <cfscript>
		vGoogleMaps = '';
	</cfscript>
    
    <style type="text/css">
		.displayNone {
			background:red;
		}
	</style>
    
    <cfquery name="qGetHostCompanyInfo" datasource="MySql">
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
            eh.phone, 
            eh.cellPhone,
            eh.fax,
            eh.email,
            eh.supervisor,
            eh.supervisor_name,
            eh.supervisor_phone,
            eh.supervisor_cellPhone, 
            eh.supervisor_email, 
            eh.homepage,
            eh.personJobOfferName,
            eh.personJobOfferTitle,
            eh.authenticationType,
            eh.EIN,
            eh.workmensCompensation,
            eh.WCDateExpired,
            eh.observations,
            eh.housing_options,
            eh.housing_cost,
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
            et.business_type as typeBusiness, 
            s.stateName,  
            workSiteS.stateName as hqStateName,
            airportS.stateName as arrivalAirportStateName            
        FROM 
        	extra_hostcompany eh
        LEFT OUTER JOIN 
        	smg_states s ON eh.state = s.ID
        LEFT OUTER JOIN 
        	smg_states workSiteS ON eh.hqState = workSiteS.ID
        LEFT OUTER JOIN 
        	smg_states airportS ON eh.arrivalAirportState = airportS.ID
        LEFT OUTER JOIN 
        	extra_typebusiness et ON et.business_typeID = eh.business_typeID
        WHERE 
        	eh.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostCompanyID#">
    </cfquery>
	
    <cfquery name="qGetenteredBy" datasource="MySql">
        SELECT 
        	firstname, 
            lastname
        FROM 
        	smg_users
        WHERE
        	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostCompanyInfo.enteredBy)#"> 
    </cfquery>
    
    <cfquery name="qGetJobs" datasource="MySql">
        SELECT 
        	ej.id, 
            ej.title, 
            ej.hours,
            ej.description,
            ej.wage, 
            ej.wage_type
        FROM 
        	extra_jobs ej
        WHERE 
        	ej.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostCompanyInfo.hostCompanyID)#"> 
    </cfquery> 
    
    <cfquery name="qGetHousing" datasource="MySql">
        SELECT 
        	ID,
            type
        FROM 
        	extra_housing	
        WHERE	
        	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">	
        ORDER BY
        	type					
    </cfquery>

    <cfquery name="qGetBusinessType" datasource="MySql">
        SELECT 
        	business_typeID, 
            business_type
        FROM 
        	extra_typebusiness
		ORDER BY
        	business_type            
    </cfquery>

    <cfquery name="qGetStateList" datasource="MySql">
        SELECT 
        	id, 
            state, 
            stateName
        FROM 
        	smg_states
      	ORDER BY
        	stateName
    </cfquery>

    <cfquery name="qGetWorkSiteState" dbtype="query">
        SELECT 
        	id, 
            state, 
            stateName
        FROM 
        	qGetStateList
      	WHERE
        	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostCompanyInfo.state)#">
    </cfquery>

    
    <!--- FORM Submitted --->
    <cfif FORM.submitted>
    
        <cfquery name="qCheckForDuplicates" datasource="MySql">
            SELECT 
                hostCompanyID, 
                name
            FROM 
                extra_hostcompany
            WHERE
                name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.name#">
			AND
            	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">                
            <cfif VAL(FORM.hostCompanyID)>
                AND
                    hostCompanyID != <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hostCompanyID#">
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
            
            <cfquery name="qCheckBusinessType" datasource="MySql">
                SELECT
                    business_typeID,
                    business_type 
                FROM
                    extra_typebusiness
                WHERE
                    business_type LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.businessTypeOther#">
            </cfquery>
                                
            <!--- Found a match for business type --->
            <cfif qCheckBusinessType.recordCount>
            
                <cfscript>
                    // Set New Business Type
                    FORM.business_typeID = qCheckBusinessType.business_typeID;
                </cfscript>
            
            <cfelse>
            
                <cfquery result="newBusinessType" datasource="MySql">
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
                <cfquery datasource="MySql">
                    UPDATE 
                        extra_hostcompany 
                    SET 
                        name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.name#">,
                        business_typeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.business_typeID#">,
                        <!--- Work Site Address --->
                        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        state = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.state#">,
                        zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        <!--- HQ Address --->
                        hqAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hqAddress#">,
                        hqCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hqCity#">,
                        hqState = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hqState#">,
                        hqZip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hqZip#">,
                        <!--- Housing Information --->
                        isHousingProvided = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#FORM.isHousingProvided#">,
                        housingProvidedInstructions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housingProvidedInstructions#">,
                        housing_options = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housing_options#">,
                        housing_cost = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.housing_cost)#">,
                        <!--- Contact --->
                        supervisor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor#">,
                        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        cellPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cellPhone#">,
                        fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <!--- Supervisor --->
                        supervisor_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_name#">,
                        supervisor_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_phone#">,
                        supervisor_cellPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_cellPhone#">,
                        supervisor_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_email#">,
                        <!--- Other Information --->
                        personJobOfferName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferName#">,
                        personJobOfferTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferTitle#">,
                        authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.authenticationType#">,
                        EIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.EIN#">,
                        workmensCompensation = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.workmensCompensation#" null="#NOT IsNumeric(FORM.workmensCompensation)#">,
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
                        pickUpContactHours = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pickUpContactHours#">
                    WHERE
                        hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">
                </cfquery>
                
            <cfelse>

				<!--- Insert Host Company --->                  
                <cfquery result="newRecord" datasource="MySql">
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
                        <!--- Contact --->
                        supervisor,
                        phone,
                        cellPhone,
                        fax,
                        email,
                        <!--- Supervisor --->
                        supervisor_name,
                        supervisor_phone,
                        supervisor_cellPhone,
                        supervisor_email,
                        <!--- Other Information --->
                        personJobOfferName,
                        personJobOfferTitle,
                        authenticationType,
                        EIN,
                        workmensCompensation,
                        WCDateExpired,
                        homepage,
                        observations,
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
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.state#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        <!--- HQ Address --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hqAddress#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hqCity#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hqState#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hqZip#">,
						<!--- Housing Information --->
                        <cfqueryparam cfsqltype="cf_sql_tinyint" value="#FORM.isHousingProvided#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housingProvidedInstructions#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housing_options#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.housing_cost)#">,
                        <!--- Contact --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cellPhone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <!--- Supervisor --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_cellPhone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_email#">,
						<!--- Other Information --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personJobOfferTitle#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.authenticationType#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.EIN#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.workmensCompensation#" null="#NOT IsNumeric(FORM.workmensCompensation)#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.WCDateExpired#" null="#NOT IsDate(FORM.WCDateExpired)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homepage#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.observations#">,
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
                        <!--- Record Information --->
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                    )
                </cfquery>
                
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
			// Primary Contact
			FORM.supervisor = qGetHostCompanyInfo.supervisor;
			FORM.phone = qGetHostCompanyInfo.phone;
			FORM.cellPhone = qGetHostCompanyInfo.cellPhone;
			FORM.fax = qGetHostCompanyInfo.fax;
			FORM.email = qGetHostCompanyInfo.email;
			// Supervisor
			FORM.supervisor_name = qGetHostCompanyInfo.supervisor_name;
			FORM.supervisor_phone = qGetHostCompanyInfo.supervisor_phone;
			FORM.supervisor_cellPhone = qGetHostCompanyInfo.supervisor_cellPhone;
			FORM.supervisor_email = qGetHostCompanyInfo.supervisor_email;
			// Other Information
			FORM.personJobOfferName = qGetHostCompanyInfo.personJobOfferName;
			FORM.personJobOfferTitle = qGetHostCompanyInfo.personJobOfferTitle;
			FORM.authenticationType = qGetHostCompanyInfo.authenticationType;
			FORM.EIN = qGetHostCompanyInfo.EIN;
			FORM.workmensCompensation = qGetHostCompanyInfo.workmensCompensation;
			FORM.WCDateExpired = qGetHostCompanyInfo.WCDateExpired;
			FORM.homepage = qGetHostCompanyInfo.homepage;
			FORM.observations = qGetHostCompanyInfo.observations;
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

<script language="JavaScript"> 
	$(document).ready(function() {
		// $(".formField").attr("disabled","disabled");
		
		showHideBusinessTypeOther();
		displayPickUpInfo();
		
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
			var address = $("#address").val();
			var city = $("#city").val();
			var state = $("#state").val();
			var zip = $("#zip").val();
			
			// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
			udf.setCallbackHandler(checkAddress); 
			udf.setErrorHandler(myErrorHandler);
			udf.addressLookup(address,city,state,zip,"232");
		}
	} 

	// Callback function to handle the results returned by the getHostLeadList function and populate the table. 
	var checkAddress = function(googleResponse) { 
	
		var isAddressVerified = googleResponse.ISVERIFIED;
	
		if ( isAddressVerified == 1 ) {
		
			// Get Data Back	
			var streetAddress = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('ADDRESS')]
			var city = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('CITY')]
			var state = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('STATE')]
			var zip = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('ZIP')]
			var inputState = googleResponse.INPUTSTATE;
			var verifiedStateID = googleResponse.VERIFIEDSTATEID;
			
			if ((streetAddress == $("#address").val()) && (city == $("#city").val()) && (state == inputState) && (zip == $("#zip").val()))
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
						height:200,
						width:360,
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
				$( "#dialog-canNotVerify-confirm" ).append("We could not verify the following address:<br />" + $("#address").val() + "<br />" + $("#city").val() + ", " + $("#state").val() + " " + $("#zip").val());
				$( "#dialog-canNotVerify-confirm").dialog({
					resizable: false,
					height:200,
					width:360,
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
		var hqAddress = $("#hqAddress").val();
		var hqCity = $("#hqCity").val();
		var hqState = $("#hqState").val();
		var hqZip = $("#hqZip").val();
		
		udf.setCallbackHandler(checkHQAddress); 
		udf.setErrorHandler(myErrorHandler);
		udf.addressLookup(hqAddress,hqCity,hqState,hqZip,"232");
	}
	
	// Callback function to handle the results returned by the getHostLeadList function and populate the table. 
	var checkHQAddress = function(googleResponse) { 

		var isAddressVerified = googleResponse.ISVERIFIED;

		if ( isAddressVerified == 1 ) {
		
			// Get Data Back	
			var streetAddress = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('ADDRESS')]
			var hqCity = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('CITY')]
			var hqState = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('STATE')]
			var hqZip = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('ZIP')]
			var inputState = googleResponse.INPUTSTATE;
			var verifiedStateID = googleResponse.VERIFIEDSTATEID;
				
			if ((streetAddress == $("#hqAddress").val()) && (hqCity == $("#city").val()) && (hqState == inputState) && (hqZip == $("#zip").val()))
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
						height:200,
						width:360,
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
				$( "#dialog-canNotVerify-confirmHQ" ).append("We could not verify the following address:<br />" + $("#hqAddress").val() + "<br />" + $("#hqCity").val() + ", " + $("#hqState").val() + " " + $("#hqZip").val());
				$( "#dialog-canNotVerify-confirmHQ").dialog({
					resizable: false,
					height:200,
					width:360,
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
	
	// Use an asynchronous call to get the city and state from the zip code. The function is called when the user inputs a zip. 
	var getLocationByZipWorkSite = function(fieldid) { 
		
		// FORM Variables
		var zip = $("#" + fieldid).val();

		if (zip.length == 5) {
			// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
			udf.setCallbackHandler(checkZipWorkSite); 
			udf.setErrorHandler(myErrorHandler); 
			udf.zipCodeLookUp(zip);
		} else {
			alert("Please verify your zip code");
		}
	} 
	
	var checkZipWorkSite = function(googleResponse) { 

		var isAddressVerified = googleResponse.ISVERIFIED;

		if ( isAddressVerified == 1 ) {
		
			// Get Data Back	
			var city = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('CITY')]
			var state = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('STATE')]
			var zip = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('ZIP')]
			
			$("#city").val(city);
			$("#state").val(state);
			$("#zip").val(zip);
			
			$("#trZipLookUp").fadeOut();
		} else {
			alert("Please verify your zip code");
		}

	}
	
	// Use an asynchronous call to get the city and state from the zip code. The function is called when the user inputs a zip. 
	var getLocationByZipHQ = function(fieldid) { 
		
		// FORM Variables
		var zip = $("#" + fieldid).val();

		if (zip.length == 5) {
			// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
			udf.setCallbackHandler(checkZipHQ); 
			udf.setErrorHandler(myErrorHandler); 
			udf.zipCodeLookUp(zip);
		} else {
			alert("Please verify your zip code");
		}
	} 
	
	var checkZipHQ = function(googleResponse) { 

		var isAddressVerified = googleResponse.ISVERIFIED;

		if ( isAddressVerified == 1 ) {
		
			// Get Data Back	
			var city = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('CITY')]
			var state = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('STATE')]
			var zip = googleResponse.QUERY.DATA[0][googleResponse.QUERY.COLUMNS.findIdx('ZIP')]
			
			$("#hqCity").val(city);
			$("#hqState").val(state);
			$("#hqZip").val(zip);
			
			$("#trZipLookUpHQ").fadeOut();
		} else {
			alert("Please verify your zip code");
		}

	}

	// Error handler for the asynchronous functions. 
	var myErrorHandler = function(statusCode, statusMsg) { 
		alert('Status: ' + statusCode + ', ' + statusMsg); 
	}
	
</script>

<cfoutput>

<!--- Modal Dialogs --->

<!--- Approve Address - Modal Dialog Box --->
<div id="dialog-approveAddress-confirmHQ" title="Do you want to approve this HQ Address?" style="font-size:12px;" class="displayNone"> 
</div>
<!--- Can Not Verify Address - Modal Dialog Box --->
<div id="dialog-canNotVerify-confirmHQ" title="We could not verify the HQ Address." style="font-size:12px;" class="displayNone">
</div>
    
<!--- Approve Address - Modal Dialog Box --->
<div id="dialog-approveAddress-confirm" title="Do you want to approve this Work Site Address?" style="font-size:12px;" class="displayNone">
</div>
<!--- Can Not Verify Address - Modal Dialog Box --->
<div id="dialog-canNotVerify-confirm" title="We could not verify the Work Site Address." style="font-size:12px;" class="displayNone">
</div>

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
                            <tr>
                                <td align="right" class="style1"><strong>Date of Entry:</strong></td>
                                <td class="style1">#DateFormat(qGetHostCompanyInfo.entrydate, "mm/dd/yyyy")#</td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>Entered by:</strong></td>
                                <td class="style1">#qGetenteredBy.firstname# #qGetenteredBy.lastname#</td>
                            </tr>
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
                                <td><input type="text" id="businessTypeOther" name="businessTypeOther" id="businessTypeOther" value="#FORM.businessTypeOther#" class="style1" size="35" maxlength="100"></td>
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
                                        <cfif #hostCompanyID# EQ 0 >
                                            <tr id="trZipLookUp">
                                                <td class="style1" align="right"><strong>Input your zip code:</strong></td>
                                                <td class="style1"><input type="text" name="zipLookup" id="zipLookup" size="10" maxlength="5" class="style1 editPage" onBlur="getLocationByZipWorkSite(this.id);"></td>											
                                            </tr>
                                        </cfif>
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
                                                <input type="text" name="zip" id="zip" value="#FORM.zip#" class="style1 editPage" size="10" maxlength="5" onblur="getLocationByZipWorkSite(this.id);">
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
                                        <cfif #hostCompanyID# EQ 0 >
                                            <tr id="trZipLookUpHQ">
                                                <td class="style1" align="right"><strong>Input your zip code:</strong></td>
                                                <td class="style1"><input type="text" name="zipLookup" id="zipLookupHQ" size="10" maxlength="5" class="style1 editPage" onBlur="getLocationByZipHQ(this.id);"></td>											
                                            </tr>
                                        </cfif>
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
                                                <input type="text" name="hqZip" id="hqZip" value="#FORM.hqZip#" class="style1 editPage" size="10" maxlength="5" onblur="getLocationByZipHQ(this.id);">
                                            </td>
                                        </tr>
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
                                                        Will assist in finding
                                                    </cfif>
                                                </span>
                                                <input type="radio" name="isHousingProvided" id="isHousingProvidedNo" value="0" class="style1 editPage" <cfif FORM.isHousingProvided EQ 0> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isHousingProvidedNo">No</label>
                                                <input type="radio" name="isHousingProvided" id="isHousingProvidedYes" value="1" class="style1 editPage" <cfif FORM.isHousingProvided EQ 1> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isHousingProvidedYes">Yes</label>
                                                <input type="radio" name="isHousingProvided" id="isHousingProvidedWillAssist" value="2" class="style1 editPage" <cfif FORM.isHousingProvided EQ 2> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isHousingProvidedWillAssist">Will assist in finding</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" valign="top"><strong>Housing Instructions:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.housingProvidedInstructions#</span>
                                                <textarea name="housingProvidedInstructions" id="housingProvidedInstructions" class="style1 editPage" cols="35" rows="4">#FORM.housingProvidedInstructions#</textarea>
                                            </td>
                                        </tr>
									</table>
                        
                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <cfloop query="qGetHousing">
                                            <cfif qGetHousing.currentrow MOD 2 EQ 1><tr></cfif>
                                            <td width="20px" class="style1"> 
                                                <input type="checkbox" name="housing_options" id="housing_options#qGetHousing.id#" value="#qGetHousing.id#" class="formField" disabled <cfif ListFind(FORM.housing_options, qGetHousing.id)>checked</cfif> > 
                                            </td>
                                            <td class="style1"><label for="housing_options#qGetHousing.id#">#qGetHousing.type#</label></td>
											<cfif qGetHousing.currentrow MOD 2 EQ 0></tr></cfif>
                                        </cfloop>                                         
                                    </table>

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Cost/Week:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">
                                                    #DollarFormat(VAL(qGetHostCompanyInfo.housing_cost))#
                                                </span>
                                                <input type="text" name="housing_cost" value="#FORM.housing_cost#" class="style1 editPage" size="35" maxlength="10">
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
                                                <input type="text" name="phone" id="phone" value="#FORM.phone#" class="style1 editPage" size="35" maxlength="50">
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
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Supervisor Information</td>
                                        </tr>
                                        <tr class="editPage">
                                        	<td class="style1" align="right"><input type="checkbox" name="copyContact" id="copyContact" class="style1 editPage" onclick="jsCopyContact();" /></td>
                                            <td class="style1"><strong><label for="copyContact">Same as Above</label></strong></td>
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
                                                <input type="text" name="supervisor_phone" id="supervisor_phone" value="#FORM.supervisor_phone#" class="style1 editPage" size="35" maxlength="100">
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Cell Phone:&nbsp;</strong></td>
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
                                    </table>

                                </td>
                            </tr>
                        </table> 
                        
                        <br />

                        <!--- Other Information --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Other Information</td>
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
                                        <tr>
                                            <td class="style1" align="right"><strong>Authentication:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.authenticationType#</span>
                                                <select name="authenticationType" id="authenticationType" class="style1 editPage"> 
                                                    <option value="" <cfif NOT LEN(FORM.authenticationType)>selected</cfif> ></option>
                                                    <option value="Secretary of State website" <cfif FORM.authenticationType EQ 'Secretary of State website'>selected</cfif> >Secretary of State website</option>
                                                    <option value="US Department of Labor website" <cfif FORM.authenticationType EQ 'US Department of Labor website'>selected</cfif> >US Department of Labor website</option>
                                                    <option value="Google Earth" <cfif FORM.authenticationType EQ 'Google Earth'>selected</cfif> >Google Earth</option>
                                                </select>
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
                                            <td class="style1" align="right"><strong>Workmen's Compensation:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">
                                                    <cfif ListFind("0,1", FORM.workmensCompensation)>
                                                        #YesNoFormat(VAL(FORM.workmensCompensation))#
                                                    <cfelseif FORM.workmensCompensation EQ 2>
                                                        N/A
                                                    </cfif>
                                                </span>
                                                <select name="workmensCompensation" id="workmensCompensation" class="style1 editPage selfPlacementField"> 
                                                    <option value="" <cfif NOT LEN(FORM.workmensCompensation)>selected</cfif> ></option>
                                                    <option value="0" <cfif FORM.workmensCompensation EQ 0>selected</cfif> >No</option>
                                                    <option value="1" <cfif FORM.workmensCompensation EQ 1>selected</cfif> >Yes</option>                                                    
                                                    <option value="2" <cfif FORM.workmensCompensation EQ 2>selected</cfif> >N/A</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><strong>WC Expiration Date:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">
                                                	<cfif IsDate(FORM.WCDateExpired) AND FORM.WCDateExpired GT NOW()>
                                                    	#DateFormat(FORM.WCDateExpired, 'mm/dd/yyyy')#
                                                  	<cfelse>
                                                    	Workmen's compensation is missing.
                                                 	</cfif>
                                             	</span>
                                                	<input type="text" name="WCDateExpired" id="WCDateExpired" value="#DateFormat(WCDateExpired, 'mm/dd/yyyy')#" class="style1 datePicker editPage selfPlacementField" size="35" maxlength="100">
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

						<!--- JOBS --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="3" class="style2" bgcolor="##8FB6C9">&nbsp;:: Jobs</td>
                                        </tr>
                                        <tr>
                                            <td class="style1"><strong><u>Job Title</u></strong></td>
                                            <td class="style1"><strong><u>Wage</u></strong></td>
                                            <td class="style1"><strong><u>Hours/Week</u></strong></td>
                                        </tr>
                                        <cfloop query="qGetJobs">
                                            <tr bgcolor="###iif(qGetJobs.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                                                <td class="style1">
                                                	<a href="javascript:openWindow('hostcompany/jobInfo.cfm?ID=#id#&hostCompanyID=#qGetHostCompanyInfo.hostCompanyID#', 300, 600);">
	                                                    #qGetJobs.title#
                                                    </a>
                                                </td>
                                                <td class="style1">#qGetJobs.wage# / #qGetJobs.wage_type#</td>
                                                <td class="style1">#qGetJobs.hours#</td>
                                            </tr>
                                        </cfloop>
                                        <cfif VAL(qGetHostCompanyInfo.hostCompanyID) AND ListFind("1,2,3,4", CLIENT.userType)>
                                            <tr>
                                                <td colspan="3" align="center">
                                                    <a href="javascript:openWindow('hostcompany/jobInfo.cfm?hostCompanyID=#qGetHostCompanyInfo.hostCompanyID#', 300, 600);" > 
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

                        <!--- PICK UP/ARRIVAL INFORMATION --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Arrival Information</td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Aiport/Station Code:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.arrivalAirport#</span>
                                                <input type="text" name="arrivalAirport" id="arrivalAirport" value="#FORM.arrivalAirport#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Aiport/Station City:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.arrivalAirportCity#</span>
                                                <input type="text" name="arrivalAirportCity" id="arrivalAirportCity" value="#FORM.arrivalAirportCity#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Aiport/Station State:</strong></td>
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
                                            <td width="35%" class="style1" align="right"><strong>Is pick-up available?</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#YesNoFormat(VAL(FORM.isPickUpProvided))#</span>
                                                <input type="radio" name="isPickUpProvided" id="isPickUpProvidedNo" value="0" class="style1 editPage" onclick="displayPickUpInfo();" <cfif FORM.isPickUpProvided EQ 0> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isPickUpProvidedNo">No</label>
                                                <input type="radio" name="isPickUpProvided" id="isPickUpProvidedYes" value="1" class="style1 editPage" onclick="displayPickUpInfo();" <cfif VAL(FORM.isPickUpProvided)> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isPickUpProvidedYes">Yes</label>
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="35%" class="style1" align="right"><strong>Pick Up Hours:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.arrivalPickUpHours#</span>
                                                <textarea name="arrivalPickUpHours" id="arrivalPickUpHours" class="style1 editPage" cols="35" rows="4">#FORM.arrivalPickUpHours#</textarea>
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
                                            <td width="35%" class="style1" align="right"><strong>Contact Name:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.pickUpContactName#</span>
                                                <input type="text" name="pickUpContactName" id="pickUpContactName" value="#FORM.pickUpContactName#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="35%" class="style1" align="right"><strong>Contact Phone:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.pickUpContactPhone#</span>
                                                <input type="text" name="pickUpContactPhone" id="pickUpContactPhone" value="#FORM.pickUpContactPhone#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="35%" class="style1" align="right"><strong>Contact Email:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.pickUpContactEmail#</span>
                                                <input type="text" name="pickUpContactEmail" id="pickUpContactEmail" value="#FORM.pickUpContactEmail#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr class="hiddenField pickUpInfo">
                                            <td width="35%" class="style1" align="right"><strong>Hours of Contact:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.pickUpContactHours#</span>
                                                <textarea name="pickUpContactHours" id="pickUpContactHours" class="style1 editPage" cols="35" rows="4">#FORM.pickUpContactHours#</textarea>
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table> 
						
                        <br />
                        
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