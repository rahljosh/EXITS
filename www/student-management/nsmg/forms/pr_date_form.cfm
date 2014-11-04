<!--- ------------------------------------------------------------------------- ----
	
	File:		pr_date_form.cfm
	Author:		Marcus Melo
	Date:		July 3, 2012
	Desc:		Add dates to progress reports

	Updated:	Updating query to loop through program start/end dates and not season	

----- ------------------------------------------------------------------------- --->
<cfoutput>


</cfoutput>
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.prdate_id" default="">
    <cfparam name="FORM.pr_id" default="0">
	
    <!--- Param LOCAL Variables --->
    <cfparam name="vSetStartDate" default="">
    <cfparam name="vSetEndDate" default="">
    <cfparam name="vSetDueDate" default="">

    <cfscript>
		field_list = 'prdate_date,prdate_comments,fk_prdate_type,fk_prdate_contact';
	</cfscript>
    
    <cfquery name="qGetContactType" datasource="#APPLICATION.DSN#">
        SELECT 
        	prdate_type_id,
            prdate_type_name
        FROM 
        	prdate_types
        ORDER BY 
        	prdate_type_id
    </cfquery>
    
    <cfquery name="qGetContacts" datasource="#APPLICATION.DSN#">
        SELECT 
            prdate_contact_id,
            prdate_contact_name
        FROM 
        	prdate_contacts
        ORDER BY 
        	prdate_contact_id
    </cfquery>
    
    <!---
	<!--- August to July Reports --->
    <cfquery name="qGetSeasonDateRange" datasource="#APPLICATION.DSN#">
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
    --->
	
    <!--- Use program start/end dates instead of season --->
    <cfquery name="qGetSeasonDateRange" datasource="#APPLICATION.DSN#">
        SELECT 
            p.startDate,
            DATE_ADD(p.endDate, INTERVAL 31 DAY) AS endDate
        FROM
        	smg_programs p
        INNER JOIN
        	smg_students s ON s.programID = p.programID
        INNER JOIN
        	progress_reports pr ON pr.fk_student = s.studentID
        WHERE
        	pr.pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_id)#">          
    </cfquery>
    
    <!--- Loop Through Months in a season | July needs to be included here --->
    <cfloop from="#qGetSeasonDateRange.startDate#" to="#qGetSeasonDateRange.endDate#" index="i" step="#CreateTimeSpan(31,0,0,0)#">
       	
        	<cfset i = DateAdd('m', -1, i)>
        
        <cfif CLIENT.pr_rmonth EQ DatePart('m', i)>
			<cfset vSetStartDate =  DateAdd('m', -1, DatePart("yyyy", i) & '-' & DatePart("m", i) & '-01')>
            <cfset vSetEndDate = CreateDate(year(vSetStartDate), month(vSetStartDate), DaysInMonth(vSetStartDate))>
            <cfset vSetDueDate = CreateDate(DatePart("yyyy", i), DatePart("m", i), '01')>
		</cfif>
         
    </cfloop>

</cfsilent>

<cfif NOT LEN(FORM.prdate_id)>

	<cfset new = true>
    
<cfelse>

	<cfif not isNumeric(FORM.prdate_id) OR NOT IsNumeric(CLIENT.pr_rmonth)>
        Error: a numeric prdate_id is required to edit a progress report date. <br />
		Please try again.       
        <cfabort>
	</cfif>
    
	<cfset new = false>
    
</cfif>

<!--- Process Form Submission --->
<cfif VAL(FORM.submitted)>

	<cfscript>
		// Data Validation
		if ( NOT isDate(FORM.prdate_date) ) {
			SESSION.formErrors.Add("Please enter your date of contact.");
		}
		
		if ( isDate(FORM.prdate_date) AND ( FORM.prdate_date LT vSetStartDate OR FORM.prdate_date GT vSetEndDate ) ) {
			SESSION.formErrors.Add("Contact date must be between #dateFormat(vSetStartDate, 'mm/dd/yyyy')# and #dateFormat(vSetEndDate, 'mm/dd/yyyy')#");
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
        
            <cfquery datasource="#APPLICATION.DSN#">
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
        
			<cfquery datasource="#APPLICATION.DSN#">
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

	<cfquery name="get_record" datasource="#APPLICATION.DSN#">
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

<!--- Table Header --->
<gui:tableHeader
	imageName="current_items.gif"
	tableTitle="Contact Date"
	width="40%"
/>    

<cfoutput>

<cfform action="index.cfm?curdoc=forms/pr_date_form" method="post" name="my_form" onSubmit="return checkForm();">
    <input type="hidden" name="submitted" value="1">
    <cfinput type="hidden" name="prdate_id" value="#FORM.prdate_id#">
    <cfinput type="hidden" name="pr_id" value="#FORM.pr_id#">

    <table width="40%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
        <tr>
            <td colspan="2" align="center">
                <h2>The <strong>#DateFormat(vSetDueDate, 'mmmm')#</strong> report is for contact during the month of <strong>#DateFormat(vSetStartDate, 'mmmm')#</strong>.</h2>
            </td>
        </tr>        
        <tr>
            <td colspan="2" align="left">
                <!--- Form Errors --->
                <gui:displayFormErrors 
                    formErrors="#SESSION.formErrors.GetCollection()#"
                    messageType="divOnly"
                    width="90%" />
            </td>
        </tr>
        <tr>
            <td class="label">Date: <span class="redtext">*</span></td>
            <td><cfinput type="text" name="prdate_date" value="#dateFormat(FORM.prdate_date, 'mm/dd/yyyy')#" class="datePicker" size="10" maxlength="10" mask="99/99/9999" > mm/dd/yyyy</td>
        </tr>
        <tr>
            <td class="label">Type: <span class="redtext">*</span></td>
            <td>
                <cfselect name="fk_prdate_type" query="qGetContactType" value="prdate_type_id" display="prdate_type_name" selected="#FORM.fk_prdate_type#" queryPosition="below">
                    <option></option>
                </cfselect>
            </td>
        </tr>
        <tr>
            <td class="label">Contact: <span class="redtext">*</span></td>
            <td>
                <cfselect name="fk_prdate_contact" query="qGetContacts" value="prdate_contact_id" display="prdate_contact_name" selected="#FORM.fk_prdate_contact#" queryPosition="below">
                    <option></option>
                </cfselect>
            </td>
        </tr>
        <tr>
            <td class="label">Comments:</td>
            <td><cftextarea name="prdate_comments" value="#FORM.prdate_comments#" cols="35" rows="6" maxlength="200" validate="maxlength" message="Please enter Comments 200 characters or less." /></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td><span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span></td>
        </tr>
    </table>
    
    <table border="0" cellpadding="4" cellspacing="0" width="40%" class="section" align="center">
        <tr>
            <td align="center"><input name="Submit" type="image" src="pics/submit.gif" border="0"></td>
        </tr>
    </table>

</cfform>

</cfoutput>

<!--- Table Footer --->
<gui:tableFooter 
	width="40%"
/>
