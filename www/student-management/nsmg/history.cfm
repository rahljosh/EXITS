<cfif not client.usertype LTE 6>
	You do not have access to this page.
    <cfabort>
</cfif>     

<cfquery name="history" datasource="#application.dsn#">
    SELECT *
    FROM smg_user_tracking
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    ORDER BY time_viewed DESC
</cfquery>

<cfquery name="get_user" datasource="#application.dsn#">
	SELECT firstname, middlename, lastname, userid
	FROM smg_users
	WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
</cfquery>

Pages user has viewed over the past 3 days...<br><br />

<table width="100%" cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>User History for <cfoutput query="get_user"><a href="index.cfm?curdoc=user_info&userid=#userid#">#firstname# #middlename# #lastname# - #userid#</a></cfoutput></h2></td>
		<td width=17 background="pics/header_rightcap.gif"></td>
	</tr>
</table>

<table width="100%" class="section">
    <tr align="left">
        <th nowrap="nowrap">Page Viewed</th>
        <th nowrap="nowrap">Time Viewed</th>
        <th>&nbsp;&nbsp;</th>
        <th nowrap="nowrap">IP Viewed From</th>
    </tr>
    <cfoutput query="history">
        <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
            <td>#page_viewed#</td>
            <td nowrap="nowrap">#DateFormat(time_viewed, 'mm/dd/yyyy' )# #TimeFormat(time_viewed)#</td>
            <td>&nbsp;&nbsp;</td>
            <td>#ip#</td>
        </tr>
    </cfoutput>
</table>

<table width="100%" cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
