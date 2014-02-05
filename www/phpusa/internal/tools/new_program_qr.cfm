 <!--- To set the correct fk_smg_student_app_programid --->
 <cfscript>
 	vSMGProgramType = 5;
	if (FORM.type EQ 1) {
		vSMGProgramType = 18;
	} else if (FORM.type EQ 2) {
		vSMGProgramType = 19;
	} else {
		vSMGProgramType = 17;
	}
 </cfscript> 
 
 <cfquery name="add_program" datasource="mysql">
    INSERT INTO 
        smg_programs
    (
        companyid,
        seasonid,
        fk_smg_student_app_programid, 
        programname,
        type, 
        startdate, 
        enddate, 
        insurance_startdate, 
        insurance_enddate,
        applicationDeadline
    )
    VALUES	
    (			
        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyid)#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonid)#">, 
        <cfqueryparam cfsqltype="cf_sql_integer" value="#vSMGProgramType#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.programname#">, 
        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.type)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.startdate#" null="#NOT IsDate(FORM.startdate)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.enddate#" null="#NOT IsDate(FORM.enddate)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.insurance_startdate#" null="#NOT IsDate(FORM.insurance_startdate)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.insurance_enddate#" null="#NOT IsDate(FORM.insurance_enddate)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.applicationDeadline#" null="#NOT IsDate(FORM.applicationDeadline)#">
    )
</cfquery>

<cflocation url="index.cfm?curdoc=tools/programs" addtoken="no">