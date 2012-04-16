<!--- ------------------------------------------------------------------------- ----
	
	File:		_studentInformation.cfm
	Author:		Marcus Melo
	Date:		April 16, 2012
	Desc:		Student Information Section for Guest User - Read Only
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
   
    <cfparam name="studentID" default="0">
    
    <cfscript>
		if ( VAL(studentID) ) {
			CLIENT.studentID = studentID;
		}
		
		// Set currentDate
		currentDate = now();
		
		// Get Student Information 
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=studentID); 

		// Get Super Rep
		qGetSuperRep = APPLICATION.CFC.USER.getUserByID(userID=VAL(qGetStudentInfo.arearepid));

		// Get Place Rep
		qGetPlaceRep = APPLICATION.CFC.USER.getUserByID(userID=VAL(qGetStudentInfo.placerepid));

		// Get Super Rep
		qEnteredBy = APPLICATION.CFC.USER.getUserByID(userID=VAL(qGetStudentInfo.entered_by));
		
		// Get 2nd Visit Rep
		qGet2ndVisitRep = APPLICATION.CFC.USER.getUserByID(userID=VAL(qGetStudentInfo.secondVisitRepID));
		
		// Get Student Region Assigned
		qRegionAssigned = APPLICATION.CFC.REGION.getRegions(regionID=qGetStudentInfo.regionAssigned);
		
		// Insurance Information
		qInsuranceHistory = APPLICATION.CFC.INSURANCE.getInsuranceHistoryByStudent(studentID=qGetStudentInfo.studentID, type='N,R,EX,X');
		
		// Virtual Folder Directory
		virtualDirectory = "#APPLICATION.PATH.onlineApp.virtualFolder##qGetStudentInfo.studentID#";
		
		// Get Facilitator for this Region
		qFacilitator = APPLICATION.CFC.USER.getUserByID(userID=VAL(qRegionAssigned.regionfacilitator));
	</cfscript>
	
    <!--- Student Picture --->
	<cfdirectory directory="#APPLICATION.PATH.onlineApp.picture#" name="studentPicture" filter="#qGetStudentInfo.studentID#.*">

	<!--- check virtual folder files --->
    <cfdirectory name="getVirtualFolder" directory="#virtualDirectory#" filter="*.*">

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
   
    <cfquery name="qGetActivePrograms" datasource="#APPLICATION.DSN#">
        SELECT 
        	programname, 
            programid, 
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
        	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.programid#">
        ORDER BY
        	programname
    </cfquery>
    
    <cfquery name="qGetSelectedProgram" dbtype="query">
        SELECT 
        	*
        FROM 
        	qGetActivePrograms
        WHERE 
			programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.programid#">
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
    
    <cfquery name="qGetSevisDates" datasource="#APPLICATION.DSN#">
        SELECT 
        	start_date, 
            end_date
        FROM 
        	smg_sevis_history
        WHERE 
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
        AND
        	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        ORDER BY 
        	historyid DESC 
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

<!--- Table Header --->
<gui:tableHeader
	imageName="students.gif"
	tableTitle="Student Information"
	tableRightTitle=""
/>

<cfoutput query="qGetStudentInfo">

<cfform name="studentForm" method="post" action="querys/update_student_info.cfm">
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
                                            pathToImage = APPLICATION.PATH.onlineApp.picture & studentPicture.name;
                                            imageFile = createObject("java", "java.io.File").init(pathToImage);
											
                                            // read the image into a BufferedImage
                                            ImageIO = createObject("java", "javax.imageio.ImageIO");
                                            bi = ImageIO.read(imageFile);
                                            img = ImageNew(bi);
                                        </cfscript>              
                                        
                                        <cfimage source="#img#" name="myImage">
                                        <cfimage source="#myImage#" action="writeToBrowser" border="0" width="135px"><br />
                                       
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
                            <tr><td align="center" colspan="2"><cfif dob EQ ''>n/a<cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old #sex# </cfif></td></tr> 
							
                            <tr><td>Intl. Rep. : </td>
								<td><select name="intrep" disabled class="xLargeField">
                                        <option value="0" selected></option>		
                                        <cfloop query="qGetIntlRep">
                                        	<option value="#qGetIntlRep.userid#" selected>#businessname#</option>
                                        </cfloop>
									</select>
								</td>
							</tr>
							
                            <tr>
								<td colspan="2">
									<table width="100%" cellpadding="2">
										<tr><td>Date of Entry : </td><td>#DateFormat(dateapplication, 'mm/dd/yyyy')# </td></tr>
										<tr><td><cfif randid EQ 0>Entered by : <cfelse>Approved by : </cfif> </td><td><cfif qEnteredBy.recordcount NEQ 0>#qEnteredBy.firstname# #qEnteredBy.lastname# (###qEnteredBy.userid#)<cfelse>n/a</cfif></td></tr>										
										<tr><cfif canceldate EQ ''>
											<td width="80" align="right">				
												<cfif VAL(active)>
													<input name="active" type="checkbox"   checked disabled>
												<cfelse>
													<input name="active" type="checkbox"  disabled>
												</cfif>
											</td>
											<td>Student is Active</td>
											</cfif>
										</tr>
									</table>
                                    
									<table width="225" cellpadding="2" align="right">
										<!--- EXITS ONLINE APPLICATION --->
										<cfif randid NEQ 0>
                                            <tr>
                                                <td align="center">
                                                    <a href="javascript:OpenApp('student_app/print_application.cfm?unqid=#uniqueid#');"><img src="pics/exits.jpg" border="0"></a>
                                                	<br />
                                                	<a href="javascript:OpenMediumW('student_app/section4/page22print.cfm?unqid=#uniqueid#');"><img src="pics/attached-files.gif" border="0"></a>	
                                                </td>
                                            </tr>
										</cfif>														
									</table>								
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
                    <a href="" onClick="javascript: win=window.open('forms/received_progress_reports.cfm?stuid=#qGetStudentInfo.studentID#', 'Reports', 'height=450, width=610, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Progress Reports</A>  
                    <a href="student/index.cfm?action=flightInformation&uniqueID=#qGetStudentInfo.uniqueID#&programID=#qGetStudentInfo.programID#" class="jQueryModal">Flight Information</a>
                </div>
            </div>
		</td>
	</tr>
</table>

<br />

<!--- PROGRAM / REGION --->
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding=2 cellspacing=0 align="center" width="100%">
				<tr bgcolor="##EAE8E8">
                	<td colspan="2">
                    	<span class="get_attention"><b>:: </b></span>Program
                    </td>
                </tr>
				<tr><td>Program :</td>
					<td>		
						<cfif qCheckForExpiredProgram.recordcount EQ 1>
							#qCheckForExpiredProgram.programname#
							<input type="hidden" name="program" value="#qCheckForExpiredProgram.programid#">
						<cfelse>
							<select name="program" id="program" onchange="displayProgramReason(#qGetStudentInfo.programID#, this.value);" disabled>
                                <option value="0">Unassigned</option>
                                <cfloop query="qGetActivePrograms">
                                	<option value="#programid#" <cfif qGetStudentInfo.programid EQ programid> selected </cfif>>#programname#</option>
                                </cfloop>
                            </select>
						</cfif>
					</td>
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
                <tr><td>2nd Visit Rep. :</td>
                    <td><cfif secondVisitRepID is 0>Not Assigned <cfelse> 
                        <a href="index.cfm?curdoc=user_info&userid=#qGet2ndVisitRep.userid#">#qGet2ndVisitRep.firstname# #qGet2ndVisitRep.lastname#</a></cfif> 
                    </td>				
                </tr>	
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
        <td width="49%" valign="top">
            <table cellpadding=2 cellspacing=0 align="center" width="100%">
				<tr bgcolor="##EAE8E8">
                	<td colspan="2"><span class="get_attention"><b>:: </b></span>Region</td>
                </tr>
				<tr>
                	<td width="150px">Region :</td>
					<td>
                    	<select name="region" id="region" onChange="displayGuaranteed(this.value); displayRegionReason(#qGetStudentInfo.regionAssigned#, this.value);" disabled >
							<cfloop query="qRegionAssigned">
								<option value="#qRegionAssigned.regionid#" selected>#qRegionAssigned.regionname#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
                	<td>Assigned on :</td>
					<td>#DateFormat(dateassigned,'mm/dd/yyyy')#</td>
				</tr>
				<tr>
                	<td>Region/State Preference :</td>
					<td>
                        <input type="radio" name="regionguar" id="regionguarYes" value="yes" <cfif regionguar EQ 'yes' OR state_guarantee GT 0> checked="checked" </cfif> onClick="displayGuaranteed();" disabled > 
                        <label for="regionguarYes"> Yes </label>
                        <input type="radio" name="regionguar" id="regionguarNo" value="no" <cfif regionguar EQ 'no'  AND state_guarantee EQ 0> checked="checked" </cfif> onClick="displayGuaranteed();" disabled > 
                        <label for="regionguarNo"> No </label>
					</td>
				</tr>
				<tr class="displayNoGuarantee">
                	<td>Region Preference :</td>
					<td>n/a</td>
				</tr>
				<tr class="displayGuarantee"><td>Region Preference :</td>
					<td>
                        <cfselect
                            name="rguarantee" 
                            id="rguarantee"
                            value="regionID"
                            display="regionName"
                            selected="#VAL(qGetStudentInfo.regionalGuarantee)#"
                            bindonload="yes"
                            bind="cfc:nsmg.extensions.components.region.getRegionGuaranteeRemote({region})"
                            disabled /> 
					</td>
				</tr>
				<tr class="displayNoGuarantee">
                	<td>State Preference :</td>
					<td>n/a</td>
				</tr>
				<tr class="displayGuarantee">
                	<td>State Preference :</td>
					<td>
                    	<select name="state_guarantee" id="state_guarantee" disabled >
                            <option value="0">--- Select a State ---</option>
                            <cfloop query="qStates">
                                <option value="#id#" <cfif qGetStudentInfo.state_guarantee eq id>selected</cfif>>#statename#</option>
                            </cfloop>
						</select>
					</td>
				</tr>
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
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>#CLIENT.DSFormName# Form</td></tr>				
				<tr>		
					<td><Cfif verification_received EQ ''><input type="checkbox" name="verification_box" value="0" onClick="PopulateDS2019Box()" disabled> <cfelse> <input type="checkbox" name="verification_box" value="1" onClick="PopulateDS2019Box()" checked disabled> </cfif>
					<td>#CLIENT.DSFormName# Verification Received &nbsp; &nbsp; Date: &nbsp;<input type="text" name="verification_form" size=8 value="#DateFormat(verification_received, 'mm/dd/yyyy')#" readonly></td>
				</tr>
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
					<td>#CLIENT.DSFormName# no.: &nbsp;<input type="text" name="ds2019_no" size=12 value="#ds2019_no#" maxlength="12" readonly> &nbsp; 
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
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Insurance</td></tr>
				<tr>
					<td width="10"><cfif qGetIntlRep.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" value="0" disabled><cfelse><input type="checkbox" name="insurance_check" value="1" checked disabled></cfif></td>
					<td align="left" colspan="2">
						<cfif qGetIntlRep.insurance_typeid EQ 0> 
                        	<font color="FF0000">Intl. Rep. Insurance Information is missing</font>
						<cfelseif qGetIntlRep.insurance_typeid EQ 1> 
                        	Does not take Insurance Provided by #CLIENT.companyshort#
						<cfelse> 
                        	Takes Insurance Provided by #CLIENT.companyshort# 
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
                            #DateFormat(qInsuranceHistory.date, 'mm/dd/yyyy')#
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

<!---
<br />
<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td width="49%" valign="top">
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
			<!--- Cancelation --->
			<table cellpadding="2" width="100%">
				<tr bgcolor="##EAE8E8"><td colspan="3"><span class="get_attention"><b>:: </b></span>Cancelation</td></tr>
				<tr>
					<td width="10"><Cfif NOT LEN(cancelDate)> <input type="checkbox" name="student_cancel" value="0" OnClick="PopulateCancelBox()" disabled> <cfelse> <input type="checkbox" name="student_cancel" value="1" OnClick="PopulateCancelBox();" checked disabled > </cfif></td>
					<td colspan="2">Student Cancelled  &nbsp; &nbsp; &nbsp; &nbsp; Date: &nbsp; <input type="text" name="date_canceled" class="datePicker" value="#DateFormat(canceldate, 'mm/dd/yyyy')#" readonly></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Reason:</td>
					<td>
                    	<select name="cancelreason" disabled>
                            <option value="" <cfif cancelreason EQ ''>selected</cfif>></option>
                            <option value="Cancelation" <cfif cancelreason EQ 'Cancelation'>selected</cfif>>Cancelation</option>
                            <option value="Withdrawl" <cfif cancelreason EQ 'Withdrawl'>selected</cfif>>Withdrawl</option>
                            <option value="Termination" <cfif cancelreason EQ 'Termination'>selected</cfif>>Termination</option>
                            <option value="Visa Denial" <cfif cancelreason EQ 'Visa Denial'>selected</cfif>>Visa Denial</option>
						</select>
                   </td> 
				</tr>
			</table>	
		</td>	
	</tr>
</table>
--->

<br />

</div>

</cfform>
		
<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>