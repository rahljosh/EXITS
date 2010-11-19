<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Help Desk</title>
</head>

<body>

<cftransaction action="begin" isolation="SERIALIZABLE">

<cfloop From = "1" To = "#form.count#" Index = "x">
 
	<Cfquery name="update_sections" datasource="mySQL">
	UPDATE  smg_help_desk_section 
		SET  assignedid = '#Evaluate("form." & x & "_userid")#'
	WHERE sectionid = '#Evaluate("form." & x & "_sectionid")#'
	</Cfquery>
	
</cfloop> 
</cftransaction>
<cflocation url="?curdoc=helpdesk/help_desk_sections" addtoken="no">

</body>
</html>
