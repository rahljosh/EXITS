<cftry>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelseif IsDefined('url.exits_app')>
	<cfset path = "nsmg/student_app/">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [01] - Student's Information</title>
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_intrep" datasource="MySql">
	SELECT userid, businessname
	FROM smg_users 
	WHERE userid = '#get_student_info.intrep#'
</cfquery>

<cfquery name="country_list" datasource="MySQL">
	SELECT countryid, countryname
	FROM smg_countrylist
	ORDER BY Countryname
</cfquery>

<cfquery name="religion_list" datasource="MySQL">
	SELECT religionid, religionname
	FROM smg_religions
	ORDER BY religionname
</cfquery>

<cfquery name="app_programs" datasource="MySQL">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_programid = '#get_student_info.app_indicated_program#'
</cfquery>
 
<cfquery name="app_other_programs" datasource="MySQL">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_programid = '#get_student_info.app_additional_program#'
</cfquery> 

<cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#client.studentid#.*">

<cfif NOT IsDefined('url.curdoc')>
<table align="center" width=90% cellpadding=0 cellspacing=0 border=0> 
<tr><td>
</cfif>

<cfoutput query="get_student_info">

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [01] - Student's Information</h2></td>
		<cfif IsDefined('url.curdoc')>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page1print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
	<tr>
		<td width="160">
			<table width="100%" align="left" cellpadding="0" cellspacing="0">
			<tr><td align="left" valign="top">
				<cfif file.recordcount>
					<img src="#path#../uploadedfiles/web-students/#file.name#" width="130" height="150"><br>
				<cfelse>
					<img src="#path#pics/no_image.gif" border=0 width="130" height="150">
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
					<td valign="top">#familylastname#<br><img src="#path#pics/line.gif" width="195" height="1" border="0" align="absmiddle"></td>
					<td valign="top">#firstname#<br><img src="#path#pics/line.gif" width="175" height="1" border="0" align="absmiddle"></td>
					<td valign="top">#middlename#<br><img src="#path#pics/line.gif" width="135" height="1" border="0" align="absmiddle"></td>
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
								<td>#app_programs.app_program# <cfif LEN(get_student_info.app_canada_area)> - #get_student_info.app_canada_area#</cfif> <br><img src="#path#pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
								<td><cfif app_other_programs.recordcount EQ '0'>None<cfelse>#app_other_programs.app_program#</cfif><br><img src="#path#pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
						</table>
				</td></tr>
				<tr>
					<td colspan="3"><b>International Representative</b></td>
				</tr>
				<tr>
					<td colspan="3" width="520">#get_intrep.businessname#<br><img src="#path#pics/line.gif" width="515" height="1" border="0" align="absmiddle"></td>
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
			<tr><td colspan="2">#address#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>City</em></td></tr>
			<tr><td colspan="2">#city#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td width="160"><em>Zip Code</em></td><td width="160"><em>Country</em></td></tr>
			<tr>
				<td>#zip#<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>			
				<td><cfloop query="country_list"><cfif get_student_info.country is countryid>#countryname#</cfif></cfloop>
					<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>	
			<tr><td>&nbsp;</td></tr>	
			<tr><td><em>Telephone No.</em></td><td><em>Fax No.</em></td></tr>
			<tr>
				<td>#phone#<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>#fax#<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>				
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>E-Mail</em></td></tr>
			<tr><td colspan="2">#email#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>	
			<tr><td><em>Sex</em></td><td><em>Date of Birth <font size="-2">(mm/dd/yyyy)</font></em></td></tr>
			<tr>
				<td>
					<cfif sex is 'male'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Male &nbsp; 
					<cfif sex is 'female'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Female &nbsp;&nbsp;&nbsp;
					<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle">
				</td>
				<td>#DateFormat(dob, 'mm/dd/yyyy')#<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>
		</table>	
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top" align="left">
		<table border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Place of Birth</em></td></tr>
			<tr><td colspan="2">#citybirth#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Birth</em></td></tr>
			<tr><td colspan="2">
					<cfloop query="country_list"><cfif get_student_info.countrybirth is countryid>#countryname#</cfif></cfloop>
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Citizenship</em></td></tr>
			<tr><td colspan="2">
				<cfloop query="country_list"><cfif get_student_info.countrycitizen is countryid>#countryname#</cfif></cfloop>
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Legal Permanent Residence</em></td></tr>
			<tr><td colspan="2">
				<cfloop query="country_list"><cfif get_student_info.countryresident is countryid>#countryname#</cfif></cfloop>
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
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
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>			
			<tr><td colspan="2"><em>Passport Number (if known)</em></td></tr>
			<tr><td colspan="2">#passportnumber#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
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
			<tr><td colspan="2">#fathersname#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>					
			<tr><td colspan="2">#fatheraddress#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country</em></td></tr>
			<tr><td colspan="2">
				<cfloop query="country_list"><cfif get_student_info.fathercountry is countryid>#countryname#</cfif></cfloop>
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td width="160"><em>Year of Birth (yyyy)</em></td><td width="160"><em>Speaks English</em></td></tr>	
			<tr>
				<td>#fatherbirth#<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>
					<cfif fatherenglish is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Yes &nbsp; &nbsp;
					<cfif fatherenglish is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> No 
					<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Business Phone</em></td><td><em>Employed By</em></td></tr>
			<tr>
				<td>#fatherworkphone#<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>#fathercompany#<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Occupation</em></td></tr>
			<tr><td colspan="2">#fatherworkposition#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
		</table>
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Mother's Name</em></td></tr>
			<tr><td colspan="2">#mothersname#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>
			<tr><td colspan="2">#motheraddress#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country</em></td></tr>
			<tr><td colspan="2">
				<cfloop query="country_list"><cfif get_student_info.mothercountry is countryid>#countryname#</cfif></cfloop>
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Year of Birth (yyyy)</em></td><td><em>Speaks English</em></td></tr>	
			<tr>
				<td>#motherbirth#<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>
					<cfif motherenglish is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Yes &nbsp; &nbsp;
					<cfif motherenglish is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> No 
					<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td width="155"><em>Business Phone</em></td><td width="155"><em>Employed By</em></td></tr>
			<tr>
				<td>#motherworkphone#<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>#mothercompany#<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Occupation</em></td></tr>
			<tr><td colspan="2">#motherworkposition#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
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
			<tr><td colspan="2">#emergency_name#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>
			<tr><td colspan="2">#emergency_address#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>	
		</table>	
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td><em>Phone Number</em></td></tr>
			<tr><td>#emergency_phone#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Country</em></td></tr>
			<tr><td>
			<cfloop query="country_list"><cfif get_student_info.emergency_country is countryid>#countryname#</cfif></cfloop>
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
		</table>
	</td>
</tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif not IsDefined('url.curdoc')>
</td></tr>
</table>
</cfif>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>