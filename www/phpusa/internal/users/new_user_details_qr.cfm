<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Update User INFO</title>
</head>

<body>

<cfif IsDefined('form.assignschool')>
	<cfloop list="#form.assignschool#" index="i">
		<cfquery name="add_schools" datasource="mysql">
			INSERT INTO php_school_contacts (schoolid, userid)
			VALUES ('#i#', '#form.userid#')
		</cfquery>
	</cfloop>
</cfif>

<cflocation url="index.cfm?curdoc=users/user_info&userid=#form.userid#" addtoken="no">
</body>
</html>