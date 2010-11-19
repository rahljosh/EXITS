<cfif not client.usertype LTE 4>
	You do not have access to this page.
    <cfabort>
</cfif>     

<!--- see includes/trackman.cfm for the Application.Online structure set up. --->

Click on the user's Name to see their history.<br /><br />

<table width="100%" cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Current Online Users</h2></td>
		<td width=17 background="pics/header_rightcap.gif"></td>
	</tr>
</table>

<table width="100%" class="section">
    <tr align="left">
        <th>Name</th>
        <th>Last Page Viewed</th>
        <th>Last Page Viewed At</th>
    </tr>
    <cfset currentRow = 0>
    <cfloop collection="#Application.Online#" item="ThisUser">
	    <cfset currentRow = currentRow + 1>
		<cfoutput>
        <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
            <td><a href="index.cfm?curdoc=history&userid=#ThisUser#">#application.Online[ThisUser][1]#</a></td>
            <td>#application.Online[ThisUser][3]#</td>
            <td>#DateFormat(application.Online[ThisUser][2], 'mm/dd/yyyy')# #TimeFormat(Application.Online[ThisUser][2])#</td>
        </tr>
        </cfoutput>
    </cfloop>
</table>

<table width="100%" cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>