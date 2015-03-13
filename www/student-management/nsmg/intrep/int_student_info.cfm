<!--- ------------------------------------------------------------------------- ----
	
	File:		secondVisitReports.cfm
	Author:		Marcus Melo
	Date:		February 15, 2012
	Desc:		Second Visit Report Matrix

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Param URL Variables --->
    <cfparam name="URL.unqid" default="">
    
	<cfif LEN(URL.unqid)>
    
        <cfquery name="qGetStudentByUniqueID" datasource="#APPLICATION.DSN#">
            SELECT *
            FROM smg_students
            WHERE uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.unqid#">
        </cfquery>
        
        <cfset CLIENT.studentID = qGetStudentByUniqueID.studentID>
        
    </cfif>

	<cfscript>
		// Get Student Information 
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=CLIENT.studentID); 

		// Get Placement History List
		qGetPlacementHistoryList = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID,isActive=1);
		
		// Check if student is placed or not (Pending is NOT considered placed)
		vIsStudentPlaced = false;
	
		// Placed Or Pending = Placed
		if ( VAL(qGetPlacementHistoryList.hostID) AND  isDate(qGetPlacementHistoryList.datePlaced) AND listFind("1,2,3,4", qGetStudentInfo.host_fam_approved) ) {
			// Placed - Set as Placed
			vIsStudentPlaced = true;	
		} else if ( VAL(qGetPlacementHistoryList.hostID) AND qGetStudentInfo.host_fam_approved GT 4 AND isDate(qGetPlacementHistoryList.datePISEmailed) ) {
			// Pending Placement - Set as Placed
			vIsStudentPlaced = false;	
		}
	</cfscript>

	<!----International Rep---->
    <cfquery name="qGetIntlRepInfo" datasource="#APPLICATION.DSN#">
        SELECT  u.userid, u.businessname, u.firstname, u.lastname, u.master_accountid, u.accepts_sevis_fee, u.insurance_typeid, insu.type
        FROM smg_users u
        LEFT JOIN smg_insurance_type insu ON insu.insutypeid = u.insurance_typeid
        WHERE u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.intrep#">
    </cfquery>
    
    <!--- error message if the student is not found --->
    <cfif qGetStudentInfo.recordcount EQ 0>
        The student ID you are looking for, <cfoutput>#URL.studentID#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
        <ul>
            <li>the student record was deleted or renumbered
            <li>the link you are following is out of date
            <li>you do not have proper access rights to view the student
        </ul>
        If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
        <cfabort>
    </cfif>

</cfsilent>

<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false 
		});		

	});

	<!--//
	// opens small pop up in a defined format
	var newwindow;
	function OpenSmallW(url) {
		newwindow=window.open(url, 'Application', 'height=300, width=400, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
		if (window.focus) {newwindow.focus()}
	}
	// open online application 
	function OpenApp(url) {
		newwindow=window.open(url, 'Application', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
		if (window.focus) {newwindow.focus()}
	}
	//-->
	<!--
	// opens letters in a defined format
	function OpenLetter(url) {
		newwindow=window.open(url, 'Application', 'height=700, width=800, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
		if (window.focus) {newwindow.focus()}
	}
	//-->
</script> 	

<!--- error message if student does not belong to current int. rep --->
<cfif qGetStudentInfo.intrep NEQ CLIENT.userid AND qGetStudentInfo.branchid NEQ CLIENT.userid AND qGetIntlRepInfo.master_accountid NEQ CLIENT.userid><br>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Students View - Error </h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
	</table>
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><br><h3><p>You are trying to access a student that does not belong to your company.</p></h3>
	<tr><td align="center"><input type="image" value="Back" onClick="history.go(-1)" src="pics/back.gif"></td></tr>
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>

<cfquery name="qGetStudentCompany" datasource="#APPLICATION.DSN#">
	SELECT companyname, companyshort
	FROM smg_companies
	WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.companyid#">
</cfquery>

<cfquery name="program" datasource="#APPLICATION.DSN#">
	select programname, programid
	from smg_programs
	where programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.programid#">
</cfquery>

<cfquery name="qGetBranchInfo" datasource="#APPLICATION.DSN#">
	select userid, businessname
	from smg_users 
	where intrepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.intrep#">
	<cfif qGetStudentInfo.intrep NEQ CLIENT.userid>	
		AND userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
	</cfif>
	ORDER BY businessname
</cfquery>

<!---Facilitator--->
<cfquery name="qGetRegionInfo" datasource="#APPLICATION.DSN#">
	SELECT s.regionassigned,
			r.regionname, 
            r.regionfacilitator, 
            r.regionid, 
            r.company,
			u.firstname, 
            u.lastname,
            u.email
	FROM 
    	smg_students s 
	INNER JOIN 
    	smg_regions r ON s.regionassigned = r.regionid
	LEFT JOIN 
    	smg_users u ON r.regionfacilitator = u.userid
	WHERE 
    	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentID#">
</cfquery>

<cfquery name="qGetSupervisingRep" datasource="#APPLICATION.DSN#">
	Select firstname, lastname, userid from smg_users 
	where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.arearepid#">
</cfquery>

<cfquery name="qGetPlacingRepresentative" datasource="#APPLICATION.DSN#">
	Select firstname, lastname, userid from smg_users 
	where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.placerepid#">
</cfquery>

<cfquery name="qGetRegionGuarantee" datasource="#APPLICATION.DSN#">
	select regionname, regionid
	from smg_regions
	where regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.regionalguarantee)#">
</cfquery>

<cfquery name="qGetStateGuarantee" datasource="#APPLICATION.DSN#">
	SELECT * FROM smg_states
	WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.state_guarantee)#">
</cfquery>

<cfquery name="qGetPrivateSchool" datasource="#APPLICATION.DSN#">
	select privateschoolid, privateschoolprice
	from smg_private_schools
	WHERE privateschoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.privateschool)#">
</cfquery>

<cfquery name="qGetIIFSchool" datasource="#APPLICATION.DSN#">
	select iffid, name
	from smg_iff
	WHERE iffid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.iffschool)#">
</cfquery>

<cfquery name="qGetAYPCamp" datasource="#APPLICATION.DSN#">
	select campid, name, camptype
	from smg_aypcamps
	WHERE campid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.aypenglish)#">
</cfquery>

<cfquery name="qGetAYPOrientationCamp" datasource="#APPLICATION.DSN#">
	select campid, name, camptype
	from smg_aypcamps
	WHERE campid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.ayporientation)#">
</cfquery>

<!----Header Table---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height="24">
	<tr valign=middle height="24">
		<td height="24" width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Student Information </td><td background="pics/header_background.gif" align="right"></td>
		<td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput query="qGetStudentInfo">
<div class="section">

<table align="center" width="75%">  
	<tr><td align="center" colspan="2"><h2>#qGetStudentCompany.companyname#</h2></td></tr>
	<tr>
		<td>
			<cfif qGetStudentInfo.hostid EQ 0 and qGetStudentInfo.canceldate is ''>
			<table background="pics/unplaced.jpg" cellpadding="2" width="100%"> 
			<cfelseif qGetStudentInfo.hostid EQ 0 and qGetStudentInfo.canceldate is not ''>
			<table background="pics/canceled.jpg" cellpadding="2" width="100%"> 
			<cfelse>
			<table width=100% align="Center" cellpadding="3">				
			</cfif>
				<tr>
					<td width="133">
						<table width="100%" cellpadding="3">
							<tr><td><td width="133">
								<cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#CLIENT.studentID#.*">
								<cfif file.recordcount>
									<img src="uploadedfiles/web-students/#file.name#" width="135">
								<cfelse>
									<img src="pics/no_stupicture.jpg" width="135">
								</cfif>
							</td></tr>
						</table>
					</td>
					<td valign="top">
						<table width="100%" cellpadding="3">
							<tr><td align="center" colspan="2"><h1>#firstname# #middlename# #familylastname# (#studentID#)</h1></td></tr>
							<tr><td align="center" colspan="2"><font size=-1><span class="edit_link">[ <a href='?curdoc=intrep/int_student_profile&unqid=#uniqueid#'>PROFILE</a></span></font> ]</td></tr>
			 				<tr><td align="center" colspan="2"><cfif dob is ''><cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old #sex# </cfif></td></tr> 
							<tr><td align="right">Intl. Rep. : </td><td>#qGetIntlRepInfo.businessname#</td></tr>
							<tr><td align="right">Branch : </td>
								<cfif qGetStudentInfo.intrep EQ CLIENT.userid>
									<cfform name="branch" action="?curdoc=intrep/qr_int_student_info" method="post">
										<cfinput type="hidden" name="studentID" value="#studentID#">
											<td valign="middle"><cfselect name="branchid">
												<option value="0">Main Office</option>
												<cfloop query="qGetBranchInfo">
												<option value="#userid#" <cfif qGetStudentInfo.branchid EQ	qGetBranchInfo.userid>selected</cfif>>#businessname#</option>
												</cfloop>
												</cfselect>
												&nbsp; &nbsp; <cfinput name="submit" type="image" src="pics/update.gif" border=0 alt=" update branch information ">
											</td>
									</cfform>
								<cfelse>
									<td>#qGetBranchInfo.businessname#</td>
								</cfif>
							</tr>							
							<tr><td align="right">Date of Entry : </td><td>#DateFormat(dateapplication, 'mm/dd/yyyy')#</td></tr>
							<tr><td align="right"><cfif active is 1><input type="checkbox" name="active" checked="Yes" disabled><cfelse><input type="checkbox" name="active" disabled></cfif></td><td>Student is Active</td></tr>														
							<!--- EXITS ONLINE APPLICATION --->
							<cfif app_current_status NEQ 0>
							<tr>
								<td align="center" colspan="2">
									<a href="javascript:OpenApp('student_app/index.cfm?curdoc=section1&unqid=#uniqueid#&id=1');"><img src="pics/exits.jpg" border="0"></a>
								<br><a href="javascript:OpenSmallW('student_app/section4/page22print.cfm?unqid=#uniqueid#');"><img src="pics/attached-files.gif" border="0"></a>	
								</td>
							</tr>
							</cfif>														
						</table>								
					</td>
				</tr>
			</table>
		</td>
		<td align="right" valign="top">
			<div id="subMenuNav"> 
				<div id="subMenuLinks">  
                <a href="index.cfm?curdoc=virtualFolder/view&unqid=#qGetStudentInfo.uniqueID#" >Virtual Folder</a>
					
				<a class=nav_bar href="" onClick="javascript: win=window.open('forms/received_progress_reports.cfm?stuid=#CLIENT.studentID#', 'Reports', 'height=250, width=620, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Progress Reports</A>  
                <a href="student/index.cfm?action=flightInformation&uniqueID=#qGetStudentInfo.uniqueID#&programID=#qGetStudentInfo.programID#" class="jQueryModal">Flight Information</a>
				<cfif vIsStudentPlaced>
					<a class=nav_bar href="index.cfm?curdoc=intrep/int_host_fam_info&hostid=#qGetStudentInfo.hostid#">Host Family</A>
				</cfif>
               
				</div>
			</div>
		</td>
	</tr>
</table>

<table align="center" width="75%">
	<tr>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>:: </b></span>Program</td></tr>
				<tr><td>Program :</td><td><cfif program.recordcount NEQ '0'>#program.programname#<cfelse>n/a</cfif></td></tr>
				<tr><td>Facilitator :</td><td><cfif qGetStudentInfo.regionassigned EQ 0><div class="get_attention">No Region Assigned</div><cfelse> <a href="mailto:#qGetRegionInfo.email#">#qGetRegionInfo.firstname# #qGetRegionInfo.lastname#</a></cfif></td></tr>
				<tr><td>Supervising Rep. :</td><td><cfif qGetStudentInfo.arearepid EQ 0 OR qGetStudentInfo.host_fam_approved GT 4>Not Assigned<cfelse>#qGetSupervisingRep.firstname# #qGetSupervisingRep.lastname#</cfif></td></tr>
				<tr><td>Placing Rep. :</td><td><cfif qGetStudentInfo.placerepid EQ 0 OR qGetStudentInfo.host_fam_approved GT 4>Not Assigned<cfelse>#qGetPlacingRepresentative.firstname# #qGetPlacingRepresentative.lastname#</cfif> </td></tr>												
			</table>
		</td>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>:: </b></span>Region</td></tr>
				<tr><td>Assigned to Region :</td><td><cfif qGetRegionInfo.recordcount NEQ '0'><b>#qGetRegionInfo.regionname#</b><cfelse> Unassigned </cfif></td></tr>
				<tr>
                	<td>Region / State Preference :</td>
					<td>
						<input type="radio" name="regionguar" value="yes" disabled="disabled" <cfif regionguar EQ 'yes' OR state_guarantee GT 0>checked="checked"</cfif>>Yes 
                        <input type="radio" name="regionguar" value="no" disabled <cfif regionguar EQ 'no' AND state_guarantee EQ 0>checked="checked"</cfif>>No 
					</td>
              	</tr>
				<tr><td>Region Preference :</td><td><cfif qGetRegionGuarantee.recordcount EQ '0'> n/a <cfelse> #qGetRegionGuarantee.regionname# </cfif></td></tr>
				<tr><td>State Preference :</td><td><cfif qGetStateGuarantee.recordcount EQ '0'> n/a <cfelse> #qGetStateGuarantee.statename# </cfif></td></tr>				
			</table>	
		</td>	
	</tr>
</table>

<table align="center" width="75%">
	<tr>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="3"><span class="get_attention"><b>:: </b></span>Pre-AYP / Private School</td></tr>
				<tr><td width="4"><cfif scholarship EQ 0><input type="checkbox" name="scholarship" disabled><cfelse><input type="checkbox" name="scholarship " checked disabled></cfif></td>
					<td colspan="2">Participant of Scholarship Program</td></tr>	
				<tr><td><cfif privateschool EQ 0><input type="checkbox" name="privateschool_check" disabled><cfelse><input type="checkbox" name="privateschool_check" checked disabled></cfif></td>
					<td>Accepts Private HS :</td>
					<td><cfif qGetPrivateSchool.recordcount EQ '0'> n/a <cfelse> #qGetPrivateSchool.privateschoolprice# </cfif></td></tr>	
				<tr><td><cfif iffschool EQ 0><input type="checkbox" name="iff_check" disabled><cfelse><input type="checkbox" name="iff_check" checked disabled></cfif></td>
					<td>Accepts IFF School :</td>
					<td><cfif qGetIIFSchool.recordcount EQ '0'> n/a <cfelse> #qGetIIFSchool.name# </cfif></td></tr>	
				<tr><td><cfif aypenglish EQ 0><input type="checkbox" name="english_check" disabled><cfelse><input type="checkbox" name="english_check" checked disabled></cfif></td>
					<td>PRE-AYP English Camp :</td>
					<td><cfif qGetAYPCamp.recordcount EQ '0'> n/a <cfelse> #qGetAYPCamp.name# </cfif></td></tr>	
				<tr><td><cfif ayporientation EQ 0><input type="checkbox" name="orientation_check" disabled><cfelse><input type="checkbox" name="orientation_check" checked disabled></cfif></td>
					<td>PRE-AYP Orientation Camp :</td>
					<td><cfif qGetAYPOrientationCamp.recordcount EQ '0'> n/a <cfelse> #qGetAYPOrientationCamp.name# </cfif></td></tr>	
			</table>
		</td>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="3"><span class="get_attention"><b>:: </b></span>Insurance</td></tr>
				<tr>
					<td width="10"><cfif qGetIntlRepInfo.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" disabled><cfelse><input type="checkbox" name="insurance_check" checked disabled></cfif></td>
					<td align="left" colspan="2"><cfif qGetIntlRepInfo.insurance_typeid EQ '0'> <font color="FF0000">Insurance Information is missing</font>
						<cfelseif qGetIntlRepInfo.insurance_typeid EQ '1'> Does not take Insurance Provided by SMG
						<cfelse> Takes Insurance Provided by SMG</cfif>
					</td>
				</tr>
				<tr>
					<td><cfif qGetIntlRepInfo.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" disabled><cfelse><input type="checkbox" name="insurance_check" checked disabled></cfif></td>
					<td>Policy Type :</td>
					<td align="left">
						<cfif qGetIntlRepInfo.insurance_typeid EQ '0'>
							<font color="FF0000">Missing Policy Type</font>
						<cfelseif qGetIntlRepInfo.insurance_typeid EQ '1'> n/a
						<cfelse> #qGetIntlRepInfo.type#	</cfif>		
					</td>
				</tr>
				<tr><td><Cfif insurance is ''><input type="checkbox" name="insured_date" disabled><Cfelse><input type="checkbox" name="insured_date" checked disabled></cfif></td>
					<td>Insured Date :</td>
					<td>#DateFormat(insurance, 'mm/dd/yyyy')#</td></tr>
				<tr><td><Cfif cancelinsurancedate is ''><input type="checkbox" name="insurance_Cancel" disabled><Cfelse><input type="checkbox" name="insurance_Cancel" checked disabled></cfif></td>
					<td>Canceled on :</td>
					<td>#cancelinsurancedate#</td></tr>
			</table>	
		</td>	
	</tr>
</table>

<table align="center" width="75%">
	<tr>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="3"><span class="get_attention"><b>:: </b></span>#CLIENT.DSFormName# Form</td></tr>
				<tr>		
					<td width="4"><Cfif verification_received EQ ''><input type="checkbox" name="verification_box" disabled> <cfelse> <input type="checkbox" name="verification_box" checked disabled> </cfif>
					<td>#CLIENT.DSFormName# Verification Received &nbsp; Date: &nbsp; #DateFormat(verification_received, 'mm/dd/yyyy')#</td>
				</tr>
				<tr><td></td><td>#CLIENT.DSFormName# number : &nbsp; <cfif ds2019_no EQ ''>n/a<cfelse>#ds2019_no#</cfif></td></tr>	
				<tr>
					<td width="4"><cfif qGetIntlRepInfo.accepts_sevis_fee EQ '1'><input type="checkbox" name="accepts_sevis_fee" checked disabled><cfelse><input type="checkbox" name="accepts_sevis_fee" disabled></cfif></td>
					<td><cfif qGetIntlRepInfo.accepts_sevis_fee EQ ''>
							<font color="FF0000">SEVIS Fee Information is missing</font>
						<cfelseif qGetIntlRepInfo.accepts_sevis_fee EQ '0'>
							Intl. Agent does not accept SEVIS Fee
						<cfelseif qGetIntlRepInfo.accepts_sevis_fee EQ '1'>
							Intl. Agent Accepts SEVIS Fee
						</cfif>
					</td>
				</tr>
				<cfif qGetIntlRepInfo.accepts_sevis_fee EQ '1'>
				<tr><td></td><td>Fee Status: &nbsp; <cfif sevis_fee_paid_date EQ ''>Unpaid <cfelse>Paid  on: &nbsp; #DateFormat(sevis_fee_paid_date, 'mm/dd/yyyy')#</cfif></td></tr>	
				</cfif>
			</table>
		</td>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="3"><span class="get_attention"><b>:: </b></span>Cancelation</td></tr>
				<tr>
					<td width="10"><input type="checkbox" name="student_cancel" disabled <Cfif canceldate NEQ ''>checked</cfif>></td>
					<td colspan="2">Student Cancelled  &nbsp; &nbsp; &nbsp; &nbsp; Date: &nbsp; #DateFormat(canceldate, 'mm/dd/yyyy')#</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Reason:</td>
					<td>#cancelreason#</td>
				</tr>
			</table>	
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>:: </b></span>Letters</td></tr>
				<tr><td>: : <a href="" onClick="javascript: win=window.open('reports/acceptance_letter.cfm', 'Settings', 'height=480,width=800, location=yes, scrollbars=yes,  toolbar=yes, menubar=yes, resizable=yes'); win.opener=self; return false;">Acceptance Letter</a></td></tr>
				<cfif vIsStudentPlaced>
                    <tr><td>: : <a href="javascript:OpenLetter('reports/labels_student_idcards.cfm?uniqueID=#qGetStudentInfo.uniqueID#');">Student ID Card</a></td></tr>
					<tr><td>: : <a href="javascript:OpenLetter('reports/placementInfoSheet.cfm?uniqueID=#qGetStudentInfo.uniqueid#');">Placement</a></td></tr>
				</cfif>                
			</table>	
		</td>	
	</tr>
</table>
</div>

</cfoutput>

<cfinclude template="../table_footer.cfm">