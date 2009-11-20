<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Add New Program</title>
</head>

<body>

<cftransaction action="begin" isolation="serializable">
	 
	 <cfquery name="add_program" datasource="mysql">
		INSERT INTO smg_programs
			(companyid, programname, type, startdate, enddate, insurance_startdate, insurance_enddate, seasonid)
		VALUES	
			('#client.companyid#', '#form.programname#', '#form.type#',
			<cfif form.startdate NEQ ''>#CreateODBCDate(form.startdate)#<cfelse>NULL</cfif>,
			<cfif form.enddate NEQ ''>#CreateODBCDate(form.enddate)#<cfelse>NULL</cfif>,
			<cfif form.insurance_startdate NEQ ''>#CreateODBCDate(form.insurance_startdate)#<cfelse>NULL</cfif>,
			<cfif form.insurance_enddate NEQ ''>#CreateODBCDate(form.insurance_enddate)#<cfelse>NULL</cfif>,
			'#form.seasonid#')
	</cfquery>

	<cfquery name="prog_id" datasource="MySQL">
		SELECT MAX(programid) as programid
		FROM smg_programs
	</cfquery>

</cftransaction>

<cflocation url="index.cfm?curdoc=tools/programs" addtoken="no">

<!--- <cflocation url="?curdoc=tools/edit_program&programid=#prog_id.programid#" addtoken="no"> --->

</body>
</html>