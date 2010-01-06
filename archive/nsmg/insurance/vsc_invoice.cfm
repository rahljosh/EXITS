<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Virginia Surety - Invoice</title>
</head>

<body>

<cfoutput>

<!--- Standard Comprehensive --->
<cfparam name="form.vsc_7" default="1.40"> 

<!--- Standard Comprehensive $50 Deductible --->
<cfparam name="form.vsc_8" default="1.28"> 

<!--- Standard Comprehensive Premier --->
<cfparam name="form.vsc_9" default="1.53"> 

<cfset ise_students = 0>
<cfset into_students = 0>
<cfset asa_students = 0>
<cfset dmd_students = 0>
<cfset php_students = 0>

<cfset totalise = 0>
<cfset totalinto = 0>
<cfset totalasa = 0>
<cfset totaldmd = 0>
<cfset totalphp = 0>
<cfset totaltrainee = 0>

<cfquery name="insured_kids" datasource="MySql">
	SELECT i.insuranceid, i.companyid, i.studentid, i.firstname, i.lastname, i.sex, i.dob, i.country_code, i.new_date, i.end_date, i.org_code, i.policy_code,
		i.sent_to_caremed, i.transtype,
		c.companyshort,
		type.type
	FROM smg_insurance i
	LEFT JOIN smg_companies c ON i.companyid = c.companyid
	LEFT JOIN smg_insurance_type type ON i.policy_code = type.insutypeid
	WHERE i.policy_code between 7 and 9
	ORDER BY i.lastname
</cfquery>

<table width="90%" cellpadding=:"4" cellspacing="0" align="center">
	<tr><th>VIRGINIA SURETY STUDENTS</th></tr>
</table><br>

<table width="90%" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<td><b>Company</b></td>
		<td><b>Student</b></td>
		<td><b>Policy</b></td>
		<td><b>Start Date</b></td>
		<td><b>End Date</b></td>
		<td><b>Days</b></td>
		<td><b>Total</b></td>
	</tr>
	<cfloop query="insured_kids">
		<cfset totaldays = DateDiff('d',new_date, end_date)>
		<cfset totalstudent = totaldays * form["vsc_" & policy_code]>
		<tr bgcolor="#IIF(currentrow MOD 2, DE("white"), DE("C9C9C9") )#"> 
			<td>#companyshort#</td>
			<td>#firstname# #lastname# (###studentid#)</td>
			<td>#type#</td>
			<td>#DateFormat(new_date, 'mm/dd/yy')#</td>
			<td>#DateFormat(end_date, 'mm/dd/yy')#</td>
			<td>#totaldays# days * #form["vsc_" & policy_code]#</td>
			<td>#LSCurrencyFormat(totalstudent, 'local')#</td>
			<cfif companyid EQ 1>
				<cfset totalise = totalise + totalstudent>
				<cfset ise_students = ise_students + 1>
			<cfelseif companyid EQ 2>
				<cfset totalinto = totalinto + totalstudent>
				<cfset into_students = into_students + 1>
			<cfelseif companyid EQ 3>
				<cfset totalasa = totalasa + totalstudent>
				<cfset asa_students = asa_students + 1>
			<cfelseif companyid EQ 4>
				<cfset totaldmd = totaldmd + totalstudent>
				<cfset dmd_students = dmd_students + 1>
			<cfelseif companyid EQ 6>
				<cfset totalphp = totalphp + totalstudent>
				<cfset php_students = php_students + 1>
			</cfif>
		</tr>
	</cfloop>

	<!--- Trainees --->
	<cfset traineestudents = 7>
	
	<cfset Trainee1_start = '2007-08-17'>
	<cfset Trainee1_end = '2007-12-04'>
	
	<cfset Trainee2_start = '2007-08-17'>
	<cfset Trainee2_end = '2008-06-18'>
	
	<cfset Trainee3_start = '2007-08-17'>
	<cfset Trainee3_end = '2008-06-18'>
	
	<cfset Trainee4_start = '2007-08-17'>
	<cfset Trainee4_end = '2007-12-18'>
	
	<cfset Trainee5_start = '2007-08-17'>
	<cfset Trainee5_end = '2007-12-18'>
	
	<cfset Trainee6_start = '2007-08-17'>
	<cfset Trainee6_end = '2008-01-09'>
	
	<cfset Trainee7_start = '2007-07-10'>
	<cfset Trainee7_end = '2008-06-25'>
	
	<tr> 
		<cfset totaldaystrainee1 = DateDiff('d',Trainee1_start, Trainee1_end)>
		<cfset totaltrainee1 = totaldaystrainee1 * 1.40>
		<td>Trainee</td>
		<td>Hephzibah Rajarathinam</td>
		<td>Standard Comprehensive</td>
		<td>#DateFormat(Trainee1_start, 'mm/dd/yy')#</td>
		<td>#DateFormat(Trainee1_end, 'mm/dd/yy')#</td>
		<td>#totaldaystrainee1# days * 1.40</td>
		<td>#LSCurrencyFormat(totaltrainee1, 'local')#</td>
	</tr>
	
	<tr bgcolor="C9C9C9"> 
		<cfset totaldaystrainee2 = DateDiff('d',Trainee2_start, Trainee2_end)>
		<cfset totaltrainee2 = totaldaystrainee2 * 1.40>
		<td>Trainee</td>
		<td>Sudarshan Sinnasamy</td>
		<td>Standard Comprehensive</td>
		<td>#DateFormat(Trainee2_start, 'mm/dd/yy')#</td>
		<td>#DateFormat(Trainee2_end, 'mm/dd/yy')#</td>
		<td>#totaldaystrainee2# days * 1.40</td>
		<td>#LSCurrencyFormat(totaltrainee2, 'local')#</td>
	</tr>
	
	<tr> 
		<cfset totaldaystrainee3 = DateDiff('d',Trainee3_start, Trainee3_end)>
		<cfset totaltrainee3 = totaldaystrainee3 * 1.40>
		<td>Trainee</td>
		<td>Shafqat Hussain</td>
		<td>Standard Comprehensive</td>
		<td>#DateFormat(Trainee3_start, 'mm/dd/yy')#</td>
		<td>#DateFormat(Trainee3_end, 'mm/dd/yy')#</td>
		<td>#totaldaystrainee3# days * 1.40</td>
		<td>#LSCurrencyFormat(totaltrainee3, 'local')#</td>
	</tr>
	
	<tr bgcolor="C9C9C9"> 
		<cfset totaldaystrainee4 = DateDiff('d',Trainee4_start, Trainee4_end)>
		<cfset totaltrainee4 = totaldaystrainee4 * 1.40>
		<td>Trainee</td>
		<td>Carlos Torres Torres</td>
		<td>Standard Comprehensive</td>
		<td>#DateFormat(Trainee4_start, 'mm/dd/yy')#</td>
		<td>#DateFormat(Trainee4_end, 'mm/dd/yy')#</td>
		<td>#totaldaystrainee4# days * 1.40</td>
		<td>#LSCurrencyFormat(totaltrainee4, 'local')#</td>
	</tr>
		
	<tr> 
		<cfset totaldaystrainee5 = DateDiff('d',Trainee5_start, Trainee5_end)>
		<cfset totaltrainee5 = totaldaystrainee5 * 1.40>
		<td>Trainee</td>
		<td>Jennifer Villanueva</td>
		<td>Standard Comprehensive</td>
		<td>#DateFormat(Trainee5_start, 'mm/dd/yy')#</td>
		<td>#DateFormat(Trainee5_end, 'mm/dd/yy')#</td>
		<td>#totaldaystrainee5# days * 1.40</td>
		<td>#LSCurrencyFormat(totaltrainee5, 'local')#</td>
	</tr>
		
	<tr bgcolor="C9C9C9"> 
		<cfset totaldaystrainee6 = DateDiff('d',Trainee6_start, Trainee6_end)>
		<cfset totaltrainee6 = totaldaystrainee6 * 1.40>
		<td>Trainee</td>
		<td>Sagar Gosavi</td>
		<td>Standard Comprehensive</td>
		<td>#DateFormat(Trainee6_start, 'mm/dd/yy')#</td>
		<td>#DateFormat(Trainee6_end, 'mm/dd/yy')#</td>
		<td>#totaldaystrainee6# days * 1.40</td>
		<td>#LSCurrencyFormat(totaltrainee6, 'local')#</td>
	</tr>
		
	<tr> 
		<cfset totaldaystrainee7 = DateDiff('d',Trainee7_start, Trainee7_end)>
		<cfset totaltrainee7 = totaldaystrainee7 * 1.40>
		<td>Trainee</td>
		<td>Cynthia Namirimu</td>
		<td>Standard Comprehensive</td>
		<td>#DateFormat(Trainee7_start, 'mm/dd/yy')#</td>
		<td>#DateFormat(Trainee7_end, 'mm/dd/yy')#</td>
		<td>#totaldaystrainee7# days * 1.40</td>
		<td>#LSCurrencyFormat(totaltrainee7, 'local')#</td>
	</tr>
</table><br />

<cfset totalstudents = ise_students + into_students + asa_students + dmd_students + php_students + traineestudents>
<cfset totaltrainee = totaltrainee1 + totaltrainee2 + totaltrainee3 + totaltrainee4 + totaltrainee5 + totaltrainee6 + totaltrainee7>
<cfset totalinvoice = totalise + totalinto + totalasa + totaldmd + totalphp + totaltrainee>
	
	
<table width="90%" cellpadding="2" cellspacing="0" align="center">
	<tr><td width="55%">&nbsp;</td><th width="10%">Company</th><td width="20%" align="right"><b>Total of Students</b></td><td align="right" width="15%"><b>Total Invoice</b></td></tr>
	<tr><td>&nbsp;</td><td align="center">ISE</td><td align="right">#ise_students#</td><td align="right">#LSCurrencyFormat(totalise, 'local')#</td></tr>
	<tr><td>&nbsp;</td><td align="center">INTO</td><td align="right">#into_students#</td><td align="right">#LSCurrencyFormat(totalinto, 'local')#</td></tr>
	<tr><td>&nbsp;</td><td align="center">ASA</td><td align="right">#asa_students#</td><td align="right">#LSCurrencyFormat(totalasa, 'local')#</td></tr>	
	<tr><td>&nbsp;</td><td align="center">DMD</td><td align="right">#dmd_students#</td><td align="right">#LSCurrencyFormat(totaldmd, 'local')#</td></tr>
	<tr><td>&nbsp;</td><td align="center">PHP</td><td align="right">#php_students#</td><td align="right">#LSCurrencyFormat(totalphp, 'local')#</td></tr>
	<tr><td>&nbsp;</td><td align="center">Trainee</td><td align="right">#traineestudents#</td><td align="right">#LSCurrencyFormat(totaltrainee, 'local')#</td></tr>		
	<tr><td>&nbsp;</td><td colspan="3"><hr width="100%"/></td></tr>
	<tr><td>&nbsp;</td><td align="center"><b>Total SMG</b></td><td align="right"><b>#totalstudents#</b></td><td align="right"><b>#LSCurrencyFormat(totalinvoice, 'local')#</b></td></tr>	
</table><br>

</cfoutput>

<!---

-------------------------------------------------------------------- <br />

The SMG Group Insurance Premier Plan <br />
The SMG Group Standard Comp + Deductible <br />
The SMG Group StandardComprehensive Plan <br /><br />

<cfquery name="temp_vsc" datasource="MySql">
	SELECT id, field_name, start_position, length
	FROM temp_vsc
</cfquery>

<!--- Get the length of the ASCII ruler. --->
<cfset TotalColumnLength = 1203 />

<cfset col_list = '<cfloop from="1" to="1203" index="i">p</cfloop>'>

#col_list#<br /><br />

List = #Len(col_list)# <br /><br />


<cfquery name="insured_kids" datasource="MySql">
	SELECT insuranceid, companyid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code,
		sent_to_caremed, transtype
	FROM smg_insurance
	WHERE policy_code between 7 and 9
	ORDER BY companyid, sent_to_caremed
	LIMIT 10
</cfquery>

<cffile action="write" file ="/var/www/html/student-management/nsmg/uploadedfiles/vsc.txt" output="" mode="777">


<cfloop query="insured_kids">
	<cfset new_line = '#firstname# #lastname# ###studentid# - #companyid# #Chr( 13 )# #Chr( 10 )#'>
	
	<cffile action="append" file ="/var/www/html/student-management/nsmg/uploadedfiles/vsc.txt" output="#new_line#" addnewline="yes" charset="us-ascii" mode="777">
	
</cfloop>




<!------------------------------------------------------------------------------------->


<!--- Get the length of the ASCII ruler. --->
<cfset intRulerLength = 150 />

<!--- Get the ruler height. This is the number of digits that the max value will have. Since the rule will count up from
1, the max height will be determined by the last value in the ruler (ie. the length of the ruler). --->
<cfset intRulerHeight = Len( intRulerLength ) />

<!--- Create the array in which to build the output. This is a two-dimensional array. The first index is going to create
the ROW of the output (digit column). The Second index is going to be the COLUMN of the output (the index on the ruler. --->
<cfset arrRuler = ArrayNew( 2 ) />

<!--- Now, let's start building the ruler output by looping from 1 to the length of the ruler. --->
<cfloop index="intColumn" from="1" to="#intRulerLength#">

	<!--- Check to see if we are at a power of 10 (MOD will not return a remainder). If we are, then we need to display
	all digits, otherwise, we are just going to display the ones digit column. --->
	<cfif (intColumn MOD 10)>
	
		<!--- Fill the entire column with spaces. --->
		<cfloop index="intDigit" from="1" to="#intRulerHeight#">
		<cfset arrRuler[ intDigit ][ intColumn ] = " " />
		</cfloop>
		
		<!--- Now that we have filled the column with spaces, put  the ones digit in the last space. --->
		<cfset arrRuler[ intRulerHeight ][ intColumn ] = (intColumn MOD 10) />
		
	<cfelse>
	
		<!--- We need to output the entire value in the output. But, this value might not be the same length as the
		max value length. Therefore, we need to right-justify the value to fit exactly with the ruler's height. --->
		<cfset strValue = RJustify(intColumn, intRulerHeight) />
		
		<!--- Now loop over the value and apply to the ruler output array. --->
		<cfloop index="intDigit" from="1" to="#intRulerHeight#">
			<cfset arrRuler[ intDigit ][ intColumn ] = Mid(strValue, intDigit, 1) />
		</cfloop>
	</cfif>
</cfloop>

<!--- ASSERT: At this point, the entire output for the ASCII ruler should be stored in the ruler array. Now, we need to
translate that into a horizontal ruler. To make this faster and control the white space, let's create a Java string 
buffer to which we can systematically append output data. --->
<cfset sbOutput = CreateObject("java", "java.lang.StringBuffer").Init() />

<!--- Loop over the ruler array and append to output. Since we need to output the ruler horizontally, we need to do each row at a time. --->

<cfloop index="intDigit" from="1" to="#intRulerHeight#">
	<!--- For each row of digits, loop over every column. --->
	<cfloop index="intColumn" from="1" to="#intRulerLength#">
		<!--- When appending, we need to convert the array data to a string to make sure Java don't choke. --->
		<cfset sbOutput.Append(JavaCast("string",arrRuler[ intDigit ][ intColumn ])) />
	</cfloop>
	<!--- After each row, add a line break. --->
	<cfset sbOutput.Append(JavaCast("string",Chr( 13 ) & Chr( 10 ))) />
</cfloop>

<!--- Output the ASCII data in PRE tags for best formatting. --->
<pre>#sbOutput.ToString()#</pre>

</cfoutput>

--->

</body>
</html>