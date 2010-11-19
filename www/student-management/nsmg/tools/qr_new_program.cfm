<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cftransaction action="begin" isolation="serializable"> = 
	 <cfquery name="add_program" datasource="mysql">
		insert into smg_programs (programname, type , startdate, enddate, companyid, insurance_startdate, insurance_enddate, seasonid, smgseasonid, tripid, hold)
			values('#form.programname#', #form.type#, #CreateODBCDate(form.startdate)#, #CreateODBCDate(form.enddate)#, 
				#client.companyid#, 
				<cfif form.insurance_startdate is not ''>#CreateODBCDate(form.insurance_startdate)#<cfelse>null</cfif>,
				<cfif form.insurance_enddate is not ''>#CreateODBCDate(form.insurance_enddate)#<cfelse>null</cfif>,
				'#form.seasonid#', '#form.smgseasonid#', '#form.smg_trip#', 1)
	</cfquery>
	<cfquery name="prog_id" datasource="MySQL">
		select MAX(programid) as newid
		from smg_programs
	</cfquery>

</cftransaction>
<cfoutput>
<cflocation url="index.cfm?curdoc=tools/change_programs&progid=#prog_id.newid#" addtoken="no">
</cfoutput>

</body>
</html>
