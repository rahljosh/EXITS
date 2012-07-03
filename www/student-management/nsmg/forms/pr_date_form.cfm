<!--- ------------------------------------------------------------------------- ----
	
	File:		pr_date_form.cfm
	Author:		Marcus Melo
	Date:		July 3, 2012
	Desc:		Add dates to progress reports

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.prdate_id" default="">

	<cfset field_list = 'prdate_date,prdate_comments,fk_prdate_type,fk_prdate_contact'>
    <cfset errorMsg = ''>
    
</cfsilent>

<cfif NOT LEN(FORM.prdate_id)>
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(FORM.prdate_id)>
        a numeric prdate_id is required to edit a progress report date.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<!--- Process Form Submission --->
<cfif VAL(FORM.submitted)>

    <cfquery name="qGetDateRange" datasource="mysql">
        SELECT 
            startDate, 
            DATE_ADD(endDate, INTERVAL 31 DAY) AS endDate <!--- add 1 month to include July dates --->
        FROM 
            smg_seasons
        WHERE 
            startdate <= CURRENT_DATE
        AND 
            DATE_ADD(endDate, INTERVAL 31 DAY) >= CURRENT_DATE
	</cfquery>
        
    <cfloop from="#qGetDateRange.startDate#" to="#qGetDateRange.endDate#" index="i" step="#CreateTimeSpan(31,0,0,0)#">
   
		<cfif client.pr_rmonth EQ DatePart('m', i)>
			<cfset firstDate = '#DatePart("yyyy", i)#-#DatePart("m", i)#-01'>
            <cfset lastDay = '#DateAdd("d", "31", "#DatePart("yyyy", i)#-#DatePart("m", i)#-01")#"'>
            <cfset thisDay = '#DateFormat('#now()#', 'yyyy-mm-dd')#'>
        </cfif>

	</cfloop>
       
	<cfscript>
		// Data Validation
		if ( NOT LEN(FORM.prdate_date) ) {
			SESSION.formErrors.Add("Please enter your date of contact.");
		}
		
		if ( isDate(FORM.prdate_date) AND ( FORM.prdate_date LT firstDate OR FORM.prdate_date GT lastDay ) ) {
			SESSION.formErrors.Add("Contact date must be between #dateFormat(firstDate, 'mm/dd/yyyy')# and #dateFormat(lastDay, 'mm/dd/yyyy')#");
		}

		if ( NOT LEN(FORM.fk_prdate_type) ) {
			SESSION.formErrors.Add("Please enter the type of contact you had.");
		}

		if ( NOT LEN(FORM.fk_prdate_contact) ) {
			SESSION.formErrors.Add("Please select the Contact.");
		}
		
		if ( LEN(FORM.fk_prdate_contact) GT 200 ) {
			SESSION.formErrors.Add("Please limit comments  to 200 characters or less.");
		}
	</cfscript>	

	<!--- Check if there are no errors --->
    <cfif NOT SESSION.formErrors.length()>
    
		<cfif new>
        
            <cfquery datasource="#application.dsn#">
                INSERT INTO 
               		progress_report_dates 
				(
                	fk_progress_report, 
                    prdate_date, 
                    prdate_comments, 
                    fk_prdate_type, 
                    fk_prdate_contact
                )
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.prdate_date#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.prdate_comments#" null="#yesNoFormat(trim(FORM.prdate_comments) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_prdate_type#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_prdate_contact#">
                )  
            </cfquery>
            
		<!--- edit --->
		<cfelse>
        
			<cfquery datasource="#application.dsn#">
				UPDATE 
                	progress_report_dates 
                SET
                    prdate_date = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.prdate_date#">,
                    prdate_comments = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.prdate_comments#" null="#yesNoFormat(trim(FORM.prdate_comments) EQ '')#">,
                    fk_prdate_type = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_prdate_type#">,
                    fk_prdate_contact = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_prdate_contact#">
				WHERE 
                	prdate_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.prdate_id#">
			</cfquery>
            
		</cfif>
        
        <form action="index.cfm?curdoc=progress_report_info" method="post" name="theForm" id="theForm">
            <input type="hidden" name="pr_id" value="<cfoutput>#FORM.pr_id#</cfoutput>">
        </form>
        
        <script>
			$(document).ready(function() {
				// submit form
				$("#theForm").submit();
			});
        </script>
        
	</cfif>

<!--- add --->
<cfelseif new>

	<cfparam name="FORM.pr_id" default="">
	<cfif not isNumeric(FORM.pr_id)>
        a numeric pr_id is required to add a new progress report date.
        <cfabort>
	</cfif>

	<cfloop list="#field_list#" index="counter">
    	<cfset "FORM.#counter#" = "">
	</cfloop>
        
<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="#application.dsn#">
		SELECT *
		FROM progress_report_dates
		WHERE prdate_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.prdate_id#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "FORM.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
    
    <!--- pr_id is passed in for a new date, but set it for edit. --->
    <cfset FORM.pr_id = get_record.fk_progress_report>

</cfif>

<table align="center">

  <tr>
    <td>

<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>

<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
	<td background="pics/header_background.gif"><h2>Contact Date</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=forms/pr_date_form" method="post" name="my_form" onSubmit="return checkForm();">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="prdate_id" value="#FORM.prdate_id#">
<cfinput type="hidden" name="pr_id" value="#FORM.pr_id#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">

    <tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td colspan=4 align="left"><!--- Form Errors --->
        	<gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="divOnly"
            width="90%"
            />
        </td>
    </tr>
    <tr>
    
    	<td class="label">Date: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="prdate_date" value="#dateFormat(FORM.prdate_date, 'mm/dd/yyyy')#" class="datePicker" size="10" maxlength="10" mask="99/99/9999" > mm/dd/yyyy</td>
    </tr>
    <tr>
    	<td class="label">Type: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_types" datasource="#application.dsn#">
                SELECT *
                FROM prdate_types
                ORDER BY prdate_type_id
            </cfquery>
            <cfselect name="fk_prdate_type" query="get_types" value="prdate_type_id" display="prdate_type_name" selected="#FORM.fk_prdate_type#" queryPosition="below">
                <option></option>
            </cfselect>
        </td>
    </tr>
    <tr>
    	<td class="label">Contact: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_contacts" datasource="#application.dsn#">
                SELECT *
                FROM prdate_contacts
                ORDER BY prdate_contact_id
            </cfquery>
            <cfselect name="fk_prdate_contact" query="get_contacts" value="prdate_contact_id" display="prdate_contact_name" selected="#FORM.fk_prdate_contact#" queryPosition="below">
                <option></option>
            </cfselect>
        </td>
    </tr>
    <tr>
    	<td class="label">Comments:</td>
        <td><cftextarea name="prdate_comments" value="#FORM.prdate_comments#" cols="35" rows="6" maxlength="200" validate="maxlength" message="Please enter Comments 200 characters or less." /></td>
    </tr>
</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
	</tr>
</table>

</cfform>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

    </td>
  </tr>
</table>