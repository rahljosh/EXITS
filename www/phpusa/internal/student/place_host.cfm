<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param FORM variables --->
    <cfparam name="FORM.hostID" default="0">
    <cfparam name="FORM.isWelcomeFamily" default="0">

	<!--- get student info by uniqueID --->
    <cfinclude template="../querys/get_student_unqid.cfm">
    
    <cfquery name="qBoardingSchool" datasource="mysql">
        SELECT 
            schoolid, 
            schoolname, 
            boarding_school
        FROM 
            php_schools
        WHERE 
            schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.schoolid#">
    </cfquery>
    
    <cfquery name="qGetAvailableHosts" datasource="mysql">
        SELECT 
            hostID, 
            familylastname, 
            fatherfirstname, 
            motherfirstname, 
            fatherlastname, 
            motherlastname
        FROM 
            smg_hosts
        WHERE 
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        ORDER BY
            familylastname
    </cfquery>
    
    <cfquery name="qHostInfo" datasource="mysql">
        SELECT  
            hostID, 
            familylastname, 
            fatherfirstname, 
            fatherlastname, 
            motherfirstname, 
            motherlastname, 
            address, 
            address2, 
            city, 
            state, 
            zip, 
            phone, 
            email 
        FROM 
            smg_hosts 
        WHERE 
            hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.hostID#">
    </cfquery>	

	<!--- HOST HISTORY --->
    <cfquery name="placement_history" datasource="mysql">
        SELECT 
        	history.hostID, 
            history.reason, 
            history.studentid, 
            history.dateofchange,	
            history.arearepid, 
            history.placerepid,
            history.changedby,
            h.familylastname, 
            h.hostID,
            u.firstname, 
            u.lastname, 
            u.userid
        FROM 
        	smg_hosthistory history
        INNER JOIN 
        	smg_hosts h ON h.hostID = history.hostID
        LEFT JOIN 
        	smg_users u ON u.userid = history.changedby
        WHERE 
        	history.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentid#">
        AND 
        	history.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
        AND 
        	history.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
        	history.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
        	h.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="6">
        ORDER BY 
        	history.dateofchange desc
    </cfquery>
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Placement Management - Host Family</title>
</head>

<body>

<style type="text/css">
<!--
.history {color: #7B848A}
-->
</style>

<!----
<cftry>
---->

<cfif NOT IsDefined('URL.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfoutput>

<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 bgcolor="##e9ecf1"> 
<tr><td>

<!--- include template page header --->
<cfinclude template="place_menu_header.cfm">

<!--- CHECK CANCELED STUDENT --->
<cfif get_student_unqid.canceldate NEQ ''> 
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center"><b>High School</b></td></tr>
		<tr><td><h3>This student was canceled on #DateFormat(get_student_unqid.canceldate, 'mmm dd, yyyy')#. &nbsp; You can not place them with a school.</h3></td></tr>
		<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp; <input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></font></td></tr>
	</table><br><br>
	<cfabort>
</cfif>

<cfif get_student_unqid.schoolid EQ 0>
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center"><b>Host Family</b></td></tr>
		<tr><td>#get_student_unqid.firstname# #get_student_unqid.familylastname# is not assigned to a school. Please select a school first in order to continue.</td></tr>
		<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp; <input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></font></td></tr>
	</table><br><br>
	<cfabort>
<cfelseif qBoardingSchool.boarding_school EQ 1>
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center"><b>Host Family</b></td></tr>
		<tr><td>#get_student_unqid.firstname# #get_student_unqid.familylastname# is assigned to a boarding school. No Host Family needed.</td></tr>
		<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp; <input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></font></td></tr>
	</table><br><br>
	<cfabort>
<cfelseif qBoardingSchool.boarding_school EQ 3>	
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center"><b>Host Family</b></td></tr>
		<tr><td>#qBoardingSchool.schoolname# (###qBoardingSchool.schoolid#) has not been verified if it is or is not a boarding schoool. Please check school record in order to continue.</td></tr>
		<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp; <input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></font></td></tr>
	</table><br><br>
	<cfabort>
</cfif>

<!---  SELECT NEW HOST --->
<cfif NOT IsDefined('URL.change')>
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center" colspan="3"><b>Host Family</b></td></tr>
		<cfif get_student_unqid.hostID EQ 0> <!--- PLACE A HOST --->
			<cfform action="qr_place_host.cfm?unqid=#get_student_unqid.uniqueid#" method="post">
			<cfinput type="hidden" name="assignedid" value="#get_student_unqid.assignedid#">
			<tr><td>The following hosts are available for this student:</td></tr>
			<tr>
            	<td>				
                    <cfselect name="hostID">
                        <option value="0"></option>
                        <cfloop query="qGetAvailableHosts">
                        <option value="#hostID#">			
                            <cfif fatherfirstname NEQ''>
                                #fatherfirstname# 
                                <cfif fatherlastname NEQ familylastname>#fatherlastname#</cfif>
                            </cfif>
                            <cfif fatherfirstname NEQ '' AND motherfirstname NEQ ''> and </cfif>
                            <cfif motherfirstname NEQ ''>
                                #motherfirstname#
                                <cfif motherlastname NEQ familylastname>#motherlastname#</cfif> 
                            </cfif>
                            <cfif motherlastname EQ familylastname OR fatherlastname EQ familylastname>#familylastname#</cfif>
                            &nbsp; (###hostID#)
                        </option>
                        </cfloop>
                    </cfselect>
				</td>
            </tr>
			<tr>
            	<td>
                	Is this a Welcome/Temp family?
                </td>
            </tr>
            <tr>
                <td>
                	<input type="radio" name="isWelcomeFamily" id="welcomeFamilyNo" value="0" <cfif NOT VAL(FORM.isWelcomeFamily)>checked</cfif> > <label for="welcomeFamilyNo">No</label>
                    <input type="radio" name="isWelcomeFamily" id="welcomeFamilyYes" value="1" <cfif VAL(FORM.isWelcomeFamily)>checked</cfif> > <label for="welcomeFamilyYes">Yes</label>
                </td>
            </tr>            
            <Tr>
				<td align="center" width="50%"><input name="submit" type="image" src="../pics/update.gif" align="right" border=0></td>
				<td align="center" width="50%"><input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></td>
			</tr>
			</cfform>
		<!--- STUDENT IS ASSIGNED TO A HOST --->
		<cfelse> 
			<cfif qHostInfo.recordcount is '0'>	
				<tr><td colspan="2">Host (#get_student_unqid.hostID#) was not found in the system.</td></tr>
			<cfelse>
				<tr><td colspan="2">			
					#qHostInfo.fatherfirstname# <cfif #qHostInfo.motherlastname# NEQ #qHostInfo.fatherlastname#>#qHostInfo.fatherlastname#</cfif>
						and #qHostInfo.motherfirstname#<cfif #qHostInfo.motherlastname# EQ #qHostInfo.fatherlastname#> #qHostInfo.familylastname#<cfelse> #qHostInfo.motherlastname#</cfif>&nbsp;(#qHostInfo.hostID#) &nbsp;  
						[ <A href="../index.cfm?curdoc=host_fam_info&hostID=#qHostInfo.hostID#" target="_blank">edit</A> ]<br>
					#qHostInfo.address#<br>
					<cfif qHostInfo.address2 NEQ ''>#qHostInfo.address2#<br></cfif>
					#qHostInfo.city# #qHostInfo.state#, #qHostInfo.zip#<br>
					#qHostInfo.phone#<br>
					<a href="mailto:#qHostInfo.email#">#qHostInfo.email#</a><br>
					<font size=-1>#get_student_unqid.firstname# was placed on #DateFormat(get_student_unqid.dateplaced, 'ddd. mmm. d, yyyy')# at #TimeFormat(get_student_unqid.dateplaced, 'h:mm:ss tt')#</font>
				</td></tr>
			</cfif>
			
			<cfform action="place_host.cfm?unqid=#get_student_unqid.uniqueid#&change=yes"  method="post">
				<cfinput type="hidden" name="assignedid" value="#get_student_unqid.assignedid#">
				<Tr>
					<td align="center" width="50%"><input name="submit" type="image" src="../pics/update.gif" align="right" border=0></td>
					<td align="center" width="50%"><input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></td>
				</tr>
			</cfform>
		</cfif>
	</table><br><br>

<!--- UPDATE/CHANGE CURRENT HOST --->
<cfelse>
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center" colspan="2"><b>Change Host Family</b></td></tr>
			<cfform action="qr_place_host.cfm?unqid=#get_student_unqid.uniqueid#&change=yes" method="post">
			<cfinput type="hidden" name="assignedid" value="#get_student_unqid.assignedid#">
			<tr><td>The following hosts are available for this student:</td></tr>
			<tr><td>				
					<cfselect name="hostID">
						<option value="0">Select a HF</option>
						<cfloop query="qGetAvailableHosts">
						<option value="#hostID#">			
							<cfif fatherfirstname NEQ''>
								#fatherfirstname# 
								<cfif fatherlastname NEQ familylastname>#fatherlastname#</cfif>
							</cfif>
							<cfif fatherfirstname NEQ '' AND motherfirstname NEQ ''> and </cfif>
							<cfif motherfirstname NEQ ''>
								#motherfirstname#
								<cfif motherlastname NEQ familylastname>#motherlastname#</cfif> 
							</cfif>
							<cfif motherlastname EQ familylastname OR fatherlastname EQ familylastname>#familylastname#</cfif>
							&nbsp; (###hostID#)
						</option>
						</cfloop>
					</cfselect>
			</td></tr>
			<tr>
            	<td>
                	Is this a Welcome/Temp family?
                </td>
            </tr>
            <tr>
                <td>
                	<input type="radio" name="isWelcomeFamily" id="welcomeFamilyNo" value="0" <cfif NOT VAL(FORM.isWelcomeFamily)>checked</cfif> > <label for="welcomeFamilyNo">No</label>
                    <input type="radio" name="isWelcomeFamily" id="welcomeFamilyYes" value="1" <cfif VAL(FORM.isWelcomeFamily)>checked</cfif> > <label for="welcomeFamilyYes">Yes</label>
                </td>
            </tr>            
			<tr><td colspan="2">Please indicate why you are changing the host family:<br><textarea cols=50 rows=4 name="reason"></textarea></td></tr>
			<Tr>
				<td align="center" width="50%"><input name="submit" type="image" src="../pics/update.gif" align="right" border=0></td>
				<td align="center" width="50%"><input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></td>
			</tr>
			</cfform>
	</table><br><br>
</cfif>

<Cfif placement_history.recordcount is not 0> 
<Table width=580 cellpadding=3 cellspacing=0 align="center" class="history">
	<tr><td colspan="3" align="center"><font color="a8a8a8">H O S T &nbsp; H I S T O R Y </font><br><br></td></tr>
	<cfoutput query="placement_history">
		<tr bgcolor="D5DCE5"><td colspan="3">Date : &nbsp; #DateFormat(dateofchange, 'mm/dd/yyyy')#</td></tr>
			<tr><td width="175"><u>Host Fam.</u></td>
			<td width="230"><u>Reason</u></td>
			<td width="175"><u>Changed By</u></td></tr>
		<tr bgcolor="#iif(placement_history.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td>#familylastname# (#hostID#)</td>
			<td>#reason#</td>
			<td>#firstname# #lastname# (#userid#)</td></tr>
	</cfoutput>
</table><br><br>
</cfif>

</td></tr>
</table>

</cfoutput>
<!----
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
---->
</body>
</html>