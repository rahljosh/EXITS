<cfform action="querys/assign_reps.cfm" method="post">

<cfinclude template="../querys/get_Student_info.cfm">

<cfquery name="host_info" datasource="caseusa">
select * 
from smg_hosts
where hostid = #get_Student_info.hostid#
</cfquery>
<Cfquery name="get_Rep_info" datasource="caseusa">
select *
from smg_users
where userid = #get_student_info.arearepid#
</Cfquery>
<cfquery name="get_place_info" datasource="caseusa">
select *
from smg_users 
where userid = #get_student_info.placerepid#
</cfquery>
<style type="text/css">
<!--
/* region table */

table.dash { font-size: 12px; border: 1px solid #202020; }
tr.dash {  font-size: 12px; border-bottom: dashed #201D3E; }
td.dash {  font-size: 12px; border-bottom: 1px dashed #201D3E;}
-->
</style> 
<span class="application_section_header">Review Placement</span>
<cfinclude template = "../family_pis_menu.cfm">
<cfoutput>
<div class="row1">
<p>	<table border=0>
<tr>
    <td rowspan="2" valign="top" width=5><span class="get_attention"><b>></b></span></td>
    <td class="dash" width=50%>Host Family</td>
    <td rowspan="4" valign="top" width=5><span class="get_attention"><b>></b></span></td>
    <td class="dash">Student [ <cfif client.usertype gt 4><A href="student_profile.cfm?studentid=#get_student_info.studentid#"><cfelse><A href="?curdoc=student_info"></cfif>view student</A> ]</td>

</tr>
<tr>
    <td valign="top">#host_info.Fatherfirstname#<cfif #host_info.fatherlastname# is #host_info.motherlastname#> and <cfelse> #host_info.fatherlastname# and </cfif> #host_info.motherfirstname#<cfif #host_info.fatherlastname# is #host_info.motherlastname#> #host_info.familylastname# <cfelse> #host_info.motherlastname# </cfif><br>

			#host_info.address#<br>
			<cfif #host_info.address2# is not ''>
			#host_info.address2#<br>
			</cfif>
			#host_info.city# #host_info.state#, #host_info.zip#
			<br>
			P: #host_info.phone#<br>
			<cfif host_info.fax is ''><cfelse>F: #host_info.fax#<br></cfif>
			E:#host_info.email#<br>
			<br>
    <td rowspan="3" valign="top">
	#get_Student_info.firstname# #get_Student_info.middlename# #get_Student_info.familylastname#<br>
	#get_Student_info.address#<Br>
	<cfif get_Student_info.address2 is ''><cfelse>#get_Student_info.address2#<br></cfif>
	#get_student_info.city# #get_student_info.country# #get_student_info.zip#<br>
	P: #get_student_info.phone#<br>
	<cfif get_student_info.fax is ''><cfelse>F: #get_student_info.fax#<br></cfif>
	<cfif get_student_info.email is ''><cfelse>E: #get_student_info.email#<br></cfif>


</tr>
</table><table>

<Tr>
	    <td rowspan="2" valign="top" width=5><span class="get_attention"><b>></b></span></td>
    <td class="dash">Place and Supervision</td>
</Tr>
<tr>
    <td valign="top">
	<table>
		<tr>
			<td align="right">Placeing:</td><Td>#get_place_info.firstname# #get_place_info.lastname# #get_place_info.userid#</Td>
		</tr>
		<tr>
			<td align="right">Supervising:</td><Td>#get_rep_info.firstname# #get_rep_info.lastname# #get_rep_info.userid#</Td>
		</tr>
	</table>
	
	</td>
</table>
</cfoutput>
</div>
<div class="row">
This student has been placed with this host family. To make any changes to the host family, please select from the menu on the left.  To review the student information,
click on 'view student' next to the heading Student.
<br>
<br>

</div>
</cfform>