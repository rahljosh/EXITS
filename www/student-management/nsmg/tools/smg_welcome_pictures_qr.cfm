<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<!--- <cfdump var="#form#"> --->
<cfloop From = "1" To = "#form.count#" Index = "x">
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
	<cfquery name="update_pictures" datasource="MySQL">
		UPDATE smg_pictures
		SET title = '#form["title" & x]#',
			description = <cfqueryparam value="#form["description" & x]#" cfsqltype="cf_sql_longvarchar">,
			active = '#form["active" & x]#'
		WHERE pictureid = '#form["pictureid" & x]#'
		LIMIT 1
	</cfquery>
	</cftransaction>
</cfloop>

<cflocation url="?curdoc=tools/smg_welcome_pictures" addtoken="no">

</body>
</html>