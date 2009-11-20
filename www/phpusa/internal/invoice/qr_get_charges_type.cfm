<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Charges Type</title>
</head>

<body>

<cfquery name="get_charges_type" datasource="MySql">
	SELECT chargeid, charge
	FROM egom_charges_type
	WHERE systemid = '0' 
		OR systemid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
</cfquery>

</body>
</html>
