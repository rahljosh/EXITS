<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cftransaction action="begin" isolation="SERIALIZABLE">

<cfloop From = "1" To = "#form.count#" Index = "x">
		<Cfquery name="add_program_charges" datasource="mySQL">
		 update smg_users 
			set 10_month_price ='#Evaluate("FORM." & x & "_10_month_price")#',
			10_month_ins= '#Evaluate("FORM." & x & "_10_month_ins")#',
			5_month_price='#Evaluate("FORM." & x & "_5_month_price")#',
			5_month_ins='#Evaluate("FORM." & x & "_5_month_ins")#',
			insurance_typeid = '#Evaluate("FORM." & x & "_insu_typeid")#',
			accepts_sevis_fee = '#Evaluate("FORM." & x & "_accepts_sevis_fee")#'		
		WHERE userid = '#Evaluate("FORM." & x & "_userid")#'
		LIMIT 1
		</Cfquery>
</cfloop>

</cftransaction>

<cflocation url="?curdoc=invoice/int_rep_rates&message=Prices Updated Succesfully!!">

</body>
</html>
