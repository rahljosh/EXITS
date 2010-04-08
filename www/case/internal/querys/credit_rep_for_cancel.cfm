<div class="application_section_header">Canceled Students</div> <br><br>
<cfif not isDefined('form.student')>

Please select an International Student to credit. 
<div class="button"><input name="back" type="image" src="pics/back.gif" border=0 onClick="history.back()"></div>
</cfif>
<cfloop list=#form.student# index="i">
	<cfquery name="canceled_Students" datasource="caseusa">
		select smg_students.studentid, smg_students.intrep, smg_students.familylastname, smg_students.firstname, smg_users.businessname, smg_users.firstname as rep_firstname, smg_users.lastname, smg_users.userid,
			smg_students.program_payment_amount, smg_students.application_payment, smg_students.insurance_pay_amount
		from smg_students left join smg_users on smg_students.intrep = smg_users.userid
		where smg_students.studentid = #i#
	</cfquery>
	<cfquery name="other_charges" datasource="caseusa">
		select sum(other_charge) as total_other_charges
		from smg_invoices
		where studentid = #i#
	</cfquery>
		<cfif other_charges.total_other_charges is ''>
	<cfset other_charges.total_other_charges = 0.00>
	</cfif>
	<cfset total=#canceled_Students.application_payment# + #canceled_Students.insurance_pay_amount# + #canceled_Students.program_payment_amount# + #other_charges.total_other_charges#>
	<cfquery name="update_cancelled_students" datasource="caseusa">
	update smg_students
		set invoiced_cancel = 1
	where studentid = #i#
	</cfquery>
	<cfquery name="get_credit" datasource="caseusa">
	select account_credit from smg_users
	where userid = #canceled_students.intrep#
	</cfquery>
	<cfset newcredit = #total# + #get_credit.account_credit#>
	<cfquery name="update_int_rep" datasource="caseusa">
	update smg_users
		set account_Credit = #newcredit#
	where userid = #canceled_students.intrep#
	</cfquery>
	<cfoutput>
#canceled_Students.firstname# #canceled_Students.familylastname# has been marked as canceled financially.<br>
#canceled_Students.businessname# #canceled_students.rep_firstname# #canceled_students.lastname# has had #total# credited to there account. <br><br>
</cfoutput>
</cfloop>

If you are sending a check to the International Rep for the credit amount, please create a Refund Invoice.
