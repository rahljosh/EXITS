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
	<title>Page [21] - State Guarantee</title>
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page21'>

<cfquery name="states_requested" datasource="caseusa">
	SELECT state1, sta1.statename as statename1, state2, sta2.statename as statename2, state3, sta3.statename as statename3
	FROM smg_student_app_state_requested 
	LEFT JOIN smg_states sta1 ON sta1.id = state1
	LEFT JOIN smg_states sta2 ON sta2.id = state2
	LEFT JOIN smg_states sta3 ON sta3.id = state3
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
			<td class="tablecenter"><h2>Page [21] - State Guarantee</h2></td>
			<cfif IsDefined('url.curdoc')>
			<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page21print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
			</cfif>
			<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
		</tr>
	</table>
	
	<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 --->
	<cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND (int_agent.master_accountid EQ 10115 OR int_agent.userid EQ 10115 OR int_agent.userid EQ 8318)>
		<div class="section"><br><br>
		<table width="670" cellpadding=2 cellspacing=0 align="center">
			<tr>
				<td>Currently, you are unable to request a State Guarantee online.  You are still able to request them, you just need to contact your
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
		<tr>
			<td>
				<div align="justify"><cfinclude template="state_guarantee_text.cfm"></div>
				<table border=0 cellpadding=2 cellspacing=0>
					<tr><td>46 State Guarantee</td><td>=</td><td>$500</td></tr>
					<tr><td align="right">Florida</td><td>=</td><td>$600</td></tr>
					<tr><td align="right">California</td><td>=</td><td>$700</td></tr>
				</table><br>
				<img src="#path#pics/usa-map.gif"><br><br>
				<cfif states_requested.recordcount GT '0' AND states_requested.state1 NEQ '0'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Yes, submit my choices as indicated below. 
				<cfif states_requested.recordcount EQ '0' OR states_requested.state1 EQ '0'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"><cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> No, I am not interested in a state guarantee.<br><br>
				<table width="100%" border=0 cellpadding=2 cellspacing=0 align="center">
					<tr>
					<td width="90">1st Choice:</td>
					<td width="130" align="left">#states_requested.statename1#<br><img src="#path#pics/line.gif" width="125" height="1" border="0" align="absmiddle"></td>
					<td width="90">&nbsp; 2nd Choice:</td>
					<td width="130" align="left">#states_requested.statename2#<br><img src="#path#pics/line.gif" width="125" height="1" border="0" align="absmiddle"></td>
					<td width="90">&nbsp; 3rd Choice:</td>
					<td width="130" align="left">#states_requested.statename3#<br><img src="#path#pics/line.gif" width="125" height="1" border="0" align="absmiddle"></td>
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