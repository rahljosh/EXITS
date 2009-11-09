<cftransaction action="begin" isolation="SERIALIZABLE">
<cfloop From = "1" To = "#form.count#" Index = "x">
 
	<Cfquery name="update_amount" datasource="mySQL">
	UPDATE smg_payment_amount
		SET amount = '#Evaluate("form." & x & "_amount")#'
		WHERE companyid = '#form.companyid#' AND paymentid = '#Evaluate("form." & x & "_paymentid")#'
	</Cfquery>
	
</cfloop> 
</cftransaction>

<html>
<head>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
location.replace("?curdoc=forms/supervising_maintenance");
-->
</script>
</head>
</html> 