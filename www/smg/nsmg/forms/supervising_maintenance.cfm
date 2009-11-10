<cfquery name="get_prices" datasource="MySql">
	SELECT companyshort, type , amount, paymentid
	FROM `smg_payment_amount` 
	INNER JOIN smg_companies ON smg_companies.companyid = smg_payment_amount.companyid
	LEFT OUTER JOIN smg_payment_types ON smg_payment_types.id = smg_payment_amount.paymentid
	WHERE smg_payment_amount.companyid = '#client.companyid#'
	ORDER BY smg_payment_amount.companyid
</cfquery>

<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>#companyshort.companyshort# - Payment Rep Maintenance</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform method=post action="?curdoc=querys/update_supervising_maintenance">
<cfinput type="hidden" name="companyid" value="#client.companyid#">
<cfinput type="hidden" name="count" value="#get_prices.recordcount#">

<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
<tr>
	<td align="center">
		<table cellpadding=2 cellspacing=0 width="50%" border="1" bordercolor="CCCCCC">
			<tr>	
				<th>Company</th>
				<th>Type</th>
				<th>Amount</th>
			</tr>
			<cfloop query="get_prices">
			<tr>
				<td>#companyshort#</td>
				<td>#type# <cfinput type="hidden" name="#get_prices.currentrow#_paymentid" value="#get_prices.paymentid#"></td>
				<td><cfinput type="text" name="#get_prices.currentrow#_amount" size="6"  maxlength="6" value="#amount#"></td>
			</tr>
			</cfloop>
		</table>
	</td>
</tr>
<tr>
	<td align="center">
		<a href="?curdoc=forms/supervising_placement_payments"><img src="pics/back.gif" border="0" align="bottom"></a> &nbsp; &nbsp; 
		<cfinput name="Submit" type="image" src="pics/update.gif" border=0 alt="  Update  " submitOnce>
	</td>
</tr>	
</table>
</cfform>
</cfoutput>

<!----footer of table --- ALL ITEMS---->
<cfinclude template="../table_footer.cfm">
