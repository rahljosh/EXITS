<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cftransaction action="begin" isolation="SERIALIZABLE">

<cfloop From = "1" To = "#form.count#" Index = "x">
	<cfquery name="update_tuitions" datasource="MySql">
	 UPDATE php_schools
	 SET tuition_year = <cfif Evaluate("FORM." & x & "_tuition_year") EQ ''>NULL<cfelse>'#Evaluate("FORM." & x & "_tuition_year")#'</cfif>,
	 	tuition_semester = <cfif Evaluate("FORM." & x & "_tuition_semester") EQ ''>NULL<cfelse>'#Evaluate("FORM." & x & "_tuition_semester")#'</cfif>,	
		boarding_school = '#Evaluate("FORM." & x & "_boarding_school")#'
	WHERE schoolid = '#Evaluate("FORM." & x & "_schoolid")#'
	LIMIT 1
	</cfquery>
</cfloop>

</cftransaction>

<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("?curdoc=invoice/school_tuition");
-->
</script>

</body>
</html>