<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Update Help Desk Sections</title>
</head>

<body>

<cftry>

<cftransaction action="begin" isolation="SERIALIZABLE">

	<cfloop From = "1" To = "#form.count#" Index = "x">
		<Cfquery name="update_sections" datasource="mySQL">
			UPDATE  smg_help_desk_section 
				SET sectionname = '#Evaluate("form." & x & "_sectionname")#',
					assignedid = '#Evaluate("form." & x & "_userid")#'
			WHERE sectionid = '#Evaluate("form." & x & "_sectionid")#'
		</Cfquery>
	</cfloop> 
	
</cftransaction>

<html>
<head>
<script language="JavaScript">
	<!-- 
	alert("Help Desk Sections Updated! Thank You.");
	<!-- 
	location.replace("?curdoc=helpdesk/sections");
	-->
</script>
</head>
</html> 

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>