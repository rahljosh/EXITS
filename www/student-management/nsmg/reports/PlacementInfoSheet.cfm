<!--- ------------------------------------------------------------------------- ----
	
	File:		PlacementInfoSheet.cfm
	Author:		Josh Rahl
	Date:		April 4th, 2011
	Desc:		Web Version of Placement Info Sheet

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- CHECK SESSIONS --->
    <cfinclude template="../check_sessions.cfm">
	
    <!--- Param URL Variables --->    
    <cfparam name="uniqueID" default="">
    <cfparam name="profileType" default="">
    <cfparam name="URL.studentID" default="0">
    <cfparam name="URL.print" default="">

    <!--- Param FORM Variables --->    
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.emailTo" default="">
    <cfparam name="FORM.NewDatePlaced" default="">

    <cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
		
		if ( NOT LEN(uniqueID) ) {
			ArrayAppend(Errors.Messages, "You have not specified a valid studentID");
		}	
	
		// Get Student by uniqueID
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=uniqueID);
		
		// Get Region
		qGetRegion = APPLICATION.CFC.REGION.getRegions(regionID=qGetStudentInfo.regionassigned);

		// Get International Representative
		qIntlRep = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.intrep);
		
		// Get Company
		qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		
		// Facilitator
		qGetFacilitator = APPLICATION.CFC.USER.getUsers(qGetRegion.regionfacilitator); 

		// Area Representative
		qGetAreaRep = APPLICATION.CFC.USER.getUsers(userID=qGetStudentInfo.arearepid);
		
		// Host Family
		qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=qGetStudentInfo.hostID);
		
		// Host Family Children
		qGetHostChildren = APPLICATION.CFC.HOST.getHostMemberByID(hostID=qGetStudentInfo.hostID);
		
		// Host Family Pets
		qGetHostPets = APPLICATION.CFC.HOST.getHostPets(hostID=qGetStudentInfo.hostID);
		
		// School
		qGetSchool = APPLICATION.CFC.SCHOOL.getSchools(schoolID=qGetStudentInfo.schoolID);
						
		// Get Host Interests
		qGetHostInterests = APPLICATION.CFC.LOOKUPTABLES.getInterest(interestID=qGetHostFamily.interests,limit=6);
		
		// set Interest List
		interestHostList = ValueList(qGetHostInterests.interest, "<br />");
		
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {

			// Data Validation
			if ( NOT IsValid("email", FORM.emailTo) ) {
				ArrayAppend(Errors.Messages, "Please enter a valid email address");
			}

		}
	</cfscript>

	<!--- Update Date Placed | Update on both tables students and smg_hostHistory --->
    <cfif IsDate(FORM.NewDatePlaced)>
    
        <cfquery datasource="#APPLICATION.DSN#">
        	UPDATE 
				smg_students
        	SET
				datePlaced = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.newDatePlaced#">
        	WHERE
				uniqueID = <cfqueryparam cfsqltype="integer" value="#URL.uniqueID#">
        </cfquery>
        
        <cfquery datasource="#APPLICATION.DSN#">
        	UPDATE 
				smg_hostHistory
        	SET
				datePlaced = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.newDatePlaced#">
        	WHERE
				studentID = <cfqueryparam cfsqltype="integer" value="#qGetStudentInfo.studentID#">
            AND
            	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            LIMIT 1
        </cfquery>
        
        <cflocation url="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" addtoken="no">
        
    </cfif>
            
    <cfquery name="qGetSchool_dates" datasource="#APPLICATION.DSN#">
        SELECT 
        	schooldateid, 
            schoolid, 
            smg_school_dates.seasonid, 
            enrollment, 
            year_begins, 
            semester_ends, 
            semester_begins, 
            year_ends,
            p.programid
        FROM 
        	smg_school_dates
        INNER JOIN 
        	smg_programs p ON p.seasonid = smg_school_dates.seasonid
        WHERE 
        	schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.schoolid#">
        AND 
        	p.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.programid#">
    </cfquery>
    
    <!--- get history to check if this is a relocation --->
    <cfquery name="qGetHistory" datasource="#APPLICATION.DSN#">
        SELECT 
        	historyid, 
            isRelocation
        FROM 
        	smg_hosthistory
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">
        ORDER BY 
        	historyid DESC
    </cfquery>
    
    <!---number kids at home---->
    <cfquery name="kidsAtHome" dbtype="query">
        SELECT 
        	count(childid)
        FROM 
        	qGetHostChildren
        WHERE
        	liveathome = 'yes'
    </cfquery>
    
    <cfscript>
		father=0;
		mother=0;
		
		if ( LEN(qGetHostFamily.fatherfirstname) ) {
			father = 1;
		}

		if ( LEN(qGetHostFamily.motherfirstname) ) {
			mother = 1;
		}
		
		totalfam = mother + father + kidsAtHome.recordcount;
	</cfscript>
    
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<script language="javascript">
	function enableButtons() {
		window.opener.displayApprovalButton('actionButtons');
		window.close();
	}
</script>

<Cfoutput>

<!----Approve Link---->
<cfsavecontent variable="approveLink">

    <table class="profileTable" align="center" style="margin-top:10px;">
        <tr>
            <Td align="center">
			    <a href="javascript:enableButtons();">
                	I have read and checked the Placement Letter Above and am ready to Approve or Deny. 
                    <br /> 
                    Clicking continue will close this window and enable the Approve/Deny button on the placement menu.
                    <br />
                    <img src="../pics/continue.gif" border="0">
                </a>
                <br />
            </td>
        </tr>
    </table>

</cfsavecontent>

<cfsavecontent variable="closeLink">

    <table width="800" border="0" cellpadding="2" cellspacing="2" class="section"  align="Center" bgcolor="##D6F9D5">
        <tr>
            <Td align="center">
			    <a href="javascript:window.close()"><img src="../pics/close.gif" border="0"><br /></a>
            </td>
        </tr>
    </table>

</cfsavecontent>

<cfsavecontent variable="openPrint">

    <body onLoad="print();">
    	<!----
			<table width="800" border="0" cellpadding="2" cellspacing="2" class="section"  align="Center" bgcolor="##D6F9D5">
				<tr>
					<td width=50%>PRINTED: #DateFormat(now(), 'mmm. d, yyyy')# at #TimeFormat(now(), 'HH:mm')# by #CLIENT.name#</td>
					<td align="right"><a href="PlacementInfoSheet.cfm?uniqueID=#qGetStudentInfo.uniqueID#&showemail"><img src="../pics/email.gif" border="0" alt=" Email "></a></td>
				</tr>
			</table>
		---->
	</body>
	
</cfsavecontent>

<!--- Save Email Option as Link --->
<cfsavecontent variable="emailLink">

    <form name="PlacementInfoSheet.cfm" method="post">
        <input type="hidden" name="submitted" value="1" />
        <input type="hidden" name="uniqueID" value="#qGetStudentInfo.uniqueID#" />
        <input type="hidden" name="profileType" value="email" />
        
        <table width="810px" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" style="margin-bottom:10px;">
            <tr><th colspan="2">Email/Print PIS</th></tr>
			<!--- Display Errors --->
            <cfif VAL(ArrayLen(Errors.Messages))>
                <tr>
                    <td>
                        <p style="color:##FF0000">Please review the following items: </p>
                        <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                            #Errors.Messages[i]# <br />  	
                        </cfloop> 
                    </td>
                </tr>
            </cfif>	
            <tr>	
                <td align="Center" valign="center">
                    Send this PIS to: &nbsp; <input type="text" name="emailTo" value="#qIntlRep.email#" size="30" maxlength="100" />			
                </td>
                <td calign="Center">
                    <input name="Submit" type="image" src="../pics/submit.gif" border="0" alt=" Send Email ">
                    &nbsp; &nbsp; &nbsp;
                    <input type="image" value="close window" src="../pics/close.gif" alt=" Close this Screen " onClick="javascript:window.close()">
                    &nbsp; &nbsp; &nbsp;
                    <a href="PlacementInfoSheet.cfm?uniqueID=#qGetStudentInfo.uniqueID#&print=1"><img src="../pics/print.png"  border="0" alt=" Print "></a>
                </td>
            </tr>
            <tr>
           		<td align="right">Do you want to add a message?</td>
                <td>
                    <input type="radio" name="showAddInfo" id="showAddInfoYes" value="1" checked="no" onClick="document.getElementById('showAddInfo').style.display='table-row';"/> 
                    <label for="showAddInfoYes">Yes</label>
                    
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    
                    <input type="radio" name="showAddInfo" id="showAddInfoNo" value="0" checked='yes' onClick="document.getElementById('showAddInfo').style.display='none';" /> 
                    <label for="showAddInfoNo">No</label>
                </td>
            </tr>
            <tr>	
                <td valign="top" id="showAddInfo"  style="display: none;" colspan=4>
                    Additional Info: &nbsp; <textarea name="addInfo" cols="48" rows="5"></textarea>
                </td>
            </tr>
		</table>
        
    </form>
    


	<!----Only allow Josh-1, Brian-12313, Marcus - 510, Bill - 8731, Bob - 8743, Gary -12431 to change the dates---->
    <cfif IsDate(qGetStudentInfo.datePlaced) AND listFind("1,12313,510,8731,8743,12431", CLIENT.userID)>		

        <form name="PlacementInfoSheet.cfm" method="post">
            <input type="hidden" name="submitted" value="1" />
            <input type="hidden" name="uniqueID" value="#qGetStudentInfo.uniqueID#" />
            <table width="810px" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" style="margin-bottom:10px;">
                 <tr><th colspan="2">Update Placement Date</th></tr>
                 <tr>	
                    <td class="subTitleRight">Current Date:</td>
                    <td class="subTitleLeft">#DateFormat(qGetStudentInfo.datePlaced, 'mm/dd/yyyy')#</td>
                </tr>
				<tr>	
                    <td class="subTitleRight">New Date: </td>
                    <td class="subTitleLeft"><input name="NewDatePlaced" type="text" value="#DateFormat(FORM.NewDatePlaced, 'mm/dd/yyyy')#" class="datePicker"></td>
                </tr>
                <tr>
                	<td colspan="2" align="center">
                    	<input name="Submit" type="image" src="../pics/submit.gif" border="0" alt=" Update Placement Date ">
                    </td>
                </tr>
			</table>
	    </form>

    </cfif>

      
</cfsavecontent>

<!----Save profile as variable---->
<cfsavecontent variable="PlacementInfo">
	
    <link rel="stylesheet" href="../linked/css/student_profile.css" type="text/css">
    
    <table class="profileTable" align="center">
        <tr>
            <td>
    
				<!--- Header --->
                <table align="center">
                    <tr>
                        <td class="bottom_center" width="800"  valign="top">
                            <img src="../pics/#CLIENT.companyid#_short_profile_header.jpg" />
                            <span class="title"><font size=+1>Placement Information for</font></span><font size=+1>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#</font><font size=+1> (###qGetStudentInfo.studentID#)</font><br />
                            <span class="title">Facilitator:</span>  #qGetFacilitator.firstname# #qGetFacilitator.lastname# 
                        </td>
                    </tr>	
                </table>
				<cfif totalfam eq 1>
                    <div class="alert" align="Center">
                    	<h3>Single Person Placement </h3>
                    </div>
                </cfif>
				<cfif VAL(qGetStudentInfo.doubleplace)>
                    <div class="alert" align="Center">
                    	<h3>Double Placement: Two exchange students will be living with this host family. </h3>
                    </div>
                </cfif>
                
				<cfif qGetStudentInfo.isWelcomeFamily EQ 1>	
                    <div class="alert" align="Center">
                        <h3>This is a welcome family.  Permanent family information will be sent shortly.</h3>
                    </div>
				</cfif>
                
				<cfif VAL(qGetHistory.isRelocation)>
                    <div class="alert" align="Center">
                        <h3>This is a relocation. The student will be moving to this host family and/or school shortly.</h3>
                    </div>
                </cfif>
    
				<!--- Student Information #qGetStudentInfo.countryresident# --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=5 align="center"><img src="../pics/HFbanner.png" /></Td>
                    </tr>
                    <tr>
                        <td valign="top">
    
							<!---Host Family Information---->
                            <table>
								<cfif LEN(qGetHostFamily.fatherfirstname)>
	                                <tr>
                                    	<td width="100"><span class="title">Host Father:</span></td>
                                        <td width="250">
                                            #qGetHostFamily.fatherfirstname# #qGetHostFamily.fatherlastname#, 
                                            <cfif IsDate(qGetHostFamily.fatherDOB)>
                                                (#DateDiff('yyyy', qGetHostFamily.fatherDOB, now())#)
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                    	<td><span class="title">Occupation:</span></td>
                                        <td>#qGetHostFamily.fatherworktype#</td>
                                    </tr>
								</cfif>
                                
                                <tr><td>&nbsp;</td></tr>
                                
                                <cfif LEN(qGetHostFamily.motherfirstname)>
	                                <tr>
                                    	<td width="100"><span class="title">Host Mother:</span></td>
    	                            	<td width="250">
                                        	#qGetHostFamily.motherfirstname# #qGetHostFamily.motherlastname#, 
											<cfif IsDate(qGetHostFamily.motherDOB)>
                                                (#DateDiff('yyyy', qGetHostFamily.motherDOB, now())#)
                                            </cfif>
                                        </td>
									</tr>
                                	<tr>
                                    	<td><span class="title">Occupation:</span></td>
		                                <td>#qGetHostFamily.motherworktype#</td>
                                    </tr>
								</cfif>
                            </table>
    				
                    	</td>
    
                        <td valign="top">
                        
							<!----Address & Contact Info----> 
                            <Table>
                                <tr>
                                	<td width="100" valign="top"><span class="title">Address:</span></td>
	                                <td>
                                    	#qGetHostFamily.address#<br />
    		                            <a href="http://en.wikipedia.org/wiki/#qGetHostFamily.city#,_#qGetHostFamily.state#" target="_blank" class="wiki">#qGetHostFamily.city# #qGetHostFamily.state# </a>, #qGetHostFamily.zip#
									</td>
                                </tr>
                                <tr>
	                                <td width="100" valign="top"><span class="title">Phone: </span></td>
                                    <td>#qGetHostFamily.phone#</td>
                                </tr>
                                <tr>
                                	<td width="100" valign="top"><span class="title">Email: </span></td>
                                    <td>#qGetHostFamily.email#</td>
                                </tr>
                               
                                <tr>
                                	<td width="100" valign="top"><span class="title">Placed: </span></td>
                                    <td>#DateFormat(qGetStudentInfo.datePlaced, 'mmmm d, yyyy')#</td>
                                </tr>
								
                            </table>
    
                        </td>
                    </tr>                
				</table>
                
				<!----Siblings and Pets---->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <Td><img src="../pics/sib.png" /></Td>
                        <td><img src="../pics/pets.png" /></td>
                        <td><img src="../pics/interest.png" /></td>
                    </tr>
                    <tr>
                        <td valign="top" width=40%>
                    
							<!---Siblings---->
                            <table width="100%" align="Center">
                                <tr>
                                    <td><span class="title">Name</span><br /></td>
                                    <td align="center"><span class="title">Age</span><br /></td>
                                    <td align="center"><span class="title">Sex</span><br /></td>
                                    <td align="center"><span class="title">At home</span><br /></td>
                                    <td align="center"><span class="title">Relation</span><br /></td>
                                </tr>
                            	<cfloop query="qGetHostChildren">
                                    <tr>
                                        <td>
                            				<cfset maxwords = 1>
                                            #REReplace(qGetHostChildren.name,"^(#RepeatString('[^ ]* ',maxwords)#).*","\1")#
											<Cfif shared is 'yes'>
                                            	<img src="https://ise.exitsapplication.com/nsmg/pics/share.jpg" height="20" border="0"/>
											</Cfif>
                            			</td>
                                        <td align="center">
											<cfif IsDate(qGetHostChildren.birthdate)>
                                            	#DateDiff('yyyy', qGetHostChildren.birthdate, now())#
											<cfelse>
                                            	n/a
											</cfif>
                                        </td>
                                        <td align="center">#qGetHostChildren.sex#</td>
                                        <td align="center">#qGetHostChildren.liveathome#</td>
                                        <td align="center">#qGetHostChildren.membertype#</td>
                                    </tr>
                                </cfloop>
                            </table>
                            
                        </td>
    
                        <td valign="top">
                        
							<!----Animals---->
                            <Table align="Center">
                            <tr>
                                <td align="center"><span class="title">Type</span></td>
                                <td align="center"><span class="title">Number</span></td>
                                <td align="center"><span class="title">Indoor</span></td>
                            </tr>
                            <cfloop query="qGetHostPets">
                                <tr>		
                                    <td>#qGetHostPets.animaltype#</td>
                                    <td align="center">#qGetHostPets.number#</td>
                                    <td align="center">#qGetHostPets.indoor#</td>
                                </tr>
                            </cfloop>
                            </table>
    
                        </td>

                        <td valign="top">

							<!----Interests---->
                            <Table align="Center">
                                <tr>
                                    <td>
										#interestHostList#                                    
                                    </td>
                                </tr>
                            </table>
    
                        </td>
                    </tr>                
                </table>
    
				<!--- Community Information --->
                <table align="center" class="profileTable2" width="100%">
                    <tr bgcolor="##0854a0" align="center" ><img src="../pics/CIinfo.png" /></td></tr>     
                    <tr>
                        <td>
							<cfif LEN(qGetHostFamily.community)>
                                The community is #qGetHostFamily.community#
                            </cfif>
                                
                            <cfif qGetHostFamily.community is 'small'>town</cfif>.
                            
							<cfif LEN(qGetHostFamily.nearbigcity)>
                            	The nearest big city is <a href="http://en.wikipedia.org/wiki/#qGetHostFamily.nearbigcity#" target="_blank" class="wiki">#qGetHostFamily.nearbigcity# </a> is #qGetHostFamily.near_city_dist# miles away.
							</cfif>
                            
							<cfif LEN(qGetHostFamily.major_air_code)>
                            	The Closest arrival airport is <a href="http://www.airnav.com/airport/K#qGetHostFamily.major_air_code#" target="_blank" class="airport">#qGetHostFamily.major_air_code#</A>
	                            <cfif LEN(qGetHostFamily.airport_city)>
                                	, in the city of  <a href="http://en.wikipedia.org/wiki/#qGetHostFamily.airport_city#" target="_blank" class="wiki">#qGetHostFamily.airport_city# </a> 
								</cfif>                            
                            </cfif>
                            
                            <br /><br />
                            
							<cfif LEN(qGetHostFamily.pert_info)>Points of interest in the community: #qGetHostFamily.pert_info#</cfif>
                        </td>
                    </tr>
                </table>
    
                <table align="center" class="profileTable2" width="100%">
                    <tr bgcolor="##0854a0" align="center" ><img src="../pics/schoolinfo.png" /></td></tr>            
                    <tr>
                        <td valign="top">
                        
                   			<!---School Dates---->
                            <table>
								<cfif LEN(qGetSchool_dates.enrollment)>
                                    <Tr>
                                        <td><span class="title">Orientation</span></td>
                                        <td>
                                            <cfif IsDate(qGetSchool_dates.enrollment)>
                                                #DateFormat(qGetSchool_dates.enrollment, 'mmmm d, yyyy')#
                                            <cfelse>
                                                Not Available
                                            </cfif>
                                        </td>
                                    </Tr>
                                </cfif>
                                <Tr>
                                    <td><span class="title">1<sup>st</sup> Semester Begins:</span></td>
                                    <td>
										<cfif IsDate(qGetSchool_dates.year_begins)>
                                        	#DateFormat(qGetSchool_dates.year_begins, 'mmmm d, yyyy')#
										<cfelse>
											Not Available
										</cfif>
									</td>
                                </Tr>
                                <Tr>
                                    <td><span class="title">1<sup>st</sup> Semester Ends:</span></td>
                                    <td>
										<cfif IsDate(qGetSchool_dates.semester_ends)>
                                        	#DateFormat(qGetSchool_dates.semester_ends, 'mmmm d, yyyy')#
										<cfelse>
                                        	Not Available
										</cfif>                                    
                                    </td>
                                </Tr>
                                <Tr>
                                    <td><span class="title">2<sup>nd</sup> Semester Begins:</span></td>
                                    <td>
										<cfif IsDate(qGetSchool_dates.semester_begins)>
                                        	#DateFormat(qGetSchool_dates.semester_begins, 'mmmm d, yyyy')#
										<cfelse>
                                        	Not Available
										</cfif>
                                    </td>
                                </Tr>
                                <Tr>
                                	<td><span class="title">Year Ends:</span></td>
                                    <td>
										<cfif IsDate(qGetSchool_dates.year_ends)>
                                        	#DateFormat(qGetSchool_dates.year_ends, 'mmmm d, yyyy')#
										<cfelse>
                                        	Not Available
										</cfif>
                                    </td>
                                </Tr>
                            </table>
                            
                        </td>
                        <td valign="top">
                        
							<!---- School Address & Contact Info---->
                            <Table>
                                <Tr>
                                
                                <tr>
                                	<td valign="top"><span class="title">Name:</span></td>
                                    <td><a href="#qGetSchool.url#">#qGetSchool.schoolname#</a></td>
                                </tr>
                                <tr>
                                	<td width="100" valign="top"><span class="title">Address:</span></td>
                                	<td>
                                    	#qGetSchool.address#
										<cfif LEN(qGetSchool.address2)>
                                        	<br />#qGetSchool.address2#
										</cfif>
                                
		                                <a href="http://en.wikipedia.org/wiki/#qGetSchool.city#,_#qGetSchool.state#" target="_blank" class="wiki">
                                        	#qGetSchool.city#, #qGetSchool.state# 
                                        </a>, 
                                        
                                        #qGetSchool.zip#
                                    </td>
                                </tr>
                                <tr>
                                    <td width="100" valign="top"><span class="title">Phone: </span></td>
                                    <td>#qGetSchool.phone#</td>
                                </tr>
                                <tr>
                                    <td width="100" valign="top"><span class="title">Contact: </span></td>
                                    <td><a href="#qGetSchool.url#">#qGetSchool.principal#</a></td>
                                </tr>
                            </table>
    
                        </td>
                    </tr>
                    
					<cfif LEN(qGetHostFamily.schoolcosts)>
                        <Tr>
                            <Td colspan=2>The student is responsible for the following expenses: #qGetHostFamily.schoolcosts#</Td>
                        </Tr>
                    </cfif>
                </table>
    
                <table width="800">
                    <Tr>
                        <Td width="100%" valign="top">
                    		
                            <!--- Area Representative --->
                            <table align="center" width="100%">
                                <tr bgcolor="##0854a0"><td colspan=10 align="center" ><img src="../pics/ARbanner.png" /></td></tr>     
                                <tr>
	                                <td valign="top"><span class="title">Name:</span></td>
                                    <Td valign="top">#qGetAreaRep.firstname# #qGetAreaRep.lastname#</Td>
                                    <td  valign="top"><span class="title">Address:</span></td>
                                    <Td valign="top">
                                    	#qGetAreaRep.address#<br />
		                                <Cfif LEN(qGetAreaRep.address2)>#qGetAreaRep.address2#<br /></Cfif>
		                                #qGetAreaRep.city# #qGetAreaRep.state#, #qGetAreaRep.zip#
                                    </Td>
                                	<td  valign="top"><span class="title">Phone:</span></td>
                                    <Td valign="top">#qGetAreaRep.phone#</Td>
                                </tr>
                                <tr>
                                <td colspan="4"></td>
                                <td  valign="top"><span class="title">Email:</span></td>
                                <td  valign="top">#qGetAreaRep.email#</td>
                        	</table>
   
    					</Td>
    				</Tr>
                    
                    <tr>
                        <td  valign="top">
                        
                            <table align="center" width="100%"  >
                                <tr bgcolor="##0854a0"><td colspan=10 align="center" ><img src="../pics/addinfo.png" /></td></tr>     
                                <tr>
                                    <td>
										<cfif LEN(qGetStudentInfo.placement_notes)>#qGetStudentInfo.placement_notes#<br /><br /></cfif>		
                                        
                                        <cfif NOT VAL(qGetHistory.isRelocation)>
                                            The student should plan to arrive within five days from start of school. Please advise us of 
                                            #qGetStudentInfo.firstname#'s arrival information as soon as possible. Please upload flight information through EXITS.
                                        </cfif><br />
                                        
                                    </td>
                                </tr>
                            </table>
    
    					</td>
                    </tr>
                </table>
                
            </td>
        </tr>
    </table>
    
    <div align="center">
        <img src="https://ise.exitsapplication.com/nsmg/pics/share.jpg" height="20"> Sharing a Room &nbsp;&middot;&nbsp; 
        <img src="https://ise.exitsapplication.com/nsmg/pics/Airport-icon.png" height="16"> Airport Information &nbsp;&middot;&nbsp;
        <img src="https://ise.exitsapplication.com/nsmg/pics/Wikipedia-Globe-icon.png" height="16"> Wikipedia Information 
    </div>

</cfsavecontent>


<!--- Display Profile / Email Form --->
<cfswitch expression="#profileType#">
	
    <!--- Web Profile --->
	<cfcase value="web">
		<!--- Include PIS Template --->
        #PlacementInfo#
    </cfcase>

    <!--- Email Profile --->
	<cfcase value="email">
		
        <!--- Email FORM --->
        <link rel="stylesheet" type="text/css" href="../smg.css">
        
		<!--- FORM Submitted --->
        <cfif FORM.submitted AND NOT VAL(ArrayLen(Errors.Messages))>
        	
            <!--- Set Date Emailed --->
            <cfif NOT isDate(qGetStudentInfo.datePISEmailed)>
            
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_students
                    SET
						datePISEmailed = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        studentID = <cfqueryparam cfsqltype="integer" value="#qGetStudentInfo.studentID#">                 	
                </cfquery>
            
            </cfif>
            
            <cfsavecontent variable="PlacementInfo">
                <!--- Include PIS Template --->
                #PlacementInfo#
            </cfsavecontent>
            
            <cfsavecontent variable="emailMessage">
                <p>We are pleased to give you the placement information and ID Card for  #qGetStudentInfo.firstName# #qGetStudentInfo.familylastName# (###qGetStudentInfo.studentid#).  Both files are attached. </p>
                <p>If, for any reason, you are unable to view the files, you can reprint them by logging into EXITS, navigate to the Students Profile and look under the section "Letters".   </p>
                 
                <Cfif LEN(FORM.addInfo)>
                	<p>Additional Info: #FORM.addInfo#</p>
                </Cfif>
                
                <p>
                    Thank you, <br />
                    #qGetCompany.companyName#   
                </p>        
            </cfsavecontent>
            
            <!--- Create PDF File - Include Profile and Letters --->
            <cfdocument name="profile" format="pdf">
	            <!--- Include PIS Template --->
                #PlacementInfo#	
            </cfdocument>
            
            <!--- Save PDF File --->
            
            <cffile action="write" file="#APPLICATION.PATH.TEMP##qGetStudentInfo.studentID#-placementInfo.pdf" output="#profile#" nameconflict="overwrite">    
            
            <cfdocument filename="#APPLICATION.PATH.TEMP##qGetStudentInfo.studentID#-idCard.pdf" format="PDF" backgroundvisible="yes" overwrite="yes" fontembed="yes" localurl="no">

                <cfscript>
					// FORM.pr_id and FORM.report_mode are required for the progress report in print mode.
					// FORM.pdf is used to not display the logo which isn't working on the PDF. 
					URL.studentID = qGetStudentInfo.studentID;
					FORM.report_mode = 'print';
					FORM.pdf = 1;
				</cfscript>
                
                <cfinclude template="../reports/labels_student_idcards.cfm">
       	 	</cfdocument>
            
            <!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#FORM.emailTo#">
                <cfinvokeargument name="email_cc" value="#CLIENT.email#">
                <cfinvokeargument name="email_subject" value="Placement Information for #qGetStudentInfo.firstName# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)">
                <cfinvokeargument name="email_message" value="#emailMessage#">
                <cfinvokeargument name="email_from" value="""#qGetCompany.companyshort_nocolor# - #qGetFacilitator.firstname# #qGetFacilitator.lastname#"" <#qGetFacilitator.email#>">
                <!--- Attach Students Profile  --->
                <cfinvokeargument name="email_file" value="#APPLICATION.PATH.temp##qGetStudentInfo.studentID#-placementInfo.pdf">
         		<!----Attach the ID Card---->       
                <cfinvokeargument name="email_file2" value="#APPLICATION.PATH.temp##qGetStudentInfo.studentID#-idCard.pdf">
            </cfinvoke>
        
            <script language="JavaScript">
				// Close Window
				<!--
				  window.close();
				//-->
            </script>
        
        </cfif>
    
	</cfcase>    
    
    <!--- Web Profile --->
    <cfdefaultcase>
    
		<!----Include Email Link at top---->
        <cfif NOT LEN(URL.print)>
        
			<cfif ListFind("1,2,3,4", CLIENT.usertype)>
                #emailLink#
			</cfif>
            
        <cfelse>
            #openPrint#
        </cfif>

		<!--- Include PIS Template --->
        #PlacementInfo#
        
    	<cfif isDefined('URL.approve')>
	         #approveLink#
    	<cfelse>
			#closeLink#
		</cfif>
        
    </cfdefaultcase>

</cfswitch>

</cfoutput>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

