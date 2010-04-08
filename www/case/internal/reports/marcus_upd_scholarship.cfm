<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<!----
<cfoutput>
<cfquery name="get_scholarship" datasource="caseusa">
	SELECT * 
	FROM smg_students2 s 
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE scholarship =1 and s.active = '1' and p.smgseasonid = '3'
</cfquery>

<cfloop query="get_scholarship">

	<cfquery name="update" datasource="caseusa">
		UPDATE smg_students
		SET scholarship = '1'
		WHERE studentid = '#get_scholarship.studentid#'
		LIMIT 1
	</cfquery>

	#get_scholarship.studentid#<br>
	
</cfloop>
Total: #get_scholarship.recordcount#
</cfoutput>
--->

</body>
</html>
