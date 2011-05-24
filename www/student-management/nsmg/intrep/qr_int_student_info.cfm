<cftry>

<cfoutput>

<cfif NOT isdefined('form.studentid')>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Students View - Error </h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
	</table>
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><br><h3><p>Sorry, an error has ocurred. Please try again. Thank you.</p></h3>
	<tr><td align="center"><input type="image" value="Back" onClick="history.go(-1)" src="pics/back.gif"></td></tr>
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>

<cfquery name="get_student" datasource="MySQL">
  SELECT 	s.firstname, s.familylastname, s.studentid, s.uniqueid
  FROM 	smg_students s
  WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="update_branch" datasource="MySQL">
	UPDATE smg_students
	SET branchid = '#form.branchid#'
	WHERE studentid = '#form.studentid#'
	LIMIT 1
</cfquery>

<cfif IsDefined('form.php')>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page");
			location.replace("?curdoc=intrep/int_student_info_php&unqid=#get_student.uniqueid#&assignedID=#get_student.assignedID#");
	-->
	</script>
<cfelse>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page");
			location.replace("?curdoc=intrep/int_student_info&unqid=#get_student.uniqueid#");
	-->
	</script>
</cfif>

</cfoutput>

	<cfcatch type="any">
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
				<td background="pics/header_background.gif"><h2>Students View - Error </h2></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td align="center"><br><h3><p>Sorry, an error has ocurred. Please try again. Thank you.</p></h3>
		<tr><td align="center"><input type="image" value="Back" onClick="history.go(-1)" src="pics/back.gif"></td></tr>
		</table>
		<cfinclude template="../table_footer.cfm">
	</cfcatch>
</cftry>