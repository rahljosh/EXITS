<style type="text/css">
<!--
.program {
	font-size: 13px;
	font-weight: bold;
	background-color: #eeeeee;
	line-height: 25px;
}
-->
</style>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>
	<cfif trim(form.date_from) NEQ '' and not isDate(trim(form.date_from))>
		<cfset errorMsg = "Please enter a valid From date.">
	<cfelseif trim(form.date_to) NEQ '' and not isDate(trim(form.date_to))>
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
<cfparam name="company_region" default="region,#client.regionid#">
<cfparam name="display" default="0">
<cfparam name="intrep" default="">
<cfparam name="programid" default="">
<cfparam name="date_from" default="">
<cfparam name="date_to" default="">
<cfparam name="recordsToShow" default="25">


<!--- this table is to prevent 100% width. --->
<table align="center">
  <tr>
	<td>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>Cancelled Students</h2></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfform action="index.cfm?curdoc=reports_new/cancelled_students" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
          <td>
            <cfquery name="list_regions" datasource="#application.dsn#">
                SELECT smg_regions.regionid, smg_regions.regionname, smg_companies.companyid, smg_companies.team_id
                FROM smg_regions
                INNER JOIN smg_companies ON smg_regions.company = smg_companies.companyid
                WHERE smg_companies.companyid = #client.companyid#
                AND smg_regions.subofregion = '0'
                ORDER BY smg_companies.companyid, smg_regions.regionname
            </cfquery>
            Program Manager - Region<br />
			<select name="company_region">
               
            	<cfoutput query="list_regions" group="companyid">
                  <option value="company,#companyid#" <cfif company_region EQ 'company,#companyid#'>selected</cfif>>#team_id# (All Regions)</option>
                    <cfoutput>
                   		<option value="region,#regionid#" <cfif company_region EQ 'region,#regionid#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#team_id# - #regionname#</option>
                    </cfoutput>
                </cfoutput>
			</select>
        </td>
        <td>
         <cfinvoke component="nsmg.cfc.queries" method="get_programs" returnvariable="get_programs">
            Program<br />
			<cfif client.companyid EQ 5>
                <cfselect name="programid" query="get_programs" group="companyshort" value="programid" display="programname" selected="#programid#" multiple="yes" size="6" />
            <cfelse>
                <cfselect name="programid" query="get_programs" value="programid" display="programname" selected="#programid#" multiple="yes" size="6" />
            </cfif>
        </td>
        <td>
            From<br />
			<cfinput type="text" name="date_from" value="#dateFormat(date_from, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid From date."> mm/dd/yyyy<br />
            To<br />
			<cfinput type="text" name="date_to" value="#dateFormat(date_to, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid To date."> mm/dd/yyyy
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
<cfoutput>

</cfoutput>
    <cfquery name="getResults" datasource="#application.dsn#">
        SELECT smg_students.studentid, smg_students.firstname, smg_students.familylastname, smg_students.programid,
        	smg_students.canceldate, smg_students.cancelreason, smg_regions.regionname, c.countryname, smg_programs.programname
        FROM smg_students
        INNER JOIN smg_regions ON smg_students.regionassigned = smg_regions.regionid
        INNER JOIN smg_programs ON smg_students.programid = smg_programs.programid
        LEFT JOIN smg_countrylist c ON smg_students.countryresident = c.countryid
        
       where smg_students.canceldate != 'NULL' 
       <cfif programid is not ''>
		AND	smg_students.programid IN (#programid#)
        <cfelse>
        	
			<cfif client.companyid lt 6>
            AND smg_students.companyid < 6 
            <cfelse>
            AND smg_students.companyid = #client.companyid#
            </cfif>
       </cfif> 
        <cfif date_from NEQ ''>
            AND DATE(smg_students.canceldate) >= <cfqueryparam cfsqltype="cf_sql_date" value="#date_from#">
        </cfif>
        <cfif date_to NEQ ''>
            AND DATE(smg_students.canceldate) <= <cfqueryparam cfsqltype="cf_sql_date" value="#date_to#">
        </cfif>
   		<cfif (#listLast(company_region)# neq #client.companyid#)>
        AND  smg_students.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(company_region)#">
        </cfif>
	     <!---- include the programid because we're grouping by that in the output, just in case two have the same programname. --->
        ORDER BY smg_students.programid, smg_students.familylastname
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
		<cfset urlVariables = "display=1&programid=#programid#&date_from=#date_from#&date_to=#date_to#&recordsToShow=#recordsToShow#&company_region=#company_region#">
    
        <cfoutput>
    
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td width="19"><a href="reports_new/cancelled_students_print.cfm?#urlVariables#" target="_blank"><img src="pics/printer.gif" alt="Printer Friendly Format" border="0" /></a></td>
                <td>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="index.cfm?curdoc=reports_new/cancelled_students&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="index.cfm?curdoc=reports_new/cancelled_students&startPage=#i#&#urlVariables#">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="index.cfm?curdoc=reports_new/cancelled_students&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                        </cfif>
                        <br>
                    </cfif>
                    Displaying #startrow# to #endrow# of #getResults.recordCount#
                </td>
            </tr>
        </table>
 
        <table width=100% class="section">
			<cfset myCurrentRow = 0>
            <cfset current_programid = ''>
            
            
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
                <cfif programid NEQ current_programid>
                    <cfset myCurrentRow = 0>
                    <cfset current_programid = programid>
                    <tr>
                        <td colspan=6 height="25">&nbsp;</td>
                    </tr>
                    <tr align="center" class="program">
                        <td colspan="6">Program: #programname#</td>
                    </tr>
                    <tr align="left">
                        <th>Student</th>
                        <th>Date Cancelled</th>
                        
                        <th>Country</th>
                        <th>Region</th>
                        <th>Reason</th>
                    </tr>
                </cfif>
                <cfset myCurrentRow = myCurrentRow + 1>                
                <tr bgcolor="#iif(currentRow MOD 2 ,DE("F0F0F0") ,DE("white") )#">
                    <td>#firstname# #familylastname# (#studentid#)</td>
                    <td>#DateFormat(canceldate, 'mm/dd/yyyy')#</td>
                    
                    <td>#countryname#</td>
                    <td>#regionname#</td>
                    <td>#cancelreason#</td>
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

    </td>
  </tr>
</table>
<!--- this table is to prevent 100% width. --->