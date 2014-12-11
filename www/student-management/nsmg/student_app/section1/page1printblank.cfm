<cftry>

<cfif LEN(URL.curdoc) OR IsDefined('url.path')>
	<cfset path = "">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [01] - Student's Information</title>
	<style type="text/css">
	<!--
	body {
		margin-left: 0.3in;
		margin-top: 0.3in;
		margin-right: 0.3in;
		margin-bottom: 0.3in;
	}
	-->
	</style>	
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfoutput>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0> 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [01] - Student's Information</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page1printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
	<tr>
		<td width="150" rowspan="11" align="left">
				<img src="#path#pics/no_image.gif" border=0>
		</td>
		<td colspan="3"><b>Student's Name</b></td>
	</tr>
	<tr>
		<td width="200"><em>Family Name</em></td>
		<td width="180"><em>First Name</em></td>
		<td width="140"><em>Middle Name</em></td>		
	</tr>
	<tr>
		<td valign="top"><br><img src="#path#pics/line.gif" width="195" height="1" border="0" align="absmiddle"></td>
		<td valign="top"><br><img src="#path#pics/line.gif" width="175" height="1" border="0" align="absmiddle"></td>
		<td valign="top"><br><img src="#path#pics/line.gif" width="135" height="1" border="0" align="absmiddle"></td>
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
					<td><br><img src="#path#pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
					<td><br><img src="#path#pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
	</td></tr>
	<tr>
		<td colspan="3"><b>International Representative</b></td>
	</tr>
	<tr>
		<td colspan="3" width="520"><br><img src="#path#pics/line.gif" width="515" height="1" border="0" align="absmiddle"></td>
	</tr>
</table>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
<tr><td colspan="3"><b>Complete Mailing Address</b></td></tr>
<tr>
	<td width="48%" valign="top">
		<table border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Street Address</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>City</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td width="160"><em>Zip Code</em></td><td width="160"><em>Country</em></td></tr>
			<tr>
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>			
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>	
			<tr><td>&nbsp;</td></tr>	
			<tr><td><em>Telephone No.</em></td><td><em>Fax No.</em></td></tr>
			<tr>
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>				
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>E-Mail</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>	
			<tr><td><em>Sex</em></td><td><em>Date of Birth <font size="-2">(mm/dd/yyyy)</font></em></td></tr>
			<tr>
				<td>
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Male &nbsp; 
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Female &nbsp;&nbsp;&nbsp;
					<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle">
				</td>
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>
		</table>	
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top" align="left">
		<table border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Place of Birth</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Birth</em></td></tr>
			<tr><td colspan="2">
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Citizenship</em></td></tr>
			<tr><td colspan="2">
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country of Legal Permanent Residence</em></td></tr>
			<tr><td colspan="2">
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Religious Affiliation</em></td></tr>
			<tr><td colspan="2">
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>			
			<tr><td colspan="2"><em>Passport Number (if known)</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
		</table>	
	</td>
</tr>
</table>

<br>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
<tr><td colspan="2"><b>FAMILY INFORMATION</b></td></tr>
<tr>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Father's Name</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>					
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country</em></td></tr>
			<tr><td colspan="2">
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td width="160"><em>Date of Birth <font size="-2">(mm/dd/yyyy)</font></em></td><td width="160"><em>Speaks English</em></td></tr>	
			<tr>
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No 
					<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Business Phone</em></td><td><em>Employed By</em></td></tr>
			<tr>
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Occupation</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
		</table>
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Mother's Name</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Country</em></td></tr>
			<tr><td colspan="2">
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Date of Birth <font size="-2">(mm/dd/yyyy)</font></em></td><td><em>Speaks English</em></td></tr>	
			<tr>
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td>
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No 
					<br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td width="155"><em>Business Phone</em></td><td width="155"><em>Employed By</em></td></tr>
			<tr>
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
				<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Occupation</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
		</table>
	</td>
</tr>
</table>

<br>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
<tr><td colspan="2"><b>EMERGENCY CONTACT</b></td></tr>
<tr>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td colspan="2"><em>Name</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><em>Address</em></td></tr>
			<tr><td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>	
		</table>	
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td><em>Phone Number</em></td></tr>
			<tr><td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Country</em></td></tr>
			<tr><td>
				<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			</tr>
		</table>
	</td>
</tr>
</table><br>
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

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</body></html></cftry>


