<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Menu</title>
</head>

<body>
<cftry>

<cfoutput>
<div id="subMenuNav">
	<div id="subMenuLinks">  
		<a href="?curdoc=student/student_info&unqid=#get_student_unqid.uniqueid#">Overview</a>  
		<a href="?curdoc=student/student_form1&unqid=#get_student_unqid.uniqueid#">1 &nbsp; - &nbsp; Student Info</a>  
		<a href="?curdoc=student/student_form2&unqid=#get_student_unqid.uniqueid#">2 &nbsp;- &nbsp; Family Info</a>
		<a href="?curdoc=student/student_form3&unqid=#get_student_unqid.uniqueid#">3 &nbsp;- &nbsp; Siblings</a>
		<a href="?curdoc=student/student_form4&unqid=#get_student_unqid.uniqueid#">4 &nbsp;- &nbsp; Activities & Interests</a>
		<a href="?curdoc=student/student_form5&unqid=#get_student_unqid.uniqueid#">5 &nbsp;- &nbsp; Religious Participation</a>
		<a href="?curdoc=student/student_form6&unqid=#get_student_unqid.uniqueid#">6 &nbsp;- &nbsp; Allergies/Curfew</a> 
		<a href="?curdoc=student/student_form7&unqid=#get_student_unqid.uniqueid#">7 &nbsp;- &nbsp; School Info</a>
	</div>
</div>
</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>