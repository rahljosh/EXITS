<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student" datasource="MySQL">
	SELECT	 
    	studentid, 
        familylastname, 
        firstname, 
        middlename, 
        sex, 
        dob, 
        citybirth, 
        intrep,
        birth.countryname as countrybirth,
        resident.countryname as countryresident,
        citizen.countryname as countrycitizen
	FROM 	
    	smg_students
	LEFT JOIN 
    	smg_countrylist birth ON smg_students.countrybirth = birth.countryid
	LEFT JOIN 
    	smg_countrylist resident ON smg_students.countryresident = resident.countryid
	LEFT JOIN 
    	smg_countrylist citizen ON smg_students.countrycitizen = citizen.countryid
	WHERE 
    	verification_received IS NULL
		
	<cfif CLIENT.companyID EQ 5>
        AND 
            companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="$APPLICATION.SETTINGS.COMPANYLIST.ISE$" list="yes"> )
    <cfelse>
        AND 
            companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    </cfif>
        
    AND 
    	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND 
    	programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#"> 
    AND 
    	intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
    AND 
    	onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
	ORDER BY 
    	familylastname
</cfquery>

<!-----Intl. Agent----->
<cfquery name="int_Agent" datasource="MySQL">
	select companyid, businessname, fax, email
	from smg_users 
	where userid = #form.intrep#
</cfquery>

<cfquery name="program_name" datasource="MySQL">
	SELECT programname, programid
	FROM smg_programs
	WHERE programid = #form.programid#
</cfquery>

<table width=80% align="center" border=0 bgcolor="FFFFFF">
<cfoutput>
	<tr>
	<td  valign="top" width=90><span id="titleleft">
		TO:<br>
		FAX:<br>
		E-MAIL:<br><br><br>		
		Today's Date:<br>
	</td>
	<td  valign="top"><span id="titleleft">
		<cfif len(#int_agent.businessname#) gt  40>#Left(int_agent.businessname,40)#..</font></a><cfelse>#int_agent.businessname#</cfif><br>
		#int_agent.fax#<br>
		<a href="mailto:#int_agent.email#">#int_agent.email#</a><br><br><br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br>
	</td>
	<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="right"></td>	
	<td valign="top" align="right"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyshort#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
	</td></tr>		
</cfoutput>
</table>

<div id="pagecell_reports">
<hr width=80% color="000000">
<div align="center"><h3>DS 2019 Verification Report</h3></div>

<cfoutput>
<div align="center"><h4>Total of #get_student.recordcount# student(s).</h4></b></div>
<div align="center"><h4><b>Program:</b> #program_name.programname#</h4></b></div>
</cfoutput>
<hr width=80% color="000000">

<br>

<Table width=98% frame=below cellpadding=14 cellspacing="0">
	<tr>
		<td width=3%><u>ID</td><td width=14%><u>Last Name</td><td width=14%><u>First Name</td>
		<td width=14%><u>Middle Name</td><td width=6%><u>Sex</td><td width=9%><u>Date of Birth</td>
		<td width=10%><u>City of Birth</td><td width=10%><u>Country of Birth</td><td width=10%><u>Country of Citizenship</td>
		<td width=10%><u>Country of Residence</td> 
  	</tr>
	<cfoutput query="get_student">
	<tr bgcolor="#iif(get_student.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" >
		<td>#get_student.studentid#</td><td>#get_student.familylastname#</td><td>#get_student.firstname#</td>
		<td>#get_student.middlename#</td><td>#get_student.sex#</td><td>#DateFormat(get_student.dob, 'mm/dd/yyyy')#</td>
		<td>#get_student.citybirth#</td><td>#get_student.countrybirth#</td><td>#get_student.countrycitizen#</td>
		<td>#get_student.countryresident#</td>
	</tr>
	</cfoutput>
</Table>

<br>
<cfoutput>

<table width=98% cellpadding=2 cellspacing="0">
	<tr>
		<td valign="top"><div align="justify">
		Please take a look at all the information above. If there's anything wrong or misspelled, please correct it ON THIS FORM and return it to us dated and signed.
		</div></td></tr>
	<tr>
		<table>
			<tr><td valign="top"><div align="justify">
			Please review the report and make any necessary corrections. After you have made the corrections, sign the form, scan and email it back to me at <a href="#APPLICATION.EMAIL.admissions#">#APPLICATION.EMAIL.admissions#</a>.
			Once I receive the signed from, I will print the DS-2019 form for your student(s) and send them to you.
			</div></td>
			<td align="right">
				<table width="300" align="right" frame="border" cellpadding=2 cellspacing="0">
					<tr><td><u>Return check:</u><br><br></td></tr>
					<tr><td>Date: ________________________________</td></tr>
					<tr><td>Signature: ____________________________</td></tr>				
				</table>
			</td></tr>
		</table>
	</tr>
</table>
<br>
<table>
	<tr><td>Our best regards,</td></tr>
	<tr><td>#companyshort.verification_letter#</td></tr>
	<tr><td>Student Admissions Department</td></tr>
</table>

</cfoutput>

</div>