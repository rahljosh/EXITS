<style type="text/css">
<!--
.usertype {
	font-size: 13px;
	font-weight: bold;
	background-color: #eeeeee;
	line-height: 25px;
}
.fav_no {
	font-size: 27px;
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
	color: #cccccc;
}
.fav_yes {
	font-size: 27px;
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
	color: #F60;
}
-->
</style>

<!--- add favorite --->
<cfif isDefined("url.add_fav")>
	<!--- if they click twice they can add the favorite twice and get two reports on the list. --->
    <cfquery name="check_fav" datasource="#application.dsn#">
        SELECT *
        FROM smg_report_favorites
        WHERE fk_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.add_fav#">
        AND fk_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
    <cfif check_fav.recordCount EQ 0>
        <cfquery datasource="#application.dsn#">
            INSERT INTO smg_report_favorites (fk_report, fk_user)
            VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#url.add_fav#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            )  
        </cfquery>
    </cfif>
<!--- remove favorite --->
<cfelseif isDefined("url.remove_fav")>
    <cfquery datasource="#application.dsn#">
        DELETE FROM smg_report_favorites
        WHERE fk_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.remove_fav#">
        AND fk_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
</cfif>

<!--- this is turned on/off on the tools/reports page. --->
<cfparam name="client.report_maintenance" default="0">

<cfparam name="submitted" default="0">
<cfparam name="favorite" default="Yes">
<cfparam name="usertype_category" default="">
<cfparam name="keyword" default="">
<cfparam name="report_active" default="1">
<cfparam name="recordsToShow" default="25">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>
        	Reports
            <cfif client.report_maintenance>
            	- Report Maintenance is turned on.  <a href="index.cfm?curdoc=tools/reports">Click here</a> for the tools page.
            </cfif>
        </h2></td>
        <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=reports/index">Old Reports</a></td>
        <!--- only global gets this link because to add a report you also need to add the ColdFusion template. --->
		<cfif client.report_maintenance and client.usertype EQ 1>
            <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=tools/report_form">Add Report</a></td>
        </cfif>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfform action="index.cfm?curdoc=reports" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
        <td>
            Favorite<br />
            <select name="favorite">
            	<option value="">All</option>
                <option <cfif favorite EQ 'Yes'>selected</cfif>>Yes</option>
                <option <cfif favorite EQ 'No'>selected</cfif>>No</option>
            </select>            
        </td>
        <td>
            <cfquery name="get_usertype_category" datasource="#application.dsn#">
                SELECT DISTINCT smg_usertype.usertypeid, smg_usertype.usertype AS usertypename,
                	smg_report_categories.report_category_id, smg_report_categories.report_category_name
                FROM smg_reports
                INNER JOIN smg_usertype ON smg_reports.fk_usertype = smg_usertype.usertypeid
                INNER JOIN smg_report_categories ON smg_reports.fk_report_category = smg_report_categories.report_category_id
                WHERE smg_reports.report_active = 1
                AND smg_reports.fk_usertype >= <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
                ORDER BY smg_reports.fk_usertype, smg_report_categories.report_category_name
            </cfquery>
            Level - Category<br />
			<select name="usertype_category">
                <option value="">All</option>
            	<cfoutput query="get_usertype_category" group="usertypeid">
                  <option value="#usertypeid#" <cfif usertype_category EQ '#usertypeid#'>selected</cfif>>Reports Available for #usertypename# and Above</option>
                    <cfoutput>
                   		<option value="#usertypeid#,#report_category_id#" <cfif usertype_category EQ '#usertypeid#,#report_category_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#report_category_name#</option>
                    </cfoutput>
                </cfoutput>
			</select>
			<!---<cfquery name="get_categories" datasource="#application.dsn#">
                SELECT *
                FROM smg_report_categories
                ORDER BY report_category_name
            </cfquery>
            Category<br />
			<cfselect name="report_category_id" query="get_categories" value="report_category_id" display="report_category_name" selected="#report_category_id#" queryPosition="below">
				<option value="">All</option>
			</cfselect>--->
        </td>
        <td>
            Keyword<br />
			<cfinput type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
        </td>
        <cfif client.report_maintenance>
            <td>
                Active<br />
                <select name="report_active">
                    <option value="">All</option>
                    <option value="1" <cfif report_active EQ 1>selected</cfif>>Yes</option>
                    <option value="0" <cfif report_active EQ 0>selected</cfif>>No</option>
                </select>            
            </td>
        </cfif>
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

<cfquery name="getResults" datasource="#application.dsn#">
    SELECT smg_reports.*, smg_usertype.usertype AS usertypename, smg_report_categories.report_category_name, smg_report_favorites.fk_report AS isfavorite
    FROM smg_reports
    INNER JOIN smg_usertype ON smg_reports.fk_usertype = smg_usertype.usertypeid
    INNER JOIN smg_report_categories ON smg_reports.fk_report_category = smg_report_categories.report_category_id
    LEFT JOIN smg_report_favorites ON (
        smg_reports.report_id = smg_report_favorites.fk_report
        AND smg_report_favorites.fk_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    )
    WHERE smg_reports.fk_usertype >= <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
    <!--- if report maintenance is turned on they're using the active selection, else hard coded for active. --->
    <cfif client.report_maintenance>
        <cfif report_active NEQ ''>
            AND smg_reports.report_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#report_active#">
        </cfif>
    <cfelse>
        AND smg_reports.report_active = 1
    </cfif>
    <cfif favorite NEQ ''>
        <cfif favorite EQ 'Yes'>
            AND smg_report_favorites.fk_report IS NOT NULL
        <cfelseif favorite EQ 'No'>
            AND smg_report_favorites.fk_report IS NULL
        </cfif>
    </cfif>
    <cfif usertype_category NEQ ''>
        AND smg_reports.fk_usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#listFirst(usertype_category)#">
        <cfif listLen(usertype_category) EQ 2>
            AND smg_reports.fk_report_category = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(usertype_category)#">
        </cfif>
    </cfif>
    <cfif trim(keyword) NEQ ''>
        AND (
            smg_reports.report_name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
            OR smg_reports.report_description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
        )
    </cfif>
    ORDER BY smg_reports.fk_usertype, smg_report_categories.report_category_name, smg_reports.report_name
</cfquery>

<cfif getResults.recordCount GT 0>

    <cfif client.report_maintenance>
        <cfquery name="count_favorites" datasource="#application.dsn#">
            SELECT fk_report, COUNT(*) AS fav_count
            FROM smg_report_favorites
            GROUP BY fk_report
        </cfquery>
    </cfif>

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
    <cfset urlVariables = "submitted=1&favorite=#favorite#&usertype_category=#usertype_category#&keyword=#urlEncodedFormat(keyword)#&report_active=#report_active#&recordsToShow=#recordsToShow#">

    <cfoutput>

    <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
        <tr align="center">
            <td>
                <cfif totalPages GT 1>
                    <cfif url.startPage NEQ 1>
                        <a href="index.cfm?curdoc=reports&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                    </cfif>
                    <cfloop from="1" to="#totalPages#" index="i">
                        <cfif i is url.startPage>#i#<cfelse><a href="index.cfm?curdoc=reports&startPage=#i#&#urlVariables#">#i#</a></cfif>
                    </cfloop>
                    <cfif isNextPage>
                        &nbsp; <a href="index.cfm?curdoc=reports&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                    </cfif>
                    <br>
                </cfif>
                Displaying #startrow# to #endrow# of #getResults.recordCount#
            </td>
        </tr>
    </table>

    <table width=100% cellspacing="0" cellpadding="4" class="section">
        <cfset myCurrentRow = 0>
        <cfset current_usertype = ''>
        <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
            <cfset myCurrentRow = myCurrentRow + 1>
            <cfif fk_usertype NEQ current_usertype>
                <cfset myCurrentRow = 1>
                <cfset current_usertype = fk_usertype>
                <tr align="left">
                    <th colspan="7" class="usertype">&nbsp;Reports Available for #usertypename# and Above</th>
                </tr>
                <tr align="left">
                    <cfif client.report_maintenance>
                        <th>&nbsp;</th>
                    </cfif>
                    <th align="center">Favorite</th>
                    <th>Category</th>
                    <th>Report Name</th>
                    <th>Description</th>
                    <cfif client.report_maintenance>
                        <th>Active</th>
                        <th>Number of Favorites</th>
                    </cfif>
                </tr>
            </cfif>
            <tr bgcolor="#iif(myCurrentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <cfif client.report_maintenance>
                    <td align="center">
                        <!--- edit report --->
                        <form action="index.cfm?curdoc=tools/report_form" method="post">
                        <input type="hidden" name="report_id" value="#report_id#">
                        <input name="Submit" type="image" src="pics/edit.png" alt="Edit Report" border=0>
                        </form>
                    </td>
                </cfif>
                <td align="center">
                	<!--- old buttons: <font class="fav_yes">*</font> <font class="fav_no">*</font> --->
                    <cfif isfavorite NEQ ''>
                        <a href="index.cfm?curdoc=reports&remove_fav=#report_id#&startPage=#url.startPage#&#urlVariables#" title="Remove Favorite" onClick="return confirm('Are you sure you want to remove this Favorite?')"><img src="pics/round_button_on.png" border="0" /></a>
                    <cfelse>
                        <a href="index.cfm?curdoc=reports&add_fav=#report_id#&startPage=#url.startPage#&#urlVariables#" title="Add Favorite"><img src="pics/round_button_off.png" border="0" /></a>
                    </cfif>
                </td>
                <td><strong>#report_category_name#</strong></td>
                <td><a href="index.cfm?curdoc=reports_new/#report_template#">#report_name#</a></td>
                <td>#replaceList(report_description, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</td>
                <cfif client.report_maintenance>
                    <cfquery name="get_count" dbtype="query">
                        SELECT fav_count
                        FROM count_favorites
                        WHERE fk_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#report_id#">
                    </cfquery>
                    <td>#yesNoFormat(report_active)#</td>
                    <td>#numberFormat(get_count.fav_count)#</td>
                </cfif>
            </tr>
        </cfloop>
    </table>
           
    </cfoutput>
<cfelse>
    <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
        <tr>
            <th><br />
            	<!--- since favorites is the default search selection, give special message to users coming here for the first time who would get no results. --->
                <cfif favorite NEQ '' and usertype_category EQ '' and trim(keyword) EQ ''>
                	You have no favorites selected.  Select Favorite=All and click Submit, then click the Favorites column to add favorites.
                <cfelse>
                    No reports matched your criteria.
                </cfif>
            </th>
        </tr>
    </table>
</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>