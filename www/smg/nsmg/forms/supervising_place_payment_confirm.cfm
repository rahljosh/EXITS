<cfoutput>

<Cfquery name="rep_info" datasource="MySQL">
	select firstname, lastname, userid
	from smg_users
	where 
	userid = #url.user#
</Cfquery>
<h2>Representitive: #rep_info.firstname# #rep_info.lastname# (#rep_info.userid#)&nbsp; <span class="get_attention"><b>::</b></span>
<a href="" onClick="javascript: win=window.open('forms/supervising_history.cfm?userid=#rep_info.userid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Payment History</a></h2>

<Br>
Below is a summary of the payments recorded.
<br>

<input type="hidden" name="user" value=#url.user#>

<table width=90% cellpadding=4 cellspacing=0>
	<tr>
		<td bgcolor="010066" colspan=5><font color="white"><strong>Supervised Students </strong></font></td>
	</tr>
	<tr bgcolor="CCCCCC">
		<Td>ID</Td><td>Student</td><td>Type</td><td>Amount</td><td>Comment</td>
	</tr>
	<Cfif not isDefined('url.supervised_list')>
			<td colspan=5 align="center">No supervision payments submitted.</td>
		<cfelse>

			<cfloop list="#url.supervised_list#" index = "x">
			<Cfquery name="payment_details" datasource="MySQL">
			select *
			from smg_rep_payments
			where id = #x#
			</Cfquery>
			<!----retrieve student name---->
			<cfquery name="stu_name" datasource="MySQL">
			select firstname, familylastname, studentid
			from smg_students
			where studentid = #payment_details.studentid#
			</cfquery>
			<!----Retrieve type of payment---->
			<cfquery name="type" datasource="MySQL">
			select type 
			from smg_payment_types
			where id = #payment_details.paymenttype#
			</cfquery>
			<tr>
				<Td>#x#</Td><td>#stu_name.firstname# #stu_name.familylastname# (#stu_name.studentid#)</td>
				<Td>#type.type#
				</Td>  
				<td>#LSCurrencyFormat(payment_details.amount, 'local')#</td>
				<td>#payment_details.comment#</td>
			</tr>
		 
			</cfloop>
		</cfif>
		</td>
	</Tr>
	<Cfif isDefined('form.supervised_selected_student')>
		<tr>
			<td colspan=5 align="right"><input name="submit" type="image" src="pics/submit.gif" align="right" border=0 alt="submit"></td>
		</Tr>
	</cfif>

	<tr><td>&nbsp;</td></tr>

	<tr>
		<td bgcolor="010066" colspan=5><font color="white"><strong>Placed Students</strong></font></td>
	</tr>
	<tr bgcolor="CCCCCC">
		<Td>Payment ID</Td><td>Student</td><td>Type</td><td>Amount</td><td>Comment</td>
	</tr>
	
		<Cfif not isDefined('url.place_list')>
		<tr>
			<td colspan=5 align="center">No placement payments submitted.</td>
		</tr>
		<cfelse>
		
			<cfloop list=#url.place_list# index = "x">
			<Cfquery name="payment_details" datasource="MySQL">
			select *
			from smg_rep_payments
			where id = #x#
			</Cfquery>
			<!----retrieve student name---->
			<cfquery name="stu_name" datasource="MySQL">
			select firstname, familylastname, studentid
			from smg_students
			where studentid = #payment_details.studentid#
			</cfquery>
			<!----Retrieve type of payment---->
			<cfquery name="type" datasource="MySQL">
			select type 
			from smg_payment_types
			where id = #payment_details.paymenttype#
			</cfquery>
			<tr>
				<Td>#x#</Td><td>#stu_name.firstname# #stu_name.familylastname# (#stu_name.studentid#)</td>
				<Td>#type.type#</Td>  
				<td>#LSCurrencyFormat(payment_details.amount, 'local')#</td>
				<td>#payment_details.comment#</td>
			</tr>
			</cfloop>
		</cfif>
		<Cfif isDefined('form.supervised_list')>
					<tr>
			<td colspan=5 align="right"> <input name="submit" type="image" src="pics/submit.gif" align="right" border=0 alt="submit"></td>
		</Tr>
		</cfif>
</table>
</form>
<br><div align="center"><a href="?curdoc=forms/supervising_placement_payments"><img src="pics/newpayment.gif" border="0" align="bottom"></a></div>
</cfoutput>