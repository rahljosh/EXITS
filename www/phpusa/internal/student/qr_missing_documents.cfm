<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Missing Documents</title>
</head>

<body>

<cfif NOT IsDefined('form.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="update_missing_docs" datasource="mysql">
	UPDATE smg_students
	SET transcript = "#form.transcript#",
		language_eval = "#form.language_eval#",
		social_skills = "#form.social_skills#",
		health = "#form.health#",
		immunization = "#form.immunization#",
		minorauthorization = "#form.minorauthorization#",
		other_missing_docs = '#form.other_missing#',
		php_passport_copy = '#form.php_passport_copy#'
	WHERE uniqueid = "#form.unqid#"
	LIMIT 1
</cfquery>
</cftransaction>

<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("missing_documents.cfm?unqid=#form.unqid#");
//-->
</script>
</cfoutput>
</head>
</html> 	

<!--- <cflocation url="missing_documents.cfm?unqid=#form.unqid#" addtoken="no"> --->

</body>
</html>