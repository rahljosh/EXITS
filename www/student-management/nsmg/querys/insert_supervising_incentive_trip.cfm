<cftransaction action="begin" isolation="serializable">
	
	<Cfquery name="insert_trip_charge" datasource="MySQL">
		INSERT INTO smg_rep_payments (agentid, studentid, paymenttype, date, transtype, inputby, amount, companyid, comment)
				VALUES ('#form.user#', '0', '#form.trip_type#', #now()#, '#form.trip_transtype#',  '#client.userid#', '#form.trip_amount#', 
						'#client.companyid#', '#form.trip_comment#')
	</Cfquery>

	<cfquery name="payment_id" datasource="MySQL">
		select max(id) as lastid from smg_rep_payments
	</cfquery>

</cftransaction>

<cfoutput>
<cflocation url="../index.cfm?curdoc=forms/supervising_incentive_trip_confirm&user=#form.user#&payment=#payment_id.lastid#" addtoken="no">
</cfoutput>