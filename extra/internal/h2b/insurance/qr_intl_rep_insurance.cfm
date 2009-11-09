<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Update Insurance Policy List</title>
</head>

<body>

<cftransaction action="begin" isolation="SERIALIZABLE">

<cfloop From = "1" To = "#form.count#" Index = "x">
		<Cfquery name="update_insurance" datasource="mySQL">
			 UPDATE smg_users 
				SET extra_insurance_typeid = '#Evaluate("FORM." & x & "_extra_insurance_typeid")#'
			WHERE userid = '#Evaluate("FORM." & x & "_userid")#'
			LIMIT 1
		</Cfquery>
</cfloop>

</cftransaction>

<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("?curdoc=insurance/intl_rep_insurance");
-->
</script>

</body>
</html>
