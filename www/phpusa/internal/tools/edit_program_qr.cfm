<cfparam name="FORM.ins_batch" default="0">
  
<cfquery name="update_program" datasource="mysql">
    UPDATE 
    	smg_programs
    SET 
    	programname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.programname#">, 
        type = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.type)#">,
        startdate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.startdate#" null="#NOT IsDate(FORM.startdate)#">,
        enddate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.enddate#" null="#NOT IsDate(FORM.enddate)#">,
        insurance_startdate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.insurance_startdate#" null="#NOT IsDate(FORM.insurance_startdate)#">,
        insurance_enddate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.insurance_enddate#" null="#NOT IsDate(FORM.insurance_enddate)#">,
        insurance_w_Deduct = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.insurance_w_Deduct#">,
        insurance_wo_deduct = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.insurance_wo_deduct#">,
        insurance_batch = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.ins_batch#">, 
        programfee = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.programfee#">,
        seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonid)#">
    WHERE 
    	programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#">
</cfquery>

<cfoutput>

<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
		location.replace("index.cfm?curdoc=tools/edit_program&programid=#FORM.programid#");
	//-->
</script>

</cfoutput>
