<cfif client.usertype EQ 9>
	You do not have access to Schools.
    <cfabort>
</cfif>

<cfparam name="submitted" default="0">
<cfparam name="stateShort" default="">
<cfparam name="keyword" default="">
<cfparam name="school_dates" default="">
<cfparam name="orderBy" default="schoolname">
<cfparam name="recordsToShow" default="25">

<cfquery name="qGetStateList" datasource="#APPLICATION.dsn#">
    SELECT DISTINCT 
    	state
    FROM 
    	smg_schools
    ORDER BY 
    	state
</cfquery>

<!--- default state to user's state. --->
<cfif NOT LEN(stateShort)>

    <cfquery name="qGetUserState" datasource="#APPLICATION.dsn#">
        SELECT 
        	u.state
        FROM 
        	smg_users u
		INNER JOIN
        	smg_states s ON s.state = u.state          
        WHERE 
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
	
	<cfscript>
		if (qGetUserState.recordCount) {
			stateShort = qGetUserState.state;
		}
	</cfscript>

</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
        <td background="pics/header_background.gif"><h2>Schools</h2></td>
        <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=forms/school_form">Add School</a></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfoutput>

<form action="?curdoc=schools" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
        <td>
            State<br />
			<select name="stateShort" id="stateShort">
            	<option value="" <cfif NOT LEN(stateShort)> selected="selected" </cfif>>All</option>
            	<cfloop query="qGetStateList">
                    <option value="#qGetStateList.state#" <cfif qGetStateList.state EQ stateShort> selected="selected" </cfif> >#qGetStateList.state#</option>
                </cfloop>
            </select>
        </td>
        <td>
            Keyword / ID<br />
			<input type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
        </td>
        <td>
            School Dates<br />
			<select name="school_dates">
				<option value="">All</option>
				<option <cfif school_dates EQ 'Unassigned'>selected</cfif>>Unassigned</option>
			</select>            
        </td>
        <td>
            Order By<br />
            <select name="orderBy">
                <option value="schoolid" <cfif orderBy EQ 'schoolid'>selected</cfif>>ID</option>
                <option value="schoolname" <cfif orderBy EQ 'schoolname'>selected</cfif>>School Name</option>
                <option value="principal" <cfif orderBy EQ 'principal'>selected</cfif>>Contact</option>
                <option value="city" <cfif orderBy EQ 'city'>selected</cfif>>City</option>
                <option value="state" <cfif orderBy EQ 'state'>selected</cfif>>State</option>
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
</form>

</cfoutput>

<cfif submitted>

    <cfquery name="getResults" datasource="#APPLICATION.dsn#">
        SELECT DISTINCT 
			s.*
        FROM 
        	smg_schools s
        LEFT JOIN 
        	smg_school_dates scd ON s.schoolid = scd.schoolid
        WHERE 
        	1=1		
		<!----ESI Wants to see all schools, not just the ones they entered---->
		<!--- Filter ESI Schools
		<cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>
        	AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
		 --->
		<cfif LEN(stateShort)>
            AND 
            	s.state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stateShort#">
        </cfif>

        <cfif LEN(TRIM(keyword))>
            AND 
            	(
                	s.schoolid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(keyword)#">
                OR 
                	s.schoolname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                OR 
                	s.principal LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                OR 
                	s.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                OR 
                	s.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
            	)
        </cfif>
        
		<cfif LEN(school_dates)>
            AND 
            	scd.schoolid IS NULL
        </cfif>
        
        ORDER BY
            <cfif ListFind("schoolid,schoolname,principal,city,state", orderBy)>
            	#orderBy#
            <cfelse>
            	s.schoolname
            </cfif>
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
		<cfset urlVariables = "submitted=1&stateShort=#stateShort#&keyword=#urlEncodedFormat(keyword)#&school_dates=#school_dates#&orderBy=#orderBy#&recordsToShow=#recordsToShow#">
    
        <cfoutput>
    
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="?curdoc=schools&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="?curdoc=schools&startPage=#i#&#urlVariables#">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="?curdoc=schools&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                        </cfif>
                        <br>
                    </cfif>
                    Displaying #startrow# to #endrow# of #getResults.recordCount#
                </td>
            </tr>
        </table>
 
        <table width=100% class="section">
            <tr align="left" style="font-weight:bold;">
                <td>ID</td>
                <td>School Name</td>
                <td>Contact</td>
                <td>City</td>
                <td>State</td>
            </tr>
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
            <tr bgcolor="###iif(currentRow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                <td><a href="?curdoc=school_info&schoolid=#schoolid#">#schoolid#</a></td>
                <td><a href="?curdoc=school_info&schoolid=#schoolid#">#schoolname#</a></td>
                <td>#principal#</td>
                <td>#city#</td>
                <td>#state#</td>
            </tr>
            </cfloop>
        </table>
               
        </cfoutput>
	<cfelse>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <td>No schools matched your criteria.</td>
            </tr>
        </table>
    </cfif>

</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

