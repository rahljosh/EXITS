<cfset supervised_payments_list = ''>
<cfset placed_payments_list = ''>

<cfif form.supervised_selected_student NEQ ''>
	<Cfloop list="#form.supervised_selected_student#" index="x">
	
		<cfif #Evaluate("FORM." & x & "super_type")# NEQ ''>
			<cftransaction action="begin" isolation="serializable">
				<Cfquery name="s_stu_program" datasource="MySQL">
					select studentid, programid
					from smg_students
					where studentid = '#x#'
				</Cfquery>
				<Cfquery name="insert_super_charge" datasource="MySQL">
					INSERT INTO smg_rep_payments(agentid, studentid, programid, paymenttype, date, transtype, inputby, amount, companyid, comment)
					VALUES ('#form.user#', '#x#', '#s_stu_program.programid#', '#Evaluate("FORM." & x & "super_type")#', #now()#, '#Evaluate("FORM." & x & "super_transtype")#', #client.userid#, '#Evaluate("FORM." & x & "super_amount")#', #client.companyid#, '#Evaluate("FORM." & x & "super_comment")#')
				</Cfquery>
			</cftransaction>
			<cfquery name="supervised_payment_id" datasource="MySQL">
				select max(id) as lastid from smg_rep_payments
			</cfquery>
			<Cfset supervised_payments_list = #ListAppend(supervised_payments_list, #supervised_payment_id.lastid#)#>
		</cfif>	
	</Cfloop>
</cfif>

<cfif form.placed_selected_student NEQ ''>
	<Cfloop list="#form.placed_selected_student#" index="x">
		<cfif #Evaluate("FORM." & x & "place_type")# NEQ ''>
			<cftransaction action="begin" isolation="serializable">
				<Cfquery name="p_stu_program" datasource="MySQL">
					select studentid, programid
					from smg_students
					where studentid = '#x#'
				</Cfquery>
				<Cfquery name="insert_place_charge" datasource="MySQL">
					INSERT INTO smg_rep_payments(agentid, studentid, programid, paymenttype, date, transtype, inputby, amount, companyid, comment)
					VALUES ('#form.user#', '#x#', '#p_stu_program.programid#', '#Evaluate("FORM." & x & "place_type")#', #now()#, '#Evaluate("FORM." & x & "place_transtype")#', #client.userid#, '#Evaluate("FORM." & x & "place_amount")#', #client.companyid#, '#Evaluate("FORM." & x & "place_comment")#')
				</Cfquery>
			</cftransaction>
			<cfquery name="placed_payment_id" datasource="MySQL">
				select max(id) as lastid from smg_rep_payments
			</cfquery>
			<Cfset placed_payments_list = #ListAppend(placed_payments_list, #placed_payment_id.lastid#)#>
		</cfif>
	</Cfloop>
</cfif>

<cfoutput>

<cflocation url="../index.cfm?curdoc=forms/supervising_place_payment_confirm&user=#form.user#&place_list=#placed_payments_list#&supervised_list=#supervised_payments_list#">
</cfoutput>