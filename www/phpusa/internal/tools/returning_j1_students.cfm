<cfif client.usertype GTE '5'>
	You do not have sufficient rights to edit programs.
	<cfabort>
</cfif>

<cfoutput>

<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign="middle" height=24>
		<td width="100%" valign="middle" bgcolor="e9ecf1"><h3 class="style1">&nbsp; R E T U R N I N G &nbsp; &nbsp; J 1 &nbsp; &nbsp; S T U D E N T S </h3></td>
	</tr>
</table>

<cfif NOT IsDefined('FORM.studentid')>

	<cfform name="get_student" action="index.cfm?curdoc=tools/returning_j1_students" method="post">
	<table border=0 cellpadding=2 cellspacing=2 align="center" width=90%>
		<tr><td colspan="2">Please use the feature below to assign J1 students to the PHP Program.</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td align="right" width="25%">Student ID:</td><td><cfinput name="studentid" type="text" size="4" maxlength="5"></td></tr>
		<tr><td colspan="2" align="center"><cfinput name="Submit" type="image" src="pics/next.gif" border=0></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	</cfform>

<cfelseif NOT IsDefined('FORM.confirm')>

	<cfquery name="get_student" datasource="MySql">
		SELECT 
        	s.studentid, 
            s.firstname, 
            s.familylastname, 
            s.active,
			u.businessname, 
			c.companyshort
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_users u ON u.userid = s.intrep
		INNER JOIN 
        	smg_companies c ON c.companyid = s.companyid
		WHERE 
        	studentid = <cfqueryparam value="#FORM.studentid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<form method="post" name="assign_student" action="index.cfm?curdoc=tools/returning_j1_students">
        <input type="hidden" name="studentid" value="#get_student.studentid#">
        <input type="hidden" name="confirm" value="yes">
        <table border=0 cellpadding=2 cellspacing=2 align="center" width=90%>
            <tr><td colspan="2">Please review the information below. If you wish to transfer this student to PHP please click on the button bellow.</td></tr>
            <tr><td colspan="2">&nbsp;</td></tr>
            <tr><td align="right" width="25%"><b>Student Name:</b></td><td>#get_student.firstname# #get_student.familylastname# (###get_student.studentid#)</td></tr>
            <tr><td align="right"><b>Students Status:</b></td><td><cfif get_student.active EQ '1'>Active<cfelse>Inactive</cfif></td></tr>
            <tr><td align="right"><b>Intl. Representative:</b></td><td>#get_student.businessname#</td></tr>
            <tr><td align="right"><b>Assigned to:</b></td><td>#get_student.companyshort#</td></tr>
            <tr><td colspan="2">&nbsp;</td></tr>
            <tr>
                <td align="right"><input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.go(-1)"> &nbsp;  &nbsp; </td>
                <td align="left"> &nbsp;  &nbsp; <input name="Submit" type="image" value="  next  " src="pics/next.gif" alt="Next" border="0"></td>
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>
        </table>
	</form>
	
<cfelse>

	<cfquery name="get_student" datasource="MySql">
		SELECT 
        	s.studentid, 
            s.firstname, 
            s.familylastname, 
            s.active,
			u.businessname, 
			c.companyshort
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_users u ON u.userid = s.intrep
		INNER JOIN 
        	smg_companies c ON c.companyid = s.companyid
		WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">
	</cfquery>

	<cfquery name="search_student" datasource="MySql">
		SELECT 
        	studentid
		FROM 
        	php_students_in_program 
		WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">
		AND 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
	</cfquery>

	<cfif NOT VAL(search_student.recordcount)>
	
		<cfquery name="add_student" datasource="MySql">
			INSERT INTO 
            	php_students_in_program 
			(
            	studentid, 
                companyid, 
                inputby, 
                active, 
                return_student, 
                datecreated
			) 
			VALUES 
            (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_student.studentid#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="1">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="4">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			)		
		</cfquery>
	
		<table border=0 cellpadding=2 cellspacing=2 align="center" width=90%>
			<tr><td align="right" width="25%"><b>Student Name:</b></td><td>#get_student.firstname# #get_student.familylastname# (###get_student.studentid#) ASSIGNED TO PHP</td></tr>		
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2"><a href="index.cfm?curdoc=tools/returning_j1_students">Return to Main Menu</a></td></tr>
		</table>
        
	<cfelse>	
    
		<table border=0 cellpadding=2 cellspacing=2 align="center" width=90%>
			<tr><td align="right" width="25%"><b>Student Name:</b></td><td>#get_student.firstname# #get_student.familylastname# (###get_student.studentid#) is already assigned to PHP.</td></tr>		
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2"><a href="index.cfm?curdoc=tools/returning_j1_students">Return to Main Menu</a></td></tr>
		</table>
        
	</cfif>
	
</cfif>

</cfoutput>