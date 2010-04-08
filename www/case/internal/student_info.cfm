<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>Student's Information</title>
	
	<cfif isdefined('url.studentid')><cfset client.studentid = '#url.studentid#'> </cfif>
	<cfinclude template="querys/get_student_info.cfm">
		
	<!--// load the Client/Server Gateway API //-->
	<script language="JavaScript1.2" src="./lib/gateway.js"></script> 	<!--// [start] custom JavaScript //-->
	<script language="JavaScript1.2" src="student_info.js"></script>
	
	<script language="JavaScript"> 	<!--// // create the gateway object
	oGateway = new Gateway("RegionRelatedSelect.cfm", false);
	function init(){ // when the page first loads, grab the Regions and populate the select box
		oGateway.onReceive = updateOptions; // clear option boxes
		document.StudentInfo.rguarantee.length = 1;
		loadOptions("rguarantee");
	}
	
	function populate(f, a){
		var oField = document.StudentInfo[f];
		oField.options.length = 0;
		for( var i=0; i < a.length; i++ ) oField.options[oField.options.length] = new Option(a[i][0], a[i][1]);
		/******** Set the value of your rguarantee field below  *******/
	    var Counter = 0;
	    for (i=0; i<document.StudentInfo.rguarantee.length; i++){
		   if (document.StudentInfo.rguarantee.options[i].value == <cfoutput>#get_student_info.regionalguarantee#</cfoutput>){
			 Counter++;
		   }
	    }
	    if (Counter == 1){		
		 document.StudentInfo.rguarantee.value = <cfoutput>#get_student_info.regionalguarantee#</cfoutput>;
		}
	}
	
	function loadOptions(f){
		var d = {}, oForm = document.StudentInfo;
		if( f == "region" ){
			document.StudentInfo.rguarantee.length = 1;
		} 
		var sregion = oForm.region.options[oForm.region.options.selectedIndex].value;
		displayLoadMsg(f);
		oGateway.sendPacket({field: f, region: sregion});
	}

	function updateOptions(){
		if( this.received == null ) return false; 
		populate(this.received[0], this.received[1]);
		return true;
	}
	function displayLoadMsg(f){
		var oField = document.StudentInfo[f];
		oField.options.length = 0;
		oField.options[oField.options.length] = new Option("Loading data...", "");
	}
	//-->
	</script> 	<!--// [ end ] custom JavaScript //-->
</head>
<body onLoad="init();">

<cfparam name="edit" default="no">
<cfif isDefined('form.edit') AND client.usertype LTE '4'> <cfset edit=#form.edit#> </cfif>

<cfset currentdate = #now()#>

<cfinclude template="querys/get_company_short.cfm">

<cfquery name="get_regions" datasource="caseusa">
	SELECT regionid, regionname, companyshort
	FROM smg_regions
	INNER JOIN smg_companies ON company = companyid
	WHERE subofregion = '0'
	<cfif #client.companyid# NEQ '5'>
		AND company = '#client.companyid#'
	</cfif>
	ORDER BY companyshort, regionname
</cfquery>

<!--- student does not exist --->
<cfif get_student_info.recordcount is 0>
	The student ID you are looking for, <cfoutput>#url.studentid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the student record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view the student
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@case-usa.org">Support</a>
	<cfabort>
</cfif>

<!--- Block if users try to change the student id in the address bar --->
<cfif client.usertype GT 4> 
	<cfquery name="check_stu_region" datasource="caseusa">
		SELECT regionid, companyid, userid, usertype	
		FROM user_access_rights
		WHERE regionid = <cfqueryparam value="#get_student_info.regionassigned#" cfsqltype="cf_sql_integer"> 
			AND userid =  <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset client.usertype = #check_stu_region.usertype#>
	
	<!--- student's view only - transfer to profile --->
	<cfif client.usertype EQ '9'>
		<cflocation url="index.cfm?curdoc=student_profile&uniqueid=#get_student_info.uniqueid#" addtoken="no">
	</cfif>
			
	<cfif get_student_info.companyid NEQ client.companyid OR check_stu_region.recordcount EQ 0><br>
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
				<td background="pics/header_background.gif"><h2>Students View - Error </h2></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
			</tr>
		</table>
		<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
			<tr>
				<td align="center">
					<br><div align="justify"><img src="pics/error_exclamation.gif" align="left"><h3>
					<p>You are trying to access a student that is not assigned to this company or to your region.</p>
					<p>If you have access rights to the company the student belongs to, you must change company views, then access the student.</p></h3></div>
				</td>
			</tr>
		<tr><td align="center"><input type="image" value="Back" onClick="history.go(-1)" src="pics/back.gif"></td></tr>
		</table>
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
				<td width=100% background="pics/header_background_footer.gif"></td>
				<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
			</tr>
		</table>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="get_region_assigned" datasource="caseusa">
	SELECT smg_students.regionassigned, smg_regions.regionname, smg_regions.regionfacilitator, smg_regions.regionid, smg_regions.company
	FROM smg_students 
	INNER JOIN smg_regions ON smg_students.regionassigned = smg_regions.regionid
	WHERE studentid = '#client.studentid#'
</cfquery>

<cfquery name="private_schools" datasource="caseusa">
	SELECT *
	FROM smg_private_schools
</cfquery>

<cfquery name="iff_schools" datasource="caseusa">
	SELECT *
	FROM smg_iff
</cfquery>

<cfquery name="aypcamps" datasource="caseusa">
	SELECT *
	FROM smg_aypcamps
</cfquery>

<!---Facilitator--->
<cfif get_region_assigned.recordcount is 0>
	 <cfset get_facilitator.firstname = "Region doesn't have Fac. Assigned.">
	 <cfset get_facilitator.lastname = "">
<cfelse>
	<cfquery name="get_facilitator" datasource="caseusa">
	SELECT smg_users.firstname, smg_users.lastname, smg_users.userid
	FROM smg_users
	WHERE smg_users.userid = #get_region_assigned.regionfacilitator#
	</cfquery>
</cfif>

<!----International Rep---->
<cfquery name="int_Agent" datasource="caseusa">
	SELECT u.businessname, u.firstname, u.lastname, u.userid, u.accepts_sevis_fee, u.insurance_typeid, insu.type
	FROM smg_users u
	LEFT JOIN smg_insurance_type insu ON insu.insutypeid = u.insurance_typeid
	WHERE u.userid = '#get_student_info.intrep#'
</cfquery>

<!----International Rep list ---->
<cfquery name="list_int_reps" datasource="caseusa">
	SELECT businessname, firstname, lastname, userid, accepts_sevis_fee
	FROM smg_users
	WHERE usertype = 8
	order by businessname
</cfquery>

<cfquery name="program" datasource="caseusa">
	SELECT programname, programid, enddate
	FROM smg_programs
	WHERE companyid = #client.companyid# and enddate > #currentdate#
	order by programname
</cfquery>

<!----Get Expired Student Programs---->
<cfquery name="check_for_expired_program" datasource="caseusa">
	SELECT smg_students.studentid, smg_students.programid, smg_programs.programname
	FROM smg_programs 
	INNER JOIN smg_students ON smg_programs.programid = smg_students.programid
	WHERE smg_programs.enddate <= #currentdate# 
		AND studentid = #client.studentid#
</cfquery>

<!-----Check for program hold---->
<cfquery name="check_for_hold_program" datasource="caseusa">
	SELECT smg_students.studentid, smg_students.programid, smg_programs.programname
	FROM smg_programs join smg_students on smg_programs.programid = smg_students.programid
	WHERE smg_programs.hold = 1 and studentid = #client.studentid#
</cfquery>

<cfquery name="get_super_rep" datasource="caseusa">
	SELECT firstname, lastname, userid 
	FROM smg_users 
	WHERE userid = '#get_student_info.arearepid#'
</cfquery>

<cfquery name="get_place_rep" datasource="caseusa">
	SELECT firstname, lastname, userid 
	FROM smg_users 
	WHERE userid = '#get_student_info.placerepid#'
</cfquery>

<!--- entered by --->
<cfquery name="entered_by" datasource="caseusa">
	SELECT firstname, lastname, userid 
	FROM smg_users 
	WHERE userid = '#get_student_info.entered_by#'
</cfquery>

<cfquery name="states" datasource="caseusa">
	SELECT id, statename
	FROM smg_states
	WHERE id != 2 AND id != 11
	ORDER BY id
</cfquery>

<cfquery name="user_compliance" datasource="caseusa">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="sevis_status" datasource="caseusa">
	SELECT batchid, received, datecreated
	FROM smg_sevis
	INNER JOIN smg_students s ON s.sevis_activated = smg_sevis.batchid
	WHERE s.studentid = '#get_student_info.studentid#'
		AND received = 'yes'
</cfquery>

<cfquery name="get_sevis_dates" datasource="caseusa">
	SELECT start_date, end_date
	FROM smg_sevis_history
	WHERE studentid = '#get_student_info.studentid#'
	ORDER BY historyid DESC 
</cfquery>

<!----Header Table---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Student Information</td><td background="pics/header_background.gif" align="right"></td>
		<td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput query="get_Student_info">

<form name="StudentInfo" method="post" action="querys/update_student_info.cfm" onSubmit="return CheckGuarantee(#get_student_info.regionassigned#, #get_student_info.programid#);">

<input type="hidden" name="studentid" value="#client.studentid#">

<div class="section"><br>

<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td valign="top" width="590">
			<cfif hostid is 0 and canceldate is ''>
			<table background="pics/unplaced.jpg" cellpadding="2" width="100%"> 
			<cfelseif canceldate is not ''>
			<table background="pics/canceled.jpg" cellpadding="2" width="100%"> 
			<cfelse>
			<table width=100% align="Center" cellpadding="2">				
			</cfif>
				<tr>
					<td width="135" valign="top">
						<table width="100%" cellpadding="2">
							<tr><td width="135">
								<cfset nsmg_directory = '/var/www/html/case/internal/uploadedfiles/web-students'>
								<cfdirectory directory="#nsmg_directory#" name="file" filter="#client.studentid#.*">
								<cfif file.recordcount>
									<img src="uploadedfiles/web-students/#file.name#" width="135"><br>
									<cfif client.usertype lte 4><A href="qr_delete_picture.cfm?student=#file.name#&studentid=#studentid#">Remove Picture</a></cfif>
								<cfelse>
									<img src="pics/no_stupicture.jpg" width="135">
								</cfif>
							</td></tr>
						</table>
					</td>
					<td width="450" valign="top">
						<table width="100%" cellpadding="2">
							<tr><td align="center" colspan="2"><h1>#firstname# #middlename# #familylastname# (###studentid#)</h1></td></tr>
							<tr><td align="center" colspan="2"><font size=-1><span class="edit_link">[ <cfif client.usertype LTE '4'><a href="index.cfm?curdoc=forms/edit_student_app_1">edit</a> &middot; </cfif> <a href='student_profile.cfm?uniqueid=#uniqueid#'>profile</a> <a href='student_profile_pdf.cfm?studentid=#uniqueid#'> <img src="pics/pdficon_small.gif" border=0></a>]</span></font></td></tr>
			 				<tr><td align="center" colspan="2"><cfif dob EQ ''>n/a<cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old #sex# </cfif></td></tr> 
							<tr><td width="80">Intl. Rep. : </td>
								<td><select name="intrep" <cfif edit EQ 'no'>disabled</cfif> >
									<option value="0"></option>		
									<cfloop query="list_int_reps">
									<cfif int_Agent.userid is list_int_reps.userid><option value="#list_int_reps.userid#" selected>#list_int_reps.businessname# </option><cfelse>
									<option value="#userid#"><cfif #len(businessname)# gt 50>#Left(businessname, 47)#...<cfelse>#businessname#</cfif></option></cfif>
									</cfloop>
									</select>
									
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table width="225" cellpadding="2" align="left">
										<tr><td width="80">Date of Entry : </td><td>#DateFormat(dateapplication, 'mm/dd/yyyy')# </td></tr>
										<tr><td><cfif randid EQ 0>Entered by : <cfelse>Approved by : </cfif> </td><td><cfif entered_by.recordcount NEQ 0>#entered_by.firstname# #entered_by.lastname# (###entered_by.userid#)<cfelse>n/a</cfif></td></tr>										
										<tr><cfif canceldate EQ ''>
											<td width="80" align="right">				
												<cfif active is 1>
													<input name="active" type="checkbox"  value="" checked <cfif edit EQ 'no'>disabled</cfif>>
												<cfelse>
													<input name="active" type="checkbox" value=""  <cfif edit EQ 'no'>disabled</cfif>>
												</cfif>
											</td>
											<td>Student is Active 
											<a href="" onClick="javascript: win=window.open('forms/active_history.cfm?uniqueid=#uniqueid#', 'Settings', 'height=350, width=500, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">history</A></td>
											</cfif>
										</tr>
										<cfif edit NEQ 'no'>
										<Tr
											<td colspan=3>Reason for changing active status: <input type="text" size=30 name="active_reason"> </td>
										</Tr>
										</cfif>
									</table>
									<table width="225" cellpadding="2">
										<!--- EXITS ONLINE APPLICATION --->
										<cfif randid NEQ 0>
										<tr>
											<td align="center">
											<cfif client.usertype LTE '4'>
												<a href="javascript:OpenApp('student_app/index.cfm?curdoc=section1&unqid=#uniqueid#&id=1');"><img src="pics/exits.jpg" border="0"></a>
											<cfelse>
												<a href="javascript:OpenApp('student_app/print_application.cfm?unqid=#uniqueid#');"><img src="pics/exits.jpg" border="0"></a>
											</cfif>
											<br><a href="javascript:OpenSmallW('student_app/section4/page22print.cfm?unqid=#uniqueid#');"><img src="pics/attached-files.gif" border="0"></a>	
											<br><a href="javascript:SendEmail('student_app/email_form.cfm?unqid=#uniqueid#');"><img src="pics/send-email.gif" border="0"></a>	
											</td>
										</tr>
										<cfelse>
										<tr><td align="right">&nbsp;</td></tr>
										</cfif>														
									</table>								
								</td>
							</tr>
							<tr><td align="right">&nbsp;</td></tr>
							<tr><td align="right">&nbsp;</td></tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td align="right" valign="top" width="180">
		<!--- check virtual folder files --->
		<cfset virtualf_directory = "/var/www/html/student-management/nsmg/uploadedfiles/virtualfolder/#get_student_info.studentid#">
		<cfdirectory name="virtual_folder" directory="#virtualf_directory#" filter="*.*">
		<div id="subMenuNav"> 
			<div id="subMenuLinks">  
				<!----All Users---->
				<a href="javascript:OpenPlaceMan('forms/place_menu.cfm?studentid=#client.studentid#' , 'Settings', 'height=400, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes');">Placement Management</a>
				<!----For Testing Purposes---->
	
				<!--- OFFICE USERS ONLY --->
				<cfif client.usertype LTE '4'> 
							<!----	<a href="" onClick="javascript: win=window.open('insurance2/insurance_management.cfm?studentid=#client.studentid#', 'Settings', 'height=400, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Insurance</a> 	
					<a href="" onClick="javascript: win=window.open('insurance/insurance_management.cfm?studentid=#client.studentid#', 'Settings', 'height=400, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Insurance Management</a> 	---->	
					<a href="" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#client.studentid#', 'Settings', 'height=400, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Rep. Payments</a> 					
					<a href="" onClick="javascript: win=window.open('forms/missing_documents.cfm', 'Settings', 'height=450, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Missing Documents</A>
					<a href="" onClick="javascript: win=window.open('forms/notes.cfm', 'Settings', 'height=420, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><cfif get_student_info.notes NEQ ''><img src="pics/green_check.gif" border="0">&nbsp;</cfif>Notes</a> 		
				</cfif> 
				<!--- OFFICE - MANAGERS ONLY --->
				<cfif client.usertype LTE '5'> 
					<a href="" onClick="javascript: win=window.open('forms/profile_adjustments.cfm', 'Settings', 'height=500, width=663, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Profile Adjustments</a>
				</cfif> 				
				<!----All Users---->				
				<a href="" onClick="javascript: win=window.open('virtualfolder/list_vfolder.cfm?unqid=#get_student_info.uniqueid#', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><cfif virtual_folder.recordcount><img src="pics/green_check.gif" border="0">&nbsp;</cfif>Virtual Folder</a>		
				<a href="" onClick="javascript: win=window.open('forms/received_progress_reports.cfm?stuid=#client.studentid#', 'Reports', 'height=450, width=610, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Progress Reports</A>  
				<a href="" onClick="javascript: win=window.open('forms/flight_info.cfm', 'Settings', 'height=500, width=740, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Flight Information</A>
				<a href="" onClick="javascript: win=window.open('forms/double_place_docs.cfm', 'Settings', 'height=380, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Double Place Docs</a>
				<!---- GLOBAL OR COMPLIANCE USERS ---->
				<cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'>
				<a href="" onClick="javascript: win=window.open('compliance/student_checklist.cfm?unqid=#get_student_info.uniqueid#', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Compliance</a>
				</cfif>
			</div>
		</div>
		</td>
	</tr>
</table><br>

<!--- PROGRAM / REGION --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding=2 cellspacing=0 align="center" width="100%">
				<tr bgcolor="D1E0EF"><td colspan="2"><span class="get_attention"><b>:: </b></span>Program <cfif client.usertype LTE '4'>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('forms/stu_program_history.cfm?unqid=#uniqueid#');">History</a> ]</font></cfif></td></tr>
				<tr><td>Program :</td>
					<td>		
						<cfif check_for_expired_program.recordcount EQ '1'>
							#check_for_expired_program.programname#
							<input type="hidden" name="program" value="#check_for_expired_program.programid#">
						<cfelse>
							<select name="program" <cfif edit EQ 'no'>disabled</cfif>>
							<option value="0">Unassigned</option>
							<cfloop query="program">
							<cfif get_student_info.programid EQ programid><option value="#programid#" selected>#programname#</option><cfelse>
							<option value="#programid#">#programname#</option></cfif>
							</cfloop>
						</cfif>
					</td>
				</tr>
				<!--- reason for changing programs --->
				<tr id="program_history" bgcolor="FFBD9D">
					<td>Reason:</td>
					<td><input type="text" size="20" name="program_reason"></td>
				</tr>
				<tr><td>Facilitator :</td>
					<td><cfif regionassigned is 0>	<div class="get_attention">No Region Assigned</div><cfelse>
						<a href="index.cfm?curdoc=user_info&userid=#get_facilitator.userid#">#get_facilitator.firstname# #get_facilitator.lastname#</a></cfif>
					</td>
				</tr>
				<tr><td>Supervising Rep. :</td>
					<td><cfif arearepid is 0> Not Assigned	<cfelse>
						<a href="index.cfm?curdoc=user_info&userid=#get_super_rep.userid#">#get_super_rep.firstname# #get_super_rep.lastname#</a></cfif>
					</td>
				</tr>
				<tr><td>Placing Rep. :</td>
					<td><cfif placerepid is 0>	Not Assigned <cfelse> 
						<a href="index.cfm?curdoc=user_info&userid=#get_place_rep.userid#">#get_place_rep.firstname# #get_place_rep.lastname#</a></cfif> 
					</td>				
				</tr>												
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<table cellpadding=2 cellspacing=0 align="center" width="100%">
				<tr bgcolor="D1E0EF"><td colspan="2"><span class="get_attention"><b>:: </b></span>Region  <cfif client.usertype LTE '4'>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('forms/stu_region_history.cfm?unqid=#uniqueid#');"> History </a> ]</font></cfif></td></tr>
				<tr><td width="120">Region :</td>
					<td><select name="region" onChange="loadOptions('rguarantee'); Guaranteed();" <cfif edit EQ 'no'> disabled </cfif> >
							<option value="0">Select a Region</option> 
							<option value="0">----------------</option>
							<cfloop query="get_regions">
							<option value="#regionid#" <cfif get_student_info.regionassigned EQ regionid>selected</cfif>>#regionname#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<!--- reason for changing regions --->
				<tr id="region_history" bgcolor="FFBD9D">
					<td>Reason:</td>
					<td><input type="text" size="16" name="region_reason"></td>
				</tr>
				<tr><td>Assigned on :</td>
					<td>#DateFormat(dateassigned,'mm/dd/yyyy')#</td>
				</tr>
				<tr><td>Region or State Guaranteed :</td>
						<td><cfif regionguar EQ 'yes'><input type="radio" name="regionguar" value="yes" checked onClick="Guaranteed();" <cfif edit EQ 'no'> disabled </cfif> >Yes <input type="radio" name="regionguar" value="no"  onClick="Guaranteed();" <cfif edit EQ 'no'> disabled </cfif> >No 
						<cfelse><input type="radio" name="regionguar" value="yes"  onClick="Guaranteed();" <cfif edit EQ 'no'> disabled </cfif>  >Yes <input type="radio" name="regionguar" value="no" checked  onClick="Guaranteed();" <cfif edit EQ 'no'> disabled </cfif> >No</cfif>
					</td>
				</tr>
				<tr id="nreg_guarantee"><td>Regional Guaranteed :</td>
					<td>n/a</td>
				</tr>
				<tr id="reg_guarantee"><td>Regional Guaranteed :</td>
					<td><select name="rguarantee" <cfif edit EQ 'no'> disabled </cfif> >
							<!--// add a bunch of blank option arrays to compensate for NS4 DOM display bug //-->
							<option> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </option>
							<option></option><option></option><option></option><option></option><option></option><option></option>
							<option></option><option></option><option></option><option></option><option></option><option></option>
							<option></option><option></option><option></option><option></option><option></option><option></option>
						</select>
					</td>
				</tr>
				<tr id="nsta_guarantee"><td >State Guaranteed :</td>
					<td>n/a</td>
				</tr>
				<tr id="sta_guarantee"><td >State Guaranteed :</td>
					<td><select name="state_guarantee" onChange="FeeWaived(#jan_app#);" <cfif edit EQ 'no'> disabled </cfif> >
						<option value="0">Select a State</option>
						<option value="0">--------------</option>
						<cfloop query="states">
						<option value="#id#" <cfif get_student_info.state_guarantee eq #id#>selected</cfif>>#statename#</option>
						</cfloop>
						</select>
					</td>
				</tr>
				<tr id="nfee_waived"><td >Guarantee Fee Waived</td>
					<td>n/a</td>
				</tr>
				<tr id="fee_waived"><td >Guarantee Fee Waived</td>
					<td><input type="radio" name="jan_app" value=0 onClick="FeeWaived2();" <cfif jan_app EQ 0>checked</cfif> <cfif edit EQ 'no' OR jan_app NEQ '2'>disabled</cfif> >no 
						<input type="radio" name="jan_app"  value=1 onClick="FeeWaived2();" <cfif jan_app EQ 1>checked</cfif> <cfif edit EQ 'no' OR jan_app NEQ '2'>disabled</cfif> >yes
					</td>
				</tr>
			</table>	
		</td>	
	</tr>
</table><br>

<!--- PRE AYP - INSURANCE --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="D1E0EF"><td colspan="3"><span class="get_attention"><b>:: </b></span>Pre-AYP / Private School</td></tr>
				<tr>
					<td><cfif scholarship EQ 0><input type="checkbox" name="scholarship" <cfif edit EQ 'no'>disabled</cfif>><cfelse><input type="checkbox" name="scholarship" checked <cfif edit EQ 'no'>disabled</cfif>></cfif></td>
					<td>Participant of Scholarship Program</td>
				</tr>										
				<tr>
					<td width="10"><cfif privateschool EQ 0><input type="checkbox" name="privateschool_check" <cfif edit EQ 'no'>disabled</cfif>><cfelse><input type="checkbox" name="privateschool_check" checked <cfif edit EQ 'no'>disabled</cfif>></cfif></td>
					<td>Accepts Private HS: &nbsp; 
						<select name="privateschool" <cfif edit EQ 'no'>disabled</cfif>>
						<option value="0"></option>
						<cfloop query="private_schools">
						<option value="#privateschoolid#" <cfif get_student_info.privateschool EQ privateschoolid> selected </cfif> >#privateschoolprice#</option>
						</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td><cfif iffschool EQ 0><input type="checkbox" name="iff_check" <cfif edit EQ 'no'>disabled</cfif>> <cfelse>	<input type="checkbox" name="iff_check" checked <cfif edit EQ 'no'>disabled</cfif>>	</cfif></td>
					<td>Accepts IFF School: &nbsp;
						<select name="iffschool" <cfif edit EQ 'no'>disabled</cfif>>
						<option value="0"></option ><cfif edit EQ 'no'>disabled</cfif>>
						<cfloop query="iff_schools">
						<option value="#iffid#" <cfif get_student_info.iffschool EQ iffid> selected </cfif> >#name#</option>
						</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td><cfif #aypenglish# EQ 0><input type="checkbox" name="english_check" <cfif edit EQ 'no'>disabled</cfif>>	<cfelse> <input type="checkbox" name="english_check" checked <cfif edit EQ 'no'>disabled</cfif>> </cfif> </td>
					<td>Pre-AYP English Camp: &nbsp; &nbsp;
						<select name="ayp_englsh" <cfif edit EQ 'no'>disabled</cfif>>
						<option value="0"></option>
						<cfloop query="aypcamps">
						<cfif camptype EQ "english"><option value="#campid#" <cfif get_student_info.aypenglish EQ campid> selected </cfif>>#name#</option></cfif>
						</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td><cfif #ayporientation# EQ 0><input type="checkbox" name="orientation_check" <cfif edit EQ 'no'>disabled</cfif>>	<cfelse><input type="checkbox" name="orientation_check" checked <cfif edit EQ 'no'>disabled</cfif>>	</cfif></td>
					<td>Pre-AYP Orientation Camp:  &nbsp;
					    <select name="ayp_orientation" <cfif edit EQ 'no'>disabled</cfif>>
						<option value="0"></option>
						<cfloop query="aypcamps">
						<cfif camptype is "orientation"><option value="#campid#" <cfif get_student_info.ayporientation EQ campid> selected </cfif>>#name#</option></cfif>
						</cfloop>
						</select>
					</td>
				</tr>
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="D1E0EF"><td colspan="3"><span class="get_attention"><b>:: </b></span>Insurance</td></tr>
				<tr>
					<td width="10"><cfif int_Agent.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" disabled><cfelse><input type="checkbox" name="insurance_check" checked disabled></cfif></td>
					<td align="left" colspan="2"><cfif int_Agent.insurance_typeid EQ '0'> <font color="FF0000">Insurance Information is missing</font>
						<cfelseif int_Agent.insurance_typeid EQ '1'> Does not take Insurance Provided by #companyshort.companyshort#
						<cfelse> Takes Insurance Provided by #companyshort.companyshort# </cfif>
					</td>
				</tr>
				<tr>
					<td><cfif int_Agent.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" disabled><cfelse><input type="checkbox" name="insurance_check" checked disabled></cfif></td>
					<td>Policy Type :</td>
					<td><cfif int_Agent.insurance_typeid EQ '0'>
							<font color="FF0000">Missing Policy Type</font>
						<cfelseif int_Agent.insurance_typeid EQ '1'> n/a
						<cfelse> #int_Agent.type#	</cfif>		
					</td>
				</tr>
				<tr>
					<td><Cfif insurance is ''><input type="checkbox" name="insured_date" disabled><Cfelse><input type="checkbox" name="insured_date" checked disabled></cfif></td>
					<td>Insured Date :</td>
					<td>
					<cfif int_Agent.insurance_typeid EQ '1'> 
						n/a
						<cfelse>
							
							<cfquery name="ins_info" datasource="caseusa">
								select date 
								from smg_insurance_batch2
								where studentid = #studentid#
							</cfquery>
							<cfif ins_info.recordcount eq 0>
							not insured yet.
							<cfelse>
							#DateFormat(ins_info.date, 'mm/dd/yyyy')#
							</cfif>
						</cfif>
					
					</td>
				</tr>
				<tr>
					<td><Cfif cancelinsurancedate is ''><input type="checkbox" name="insurance_Cancel" disabled><Cfelse><input type="checkbox" name="insurance_Cancel" checked disabled></cfif></td>
					<td>Canceled on :</td>
					<td><a href="javascript:OpenLetter('insurance/insurance_history.cfm?studentid=#studentid#');">#DateFormat(cancelinsurancedate, 'mm/dd/yyyy')#</a></td>
					</tr>
			</table>
		</td>	
	</tr>
</table><br>

<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<!--- Direct Placement --->
			<table cellpadding="2" width="100%">
				<tr bgcolor="D1E0EF"><td colspan="3"><span class="get_attention"><b>:: </b></span>Direct Placement</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td>Direct Placement &nbsp; 
						<cfif direct_placement EQ '0'><input type="radio" name="direct_placement" value="0" checked="yes" <cfif edit EQ 'no'>disabled</cfif>>No<cfelse><input type="radio" name="direct_placement" value="0" <cfif edit EQ 'no'>disabled</cfif>>No</cfif> &nbsp; 
						<cfif direct_placement EQ '1'><input type="radio" name="direct_placement" value="1" checked="yes" <cfif edit EQ 'no'>disabled</cfif>>Yes<cfelse><input type="radio" name="direct_placement" value="1" <cfif edit EQ 'no'>disabled</cfif>>Yes</cfif>													
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Nature of Direct Placement &nbsp; 
						<input type="text" name="direct_place_nature" size="20" value="#direct_place_nature#" <cfif edit EQ 'no'>readonly</cfif>>
					</td>
				</tr>	
			</table>	
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<!--- Cancelation --->
			<table cellpadding="2" width="100%">
				<tr bgcolor="D1E0EF"><td colspan="3"><span class="get_attention"><b>:: </b></span>Cancelation</td></tr>
				<tr>
					<td width="10"><Cfif #canceldate# is ''> <input type="checkbox" name="student_cancel" OnClick="PopulateCancelBox()" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="student_cancel" OnClick="PopulateCancelBox();" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif></td>
					<td colspan="2">Student Cancelled  &nbsp; &nbsp; &nbsp; &nbsp; Date: &nbsp; <input type="text" name="date_canceled" size=8 value="#DateFormat(canceldate, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Reason:</td>
					<td><input type="text" name="cancelreason" size="30" value="#cancelreason#" <cfif edit EQ 'no'>readonly</cfif>></td>
				</tr>
			</table>	
		</td>	
	</tr>
</table><br>

<!--- FORM DS 2019 / LETTERS --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	

	<tr>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="D1E0EF"><td colspan="3"><span class="get_attention"><b>:: </b></span>DS 2019 Form <cfif client.usertype LTE '4'>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('sevis/student_history.cfm?unqid=#uniqueid#');">History</a> ]</font></cfif> </td></tr>				
				<tr>		
					<td><Cfif verification_received EQ ''><input type="checkbox" name="verification_box" onClick="PopulateDS2019Box()" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="verification_box" onClick="PopulateDS2019Box()" checked <cfif edit EQ 'no'>disabled</cfif>> </cfif>
					<td>DS 2019 Verification Received &nbsp; &nbsp; Date: &nbsp;<input type="text" name="verification_form" size=8 value="#DateFormat(verification_received, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
				</tr>
				<tr>
					<td width="10"><cfif int_Agent.accepts_sevis_fee EQ '1'><input type="checkbox" name="accepts_sevis_fee" checked disabled><cfelse><input type="checkbox" name="accepts_sevis_fee" disabled></cfif></td>
					<td><cfif int_Agent.accepts_sevis_fee EQ ''>
							<font color="FF0000">SEVIS Fee Information is missing</font>
						<cfelseif int_Agent.accepts_sevis_fee EQ '0'>
							Intl. Agent does not accept SEVIS Fee
						<cfelseif int_Agent.accepts_sevis_fee EQ '1'>
							Intl. Agent Accepts SEVIS Fee
						</cfif>
					</td>
				</tr>
				<tr><td>&nbsp;</td>	
					<td>DS2019 no.: &nbsp;<input type="text" name="ds2019_no" size=12 value="#ds2019_no#" maxlength="12" <cfif edit EQ 'no'>readonly</cfif>> &nbsp; 
						Batch ID: #sevis_batchid#</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Fee Status: &nbsp; <cfif int_Agent.accepts_sevis_fee NEQ '1' AND sevis_fee_paid_date EQ ''>n/a<cfelseif sevis_fee_paid_date NEQ ''>Paid  on: &nbsp; #DateFormat(sevis_fee_paid_date, 'mm/dd/yyyy')# <cfelse> Unpaid </cfif></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Sevis Status: &nbsp; <cfif sevis_status.recordcount> Active since #DateFormat(sevis_status.datecreated, 'mm/dd/yyyy')# <cfelseif sevis_batchid NEQ '0'> Initial <cfelse> n/a </cfif></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Start Date: &nbsp; <cfif get_sevis_dates.start_date NEQ ''>#DateFormat(get_sevis_dates.start_date, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>End Date: &nbsp; <cfif get_sevis_dates.end_date NEQ ''>#DateFormat(get_sevis_dates.end_date, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
				</tr>				
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="D1E0EF"><td colspan="2"><span class="get_attention"><b>:: </b></span>Letters &nbsp; &nbsp; [  <font size=-3> <a href="javascript:OpenLetter('reports/printing_tips.cfm');">Printing Tips</a></font> ]</td></tr>
		<!--- OFFICE USERS --->
				<cfif client.usertype LTE '4'>
				<tr>
					<td>: : <a href="javascript:OpenLetter('reports/acceptance_letter.cfm');">Acceptance</a></td>
					<td>: : <a href="javascript:OpenLetter('reports/placement_letter.cfm');">Placement</a></td>
				</tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/host_welcome_letter.cfm');">Family Welcome</a></td>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/host_thank_you_letter.cfm');">Family Thank You</a></td>
				</tr>
				<tr>
					<td>: : <a href="javascript:OpenLetter('reports/school_welcome_letter.cfm');">School Welcome</a></td>
					<td>: : <a href="javascript:OpenLetter('reports/school_thank_you_letter.cfm');">School Thank You</a></td>
				</tr>
				<tr>
					<td>: : <a href="javascript:OpenLetter('reports/school_relocation_letter.cfm');">School Relocation</a></td>
					<td>: : <a href="javascript:OpenLetter('reports/flight_information.cfm');">Flight Information</a></td>
				</tr>				
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/letter_student_orientation.cfm');">Student Orient. Sign Off</a></td>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/letter_host_orientation.cfm');">Family Orientation Sign Off</a></td>
				</tr>				
			</table>
			<table cellpadding="2" width="100%">
				<tr bgcolor="D1E0EF"><td colspan="2"><span class="get_attention"><b>:: </b></span>Double Placement Letters</td></tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_host_family.cfm');">Family & School</a></td>
					<td width="50%">
						: : <a href="javascript:OpenLetter('reports/double_placement_nat_fam.cfm');">Natural Family</a>
						<cfif client.usertype LTE '4'> &nbsp; <a href="javascript:OpenLetter('reports/email_dbl_place_nat_fam.cfm?studentid=#get_student_info.studentid#');"><img src="pics/email.gif" border="0" alt="Email Nat. Family Letter"></a></cfif>
					</td>
				</tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_students.cfm');">Students</a></td>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_dos.cfm');">Depart. of State</a></td>
				</tr>
				</cfif>
		<!--- FIELD USERS --->
				<cfif client.usertype GTE '5' AND client.usertype LTE '7'>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/placement_letter.cfm');">Placement</a></td>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/flight_information.cfm');">Flight Information</a></td>
				</tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/host_thank_you_letter.cfm');">Family Thank You</a></td>
				</tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/letter_student_orientation.cfm');">Student Orient. Sign Off</a></td>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/letter_host_orientation.cfm');">Family Orientation Sign Off</a></td>
				</tr>				
			</table>
			<table cellpadding="2" width="100%">
				<tr bgcolor="D1E0EF"><td colspan="2"><span class="get_attention"><b>:: </b></span>Double Placement Letters</td></tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_host_family.cfm');">Family and School</a></td>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_students.cfm');">Students</a></td>
				</tr>
				</cfif>
			</table>	
		</td>	
	</tr>
</table><br>

</div>

<!--- UPDATE BUTTON --->
<cfif edit NEQ 'no'>
<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
<tr><td align="center">
	<input name="Submit" type="image" src="pics/update.gif" alt="Update Profile"  border=0></input>
</td></tr>
</table>
</cfif>
</form>
		
<!---- EDIT BUTTON - OFFICE USERS ---->
<cfif client.usertype LTE '4' AND edit EQ 'no'>
<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
<tr><td align="center">
	<form action="?curdoc=student_info&studentid=#client.studentid#" method="post">&nbsp;
		<input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0  
		<cfif companyid is not client.companyid> disabled </cfif> >
	</form>
</td></tr>
</table>
</cfif> 

<script>
// place this on the page where you want the gateway to appear
oGateway.create();
// call the function to hide and show certain elements according to region guarantee choice 
Guaranteed();
// hide field reason (changing regions)
document.getElementById('region_history').style.display = 'none';
// hide field reason (changing program)
document.getElementById('program_history').style.display = 'none';
</script>	

<cfinclude template="table_footer.cfm">

</cfoutput>

</body>
</html>