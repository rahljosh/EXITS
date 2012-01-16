<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- Kill extra output --->
<cfsilent>

	<!--- Get Student Info by UniqueID --->
    <cfinclude template="../querys/get_student_unqid.cfm">
    
    <cfquery name="boarding_school" datasource="mysql">
        SELECT schoolid, schoolname, boarding_school
        FROM php_schools
        WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.schoolid#">
    </cfquery>
    
    <cfif NOT isDefined('url.text')>
        <cfset url.text = 'no'>
    </cfif>
    
    <cfquery name="qGetStudentInfo" datasource="mysql">
        SELECT DISTINCT stu.studentid, stu.firstname, stu.familylastname, stu.middlename, stu.address, stu.address2, stu.city, stu.country, stu.zip,
               stu.fax, stu.email, stu.phone, 
               php.hostid, php.schoolid, php.arearepid, php.placerepid, php.dateplaced, php.isWelcomeFamily,
               h.familylastname as hostlastname, h.hostid as hostfamid,
               sc.schoolname, sc.schoolid as highschoolid,
               area.firstname as areafirstname, area.lastname as arealastname, area.userid as areaid,
               place.firstname as placefirstname, place.lastname as placelastname, place.userid as placeid,
               countryname
        FROM 
        	smg_students stu
        INNER JOIN
        	php_students_in_program php ON php.studentid = stu.studentid
        LEFT JOIN 
        	smg_hosts h ON php.hostid = h.hostid
        LEFT JOIN 
        	php_schools sc ON php.schoolid = sc.schoolid
        LEFT JOIN 
        	smg_users area ON php.arearepid = area.userid
        LEFT JOIN 
        	smg_users place ON php.placerepid = place.userid
        LEFT JOIN 
        	smg_countrylist country ON stu.countryresident = country.countryid
        WHERE 
        	stu.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentid#">
        AND 
        	php.assignedid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.assignedid#">
        AND 
        	php.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    
    <!--- PLACEMENT HISTORY --->
    <cfquery name="qPlacementHistory" datasource="mysql">
        SELECT hist.hostid, hist.reason, hist.studentid, hist.dateofchange, hist.arearepid, hist.placerepid, hist.schoolid, 
            hist.changedby, hist.original_place,
            h.familylastname,
            sc.schoolname,
            area.firstname as areafirstname, area.lastname as arealastname,
            place.firstname as placefirstname, place.lastname as placelastname,
            changedby.firstname as changedbyfirstname, changedby.lastname as changedbylastname
        FROM 
        	smg_hosthistory hist
        LEFT JOIN 
        	smg_hosts h ON hist.hostid = h.hostid
        LEFT JOIN 
        	php_schools sc ON hist.schoolid = sc.schoolid
        LEFT JOIN 
        	smg_users area ON hist.arearepid = area.userid
        LEFT JOIN 
        	smg_users place ON hist.placerepid = place.userid
        LEFT JOIN 
        	smg_users changedby ON hist.changedby = changedby.userid
        WHERE 
        	hist.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentid#">
        ORDER BY 
        	hist.dateofchange desc, 
            hist.historyid DESC
    </cfquery>
    
    <!--- PLACEMENT HISTORY --->
    <cfquery name="qHistoryDates" datasource="mysql">
        SELECT 
        	dateofchange
        FROM 
        	smg_hosthistory
        WHERE 
        	smg_hosthistory.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentid#">
        GROUP BY 
        	dateofchange
        ORDER BY 
        	smg_hosthistory.dateofchange desc
    </cfquery>

</cfsilent>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../phpusa.css" rel="stylesheet" type="text/css">
<Title>Placement Management Menu</title>
</head>

<body onload="opener.location.reload()"> 

<cftry>

<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 bgcolor="#e9ecf1"> 
<tr><td>



<!--- include template page header --->
<cfinclude template="place_menu_header.cfm">

	
<style type="text/css">
<!--
.placeinfo {color: #3434B6}
-->
<!--
/* region table */
table.dash { font-size: 12px; border: 1px solid #202020; }
tr.dash {  font-size: 12px; border-bottom: dashed #201D3E; }
td.dash {  font-size: 12px; border-bottom: 1px dashed #201D3E;}
-->
</style>

<cfoutput>

<!----Header Table---->
<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
	<tr bgcolor="##C2D1EF"><td align="center"><b>Placement Information</b></td></tr>
	<tr>
		<td>
			<table width="100%" align="center">
				<tr><td align="center"><h3>Welcome to the Placement Management Screen</h3></td></tr>
				<tr><td align="center">
					<Cfif url.text is 'no'>
							<a href="place_menu.cfm?unqid=#get_student_unqid.uniqueid#&text=yes"><img src="../pics/help_show.gif" align="Center" border=0></a>
					<cfelseif url.text is 'yes'>
							<a href="place_menu.cfm?unqid=#get_student_unqid.uniqueid#&text=no"><img src="../pics/help_hide.gif" align="Center" border=0></a></Cfif>
				</td></tr>
			<cfif url.text EQ 'yes'>
				<tr><td align="center"><h3>Steps 1-4 are mandatory and step 5 is optional when placing a student.</td></tr>
				<tr><td align="center">Gray buttons indicate the step has never been completed.</td></tr>
				<tr><td align="center">Green buttons indicate the step has been completed.</td></tr>
				<tr><td align="center">After Original Placement is completed, green buttons can be used to update placement information.</td></tr>
				<tr><td align="center">When placement information is updated, the Placement Log will be updated.</td></tr>
				<tr><td align="center">Current Placement Information is always listed as the top description.</td></tr>
				<tr><td align="center">The Placement Log then lists all past changes in placement information</td></tr>
				<tr><td align="center">The Placement Log starts from the bottom and lists the most recent updates on the top of the log.</td></tr>
			</cfif>
			</table><br>
			
			<cfloop query="qGetStudentInfo">
			<table width="100%" class="placeinfo" align="center">
			<!--- if placement status --->
			<cfif (boarding_school.boarding_school EQ '1' AND placerepid NEQ '0' AND arearepid NEQ '0') OR (hostid NEQ '0' AND schoolid NEQ '0' AND placerepid NEQ '0' AND arearepid NEQ '0')> 
				<tr><td align="center" colspan="3">#firstname# #familylastname# is &nbsp; <b>P L A C E D</b><br><br></td></tr>
			<cfelseif hostid NEQ '0' OR schoolid NEQ '0' OR placerepid NEQ '0' OR arearepid NEQ '0'>
				<tr><td align="center" colspan="3">#firstname# #familylastname# is &nbsp; <b>I N C O M P L E T E</b><br><br></td></tr>
			<cfelse>
				<tr><td align="center" colspan="3">#firstname# #familylastname# is &nbsp; <b>U N P L A C E D</b><br><br></td></tr>
			</cfif>
				<tr><td align="center" colspan="3"><br><b><u>CURRENT PLACEMENT INFORMATION</u></b><br><br></td></tr>
			</table>
			
			<table border=0 width="500" align="center">
				<tr>
					<td rowspan="2" valign="top" width=5><span class="get_attention"><b>></b></span></td>
					<td class="dash" width=50%><b>Student</b> &nbsp; [ <a href='student_profile.cfm?unqid=#get_student_unqid.uniqueid#' target="_blank">view student</A> ]</td>
					<td rowspan="2" valign="top" width='10'></td>
					<td rowspan="4" valign="top" width=5><span class="get_attention"><b>></b></span></td>
					<td class="dash"><b>Host Family</b> &nbsp; <cfif hostid NEQ 0>[ <A href="../index.cfm?curdoc=host_fam_info&hostid=#qGetStudentInfo.hostid#" target="_blank">view host</A> ] </cfif></td>
				</tr>
				<tr>
					<td valign="top">
						#qGetStudentInfo.firstname# #qGetStudentInfo.middlename# #qGetStudentInfo.familylastname#<br>
						#qGetStudentInfo.city# &nbsp; #qGetStudentInfo.countryname#, &nbsp; #qGetStudentInfo.zip#<br>
						Phone: #qGetStudentInfo.phone#<br>
						<cfif qGetStudentInfo.fax is ''><cfelse>Fax: #qGetStudentInfo.fax#<br></cfif>
						<cfif qGetStudentInfo.email is ''><cfelse>Email: #qGetStudentInfo.email#<br></cfif>
					</td>		
					<td rowspan="3" valign="top">
						<cfif boarding_school.boarding_school EQ '1'>
							<font color="CC3300">Student assigned to a boarding school. No HF needed.</font>
						<cfelseif hostid EQ '0'>
							<font color="CC3300">Host Family has not been assigned.</font>					
						<cfelseif hostfamid EQ ''>
							<font color="CC3300">Host Family (#hostid#) was not found in the system.</font>
						<cfelse>
							#hostlastname# (###hostid#)
                            <cfif VAL(qGetStudentInfo.isWelcomeFamily)> <br> This is a welcome/temp family.</cfif>
						</cfif>	
					</td>
				</tr>
			</table>
			<table border=0 width="500" class="placeinfo" align="center">
				<tr>
					<td rowspan="2" valign="top" width='5'><span class="get_attention"><b>></b></span></td>
					<td class="dash" width=50%><b>School</b> <cfif schoolid NEQ '0'>[ <A href="../index.cfm?curdoc=forms/view_school&sc=#qGetStudentInfo.schoolid#" target="_blank">view school</A> ]</cfif></td>
					<td rowspan="2" valign="top" width='10'></td>
					<td rowspan="4" valign="top" width='5'><span class="get_attention"><b>></b></span></td>
					<td class="dash"><b>Placement and Supervision</b></td>
				</tr>
				<tr>
					<td valign="top">
					<cfif schoolid is 0><font color="CC3300">School has not been assigned.</font><cfelse>
					<cfif highschoolid is ''><font color="CC3300">School (#schoolid#) was not found in the system.</font><cfelse>#schoolname# (#schoolid#)<br><font size=-2>year beg: <!--- #DateFormat(begins, 'mm/dd/yy')# ---> sem end:  <br> sem start: year end: </font></cfif></cfif>
					</td>		
					<td rowspan="3" valign="top">
						<table border=0 class="placeinfo" align="center">
							<tr><td align="right">Placing :</td>
								<Td><cfif placerepid is 0><font color="CC3300">Placing Rep has not been assigned yet.</font><cfelse>
								<cfif placeid is ''><font color="CC3300">Placing Rep (#placerepid#) was not found in the system.</font><cfelse>#placefirstname# #placelastname# (#placerepid#)</cfif></cfif></td></tr>
								<tr><td align="right">Supervising :</td>
							<td><cfif arearepid is 0><font color="CC3300">Supervising Rep. has not been assigned yet.</font><cfelse>
								<cfif areaid is ''><font color="CC3300">Supervising Rep (#arearepid#) was not found in the system.</font><cfelse>#areafirstname# #arealastname# (#arearepid#)</cfif></cfif></Td></tr>
						</table>
					</td>
				</tr>
			</table>
			</cfloop><br>
			<table width="100%" align="center">
				<tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
			</table>
		</td>
	</tr>
</table><br>



<Cfif qHistoryDates.recordcount NEQ 0>
<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
	<tr><td colspan="6" align="center" bgcolor="##C2D1EF">P L A C E M E N T &nbsp; L O G</td></tr>
	<cfloop query="qPlacementHistory">								
		<cfif original_place EQ 'yes'>
		<tr bgcolor="D5DCE5"><td colspan="2">Date : &nbsp; #DateFormat(dateofchange, 'mm/dd/yyyy')# </td>
		<td colspan="4" align="left">O R I G I N A L &nbsp; &nbsp; P L A C E M E N T </td></tr>
		<tr><td width="90"><u>Host Fam.</u></td>
		<td width="90"><u>School</u></td>
		<td width="90"><u>Super Rep.</u></td>
		<td width="90"><u>Place Rep.</u></td>
		<td colspan="2" width="220"><u>Added by</u></td></tr>
		<tr bgcolor="#iif(qPlacementHistory.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td td width="90"><cfif hostid NEQ '0'>#familylastname# (#hostid#)</cfif></td>
			<td td width="90"><cfif schoolid NEQ '0'>#schoolname#  (#schoolid#)</cfif></td>
			<td td width="90"><cfif arearepid NEQ '0'>#areafirstname# #arealastname# (#arearepid#)</cfif></td>
			<td td width="90"><cfif placerepid NEQ '0'>#placefirstname# #placelastname# (#placerepid#)</cfif></td>
			<td colspan="2">#changedbyfirstname# #changedbylastname# (#changedby#)</td>
		</tr>
		<cfelse>
		<tr bgcolor="D5DCE5"><td colspan="6">Date : &nbsp; #DateFormat(dateofchange, 'mm/dd/yyyy')#</td></tr>
		<tr><td width="90"><u>Host Fam.</u></td>
		<td width="90"><u>School</u></td>
		<td width="90"><u>Super Rep.</u></td>
		<td width="90"><u>Place Rep.</u></td>
		<td width="130"><u>Reason</u></td>
		<td width="90"><u>Changed By</u></td></tr>	
		<tr bgcolor="#iif(qPlacementHistory.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td td width="90"><cfif hostid NEQ '0'>#familylastname# (#hostid#)</cfif></td>
			<td td width="90"><cfif schoolid NEQ '0'>#schoolname#  (#schoolid#)</cfif></td>
			<td td width="90"><cfif arearepid NEQ '0'>#areafirstname# #arealastname# (#arearepid#)</cfif></td>
			<td td width="90"><cfif placerepid NEQ '0'>#placefirstname# #placelastname# (#placerepid#)</cfif></td>
			<td td width="130">#reason#</td>
			<td td width="90">#changedbyfirstname# #changedbylastname# (#changedby#)</td>
		</tr>
		</cfif>
	</cfloop>
	</table>
</cfif><br>

</cfoutput>
	
</td></tr>
</table>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
</body>
</html>