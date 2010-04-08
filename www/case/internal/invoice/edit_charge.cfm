<link rel="stylesheet" href="../../smg.css" type="text/css">

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<form method="post" action="edit_charge_query.cfm" >

<cfoutput> 
<cfquery name="charge_type" datasource="caseusa">
select type, description
from smg_charge_type
</cfquery>
<div class="application_section_header">Change Charges already on Account</div><br>
<input type="hidden" name=chargeid value=#url.chargeid# onSubmit="setTimeout('window.close',5000)">
</cfoutput>
<cfquery name="get_charges" datasource="caseusa">
select *
from smg_charges
where chargeid = #url.chargeid#
</cfquery>
<br />

<cfoutput query="get_charges">
<Cfquery name="student_name" datasource="caseusa">
select firstname, familylastname
from smg_students
where studentid = #stuid#
</Cfquery>
<h2>Student: #student_name.firstname# #student_name.familylastname# (#stuid#)</h2>
Type: 	<select name="type">
		<cfloop query="charge_type">
		<option value="#type#" <cfif get_charges.type is #type#>selected</cfif>>#type#</option>
		</cfloop>
		</select>
 Description: <input type="text" name="description" size=25 value='#description#'>  Amount: <input type="text" name="amount" size=8 value=#amount#>
 <br><br>
 
<input type="checkbox" name="delete" value=#chargeid#>Delete this charge. <font size=-2><i>This is unreversable</i></font>
 <div class="button"> <input name="submit" type="image" src="../../pics/update.gif" align="right" border=0></div><br><Br>
 <font size=-2>you can not just change the student, you have to delete this charge and then re-charge the correct student.</font>
</cfoutput>
 </form>