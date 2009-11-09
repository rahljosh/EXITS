<cfset p_payment = ''>
<cfset s_payment = ''>

<cfoutput>

<Cfquery name="stu_program" datasource="MySQL">
	select studentid, programid
	from smg_students
	where studentid = '#form.studentid#'
</Cfquery>

<!--- supervising --->
	<cfif form.supervising_type NEQ ''>
	<cfif form.supervising_amount EQ ''>
		<h2>Supervising Amount is required and cannot be left blank.</h2>
		<Br>Please go back and enter the information required.<br>
		<center><input name="back" alt="go back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.back()"></center>
		<cfabort>	
	</cfif>
	
	<cftransaction action="begin" isolation="serializable">
		<Cfquery name="insert_super_charge" datasource="MySQL">
			INSERT INTO smg_rep_payments
						(agentid, studentid, programid, paymenttype, date, transtype, inputby, amount, companyid, comment)
			VALUES ('#form.superid#', '#form.studentid#', '#stu_program.programid#', '#form.supervising_type#', #now()#, 'supervision', 
					'#client.userid#', '#form.supervising_amount#', '#client.companyid#', '#form.supervising_comment#')
		</Cfquery>
		<cfquery name="supervised_payment_id" datasource="MySQL">
			select max(id) as lastid from smg_rep_payments
		</cfquery>
		<Cfset s_payment = '#supervised_payment_id.lastid#'>		
	</cftransaction>
<cfelse>
	<Cfset s_payment = '0'>
</cfif>

<!--- placing --->
<cfif form.placing_type NEQ ''>
	<cfif form.placing_amount EQ ''>
		<h2>Placing Amount is required and cannot be left blank.</h2>
		<Br>Please go back and enter the information required.<br>
		<center><input name="back" alt="go back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.back()"></center>
		<cfabort>	
	</cfif>
	
	<cftransaction action="begin" isolation="serializable">
		<Cfquery name="insert_place_charge" datasource="MySQL">
			INSERT INTO smg_rep_payments
						(agentid, studentid, programid, paymenttype, date, transtype, inputby, amount, companyid, comment)
			VALUES ('#form.placeid#', '#form.studentid#', '#stu_program.programid#', '#form.placing_type#', #now()#, 'placement', 
					'#client.userid#', '#form.placing_amount#', '#client.companyid#', '#form.placing_comment#')
		</Cfquery>
		<cfquery name="placed_payment_id" datasource="MySQL">
			select max(id) as lastid from smg_rep_payments
		</cfquery>
		<cfset p_payment = '#placed_payment_id.lastid#'>
	</cftransaction>
<cfelse>
	<cfset p_payment = '0'>
</cfif>

<cflocation url="?curdoc=forms/supervising_place_student_confirm&studentid=#form.studentid#&p_payment=#p_payment#&s_payment=#s_payment#" addtoken="no">
</cfoutput>