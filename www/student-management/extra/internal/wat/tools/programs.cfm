<html>
<head><title></title>
<link href="http://dev.student-management.com/extra/style.css" rel="stylesheet" type="text/css">
<body>

<cfquery name="programstools" datasource="MySql">
	SELECT 
    	programid, 
        programname, 
        type, 
        extra_sponsor,
        smg_program_type.programtype, 
        startdate, 
        enddate, 
        insurance_startdate, 
        insurance_enddate, 
        smg_programs.companyid, 
        smg_companies.companyname, 
        programfee, 
        smg_programs.active, 
        smg_programs.hold
	FROM 
    	smg_programs
    INNER JOIN 
    	smg_companies ON smg_companies.companyid = smg_programs.companyid
    LEFT JOIN 
    	smg_program_type ON smg_program_type.programtypeid = smg_programs.type
    WHERE 
    	smg_programs.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
</cfquery>

<form method=post action="?curdoc=tools/program_info">

<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
	<tr bgcolor="E4E4E4">
	  <td width="85%" class="title1"> Program Maintenence</td>
		<td width="15%" class="title1"><!---<cfoutput>#programstools.active# </cfoutput>----></td>
	</tr>
</table><br />


<table width=95% border=0 align="center" cellpadding=4 cellspacing=0 class="section">
	<tr>
  		<td bgcolor="4F8EA4"><span class="style2"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif"><b>ID</b></font></span></td>
		<td bgcolor="4F8EA4"><span class="style2"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif"><b>Status</b></font></span></td>
		<td bgcolor="4F8EA4"><span class="style2"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif"><b>Program Name</b></font></span></td>
		<td bgcolor="4F8EA4"><span class="style2"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif"><b>Type</b></font></span></td>
		<td bgcolor="4F8EA4"><span class="style2"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif"><b>Start Date</b></font></span></td>
		<td bgcolor="4F8EA4"><span class="style2"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif"><b>End Date</b></font></span></td>
		<td bgcolor="4F8EA4"><span class="style2"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif"><b>Company</b></font></span></td>
        <td bgcolor="4F8EA4"><span class="style2"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif"><b>Sponsor</b></font></span></td>		  
	</tr>
	<cfoutput query="programstools">
	<tr bgcolor="#iif(programstools.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
		<td> 
        	<span class="style5">#programid#</span>
        </td>
		<Td>
		    <cfif enddate lt now()>
		      <span class="style5"><font color="red">expired</font></span>
		      <cfelseif hold is 1>
		      <span class="style5"><font color="##3300CC">hold</font></span>
		      <cfelseif enddate gt now()>
		      <span class="style5"><font color="green">active</font> </span>
		    </cfif>
		</Td>
		<td>
        	<span class="style5"><a href="?curdoc=tools/program_info&programID=#programid#">#programname# </a></span>
		</td>
		<td>
		    <cfif programtype is ''>
		      <span class="style5"><font color="red">None Assigned</font></span>
		      <cfelse>
		      <span class="style5">#programtype#</span>
		    </cfif>
		</td>
		<td>
		  <span class="style5">#DateFormat(startdate, 'mm-dd-yyyy')#</span>	    
	    </td>
		<td>
		  <span class="style5">#DateFormat(enddate, 'mm-dd-yyyy')#</span>
		</td>
		<td>
		  <span class="style5">#companyname#</span>
        </td>
		<td>
		  <span class="style5">#extra_sponsor#</span>
		</td>
	</tr>
	</cfoutput>
	<Tr>
		<td colspan=8 align="center"><a href="index.cfm?curdoc=tools/program_info" class="style5"><input name="Submit" type="image" src="../pics/add-program.gif" alt="Add Program" border=0></a></td>
	</Tr>
	<tr><td colspan=8></span></td>
	</tr>
</table>
</form>
<!------------
<cfelse>
You do not have sufficient rights to edit programs.
</cfif>----------->

<!--- TURN PROGRAMS TO INACTIVE 
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM smg_programs p
	LEFT JOIN smg_program_type ON type = programtypeid
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	WHERE enddate < '#DateFormat(now(), 'yyyy-mm-dd')#'
	ORDER BY companyshort, programname
</cfquery>
<cfoutput query="get_program">
	<cfquery name="update" datasource="MySql">
		UPDATE smg_programs 
		SET active = '0'
		WHERE programid = '#get_program.programid#'
		LIMIT 1
	</cfquery>
</cfoutput>
---->

<!-----<cfinclude template="../footer.cfm"> --->

</body>
</html>