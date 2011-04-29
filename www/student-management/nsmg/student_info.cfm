<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<!--- Param variables --->
    <cfparam name="FORM.edit" default="no">
    
    <cfparam name="CLIENT.company_submitting" default="0">
    
    <cfparam name="studentID" default="0">
    
    <cfscript>
		if ( VAL(studentID) ) {
			CLIENT.studentID = studentID;
		}
		
		// Only allow edits if USER is LTE 4 
		if ( CLIENT.usertype GT 4 ) {
			FORM.edit = 'no';
		}
		
		// Set currentDate
		currentDate = now();

		// Get Student Information 
		qGetStudentInfo = AppCFC.STUDENT.getStudentByID(studentID=studentID); 

		// Get Super Rep
		qGetSuperRep = APPCFC.USER.getUserByID(userID=VAL(qGetStudentInfo.arearepid));

		// Get Place Rep
		qGetPlaceRep = APPCFC.USER.getUserByID(userID=VAL(qGetStudentInfo.placerepid));

		// Get Super Rep
		qEnteredBy = APPCFC.USER.getUserByID(userID=VAL(qGetStudentInfo.entered_by));
		
		// Get Student Company Assigned
		qAssignedCompany = AppCFC.COMPANY.getCompanyByID(companyID=qGetStudentInfo.companyID);

		// Get Student Region Assigned
		qRegionAssigned = AppCFC.REGION.getRegions(regionID=qGetStudentInfo.regionAssigned);
		
		// Insurance Information
		qInsuranceHistory = AppCFC.INSURANCE.getInsuranceHistoryByStudent(studentID=qGetStudentInfo.studentID, type='N,R,EX');

		// Insurance Information
		qInsuranceCancelation = AppCFC.INSURANCE.getInsuranceHistoryByStudent(studentID=qGetStudentInfo.studentID, type='X');
		
		// Get Private Schools Prices
		qPrivateSchools = APPCFC.SCHOOL.getPrivateSchools();
		
		// Get IFF Schools
		qIFFSchools = APPCFC.SCHOOL.getIFFSchools();
		
		// Get AYP Camps
		qAYPCamps = APPCFC.SCHOOL.getAYPCamps();
		
		// Get Intl. Rep List
		qIntRepsList = APPCFC.USER.getUsers(usertype=8);

		// Check User Compliance Access
		qUserCompliance = APPCFC.USER.getUserByID(userID=CLIENT.userid);

		// Get Company Information
		qCompanyShort = AppCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		
		// Get a list of regions for this companyID
		qRegions = AppCFC.REGION.getRegions(companyID=CLIENT.companyID);
		
		// Get Available teams
		qAvailableTeams = AppCFC.COMPANY.getCompanies(website=CLIENT.company_submitting);

		// Virtual Folder Directory
		virtualDirectory = "#AppPath.onlineApp.virtualFolder##qGetStudentInfo.studentID#";
		
		// Get Facilitator for this Region
		qFacilitator = APPCFC.USER.getUserByID(userID=VAL(qRegionAssigned.regionfacilitator));
	</cfscript>
	
    <!--- Student Picture --->
	<cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#qGetStudentInfo.studentID#.*">

	<!--- check virtual folder files --->
    <cfdirectory name="getVirtualFolder" directory="#virtualDirectory#" filter="*.*">

    <!----International Rep---->
    <cfquery name="qIntAgent" datasource="#application.dsn#">
        SELECT 
        	u.businessname, 
            u.firstname, 
            u.lastname, 
            u.userid, 
            u.accepts_sevis_fee, 
            u.insurance_typeid,
            insu.type 
        FROM 
        	smg_users u
        LEFT JOIN 
        	smg_insurance_type insu ON insu.insutypeid = u.insurance_typeid
        LEFT JOIN 
        	smg_insurance_codes codes ON codes.insutypeid = insu.insutypeid
        WHERE 
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.intrep)#">
    </cfquery>
   
    <cfquery name="qProgramInfo" datasource="#application.dsn#">
        SELECT 
        	programname, 
            programid, 
            enddate,
            seasonid
        FROM 
        	smg_programs
        WHERE 
			is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
        AND 
        	companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
        AND 
        	enddate > #currentDate#
        ORDER BY
        	programname
    </cfquery>
    
    <!----Ins. Policy Code---->
    <Cfquery name="qInsPolicy" datasource="#application.dsn#">
        SELECT 
        	policycode
        FROM 
        	smg_insurance_codes
        WHERE 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND 
        	seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qProgramInfo.seasonid#">
        AND 
        	insutypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qIntAgent.insurance_typeid#">
    </cfquery>
    
    <!----Get Expired Student Programs---->
    <cfquery name="qCheckForExpiredProgram" datasource="#application.dsn#">
        SELECT 
        	smg_students.studentID, 
            smg_students.programid, 
            smg_programs.programname
        FROM 
        	smg_programs 
        INNER JOIN 
        	smg_students ON smg_programs.programid = smg_students.programid
        WHERE 
        	smg_programs.enddate <= #currentDate# 
        AND 
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
    </cfquery>
        
    <cfquery name="qStates" datasource="#application.dsn#">
        SELECT 
        	id, 
            statename
        FROM 
        	smg_states
        WHERE 
        	id != <cfqueryparam cfsqltype="cf_sql_integer" value="2">
        AND 
        	id != <cfqueryparam cfsqltype="cf_sql_integer" value="11">
        ORDER BY 
        	id
    </cfquery>
        
    <cfquery name="qSevisStatus" datasource="#application.dsn#">
        SELECT 
        	batchid, 
            received, 
            datecreated
        FROM 
        	smg_sevis
        INNER JOIN 
        	smg_students s ON s.sevis_activated = smg_sevis.batchid
        WHERE 
        	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
        AND 
        	received = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
    </cfquery>
    
    <cfquery name="qGetSevisDates" datasource="#application.dsn#">
        SELECT 
        	start_date, 
            end_date
        FROM 
        	smg_sevis_history
        WHERE 
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
        ORDER BY 
        	historyid DESC 
    </cfquery>
    
    <!----Date of last phone contact---->
    <cfquery name="qLastContact" datasource="#application.dsn#">
        SELECT 
        	max(date) as qLastContact
        FROM 
        	phone_call_log
        WHERE 
        	fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
    </cfquery>
    
</cfsilent>

<script type="text/javascript" src="student_info.js"></script>
	
<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {
		// call the function to hide and show certain elements according to region guarantee choice 
		displayGuaranteed();

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false 
		});		

	});
</script> 	

<cfoutput>

<!--- student does not exist --->
<cfif NOT VAL(qGetStudentInfo.recordcount)>
	The student ID you are looking for, #studentID#, was not found. This could be for a number of reasons.<br /><br />
	<ul>
		<li>the student record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view the student
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:#APPLICATION.EMAIL.support#">Support</a>
	<cfabort>
</cfif>

</cfoutput>

<!--- student's view only - transfer to profile --->
<cfif CLIENT.usertype EQ 9>
	<cflocation url="index.cfm?curdoc=student_profile&uniqueid=#qGetStudentInfo.uniqueid#" addtoken="no">
</cfif>

<!--- Block if users try to change the student id in the address bar --->
<cfif CLIENT.usertype GT 4> 
				
	<cfif qGetStudentInfo.regionassigned NEQ CLIENT.regionid>
    	<br />
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
					<br /><div align="justify"><img src="pics/error_exclamation.gif" align="left"><h3>
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

<!--- Table Header --->
<gui:tableHeader
	imageName="students.gif"
	tableTitle="Student Information"
	tableRightTitle=""
/>

<cfoutput query="qGetStudentInfo">

<cfform name="studentForm" method="post" action="querys/update_student_info.cfm" onSubmit="return formValidation(#qGetStudentInfo.regionassigned#, #qGetStudentInfo.programid#);">
<input type="hidden" name="studentID" value="#qGetStudentInfo.studentID#">

<div class="section"><br />

<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td valign="top" width="590">
			<cfif hostid is 0 and NOT LEN(cancelDate)>
			<table background="pics/unplaced.jpg" cellpadding="2" width="100%"> 
			<cfelseif LEN(canceldate)>
			<table background="pics/canceled.jpg" cellpadding="2" width="100%"> 
			<cfelse>
			<table width=100% align="Center" cellpadding="2">				
			</cfif>
				<tr>
					<td width="135" valign="top">
						<table width="100%" cellpadding="2">
							<tr>
                            	<td width="135">
                                    <!--- Use a cftry instead of cfif. Using cfif when image is not available CF throws an error. --->
                                    <cftry>
                                    
										<cfscript>
											// CF throws errors if can't read head of the file "ColdFusion was unable to create an image from the specified source file". 
											// Possible cause is a gif file renamed as jpg. Student #17567 per instance.
										
                                            // this file is really a gif, not a jpeg
                                            pathToImage = AppPath.onlineApp.picture & studentPicture.name;
                                            imageFile = createObject("java", "java.io.File").init(pathToImage);
											
                                            // read the image into a BufferedImage
                                            ImageIO = createObject("java", "javax.imageio.ImageIO");
                                            bi = ImageIO.read(imageFile);
                                            img = ImageNew(bi);
                                        </cfscript>              
                                        
                                        <cfimage source="#img#" name="myImage">
                                        <!---- <cfset ImageScaleToFit(myimage, 250, 135)> ---->
                                        <cfimage source="#myImage#" action="writeToBrowser" border="0" width="135px"><br />
                                       
                                        <cfif CLIENT.usertype lte 4><A href="qr_delete_picture.cfm?student=#studentPicture.name#&studentID=#studentID#">Remove Picture</a></cfif>
                                        
                                        <cfcatch type="any">
                                            <img src="pics/no_stupicture.jpg" width="135">
                                        </cfcatch>
                                        
                                    </cftry>
								</td>
                            </tr>
						</table>
					</td>
					<td width="450" valign="top">
						<table width="100%" cellpadding="2">
							<tr><td align="center" colspan="2"><h1>#firstname# #middlename# #familylastname# (###studentID#)</h1></td></tr>
							<tr>
                            	<td align="center" colspan="2">
                            		<font size=-1><span class="edit_link">
                                    [ 
										<cfif ListFind("1,2,3,4", CLIENT.usertype)>
                                        	<a href="index.cfm?curdoc=forms/edit_student_app_1">edit</a> &middot; 
                                            <a href='studentProfileFull.cfm?uniqueid=#uniqueid#'>full profile</a> &middot;
                                        </cfif> 
                                    	<a href='student_profile.cfm?uniqueid=#uniqueid#&profileType=web'>profile</a> &middot;
                                        <a href='student_profile.cfm?uniqueid=#uniqueid#&profileType=pdf'> <img src="pics/pdficon_small.gif" border=0></a> &middot;
										<cfif ListFind("1,2,3,4,5,6,7", CLIENT.usertype)>  <!--- Only Office & Managers --->
	                                        <a href="javascript:SendEmail('student_profile.cfm?uniqueid=#uniqueid#&profileType=email', 300, 400);" title="Email Student Profile and Letters"> email profile <img src="pics/email.gif" border="0" alt="Email Student Profile and Letters"> </a>
                                        </cfif>
                                    ]
                                    </span></font>
                                </td>
                            </tr>
			 				<tr><td align="center" colspan="2"><cfif dob EQ ''>n/a<cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old #sex# </cfif></td></tr> 
							<tr><td width="80">Intl. Rep. : </td>
								<td><select name="intrep" <cfif FORM.edit EQ 'no'>disabled</cfif> >
                                        <option value="0" selected></option>		
                                        <cfloop query="qIntRepsList">
                                        	<option value="#qIntRepsList.userid#" <cfif qIntRepsList.userid EQ qGetStudentInfo.intrep> selected </cfif> >
												<cfif len(businessname) gt 50>#Left(businessname, 47)#...<cfelse>#businessname#</cfif>
                                            </option>
                                        </cfloop>
									</select>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table width="225" cellpadding="2" align="left">
										<tr><td width="80">Date of Entry : </td><td>#DateFormat(dateapplication, 'mm/dd/yyyy')# </td></tr>
										<tr><td><cfif randid EQ 0>Entered by : <cfelse>Approved by : </cfif> </td><td><cfif qEnteredBy.recordcount NEQ 0>#qEnteredBy.firstname# #qEnteredBy.lastname# (###qEnteredBy.userid#)<cfelse>n/a</cfif></td></tr>										
										
										<cfif CLIENT.usertype EQ 1 OR ListFind("8731,11245,8743,12313,1077,12431,11273", CLIENT.userid)> <!--- Pat, Bill, Bob, Brian Hause, Diana, Gary and Margarita --->
                                        <tr>
											<td>Division:</td><td>
											<cfif FORM.edit EQ 'no'>
                                            	#qAssignedCompany.team_id# 
                                            <cfelse>
                                                <select name="team_id">
                                                <cfloop query="qAvailableTeams">
                                                <option value="#companyid#" <cfif CLIENT.companyid eq companyid>selected</cfif>>#team_id#</option>
                                                </cfloop>
                                                </select>
                                                <br />*You will need to re-assign regions after updating.
											</cfif>
										</tr>
                                        </cfif>
                                        
										<tr><cfif canceldate EQ ''>
											<td width="80" align="right">				
												<cfif VAL(active)>
													<input name="active" type="checkbox"   checked <cfif FORM.edit EQ 'no'>disabled</cfif>>
												<cfelse>
													<input name="active" type="checkbox"  <cfif FORM.edit EQ 'no'>disabled</cfif>>
												</cfif>
											</td>
											<td>Student is Active 
											<a href="" onClick="javascript: win=window.open('forms/active_history.cfm?uniqueid=#uniqueid#', 'Settings', 'height=350, width=500, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">history</A></td>
											</cfif>
										</tr>
										<cfif FORM.edit NEQ 'no'>
										<Tr>
											<td colspan="2">Reason for changing active status: <input type="text" size="25" name="active_reason"> </td>
										</Tr>
										</cfif>
									</table>
                                    
									<table width="225" cellpadding="2" align="right">
										<!--- EXITS ONLINE APPLICATION --->
										<cfif randid NEQ 0>
										<tr>
											<td align="center">
											<cfif CLIENT.usertype LTE '4'>
												<a href="javascript:OpenApp('student_app/index.cfm?curdoc=section1&unqid=#uniqueid#&id=1');"><img src="pics/exits.jpg" border="0"></a>
											<cfelse>
												<a href="javascript:OpenApp('student_app/print_application.cfm?unqid=#uniqueid#');"><img src="pics/exits.jpg" border="0"></a>
											</cfif>
											<br /><a href="javascript:OpenMediumW('student_app/section4/page22print.cfm?unqid=#uniqueid#');"><img src="pics/attached-files.gif" border="0"></a>	
											<cfif client.usertype lt 7>
                                            <br /><a href="javascript:SendEmail('student_app/email_form.cfm?unqid=#uniqueid#', 400, 450);"><img src="pics/send-email.gif" border="0"></a>	</cfif>
											</td>
										</tr>
										<cfelse>
										<tr><td align="right">&nbsp;</td></tr>
										</cfif>														
									</table>								
								</td>
							</tr>
							<tr>
                          <td align="right"><a href="" onClick="javascript: win=window.open('forms/phone_call.cfm?studentID=#qGetStudentInfo.studentID#', 'PhoneCall', 'height=600, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><strong>Phone Call:</strong></a></td>
                          <td> <cfif qLastContact.qLastContact is 'NULL'>
                            Not Yet.
                            <cfelse>
                            #DateFormat(qLastContact.qLastContact, 'mm/dd/yyyy')#  #TimeFormat(qLastContact.qLastContact, 'hh:mm tt')#
                            </cfif>
                          </td>
                        </tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		
		<td align="right" valign="top" width="180">
		<div id="subMenuNav"> 
			<div id="subMenuLinks">  
				<!----All Users---->
				<a href="javascript:OpenPlaceMan('forms/place_menu.cfm?studentID=#qGetStudentInfo.studentID#' , 'Settings', 'height=400, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes');">Placement Management</a>
	
				<!--- OFFICE USERS ONLY --->
				<cfif CLIENT.usertype LTE 4> 
					<!---- <a href="" onClick="javascript: win=window.open('insurance/insurance_management.cfm?studentID=#qGetStudentInfo.studentID#', 'Settings', 'height=400, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Insurance Management</a> ---->	
					<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#qGetStudentInfo.studentID#', 700, 500);" class="nav_bar">Representative Payments</a> 					
                    <a href="javascript:openPopUp('forms/missing_documents.cfm', 450, 500);" class="nav_bar">Missing Documents</a>
					<a href="javascript:openPopUp('forms/notes.cfm', 450, 500);" class="nav_bar"><cfif LEN(qGetStudentInfo.notes)><img src="pics/green_check.gif" border="0">&nbsp;</cfif>Notes</a> 	
                    <a href="javascript:openPopUp('forms/ssp.cfm?studentid=#client.studentid#', 600, 450);" class="nav_bar">Student Services Project</a>	
				</cfif> 
                
				<!--- OFFICE - MANAGERS ONLY --->
				<cfif CLIENT.usertype LTE 5> 
					<a href="" onClick="javascript: win=window.open('forms/profile_adjustments.cfm', 'Settings', 'height=500, width=663, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Profile Adjustments</a>		
                </cfif> 
                				
				<!----All Users---->				
				<a href="" onClick="javascript: win=window.open('virtualfolder/list_vfolder.cfm?unqid=#qGetStudentInfo.uniqueid#', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><cfif VAL(getVirtualFolder.recordcount)><img src="pics/green_check.gif" border="0">&nbsp;</cfif>Virtual Folder</a>		
				<a href="" onClick="javascript: win=window.open('forms/received_progress_reports.cfm?stuid=#qGetStudentInfo.studentID#', 'Reports', 'height=450, width=610, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Progress Reports</A>  
                <a href="student/index.cfm?action=flightInformation&uniqueID=#qGetStudentInfo.uniqueID#" class="jQueryModal">Flight Information</a>
				<a href="" onClick="javascript: win=window.open('forms/double_place_docs.cfm', 'Settings', 'height=380, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Double Place Docs</a>
                <a href="" onClick="javascript: win=window.open('tours/trips.cfm', 'Settings', 'height=450, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Student Trips</a>
				
				<!---- GLOBAL OR COMPLIANCE USERS ---->
				<cfif CLIENT.usertype EQ 1 OR qUserCompliance.compliance EQ 1>
					<a href="" onClick="javascript: win=window.open('compliance/student_checklist.cfm?unqid=#qGetStudentInfo.uniqueid#', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Compliance</a>
				</cfif>
			</div>
		</div>
		</td>
	</tr>
</table>

<br />

<cfif CLIENT.companyid neq qAssignedCompany.companyid> 
	<table width=770 bgcolor="##CC3300" align="center">
		<tr>
		<td>
			<img src="pics/error_exclamation.gif"></td><td><font color="white">Student is assigned to a different company then you are accessing the record through. <br /> Please change companies to #qAssignedCompany.team_id# to prevent errors in displayed and recorded information.</font>
		</td>
	</table>
		</cfif>
<!--- PROGRAM / REGION --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding=2 cellspacing=0 align="center" width="100%">
				<tr bgcolor="##EAE8E8">
                	<td colspan="2">
                    	<span class="get_attention"><b>:: </b></span>Program <cfif CLIENT.usertype LTE '4'>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('forms/stu_program_history.cfm?unqid=#uniqueid#');">History</a> ]</font></cfif>
                    </td>
                </tr>
				<tr><td>Program :</td>
					<td>		
						<cfif qCheckForExpiredProgram.recordcount EQ 1>
							#qCheckForExpiredProgram.programname#
							<input type="hidden" name="program" value="#qCheckForExpiredProgram.programid#">
						<cfelse>
							<select name="program" id="program" onchange="displayProgramReason(#qGetStudentInfo.programID#, this.value);" <cfif FORM.edit EQ 'no'>disabled</cfif>>
                                <option value="0">Unassigned</option>
                                <cfloop query="qProgramInfo">
                                	<option value="#programid#" <cfif qGetStudentInfo.programid EQ programid> selected </cfif>>#programname#</option>
                                </cfloop>
                            </select>
						</cfif>
					</td>
				</tr>
				<!--- reason for changing programs --->
				<tr id="trProgramHistory" bgcolor="##FFBD9D" class="displayNone">
					<td>Reason:</td>
					<td><input type="text" name="program_reason" id="program_reason" size="20"></td>
				</tr>
				<tr><td>Facilitator :</td>
					<td><cfif NOT VAL(regionassigned)>	
	                    	<div class="get_attention">No Region Assigned</div>
                        <cfelse>
							<cfif VAL(qFacilitator.recordCount)>
		                        <a href="index.cfm?curdoc=user_info&userid=#qFacilitator.userid#">#qFacilitator.firstname# #qFacilitator.lastname#</a>                        
	                        <cfelse>
                        		<div class="get_attention">Region doesn't have Fac. Assigned.</div>
							</cfif>
						</cfif>                            
					</td>
				</tr>
				<tr><td>Supervising Rep. :</td>
					<td><cfif arearepid is 0> Not Assigned	<cfelse>
						<a href="index.cfm?curdoc=user_info&userid=#qGetSuperRep.userid#">#qGetSuperRep.firstname# #qGetSuperRep.lastname#</a></cfif>
					</td>
				</tr>
				<tr><td>Placing Rep. :</td>
					<td><cfif placerepid is 0>	Not Assigned <cfelse> 
						<a href="index.cfm?curdoc=user_info&userid=#qGetPlaceRep.userid#">#qGetPlaceRep.firstname# #qGetPlaceRep.lastname#</a></cfif> 
					</td>				
				</tr>												
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
        <td width="49%" valign="top">
            <table cellpadding=2 cellspacing=0 align="center" width="100%">
				<tr bgcolor="##EAE8E8">
                	<td colspan="2"><span class="get_attention"><b>:: </b></span>Region  <cfif CLIENT.usertype LTE '4'>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('forms/stu_region_history.cfm?unqid=#uniqueid#');"> History </a> ]</font></cfif></td>
                </tr>
				<tr>
                	<td width="150px">Region :</td>
					<td>
                    	<select name="region" id="region" onChange="displayGuaranteed(this.value); displayRegionReason(#qGetStudentInfo.regionAssigned#, this.value);" <cfif FORM.edit EQ 'no'> disabled </cfif> >
							<option value="0">Select a Region</option> 
							<cfloop query="qRegions">
								<option value="#regionid#" <cfif qGetStudentInfo.regionassigned EQ regionid>selected</cfif>>#regionname#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<!--- reason for changing regions --->
				<tr id="trRegionHistory" bgcolor="##FFBD9D" class="displayNone">
					<td>Reason:</td>
					<td><input type="text" name="region_reason" id="region_reason" size="16"></td>
				</tr>
				<tr>
                	<td>Assigned on :</td>
					<td>#DateFormat(dateassigned,'mm/dd/yyyy')#</td>
				</tr>
				<tr>
                	<td>Region/State Preference :</td>
					<td>
                        <input type="radio" name="regionguar" id="regionguarYes" value="yes" <cfif regionguar EQ 'yes'> checked="checked" </cfif> onClick="displayGuaranteed();" <cfif FORM.edit EQ 'no'> disabled </cfif> > 
                        <label for="regionguarYes"> Yes </label>
                        <input type="radio" name="regionguar" id="regionguarNo" value="no" <cfif regionguar EQ 'no'> checked="checked" </cfif> onClick="displayGuaranteed();" <cfif FORM.edit EQ 'no'> disabled </cfif> > 
                        <label for="regionguarNo"> No </label>
					</td>
				</tr>
				<tr class="displayNoGuarantee">
                	<td>Regional Preference :</td>
					<td>n/a</td>
				</tr>
				<tr class="displayGuarantee"><td>Regional Preference :</td>
					<td>
                        <cfif FORM.edit EQ 'no'>
                        
                            <cfselect
                                name="rguarantee" 
                                id="rguarantee"
                                value="regionID"
                                display="regionName"
                                selected="#VAL(qGetStudentInfo.regionalGuarantee)#"
                                bindonload="yes"
                                bind="cfc:nsmg.extensions.components.region.getRegionGuaranteeRemote({region})"
                                disabled /> 
						
                        <cfelse>

                            <cfselect
                                name="rguarantee" 
                                id="rguarantee"
                                value="regionID"
                                display="regionName"
                                selected="#VAL(qGetStudentInfo.regionalGuarantee)#"
                                bindonload="yes"
                                bind="cfc:nsmg.extensions.components.region.getRegionGuaranteeRemote({region})" /> 
                        
                        </cfif>					
					</td>
				</tr>
				<tr class="displayNoGuarantee">
                	<td>State Guaranteed :</td>
					<td>n/a</td>
				</tr>
				<tr class="displayGuarantee">
                	<td>State Guaranteed :</td>
					<td>
                    	<select name="state_guarantee" id="state_guarantee" <cfif FORM.edit EQ 'no'> disabled </cfif> > <!---  onChange="FeeWaived(#jan_app#);" --->
                            <option value="0">--- Select a State ---</option>
                            <cfloop query="qStates">
                                <option value="#id#" <cfif qGetStudentInfo.state_guarantee eq id>selected</cfif>>#statename#</option>
                            </cfloop>
						</select>
					</td>
				</tr>
                <!----
				<cfif qStudentInfo.studentID neq 28304>
					<tr id="nfee_waived">
						<td width="140px">Guarantee Fee Waived</td>
						<td>n/a</td>
					</tr>
					<tr id="fee_waived"><td >Guarantee Fee Waived</td>
						<td width="140px">
							<input type="radio" name="jan_app" value=0 onClick="FeeWaived2();" <cfif jan_app EQ 0>checked</cfif> <cfif FORM.edit EQ 'no' OR jan_app NEQ '2'>disabled</cfif> >no 
							<input type="radio" name="jan_app"  value=1 onClick="FeeWaived2();" <cfif jan_app EQ 1>checked</cfif> <cfif FORM.edit EQ 'no' OR jan_app NEQ '2'>disabled</cfif> >yes
						</td>
					</tr>
				</cfif>
				---->
			</table>	
		</td>	
	</tr>
</table>

<br />

<!--- PRE AYP - INSURANCE --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Pre-AYP / Private School</td></tr>
				<tr>
					<td><cfif scholarship EQ 0><input type="checkbox" name="scholarship" value="0" <cfif FORM.edit EQ 'no'>disabled</cfif>><cfelse><input type="checkbox" name="scholarship" value="1" checked <cfif FORM.edit EQ 'no'>disabled</cfif>></cfif></td>
					<td>Participant of Scholarship Program</td>
				</tr>										
				<tr>
					<td width="10"><cfif privateschool EQ 0><input type="checkbox" value="0" name="privateschool_check" <cfif FORM.edit EQ 'no'>disabled</cfif>><cfelse><input type="checkbox" name="privateschool_check" value="1" checked <cfif FORM.edit EQ 'no'>disabled</cfif>></cfif></td>
					<td>Accepts Private HS: &nbsp; 
						<select name="privateschool" <cfif FORM.edit EQ 'no'>disabled</cfif>>
						<option value="0"></option>
						<cfloop query="qPrivateSchools">
						<option value="#privateschoolid#" <cfif qGetStudentInfo.privateschool EQ privateschoolid> selected </cfif> >#privateschoolprice#</option>
						</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td><cfif iffschool EQ 0><input type="checkbox" name="iff_check" value="0" <cfif FORM.edit EQ 'no'>disabled</cfif>> <cfelse>	<input type="checkbox" name="iff_check" value="1" checked <cfif FORM.edit EQ 'no'>disabled</cfif>>	</cfif></td>
					<td>Accepts IFF School: &nbsp;
						<select name="iffschool" <cfif FORM.edit EQ 'no'>disabled</cfif>>
						<option value="0"></option ><cfif FORM.edit EQ 'no'>disabled</cfif>>
						<cfloop query="qIffSchools">
						<option value="#iffid#" <cfif qGetStudentInfo.iffschool EQ iffid> selected </cfif> >#name#</option>
						</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td><cfif aypenglish EQ 0><input type="checkbox" name="english_check" value="0" <cfif FORM.edit EQ 'no'>disabled</cfif>>	<cfelse> <input type="checkbox" name="english_check" value="1" checked <cfif FORM.edit EQ 'no'>disabled</cfif>> </cfif> </td>
					<td>Pre-AYP English Camp: &nbsp; &nbsp;
						<select name="ayp_englsh" <cfif FORM.edit EQ 'no'>disabled</cfif>>
						<option value="0"></option>
						<cfloop query="qAYPCamps">
						<cfif camptype EQ "english"><option value="#campid#" <cfif qGetStudentInfo.aypenglish EQ campid> selected </cfif>>#name#</option></cfif>
						</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td><cfif ayporientation EQ 0><input type="checkbox" name="orientation_check" value="0" <cfif FORM.edit EQ 'no'>disabled</cfif>>	<cfelse><input type="checkbox" name="orientation_check" value="1" checked <cfif FORM.edit EQ 'no'>disabled</cfif>>	</cfif></td>
					<td>Pre-AYP Orientation Camp:  &nbsp;
					    <select name="ayp_orientation" <cfif FORM.edit EQ 'no'>disabled</cfif>>
						<option value="0"></option>
						<cfloop query="qAYPCamps">
						<cfif camptype is "orientation"><option value="#campid#" <cfif qGetStudentInfo.ayporientation EQ campid> selected </cfif>>#name#</option></cfif>
						</cfloop>
						</select>
					</td>
				</tr>
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Insurance</td></tr>
				<tr>
					<td width="10"><cfif qIntAgent.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" value="0" disabled><cfelse><input type="checkbox" name="insurance_check" value="1" checked disabled></cfif></td>
					<td align="left" colspan="2">
						<cfif qIntAgent.insurance_typeid EQ '0'> 
                        	<font color="FF0000">Intl. Rep. Insurance Information is missing</font>
						<cfelseif qIntAgent.insurance_typeid EQ 1> 
                        	Does not take Insurance Provided by #qCompanyShort.companyshort#
						<cfelse> 
                        	Takes Insurance Provided by #qCompanyShort.companyshort# 
						</cfif>
					</td>
				</tr>
				<tr>
					<td><cfif qIntAgent.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" value="0" disabled><cfelse><input type="checkbox" name="insurance_check" value="1" checked disabled></cfif></td>
					<td>Policy Type :</td>
					<td><cfif qIntAgent.insurance_typeid EQ '0'>
							<font color="FF0000">Missing Policy Type</font>
						<cfelseif qIntAgent.insurance_typeid EQ 1> 
                        	n/a
						<cfelse> 
                        	#qIntAgent.type#	
						</cfif>		
					</td>
				</tr>
                <tr>
                    <td></td> 	
                    <Td>Policy No.</Td>
                    <Td>#qInsPolicy.policycode#</Td>
                </tr>
				<!--- Insurance Information --->
                <tr>
					<td>
                    	<input type="checkbox" name="insured_date" value="1" <Cfif qInsuranceHistory.recordCount> checked </cfif> disabled>
                    </td>
					<td>Insured on :</td>
					<td>
						<cfif qIntAgent.insurance_typeid EQ 1>
                            n/a
                        <cfelseif qInsuranceHistory.recordCount>
                            #DateFormat(qInsuranceHistory.date, 'mm/dd/yyyy')# &nbsp; - &nbsp; <a href="http://www.esecutive.com/MyInsurance/" target="_blank">[ Print Card ]</a><br />
                        <cfelse>
                            not insured yet.
                        </cfif>
					</td>
				</tr>
                <cfloop query="qInsuranceHistory">
                    <tr>
                        <td>&nbsp;</td>
                        <td>#qInsuranceHistory.type#</td>
                        <td>
                            From #DateFormat(qInsuranceHistory.startDate, 'mm/dd/yyyy')# to #DateFormat(qInsuranceHistory.endDate, 'mm/dd/yyyy')# 
                        </td>
                    </tr>
                </cfloop>
                <!--- Cancelation --->
                <tr>
                    <td>
                        <input type="checkbox" name="insurance_Cancel" value="1" <cfif qInsuranceCancelation.recordCount> checked </cfif> disabled>
                    </td>
                    <td>Canceled on :</td>
                    <td>                    	
                        #DateFormat(qInsuranceCancelation.date, 'mm/dd/yyyy')#
                    </td>
                </tr>
			</table>
		</td>	
	</tr>
</table>

<br />


<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<!--- Direct Placement --->
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Direct Placement</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td>Direct Placement &nbsp; 
						<cfif direct_placement EQ '0'><input type="radio" name="direct_placement" value="0" checked="yes" <cfif FORM.edit EQ 'no'>disabled</cfif>>No<cfelse><input type="radio" name="direct_placement" value="0" <cfif FORM.edit EQ 'no'>disabled</cfif>>No</cfif> &nbsp; 
						<cfif direct_placement EQ 1><input type="radio" name="direct_placement" value="1" checked="yes" <cfif FORM.edit EQ 'no'>disabled</cfif>>Yes<cfelse><input type="radio" name="direct_placement" value="1" <cfif FORM.edit EQ 'no'>disabled</cfif>>Yes</cfif>													
					</td>
				</tr>
			</table>	
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<!--- Cancelation --->
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Cancelation</td></tr>
				<tr>
					<td width="10"><Cfif NOT LEN(cancelDate)> <input type="checkbox" name="student_cancel" value="0" OnClick="PopulateCancelBox()" <cfif FORM.edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="student_cancel" value="1" OnClick="PopulateCancelBox();" checked <cfif FORM.edit EQ 'no'>disabled</cfif> > </cfif></td>
					<td colspan="2">Student Cancelled  &nbsp; &nbsp; &nbsp; &nbsp; Date: &nbsp; <input type="text" name="date_canceled" size=8 value="#DateFormat(canceldate, 'mm/dd/yyyy')#" <cfif FORM.edit EQ 'no'>readonly</cfif>></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Reason:</td>
					<!--<td><input type="text" name="cancelreason" size="30" value="#cancelreason#" <cfif FORM.edit EQ 'no'>readonly</cfif>></td>-->
					<td><select name="cancelreason" <cfif FORM.edit EQ 'no'>disabled</cfif>>
						<option value="" <cfif cancelreason EQ ''>selected</cfif>></option>
						<option value="Cancelation" <cfif cancelreason EQ 'Cancelation'>selected</cfif>>Cancelation</option>
						<option value="Withdrawl" <cfif cancelreason EQ 'Withdrawl'>selected</cfif>>Withdrawl</option>
						<option value="Termination" <cfif cancelreason EQ 'Termination'>selected</cfif>>Termination</option>
						<option value="Visa Denial" <cfif cancelreason EQ 'Visa Denial'>selected</cfif>>Visa Denial</option>
						</select></td> 
				</tr>
			</table>	
		</td>	
	</tr>
</table>

<br />


<!--- FORM DS 2019 / LETTERS --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	

	<tr>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>DS 2019 Form <cfif CLIENT.usertype LTE '4'>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('sevis/student_history.cfm?unqid=#uniqueid#');">History</a> ]</font></cfif> </td></tr>				
				<tr>		
					<td><Cfif verification_received EQ ''><input type="checkbox" name="verification_box" value="0" onClick="PopulateDS2019Box()" <cfif FORM.edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="verification_box" value="1" onClick="PopulateDS2019Box()" checked <cfif FORM.edit EQ 'no'>disabled</cfif>> </cfif>
					<td>DS 2019 Verification Received &nbsp; &nbsp; Date: &nbsp;<input type="text" name="verification_form" size=8 value="#DateFormat(verification_received, 'mm/dd/yyyy')#" <cfif FORM.edit EQ 'no'>readonly</cfif>></td>
				</tr>
				<tr>
					<td width="10"><cfif VAL(qIntAgent.accepts_sevis_fee)><input type="checkbox" name="accepts_sevis_fee" value="1" checked disabled><cfelse><input type="checkbox" name="accepts_sevis_fee" value="0" disabled></cfif></td>
					<td><cfif qIntAgent.accepts_sevis_fee EQ ''>
							<font color="FF0000">SEVIS Fee Information is missing</font>
						<cfelseif qIntAgent.accepts_sevis_fee EQ '0'>
							Intl. Agent does not accept SEVIS Fee
						<cfelseif qIntAgent.accepts_sevis_fee EQ 1>
							Intl. Agent Accepts SEVIS Fee
						</cfif>
					</td>
				</tr>
				<tr><td>&nbsp;</td>	
					<td>DS2019 no.: &nbsp;<input type="text" name="ds2019_no" size=12 value="#ds2019_no#" maxlength="12" <cfif FORM.edit EQ 'no'>readonly</cfif>> &nbsp; 
						Batch ID: #sevis_batchid#</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Fee Status: &nbsp; <cfif qIntAgent.accepts_sevis_fee NEQ 1 AND sevis_fee_paid_date EQ ''>n/a<cfelseif sevis_fee_paid_date NEQ ''>Paid  on: &nbsp; #DateFormat(sevis_fee_paid_date, 'mm/dd/yyyy')# <cfelse> Unpaid </cfif></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Sevis Status: &nbsp; <cfif qSevisStatus.recordcount> Active since #DateFormat(qSevisStatus.datecreated, 'mm/dd/yyyy')# <cfelseif sevis_batchid NEQ '0'> Initial <cfelse> n/a </cfif></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Start Date: &nbsp; <cfif qGetSevisDates.start_date NEQ ''>#DateFormat(qGetSevisDates.start_date, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>End Date: &nbsp; <cfif qGetSevisDates.end_date NEQ ''>#DateFormat(qGetSevisDates.end_date, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
				</tr>				
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="2"><span class="get_attention"><b>:: </b></span>Letters &nbsp; &nbsp; [  <font size=-3> <a href="javascript:OpenLetter('reports/printing_tips.cfm');">Printing Tips</a></font> ]</td></tr>
				<!--- OFFICE USERS --->
				<cfif CLIENT.usertype LTE '4'>
				<tr>
					<td>: : <a href="javascript:OpenLetter('reports/acceptance_letter.cfm');">Acceptance</a></td>
                  
					<td>: : <a href="javascript:OpenLetter('reports/PlacementInfoSheet.cfm?studentID=#uniqueid#');">Placement</a>
                  </td>
                   
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
                <tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/labels_student_idcards.cfm?studentid=#studentid#');">Student ID Card</a>
						<cfif CLIENT.usertype LTE '4'> &nbsp; <a href="javascript:OpenLetter('reports/emailStudentIDCard.cfm?studentID=#studentID#');">
                   		<img src="pics/email.gif" border="0" alt="Email Student ID Card"></a></cfif></td>
					<td width="50%">: : <a href="javascript:OpenLetter('forms/singlePersonPlacementAuth.cfm?studentid=#studentid#');">Single Person Auth.</a>
						<cfif CLIENT.usertype LTE '4'> &nbsp; <a href="javascript:OpenLetter('reports/emailSinglePlaceAuth.cfm?studentID=#studentID#');">
                        <img src="pics/email.gif" border="0" alt="Email Single Place Auth"></a></cfif></td>
				</tr>				
			</table>
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="2"><span class="get_attention"><b>:: </b></span>Double Placement Letters</td></tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_host_family.cfm');">Family & School</a></td>
					<td width="50%">
						: : <a href="javascript:OpenLetter('reports/double_placement_nat_fam.cfm');">Natural Family</a>
						<cfif CLIENT.usertype LTE '4'> &nbsp; <a href="javascript:OpenLetter('reports/email_dbl_place_nat_fam.cfm?studentID=#qGetStudentInfo.studentID#');"><img src="pics/email.gif" border="0" alt="Email Nat. Family Letter"></a></cfif>
					</td>
				</tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_students.cfm');">Students</a></td>
					<td width="50%"></td>
				</tr>
				</cfif>
			
			<!--- FIELD USERS --->
			<cfif CLIENT.usertype GTE '5' AND CLIENT.usertype LTE '7'>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/PlacementInfoSheet.cfm?studentID=#uniqueid#&profileType=web');">Placement</a></td>
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
				<tr bgcolor="##EAE8E8"><td colspan="2"><span class="get_attention"><b>:: </b></span>Double Placement Letters</td></tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_host_family.cfm');">Family and School</a></td>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_students.cfm');">Students</a></td>
				</tr>
				</cfif>
			</table>	
		</td>	
	</tr>
</table>

<br />


</div>

<!--- UPDATE BUTTON --->
<cfif FORM.edit NEQ 'no'>
    <table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
    <tr><td align="center">
        <input name="Submit" type="image" src="pics/update.gif" alt="Update Profile"  border=0></input>
    </td></tr>
    </table>
</cfif>

</cfform>
		
<!---- EDIT BUTTON - OFFICE USERS ---->
<cfif CLIENT.usertype LTE '4' AND FORM.edit EQ 'no'>
    <table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
    <tr><td align="center">
        <form action="?curdoc=student_info&studentID=#qGetStudentInfo.studentID#" method="post">&nbsp;
            <input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0  
            <cfif companyid is not CLIENT.companyid> disabled </cfif> >
        </form>
    </td></tr>
    </table>
</cfif> 

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>

</body>
</html>