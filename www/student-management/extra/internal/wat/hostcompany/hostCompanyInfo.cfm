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

    <!--- Param variables --->
    <cfparam name="URL.hostCompanyID" default="0">
	<!--- FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.hostCompanyID" default="0">
    <cfparam name="FORM.name" default="">
    <cfparam name="FORM.business_typeID" default="">
    <cfparam name="FORM.businessTypeOther" default="">
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.workSiteAddress" default="">
    <cfparam name="FORM.workSiteCity" default="">
    <cfparam name="FORM.workSiteState" default="">
    <cfparam name="FORM.workSiteZip" default="">
    <cfparam name="FORM.housing_options" default="">
    <cfparam name="FORM.housing_cost" default="">
	<!--- Arrival Information --->    
    <cfparam name="FORM.isHousingProvided" default="0">
    <cfparam name="FORM.housingProvidedInstructions" default="">
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
	<!--- Supervisor --->    
    <cfparam name="FORM.supervisor" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.fax" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.supervisor_name" default="">
    <cfparam name="FORM.supervisor_phone" default="">
    <cfparam name="FORM.supervisor_email" default="">
    <cfparam name="FORM.EIN" default="">
    <cfparam name="FORM.homepage" default="">
    <cfparam name="FORM.observations" default="">
    
    <cfquery name="qGetHostCompanyInfo" datasource="MySql">
        SELECT 
        	eh.hostCompanyID,
            eh.business_typeID, 
            eh.name,
            eh.address,
            eh.city, 
            eh.state,
            eh.zip,
            eh.workSiteAddress,
            eh.workSiteCity,
            eh.workSiteState,
            eh.workSiteZip,
            eh.phone, 
            eh.fax,
            eh.email,
            eh.supervisor,
            eh.supervisor_name,
            eh.supervisor_phone, 
            eh.supervisor_email, 
            eh.homepage,
            eh.EIN,
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
            workSiteS.stateName as workSiteStateName,
            airportS.stateName as arrivalAirportStateName            
        FROM 
        	extra_hostcompany eh
        LEFT OUTER JOIN 
        	smg_states s ON eh.state = s.ID
        LEFT OUTER JOIN 
        	smg_states workSiteS ON eh.workSiteState = workSiteS.ID
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
        	type, 
            id
        FROM 
        	extra_housing							
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
                        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        state = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.state#">,
                        zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        workSiteAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.workSiteAddress#">,
                        workSiteCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.workSiteCity#">,
                        workSiteState = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.workSiteState#">,
                        workSiteZip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.workSiteZip#">,
                        housing_options = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housing_options#">,
                        housing_cost = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.housing_cost)#">,
                        isHousingProvided = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isHousingProvided)#">,
                        housingProvidedInstructions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housingProvidedInstructions#">,
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
                        supervisor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor#">,
                        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        supervisor_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_name#">,
                        supervisor_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_phone#">,
                        supervisor_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_email#">,
                        EIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.EIN#">,
                        homepage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homepage#">,
                        observations = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.observations#">
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
                        address,
                        city,
                        state,
                        zip,
                        workSiteAddress,
                        workSiteCity,
                        workSiteState,
                        workSiteZip,
                        housing_options,
                        housing_cost,
                        isHousingProvided,
                        housingProvidedInstructions,
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
                        supervisor,
                        phone,
                        fax,
                        email,
                        supervisor_name,
                        supervisor_phone,
                        supervisor_email,
                        EIN,
                        homepage,
                        observations,
                        entryDate,
                        enteredBy
                    )                
                    VALUES 
                    (
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.name#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.business_typeID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.state#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.workSiteAddress#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.workSiteCity#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.workSiteState#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.workSiteZip#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housing_options#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.housing_cost)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isHousingProvided)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housingProvidedInstructions#">,
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
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervisor_email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.EIN#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homepage#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.observations#">,
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
			FORM.address = qGetHostCompanyInfo.address;
			FORM.city = qGetHostCompanyInfo.city;
			FORM.state = qGetHostCompanyInfo.state;
			FORM.zip = qGetHostCompanyInfo.zip;
			FORM.EIN = qGetHostCompanyInfo.EIN;
			FORM.workSiteAddress = qGetHostCompanyInfo.workSiteAddress;
			FORM.workSiteCity = qGetHostCompanyInfo.workSiteCity;
			FORM.workSiteState = qGetHostCompanyInfo.workSiteState;
			FORM.workSiteZip = qGetHostCompanyInfo.workSiteZip;
			FORM.housing_options = qGetHostCompanyInfo.housing_options;
			FORM.housing_cost = qGetHostCompanyInfo.housing_cost;
			FORM.isHousingProvided = qGetHostCompanyInfo.isHousingProvided;
			FORM.housingProvidedInstructions = qGetHostCompanyInfo.housingProvidedInstructions;
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
			FORM.supervisor = qGetHostCompanyInfo.supervisor;
			FORM.phone = qGetHostCompanyInfo.phone;
			FORM.fax = qGetHostCompanyInfo.fax;
			FORM.email = qGetHostCompanyInfo.email;
			FORM.supervisor_name = qGetHostCompanyInfo.supervisor_name;
			FORM.supervisor_phone = qGetHostCompanyInfo.supervisor_phone;
			FORM.supervisor_email = qGetHostCompanyInfo.supervisor_email;
			FORM.homepage = qGetHostCompanyInfo.homepage;
			FORM.observations = qGetHostCompanyInfo.observations;
		</cfscript>
    
    </cfif>

</cfsilent>

<script language="JavaScript"> 
	$(document).ready(function() {
		// $(".formField").attr("disabled","disabled");
		
		showHideBusinessTypeOther();
		displayHousingInfo();
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
			$("#workSiteAddress").val($("#address").val());
			$("#workSiteCity").val($("#city").val());
			$("#workSiteState").val($("#state").val());
			$("#workSiteZip").val($("#zip").val());
		} else {
			$("#workSiteAddress").val("");
			$("#workSiteCity").val("");
			$("#workSiteState").val("");
			$("#workSiteZip").val("");
		}
	}

	var jsCopyContact = function () {
		isChecked = $("#copyContact").attr('checked');
		if ( isChecked ) {
			$("#supervisor_name").val($("#supervisor").val());
			$("#supervisor_phone").val($("#phone").val());
			$("#supervisor_email").val($("#email").val());
		} else {
			$("#supervisor_name").val("");
			$("#supervisor_phone").val("");
			$("#supervisor_email").val("");
		}
	}

	var displayHousingInfo = function() { 
		// Get Housing Info
		getHousingInfo = $('input:radio[name=isHousingProvided]:checked').val();
		if ( getHousingInfo == 1 ) {
			$(".housingInfo").fadeIn("fast");
		} else {
			//erase data
			$("#housingProvidedInstructions").val("");
			$(".housingInfo").fadeOut("fast");
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
	   $("#fax").mask("(999)999-9999");
	   $("#supervisor_phone").mask("(999)999-9999");
	   $("#pickUpContactPhone").mask("(999)999-9999");
	});	
	// --> 
</script>

<cfoutput>

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
                                <td><input type="text" name="name" value="#FORM.name#" class="style1" size="50" maxlength="250"></td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>Business Type:</strong></td>
                                <td>
                                    <select name="business_typeID" id="business_typeID" class="style1" onchange="showHideBusinessTypeOther();">
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
                                <td><input type="text" name="businessTypeOther" id="businessTypeOther" value="#FORM.businessTypeOther#" class="style1" size="35" maxlength="100"></td>
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
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Address</td>
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
		                                                <option value="#qGetStateList.ID#" <cfif qGetStateList.ID eq FORM.state>selected</cfif>>#qGetStateList.stateName#</option>
        	                                      	</cfloop>
	                                            </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Zip:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.zip#</span>
                                                <input type="text" name="zip" id="zip" value="#FORM.zip#" class="style1 editPage" size="35" maxlength="10">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table> 
                        
                        <br />

                        <!--- WORK SITE ADDRESS --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Work Site Address</td>
                                        </tr>
                                        <tr class="editPage">
                                        	<td class="style1" align="right"><input type="checkbox" name="copyAddress" id="copyAddress" class="style1 editPage" onclick="jsCopyAddress();" /></td>
                                            <td class="style1"><strong><label for="copyAddress">Same as Above</label></strong></td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Address:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#FORM.workSiteAddress#</span>
                                                <input type="text" name="workSiteAddress" id="workSiteAddress" value="#FORM.workSiteAddress#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>City</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.workSiteCity#</span>
                                                <input type="text" name="workSiteCity" id="workSiteCity" value="#FORM.workSiteCity#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>		
                                        <tr>
                                            <td class="style1" align="right"><strong>State:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetHostCompanyInfo.workSitestateName#</span>
                                                <select name="workSiteState" id="workSiteState" class="style1 editPage">
                                              		<option value="0"></option>
                                              		<cfloop query="qGetStateList">
		                                                <option value="#qGetStateList.ID#" <cfif qGetStateList.ID eq FORM.workSiteState>selected</cfif>>#qGetStateList.stateName#</option>
        	                                      	</cfloop>
	                                            </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Zip:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.workSiteZip#</span>
                                                <input type="text" name="workSiteZip" id="workSiteZip" value="#FORM.workSiteZip#" class="style1 editPage" size="35" maxlength="10">
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
                                            <td colspan="4" class="style2" bgcolor="##8FB6C9">&nbsp;:: Housing</td>
                                        </tr>
                                        <cfloop query="qGetHousing">
                                            <cfif qGetHousing.currentrow MOD 2 EQ 1><tr></cfif>
                                            <td class="style1"> 
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
                                            <td width="35%" class="style1" align="right"><strong>Contact:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.supervisor#</span>
                                                <input type="text" name="supervisor" id="supervisor" value="#FORM.supervisor#" class="style1 editPage" size="35" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Phone:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.phone#</span>
                                                <input type="text" name="phone" id="phone" value="#FORM.phone#" class="style1 editPage" size="35" maxlength="50">
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
                                            <td class="style1" align="right"><strong>Supervisor Phone:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.supervisor_phone#</span>
                                                <input type="text" name="supervisor_phone" id="supervisor_phone" value="#FORM.supervisor_phone#" class="style1 editPage" size="35" maxlength="100">
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Supervisor Email:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.supervisor_email#</span>
                                                <input type="text" name="supervisor_email" id="supervisor_email" value="#FORM.supervisor_email#" class="style1 editPage" size="35" maxlength="100">
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>EIN:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.EIN#</span>
                                                <input type="text" name="EIN" id="EIN" value="#FORM.EIN#" class="style1 editPage" size="35" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Homepage:&nbsp;</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.homepage#</span>
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

                        <!--- HOUSING INFORMATION --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Housing Information</td>
                                        </tr>
                                        <tr>
                                            <td width="35%" class="style1" align="right"><strong>Is Housing Provided?</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#YesNoFormat(VAL(FORM.isHousingProvided))#</span>
                                                <input type="radio" name="isHousingProvided" id="isHousingProvidedNo" value="0" class="style1 editPage" onclick="displayHousingInfo();" <cfif FORM.isHousingProvided EQ 0> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isHousingProvidedNo">No</label>
                                                <input type="radio" name="isHousingProvided" id="isHousingProvidedYes" value="1" class="style1 editPage" onclick="displayHousingInfo();" <cfif VAL(FORM.isHousingProvided)> checked="checked" </cfif> /> 
                                                <label class="style1 editPage" for="isHousingProvidedYes">Yes</label>
                                            </td>
                                        </tr>
                                        <tr class="hiddenField housingInfo">
                                            <td class="style1" align="right" valign="top"><strong>Housing Instructions:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#FORM.housingProvidedInstructions#</span>
                                                <textarea name="housingProvidedInstructions" id="housingProvidedInstructions" class="style1 editPage" cols="35" rows="4">#FORM.housingProvidedInstructions#</textarea>
                                            </td>
                                        </tr>
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
	                                <input name="Submit" type="image" src="../pics/update.gif" alt="Update Host Company" border="0">
								<cfelse>
	                                <input name="Submit" type="image" src="../pics/save.gif" alt="Save Host Company" border="0">
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
