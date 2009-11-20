<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>INSURANCE PRICES LIST</title>
</head>

<body>

<cftransaction action="begin" isolation="serializable">

	<cfloop From = "1" To = "#form.count#" Index = "x">
		<cfquery name="update_insurance" datasource="MySql">
			UPDATE smg_insurance_type
			SET ayp5 = '#Evaluate("form." & x & "_ayp5")#',
				ayp10 = '#Evaluate("form." & x & "_ayp10")#',
				ayp12 = '#Evaluate("form." & x & "_ayp12")#'
			WHERE insutypeid = '#Evaluate("form." & x & "_insutypeid")#'
			LIMIT 1
		</cfquery>
	</cfloop>

</cftransaction>

<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("?curdoc=invoice/insurance_prices");
-->
</script>


</body>
</html>