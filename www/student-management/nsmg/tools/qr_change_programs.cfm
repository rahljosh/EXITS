<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cfif FORM.programfee is 0.00>
	Base program fee can not be 0.00, please click back and update the fee.
	<cfabort>
</cfif>

<Cfquery name="update_programs" datasource="MySQL">
	update smg_programs
	set programname = '#FORM.programname#',
		type = #FORM.programtype#,
		startdate = #CreateODBCDate(FORM.startdate)#,
		enddate = #CreateODBCDate(FORM.enddate)#,
        applicationDeadline = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FORM.applicationDeadline#" null="#NOT isDate(FORM.applicationDeadline)#">,
        fk_smg_student_app_programID = '#FORM.studentAppType#',
		insurance_startdate = <cfif FORM.insurance_startdate is not ''>#CreateODBCDate(FORM.insurance_startdate)#<cfelse>null</cfif>,
		insurance_enddate = <cfif FORM.insurance_enddate is not ''>#CreateODBCDate(FORM.insurance_enddate)#<cfelse>null</cfif>,
		preayp_date = <cfif FORM.preayp_date is not ''>#CreateODBCDate(FORM.preayp_date)#<cfelse>null</cfif>,
		programfee = '#FORM.programfee#',
		insurance_w_deduct = '#FORM.insurance_w_deduct#',
		seasonid = '#FORM.seasonid#',
		sevis_startdate = <cfif FORM.sevis_startdate is not ''>#CreateODBCDate(FORM.sevis_startdate)#<cfelse>null</cfif>,
		sevis_enddate = <cfif FORM.sevis_enddate is not ''>#CreateODBCDate(FORM.sevis_enddate)#<cfelse>null</cfif>,
		progress_reports_active = #FORM.progress_reports_active#,
		tripid = '#FORM.smg_trip#',
		smgseasonid = '#FORM.smgseasonid#',
		fieldviewable = #fieldviewable#,
		<cfif isDefined('FORM.blank')> blank = 1, <cfelse> blank = 0, </cfif>
		<cfif isDefined('FORM.hold')> hold = 1, <cfelse> hold = 0, </cfif>
		<cfif isDefined('FORM.ins_batch')> insurance_batch = 1, <cfelse> insurance_batch = 0, </cfif>
		insurance_wo_deduct = '#FORM.insurance_wo_deduct#'
	where programid = #FORM.programid#
	LIMIT 1
</Cfquery>

<cfif isdefined('FORM.change_status')>
	<cfif FORM.student_status neq 9>
    	<cfquery name="update_student_status" datasource="mysql">
        update smg_students
        set active = #FORM.student_status#
        where programid = #FORM.programid#
        </cfquery>
    </cfif>
</cfif>  
<cflocation url="index.cfm?curdoc=tools/change_programs&progid=#FORM.programid#" addtoken="no">

</body>
</html>
