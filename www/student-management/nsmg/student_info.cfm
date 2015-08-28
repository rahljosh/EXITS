<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<!--- Param variables --->
    <cfparam name="FORM.edit" default="no">
    
    <cfparam name="CLIENT.company_submitting" default="0">
    
    <cfparam name="studentID" default="0">
    <cfset session.studentlist = ''>
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
		
		vAllowedDivisionChangeList = "8731,8743,12431,16718,12389,17993,16552,17972,18061";  // Bill, Bob, Gary, Tal and Merri, Jan McInvale, Steve S, john	
		
		// Get Student Information 
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=VAL(studentID));
		
		// Get Placement History List
		qGetPlacementHistoryList = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID);
		
		// Get Placement History By ID - First record of qGetPlacementHistoryList is the current record
		if ( VAL(qGetPlacementHistoryList.isActive) ) {
			// Get Current History
			qGetPlacementHistoryByID = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=qGetStudentInfo.studentID, historyID=qGetPlacementHistoryList.historyID);
		} else {
			// Student is unplaced 
			qGetPlacementHistoryByID = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=qGetStudentInfo.studentID, historyID=0);
		};

		// Get Super Rep
		qGetSuperRep = APPLICATION.CFC.USER.getUserByID(userID=VAL(qGetStudentInfo.arearepid));

		// Get Place Rep
		qGetPlaceRep = APPLICATION.CFC.USER.getUserByID(userID=VAL(qGetStudentInfo.placerepid));

		// Get Super Rep
		qEnteredBy = APPLICATION.CFC.USER.getUserByID(userID=VAL(qGetStudentInfo.entered_by));
		
		// Get 2nd Visit Rep
		qGet2ndVisitRep = APPLICATION.CFC.USER.getUserByID(userID=VAL(qGetStudentInfo.secondVisitRepID));
		
		// Get Student Company Assigned
		qAssignedCompany = APPLICATION.CFC.COMPANY.getCompanyByID(companyID=qGetStudentInfo.companyID);

		// Get Student Region Assigned
		qRegionAssigned = APPLICATION.CFC.REGION.getRegions(regionID=qGetStudentInfo.regionAssigned);
		
		// Insurance Information
		qInsuranceHistory = APPLICATION.CFC.INSURANCE.getInsuranceHistoryByStudent(studentID=qGetStudentInfo.studentID, type='N,R,EX,X');
		
		// Get Private Schools Prices
		qPrivateSchools = APPLICATION.CFC.SCHOOL.getPrivateSchools();
		
		// Get IFF Schools
		qIFFSchools = APPLICATION.CFC.SCHOOL.getIFFSchools();
		
		// Get AYP English Camps
		qAYPEnglishCamps = APPLICATION.CFC.SCHOOL.getAYPCamps(campType='english');

		// Get AYP Orientation Camps
		qAYPOrientationCamps = APPLICATION.CFC.SCHOOL.getAYPCamps(campType='orientation');

		// Get Intl. Rep List
		qIntRepsList = APPLICATION.CFC.USER.getUsers(usertype=8);

		// Check User Compliance Access
		qUserCompliance = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userid);

		// Get Company Information
		qCompanyShort = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		
		// Get a list of regions for this companyID
		qRegions = APPLICATION.CFC.REGION.getRegions(companyID=CLIENT.companyID);
		
		// Get Available teams
		qAvailableTeams = APPLICATION.CFC.COMPANY.getCompanies(website=CLIENT.company_submitting);

		// Virtual Folder Directory
		virtualDirectory = "#AppPath.onlineApp.virtualFolder##qGetStudentInfo.studentID#";
		
		// Internal Virtual Folder Directory
		internalVirtualDirectory = "#AppPath.onlineApp.internalVirtualFolder##qGetStudentInfo.studentID#";
		
		// Get Facilitator for this Region
		qFacilitator = APPLICATION.CFC.USER.getUserByID(userID=VAL(qRegionAssigned.regionfacilitator));
		
		// Get Facilitator for this Region
		qStudentsCases = APPLICATION.CFC.caseMgmt.studentsCases(studentid=VAL(qGetStudentInfo.studentID));
		//Get available programs
		if ( CLIENT.companyid eq 13 OR client.companyid eq 14){
			qGetActivePrograms = APPLICATION.CFC.PROGRAM.getPrograms(companyid=client.companyid,isActive=1);
		}
		else
			{
			qGetActivePrograms = APPLICATION.CFC.PROGRAM.getPrograms(isActive=1);
		}
		
		// Set Placement Status (Unplaced / Rejected / Approved / Pending / Incomplete)
		vPlacementStatus = '';
		
		if ( 
			NOT VAL(qGetPlacementHistoryByID.hostID) 
			AND NOT VAL(qGetPlacementHistoryByID.schoolID) 
			AND NOT VAL(qGetPlacementHistoryByID.placeRepID) 
			AND NOT VAL(qGetPlacementHistoryByID.areaRepID) ) {
			
			vPlacementStatus = 'Unplaced';
		} else if ( 
			VAL(qGetPlacementHistoryByID.hostID) 
			AND VAL(qGetPlacementHistoryByID.schoolID) 
			AND VAL(qGetPlacementHistoryByID.placeRepID) 
			AND VAL(qGetPlacementHistoryByID.areaRepID) ) {			
			
			if ( qGetStudentInfo.host_fam_approved EQ 99 ) {
				// Placement Rejected
				vPlacementStatus = 'Rejected';
			} else if ( ListFind("1,2,3,4", qGetStudentInfo.host_fam_Approved) ) {
				// Placement Approved
				vPlacementStatus = 'Approved';
			} else {
				// Pending Approval
				vPlacementStatus = 'Pending';
			}
		} else {
			vPlacementStatus = 'Incomplete';
		}
	</cfscript>

	<!--- Student Picture --->
	<cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#qGetStudentInfo.studentID#.*">

	<!--- check virtual folder files --->
    <cfdirectory name="getVirtualFolder" directory="#virtualDirectory#" filter="*.*">
    
    <!--- check internal virtual folder files --->
    <cfdirectory name="getInternalVirtualFolder" directory="#internalVirtualDirectory#" filter="*.*">

    <!----International Rep---->
    <cfquery name="qGetIntlRep" datasource="#APPLICATION.DSN#">
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
    
   <!----
    <cfquery name="qGetActivePrograms" datasource="#APPLICATION.DSN#">
        SELECT 
        	programname, 
            programID, 
            enddate,
            seasonID
        FROM 
        	smg_programs
        WHERE 
			is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
        AND 
        	companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
        AND 
        	enddate > #currentDate#
        OR
        	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.programID#">
        ORDER BY
        	programname
    </cfquery>
      ---->
      
    <cfquery name="qGetSelectedProgram" dbtype="query">
        SELECT 
        	*
        FROM 
        	qGetActivePrograms
        WHERE 
			programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.programID)#">
    </cfquery>
  
    <!----Ins. Policy Code---->
    <Cfquery name="qGetInsurancePolicyInfo" datasource="#APPLICATION.DSN#">
        SELECT 
        	policycode
        FROM 
        	smg_insurance_codes
        WHERE 
        	seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetSelectedProgram.seasonID)#">
            
		<!--- Combine ISE Companies --->  
        <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISE, CLIENT.companyID)>
            AND
                companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <cfelse>
            AND
                companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        </cfif>
        
        <!--- ESI - Elite Only --->
        <cfif CLIENT.companyID EQ 14>
            AND
                insuTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="11">                           
        <cfelse>
            AND
                insuTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetIntlRep.insurance_typeID)#">                           
        </cfif>
            
    </cfquery>
    
    <!----Get Expired Student Programs---->
    <cfquery name="qCheckForExpiredProgram" datasource="#APPLICATION.DSN#">
        SELECT 
        	smg_students.studentID, 
            smg_students.programID, 
            smg_programs.programname
        FROM 
        	smg_programs 
        INNER JOIN 
        	smg_students ON smg_programs.programID = smg_students.programID
        WHERE 
        	smg_programs.enddate <= #currentDate# 
        AND 
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
    </cfquery>
        
    <cfquery name="qStates" datasource="#APPLICATION.DSN#">
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
        
    <cfquery name="qSevisStatus" datasource="#APPLICATION.DSN#">
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
    
    <cfquery name="qGetSevisHistory" datasource="#APPLICATION.DSN#">
        SELECT 
        	his.start_date, 
            his.end_date,
            his.school_name,
            his.hostID,
            host.familyLastName
        FROM 
        	smg_sevis_history his
      	LEFT OUTER JOIN
        	smg_hosts host ON host.hostID = his.hostID
        WHERE 
        	his.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
        AND
        	his.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        ORDER BY 
        	his.historyid DESC 
    </cfquery>
    
    <!----Date of last phone contact---->
    <cfquery name="qLastContact" datasource="#APPLICATION.DSN#">
        SELECT 
        	max(date) as qLastContact
        FROM 
        	smg_student_phone_call_log
        WHERE 
        	fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
    </cfquery>
    
</cfsilent>
<style type="text/css">
.alertRed{
	margin-left:auto;
	margin-right:auto;
	width:770px;
	height:55px;
	border:#666;
	background-color:#FF9797;
	-moz-border-radius: 15px;
	border-radius: 15px;
	vertical-align:center;

	
}
.alertGreen{
	margin-left:auto;
	margin-right:auto;
	width:770px;
	height:55px;
	border:#666;
	background-color:#DEEAE1;
	-moz-border-radius: 15px;
	border-radius: 15px;
	vertical-align:center;
	
}
</style>
<script type="text/javascript" src="student_info.js"></script>
	
<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {
		// call the function to hide and show certain elements according to region guarantee choice 
		displayGuaranteed();

		// JQuery Modal - Refresh Student Info page after closing placement management
		$(".jQueryModalPL").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false, 
			onClosed:function(){ window.location.reload(); }
		});	

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

	<cfif ListFind("6,7",CLIENT.userType)>
    
    	<cfset vGrantAccess = 0>
        
  		<cfif CLIENT.userType EQ 6>
        
        	<cfquery name="qGetReps" datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
                    userid
                FROM 
                    user_access_rights
                WHERE 
                    regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
                AND 
                    (
                        advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                    OR 
                        userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                    ) 
            </cfquery>
            
            <cfloop query="qGetReps">
                <cfquery name="qCheckHosts" datasource="#APPLICATION.DSN#">
                    SELECT
                        *
                    FROM
                        smg_students
                    WHERE
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.studentID#">
                    AND
                        regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
                    AND
                        ( 	
                            arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetReps.userid#">
                        OR 
                            placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                        OR
                            hostid = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        )
                </cfquery>
                <cfif VAL(qCheckHosts.recordCount)>
                    <cfset vGrantAccess = 1>
                </cfif>
            </cfloop> 
            
        <cfelseif CLIENT.userType EQ 7>
    
            <cfquery name="qCheckStudents" datasource="#APPLICATION.DSN#">
                SELECT
                    *
                FROM
                    smg_students
                WHERE
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.studentID#">
               	AND
                	regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
              	AND
                    ( 	
                        arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                    OR 
                        placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                   	OR
                    	hostid = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    )
            </cfquery>
			<cfif VAL(qCheckStudents.recordCount)>
                <cfset vGrantAccess = 1>
            </cfif>
            
        </cfif>
        
        <cfif vGrantAccess EQ 0>
        	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
                    <td background="pics/header_background.gif"><h2>Error</h2></td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
            <table border=0 cellpadding=4 cellspacing=0 width="100%" class="section">
                <tr><td align="center" valign="top">
                        <img src="pics/error_exclamation.gif" width="37" height="44"> I am sorry but you do not have the rights to see this page.
                    </td>
                </tr>
                <tr><td align="center">If you think this is a mistake please contact <cfoutput>#APPLICATION.EMAIL.support#</cfoutput></td></tr>
                <tr><td align="center">You can view your account by clicking <a href="?curdoc=user_info&userid=<cfoutput>#CLIENT.userid#</cfoutput>">here<a/>.<br /><br /></td></tr>			
            </table>
            <cfinclude template="table_footer.cfm">
            <cfabort>
        </cfif>
        	
	<cfelseif qGetStudentInfo.regionassigned NEQ CLIENT.regionid>
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

<cfform name="studentForm" method="post" action="querys/update_student_info.cfm" onSubmit="return formValidation(#qGetStudentInfo.regionassigned#, #qGetStudentInfo.programID#);">
<input type="hidden" name="studentID" value="#qGetStudentInfo.studentID#">

<div class="section"><br />


<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td valign="top" width="590">
			<cfif hostid eq 0 and NOT LEN(cancelDate)>
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
                                       
                                        <cfif APPLICATION.CFC.USER.isOfficeUser()><A href="qr_delete_picture.cfm?student=#studentPicture.name#&studentID=#studentID#">Remove Picture</a></cfif>
                                        
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
										<cfif APPLICATION.CFC.USER.isOfficeUser()>
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
							
                            <tr><td>Intl. Rep. : </td>
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
									<table width="100%" cellpadding="2">
										<tr><td>Date of Entry : </td><td>#DateFormat(dateapplication, 'mm/dd/yyyy')# </td></tr>
										<tr><td><cfif randid EQ 0>Entered by : <cfelse>Approved by : </cfif> </td><td><cfif qEnteredBy.recordcount NEQ 0>#qEnteredBy.firstname# #qEnteredBy.lastname# (###qEnteredBy.userid#)<cfelse>n/a</cfif></td></tr>										
										
										<cfif CLIENT.usertype EQ 1 OR ListFind(vAllowedDivisionChangeList, CLIENT.userid)>
                                            <tr>
                                                <td>Division:</td>
                                                <td>
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
                                              	</td>
                                            </tr>
                                        <cfelse>
                                        	<tr>
                                                <td>Division:</td>
                                                <td>#qAssignedCompany.team_id#</td>
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
											<cfif CLIENT.userType LTE 7>
												<a href="javascript:OpenApp('student_app/index.cfm?curdoc=section1&unqid=#uniqueid#&id=1');"><img src="pics/exits.jpg" border="0"></a>
											<cfelse>
                                            	<!--- Print Version --->
                                            	<a href="javascript:OpenApp('../exits_app.cfm?unqid=#uniqueid#');"><img src="pics/exits.jpg" border="0"></a>
                                                <!--- PDF --->
                                                <!---
												<a href="javascript:OpenApp('student_app/print_application.cfm?unqid=#uniqueid#');"><img src="pics/exits.jpg" border="0"></a>
												--->                                                
											</cfif>
											<br /><a href="javascript:OpenMediumW('student_app/section4/page22print.cfm?unqid=#uniqueid#');"><img src="pics/attached-files.gif" border="0"></a>	
											<cfif CLIENT.usertype lt 7>
                                            <br /><em><font size=-1><a href="javascript:SendEmail('student_app/email_form.cfm?unqid=#uniqueid#', 400, 450);"><img src="pics/send-email.gif" border="0"></a></cfif>
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
                <a href="student/placementMgmt/index.cfm?uniqueID=#qGetStudentInfo.uniqueID#" class="jQueryModalPL">Placement Management</a>
                <a href="student/placementMgmt/index.cfm?uniqueID=#qGetStudentInfo.uniqueID#&action=paperwork" class="jQueryModalPL">Placement Paperwork</a>
                
				<!--- OFFICE USERS ONLY --->
				<cfif APPLICATION.CFC.USER.isOfficeUser()> 
					<!---- <a href="" onClick="javascript: win=window.open('insurance/insurance_management.cfm?studentID=#qGetStudentInfo.studentID#', 'Settings', 'height=400, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Insurance Management</a> ---->	
					<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#qGetStudentInfo.studentID#', 700, 500);" class="nav_bar">Representative Payments</a> 					
                    <a href="javascript:openPopUp('forms/missing_documents.cfm', 450, 500);" class="nav_bar">Missing Documents</a>
					<a href="javascript:openPopUp('forms/notes.cfm', 450, 500);" class="nav_bar"><cfif LEN(qGetStudentInfo.notes)><img src="pics/green_check.gif" border="0">&nbsp;</cfif>Notes</a> 	
                    <a href="javascript:openPopUp('forms/ssp.cfm?studentid=#CLIENT.studentid#', 600, 450);" class="nav_bar">Student Issues</a>	
				</cfif> 
                
				<!--- OFFICE - MANAGERS ONLY --->
				<cfif CLIENT.usertype LTE 5> 
					<a href="" onClick="javascript: win=window.open('forms/profile_adjustments.cfm', 'Settings', 'height=500, width=663, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Profile Adjustments</a>		
                </cfif> 
                		
				<!----All Users		
				<a href="" onClick="javascript: win=window.open('virtualfolder/list_vfolder.cfm?unqid=#qGetStudentInfo.uniqueid#', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><cfif VAL(getVirtualFolder.recordcount)><img src="pics/green_check.gif" border="0">&nbsp;</cfif>Virtual Folder</a>
             
				<!--- OFFICE USERS ONLY --->
				<cfif APPLICATION.CFC.USER.isOfficeUser()>
                	<a href="" onClick="javascript: win=window.open('virtualfolder/list_ivfolder.cfm?unqid=#qGetStudentInfo.uniqueid#', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><cfif VAL(getInternalVirtualFolder.recordcount)><img src="pics/green_check.gif" border="0">&nbsp;</cfif>Internal Virtual Folder</a>
             	</cfif>
					---->	
               	
                  <a href="index.cfm?curdoc=virtualFolder/view&unqid=#qGetStudentInfo.uniqueID#" >Virtual Folder</a>
               
				<a href="" onClick="javascript: win=window.open('forms/received_progress_reports.cfm?stuid=#qGetStudentInfo.studentID#', 'Reports', 'height=450, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Progress Reports</A>  
                <a href="student/index.cfm?action=flightInformation&uniqueID=#qGetStudentInfo.uniqueID#&programID=#qGetStudentInfo.programID#" class="jQueryModal">Flight Information</a>
                <a href="" onClick="javascript: win=window.open('tours/trips.cfm', 'Settings', 'height=450, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Student Trips</a>
                <Cfif client.usertype lte 4>
               <a href="index.cfm?curdoc=caseMgmt/index&studentid=#qGetStudentInfo.studentid#"> <cfif val(qStudentsCases.recordcount)><img src="pics/attention.png" border=0 /></cfif> Case Management</a>
				</Cfif>
               
			</div>
		</div>
		</td>
	</tr>
</table>

<br />

<!---<cfif CLIENT.companyid neq qAssignedCompany.companyid> 
	<div class="alertRed">
    	<table>
        	<tr>
            	<Td>
                	<i class="fa fa-exclamation-triangle fa-3x"></i>
                </Td>
                <td>
                	<h1>Change Program Managers</h1>
                	<em>This student is assigned to #qAssignedCompany.team_id#.</em>
            	</td>
         	</Tr>
       	</table>
  	</div>
    <br /><br />
</cfif>--->

<cfdirectory directory="#APPLICATION.PATH.uploadedFiles#/online_app/page23/" name="file" filter="#qGetStudentInfo.studentid#.*">	
    
<cfif VAL(file.recordcount)>
          <div class="alertGreen">
          <table>
          	<Tr>
            	<Td>
                <i class="fa fa-users fa-3x"></i>
                </Td>
                <td>
                <h1>Student Accepts Double Placement</h1>
                <em>Double Placment acceptence form has been signed in the student applicaiton.</em>
            	</td>
               </Tr>
             </table>
             
            </div>
    	<br /><br />
        </cfif>
	
<!--- PROGRAM / REGION --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding=2 cellspacing=0 align="center" width="100%">
				<tr bgcolor="##EAE8E8">
                	<td colspan="2">
                    	<span class="get_attention"><b>:: </b></span>Program <cfif APPLICATION.CFC.USER.isOfficeUser()>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('forms/stu_program_history.cfm?unqid=#uniqueid#');">History</a> ]</font></cfif>
                    </td>
                </tr>
				<tr><td>Program :</td>
					<td>		
						<cfif qCheckForExpiredProgram.recordcount EQ 1 AND client.companyid neq 14>
							#qCheckForExpiredProgram.programname#
							<input type="hidden" name="program" value="#qCheckForExpiredProgram.programID#">
						<cfelse>
							<select name="program" id="program" onchange="displayProgramReason(#qGetStudentInfo.programID#, this.value);" <cfif FORM.edit EQ 'no'>disabled</cfif>>
                                <option value="0">Unassigned</option>
                                <cfloop query="qGetActivePrograms">
                                	<option value="#programID#" <cfif qGetStudentInfo.programID EQ programID> selected </cfif>>#programname#</option>
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
               <Cfif CLIENT.companyid NEQ 14> <tr><td>2nd Visit Rep. :</td>
					<td><cfif secondVisitRepID is 0>	Not Assigned <cfelse> 
						<a href="index.cfm?curdoc=user_info&userid=#qGet2ndVisitRep.userid#">#qGet2ndVisitRep.firstname# #qGet2ndVisitRep.lastname#</a></cfif> 
					</td>				
				</tr>	
                </Cfif>											
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
        <td width="49%" valign="top">
            <table cellpadding=2 cellspacing=0 align="center" width="100%">
				<tr bgcolor="##EAE8E8">
                	<td colspan="2"><span class="get_attention"><b>:: </b></span>Region  <cfif APPLICATION.CFC.USER.isOfficeUser()>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('forms/stu_region_history.cfm?unqid=#uniqueid#');"> History </a> ]</font></cfif></td>
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
                        <input type="radio" name="regionguar" id="regionguarYes" value="yes" <cfif regionguar EQ 'yes' OR state_guarantee GT 0> checked="checked" </cfif> onClick="displayGuaranteed();" <cfif FORM.edit EQ 'no'> disabled </cfif> > 
                        <label for="regionguarYes"> Yes </label>
                        <input type="radio" name="regionguar" id="regionguarNo" value="no" <cfif regionguar EQ 'no'  AND state_guarantee EQ 0> checked="checked" </cfif> onClick="displayGuaranteed();" <cfif FORM.edit EQ 'no'> disabled </cfif> > 
                        <label for="regionguarNo"> No </label>
					</td>
				</tr>
				<tr class="displayNoGuarantee">
                	<td>Region Preference :</td>
					<td>n/a</td>
				</tr>
				<tr class="displayGuarantee"><td>Region Preference :</td>
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
                	<td>State Preference :</td>
					<td>n/a</td>
				</tr>
				<tr class="displayGuarantee">
                	<td>State Preference :</td>
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
						<td width="140px">Preference Fee Waived</td>
						<td>n/a</td>
					</tr>
					<tr id="fee_waived"><td >Preference Fee Waived</td>
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
		<Cfif client.companyid eq 14>
        
          <table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Payment Information</td></tr>
                <tr>
                	<td><input type="checkbox" name="depositReceived" value="0" OnClick="PopulateDepositReceivedBox();" <cfif FORM.edit EQ 'no'>disabled</cfif> <cfif isDate(date_depositReceived)>checked</cfif>></td>
                    <Td>Deposit Received</Td>
                    <td><input type="text" name="date_depositReceived" class="datePicker" value="#DateFormat(date_depositReceived, 'mm/dd/yyyy')#" <cfif FORM.edit EQ 'no'>readonly</cfif> ></td>
                </tr>
                <tr>
                	<td><input type="checkbox" name="finalPayment" value="0" OnClick="PopulateFinalPaymentBox();"  <cfif FORM.edit EQ 'no'>disabled</cfif> <cfif isDate(date_finalPayment)>checked</cfif>></td>
                    <Td>Final Payment Received</Td>
                    <td><input type="text" name="date_finalPayment" class="datePicker" value="#DateFormat(date_finalPayment, 'mm/dd/yyyy')#" <cfif FORM.edit EQ 'no'>readonly</cfif>></td>
                </tr>
                <tr>
                	<td><input type="checkbox" name="checkDrawn" value="0" OnClick="PopulateCheckDrawnBox();" <cfif FORM.edit EQ 'no'>disabled</cfif>  <cfif isDate(date_checkDrawn)>checked</cfif>></td>
                    <Td>Check Drawn</Td>
                     <td><input type="text" name="date_checkDrawn" class="datePicker" value="#DateFormat(date_checkDrawn, 'mm/dd/yyyy')#" <cfif FORM.edit EQ 'no'>readonly</cfif>></td>
                </tr>
                <tr>
                	<td><input type="checkbox" name="checkSentSchool" value="0" OnClick="PopulateCheckSentSchoolBox();" <cfif FORM.edit EQ 'no'>disabled</cfif> <cfif isDate(date_checkSentSchool)>checked</cfif>></td>
                    <Td>Check Sent to School</Td>
                     <td><input type="text" name="date_checkSentSchool" class="datePicker" value="#DateFormat(date_checkSentSchool, 'mm/dd/yyyy')#" <cfif FORM.edit EQ 'no'>readonly</cfif>></td>
                </tr>
          </table>
       
        <cfelse>
			
            
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
                            <cfloop query="qAYPEnglishCamps">
                            	<option value="#qAYPEnglishCamps.campid#" <cfif qGetStudentInfo.aypenglish EQ qAYPEnglishCamps.campid> selected </cfif>>#qAYPEnglishCamps.name#</option>
                            </cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td><cfif ayporientation EQ 0><input type="checkbox" name="orientation_check" value="0" <cfif FORM.edit EQ 'no'>disabled</cfif>>	<cfelse><input type="checkbox" name="orientation_check" value="1" checked <cfif FORM.edit EQ 'no'>disabled</cfif>>	</cfif></td>
					<td>Pre-AYP Orientation Camp:  &nbsp;
					    <select name="ayp_orientation" <cfif FORM.edit EQ 'no'>disabled</cfif>>
                            <option value="0"></option>
                            <cfloop query="qAYPOrientationCamps">
                                <option value="#qAYPOrientationCamps.campid#" <cfif qGetStudentInfo.ayporientation EQ qAYPOrientationCamps.campid> selected </cfif>>#qAYPOrientationCamps.name#</option>
                            </cfloop>
						</select>
					</td>
				</tr>
			</table>
        </Cfif>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Insurance</td></tr>
				<tr>
					<td width="10"><cfif qGetIntlRep.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" value="0" disabled><cfelse><input type="checkbox" name="insurance_check" value="1" checked disabled></cfif></td>
					<td align="left" colspan="2">
						<cfif qGetIntlRep.insurance_typeid EQ 0> 
                        	<font color="FF0000">Intl. Rep. Insurance Information is missing</font>
						<cfelseif qGetIntlRep.insurance_typeid EQ 1> 
                        	Does not take Insurance Provided by #qCompanyShort.companyshort#
						<cfelse> 
                        	Takes Insurance Provided by #qCompanyShort.companyshort# 
						</cfif>
					</td>
				</tr>
				<tr>
					<td><cfif qGetIntlRep.insurance_typeid LTE 1><input type="checkbox" name="insurance_check" value="0" disabled><cfelse><input type="checkbox" name="insurance_check" value="1" checked disabled></cfif></td>
					<td>Policy Type :</td>
					<td>
						<cfif qGetIntlRep.insurance_typeid EQ 0>
							<font color="##FF0000">Missing Policy Type</font>
						<cfelseif qGetIntlRep.insurance_typeid EQ 1> 
                        	n/a
						<cfelse> 
                        	#qGetIntlRep.type#	
						</cfif>		
					</td>
				</tr>
                <tr>
                    <td></td> 	
                    <Td>Policy No.</Td>
                    <Td>#qGetInsurancePolicyInfo.policycode#</Td>
                </tr>
				<!--- Insurance Information --->
                <tr>
					<td>
                    	<input type="checkbox" name="insured_date" value="1" <Cfif qInsuranceHistory.recordCount> checked </cfif> disabled>
                    </td>
					<td>Insured on :</td>
					<td>
						<cfif qGetIntlRep.insurance_typeid EQ 1>
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
                        <cfswitch expression="#qInsuranceHistory.type#">
                        
                            <cfcase value="N">
                                <td>Enrolled</td>
                                <td>From #DateFormat(qInsuranceHistory.startDate, 'mm/dd/yyyy')# to #DateFormat(qInsuranceHistory.endDate, 'mm/dd/yyyy')#</td>
                            </cfcase>
                            
                            <cfcase value="EX">
                                <td>Extended</td>
                                <td>From #DateFormat(qInsuranceHistory.startDate, 'mm/dd/yyyy')# to #DateFormat(qInsuranceHistory.endDate, 'mm/dd/yyyy')#</td>
                            </cfcase>

                            <cfcase value="R,X">
                                <td>Cancelled</td> <!--- Cancelation / Return | Invert the dates --->
                                <td>From #DateFormat(qInsuranceHistory.endDate, 'mm/dd/yyyy')# to #DateFormat(qInsuranceHistory.startDate, 'mm/dd/yyyy')#</td>
                            </cfcase>
                            
                            <cfdefaultcase>
                                <td>#qInsuranceHistory.type#</td>
                                <td>From #DateFormat(qInsuranceHistory.startDate, 'mm/dd/yyyy')# to #DateFormat(qInsuranceHistory.endDate, 'mm/dd/yyyy')#</td>
                            </cfdefaultcase>
                        
                        </cfswitch>
                    </tr>
                </cfloop>
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
						<cfif direct_placement EQ 0><input type="radio" name="direct_placement" value="0" checked="yes" <cfif FORM.edit EQ 'no'>disabled</cfif>>No<cfelse><input type="radio" name="direct_placement" value="0" <cfif FORM.edit EQ 'no'>disabled</cfif>>No</cfif> &nbsp; 
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
					<td colspan="2">Student Cancelled  &nbsp; &nbsp; &nbsp; &nbsp; Date: &nbsp; <input type="text" name="date_canceled" class="datePicker" value="#DateFormat(canceldate, 'mm/dd/yyyy')#" <cfif FORM.edit EQ 'no'>readonly</cfif>></td>
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
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>#CLIENT.DSFormName# Form <cfif APPLICATION.CFC.USER.isOfficeUser()>&nbsp; &nbsp; [ <font size="-3"><a href="javascript:OpenHistory('sevis/student_history.cfm?unqid=#uniqueid#');">History</a> ]</font></cfif> </td></tr>				
				<tr>		
					<td><Cfif verification_received EQ ''><input type="checkbox" name="verification_box" value="0" onClick="PopulateDS2019Box()" <cfif FORM.edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="verification_box" value="1" onClick="PopulateDS2019Box()" checked <cfif FORM.edit EQ 'no'>disabled</cfif>> </cfif>
					<td>#CLIENT.DSFormName# Verification Received</td>
                    <td><input type="text" name="verification_form"  class="datePicker" value="#DateFormat(verification_received, 'mm/dd/yyyy')#" <cfif FORM.edit EQ 'no'>readonly</cfif>></td>
				</tr>
                <Cfif client.companyid eq 14>
                 <tr>
                	<td><input type="checkbox" name="i20Received" value="0" OnClick="PopulateI20ReceivedBox();" <cfif FORM.edit EQ 'no'>disabled</cfif> <cfif isDate(date_i20Received)>checked</cfif>></td>
                    <Td>I-20 Received</Td>
                    <td><input type="text" name="date_i20Received" class="datePicker" value="#DateFormat(date_i20Received, 'mm/dd/yyyy')#" <cfif FORM.edit EQ 'no'>readonly</cfif> ></td>
                </tr>
                <tr>
                	<td><input type="checkbox" name="i20Sent" value="0" OnClick="PopulateI20SentBox();" <cfif FORM.edit EQ 'no'>disabled</cfif> <cfif isDate(date_i20sent)>checked</cfif>></td>
                    <Td>I-20 Sent to Agent</Td>
                    <td><input type="text" name="date_i20sent" class="datePicker" value="#DateFormat(date_i20sent, 'mm/dd/yyyy')#" <cfif FORM.edit EQ 'no'>readonly</cfif> ></td>
                </tr>
                </Cfif>
				<tr>
					<td width="10">&nbsp;</td>
					<td><cfif NOT LEN(qGetIntlRep.accepts_sevis_fee)>
							<font color="FF0000">SEVIS Fee information is missing</font>
						<cfelseif qGetIntlRep.accepts_sevis_fee EQ 0>
							#qGetIntlRep.businessName# <span style="font-weight:bold; text-decoration:underline;">DOES NOT</span> accept SEVIS Fee
						<cfelseif qGetIntlRep.accepts_sevis_fee EQ 1>
							#qGetIntlRep.businessName# <span style="font-weight:bold; text-decoration:underline;">ACCEPTS</span> SEVIS Fee
						</cfif>
					</td>
				</tr>
				<tr><td>&nbsp;</td>	
					<td>#CLIENT.DSFormName# no.: &nbsp;<input type="text" name="ds2019_no" size=12 value="#ds2019_no#" maxlength="12" <cfif FORM.edit EQ 'no'>readonly</cfif>> &nbsp; 
						Batch ID: #sevis_batchid#</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
                    	Fee: &nbsp; 
						<cfif LEN(sevis_fee_paid_date)>
                        	Paid  on #DateFormat(sevis_fee_paid_date, 'mm/dd/yyyy')#
						<cfelseif qGetIntlRep.accepts_sevis_fee NEQ 1>
                        	n/a 
						<cfelse> 
                       		Unpaid 
						</cfif>
                	</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Status: &nbsp; <cfif qSevisStatus.recordcount> Active since #DateFormat(qSevisStatus.datecreated, 'mm/dd/yyyy')# <cfelseif sevis_batchid NEQ 0> Initial <cfelse> n/a </cfif></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Start Date: &nbsp; <cfif qGetSevisHistory.start_date NEQ ''>#DateFormat(qGetSevisHistory.start_date, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>End Date: &nbsp; <cfif qGetSevisHistory.end_date NEQ ''>#DateFormat(qGetSevisHistory.end_date, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
				</tr>
                <tr>
                	<td>&nbsp;</td>
                    <td>Host Family: &nbsp; <cfif qGetSevisHistory.hostID NEQ 0>#qGetSevisHistory.familyLastName# ###qGetSevisHistory.hostID#<cfelse>#CLIENT.companyName#</cfif></td>
                </tr>
                <tr>
                	<td>&nbsp;</td>
                    <td>School: &nbsp; <cfif qGetSevisHistory.school_name NEQ ''>#qGetSevisHistory.school_name#<cfelse>n/a</cfif></td>
                </tr>				
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="2"><span class="get_attention"><b>:: </b></span>Letters &nbsp; &nbsp; [  <font size=-3> <a href="javascript:OpenLetter('reports/printing_tips.cfm');">Printing Tips</a></font> ]</td></tr>
				<!--- OFFICE USERS --->
				<cfif APPLICATION.CFC.USER.isOfficeUser()>
				<tr>
					<td>: : <a href="javascript:OpenLetter('reports/acceptance_letter.cfm');">Acceptance</a></td>
					<td>
                    	<!--- Only for approved placements --->
                    	<cfif vPlacementStatus EQ "Approved" OR CLIENT.userType LTE 4>
                    		: : <a href="javascript:OpenLetter('reports/placementInfoSheet.cfm?uniqueID=#qGetStudentInfo.uniqueID#');">Placement</a>
                      	</cfif>
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
					<td>: : <a href="student/index.cfm?action=printFlightInformation&uniqueID=#qGetStudentInfo.uniqueID#&programID=#qGetStudentInfo.programID#">Flight Information</a></td>
				</tr>				
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/letter_student_orientation.cfm');">Student Orient. Sign Off</a></td>
					<td width="50%">: : <a href="javascript:OpenLetter('hostApplication/hostOrientationSignOff.cfm?hostID=#qGetStudentInfo.hostID#&seasonID=#qGetSelectedProgram.seasonID#');">Family Orientation Sign Off</a></td>
				</tr>
                <tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/labels_student_idcards.cfm?studentid=#studentid#');">Student ID Card</a>
						<cfif APPLICATION.CFC.USER.isOfficeUser()> &nbsp; <a href="javascript:OpenLetter('reports/emailStudentIDCard.cfm?studentID=#studentID#');">
                   		<img src="pics/email.gif" border="0" alt="Email Student ID Card"></a></cfif></td>
					<td width="50%">: : <a href="javascript:OpenLetter('forms/singlePersonPlacementAuth.cfm?studentid=#studentid#');">Single Person Auth.</a>
						<cfif APPLICATION.CFC.USER.isOfficeUser()> &nbsp; <a href="javascript:OpenLetter('reports/emailSinglePlaceAuth.cfm?studentID=#studentID#');">
                        <img src="pics/email.gif" border="0" alt="Email Single Place Auth"></a></cfif></td>
				</tr>				
			</table>
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="2"><span class="get_attention"><b>:: </b></span>Double Placement Letters</td></tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/double_placement_host_family.cfm');">Family & School</a></td>
					<td width="50%">
						: : <a href="javascript:OpenLetter('reports/double_placement_nat_fam.cfm');">Natural Family</a>
						<cfif APPLICATION.CFC.USER.isOfficeUser()> &nbsp; <a href="javascript:OpenLetter('reports/email_dbl_place_nat_fam.cfm?studentID=#qGetStudentInfo.studentID#');"><img src="pics/email.gif" border="0" alt="Email Nat. Family Letter"></a></cfif>
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
					<td width="50%">: : <a href="javascript:OpenLetter('reports/placementInfoSheet.cfm?uniqueID=#qGetStudentInfo.uniqueID#&profileType=web');">Placement</a></td>
					<td width="50%">: :<a href="student/index.cfm?action=printFlightInformation&uniqueID=#qGetStudentInfo.uniqueID#&programID=#qGetStudentInfo.programID#">Flight Information</a></td>
				</tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/host_thank_you_letter.cfm');">Family Thank You</a></td>
				</tr>
				<tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/letter_student_orientation.cfm');">Student Orient. Sign Off</a></td>
					<td width="50%">: : <a href="javascript:OpenLetter('hostApplication/hostOrientationSignOff.cfm?hostID=#qGetStudentInfo.hostID#&seasonID=#qGetSelectedProgram.seasonID#');">Family Orientation Sign Off</a></td>
				</tr>			
                <tr>
					<td width="50%">: : <a href="javascript:OpenLetter('reports/labels_student_idcards.cfm?studentid=#studentid#');">Student ID Card</a></td>
					<td width="50%"></td>
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
<cfif APPLICATION.CFC.USER.isOfficeUser() AND FORM.edit EQ 'no'>
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