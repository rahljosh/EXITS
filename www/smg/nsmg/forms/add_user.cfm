<!--- ONLY OFFICE CAN ADD NEW USERS --->
<cfif not client.usertype LTE 5>
	you don't have access to add a user.
	<cfabort>
</cfif>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>
	<cfif not isDefined("form.usertype")>
		<cfset errorMsg = 'Please select an Access Level.'>
	<cfelse>
		<cflocation url="index.cfm?curdoc=forms/user_form&usertype=#form.usertype#" addtoken="No">
	</cfif>
</cfif>

<cfif isDefined("errorMsg")>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

<cfquery name="usertype" datasource="#application.dsn#">
	SELECT 
    	usertypeid, 
        usertype
	FROM 
    	smg_usertype
	WHERE 		
        <cfif ListFind("5,6", CLIENT.usertype)>
            <!--- Regional Manager / Regional Advisor - Only Area Representative --->
            usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
        <cfelse>
            <!--- Other users --->
              usertypeid >= <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
            AND
              usertypeid <= <cfqueryparam cfsqltype="cf_sql_integer" value="9">
         </cfif>
    ORDER BY 
    	usertypeid
</cfquery>

<!--- this table is so the form is not 100% width. --->
<table align="center">
  <tr>
    <td>

<!----Header Format Table---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>Add User</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<cfform action="index.cfm?curdoc=forms/add_user" method="POST"> 
<input type="hidden" name="submitted" value="1">

<table border=0 cellpadding=4 cellspacing=0>
    <tr valign="top">
    	<td class="label">Access Level:</td>
    	<td>
<cfoutput query="usertype">
    <cfinput type="radio" name="usertype" value="#usertypeid#" required="yes" message="Please select an Access Level."> #usertype#<br /><br />
</cfoutput>
        </td>
    </tr>
</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/continue.gif" border=0></td>
	</tr>
</table>

</cfform>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

    </td>
  </tr>
</table>
<!--- this table is so the form is not 100% width. --->
