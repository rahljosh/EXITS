<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Student ID Cards</title>
</head>

<body>

<cfif not IsDefined('form.programid')>
	You must select at least one program. Please go back and try again.
	<cfabort>
</cfif>

<!--- Generate Avery Standard 5371 id cars for our students. --->

<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.4in 0.4in 0.46in;
	}
	div.Section1 {		
		page:Section1;
	}
	td.label {
		width:254.0pt;
		height:142.0pt;
	}
	p {
		margin-top:0in;
		margin-right:5.3pt;
		margin-bottom:0in;
		margin-left:5.3pt;
		mso-pagination:widow-orphan;
		font-size:10.0pt;
		font-family:"Arial";
	}
.style1 {font-size: 6pt} <!--- company address --->
.style2 {font-size: 7pt} <!--- host + rep info ---->
.style3 {font-size: 8pt} <!--- student's name ---->
.style4 {font-size: 10pt} <!--- company name ---->
.style5 {font-size: 5pt} 
</style>

<!--- Height = 5cm = 142 pixels = 1.96in / Width = 9cm = 255 pixels = 3.54in --->
			
<!--- Get names, addresses from our database --->
<cfquery name="get_students" datasource="mysql"> 
	SELECT 	DISTINCT php.studentid, s.familylastname, s.firstname, s.dateapplication, s.dob,
			php.active, php.i20no, 
			u.businessname,
			c.companyname, c.address AS c_address, c.city AS c_city, c.state AS c_state, c.zip AS c_zip, c.toll_free,
			sc.schoolname, sc.address as schooladdress, sc.city as schoolcity,
			sc.zip as schoolzip, sta.statename as schoolstate, sc.phone as schoolphone
	FROM php_students_in_program php
	INNER JOIN smg_students s ON php.studentid = s.studentid
	INNER JOIN smg_companies c ON php.companyid = c.companyid
	INNER JOIN smg_users u ON s.intrep = u.userid
	LEFT JOIN php_schools sc ON sc.schoolid = php.schoolid
	LEFT JOIN smg_states sta ON sta.id = sc.state
	WHERE php.active = '1'
		AND u.php_insurance_typeid = '#form.insurance_typeid#'
		<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
			AND php.datecreated between #CreateODBCDate(form.date1)# AND #CreateODBCDate(DateAdd('d', 1, form.date2))#
		</cfif>
		<cfif form.intrep NEQ '0'>AND s.intrep = '#form.intrep#'</cfif>
		AND ( <cfloop list="#form.programid#" index="prog">php.programid = #prog#
				<cfif prog is #ListLast(form.programid)#><Cfelse>or </cfif></cfloop> )							
	GROUP BY studentid
	ORDER BY u.businessname, s.familylastname, s.firstname
    
</cfquery>
					
            
<!--- The table consists has two columns, two labels. To identify where to place each, we need to maintain a column counter. --->


<div class="Section1">
				
	<cfset col=0> <!--- set variables --->
	<cfset pagebreak=0>
	
	<cfloop query="get_students">
	<cfoutput>
		<cfif pagebreak EQ "0">				
		<!--- Start a table for our labels --->
		<table align="center" width="670" border="0" cellspacing="2" cellpadding="0">
		</cfif>
		<!--- if this is the first column, then start a new row --->
		<cfif col EQ "0">
		<tr>
		</cfif>				
		<!--- Output the label --->			
			<td class="label" height="180" valign="top">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr><td height="13">&nbsp;</td></tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan="2" align="center" valign="top"><p class="style4"><b>DM Discoveries</b></p></td>
					</tr>
					<tr>
						<td width="32%" rowspan="2" align="center" valign="top"><img src="../pics/php-logo-s.jpg" border="0"/></td>
						<td colspan="2" align="center" valign="top"><p class="style4"><b>#companyname#</b></p></td>
					</tr>
					<tr>
						<td width="36%" align="center" valign="top">
							<p class="style1">#c_address#</p>
							<p class="style1">#c_city#, #c_state# &nbsp; #c_zip#</p>
							<p class="style1">#toll_free#</p>
						</td>
						<td width="32%" rowspan="2" align="center" valign="top" height="140">
							<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/web-students" name="stupicture" filter="#studentid#.*">
							<cfif stupicture.recordcount>
								<img src="http://www.student-management.com/nsmg/uploadedfiles/web-students/#stupicture.name#" width="100" height="135" border="0">
							<cfelse>
								<img src="../pics/no_stupicture.jpg" width="100" height="135" border="0">
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2" valign="top">
							<p class="style3">Student : <b>#firstname# #familylastname# (###studentid#)</b></p>
							<p class="style2">DOB : #DateFormat(dob, 'mm/dd/yyyy')#</p>
							<p class="style2">School : #schoolname#</p>
							<p class="style2">#schooladdress#</p>
							<p class="style2">#schoolcity#, #schoolstate# #schoolzip#</p>
							<p class="style2">#schoolphone#</p>
						</td>
					</tr>
				</table>
		  </td>
			<cfset col=col+1>						
			<!--- If it's column 2, then end the row and reset the column number. --->
			<cfif col EQ "2">
			</tr>
			<cfset col=0>			
			</cfif>
					
			<cfset pagebreak=pagebreak+1>
			
			<cfif pagebreak EQ "10"> <!--- close table and add a page break --->
				</table>
				<cfset pagebreak=0>
				<div style="page-break-before:always;"></div>					
			</cfif>	
	</cfoutput>
	</cfloop>
		<!--- If we didn't end on column 2, then we have to output blank labels --->
		<cfif col EQ "1">
			<td class="label" height="180">
				<p>&nbsp;</p>
			</td>
			</tr>		
		</cfif>
		</table>
</div>

</body>
</html>