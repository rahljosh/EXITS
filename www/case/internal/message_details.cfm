<link rel="stylesheet" href="smg.css" type="text/css">

<title>Message Details</title>
<cfquery name="message_details" datasource="caseusa">
select * 
from smg_news_messages
where messageid = #url.id#
</cfquery>
<cfif #message_details.companyid# is not 0>
<Cfquery name="company_affected" datasource="caseusa">
select companyshort
from smg_companies
where companyid = #message_details.companyid#
</Cfquery>
<cfelse>
<cfset company_affected.companyshort = 'All SMG Companies'>
</cfif>
<div id="information_window">
<span class="application_section_header">Message Details</span> <br>
<cfoutput query="message_Details">
<table align="Center" border=0>
	<tr>
		<td colspan=3 align="center" <cfif #messagetype# is 'alert'>bgcolor="CC0000"<cfelseif #messagetype# is 'update'>bgcolor="005B01"<cfelse></cfif>><font color="white">#Ucase(messagetype)#</font></td>
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
		<td valign="top">Message Details:</td><td>#details#</td>
	</tr>
	<tr>
		<td colspan=3 bgcolor="CCCCCC"></td><td></td>
	</tr>
	
	<tr>
		<td colspan=3>Companies Affected: <b>#company_Affected.companyshort#</b></td>
	</tr>
</table>
</cfoutput>
<div align="center">
<div class="button"><input name="Submit" type="image" src="pics/close.gif" align="right" border=0 onClick="javascript:window.close()"></div>