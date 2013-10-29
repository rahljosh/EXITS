<cfscript>
	// These are used to set the vStudentAppRelativePath directory for images nsmg/student_app/pics and uploaded files nsmg/uploadedFiles/
	// Param Variables
	param name="vStudentAppRelativePath" default="../";
	param name="vUploadedFilesRelativePath" default="../../";
	
	if ( LEN(URL.curdoc) ) {
		vStudentAppRelativePath = "";
		vUploadedFilesRelativePath = "../";
	}
</cfscript>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#vStudentAppRelativePath#app.css"</cfoutput>>
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfscript>
	// Get Canada Area Choice
	qGetSelectedCanadaAreaChoice = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='canadaAreaChoice',fieldID=get_student_info.app_canada_area);
</cfscript>
<cfquery name="get_intrep" datasource="#APPLICATION.DSN#">
	SELECT userid, businessname
	FROM smg_users 
	WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value='#VAL(get_student_info.intrep)#'>
</cfquery>
<cfquery name="country_list" datasource="#APPLICATION.DSN#">
	SELECT countryid, countryname
	FROM smg_countrylist
	ORDER BY Countryname
</cfquery>
<cfquery name="religion_list" datasource="#APPLICATION.DSN#">
	SELECT religionid, religionname
	FROM smg_religions
	ORDER BY religionname
</cfquery>
<cfquery name="app_programs" datasource="#APPLICATION.DSN#">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student_info.app_indicated_program)#">
</cfquery>
<cfquery name="assignedProgram" datasource="#APPLICATION.DSN#">
    SELECT programname
    FROM smg_programs
    WHERE programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student_info.programid)#">
</cfquery>
<cfquery name="app_other_programs" datasource="#APPLICATION.DSN#">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student_info.app_additional_program)#">
</cfquery> 

<cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#client.studentid#.*">

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0 border=0> 
<tr><td>
</cfif>

<cfoutput query="get_student_info">

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#vStudentAppRelativePath#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [01] - Student's Information</h2></td>
		<cfif LEN(URL.curdoc)>
			<td align="right" class="tablecenter">
            	<a href="" onClick="javascript: win=window.open('section1/page1print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;">
                	<img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img>
             	</a>
                &nbsp;&nbsp;
         	</td>
		</cfif>
		<td width="42" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
	<tr>
		<td width="160">
			<table width="100%" align="left" cellpadding="0" cellspacing="0">
			<tr><td align="left" valign="top">
				<cfif file.recordcount>
					<img src="#vUploadedFilesRelativePath#uploadedfiles/web-students/#file.name#" width="130" height="150"><br>
				<cfelse>
					<img src="#vStudentAppRelativePath#pics/no_image.gif" border=0 width="130" height="150">
				</cfif>
				</td>
			</tr>
			</table>
		</td>
		<td width="500">
			<table width="100%" align="left" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="3"><b>Student's Name</b></td>
				</tr>
				<tr>
					<td width="200"><em>Family Name</em></td>
					<td width="180"><em>First Name</em></td>
					<td width="140"><em>Middle Name</em></td>		
				</tr>
				<tr>
					<td valign="top">#familylastname#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="195" height="1" border="0" align="absmiddle"></td>
					<td valign="top">#firstname#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="175" height="1" border="0" align="absmiddle"></td>
					<td valign="top">#middlename#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="135" height="1" border="0" align="absmiddle"></td>
				</tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">
						<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center">	
							<tr><td colspan="2"><b>Program Information</b></td></tr>
							<tr>
								<td><em>Program</em></td>
								<td><em>Additional Programs</em></td>
							</tr>
							<tr>
								<td>#assignedProgram.programname# - #app_programs.app_program# <cfif LEN(qGetSelectedCanadaAreaChoice.name)> - #qGetSelectedCanadaAreaChoice.name# <cfelse>To be Defined</cfif> <br><img src="#vStudentAppRelativePath#pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
								<td><cfif app_other_programs.recordcount EQ '0'>None<cfelse>
                                <cfloop list="#get_student_info.app_additional_program#" index=i>
                                <cfquery name="app_other_programs" datasource="#APPLICATION.DSN#">
                                    SELECT app_programid, app_program 
                                    FROM smg_student_app_programs
                                    WHERE app_programid = '#i#'
                                </cfquery> 
                                #app_other_programs.app_program#, 
                                </cfloop>
                                </cfif><br><img src="#vStudentAppRelativePath#pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
						</table>
				</td></tr>
				<tr>
					<td colspan="3"><b>International Representative</b></td>
				</tr>
				<tr>
					<td colspan="3" width="520">#get_intrep.businessname#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="515" height="1" border="0" align="absmiddle"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<hr class="bar"></hr>

<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
<tr><td colspan="3"><b>Complete Mailing Address</b></td></tr>
<tr>
	<td width="48%" valign="top">
		<table border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Street Address</em></td></tr>
			<tr><td colspan="2">#address#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>City</em></td></tr>
			<tr><td colspan="2">#city#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td width="160"><em>Zip Code</em></td><td width="160"><em>Country</em></td></tr>
			<tr>
				<td>#zip#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>			
				<td><cfloop query="country_list"><cfif get_student_info.country is countryid>#countryname#</cfif></cfloop>
					<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>	
			<tr><td>&nbsp;</td></tr>	
			<tr><td><em>Telephone No.</em></td><td><em>Fax No.</em></td></tr>
			<tr>
				<td>#phone#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>#fax#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>				
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>E-Mail</em></td></tr>
			<tr><td colspan="2">#email#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>	
			<tr><td><em>Sex</em></td><td><em>Date of Birth <font size="-2">(mm/dd/yyyy)</font></em></td></tr>
			<tr>
				<td>
					<cfif sex is 'male'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Male &nbsp; 
					<cfif sex is 'female'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Female &nbsp;&nbsp;&nbsp;
					<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle">
				</td>
				<td>#DateFormat(dob, 'mm/dd/yyyy')#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>
		</table>	
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top" align="left">
		<table border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Place of Birth</em></td></tr>
			<tr><td colspan="2">#citybirth#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Birth</em></td></tr>
			<tr><td colspan="2">
					<cfloop query="country_list"><cfif get_student_info.countrybirth is countryid>#countryname#</cfif></cfloop>
					<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Citizenship</em></td></tr>
			<tr><td colspan="2">
				<cfloop query="country_list"><cfif get_student_info.countrycitizen is countryid>#countryname#</cfif></cfloop>
				<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Legal Permanent Residence</em></td></tr>
			<tr><td colspan="2">
				<cfloop query="country_list"><cfif get_student_info.countryresident is countryid>#countryname#</cfif></cfloop>
				<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Religious Affiliation</em></td></tr>
			<tr><td colspan="2">
				<!--- Check if student set religion to atheist, if it is print "Not interested" --->
                <cfif get_student_info.religiousaffiliation EQ 3>
					Not interested	                
                <cfelse>
	                <cfloop query="religion_list"><cfif get_student_info.religiousaffiliation EQ religionid>#religionname#</cfif></cfloop>                
                </cfif>
				<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>			
			<tr><td colspan="2"><em>Passport Number (if known)</em></td></tr>
			<tr><td colspan="2">#passportnumber#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
		</table>	
	</td>
</tr>
</table>

<hr class="bar"></hr>

<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
<tr><td colspan="2"><b>FAMILY INFORMATION</b></td></tr>
<tr>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Father's Name</em></td></tr>
			<tr><td colspan="2">#fathersname#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>					
			<tr><td colspan="2">#fatheraddress#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country</em></td></tr>
			<tr><td colspan="2">
				<cfloop query="country_list"><cfif get_student_info.fathercountry is countryid>#countryname#</cfif></cfloop>
				<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td width="160"><em>Date of Birth <font size="-2">(mm/dd/yyyy)</font></em></td><td width="160"><em>Speaks English</em></td></tr>	
			<tr>
				<td>#DateFormat(fatherDOB, 'mm/dd/yyyy')#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>
					<cfif fatherenglish is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Yes &nbsp; &nbsp;
					<cfif fatherenglish is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> No 
					<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Business Phone</em></td><td><em>Employed By</em></td></tr>
			<tr>
				<td>#fatherworkphone#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>#fathercompany#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Occupation</em></td></tr>
			<tr><td colspan="2">#fatherworkposition#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
		</table>
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Mother's Name</em></td></tr>
			<tr><td colspan="2">#mothersname#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>
			<tr><td colspan="2">#motheraddress#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country</em></td></tr>
			<tr><td colspan="2">
				<cfloop query="country_list"><cfif get_student_info.mothercountry is countryid>#countryname#</cfif></cfloop>
				<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Date of Birth <font size="-2">(mm/dd/yyyy)</font></em></td><td><em>Speaks English</em></td></tr>	
			<tr>
				<td>#DateFormat(motherDOB, 'mm/dd/yyyy')#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>
					<cfif motherenglish is 'yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Yes &nbsp; &nbsp;
					<cfif motherenglish is 'no'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> No 
					<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td width="155"><em>Business Phone</em></td><td width="155"><em>Employed By</em></td></tr>
			<tr>
				<td>#motherworkphone#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>#mothercompany#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Occupation</em></td></tr>
			<tr><td colspan="2">#motherworkposition#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
		</table>
	</td>
</tr>
</table>

<hr class="bar"></hr>

<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
<tr><td colspan="2"><b>EMERGENCY CONTACT</b></td></tr>
<tr>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Name</em></td></tr>
			<tr><td colspan="2">#emergency_name#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>
			<tr><td colspan="2">#emergency_address#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>	
		</table>	
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td><em>Phone Number</em></td></tr>
			<tr><td>#emergency_phone#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Country</em></td></tr>
			<tr><td>
			<cfloop query="country_list"><cfif get_student_info.emergency_country is countryid>#countryname#</cfif></cfloop>
				<br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
		</table>
	</td>
</tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#vStudentAppRelativePath#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#vStudentAppRelativePath#pics/p_spacer.gif"></td>
		<td width="42"><img src="#vStudentAppRelativePath#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

</body>
</html>