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
	<title>Page [20] - Region Preference</title>
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">
<!----Check if States are Selected, if one is selected, don't show regional options---->
<Cfquery name="checkStates" datasource="MySQL">
	SELECT 
    	state1, 
        sta1.statename as statename1, 
        state2, 
        sta2.statename as statename2, 
        state3, 
        sta3.statename as statename3
	FROM 
    	smg_student_app_state_requested 
	LEFT JOIN 
    	smg_states sta1 ON sta1.id = state1
	LEFT JOIN 
    	smg_states sta2 ON sta2.id = state2
	LEFT JOIN 
    	smg_states sta3 ON sta3.id = state3
	WHERE 
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.studentid#">
</cfquery> 

<cfset doc = 'page20'>

<cfquery name="check_guarantee" datasource="MySQL">
	SELECT app_region_guarantee
	FROM smg_students
	WHERE studentid = '#get_student_info.studentid#'
</cfquery>

<!---- International Rep - EF ACCOUNTS ---->
<cfquery name="int_agent" datasource="MySQL">
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
			<td class="tablecenter"><h2>Page [20] - Regional Choice </h2></td>
			<cfif IsDefined('url.curdoc')>
			<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page20print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
			</cfif>
			<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
		</tr>
	</table>
	<!--- If student has selected a state guarantee, don't show regional guarantee --->
<!--- NOT ESI / PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->

<Cfif (checkStates.recordcount neq 0) AND (checkStates.state1 neq 0 AND checkStates.state2 nEQ 0 AND checkStates.state3 nEQ 0)  > 
	<cfif (checkStates.state1 neq 0 AND checkStates.state2 nEQ 0 AND checkStates.state3 nEQ 0)>
	<div class="section"><br><br>
	<table width="670" cellpadding=2 cellspacing=0 align="center">
		<tr>
			<td>A State Request was submitted, Regional Request does not apply to this application. </td>
		</tr>
	</table><br><br>
	</div>
	<!--- FOOTER OF TABLE --->
	<cfinclude template="../footer_table.cfm">
		
    </cfif>
<Cfelse>
	<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 --->
	<cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND (int_agent.master_accountid EQ 10115 OR int_agent.userid EQ 10115 OR int_agent.userid EQ 8318)>
		<div class="section"><br><br>
		<table width="670" cellpadding=2 cellspacing=0 align="center">
			<tr>
				<td>Currently, you are unable to request a Regional Choice online.  You are still able to request them, you just need to contact your
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
		<cfinclude template="../check_uploaded_file.cfm">
	</cfif>
	
	<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
		<tr>
			<td width="110"><em>Student's Name</em></td>
			<td width="560">#get_student_info.firstname# #get_student_info.familylastname#<br><img src="#path#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
		</tr>
	</table><br>
	
	<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
		<tr><td><p>You can choose your region if you so desire. Both the Semester and Academic Year students can choose a region.<br>
				You must request a regional choice by printing and signing this page. Your application must be received in the U.S. Office prior to April 15th.</p>
		    <p>The student exchange company reserves the right in August, if a placement is not forthcoming, to place a student out of their Regional Choice area. No extra fee is then collected. </p></td>
		</tr>
	</table><br>
	
	<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
		<tr><td><div align="justify">
        <!----
			If you would like to specify a region, select option A, 
			confirm your request of region, print this page, sign it and upload it back into the system with original signatures.<br>
			If you do not want a regional choice, select option B. 
			---->
			If option B is selected you do not need to print this page, sign it and upload it back into the system.</div>
		    <br><br></td></tr>	
		<tr>
			<td>A. <cfif check_guarantee.app_region_guarantee NEQ '0'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>
					I would like to request a specific regional choice.<br></td>
		</tr>	
		<tr>
			<td>B. <cfif check_guarantee.app_region_guarantee EQ '0'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>
					I do not wish a regional choice.<br>
					<br></td>
		</tr>	
		<tr>
		  <td>			
				<h3>Note: There will be additional charges if you make a regional choice, please contact your representative for details.</h3>
				
                    
                    <table width=670 border=0 cellpadding=0 cellspacing=0 align="center">
                        <tr><td colspan="3"><h2>Select your region below</h2><br><br></td></tr>
                        <tr>
                            <td valign="top"><input type="radio" name="region_choice" value="6" onChange="DataChanged();" <cfif check_guarantee.app_region_guarantee EQ '6'>checked</cfif>>West<br>
                            <img src="https://ise.exitsapplication.com/nsmg/student_app/pics/west.jpg" width="25%"></td>
                            <td valign="top"><input type="radio" name="region_choice" value="7" onChange="DataChanged();" <cfif check_guarantee.app_region_guarantee EQ '7'>checked</cfif>>Central<br><img src="https://ise.exitsapplication.com/nsmg/student_app/pics/central.jpg" width="50%"></td>
                        </tr>
                        <tr>
                            <td valign="top"><input type="radio" name="region_choice" value="8" onChange="DataChanged();" <cfif check_guarantee.app_region_guarantee EQ '8'>checked</cfif>>South<br><img src="https://ise.exitsapplication.com/nsmg/student_app/pics/south.jpg" width="50%"></td>
                            <td valign="top"><input type="radio" name="region_choice" value="9" onChange="DataChanged();" <cfif check_guarantee.app_region_guarantee EQ '9'>checked</cfif>>East<br><img src="https://ise.exitsapplication.com/nsmg/student_app/pics/east.jpg" width="50%"></td>
                           
                        </tr>
                    </table>	
                 			
                    </div>
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
 </cfif>
</cfoutput>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
