<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfquery name="int_rep_rates" datasource="caseusa">
	SELECT userid, businessname, 10_month_price, 5_month_price, 10_month_ins, 5_month_ins, accepts_sevis_fee, insurance_typeid 
	FROM smg_users 
	WHERE usertype = 8
	ORDER BY businessname	
</cfquery>


<cfquery name="get_insutypes" datasource="caseusa">
	SELECT insutypeid, type
	FROM smg_insurance_type
	WHERE active = 1
</cfquery>


<cfoutput>

<cfif IsDefined('url.message')><div align="center" class="get_attention">#url.message#</div><br></cfif>

<div align="center">To use Default insurance rates, leave rate for Insurance at 0.00</div>

<cfform action="?curdoc=invoice/int_rep_rates_qr" method="post">

<cfinput type="hidden" name="count" value="#int_rep_rates.recordcount#">

<table div align="center" cellpadding="4" cellspacing=0 width="90%">
	<tr bgcolor="##00003C">
		<td colspan="2"></td>
		<td colspan=2 align="center"><font color="white">10 Months</Td>
		<td colspan=2 align="center"><font color="white">5 months</td>
		<td></td>
	</tr>
	<tr bgcolor="##00003C">
		<td valign="bottom"><font color="white"><b>Business</b></font></td>
		<td><font color="white"><b>Policy Type</b></font></td>
		<td align="center"><font color="white"><b>Price</b></font></td>
		<td align="center"><font color="white"><b>Insurance</b></font></td>
		<td align="center"><font color="white"><b>Price</b></font></td>
		<td align="center"><font color="white"><b>Insurance</b></font></td>
		<td align="center"><font color="white"><b>Accepts SEVIS Fee</b></font></td>
	</tr>
<cfloop query="int_rep_rates">
<tr bgcolor="#iif(int_rep_rates.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td>#businessname# (###userid#) <cfinput type="hidden" name="#currentrow#_userid" value="#userid#"></td>
	<Td align="right">
		<cfset insurance_typeid = #int_rep_rates.insurance_typeid#>
		<select name="#currentrow#_insu_typeid">
			<option value="0"></option>
			<cfloop query="get_insutypes">
			<option value="#insutypeid#" <cfif insurance_typeid EQ insutypeid>selected</cfif> >#type#</option>
			</cfloop>
		</select>	
	</Td>
	<td><cfinput type="text" name="#currentrow#_10_month_price" value="#int_rep_rates.10_month_price#" size="5"></td>
	<td><cfinput type="text" name="#currentrow#_10_month_ins" value="#int_rep_rates.10_month_ins#" size="5"></td>
	<td><cfinput type=text name="#currentrow#_5_month_price" value="#int_rep_rates.5_month_price#" size="5"></td>
	<td><cfinput type=text name="#currentrow#_5_month_ins" value="#int_rep_rates.5_month_ins#" size="5"></td>
	<td align="center">
		<select name="#currentrow#_accepts_sevis_fee">
			<option value=""></option>
			<option value="0" <cfif int_rep_rates.accepts_sevis_fee EQ '0'>selected</cfif> >No</option>
			<option value="1" <cfif int_rep_rates.accepts_sevis_fee EQ '1'>selected</cfif> >Yes</option>
		</select>	
	</td>
</tr>
</cfloop>
<tr><td colspan="6" align="center"><div class="button"><cfinput name="Submit" type="image" src="pics/next.gif" border=0></div></td></tr>
</Table>

</cfform>
</cfoutput>