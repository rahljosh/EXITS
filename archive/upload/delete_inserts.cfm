<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Delete File</title>
</head>

<body>

<cftry>

    <cfdirectory directory="#AppPath.onlineApp.inserts##url.doc#" name="file" filter="#url.student#.*">	
    
    <cffile action="delete" file="#AppPath.onlineApp.inserts##url.doc#/#file.name#">

	<cfoutput>
    
    <script language="JavaScript">
    <!-- 
    alert("You have successfully deleted the uploaded file.");
        location.replace("http://www.student-management.com/exits/student_app/index.cfm?curdoc=#url.ref#&id=#url.id#&p=#url.p#");
    //-->
    </script>
    
    </cfoutput>

    <cfcatch type="any">
        <cfinclude template="error_message.cfm">	
    </cfcatch>

</cftry>	

</body>
</html>