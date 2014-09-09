<SCRIPT>
<!--
// opens letters in a defined format
function OpenLetter(url) {
	newwindow=window.open(url, 'Application', 'height=800, width=850, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>

<!----default variables---->
<cfparam name="recordsToShow" default="25">
<cfparam name="url.Variables" default="">


<cfquery name="getResults" datasource="#application.dsn#">
	SELECT
    	s.studentid,
        s.uniqueid,
        s.firstname,
        s.familylastname,
        s.sex,
        s.active,
        s.dateassigned,
        s.regionguar,
        s.state_guarantee,
        s.aypenglish,
        s.ayporientation,
        s.hostid,
        s.scholarship,
        s.privateschool,
     	smg_regions.regionname,
        smg_g.regionname as r_guarantee,
        smg_states.state,
        smg_programs.programname,
      	c.countryname,
        co.companyshort,
        smg_hosts.familylastname AS hostname
 	FROM 
    	smg_students s
  	INNER JOIN 
    	smg_companies co ON s.companyid = co.companyid
 	LEFT JOIN 
    	smg_regions ON s.regionassigned = smg_regions.regionid
   	LEFT JOIN 
    	smg_countrylist c ON s.countryresident = c.countryid
    LEFT JOIN 
    	smg_regions smg_g ON s.regionalguarantee = smg_g.regionid
    LEFT JOIN 
    	smg_states ON s.state_guarantee = smg_states.id
    LEFT JOIN 
    	smg_hosts ON s.hostid = smg_hosts.hostid
    LEFT JOIN 
    	smg_programs on s.programID = smg_programs.programID
 	WHERE
    	s.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
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
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor="#ffffff">
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=30 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>Students</h2></td>
        <td background="pics/header_background.gif" align="right">
        	
        </td>
    	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
    
        <cfoutput>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="index.cfm?curdoc=students&startPage=#url.startPage - 1#&#url.Variables#">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="index.cfm?curdoc=students&startPage=#i#&#url.Variables#">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="index.cfm?curdoc=students&startPage=#url.startPage + 1#&#url.Variables#">NEXT ></a>
                        </cfif>
                        <br>
                    </cfif>
                    Displaying #startrow# to #endrow# of #getResults.recordCount#
                </td>
            </tr>
        </table>
            
        <table width=100% class="section">
            <tr align="left">
                <th>ID</th>
                <th>Last Name</th>
                <th>First Name</th>
                <th>Sex</th>
                <th>Country</th>
                <th>Region</th>
                <th>Program</th>
                <th>Family</th>
                <cfif client.companyid EQ 5>
                	<th>Company</th>
                </cfif>
            </tr>
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
				<cfif dateassigned NEQ '' AND dateassigned GT client.lastlogin>
                    <cfset bgcolor="e2efc7">
                <cfelseif dateassigned NEQ '' AND DateDiff('d',dateassigned, now()) GTE 25 AND DateDiff('d',dateassigned, now()) LTE 34 AND hostid EQ 0 AND active EQ 1>
                    <cfset bgcolor="B3D9FF">
                <cfelseif dateassigned NEQ '' AND DateDiff('d',dateassigned, now()) GTE 35 AND DateDiff('d',dateassigned, now()) LTE 49 AND hostid EQ 0 AND active EQ 1>
                    <cfset bgcolor="FFFF9D">
                <cfelseif dateassigned NEQ '' AND DateDiff('d',dateassigned, now()) GTE 50 AND hostid EQ 0 AND active EQ 1>
                    <cfset bgcolor="FF9D9D">
                <cfelse>
                    <cfset bgcolor="">
                </cfif>
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                    <td bgcolor="#bgcolor#">
                        <cfif client.usertype EQ 9>
                        	<a href="index.cfm?curdoc=forms/secondHomeVisitReport&uniqueid=#uniqueid#">#studentid#</a>
                        <cfelseif client.usertype eq 15>
                        	<a href="javascript:OpenLetter('reports/placementInfoSheet.cfm?uniqueID=#uniqueid#');">#studentid#</a>
                        <cfelse>
                        	<a href="index.cfm?curdoc=forms/secondHomeVisitReport&studentid=#studentid#">#studentid#</a>
                        </cfif>
                    </td>
                    <td>#familylastname#</td>
                    <td>#firstname#</td>
                    <td>
                    	<cfif sex EQ 'male'>
                        	Male
                        <cfelseif sex EQ 'female'>
                        	Female
                        </cfif>
                    </td>
                    <td>#countryname#</td>
                    <td>
                    	#regionname#
						<cfif regionguar is 'yes'>
                            <font color="CC0000">
                            <cfif r_guarantee NEQ ''>
                                * #r_guarantee#
                            <cfelseif state_guarantee NEQ 0>
                                * #state#
                            <cfelse>
                                * Missing
                            </cfif>
                            </font>
                        </cfif>
                    </td>
                    <td>
                        #programname#
                        <font color="CC0000">
                        <cfif aypenglish NEQ 0>
                            * Pre-Ayp English
                        <cfelseif ayporientation NEQ 0>
                            * Pre-Ayp Orient.
                        </cfif>
                         <cfif scholarship NEQ 0>
                            * Scholarship
                         </cfif>
                         <Cfif privateschool gt 0>
                            * Private School
                         </Cfif>
                        </font>
                    </td>
                    <td>#hostname#</td>
					<cfif client.companyid EQ 5>
                        <td>#companyshort#</td>
                    </cfif>
                </tr>
            </cfloop>
        </table>
    
        </cfoutput>
        <table width=100% bgcolor="#ffffe6" class="section">
            <tr>
                <td>
                    <table>
                      <tr>
                        <td bgcolor="e2efc7" width="15">&nbsp;</td>
                        <td>Added since your last vist.</td>
                      </tr>
                    </table>
                </td>
                <td>
                    <table>
                      <tr>
                        <td bgcolor="B3D9FF" width="15">&nbsp;</td>
                        <td>Unplaced for 25-34 days.</td>
                      </tr>
                    </table>
                </td>
                <td>
                    <table>
                      <tr>
                        <td bgcolor="FFFF9D" width="15">&nbsp;</td>
                        <td>Unplaced for 35-49 days.</td>
                      </tr>
                    </table>
                </td>
                <td>
                    <table>
                      <tr>
                        <td bgcolor="FF9D9D" width="15">&nbsp;</td>
                        <td>Unplaced more than 50 days.</td>
                      </tr>
                    </table>
                </td>
                <td><font color="CC0000">* Regional / State Preference.</font></td>
            </tr>
        </table>

	<cfelse>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <td>No students matched your criteria.</td>
            </tr>
        </table>
    </cfif>
    <cfinclude template="../table_footer.cfm">