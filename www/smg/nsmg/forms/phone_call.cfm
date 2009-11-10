<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Phone Log</title>
</head>

<body onLoad="opener.location.reload()"> 

<!---- If user is submitting call info, insert it, if not just display the form---->
<cfif isDefined('form.new')>
	<cfquery name="insert_info" datasource="#application.dsn#">
    insert into phone_call_log (fk_userid, fk_studentid, date, notes)
    				values (#client.userid#, #url.studentid#, #now()#, '#form.notes#')
    </cfquery>
</cfif>

<cfquery name="student_info" datasource="mysql">
select s.phone, s.city, s.country, s.zip, s.firstname, s.familylastname, smg_hosts.familylastname, smg_hosts.phone as host_phone,
smg_countrylist.countryname
from smg_students s
left join smg_hosts on smg_hosts.hostid = s.hostid
left join smg_countrylist on s.country = smg_countrylist.countryid
where studentid = #url.studentid#
</cfquery>

<cfquery name="phone_log" datasource="mysql">
select *, smg_users.firstname, smg_users.lastname
from phone_call_log
left join smg_users on smg_users.userid = phone_call_log.fk_userid
where fk_studentid = #url.studentid#
order by date desc
</cfquery>
<cfoutput query="student_info">
<h3>#firstname# #familylastname# from <a href="http://en.wikipedia.org/wiki/#city#" target="_top">#city#<a> #countryname#</h3>

Home Phone <font size=-1>(in #countryname#)</font>: #phone# <br />
Host Phone: #host_phone#
<Br /><br />
Make note of your call:<br />
Date/Time: #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm')# MST <br />
Contacted By: #client.name#<br />
Notes (optional):<Br />
<form method="post" action="phone_call.cfm?studentid=#url.studentid#">
<input type="hidden" name="new" />
<textarea cols="50" rows="5" name="notes"></textarea><br />
<input type="submit" value="Make Note" />
</form>
<br /><br />
History<Br />

<table width=100%>
	<tr>
    	<td>Contacted By</td><Td>Date / Time</Td><td>Comments</td>
    </tr>
    <cfif phone_log.recordcount eq 0>
    <tr>
    	<td colspan="3" align="center">No call history found. Be the first to log a call!</td>
    </tr>
    </cfif>
 <cfloop query="phone_log">   
 	
 	<tr>
    	<td valign="top">#firstname# #lastname#</td><td valign="top">#DateFormat(date, 'mm/dd/yy')# at #TimeFormat(date, 'hh:mm tt')#</td><td valign="top">#notes#</td>
    </tr>
</cfloop>
</cfoutput>
</body>
</html>