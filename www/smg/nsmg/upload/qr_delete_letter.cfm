<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Delete Letter</title>
</head>

<body>
<!----
<cftry>
---->
<cfdirectory directory="/var/www/smg_upload_files/letters/#url.type#" name="file" filter="#url.student#.*">	

<cffile action="delete" file="/var/www/smg_upload_files/letters/#url.type#/#file.name#">

<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully deleted the uploaded file.");
	location.replace("http://www.student-management.com/nsmg/student_app/index.cfm?curdoc=#url.ref#&id=#url.id#&p=#url.p#");
//-->
</script>
</cfoutput>
</head>
</html>	
<!----
<cfcatch type="any">
	<cfinclude template="error_message.cfm">	
</cfcatch>
</cftry>			
---->
</body>
</html>