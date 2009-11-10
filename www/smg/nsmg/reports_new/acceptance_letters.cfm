<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>
	<cfif not isDate(trim(form.date_from))>
		<cfset errorMsg = "Please enter a valid From date.">
	<cfelseif not isDate(trim(form.date_to))>
		<cfset errorMsg = "Please enter a valid To date.">
    <cfelse>
    	<cfset display = 1>
	</cfif>
	<cfif isDefined("errorMsg")>
        <script language="JavaScript">
            alert('<cfoutput>#errorMsg#</cfoutput>');
        </script>
    </cfif>
</cfif>

<cfparam name="display" default="0">
<cfparam name="intrep" default="">
<cfparam name="date_from" default="">
<cfparam name="date_to" default="">
<cfparam name="recordsToShow" default="25">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>Acceptance Letter</h2></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfform action="index.cfm?curdoc=reports_new/acceptance_letters" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
        <td>
            <cfquery name="get_intl_rep" datasource="#application.dsn#">
                SELECT DISTINCT smg_students.intrep, smg_users.businessname, smg_users.userid
                FROM smg_students 
                INNER JOIN smg_users ON smg_students.intrep = smg_users.userid 
                <cfif client.companyid NEQ 5>
                    AND smg_students.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                </cfif>
                ORDER BY smg_users.businessname
            </cfquery>
            Intl. Rep.<br />
			<cfselect name="intrep" query="get_intl_rep" value="intrep" display="businessname" selected="#intrep#" />
        </td>
        <td>
            From<br />
			<cfinput type="text" name="date_from" value="#dateFormat(date_from, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" required="yes" validate="date" message="Please enter a valid From date."> mm/dd/yyyy         
        </td>
        <td>
            To<br />
			<cfinput type="text" name="date_to" value="#dateFormat(date_to, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" required="yes" validate="date" message="Please enter a valid To date."> mm/dd/yyyy         
        </td>
        <td>
            Records Per Page<br />
            <select name="recordsToShow">
                <option <cfif recordsToShow EQ 25>selected</cfif>>25</option>
                <option <cfif recordsToShow EQ 50>selected</cfif>>50</option>
                <option <cfif recordsToShow EQ 100>selected</cfif>>100</option>
                <option <cfif recordsToShow EQ 250>selected</cfif>>250</option>
                <option <cfif recordsToShow EQ 500>selected</cfif>>500</option>
            </select>            
        </td>
    </tr>
</table>
</cfform>

<cfif display>

    <cfquery name="getResults" datasource="#application.dsn#">
        SELECT smg_students.studentid, smg_students.firstname, smg_students.familylastname, smg_students.other_missing_docs,
        	smg_students.programid, smg_programs.programname
        FROM smg_students
        INNER JOIN smg_programs ON smg_students.programid = smg_programs.programid
        AND smg_students.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#intrep#">
        AND (
        	DATE(smg_students.dateapplication) BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#date_from#">
            AND <cfqueryparam cfsqltype="cf_sql_date" value="#date_to#">
        ) 
        AND smg_students.active = 1
        AND smg_students.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        ORDER BY smg_students.programid, smg_students.familylastname, smg_students.firstname
    </cfquery>

	<cfif getResults.recordCount GT 0>

		<cfparam name="url.startPage" default="1">
		<cfset totalPages = ceiling(getResults.recordCount / recordsToShow)>
		<cfset startrow = 1 + ((url.startPage - 1) * recordsToShow)>
		<cfif getResults.recordCount GT url.startPage * recordsToShow>
			<cfset isNextPage = 1>
			<cfset endrow = url.startPage * recordsToShow>
		<cfelse>
			<cfset isNextPage = 0>
			<cfset endrow = getResults.recordCount>
		</cfif>
		<cfset urlVariables = "display=1&intrep=#intrep#&date_from=#date_from#&date_to=#date_to#&recordsToShow=#recordsToShow#">
    
        <cfoutput>
    
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="index.cfm?curdoc=reports_new/acceptance_letters&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="index.cfm?curdoc=reports_new/acceptance_letters&startPage=#i#&#urlVariables#">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="index.cfm?curdoc=reports_new/acceptance_letters&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                        </cfif>
                        <br>
                    </cfif>
                    Displaying #startrow# to #endrow# of #getResults.recordCount#
                </td>
            </tr>
        </table>
 
        <table width=100% class="section">
            <tr align="left">
                <th>Student</th>
                <th>Missing Documents</th>
            </tr>
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td>#firstname# #familylastname# (#studentid#)</td>
                <td>#other_missing_docs#</td>
            </tr>
            </cfloop>
        </table>
               
        </cfoutput>
	<cfelse>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <th><br />No records matched your criteria.</th>
            </tr>
        </table>
    </cfif>

</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>