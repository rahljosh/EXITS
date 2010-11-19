<cfquery name="trip_type" datasource="MySQL">
	SELECT type, id
	FROM smg_payment_types WHERE paymenttype = 'Trip'
</cfquery>

<cfoutput>

<Cfquery name="rep_info" datasource="MySQL">
	select firstname, lastname, userid
	from smg_users
	where userid = #form.user#
</Cfquery>

<h2>Representitive: #rep_info.firstname# #rep_info.lastname# (#rep_info.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
<a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_history.cfm?userid=#rep_info.userid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Payment History</a></h2>

<Br>Fill in the details for the Incentive Trip Payment.<br>

<cfform method="post" action="querys/insert_supervising_incentive_trip.cfm">

<table width=90% cellpadding=4 cellspacing=0>
	<tr>
		<td bgcolor="010066" colspan=3><font color="white"><strong>Incentive Trip </strong></font></td>
	</tr>
	<tr bgcolor="CCCCCC">
		<td>Type</td><td>Amount</td><td>Comment</td>
	</tr>
	<tr>
		<Td width="20%"><cfselect name="trip_type" required="yes" message="Please Select the Type">
			<Cfloop query="trip_type">
					<option value="#id#">#type#</option>	
			</Cfloop>
			</cfselect>
		</Td>  
		<td width="10%"><cfinput type="text" name="trip_amount" size=6 required="yes" message="Please Enter the Amount before submitting the payment."></td>
		<td width="70%"><cfinput type="text" name="trip_comment" size=40></td>
		<cfinput type="hidden" value="Trip" name="trip_transtype">
		<cfinput type="hidden" value="#form.user#" name="user">
	<tr>
		<td colspan=5 align="right"><cfinput name="submit" type="image" src="pics/submit.gif" align="right" border=0 alt="submit" submitOnce></td>
	</Tr>
</table>
</cfform>
</cfoutput>