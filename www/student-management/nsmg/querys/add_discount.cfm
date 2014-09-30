<cftransaction action="begin" isolation="serializable">
	<cfquery name="add_program_charges" datasource="#APPLICATION.DSN#">
    	UPDATE smg_users 
        SET
        	12_month_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.12_month_price#">,
            10_month_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.10_month_price#">,
            5_month_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.5_month_price#">,
            insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.insurance_typeid)#">,		
            accepts_sevis_fee = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.accepts_sevis_fee#">	
      	WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.userid)#">
	</cfquery>
<cflocation url="../index.cfm?curdoc=forms/program_discount&userid=#form.userid#&message=success" addtoken="no">