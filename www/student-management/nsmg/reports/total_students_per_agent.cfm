<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Import CustomTag --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>

<!--- Get total students grouped by Agent --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT DISTINCT
			count(s.studentid) as get_total_students,
			c.countryname,
			u.businessname,
            u.userID,
            sea.season,
            agent_country.countryname as agentcountry
	FROM 	smg_students s
	INNER JOIN smg_countrylist c ON s.countryresident = c.countryid
	INNER JOIN smg_users u ON u.userid = s.intrep
    INNER JOIN smg_programs p ON s.programID = p.programID
    INNER JOIN smg_seasons sea ON p.seasonID = sea.seasonID
	LEFT JOIN smg_countrylist agent_country ON u.country = agent_country.countryid   
	WHERE
    	sea.seasonID = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.season#">
   	AND
    	s.canceldate IS NULL 
		<cfif form.countryid neq 0>
        	AND 
            	s.countryresident = #form.countryid#
        </cfif>
		<cfif CLIENT.companyID EQ 5>
        	AND
    			s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
        <cfelse>
        	AND
    			s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
		</cfif>   
	GROUP BY Businessname
	ORDER BY Businessname
</cfquery>

<cfoutput>

	<table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
        <tr>
            <th>#companyshort.companyshort# - Total of Active Students Per Intl. Rep.</th>            
        </tr>
        <tr>
            <td class="center">
                Total of #get_total_students.recordcount# International Agents
            </td>
        </tr>
        <tr>
        	<td class="center">
                Season: #get_total_students.season# - #FORM.month#
            </td>
        </tr>
    </table>
	<br />
    
    <!--- 0 students will skip the table --->
    <cfif get_total_students.recordcount>
    
		<!--- Information Heading --->
		<cfset total_stu = '0'>
        <cfset total_remaining = '0'>
        <cfset total_allotment = '0'>
        <cfset total_submitted = '0'>
        <cfset total_received = '0'>
        <cfset total_onHold = '0'>
        <cfset total_accepted = '0'>
        <table width="98%" cellpadding=4 cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th class="left" width="25%">Name</th>
                <th class="left" width="19%">Country</td>
                <th class="left" width="8%">Submitted</th>
                <th class="left" width="8%">Received</th>
                <th class="left" width="8%">On Hold</th>
                <th class="left" width="8%">Accepted</th>
                <th class="left" width="8%">Total</th>
                <th class="left" width="8%">Allotment</th>
                <th class="left" width="8%">Remaining</th>
            </tr>
            
            <!--- Representative Loop --->
        	<cfloop query="get_total_students">
                <tr class="#iif(currentrow MOD 2 ,DE("off") ,DE("on") )#">
                	<td>#businessname#</td>
                    <td>#agentcountry#</td>
                    <cfset appTotal=0>
                    
                    <!--- Inner Loop for Submitted, Received, On Hold, and Accepted --->
                    <cfloop list = '7,8,10,11' index="i">
                        <cfquery name="apps" datasource="MySql">
                            SELECT
                                COUNT(*) AS count 
                            FROM 
                                smg_students s
                            WHERE 
                                <!--- RANDID = TO IDENTIFY ONLINE APPS --->
                                randid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                                AND
                                    intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_total_students.userid#">
                                AND 
                                    app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                <cfif CLIENT.companyID EQ 5>
                                    AND
                                        companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                                <cfelse>
                                    AND
                                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                                </cfif>
                                <cfif form.countryid neq 0>
                                    AND 
                                        s.countryresident = ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.countryid#" list="yes"> )
                                </cfif>
                        </cfquery>
                        <cfset appTotal += apps.count>
                        <cfif #i# EQ 7>
                        	<cfset total_submitted += apps.count>
                        <cfelseif #i# EQ 8>
                        	<cfset total_received += apps.count>
                        <cfelseif #i# EQ 10>
                        	<cfset total_onHold += apps.count>
                        <cfelseif #i# EQ 11>
                        	<cfset total_accepted += apps.count>
                        </cfif>
                        <td>#apps.count#</td>
                    </cfloop>
                    
                    <cfset total_stu += #apps.count#>
                    <td>#appTotal#</td>
                    
                    <!--- Allotments from each rep --->
                    <cfquery name="allotments" datasource="MySql">
                        SELECT
                            januaryAllocation,
                            augustAllocation
                        FROM
                            smg_users_allocation a
                        WHERE
                            userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_total_students.userID#">
                        AND
                            seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.season#">
                    </cfquery>
                    
                    <!--- Display appropriate allotment and calculate remaining --->
					<cfif #FORM.month# EQ "january">
                        <cfif #allotments.januaryAllocation# NEQ ''>
                        	<td>#allotments.januaryAllocation#</td>
                        	<cfset remaining = #allotments.januaryAllocation# - #total_stu#>
                            <cfset total_remaining += remaining>
                            <cfset total_allotment += #allotments.januaryAllocation#>
                        <cfelse>
                        	<td>-</td>
                        	<cfset remaining = "-">
                        </cfif>
                    <cfelse>
                        <cfif #allotments.januaryAllocation# NEQ ''>
                        	<td>#allotments.augustAllocation#</td>
                        	<cfset remaining = #allotments.augustAllocation# - #total_stu#>
                            <cfset total_remaining += remaining>
                            <cfset total_allotment += #allotments.augustAllocation#>
                        <cfelse>
                        	<td>-</td>
                        	<cfset remaining = "-">
                        </cfif>
                    </cfif>
                    <td>#remaining#</td>
                </tr>
        	</cfloop>
            <tr>
            	<th class="left">Total Students</th>
                <th>&nbsp;</th>
                <th class="left">#total_submitted#</th>
                <th class="left">#total_received#</th>
                <th class="left">#total_onHold#</th>
                <th class="left">#total_accepted#</th>
                <th class="left">#total_stu#</th>
                <th class="left">#total_allotment#</th>
                <th class="left">#total_remaining#</th>
          	</tr>
     	</table>
    </cfif>

</cfoutput>