<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Delete File</title>
</head>

<body>



<cffile action = "delete" file = "/var/www/html/case/internal/uploadedfiles/web-students/#url.studentid#.jpg">

<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully deleted the picture for this student.");
	location.replace("?curdoc=student_info&studentid=#url.studentid#");
-->
</script>
</cfoutput>
</head>
</html> 				
	
</body>
</html>






<!----


<cffile action="rename" destination="/var/www/html/student-management/nsmg/uploadedfiles/web-students/#url.student#_delete" source="/var/www/html/student-management/nsmg/uploadedfiles/web-students/#url.student#"> 
<cflocation url="index.cfm?curdoc=student_info&studentid=#url.studentid#">

---->