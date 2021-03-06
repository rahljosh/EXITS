<cftry>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelseif IsDefined('url.exits_app')>
	<cfset path = "internal/student_app/">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [20] - Regional Guarantee</title>
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page20'>

<cfquery name="check_guarantee" datasource="caseusa">
	SELECT app_region_guarantee
	FROM smg_students
	WHERE studentid = '#get_student_info.studentid#'
</cfquery>

<!---- International Rep - EF ACCOUNTS ---->
<cfquery name="int_agent" datasource="caseusa">
	SELECT u.businessname, u.userid, u.master_account, u.master_accountid
	FROM smg_users u
	WHERE u.userid = <cfif get_student_info.branchid EQ '0'>'#get_student_info.intrep#'<cfelse>'#get_student_info.branchid#'</cfif>
</cfquery>

<cfoutput>

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
			<td class="tablecenter"><h2>Page [20] - Regional Guarantee</h2></td>
			<cfif IsDefined('url.curdoc')>
			<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page20print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
			</cfif>
			<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
		</tr>
	</table>
	
	<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 --->
	<cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND (int_agent.master_accountid EQ 10115 OR int_agent.userid EQ 10115 OR int_agent.userid EQ 8318)>
		<div class="section"><br><br>
		<table width="670" cellpadding=2 cellspacing=0 align="center">
			<tr>
				<td>Currently, you are unable to request a Regional Guarantee online.  You are still able to request them, you just need to contact your
				#int_agent.businessname# Representative.  Contact information is listed above.  
				</td>
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
		<cfabort>
	</cfif>
	
	<div class="section"><br>
	
	<cfif IsDefined('url.curdoc')>
		<cfinclude template="../check_upl_print_file.cfm">
	</cfif>
	
	<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
		<tr>
			<td width="110"><em>Student's Name</em></td>
			<td width="560">#get_student_info.firstname# #get_student_info.familylastname#<br><img src="#path#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
		</tr>
	</table><br>
	
	<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
		<tr><td>You can choose your region if you so desire. Both the Semester and Academic Year students can choose a region.<br>
				You must request a guarantee by printing and signing this page. Your applicaion must be received in the U.S. Office prior to April 15th.</td></tr>
	</table><br>
	
	<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
		<tr><td><div align="justify">
			If you would like to specify a region, select option A, 
			confirm your request of region, print this page, sign it and upload it back into the system with original signatures.<br>
			If you do not want a regional guarantee, select option B. 
			If option B is selected you do not need to print this page, sign it and upload it back into the system.</div><br><br></td></tr>	
		<tr>
			<td>A. <cfif check_guarantee.app_region_guarantee NEQ '0'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>
					I would like to request a specific regional guarantee.<br></td>
		</tr>	
		<tr>
			<td>B. <cfif check_guarantee.app_region_guarantee EQ '0'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>
					I do not wish a regional guarantee.<br><br></td>
		</tr>	
		<tr><td>			
				<b>Note: If you do select a regional guarantee, there will be a $300.00 Extra Charge.</b><br><br>
				
				<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center">
					<tr>
						<td valign="top"><cfif check_guarantee.app_region_guarantee EQ '1'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>Region 1 - East<br><img src="#path#pics/region1.gif"></td>
						<td valign="top"><cfif check_guarantee.app_region_guarantee EQ '2'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>Region 2 - South<br><img src="#path#pics/region2.gif"></td>
					</tr>
					<tr>
						<td valign="top"><cfif check_guarantee.app_region_guarantee EQ '3'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>Region 3 - Central<br><img src="#path#pics/region3.gif"></td>
						<td valign="top"><cfif check_guarantee.app_region_guarantee EQ '4'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>Region 4 - Rocky Mountain<br><img src="#path#pics/region4.gif"></td>
						<td valign="top"><cfif check_guarantee.app_region_guarantee EQ '5'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>Region 5 - West<br><img src="#path#pics/region5.gif"></td>
					</tr>
				</table>			
			</td>
		</tr>
	</table><br><br>
	
	<table width="660" border=0 cellpadding=0 cellspacing=0 align="center">
		<tr>
			<td width="315"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td width="40"></td>
			<td width="315"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		</tr>
		<tr>
			<td>Student's Name (print clearly)</td>
			<td></td>
			<td>Student's Signature</td>
		</tr>
	</table><br><br>
	<table width="660" border=0 cellpadding=0 cellspacing=0 align="center">
		<tr>
			<td width="315"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td width="40"></td>
			<td width="315"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		</tr>
		<tr>
			<td>Parent's Name (print clearly)</td>
			<td></td>
			<td>Parent's Signature</td>
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
	
	<cfif not IsDefined('url.curdoc')>
		</td></tr>
		</table>
		<cfinclude template="../print_include_file.cfm">
	</cfif>

</cfif>

</cfoutput>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
