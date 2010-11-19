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
	<title>Page [14] - Authorization to Treat a Minor</title>	
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfoutput query="get_student_info">

<cfset doc = 'page14'>

<!--- PRINT ATTACHED FILE INSTEAD OF PAGE --->
<cfif NOT IsDefined('url.curdoc')>
	<cfinclude template="../print_include_file.cfm">
<cfelse>
	<cfset printpage = 'yes'>	
</cfif>

<!--- PRINT PAGE IF THERE IS NO ATTACHED FILE OR FILE IS PDF OR DOC --->
<cfif printpage EQ 'yes'>

	<cfif not IsDefined('url.curdoc')>
	<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
	<tr><td>
	</cfif>
	
	<!--- HEADER OF TABLE --->
	<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
		<tr height="33">
			<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
			<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
			<td class="tablecenter"><h2>Page [14] - Authorization to Treat a Minor</h2></td>
			<cfif IsDefined('url.curdoc')>
			<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page14print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
			</cfif>
			<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
		</tr>
	</table>
	
	<div class="section"><br>
	
	<cfif IsDefined('url.curdoc')>
		<cfinclude template="../check_upl_print_file.cfm">
	</cfif>
	
	<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
		<tr><td>1. (We) the undersigned parent(s), or legal guardian of:</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>
				<div align="justify">
				<u>#get_student_info.firstname# #get_student_info.familylastname#,</u> a minor, do hereby authorize and consent to any x-ray
				examination, anesthetic, or medical or surgical diagnosis rendered under the general or special supervision of any member
				of the medical staff and emergency room staff licensed under the provisions of the Medicine Practice Act, or a dentist
				licensed under the provisions of the Dental Practice Act and on the staff of any acute general hospital holding a current
				license to operate a hospital. It is understood that this authorization is given in advance of any specific diagnosis, 
				treatment, or hospital care being required, but is given to provide authority and power to render care which the
				aforementioned physician in the exercise of his best judgment may deem advisable. It is understood that effort shall be
				made to contact the undersigned prior to rendering treatment to the patient, but that any of the above treatment will not
				be withheld if the undersigned cannot be reached.<br>
				Furthermore, we (parents/guardian) want to assure you that we will reimburse any expenditure not covered by the accident
				and sickness insurance policy of the exchange organization.
				</div>
		</td></tr>
	</table><br>
	
	<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
		<tr><td><em>List any restrictions:</em></td></tr>
		<tr><td>#app_med_restrictions#<br><img src="#path#pics/line.gif" width="400" height="1" border="0" align="absmiddle"></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td><em>Allergies to Drugs or Foods:</em></td></tr>
		<tr><td>#other_allergies#<br><img src="#path#pics/line.gif" width="400" height="1" border="0" align="absmiddle"></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td><em>List medications taken regularly:</em></td></tr>
		<tr><td>#app_med_take_medication#<br><img src="#path#pics/line.gif" width="400" height="1" border="0" align="absmiddle"></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td><em>Special Medications or pertinent information:</em></td></tr>
		<tr><td>#app_med_special_medication#<br><img src="#path#pics/line.gif" width="400" height="1" border="0" align="absmiddle"></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td><em>Date of last tetanus toxide booster</em></td></tr>
		<tr><td>#DateFormat(app_med_tetanus_shot, 'mm/dd/yyyy')#<br><img src="#path#pics/line.gif" width="400" height="1" border="0" align="absmiddle"></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table><br>
	
	<hr class="bar"></hr><br>
	
	<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td><em>Family Physician</em></td><td>&nbsp;</td><td colspan="2"><em>Phone</em></td></tr>
		<tr>
			<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		</tr>
		<tr><td width="315"><em>Address</em></td><td width="40">&nbsp;</td><td width="160"><em>City</em></td><td width="155"><em>Country</em></td></tr>
		<tr>
			<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td><br><img src="#path#pics/line.gif" width="160" height="1" border="0" align="absmiddle"></td>
			<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
		</tr>
	</table><br><br>
	
	<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td><em>Parent/Guardian Signature</em></td><td>&nbsp;</td><td colspan="2"><em>Date</td></tr>
		<tr>
			<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		</tr>
		<tr><td width="315"><em>Address</em></td><td width="40">&nbsp;</td><td width="160"><em>City</em></td><td width="155"><em>Country</em></td></tr>
		<tr>
			<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td><br><img src="#path#pics/line.gif" width="160" height="1" border="0" align="absmiddle"></td>
			<td><br><img src="#path#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
		</tr>
		<tr><td colspan="4"><em>Telephone where Parent/Guardian may be reached</em></td></tr>
		<tr><td><em>Business</em></td><td>&nbsp;</td><td colspan="2"><em>Home</em></td></tr>
		<tr>
			<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		</tr>
	</table><br><br>
	</div>
	
	<!--- FOOTER OF TABLE --->
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr height="8">
			<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
			<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
			<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
		</tr>
	</table>
	
	
	<cfif not IsDefined('url.curdoc')>
	</td></tr>
	</table>
	</cfif>

</cfif>

</cfoutput>
</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>