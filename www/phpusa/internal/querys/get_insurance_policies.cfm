<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance Policies</title>
</head>

<body>

<cfquery name="get_insurance_policies" datasource="MySql">
	SELECT insutypeid, type
	FROM smg_insurance_type
	<!--- show only policies filter by a provider --->
	<cfif IsDefined('form.provider')>
		WHERE provider = '#form.provider#'
	</cfif>		
</cfquery>

</body>
</html>
