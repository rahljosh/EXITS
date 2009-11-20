<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Grant Access</title>
</head>

<body>

<cfquery name="get_user" datasource="MySql">
	SELECT userid, usertype
	FROM smg_users
	WHERE uniqueid = <cfqueryparam value="#url.uniqueid#" cfsqltype="cf_sql_char">
</cfquery>

<cfquery name="give_axis_access" datasource="mysql">
	INSERT INTO user_access_rights 
		(userid, companyid, usertype)
	VALUES 
		('#get_user.userid#', '6',
		<cfif get_user.usertype NEQ 0 AND get_user.usertype LTE 4>'3'<cfelse>'7'</cfif>)
</cfquery>

<cflocation url="?curdoc=users/user_info&uniqueid=#url.uniqueid#" addtoken="no">

</body>

</html>
