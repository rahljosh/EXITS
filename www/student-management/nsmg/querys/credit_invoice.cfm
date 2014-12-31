<cfif #form.totaldue# is #form.amount_received#>
<cfset credit = #form.amount_received# - #form.totaldue#>
<!----mark students have paid deposit---->
<cfquery name="get_Students" datasource="MySQL">
select studentid,intrepid, charge, id
 from smg_invoice 
where number=#url.number#
</cfquery>

<cfoutput query="get_Students">
	
	<cfquery name="update_students" datasource="MySQL">
	update smg_students
	set application_fee = #now()#
	where studentid = #studentid#
	</cfquery>

	<cfquery name="update_invoice" datasource="MySQL">
	update smg_invoice
	set ammount_paid = #charge#,
		status = 'paid',
		datepaid = #now()#
	where id=#id#
	</cfquery>


</cfoutput>
<cfquery name="get_current_credit" datasource="mysql">
select account_Credit from smg_users where userid = #get_Students.intrepid#
</cfquery>
<cfset current_Credit = #get_current_Credit.account_Credit# + #credit#>
<cflocation url="../index.cfm?curdoc=invoice/finish_credit&id=#url.number#&camount=#credit#&newcamount=#current_Credit#&pay=#form.amount_received#&due=#form.totaldue#">  
 

<cfelseif #form.totaldue# gt #form.amount_received#>
<!----select which students to apply charges to---->
<cfset form.amount_received =#form.amount_received#>
<cflocation url="../index.cfm?curdoc=invoice/partial_payment&pa=#form.amount_received#&td=#form.totaldue#">



<cfelseif #form.totaldue# lt #form.amount_received#>
<cfset credit = #form.amount_received# - #form.totaldue#>
<!----Set students as paid and add credit to int rep account---->
<cfquery name="get_Students" datasource="MySQL">
select studentid, intrepid, charge, id
 from smg_invoices
where number=#url.number#
</cfquery>
<cfoutput query="get_Students">
<cfquery name="update_students" datasource="MySQL">
update smg_students
set application_fee = #now()#
where studentid = #studentid#
</cfquery>

<cfquery name="update_invoice" datasource="MySQL">
update smg_invoices
set ammount_paid = #charge#,
	status = 'paid',
	datepaid = #now()#
where id=#id#
</cfquery>
</cfoutput>
<cfquery name="get_current_credit" datasource="mysql">
select account_Credit from smg_users where userid = #get_Students.intrepid#
</cfquery>
<cfset current_Credit = #get_current_Credit.account_Credit# + #credit#>
<Cfquery name="update_intagent" datasource="mysql">
update smg_users set account_credit = #current_Credit#
	where userid = #get_Students.intrepid#
</Cfquery>



<cflocation url="../index.cfm?curdoc=invoice/finish_credit&id=#url.number#&camount=#credit#&newcamount=#current_Credit#&pay=#form.amount_received#&due=#form.totaldue#">  
<cfelse>
Amount Not entered
</cfif>
