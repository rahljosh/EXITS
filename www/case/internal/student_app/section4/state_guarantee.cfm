<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>SMG State Guarantee</title>
</head>

<body>
<cfquery name="check_for_agreement" datasource="caseusa">
select id
from smg_student_app_state_requested
where studentid = #client.studentid#
</cfquery>

<!---if state request is already present, update, otherwise, insert new record---->

<cfif check_for_agreement.recordcount gt 0>

		<Cfquery name="update_States" datasource="caseusa">
		update smg_student_app_state_requested set studentid = #client.studentid#,
													 state1 = #form.state1#,
													 state2 = #form.state2#,
													 state3 = #form.state3#
												where studentid = #client.studentid#
		</Cfquery>
<cfelse>
				<Cfquery name="add_States" datasource="caseusa">
		insert into smg_student_app_state_requested (studentid, state1, state2, state3)
											values(#client.studentid#, #form.state1#, #form.state2#, #form.state3#)
		</Cfquery>
</cfif>

<cfquery name="get_student_info" datasource="caseusa">
select smg_students.city, smg_students.country, smg_countrylist.countryname, smg_students.firstname, smg_students.familylastname,smg_students.sex
from smg_students right join smg_countrylist on smg_students.country = smg_countrylist.countryid
where studentid = #client.studentid# 
</cfquery>

<cfif get_student_info.sex is 'male'>
	<cfset sd='son'>
	<cfset hs='he'>
	<cfset hh='his'>
<cfelse>
	<cfset sd='daughter'>
	<cfset hs='she'>
	<cfset hh='her'>
</cfif>

<cfquery name="states_requested" datasource="caseusa">
select smg_student_app_state_requested.state1, 
	smg_student_app_state_requested.state2, 
	smg_student_app_state_requested.state3
from smg_student_app_state_requested 
where studentid = #client.studentid#
</cfquery>



<cfdocument format="pdf">
<cfoutput>
<h2>State Gurantee</h2>
<h3>Student's Name: #get_student_info.firstname# #get_student_info.familylastname#</h3>
<cfinclude template="state_guarantee_text.cfm">
<br><br>

Please place me in one of the states listed below:
<br>
<br>
<cfquery name="state_name1" datasource="caseusa">
select statename
from smg_States 
where id = #states_requested.state1#
</cfquery>
Choice 1: #state_name1.statename#<br>
<cfquery name="state_name2" datasource="caseusa">
select statename
from smg_States 
where id = #states_requested.state2#
</cfquery>
Choice 2: #state_name2.statename#<br>
<cfquery name="state_name3" datasource="caseusa">
select statename
from smg_States 
where id = #states_requested.state3#
</cfquery>
Choice 3: #state_name3.statename#
</cfoutput>

<br><br><br><br>
<table>
	<tr>
		<Td>
_________________________</td><td> _____/_____/_____</td><td width=15></td><td>__________________________</td><td> _____/_____/_____</td>
</tr>
<tr>
<td>
Signature of Parent</td><td> Date</Td><td width=15></td>
<td>

Signature of Student</td><td>Date
</td>
	</tr>
</table>
</cfdocument>
</body>
</html>

