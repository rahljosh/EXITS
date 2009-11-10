<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<cfquery name="get_users" datasource="MySQL">
	SELECT DISTINCT  smg_students.studentid, smg_students.placerepid, smg_students.arearepid,
		smg_users.userid, smg_users.firstname, smg_users.lastname, smg_users.address, smg_users.address2, smg_users.city, 
		smg_users.state, smg_users.zip, smg_users.usertype
	FROM smg_users, smg_students
		WHERE smg_students.active = '1'
		AND smg_users.active = '1'
		AND smg_users.usertype between '5' and '7'
		AND (smg_students.arearepid = smg_users.userid or smg_students.placerepid = smg_users.userid)
	GROUP BY smg_users.userid
	ORDER BY smg_users.firstname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=smg_users.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
	<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<td>First Name</td>
		<td>Last Name</td>
		<td>Address</td>
		<td>City</td>
		<td>State</td>
		<td>Zip</td>
	</tr>
</cfoutput>
<cfoutput query="get_users">
	<tr>
		<td>#FirstName#</td>
		<td>#lastname#</td>
		<td><cfif #address# is ''>#Address2#<cfelse>#Address#</cfif></td>
		<td>#City#</td>
		<td>#State#</td>
		<td>#ZIP#</td>
	</tr>
</cfoutput>
<cfoutput>
	</table>
</cfoutput> 