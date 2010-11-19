<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cfif form.programfee is 0.00>
	Base program fee can not be 0.00, please click back and update the fee.
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="SERIALIZABLE">
<Cfquery name="update_programs" datasource="MySQL">
	update smg_programs
	set programname = '#form.programname#',
		type = #form.programtype#,
		startdate = #CreateODBCDate(form.startdate)#,
		enddate = #CreateODBCDate(form.enddate)#,
		insurance_startdate = <cfif form.insurance_startdate is not ''>#CreateODBCDate(form.insurance_startdate)#<cfelse>null</cfif>,
		insurance_enddate = <cfif form.insurance_enddate is not ''>#CreateODBCDate(form.insurance_enddate)#<cfelse>null</cfif>,
		preayp_date = <cfif form.preayp_date is not ''>#CreateODBCDate(form.preayp_date)#<cfelse>null</cfif>,
		programfee = '#form.programfee#',
		insurance_w_deduct = '#form.insurance_w_deduct#',
		seasonid = '#form.seasonid#',
		sevis_startdate = <cfif form.sevis_startdate is not ''>#CreateODBCDate(form.sevis_startdate)#<cfelse>null</cfif>,
		sevis_enddate = <cfif form.sevis_enddate is not ''>#CreateODBCDate(form.sevis_enddate)#<cfelse>null</cfif>,
		progress_reports_active = #form.progress_reports_active#,
		tripid = '#form.smg_trip#',
		smgseasonid = '#form.smgseasonid#',
		fieldviewable = #fieldviewable#,
		<cfif isDefined('form.blank')> blank = 1, <cfelse> blank = 0, </cfif>
		<cfif isDefined('form.hold')> hold = 1, <cfelse> hold = 0, </cfif>
		<cfif isDefined('form.ins_batch')> insurance_batch = 1, <cfelse> insurance_batch = 0, </cfif>
		insurance_wo_deduct = '#form.insurance_wo_deduct#'
	where programid = #form.programid#
	LIMIT 1
</Cfquery>
</cftransaction>
<cfif isdefined('form.change_status')>
	<cfif form.student_status neq 9>
    	<cfquery name="update_student_status" datasource="mysql">
        update smg_students
        set active = #form.student_status#
        where programid = #form.programid#
        </cfquery>
    </cfif>
</cfif>  
<cflocation url="index.cfm?curdoc=tools/change_programs&progid=#form.programid#" addtoken="no">

</body>
</html>
