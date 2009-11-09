<cfparam name="submitted" default="0">
<cfparam name="regionid" default="#client.regionid#">
<cfparam name="keyword" default="">
<cfparam name="hosting" default="">
<cfparam name="active" default="1">
<cfparam name="orderby" default="familylastname">
<cfparam name="recordsToShow" default="25">

<br>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor="#ffffff">
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=30 background="pics/header_background.gif"><img src="pics/family.gif"></td>
        <td background="pics/header_background.gif"><h2>Host Families</h2></td>
        <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=forms/host_fam_form">Add Host Family</a></td>
    	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="?curdoc=host_fam" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
	<cfif client.usertype LTE 4>
        <td>
			<!--- GET ALL REGIONS --->
            <cfquery name="list_regions" datasource="#application.dsn#">
                SELECT regionid, regionname
                FROM smg_regions
                WHERE company = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                AND subofregion = 0
                ORDER BY regionname
            </cfquery>
            Region<br />
			<cfselect NAME="regionid" query="list_regions" value="regionid" display="regionname" selected="#regionid#" queryPosition="below">
				<option value="">All</option>
			</cfselect>
        </td>
	</cfif>
        <td>
            Keyword / ID<br />
			<cfinput type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
        </td>
	<cfif client.usertype LTE 4>
        <td>
            Hosting<br />
			<select name="hosting">
				<option value="">All</option>
				<option value="1" <cfif hosting EQ 1>selected</cfif>>Yes</option>
				<option value="0" <cfif hosting EQ 0>selected</cfif>>No</option>
			</select>
            
        </td>
        <td>
            Active<br />
			<select name="active">
				<option value="">All</option>
				<option value="1" <cfif active EQ 1>selected</cfif>>Yes</option>
				<option value="0" <cfif active EQ 0>selected</cfif>>No</option>
			</select>            
        </td>
	</cfif>
        <td>
            Order By<br />
            <select name="orderby">
                <option value="hostid" <cfif orderby EQ 'hostid'>selected</cfif>>ID</option>
                <option value="familylastname" <cfif orderby EQ 'familylastname'>selected</cfif>>Last Name</option>
                <option value="fatherfirstname" <cfif orderby EQ 'fatherfirstname'>selected</cfif>>Father</option>
                <option value="motherfirstname" <cfif orderby EQ 'motherfirstname'>selected</cfif>>Mother</option>
                <option value="city" <cfif orderby EQ 'city'>selected</cfif>>City</option>
                <option value="state" <cfif orderby EQ 'state'>selected</cfif>>State</option>
            </select>            
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

<cfif submitted>

	<!--- OFFICE PEOPLE AND ABOVE --->
    <cfif client.usertype LTE 4>
        
        <cfquery name="getResults" datasource="#application.dsn#">
            SELECT h.hostid, h.familylastname, h.fatherfirstname, h.motherfirstname, h.city, h.state
            FROM smg_hosts h
            <cfif hosting EQ 1>
                INNER JOIN smg_students s ON h.hostid = s.hostid
            <cfelseif hosting EQ 0>
                LEFT JOIN smg_students s ON h.hostid = s.hostid
            </cfif>
            WHERE h.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            <cfif regionid NEQ ''>
                AND h.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionid#">
            </cfif>
            <cfif trim(keyword) NEQ ''>
                AND (
                	h.hostid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                	OR h.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.fatherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.motherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                )
            </cfif>
            <cfif hosting EQ 1>
                AND s.active = 1
            <cfelseif hosting EQ 0>
                AND s.hostid IS NULL
            </cfif>
            <cfif active NEQ ''>
                AND h.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#active#">
            </cfif>
            ORDER BY #orderby#
        </cfquery>
    
    <!--- FIELD --->
    <cfelse>
        
        <!---- REGIONAL ADVISOR ----->
        <cfif client.usertype EQ 6>
			<cfset hostlist = ''>
        	<!--- get reps who the user is the advisor of, and in the region. --->
            <cfquery name="areareps" datasource="#application.dsn#">
                SELECT userid
                FROM user_access_rights
                WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
                AND (advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                OR userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">) 
                GROUP BY userid
                ORDER BY userid
            </cfquery>
            <cfloop query="areareps">
                <cfquery name="hosts_under_reps" datasource="#application.dsn#">
                    SELECT DISTINCT hostid
                    FROM smg_students 
                    WHERE arearepid = '#areareps.userid#'
                    OR placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                    UNION
                    SELECT DISTINCT hostid
                    FROM smg_hosts
                    WHERE arearepid = '#areareps.userid#'
                    ORDER BY hostid
                </cfquery>
                <cfif hosts_under_reps.recordcount NEQ 0>	
					<!--- we're inside a loop so need listAppend. --->
                    <cfset hostlist = listAppend(hostlist, valueList(hosts_under_reps.hostid))>>
                </cfif>
            </cfloop>
        <!--- AREA REP - STUDENTS VIEW --->
        <cfelseif listFind("7,9", client.usertype)>
			<cfset hostlist = ''>
            <cfquery name="host_under_area" datasource="#application.dsn#">
                SELECT DISTINCT hostid
                FROM smg_students 
                WHERE arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                OR placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                UNION
                SELECT DISTINCT hostid
                FROM smg_hosts 
                WHERE arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                ORDER BY hostid
            </cfquery>
			<cfset hostlist = valueList(host_under_area.hostid)>
        </cfif>
    
        <cfquery name="getResults" datasource="#application.dsn#">
            SELECT DISTINCT h.familylastname, h.fatherfirstname, h.motherfirstname, h.hostid, h.city, h.state
            FROM smg_hosts h
            WHERE h.active = 1
			<!--- REGIONAL MANAGER SEES ALL FAMILIES ON THE REGION --->
            AND h.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
            <cfif trim(keyword) NEQ ''>
                AND (
                	h.hostid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                	OR h.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.fatherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.motherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                )
            </cfif>
            <cfif listFind("6,7,9", client.usertype)>
				<!--- if hostlist is null return 0 results. --->
                <cfif hostlist EQ ''>
                    AND 1 = 0
                <cfelse>
                    AND h.hostid IN (#hostlist#)
                </cfif>
            </cfif>		
            ORDER BY #orderby#
        </cfquery>
        
    </cfif>

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
		<cfset urlVariables = "submitted=1&regionid=#regionid#&keyword=#urlEncodedFormat(keyword)#&hosting=#hosting#&active=#active#&orderby=#orderby#&recordsToShow=#recordsToShow#">
    
        <cfoutput>
    
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="?curdoc=host_fam&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="?curdoc=host_fam&startPage=#i#&#urlVariables#">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="?curdoc=host_fam&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
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
                <th>Father</th>
                <th>Mother</th>
                <th>City</th>
                <th>State</th>
            </tr>
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td><a href="?curdoc=host_fam_info&hostid=#hostid#">#hostid#</a></td>
                <td>#familylastname#</td>
                <td>#fatherfirstname#</td>
                <td>#motherfirstname#</td>
                <td>#city#</td>
                <td>#state#</td>
            </tr>
            </cfloop>
        </table>
    
        </cfoutput>
	<cfelse>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <td>No host families matched your criteria.</td>
            </tr>
        </table>
    </cfif>
    
</cfif>
   
<cfinclude template="table_footer.cfm">