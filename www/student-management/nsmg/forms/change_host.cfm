<link rel="stylesheet" href="smg.css" type="text/css">
<cfif not isDefined('url.change')>
	<cfset url.change = 0>
	<cfset form.results = "null">
	<cfset url.available_families = 0>
	<cfset form.available_families = 0>	
</cfif>

<cfif url.change is 1 and form.reason is not ''>
<cfquery name="school_info" datasource="MySQL">
select schoolid
from smg_hosts
where hostid = #form.available_families#
</cfquery>

<cfif #form.available_families# is 0> <!--- change to unplaced --->
<cfquery name="change_host" datasource="MySQL"> 
update smg_students
set hostid = #form.available_families#,
	schoolid = 0,
	doubleplace = '0',
	arearepid = '0',
	placerepid = '0'
where studentid = #client.studentid#
</cfquery>
<cfelse> <!--- change host --->
<cfquery name="change_host" datasource="MySQL">
update smg_students
set hostid = #form.available_families#,
	schoolid = #school_info.schoolid#,
	doubleplace = '0',
	arearepid = '0',
	placerepid = '0'
where studentid = #client.studentid#
</cfquery>
</cfif>

<cfquery name="change_reason" datasource="MySQL"> <!--- host history --->
insert into smg_hosthistory	(hostid, studentid, reason, dateofchange, arearepid, placerepid)
	values(#url.hostid#, #url.studentid#, "#form.reason#", #now()#, #url.arearepid#, #url.placerepid#)
</cfquery>
The host family has been changed.
<cflocation url="../host_info.cfm?studentid=#client.studentid#&hostid=#form.available_families#&region=#url.region#&studentname=#url.studentname#&regionname=#url.regionname#&arearepid=#url.arearepid#&placerepid=#url.placerepid#&reload=parent" addtoken="no">	


<cfelse>
<cfquery name="get_Available_hosts" datasource="MySQL">
select hostid, familylastname, fatherfirstname, motherfirstname, fatherlastname, motherlastname
from smg_hosts
where regionid = #url.region#
</cfquery>
<cfoutput>
<span class="application_section_header">Change Host Family</span><br>
<br>

The following families in the #url.regionname# are available to host a student: <br>
</cfoutput>
<cfform action="../forms/change_host.cfm?studentid=#client.studentid#&hostid=#url.hostid#&region=#url.region#&studentname=#url.studentname#&regionname=#url.regionname#&arearepid=#url.arearepid#&placerepid=#url.placerepid#&change=1" method="post">
<cfselect name="available_families">
<option value=0>change to unplaced</option>
<cfoutput query="get_Available_hosts">
<cfif url.change is 1>
	<cfif #form.available_families# is #hostid#><option value=#hostid# selected>#fatherfirstname# <cfif #motherlastname# is #fatherlastname#><cfelse>#fatherlastname#</cfif> and #motherfirstname#<cfif #motherlastname# is #fatherlastname#> #familylastname#<cfelse> #motherlastname#</cfif> </option>
	<cfelse>
	<option value=#hostid#>#fatherfirstname# <cfif #motherlastname# is #fatherlastname#><cfelse>#fatherlastname#</cfif> and #motherfirstname#<cfif #motherlastname# is #fatherlastname#> #familylastname#<cfelse> #motherlastname#</cfif> </option>
	</cfif>
	<cfelse>
<option value=#hostid#>#fatherfirstname# <cfif #motherlastname# is #fatherlastname#><cfelse>#fatherlastname#</cfif> and #motherfirstname#<cfif #motherlastname# is #fatherlastname#> #familylastname#<cfelse> #motherlastname#</cfif> </option>
</cfif>
</cfoutput>
</cfselect>
<br>
<br>

<cfif url.change is 1><font color="red">YOU MUST INCLUDE A REASON FOR CHANGING THE FAMILY:<cfelse>Please indicate why you are changing the host family:</cfif><br>
<textarea cols=50 rows=10 name="reason"></textarea>

<table>
	<Tr>
		<td align="right" width="50%"><br><input type="submit" value="change host">&nbsp;&nbsp;</td><td align="left" width="50%"></</cfform><Br>&nbsp;&nbsp;
<input type="button" value="close window" onClick="javascript:window.close()"></td>
	</tr>
</table>
</cfif>