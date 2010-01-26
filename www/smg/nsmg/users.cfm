<cfparam name="submitted" default="0">
<cfparam name="company_region" default="region,#client.regionid#">
<cfparam name="user_type" default="">
<cfparam name="assigned" default="1">
<cfparam name="keyword" default="">
<cfparam name="new_user" default="">
<cfparam name="active" default="1">
<cfparam name="orderby" default="lastname">
<cfparam name="recordsToShow" default="25">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Users</h2></td>
	<!--- ONLY OFFICE CAN ADD NEW USERS --->
    <cfif client.usertype LTE 4>
        <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=forms/add_user">Add User</a></td>
	</cfif>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=users" method="post">

<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
	<cfif client.usertype LTE 4>
        <td>
            <cfquery name="list_regions" datasource="#application.dsn#">
                SELECT smg_regions.regionid, smg_regions.regionname, smg_companies.companyid, smg_companies.team_id
                FROM smg_regions
                INNER JOIN smg_companies ON smg_regions.company = smg_companies.companyid
                WHERE smg_companies.website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.company_submitting#">
               		AND smg_regions.subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                	AND active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                ORDER BY smg_companies.companyid, smg_regions.regionname
            </cfquery>
            Program Manager - Region<br />
			<select name="company_region">
                <option value="" selected="selected">All</option>
            	<cfoutput query="list_regions" group="companyid">
                  <option value="company,#companyid#" >#team_id# (All Regions)</option> <!--- <cfif company_region EQ 'company,#companyid#'>selected</cfif> --->
                    <cfoutput>
                   		<option value="region,#regionid#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#team_id# - #regionname#</option> <!--- <cfif company_region EQ 'region,#regionid#'>selected</cfif> --->
                    </cfoutput>
                </cfoutput>
			</select>
        </td>
        <td>
            <cfquery name="get_usertypes" datasource="#application.dsn#">
                SELECT usertypeid, usertype
                FROM smg_usertype
                WHERE usertypeid BETWEEN 1 AND 9
                ORDER BY usertypeid
            </cfquery>
            User Type<br />
            <cfselect NAME="user_type" query="get_usertypes" value="usertypeid" display="usertype" selected="#user_type#" queryPosition="below">
                <option value="">All</option>
            </cfselect>
        </td>
        <td>
            Assigned<br />
			<select name="assigned">
				<option value="1" <cfif assigned EQ 1>selected</cfif>>Yes</option>
				<option value="0" <cfif assigned EQ 0>selected</cfif>>No</option>
			</select>
        </td>
	</cfif>
  <td>
            Keyword / ID<br />
			<cfinput type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
        </td>
        <td>
            New Users<br />
			<select name="new_user">
				<option value="">All</option>
				<option value="1" <cfif new_user EQ 1>selected</cfif>>Yes</option>
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
        <td>
            Order By<br />
            <select name="orderby">
                <option value="userid" <cfif orderby EQ 'userid'>selected</cfif>>ID</option>
                <option value="lastname" <cfif orderby EQ 'lastname'>selected</cfif>>Last Name</option>
                <option value="firstname" <cfif orderby EQ 'firstname'>selected</cfif>>First Name</option>
                <option value="businessname" <cfif orderby EQ 'businessname'>selected</cfif>>Company Name</option>
                <option value="city" <cfif orderby EQ 'city'>selected</cfif>>City</option>
                <option value="state" <cfif orderby EQ 'state'>selected</cfif>>State</option>
                <option value="countryname" <cfif orderby EQ 'countryname'>selected</cfif>>Country</option>
                <option value="phone" <cfif orderby EQ 'phone'>selected</cfif>>Phone</option>
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
<cfif assigned EQ 0>
    <tr>
        <td>&nbsp;</td>
        <td colspan="3"><font size="1"><em>Company - Region, and User Type are non-functional when Assigned=No.</em></font></td>
    </tr>
</cfif>
</table>
</cfform>

<cfif submitted>

    <!--- OFFICE PEOPLE AND ABOVE --->
    <cfif client.usertype LTE 4>
    
        <cfquery name="getResults" datasource="#application.dsn#">
            SELECT DISTINCT u.userid, u.firstname, u.lastname, u.city, u.state, u.phone, u.businessname, u.datecreated, smg_countrylist.countryname
            FROM smg_users u
            <!--- need left join on user_access_rights because of the "unassigned" search option. --->
            LEFT JOIN user_access_rights ON u.userid = user_access_rights.userid
            LEFT JOIN smg_companies ON user_access_rights.companyid = smg_companies.companyid
            LEFT JOIN smg_countrylist ON u.country = smg_countrylist.countryid
            WHERE 0=0
			<cfif assigned EQ 1>
                AND smg_companies.website = '#client.company_submitting#'
				<cfif company_region NEQ ''>
                	<cfif listFirst(company_region) EQ 'company'>
                    	AND user_access_rights.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(company_region)#">
                	<cfelseif listFirst(company_region) EQ 'region'>
                        AND user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(company_region)#">
                    </cfif>
                </cfif>
                <cfif user_type NEQ ''>
                    AND user_access_rights.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#user_type#">
                </cfif>
            <cfelseif assigned EQ 0>
                AND user_access_rights.userid IS NULL
            </cfif>
            <cfif trim(keyword) NEQ ''>
                AND (
                	u.userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                	OR u.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR u.lastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR u.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR u.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR u.phone LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR u.businessname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR smg_countrylist.countryname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                )
            </cfif>
            <cfif new_user NEQ ''>
                AND u.datecreated > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#client.lastlogin#">
            </cfif>
            <cfif active NEQ ''>
                AND u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#active#">
            </cfif>
            ORDER BY #orderby#
        </cfquery>

		<!--- this is used with a query of query in the output. --->
        <cfquery name="get_user_access_rights" datasource="#application.dsn#">
            SELECT user_access_rights.userid, smg_usertype.usertype, smg_companies.team_id, user_access_rights.regionid, smg_regions.regionname
            FROM user_access_rights
            INNER JOIN smg_usertype ON user_access_rights.usertype = smg_usertype.usertypeid
            INNER JOIN smg_companies ON user_access_rights.companyid = smg_companies.companyid
            <!--- international don't have regions. --->
            LEFT JOIN smg_regions ON user_access_rights.regionid = smg_regions.regionid
            WHERE smg_companies.website = '#client.company_submitting#'
            ORDER BY user_access_rights.companyid, user_access_rights.regionid, user_access_rights.usertype
        </cfquery>
        
    <!--- FIELD --->
    <cfelse>
    
        <cfquery name="getResults" datasource="#application.dsn#">
            SELECT DISTINCT u.userid, u.firstname, u.lastname, u.city, u.state, u.phone, u.businessname, u.datecreated, smg_countrylist.countryname
            FROM user_access_rights uar
            INNER JOIN smg_users u ON u.userid = uar.userid
            LEFT JOIN smg_countrylist ON u.country = smg_countrylist.countryid
            WHERE uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
            <!--- manager --->
            AND uar.usertype > 4
            AND uar.usertype <= 7 <!--- DO NOT SHOW STUDENT VIEW --->		
            <!--- advisor --->
            <cfif client.usertype EQ 6>
            	AND uar.advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            </cfif>
            <cfif trim(keyword) NEQ ''>
                AND (
                	u.userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                	OR u.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR u.lastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR u.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR u.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR u.phone LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR u.businessname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR smg_countrylist.countryname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                )
            </cfif>
            <cfif new_user NEQ ''>
                AND u.datecreated > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#client.lastlogin#">
            </cfif>
            <cfif active NEQ ''>
                AND u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#active#">
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
		<cfset urlVariables = "submitted=1&company_region=#company_region#&user_type=#user_type#&assigned=#assigned#&keyword=#urlEncodedFormat(keyword)#&new_user=#new_user#&active=#active#&orderby=#orderby#&recordsToShow=#recordsToShow#">

        <cfoutput>
    
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
                <cfif client.usertype neq 7>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="?curdoc=users&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="?curdoc=users&startPage=#i#&#urlVariables#">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="?curdoc=users&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                        </cfif>
                        <br>
                    </cfif>
                    Displaying #startrow# to #endrow# of #getResults.recordCount#
              </cfif>
                </td>
            </tr>
        </table>
            
        <table width=100% class="section">
            <tr align="left">
                <th>ID</th>
                <th>Last Name</th>
                <th>First Name</th>
			<cfif client.usertype LTE 4>
                <th>Program Manager - Region - User Type</th>
            </cfif>
                <th>Company Name</th>
                <th>City</th>
                <th>State</th>
                <th>Country</th>
                <th>Phone</th>
            </tr>
            
            <cfif client.usertype eq 7>
            <Tr>
            	<Td colspan=10 align="center">Your access level doesn't permit viewing of users.</Td>
            </Tr>
            <cfelse>
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
            	<cfif datecreated GT client.lastlogin>
                	<cfset bgcolor = "e2efc7">
                <cfelse>
                    <cfset bgcolor="">
                </cfif>
                <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                    <td bgcolor="#bgcolor#"><a href="index.cfm?curdoc=user_info&userid=#userid#">#userid#</a></td>
                    <td>#lastname#</td>
                    <td>#firstname#</td>
                <cfif client.usertype LTE 4>
                    <cfquery name="get_my_user_access_rights" dbtype="query">
                        SELECT *
                        FROM get_user_access_rights
                        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#">
                    </cfquery>
                    <td>
                        <table cellpadding="2" cellspacing="0">
                        <cfloop query="get_my_user_access_rights">
                          <tr>
                            <td>#team_id#</td>
                            <td>-</td>
                            <td nowrap="nowrap">#regionname# (#regionid#)</td>
                            <td>-</td>
                            <td nowrap="nowrap">#usertype#</td>
                          </tr>
                        </cfloop>
                        </table>
                    </td>
                </cfif>
                    <td>#businessname#</td>
                    <td>#city#</td>
                    <td>#state#</td>
                    <td>#countryname#</td>
                    <td>#phone#</td>
                </tr>
            </cfloop>
         </cfif>
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
            </tr>
        </table>

	<cfelse>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <td>No users matched your criteria.</td>
            </tr>
        </table>
    </cfif>
    
</cfif>
   
<cfinclude template="table_footer.cfm">
