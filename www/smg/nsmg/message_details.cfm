<link rel="stylesheet" href="smg.css" type="text/css">

<title>Message Details</title>
<cfquery name="message_details" datasource="#application.dsn#">
    select * 
    from smg_news_messages
    where messageid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfif message_details.companyid is not 0>
    <cfquery name="company_affected" datasource="#application.dsn#">
        select companyshort
        from smg_companies
        where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#message_details.companyid#">
    </cfquery>
<cfelse>
	<cfset company_affected.companyshort = 'All SMG Companies'>
</cfif>
<div id="information_window">
<span class="application_section_header">Message Details</span> <br>
<cfoutput query="message_Details">
<table align="Center" border=0>
	<tr>
		<td colspan=3 align="center" <cfif #messagetype# is 'alert'>bgcolor="CC0000"<cfelseif #messagetype# is 'update'>bgcolor="005B01"</cfif>><font color="white">#Ucase(messagetype)#</font></td>
	</tr>
	<tr>
		<td>Start Date: </td><td colspan=2>#DateFormat(startdate, 'mm/dd/yyyy')# at #TimeFormat(startdate, 'hh:mm:ss tt')#</td><td></td>
	</tr>
	<tr>
		<td>End Date: </td><td colspan=2>#DateFormat(expires, 'mm/dd/yyyy')# at #TimeFormat(expires, 'hh:mm:ss tt')#</td><td></td>
	</tr>
	<tr>
	<td>Message Title: </td><td colspan=2>#message#</td><td></td>
	</tr>
	<tr>
		<td valign="top">Message Details:</td><td>#replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</td>
	</tr>
	<tr>
		<td colspan=3 bgcolor="CCCCCC"></td><td></td>
	</tr>
<!--- only display companies for these users.  others don't see companies. --->
<cfif client.usertype LTE 4>	
	<tr>
		<td colspan=3>Companies Affected: <b>#company_Affected.companyshort#</b></td>
	</tr>
</cfif>
</table>
</cfoutput>
<div align="center">
<div class="button"><input name="Submit" type="image" src="pics/close.gif" align="right" border=0 onClick="javascript:window.close()"></div>