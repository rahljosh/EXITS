<style type="text/css">
<!--
.region {
	font-size: 13px;
	font-weight: bold;
	background-color: #eeeeee;
	line-height: 25px;
}
-->
</style>

<cfparam name="form.display" default="0">
<cfparam name="form.programid" default="">

<!--- this table is to prevent 100% width. --->
<table align="center" width="500">
  <tr>
    <td>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>Gender Report by Region</h2></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfform action="index.cfm?curdoc=reports_new/regional_gender" method="post">
<input name="display" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
        <td>
            <cfquery name="get_programs" datasource="#application.dsn#">
                SELECT smg_programs.programid, smg_companies.companyshort, smg_programs.programname
                FROM smg_programs
                INNER JOIN smg_companies ON smg_programs.companyid = smg_companies.companyid
                WHERE smg_programs.active = 1
                <cfif client.companyid EQ 5>
                    AND smg_companies.website = 'SMG'
                <cfelse>
                    AND smg_programs.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                </cfif>
                ORDER BY smg_programs.companyid, smg_programs.startdate DESC, smg_programs.programname
            </cfquery>
            Program<br />
            <cfif client.companyid EQ 5>
                <cfselect name="programid" query="get_programs" group="companyshort" value="programid" display="programname" selected="#form.programid#" />
            <cfelse>
                <cfselect name="programid" query="get_programs" value="programid" display="programname" selected="#form.programid#" />
            </cfif>
        </td>
    </tr>
</table>
</cfform>

<cfif form.display>

    <cfquery name="companyshort" datasource="#application.dsn#">
        select *
        from smg_companies
        where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    </cfquery>
    <cfquery name="get_program" datasource="#application.dsn#">
        SELECT programid, programname, startdate, enddate
        FROM smg_programs 
        WHERE programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#">
    </cfquery>
    
    <!---<cfquery name="get_total_students" datasource="#application.dsn#">
        SELECT COUNT(studentid) AS count_stu
        FROM smg_students
        WHERE programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#">
        AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND active = 1
    </cfquery>--->

    <cfquery name="dump_students" datasource="#application.dsn#">
        SELECT smg_regions.regionname, smg_countrylist.countryname, smg_regions.company AS region_co, smg_students.companyid AS student_co
        FROM smg_regions
        INNER JOIN smg_students ON smg_regions.regionid = smg_students.regionassigned
		INNER JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid
        WHERE smg_students.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#">
        AND smg_students.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND smg_students.active = 1
    </cfquery>
    <cfdump var="#dump_students#">

    <cfquery name="getResults" datasource="#application.dsn#">
        SELECT smg_regions.regionid, smg_regions.regionname, smg_countrylist.countryname,
			SUM(CASE WHEN smg_students.sex = 'female' THEN 1 ELSE 0 END) AS total_female,
			SUM(CASE WHEN smg_students.sex = 'male' THEN 1 ELSE 0 END) AS total_male
        FROM smg_regions
        INNER JOIN smg_students ON smg_regions.regionid = smg_students.regionassigned
		INNER JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid
        WHERE smg_regions.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND smg_students.active = 1
        AND smg_students.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#">
        GROUP BY smg_regions.regionid, smg_regions.regionname, smg_students.countryresident
	    <!--- include the regionid because we're grouping by that in the output, just in case two have the same regionname. --->
        ORDER BY smg_regions.regionname, smg_regions.regionid, smg_countrylist.countryname
    </cfquery>

	<cfset grand_total = 0>
    <cfloop query="getResults">
        <cfset grand_total = grand_total + total_female + total_male>
    </cfloop>

    <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
        <tr align="center">
            <td>
			<cfoutput query="get_program">
                <h1>#companyshort.companyshort# Gender Report</h1>
                <b>Program: #programname# (#programid#)</b><br>
                Starts: #dateformat(startdate, 'mm/dd/yyyy')#  &nbsp; Ends: #dateformat(enddate, 'mm/dd/yyyy')#<br>
                Total Students: #numberFormat(grand_total)#<br>
            </cfoutput>
            </td>
        </tr>
    </table>

	<cfif getResults.recordCount GT 0>
    
        <table width=100% class="section" cellspacing="0" cellpadding="4">
            <cfoutput query="getResults" group="regionid">
				<cfif currentRow NEQ 1>
                    <tr>
                        <td colspan=3 height="25">&nbsp;</td>
                    </tr>
                </cfif>
                <cfset region_total = 0>
                <cfoutput>
	                <cfset region_total = region_total + total_female + total_male>
                </cfoutput>
                <tr class="region" align="center">
                    <td>Region: #regionname#</td>
                    <td colspan=2>Total Students: #numberFormat(region_total)#</td>
                </tr>
                <tr>
                    <th align="left">Country</th>
                    <th>Female</th>
                    <th>Male</th>
                </tr>
                <cfset mycurrentRow = 0>
                <cfoutput>
                    <cfset mycurrentRow = mycurrentRow + 1>
                    <tr bgcolor="#iif(mycurrentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                        <td>#countryname#</td>
                        <td align="center">#numberFormat(total_female)#</td>
                        <td align="center">#numberFormat(total_male)#</td>
                    </tr>
                </cfoutput>
            </cfoutput>
        </table>
               
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