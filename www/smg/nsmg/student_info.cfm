<!--- Kill extra output --->
<cfsilent>

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
		qStudentInfo = AppCFC.STUDENT.getStudentByID(studentID=studentID); 

		// Get Super Rep
		qGetSuperRep = APPCFC.USER.getUserByID(userID=VAL(qStudentInfo.arearepid));

		// Get Place Rep
		qGetPlaceRep = APPCFC.USER.getUserByID(userID=VAL(qStudentInfo.placerepid));

		// Get Super Rep
		qEnteredBy = APPCFC.USER.getUserByID(userID=VAL(qStudentInfo.entered_by));
		
		// Get Student Company Assigned
		qAssignedCompany = AppCFC.COMPANY.getCompanies(companyID=qStudentInfo.companyID);

		// Get Student Region Assigned
		qRegionAssigned = AppCFC.REGION.getRegions(regionID=qStudentInfo.regionAssigned);
		
		// Insurance Information
		qInsuranceHistory = AppCFC.INSURANCE.getInsuranceHistoryByStudent(studentID=qStudentInfo.studentID, type='N,R,EX');

		// Insurance Information
		qInsuranceCancelation = AppCFC.INSURANCE.getInsuranceHistoryByStudent(studentID=qStudentInfo.studentID, type='X');
		
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
		virtualDirectory = "#AppPath.onlineApp.virtualFolder##qStudentInfo.studentID#";
		
		// Get Facilitator for this Region
		qFacilitator = APPCFC.USER.getUserByID(userID=VAL(qRegionAssigned.regionfacilitator));
	</cfscript>
	
    <!--- Student Picture --->
	<cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#qStudentInfo.studentID#.*">

    <!----International Rep---->
    <cfquery name="qIntAgent" datasource="#application.dsn#">
        SELECT 
        	u.businessname, 
            u.firstname, 
            u.lastname, 
            u.userid, 
            u.accepts_sevis_fee, 
            u.insurance_typeid, insu.type
        FROM 
        	smg_users u
        LEFT JOIN 
        	smg_insurance_type insu ON insu.insutypeid = u.insurance_typeid
        WHERE 
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qStudentInfo.intrep)#">
    </cfquery>
    
    <cfquery name="qProgramInfo" datasource="#application.dsn#">
        SELECT 
        	programname, 
            programid, 
            enddate
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
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qStudentInfo.studentID)#">
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
        	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qStudentInfo.studentID)#">
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
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qStudentInfo.studentID)#">
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
        	fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qStudentInfo.studentID)#">
    </cfquery>
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>Student's Information</title>
	
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
		   if (document.StudentInfo.rguarantee.options[i].value == <cfoutput>#qStudentInfo.regionalguarantee#</cfoutput>){
			 Counter++;
		   }
	    }
	    if (Counter == 1){		
		 document.StudentInfo.rguarantee.value = <cfoutput>#qStudentInfo.regionalguarantee#</cfoutput>;
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

<cfoutput>

<!--- student does not exist --->
<cfif NOT VAL(qStudentInfo.recordcount)>
	The student ID you are looking for, #studentID#, was not found. This could be for a number of reasons.<br><br>
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
	<cflocation url="index.cfm?curdoc=student_profile&uniqueid=#qStudentInfo.uniqueid#" addtoken="no">
</cfif>

<!--- Block if users try to change the student id in the address bar --->
<cfif CLIENT.usertype GT 4> 
				
	<cfif qStudentInfo.regionassigned NEQ CLIENT.regionid>
    	<br>
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

<cfoutput query="qStudentInfo">

<form name="StudentInfo" method="post" action="querys/update_student_info.cfm" onSubmit="return CheckGuarantee(#qStudentInfo.regionassigned#, #qStudentInfo.programid#);">
<input type="hidden" name="studentID" value="#qStudentInfo.studentID#">

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
                                        <cfimage source="#myImage#" action="writeToBrowser" border="0" width="135px"><br>
                                       
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
										<cfif CLIENT.usertype LTE 4>
                                        	<a href="index.cfm?curdoc=forms/edit_student_app_1">edit</a> &middot; 
                                        </cfif> 
                                    	<a href='student_profile.cfm?uniqueid=#uniqueid#'>profile</a> &middot;
										<cfif CLIENT.userType LTE 5>  <!--- Only Office & Managers --->
	                                        <a href="javascript:SendEmail('student_profile_email.cfm?uniqueid=#uniqueid#', 300, 400);" title="Email Student Profile and Letters"><img src="pics/email.gif" border="0" alt="Email Student Profile and Letters"> email profile </a> &middot;
                                        </cfif>
                                        <a href='student_profile_pdf.cfm?studentID=#uniqueid#'> <img src="pics/pdficon_small.gif" border=0></a>
                                    ]
                                    </span></font>
                                </td>
                            </tr>
			 				<tr><td align="center" colspan="2"><cfif dob EQ ''>n/a<cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old #sex# </cfif></td></tr> 
							<tr><td width="80">Intl. Rep. : </td>
								<td><select name="intrep" <cfif FORM.edit EQ 'no'>disabled</cfif> >
                                        <option value="0" selected></option>		
                                        <cfloop query="qIntRepsList">
                                        	<option value="#qIntRepsList.userid#" <cfif qIntRepsList.userid EQ qStudentInfo.intrep> selected </cfif> >
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
                                                <br>*You will need to re-assign regions after updating.
											</cfif>
										</tr>
                                        </cfif>
                                        
										<tr><cfif canceldate EQ ''>
											<td width="80" align="right">				
												<cfif VAL(active)>
													<input name="active" type="checkbox"  value="1" checked <cfif FORM.edit EQ 'no'>disabled</cfif>>
												<cfelse>
													<input name="active" type="checkbox" value="0"  <cfif FORM.edit EQ 'no'>disabled</cfif>>
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
											<br><a href="javascript:OpenMediumW('student_app/section4/page22print.cfm?unqid=#uniqueid#');"><img src="pics/attached-files.gif" border="0"></a>	
											<br><a href="javascript:SendEmail('student_app/email_form.cfm?unqid=#uniqueid#', 400, 450);"><img src="pics/send-email.gif" border="0"></a>	
											</td>
										</tr>
										<cfelse>
										<tr><td align="right">&nbsp;</td></tr>
										</cfif>														
									</table>								
								</td>
							</tr>
							<tr>
                          <td align="right"><a href="" onClick="javascript: win=window.open('forms/phone_call.cfm?studentID=#qStudentInfo.studentID#', 'PhoneCall', 'height=600, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><strong>Phone Call:</strong></a></td>
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
		<!--- check virtual folder files --->
		<cfdirectory name="virtual_folder" directory="#virtualDirectory#" filter="*.*">
		<div id="subMenuNav"> 
			<div id="subMenuLinks">  
				<!----All Users---->
				<a href="javascript:OpenPlaceMan('forms/place_menu.cfm?studentID=#qStudentInfo.studentID#' , 'Settings', 'height=400, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes');">Placement Management</a>
	
				<!--- OFFICE USERS ONLY --->
				<cfif CLIENT.usertype LTE 4> 
					<!---- <a href="" onClick="javascript: win=window.open('insurance/insurance_management.cfm?studentID=#qStudentInfo.studentID#', 'Settings', 'height=400, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Insurance Management</a> ---->	
					<a href="" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentID=#qStudentInfo.studentID#', 'Settings', 'height=400, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Rep. Payments</a> 					
					<a href="" onClick="javascript: win=window.open('forms/missing_documents.cfm', 'Settings', 'height=450, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Missing Documents</A>
					<a href="" onClick="javascript: win=window.open('forms/notes.cfm', 'Settings', 'height=420, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><cfif LEN(qStudentInfo.notes)><img src="pics/green_check.gif" border="0">&nbsp;</cfif>Notes</a> 	
                    <a href="" onClick="javascript: win=window.open('forms/ssp.cfm?studentid=#client.studentid#', 'Settings', 'height=450, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Student Services Project</a>	
				</cfif> 
				<!--- OFFICE - MANAGERS ONLY --->
				<cfif CLIENT.usertype LTE 5> 
					<a href="" onClick="javascript: win=window.open('forms/profile_adjustments.cfm', 'Settings', 'height=500, width=663, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Profile Adjustments</a>		
                </cfif> 				
				<!----All Users---->				
				<a href="" onClick="javascript: win=window.open('virtualfolder/list_vfolder.cfm?unqid=#qStudentInfo.uniqueid#', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><cfif VAL(virtual_folder.recordcount)><img src="pics/green_check.gif" border="0">&nbsp;</cfif>Virtual Folder</a>		
				<a href="" onClick="javascript: win=window.open('forms/received_progress_reports.cfm?stuid=#qStudentInfo.studentID#', 'Reports', 'height=450, width=610, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Progress Reports</A>  
				<a href="" onClick="javascript: win=window.open('forms/flight_info.cfm', 'Settings', 'height=600, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Flight Information</A>
				<a href="" onClick="javascript: win=window.open('forms/double_place_docs.cfm', 'Settings', 'height=380, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Double Place Docs</a>
                
                <a href="" onClick="javascript: win=window.open('tours/trips.cfm', 'Settings', 'height=450, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Student Trips</a>
				<!---- GLOBAL OR COMPLIANCE USERS ---->
				<cfif CLIENT.usertype EQ 1 OR qUserCompliance.compliance EQ 1>
				<a href="" onClick="javascript: win=window.open('compliance/student_checklist.cfm?unqid=#qStudentInfo.uniqueid#', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Compliance</a>
				</cfif>
			</div>
		</div>
		</td>
	</tr>
</table><br>
<cfif CLIENT.companyid neq qAssignedCompany.companyid> 
	<table width=770 bgcolor="##CC3300" align="center">
		<tr>
		<td>
			<img src="pics/error_exclamation.gif"></td><td><font color="white">Student is assigned to a different company then you are accessing the record through. <br> Please change companies to #qAssignedCompany.team_id# to prevent errors in displayed and recorded information.</font>
		</td>
	</table>
		</cfif>
<!--- PROGRAM / REGION --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding=2 cellspacing=0 align="center" width="100%">
				<tr bgcolor="EAE8E8">
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
							<select name="program" <cfif FORM.edit EQ 'no'>disabled</cfif>>
							<option value="0">Unassigned</option>
							<cfloop query="qProgramInfo">
							<cfif qStudentInfo.programid EQ programid><option value="#programid#" selected>#programname#</option><cfelse>
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
				<tr bgcolor="EAE8E8"><td colspan="2"><span class="get_attention"><b>:: </b></span>Region  <cfif CLIENT.usertype LTE '4'>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('forms/stu_region_history.cfm?unqid=#uniqueid#');"> History </a> ]</font></cfif></td></tr>
				<tr>
                	<td width="140px">Region :</td>
					<td><select name="region" onChange="loadOptions('rguarantee'); Guaranteed();" <cfif FORM.edit EQ 'no'> disabled </cfif> >
							<option value="0">Select a Region</option> 
							<option value="0">----------------</option>
							<cfloop query="qRegions">
							<option value="#regionid#" <cfif qStudentInfo.regionassigned EQ regionid>selected</cfif>>#regionname#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<!--- reason for changing regions --->
				<tr id="region_history" bgcolor="FFBD9D">
					<td>Reason:</td>
					<td><input type="text" size="16" name="region_reason"></td>
				</tr>
				<tr>
                	<td>Assigned on :</td>
					<td>#DateFormat(dateassigned,'mm/dd/yyyy')#</td>
				</tr>
				<tr>
                	<td>Region or State Guaranteed :</td>
					<td>
						<cfif regionguar EQ 'yes'>
                        	<input type="radio" name="regionguar" value="yes" checked onClick="Guaranteed();" <cfif FORM.edit EQ 'no'> disabled </cfif> >Yes <input type="radio" name="regionguar" value="no"  onClick="Guaranteed();" <cfif FORM.edit EQ 'no'> disabled </cfif> >No 
						<cfelse>
                        	<input type="radio" name="regionguar" value="yes"  onClick="Guaranteed();" <cfif FORM.edit EQ 'no'> disabled </cfif>  >Yes <input type="radio" name="regionguar" value="no" checked  onClick="Guaranteed();" <cfif FORM.edit EQ 'no'> disabled </cfif> >No
                        </cfif>
					</td>
				</tr>
				<tr id="nreg_guarantee">
                	<td width="140px">Regional Guaranteed :</td>
					<td>n/a</td>
				</tr>
				<tr id="reg_guarantee"><td>Regional Guaranteed :</td>
					<td width="140px"><select name="rguarantee" <cfif FORM.edit EQ 'no'> disabled </cfif> >
							<!--// add a bunch of blank option arrays to compensate for NS4 DOM display bug //-->
							<option> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </option>
							<option></option><option></option><option></option><option></option><option></option><option></option>
							<option></option><option></option><option></option><option></option><option></option><option></option>
							<option></option><option></option><option></option><option></option><option></option><option></option>
						</select>
					</td>
				</tr>
				<tr id="nsta_guarantee">
                	<td width="140px">State Guaranteed :</td>
					<td>n/a</td>
				</tr>
				<tr id="sta_guarantee">
                	<td width="140px">State Guaranteed :</td>
					<td><select name="state_guarantee" onChange="FeeWaived(#jan_app#);" <cfif FORM.edit EQ 'no'> disabled </cfif> >
						<option value="0">Select a State</option>
						<option value="0">--------------</option>
						<cfloop query="qStates">
						<option value="#id#" <cfif qStudentInfo.state_guarantee eq id>selected</cfif>>#statename#</option>
						</cfloop>
						</select>
					</td>
				</tr>
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
			</table>	
		</td>	
	</tr>
</table><br>

<!--- PRE AYP - INSURANCE --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Pre-AYP / Private School</td></tr>
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
						<option value="#privateschoolid#" <cfif qStudentInfo.privateschool EQ privateschoolid> selected </cfif> >#privateschoolprice#</option>
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
						<option value="#iffid#" <cfif qStudentInfo.iffschool EQ iffid> selected </cfif> >#name#</option>
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
						<cfif camptype EQ "english"><option value="#campid#" <cfif qStudentInfo.aypenglish EQ campid> selected </cfif>>#name#</option></cfif>
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
						<cfif camptype is "orientation"><option value="#campid#" <cfif qStudentInfo.ayporientation EQ campid> selected </cfif>>#name#</option></cfif>
						</cfloop>
						</select>
					</td>
				</tr>
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Insurance</td></tr>
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
						<cfelseif qIntAgent.insurance_typeid EQ 1> n/a
						<cfelse> #qIntAgent.type#	</cfif>		
					</td>
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
                            #DateFormat(qInsuranceHistory.date, 'mm/dd/yyyy')# <br />
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
</table><br>

<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<!--- Direct Placement --->
			<table cellpadding="2" width="100%">
				<tr bgcolor="EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Direct Placement</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td>Direct Placement &nbsp; 
						<cfif direct_placement EQ '0'><input type="radio" name="direct_placement" value="0" checked="yes" <cfif FORM.edit EQ 'no'>disabled</cfif>>No<cfelse><input type="radio" name="direct_placement" value="0" <cfif FORM.edit EQ 'no'>disabled</cfif>>No</cfif> &nbsp; 
						<cfif direct_placement EQ 1><input type="radio" name="direct_placement" value="1" checked="yes" <cfif FORM.edit EQ 'no'>disabled</cfif>>Yes<cfelse><input type="radio" name="direct_placement" value="1" <cfif FORM.edit EQ 'no'>disabled</cfif>>Yes</cfif>													
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Nature of Direct Placement &nbsp; 
						<input type="text" name="direct_place_nature" size="20" value="#direct_place_nature#" <cfif FORM.edit EQ 'no'>readonly</cfif>>
					</td>
				</tr>	
			</table>	
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<!--- Cancelation --->
			<table cellpadding="2" width="100%">
				<tr bgcolor="EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Cancelation</td></tr>
				<tr>
					<td width="10"><Cfif canceldate is ''> <input type="checkbox" name="student_cancel" value="0" OnClick="PopulateCancelBox()" <cfif FORM.edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="student_cancel" value="1" OnClick="PopulateCancelBox();" checked <cfif FORM.edit EQ 'no'>disabled</cfif> > </cfif></td>
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
</table><br>

<!--- FORM DS 2019 / LETTERS --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	

	<tr>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>DS 2019 Form <cfif CLIENT.usertype LTE '4'>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('sevis/student_history.cfm?unqid=#uniqueid#');">History</a> ]</font></cfif> </td></tr>				
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
				<tr bgcolor="EAE8E8"><td colspan="2"><span class="get_attention"><b>:: </b></span>Letters &nbsp; &nbsp; [  <font size=-3> <a href="javascript:OpenLetter('reports/printing_tips.cfm');">Printing Tips</a></font> ]</td></tr>
		<!--- OFFICE USERS --->
				<cfif CLIENT.usertype LTE '4'>
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
				<tr bgcolor="EAE8E8"><td colspan="2"><span class="get_attention"><b>:: </b></span>Double Placement Letters</td></tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_host_family.cfm');">Family & School</a></td>
					<td width="50%">
						: : <a href="javascript:OpenLetter('reports/double_placement_nat_fam.cfm');">Natural Family</a>
						<cfif CLIENT.usertype LTE '4'> &nbsp; <a href="javascript:OpenLetter('reports/email_dbl_place_nat_fam.cfm?studentID=#qStudentInfo.studentID#');"><img src="pics/email.gif" border="0" alt="Email Nat. Family Letter"></a></cfif>
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
				<tr bgcolor="EAE8E8"><td colspan="2"><span class="get_attention"><b>:: </b></span>Double Placement Letters</td></tr>
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
<cfif FORM.edit NEQ 'no'>
<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
<tr><td align="center">
	<input name="Submit" type="image" src="pics/update.gif" alt="Update Profile"  border=0></input>
</td></tr>
</table>
</cfif>
</form>
		
<!---- EDIT BUTTON - OFFICE USERS ---->
<cfif CLIENT.usertype LTE '4' AND FORM.edit EQ 'no'>
<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
<tr><td align="center">
	<form action="?curdoc=student_info&studentID=#qStudentInfo.studentID#" method="post">&nbsp;
		<input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0  
		<cfif companyid is not CLIENT.companyid> disabled </cfif> >
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