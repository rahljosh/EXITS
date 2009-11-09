<span class="application_section_header">Program Fees</span> <br>

<p>Assign program fees per program for this International Rep.  Changing information here will only affect students that have NOT been invoiced. <br><br>
If there is difference from the base price, just leave blank, don't put in zero's, N/A, etc.<br>
If you need to remove an amount, set it to 0 (zero).</p>

<cfquery name="get_prices" datasource="mysql">
	select businessname, 12_month_price, 10_month_price, 5_month_price, 10_month_ins, 12_month_ins, 5_month_ins, accepts_sevis_fee, userid, insurance_typeid
	from smg_users
	where userid = #url.userid#
</cfquery>

<cfquery name="get_insutypes" datasource="MySql">
	SELECT insutypeid, type
	FROM smg_insurance_type
</cfquery>

<Cfoutput>
<form method="post" action="../nsmg/querys/add_discount.cfm?userid=#url.userid#">
<input type="hidden" name="userid" value=#url.userid#>
<table align="center">
<tr><td align="center">#get_prices.businessname#</td></tr>
</table>
</Cfoutput>

<cfif isDefined('url.message')>

</cfif>

<table div align="center" cellpadding= 4 cellspacing=0>
	<tr bgcolor="#00003C">
		<Td colspan=2 align="center"><font color="white">12 Months</Td><Td colspan=2 align="center"><font color="white">10 Months</Td><td colspan=2 align="center"><font color="white">5 months</td>
	</tr>
	<tr bgcolor="#00003C">
		<td align="center"><font color="white">Price</td><td align="center"><font color="white">Insurance</td><td align="center"><font color="white">Price</td><td align="center"><font color="white">Insurance</td><td align="center"><font color="white">Price</td><td align="center"><font color="white">Insurance</td>
	</tr>
	<cfoutput query="get_prices">
	<tr>
    	<td><input name="12_month_price" type="text" value="#get_prices.12_month_price#" size=5></td><td><input name="12_month_ins" type="text" value="#get_prices.12_month_ins#" size=5></td>
		<td><input name="10_month_price" type="text" value="#get_prices.10_month_price#" size=5></td><td><input name="10_month_ins" type="text" value="#get_prices.10_month_ins#" size=5></td><td><input name="5_month_price" type="text" value="#get_prices.5_month_price#" size=5></td><td><input name="5_month_ins" type="text" value="#get_prices.5_month_ins#" size=5></td>
	</tr>
	<Tr>
	<tr bgcolor="00003C"><td colspan=6><font color="white">Insurance Policy Type</td></tr>
	<tr>
		<td colspan=2>											
		<select name="insurance_typeid">
			<option value="0"></option>
			<cfloop query="get_insutypes">
			<option value="#insutypeid#" <cfif get_prices.insurance_typeid EQ insutypeid>selected</cfif> >#type#</option>
			</cfloop>
		</select>
		</td>
	</tr>
	<tr bgcolor="00003C"><td colspan=6><font color="white">Accepts SEVIS FEE</td></tr>
	<tr>
		<td colspan="2"> 								
		<select name="accepts_sevis_fee">
			<option value=""></option>
			<option value="0" <cfif get_prices.accepts_sevis_fee EQ '0'>selected</cfif> >No</option>
			<option value="1" <cfif get_prices.accepts_sevis_fee EQ '1'>selected</cfif> >Yes</option>
		</select>	
		</td>
	</tr>
	<tr>
		<td colspan=4 align="right"><input name="Submit" type="image" src="pics/next.gif" border=0></td>
	</tr>		
</table>
<br></cfoutput>

</form>
<Cfif isDefined('url.message')>
<p><span class="get_attention" align="center">Program charges were updated / added succesfully!!</span><br><br></cfif>