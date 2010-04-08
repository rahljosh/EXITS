<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>
<cfquery name="error_report" datasource="caseusa">
select students.studentid, status.status, status.reason, status.date
from smg_students students,  smg_student_app_status status
where students.studentid  = status.studentid
and students.intrep = 19 and status.reason <> ''
order by students.studentid, status.status
</cfquery>

select a.*
from a, b
where a.user_id = b.u
<cfdump var=#error_report#>
</body>
</html>
