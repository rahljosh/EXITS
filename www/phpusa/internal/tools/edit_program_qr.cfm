<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Add New Program</title>
</head>

<body>

<cftransaction action="begin" isolation="serializable">
	 
	 <cfquery name="update_program" datasource="mysql">
		UPDATE smg_programs
		SET programname = '#form.programname#',
			type = '#form.type#',
			startdate = <cfif form.startdate NEQ ''>#CreateODBCDate(form.startdate)#<cfelse>NULL</cfif>,
			enddate = <cfif form.enddate NEQ ''>#CreateODBCDate(form.enddate)#<cfelse>NULL</cfif>,
			insurance_startdate = <cfif form.insurance_startdate NEQ ''>#CreateODBCDate(form.insurance_startdate)#<cfelse>NULL</cfif>,
			insurance_enddate = <cfif form.insurance_enddate NEQ ''>#CreateODBCDate(form.insurance_enddate)#<cfelse>NULL</cfif>,
			insurance_w_Deduct = #form.insurance_w_Deduct#,
			insurance_wo_deduct = #form.insurance_wo_deduct#,
			<cfif isDefined('form.ins_batch')> insurance_batch = 1, <cfelse> insurance_batch = 0, </cfif>
			programfee = #form.programfee#,
			seasonid = '#form.seasonid#'
		WHERE programid = <cfqueryparam value="#form.programid#" cfsqltype="cf_sql_integer">
		LIMIT 1
	</cfquery>

</cftransaction>

<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("index.cfm?curdoc=tools/edit_program&programid=#form.programid#");
//-->
</script>
</cfoutput>
</head>
</html> 

<!--- <cflocation url="../index.cfm?curdoc=tools/edit_programs&progid=#prog_id.programid#" addtoken="no"> --->
</body>
</html>