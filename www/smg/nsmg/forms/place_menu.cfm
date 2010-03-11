<link rel="stylesheet" href="../smg.css" type="text/css">
<body onLoad="opener.location.reload()"> 
<Title>Placement Management Menu</title>

<body>
<html>

<!----If link is from approval list, sets studentid to client.studentid---->
<cfif isdefined('url.studentid')>
	<cfset client.studentid = #url.studentid#>
</cfif>

<cfif not isDefined('url.text')>
<cfset url.text = 'no'>
</cfif>

<!--- include template page header --->
<cfinclude template="placement_status_header.cfm">

<cfquery name="get_student_info" datasource="MySQL">
	SELECT DISTINCT stu.studentid, stu.firstname, stu.familylastname, stu.middlename, stu.hostid, stu.arearepid, stu.placerepid, stu.schoolid, 
		stu.uniqueid, stu.dateplaced, stu.host_fam_approved, stu.date_host_fam_approved, stu.address, stu.address2, stu.city, stu.country, stu.programid,
		stu.zip,  stu.fax, stu.email, stu.phone, stu.welcome_family,
		h.familylastname as hostlastname, h.hostid as hostfamid,
		area.firstname as areafirstname, area.lastname as arealastname, area.userid as areaid,
		place.firstname as placefirstname, place.lastname as placelastname, place.userid as placeid,
		countryname 
	FROM smg_students stu
	LEFT JOIN smg_hosts h ON stu.hostid = h.hostid
	LEFT JOIN smg_users area ON stu.arearepid = area.userid
	LEFT JOIN smg_users place ON stu.placerepid = place.userid
	LEFT JOIN smg_countrylist country ON stu.countryresident = country.countryid
	WHERE stu.studentid = #client.studentid#
</cfquery>
<cfquery name="season" datasource="#application.dsn#">
select seasonid
from smg_programs
where programid = #get_student_info.programid#
</cfquery>
<cfquery name="school_info" datasource="#application.dsn#">
select sc.schoolname, sc.schoolid, sd.year_begins, sd.semester_begins, sd.semester_ends, sd.year_ends
from smg_schools sc
left join smg_school_dates sd on sd.schoolid = sc.schoolid
where sc.schoolid = #get_student_info.schoolid#
and sd.seasonid = #season.seasonid#
</cfquery>
<cfif client.userid eq 1>
<cfdump var="#get_student_info#">
</cfif>
<!--- PLACEMENT HISTORY --->
<cfquery name="placement_history" datasource="MySQL">
	SELECT hist.hostid, hist.reason, hist.studentid, hist.dateofchange, hist.arearepid, hist.placerepid, hist.schoolid, hist.changedby, hist.original_place,
		   h.familylastname,
		   sc.schoolname,
		   area.firstname as areafirstname, area.lastname as arealastname,
		   place.firstname as placefirstname, place.lastname as placelastname,
		   changedby.firstname as changedbyfirstname, changedby.lastname as changedbylastname
	FROM smg_hosthistory hist
	LEFT JOIN smg_hosts h ON hist.hostid = h.hostid
	LEFT JOIN smg_schools sc ON hist.schoolid = sc.schoolid
	LEFT JOIN smg_users area ON hist.arearepid = area.userid
	LEFT JOIN smg_users place ON hist.placerepid = place.userid
	LEFT JOIN smg_users changedby ON hist.changedby = changedby.userid
	WHERE hist.studentid = #client.studentid#
	ORDER BY hist.dateofchange desc, hist.historyid DESC
</cfquery>
	
<style type="text/css">
<!--
.placeinfo {color: #3434B6}
-->
<!--
.history {color: #7B848A}
-->
<!--
/* region table */
table.dash { font-size: 12px; border: 1px solid #202020; }
tr.dash {  font-size: 12px; border-bottom: dashed #201D3E; }
td.dash {  font-size: 12px; border-bottom: 1px dashed #201D3E;}
-->
</style>
<!----Header Table---->
<table width=580 cellpadding=0 cellspacing=0 border=0 height=24 align="Center">
						<tr valign=middle height=24>
							<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="../pics/header_background.gif"></td>
							<td background="../pics/header_background.gif"><h2>Placement Information</td><td background="../pics/header_background.gif" width=16></td>
							<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
<table class="section" align="Center" width=580 cellpadding=0 cellspacing=0>
	<tr>
		<td>
		
				
				<table width="100%" align="center" bgcolor="#ffffe6">
				<tr><td align="center"><h3>Welcome to the Placement Management Screen</h3></td></tr>
				<tr><td align="center">
					<Cfif url.text is 'no'>
							<a href="place_menu.cfm?text=yes"><img src="../pics/help_show.gif" align="Center" border=0></a>
					<cfelseif url.text is 'yes'>
							<a href="place_menu.cfm?text=no"><img src="../pics/help_hide.gif" align="Center" border=0></a></Cfif>
				</td></tr>
				<cfif url.text is 'no'><cfelse>
				<tr><td align="center"><h3>Steps 1-4 are mandatory and step 5 is optional when placing a student.</h3></td></tr>
				<tr><td align="center"><h3>Gray buttons indicate the step has never been completed.</h3></td></tr>
				<tr><td align="center"><h3>Green buttons indicate the step has been completed.</h3></td></tr>
				<tr><td align="center"><h3>After Original Placement is completed, green buttons can be used to update placement information.</h3></td></tr>
				<tr><td align="center"><h3>When placement information is updated, the Placement Log will be updated.</h3></td></tr>
				<tr><td align="center"><h3>Current Placement Information is always listed as the top description.</h3></td></tr>
				<tr><td align="center"><h3>The Placement Log then lists all past changes in placement information</h3></td></tr>
				<tr><td align="center"><h3>The Placement Log starts from the bottom and lists the most recent updates on the top of the log.</h3></td></tr>
				</cfif>
				</table><br>
				
				<!---get RejectedBy--->
				<cfoutput query="get_student_info">
				
				<table width="100%" class="placeinfo" align="center">
				<cfif hostid NEQ '0' and schoolid NEQ '0' and placerepid NEQ '0' and arearepid NEQ '0'> <!--- if placement status --->
					<!---99---->
					<cfif host_fam_approved is '99'>
						<tr><td align="center" colspan="3" font="red"> Placement has been <b><font color="CC3300">R E J E C T E D</font></b> on #date_host_fam_approved# see the history below<br></td></tr>
						<tr><td align="center" colspan="3"><form method = "post" action="../querys/update_host_fam_resubmit.cfm"><input type="image" value="resubmit" src="../pics/resubmit.gif"></form></td></tr>	
					</cfif>
					<!---/99---->
					<!----Placement Approval Information---->
					<cfif host_fam_Approved LT '8' and host_fam_approved GTE '5'> <!--- 5 TO 7 --->
						<cfif client.usertype LT host_fam_Approved>
						<tr><td align="center" colspan="3"><a href="javascript:openLetter();"><img src="../pics/previewpis.gif" border="0"></a><br></td></tr>
						<tr><td align="center" colspan="3"><font color="FF3300">To approve this placement, please review the placement letter clicking on the link above.</font><br><br></td></tr>
						<cfelse>
						<tr><td align="center" colspan="3"><a href="../reports/placement_letter.cfm?studentid=#get_student_info.studentid#" target="_blank"><img src="../pics/previewpis.gif" border="0"></a><br><br></td></tr>
						</cfif>
						<tr><td align="center" colspan="3">Placement is being approved.  Last Approval: #DateFormat(get_student_info.date_host_fam_approved, 'mm/dd/yyyy')# by the 
							<Cfif host_fam_approved is '5'>Regional Manager
							<cfelseif host_fam_approved is '6'>Regional Advisor
							<cfelseif host_fam_approved is '7'>Area Representative
							<cfelseif host_fam_approved LT '5'>HQ
							</Cfif>.
							</td>
						</tr>
						<tr><td align="center" colspan="3"><br>
								<!--- APPROVAL BUTTON ---->
								<cfif client.usertype LT host_fam_Approved>
								<a href="../querys/update_host_fam_approved.cfm"><img src="../pics/approve.gif" border="0" id="hideapp"></img></a>
								<!--- REJECT BUTTON ----> &nbsp; &nbsp;
								<a href="place_reject_host.cfm?studentid=#get_student_info.studentid#"><img src="../pics/reject.gif" border="0" id="hidedis"></img></a>
								<cfelse><img src="../pics/no_approve.jpg" alt="Reject" border=0></cfif>
							</td>
						</tr>
						<script language="JavaScript" type="text/javascript">
						var ns4 = (navigator.appName == 'Netscape' && parseInt(navigator.appVersion) == 4);
						var ns6 = (document.getElementById)? true:false;
						var ie4 = (document.all)? true:false;
						function hideIt(id){
							if (ns6){
								el = document.getElementById(id);
								el.style.display = 'none';
							} else if (ie4){
								el = document.all[id];
								el.display = 'none';
							} else if (ns4){
								el = document.layers[id];
								el.style.display = 'none';
							}
						}
						function showIt(id){
							if (ns6){
								el = document.getElementById(id);
								el.style.display = '';
							} else if (ie4){
								el = document.all[id];
								el.display = '';
							} else if (ns4){
								el = document.layers[id];
								el.style.display = '';
							}
						}
						var newwindow;
						var url = "../reports/placement_letter_preview.cfm";
						function openLetter(){
							newwindow = window.open(url,"Letter","width=800,height=600,status=false,scrollbars=yes,resizable=yes");
						}
						hideIt('hideapp');
						hideIt('hidedis');
						</script>
					<cfelseif host_fam_approved LTE '4'>
						<tr><td align="center" colspan="3"><a href="../reports/placement_letter.cfm?studentid=#get_student_info.studentid#" target="_blank"><img src="../pics/previewpis.gif" border="0"></a><br><br></td></tr>
						<tr><td align="center" colspan="3">Placement approved on #DateFormat(get_student_info.date_host_fam_approved, 'mm/dd/yyyy')# by the HQ.</td></tr>	
					</cfif>				
				<cfelse> <!--- if placement status --->
				<tr><td align="center" colspan="3">#firstname# #familylastname# is &nbsp; <b>U N P L A C E D</b><br><br></td></tr>
				</cfif> <!--- if placement status --->
				<tr><td align="center" colspan="3"><br><b><u>CURRENT PLACEMENT INFORMATION</u></b><br><br></td></tr>
				</table>
				
				<div class="row1"><p>
				<table border=0 width="500" align="center" bgcolor="##ffffe6">
				<tr>
					<td rowspan="2" valign="top" width=5><span class="get_attention"><b>></b></span></td>
					<td class="dash" width=50%><b>Student</b> &nbsp; [ <A href="../student_profile.cfm?uniqueid=#get_student_info.uniqueid#" target="_blank">view student</A> ]</td>
					<td rowspan="2" valign="top" width='10'></td>
					<td rowspan="4" valign="top" width=5><span class="get_attention"><b>></b></span></td>
					<td class="dash"><b>Host Family</b> &nbsp; <cfif hostid NEQ '0' and client.usertype LTE 4>[ <A href="../index.cfm?curdoc=host_fam_info&hostid=#get_student_info.hostid#" target="_blank">view host</A> ] </cfif></td>
				</tr>
				<tr>
					<td valign="top">
						#get_Student_info.firstname# #get_Student_info.middlename# #get_Student_info.familylastname#<br>
						#get_student_info.city# &nbsp; #get_student_info.countryname#, &nbsp; #get_student_info.zip#<br>
						Phone: #get_student_info.phone#<br>
						<cfif get_student_info.fax is ''><cfelse>Fax: #get_student_info.fax#<br></cfif>
						<cfif get_student_info.email is ''><cfelse>Email: #get_student_info.email#<br></cfif>
					</td>		
					<td rowspan="3" valign="top">
						<cfif hostid EQ 0>
							<font color="CC3300">Host Family has not been assigned yet.</font>				
						<cfelseif hostfamid EQ ''>
							<font color="CC3300">Host Family (#hostid#) was not found in the system.</font>						
						<cfelse>
							<cfif get_student_info.welcome_family EQ 1>*** This is a Welcome Family ***<br></cfif>
							#hostlastname# (#hostid#)
						</cfif>	
					</td> 
				</tr>
				</table>
				<table border=0 width="500" class="placeinfo" align="center" class="section">
				<tr>
					<td rowspan="2" valign="top" width='5'><span class="get_attention"><b>></b></span></td>
					<td class="dash" width=50%><b>School</b> <cfif schoolid NEQ '0' and client.usertype LTE 4>[ <A href="../index.cfm?curdoc=school_info&schoolid=#get_student_info.schoolid#" target="_blank">view school</A> ]</cfif></td>
					<td rowspan="2" valign="top" width='10'></td>
					<td rowspan="4" valign="top" width='5'><span class="get_attention"><b>></b></span></td>
					<td class="dash"><b>Placement and Supervision</b></td>
				</tr>
				<tr>
					<td valign="top">
					<cfif schoolid is 0><font color="CC3300">School has not been assigned yet.</font><cfelse>
					<cfif schoolid is ''><font color="CC3300">School (#schoolid#) was not found in the system.</font><cfelse>#school_info.schoolname# (#school_info..schoolid#)<br><font size=-2>year beg: #DateFormat(school_info..year_begins, 'mm/dd/yy')# sem end: #DateFormat(school_info..semester_ends, 'mm/dd/yy')# <br> sem start:#DateFormat(school_info..semester_begins, 'mm/dd/yy')#  year end: #DateFormat(school_info..year_ends, 'mm/dd/yy')#</font></cfif></cfif>
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
				</table>
				</cfoutput></div><br>
				
				<table width="100%" align="center">
				<tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
				</table>
		</td>
	</tr>
</table>

<!----footer of table---->
						<table width=580 cellpadding=0 cellspacing=0 border=0 align="center">
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
										<td width=100% background="../pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
									</tr>
								</table>		




<br>

<!--- PLACEMENT HISTORY --->
<cfquery name="history_dates" datasource="MySQL">
	SELECT dateofchange
	FROM smg_hosthistory
	WHERE smg_hosthistory.studentid = #client.studentid#
	GROUP BY dateofchange
	ORDER BY smg_hosthistory.dateofchange desc
</cfquery>

<Cfif history_dates.recordcount NEQ 0>
  <Table width=580 cellpadding=3 cellspacing=0 align="center" class="history">
	<tr><td colspan="6" align="center" bgcolor=#e2efc7>P L A C E M E N T &nbsp; L O G <br><br></td></tr>

	<cfoutput query="placement_history">								
		<cfif original_place is 'yes'>
		<tr bgcolor="D5DCE5"><td colspan="2">Date : &nbsp; #DateFormat(dateofchange, 'mm/dd/yyyy')# </td>
		<td colspan="4" align="left">O R I G I N A L &nbsp; &nbsp; P L A C E M E N T </td></tr>
		<tr><td width="90"><u>Host Fam.</u></td>
		<td width="90"><u>School</u></td>
		<td width="90"><u>Super Rep.</u></td>
		<td width="90"><u>Place Rep.</u></td>
		<td colspan="2" width="220"><u>Added by</u></td></tr>
		<tr bgcolor="#iif(placement_history.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
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
		<tr bgcolor="#iif(placement_history.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td td width="90"><cfif hostid NEQ '0'>#familylastname# (#hostid#)</cfif></td>
			<td td width="90"><cfif schoolid NEQ '0'>#schoolname#  (#schoolid#)</cfif></td>
			<td td width="90"><cfif arearepid NEQ '0'>#areafirstname# #arealastname# (#arearepid#)</cfif></td>
			<td td width="90"><cfif placerepid NEQ '0'>#placefirstname# #placelastname# (#placerepid#)</cfif></td>
			<td td width="130">#reason#</td>
			<td td width="90">#changedbyfirstname# #changedbylastname# (#changedby#)</td>
		</tr>
		</cfif>
	</cfoutput>
	</table>
</cfif><br>
</body>
</html>