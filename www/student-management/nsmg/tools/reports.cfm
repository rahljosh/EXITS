<cfif not client.usertype LTE 4>
	<h3>You do not have access to this page.</h3>
    <cfabort>
</cfif>

<cfparam name="form.r_action" default="">
<cfswitch expression="#form.r_action#">
    <!--- turn report maintenance on. --->
    <cfcase value="report_maintenance_on">
        <cfset client.report_maintenance = 1>
    </cfcase>
    <!--- turn report maintenance off. --->
    <cfcase value="report_maintenance_off">
        <cfset client.report_maintenance = 0>
    </cfcase>
    <!--- delete category. --->
    <cfcase value="delete_category">
        <cfquery datasource="#application.dsn#">
            DELETE FROM smg_report_categories
            WHERE report_category_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.report_category_id#">
        </cfquery>
    </cfcase>
</cfswitch>

<cfparam name="client.report_maintenance" default="0">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>Report Maintenance</h2></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td>
        
        <p>To edit reports, turn Report Maintenance on here, and then go to the <a href="index.cfm?curdoc=reports">reports page</a>.</p>
        
		<p>When turned on, the following will be available on the reports page:</p>
        <ul>
        	<li>Edit links.</li>
        	<li><em>Active</em> column and search selection.</li>
        	<li><em>Number of Favorites</em> column, indicating how many users have each report selected as a favorite.</li>
		</ul>
        
        <cfif client.report_maintenance>
        	<p><b>Report Maintenance is turned on.</b></p>
            <center>
            <form action="index.cfm?curdoc=tools/reports" method="post">
            <input type="hidden" name="r_action" value="report_maintenance_off">
            <input type="submit" value="Turn Report Maintenance Off" />
            </form>
            </center>
        <cfelse>
        	<p><b>Report Maintenance is turned off.</b></p>
            <center>
            <form action="index.cfm?curdoc=tools/reports" method="post">
            <input type="hidden" name="r_action" value="report_maintenance_on">
            <input type="submit" value="Turn Report Maintenance On" />
            </form>
            </center>
        </cfif>
        
        </td>
    </tr>
</table>
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

<br />

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>Report Category Maintenance</h2></td>
   	    <td background="pics/header_background.gif" align="right">
			<!--- add category --->
            <form action="index.cfm?curdoc=tools/report_category_form" method="post">
            <input name="Submit" type="image" src="pics/new.gif" alt="Add Report Category" border=0>
            </form>
        </td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfquery name="getResults" datasource="#application.dsn#">
    SELECT report_category_id, report_category_name, COUNT(fk_report_category) AS count
    FROM smg_report_categories
    LEFT JOIN smg_reports ON smg_report_categories.report_category_id = smg_reports.fk_report_category
    GROUP BY report_category_id, report_category_name
    ORDER BY report_category_name
</cfquery>

<cfif getResults.recordCount GT 0>

    <table width=100% class="section">
        <tr align="left">
            <th>&nbsp;</th>
            <th>&nbsp;</th>
            <th>Category</th>
            <th>Number of Reports</th>
        </tr>
        <cfoutput query="getResults">
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td>
                	<!--- only allow delete if this category isn't assigned to any reports. --->
                    <cfif count EQ 0>
						<!--- delete category --->
                        <form action="index.cfm?curdoc=tools/reports" method="post" onclick="return confirm('Are you sure you want to delete this Category?')">
                        <input type="hidden" name="r_action" value="delete_category">
                        <input type="hidden" name="report_category_id" value="#report_category_id#">
                        <input name="Submit" type="image" src="pics/deletex.gif" alt="Delete Report Category" border=0>
                        </form>
                    </cfif>
                </td>
                <td>
                	<!--- edit category --->
                    <form action="index.cfm?curdoc=tools/report_category_form" method="post">
                    <input type="hidden" name="report_category_id" value="#report_category_id#">
                    <input name="Submit" type="image" src="pics/edit.png" alt="Edit Report Category" border=0>
                    </form>
                </td>
                <td>#report_category_name#</td>
                <td>#count#</td>
            </tr>
        </cfoutput>
    </table>
           
<cfelse>
    <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
        <tr>
            <td>There are no report categories.</td>
        </tr>
    </table>
</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>