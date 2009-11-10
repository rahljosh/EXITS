<cftransaction action="begin" isolation="serializable">
		<Cfquery name="add_program_charges" datasource="mySQL">
		 update smg_users 
		 	set 12_month_price =#form.12_month_price#,
			12_month_ins= #FORM.12_month_ins#,
            10_month_price =#form.10_month_price#,
			10_month_ins= #FORM.10_month_ins#,
			5_month_price=#FORM.5_month_price#,
			5_month_ins=#FORM.5_month_ins#,
			insurance_typeid = '#form.insurance_typeid#',		
			accepts_sevis_fee = '#form.accepts_sevis_fee#'	
		where userid = #url.userid#
		</Cfquery>
<cflocation url="../index.cfm?curdoc=forms/program_discount&userid=#form.userid#&message=success" addtoken="no">