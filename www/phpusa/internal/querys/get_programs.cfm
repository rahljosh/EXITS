<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Get Programs</title>
</head>

<body>

<cfset end_prog = #DateAdd('d','-30','#now()#')#>


<cfquery name="get_programs" datasource="mysql">
	SELECT *
	FROM smg_programs
	WHERE companyid = '6' 
		AND enddate > #end_prog#
	ORDER BY programname
</cfquery>


</body>
</html>
