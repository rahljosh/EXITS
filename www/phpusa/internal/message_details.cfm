<link rel="stylesheet" href="phpusa.css" type="text/css">
<title>Message Details</title>
<cfquery name="message_details" datasource="mysql">
    select * 
    from smg_news_messages
    where messageid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfoutput query="message_Details">
<table width="98%" border="1" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
  <tr>
    <td bgcolor="##FFFFFF" class="box" align="center"><font size="2"><b>Message Details</b></font></td>
  </tr>
  <tr>
    <td class="box">
    <table align="Center" border=0 bgcolor="##ffffff">
        <tr>
            <td colspan=3 align="center" <cfif messagetype is 'alert'>bgcolor="CC0000"<cfelseif messagetype is 'update'>bgcolor="005B01"<cfelse></cfif>><font color="white">#Ucase(messagetype)#</font></td>
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
    </table>
	</td>
  </tr>
  <tr>
    <td bgcolor="##FFFFFF" class="box" align="center"><span class="button">
        <input name="Submit" type="image" onClick="javascript:window.close()" src="pics/close.gif" border=0>
    </span></td>
  </tr>
</table>
</cfoutput>