<!--- ------------------------------------------------------------------------- ----
	
	File:		PlacementInfoSheetDay.cfm
	Author:		Marcus Melo
	Date:		September 9th, 2011
	Desc:		Web Version of Placement Info Sheet

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param URL Variables --->    
    <cfparam name="URL.uniqueID" default="">
    <cfparam name="URL.assignedID" default="">
    <cfparam name="URL.pisAction" default="">
    
    <!--- Param FORM Variables --->    
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.uniqueID" default="">
    <cfparam name="FORM.assignedID" default="">
    <cfparam name="FORM.pisAction" default="displayPIS">
    <cfparam name="FORM.emailTo" default="">
    <cfparam name="FORM.emailAdditionalInfo" default="">

    <cfscript>
		// Check if there is a valid URL variable
		if ( LEN(URL.uniqueID) ) {
			FORM.uniqueID = URL.uniqueID;
		}
		
		// Check if there is a valid URL variable
		if ( VAL(URL.assignedID) ) {
			FORM.assignedID = URL.assignedID;
		}

		// Check if there is a valid URL variable
		if ( LEN(URL.pisAction) ) {
			FORM.pisAction = URL.pisAction;
		}

		// Get Student Information by uniqueID
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=FORM.uniqueID, assignedID=VAL(FORM.assignedID));
		
		// Get Program
		qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programID=qGetStudentInfo.programID);
		
		// Get Host Family
		qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=qGetStudentInfo.hostID);
		
		// Host Family Children
		qGetHostChildren = APPLICATION.CFC.HOST.getHostMemberByID(hostID=qGetStudentInfo.hostID);
		
		// Host Family Pets
		qGetHostPets = APPLICATION.CFC.HOST.getHostPets(hostID=qGetStudentInfo.hostID);

		// Get Host Interests
		qGetHostInterests = APPLICATION.CFC.LOOKUPTABLES.getInterest(interestID=qGetHostFamily.interests,limit=6);
		
		// set Interest List
		interestHostList = ValueList(qGetHostInterests.interest, "<br />");

		// School
		qGetSchool = APPLICATION.CFC.SCHOOL.getSchools(schoolID=qGetStudentInfo.schoolID);

		// Get School Dates
		qGetSchoolDates = APPLICATION.CFC.SCHOOL.getAllSchoolDateInformation(schoolID=qGetStudentInfo.schoolID, programID=VAL(qGetStudentInfo.programID));

		// Get School Facilitator
		qGetFacilitator = APPLICATION.CFC.USER.getUsers(userID=qGetSchool.fk_ny_user);

		// Get Area Representative
		qGetAreaRepresentative = APPLICATION.CFC.USER.getUsers(userID=qGetStudentInfo.areaRepID);

		// Get International Representative
		qIntlRep = APPLICATION.CFC.USER.getUsers(userID=qGetStudentInfo.intrep);
		
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {

			// Data Validation
			if ( NOT IsValid("email", FORM.emailTo) ) {
				SESSION.formErrors.Add("Please enter a valid email address");
			}
			
			if ( NOT SESSION.formErrors.length() ) {
				
				// Set Page Message
				SESSION.pageMessages.Add("Email Successfully Submitted.");
				
			} else {
				
				// There is an error trying to email PIS, set pisAction to web
				FORM.pisAction = 'displayPIS';
				
			}

		} else {
			
			FORM.emailTo = qIntlRep.php_contact_email;
			
		}
	</cfscript>
	
</cfsilent>

<cfoutput>
    
	<!--- Save Email Option as Link --->
    <cfsavecontent variable="emailForm">

        <form name="emailPIS" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" style="margin:0px;">
            <input type="hidden" name="submitted" value="1" />
            <input type="hidden" name="uniqueID" value="#FORM.uniqueID#" />
            <input type="hidden" name="assignedID" value="#FORM.assignedID#" />
            <input type="hidden" name="pisAction" value="emailPIS" />
            
            <table class="placementLetterTable" align="center">
                <tr>
                    <td class="placementLetterBlueplacementLetterDetail">
                        Email Placement Information Sheet
                    </td>
                </tr>                                                    
                <tr>	
                    <td width="40%" align="right">
                        Send this placement information sheet to: 			
                    </td>
                    <td width="60%">
                        <input type="text" name="emailTo" value="#FORM.emailTo#" class="xLargeField" maxlength="100" />
                    </td>
                </tr>
                <tr>
                    <td align="right">Would you like to add a message?</td>
                    <td>
                        <input type="radio" name="showAddInfo" id="showAddInfoYes" value="1" checked="no" onClick="document.getElementById('showAddInfo').style.display='table-row';"/> 
                        <label for="showAddInfoYes">Yes</label>
                        
                        <input type="radio" name="showAddInfo" id="showAddInfoNo" value="0" checked='yes' onClick="document.getElementById('showAddInfo').style.display='none';" /> 
                        <label for="showAddInfoNo">No</label>
                    </td>
                </tr>
                <tr id="showAddInfo" class="displayNone">	
                    <td align="right" valign="top">
                        Additional Information:
                    </td>
                    <td>
                        <textarea name="emailAdditionalInfo" class="xLargeTextArea">#FORM.emailAdditionalInfo#</textarea>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <input name="Submit" type="image" src="../pics/submit.gif" border="0" alt=" Send Email ">
                        &nbsp; &nbsp; &nbsp;
                        <input type="image" value="close window" src="../pics/close.gif" alt=" Close this Screen " onClick="javascript:window.close()">
                        &nbsp; &nbsp; &nbsp;
                        <a href="http://#CGI.HTTP_HOST#/#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#&pisAction=printPIS">
                            <img src="../pics/print.png" border="0" alt=" Print ">
                        </a>
                    </td>
                </tr>
            </table>
            
        </form>
        
    </cfsavecontent>

    <!---Save profile as variable--->
    <cfsavecontent variable="PlacementInfo">

        <table class="placementLetterTable" align="center">
			<!--- Header --->
            <tr>
                <td align="center">
                    <img src="../../images/#CLIENT.companyID#_short_profile_header.jpg" width="790" height="170" />
                </td>
            </tr>
            <tr>
                <td align="center">
                    <span class="placementLetterplacementLetterDetail">Placement Information for</span>
                    <span class="placementLetterInformation">#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)</span>
                </td>
            </tr>
            <tr>
                <td>
                    <p style="margin-top:5px;">We are pleased to give you the placement information for #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#).</p>
                    
                    <cfif VAL(qGetFacilitator.recordCount)>
                        <p style="margin-bottom:5px;">
                            Please note for the Agent and Student, the Main Office Student Services Facilitator will be #qGetFacilitator.firstName# #qGetFacilitator.lastName#. <br />              
                            You may contact this person by email at <a href="mailto:#qGetFacilitator.email#">#qGetFacilitator.email#</a>
                        </p>
                    </cfif>
                </td>
            </tr>  
            <!--- Host Family --->
            <tr class="placementLetterBlueplacementLetterDetail"><td><img src="../pics/pisHostFamily.png" /></td></tr> 
            <tr>
                <td>                

                    <table cellpadding="2" cellspacing="0" align="center" class="placementLetterTableNoBorder">
                        <tr>
                        	<!--- Host Father --->
                            <td width="13%"><span class="placementLetterDetail">Host Father:</span></td>
                            <td width="42%">
								<cfif LEN(qGetHostFamily.fatherfirstname)>
                                    #qGetHostFamily.fatherfirstname# #qGetHostFamily.fatherlastname#, 
                                    <cfif IsNumeric(qGetHostFamily.fatherBirth)>
                                        (#Year(now())-qGetHostFamily.fatherBirth#)
                                    </cfif>
                                <cfelse>
                                	n/a
                                </cfif>
                            </td>
                            <!--- Address --->
                            <td width="10%"><span class="placementLetterDetail">Address:</span></td>
                            <td width="35%">
                                #qGetHostFamily.address#
                            </td>
                        </tr>
                        <tr>
                        	<!--- Host Father --->
                            <td><span class="placementLetterDetail">Occupation:</span></td>
                            <td>
                            	<cfif LEN(qGetHostFamily.fatherfirstname)>
                            		#qGetHostFamily.fatherworktype#
								<cfelse>
                                	n/a
                                </cfif>
                            </td>
                            <td><span class="placementLetterDetail"></span></td>
                            <td>
	                            <a href="http://en.wikipedia.org/wiki/#qGetHostFamily.city#,_#qGetHostFamily.state#" target="_blank" class="placementLetterWikipedia">#qGetHostFamily.city#, #qGetHostFamily.state#</a> #qGetHostFamily.zip#
                          	</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <!--- Phone --->
                            <td><span class="placementLetterDetail">Phone:</span></td>
                            <td>#qGetHostFamily.phone#</td>
                        </tr>
                        <tr>
                        	<!--- Host Mother --->
                            <td><span class="placementLetterDetail">Host Mother:</span></td>
                            <td>
								<cfif LEN(qGetHostFamily.motherfirstname)>
                                    #qGetHostFamily.motherfirstname# #qGetHostFamily.motherlastname#, 
                                    <cfif IsNumeric(qGetHostFamily.motherBirth)>
                                        (#Year(now())-qGetHostFamily.motherBirth#)
                                    </cfif>
                                <cfelse>
                                	n/a
                                </cfif>
                            </td>
                            <!--- Email --->
                            <td><span class="placementLetterDetail">Email:</span></td>
                            <td>#qGetHostFamily.email#</td>
                        </tr>
                        <tr>
                            <td><span class="placementLetterDetail">Occupation:</span></td>
                            <td>
                            	<cfif LEN(qGetHostFamily.motherfirstname)>
                            		#qGetHostFamily.motherworktype#
								<cfelse>
                                	n/a
                                </cfif>
                            </td>
                            <!--- Placed --->
                            <td><span class="placementLetterDetail">Placed:</span></td>
                            <td> #DateFormat(qGetStudentInfo.datePlaced, 'mmmm d, yyyy')#</td>
                        </tr>
					</table>
                
                </td>
            </tr>                
            <tr>
                <td>
                 
					<!--- Siblings / Pets / Interests --->
                    <table cellpadding="2" cellspacing="0" align="center" class="placementLetterTableNoBorder">
                        
                        <tr class="placementLetterBlueplacementLetterDetail">
                            <td><img src="../pics/pisSiblings.png" /></td>
                            <td><img src="../pics/pisPets.png" /></td>
                            <td><img src="../pics/pisInterests.png" /></td>
                        </tr> 
                        <tr>
                        	<td valign="top">
								
                                <!--- Siblings --->
                                <table cellpadding="2" cellspacing="0" align="center" class="placementLetterTableNoBorder">
                                    <tr>
                                        <td><span class="placementLetterDetail">Name</span><br /></td>
                                        <td align="center"><span class="placementLetterDetail">Age</span><br /></td>
                                        <td align="center"><span class="placementLetterDetail">Sex</span><br /></td>
                                        <td align="center"><span class="placementLetterDetail">At home</span><br /></td>
                                        <td align="center"><span class="placementLetterDetail">Relation</span><br /></td>
                                    </tr>
                                    <cfloop query="qGetHostChildren">
                                        <tr>
                                            <td>
                                                #REReplace(qGetHostChildren.name,"^(#RepeatString('[^ ]* ',1)#).*","\1")#
                                                <cfif qGetHostChildren.shared EQ 'yes'>
                                                    <img src="../pics/pisShareRoomIcon.png" height="16" border="0">
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
								
                                <!--- Animals --->
                                <table cellpadding="2" cellspacing="0" align="center" class="placementLetterTableNoBorder">
                                    <tr>
                                        <td align="center"><span class="placementLetterDetail">Type</span></td>
                                        <td align="center"><span class="placementLetterDetail">Number</span></td>
                                        <td align="center"><span class="placementLetterDetail">Indoor</span></td>
                                    </tr>
                                    <cfloop query="qGetHostPets">
                                        <tr>		
                                            <td align="center">#qGetHostPets.animaltype#</td>
                                            <td align="center">#qGetHostPets.number#</td>
                                            <td align="center">#qGetHostPets.indoor#</td>
                                        </tr>
                                    </cfloop>
                                </table>
                                
                            </td>
                        	<td valign="top">
                            
                            	<!--- Interests --->
                                <table cellpadding="2" cellspacing="0" class="placementLetterTableNoBorder">
                                    <tr>
                                        <td align="center">
                                            #interestHostList#                                    
                                        </td>
                                    </tr>
                                </table>
                            
                            </td>
                        </tr>
                        
					</table>
                    
                    <table cellpadding="2" cellspacing="0" align="center" class="placementLetterTableNoBorder">
                        <!--- Other Interests --->
                        <cfif LEN(qGetHostFamily.interests_other)>
                            <tr>
                                <td width="13%" valign="top"><span class="placementLetterDetail">Other Interests:</span></td>
                                <td width="87%">
    								#qGetHostFamily.interests_other#
                                </td>
                            </tr>
                        </cfif>
                        
						<!--- Smoke Information --->
                        <cfif NOT  qGetHostFamily.acceptSmoking EQ 'yes'>
                            <tr>
                                <td colspan="2"><p style="margin:3px 0px 0px 0px;">The Host Family will accept a student who smokes.</p></td>       
                            </tr>
                        </cfif>      
                        
                        <!--- Church Information --->
                        <cfif qGetHostFamily.attendChurch EQ 'yes'>
                            <tr>
                                <td colspan="2">
                                    <p style="margin:3px 0px 5px 0px;">
                                        Host Family attends church 
                                        
                                        <cfswitch expression="#qGetHostFamily.religious_participation#">
                                        
                                            <cfcase value="active">
                                                several times per week.
                                            </cfcase>
                
                                            <cfcase value="average">
                                                once per week.
                                            </cfcase>
                
                                            <cfcase value="little interest">
                                                occasionally.
                                            </cfcase>
                
                                        </cfswitch>                            
                                        
                                        <cfif qGetHostFamily.churchfam EQ 'no'> The student will be expected to attend church.</cfif>
                                    </p>
                                </td>       
                            </tr>
                        </cfif>        
					</table>                    
                    
                </td>
            </tr>            
              
            <!--- Community Information --->
            <!---
			<tr class="placementLetterBlueplacementLetterDetail"><td><img src="../pics/pisCommunity.png" /></td></tr> 
			--->
                          	
            <!--- School Address & Contact Info --->    
            <tr class="placementLetterBlueplacementLetterDetail"><td><img src="../pics/pisSchool.png" /></td></tr> 
            <tr>
                <td> 
                     
                    <table cellpadding="2" cellspacing="0" align="center" class="placementLetterTableNoBorder">
                        <tr>
                            <td colspan="4">
                                <p style="margin:3px 0px 5px 0px;">The student will attend the following school:</p>
                            </td>
                        </tr>                 
                        <tr>
                            <td width="13%"><span class="placementLetterDetail">Name:</span></td>
                            <td width="42%">#qGetSchool.schoolname#</td>
                            <td width="20%"><span class="placementLetterDetail">Orientation:</span></td>
                            <td width="25%">
                                <cfif IsDate(qGetSchoolDates.enrollment)>
                                    #DateFormat(qGetSchoolDates.enrollment, 'mmmm d, yyyy')#
                                <cfelse>
                                    Not Available
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="placementLetterDetail">Address:</span></td>  
                            <td>
                                #qGetSchool.address#
                                <cfif LEN(qGetSchool.address2)>
                                    <br />#qGetSchool.address2#
                                </cfif>
                            </td>  
                            <td><span class="placementLetterDetail">1<sup>st</sup> Semester Begins:</span></td>  
                            <td>
                                <cfif IsDate(qGetSchoolDates.year_begins)>
                                    #DateFormat(qGetSchoolDates.year_begins, 'mmmm d, yyyy')#
                                <cfelse>
                                    Not Available
                                </cfif>
                            </td>                     
                        </tr>                            
                        <tr>
                        	<td>&nbsp;</td>
                            <td>
                                <a href="http://en.wikipedia.org/wiki/#qGetSchool.city#,_#qGetSchool.stateName#" target="_blank" class="placementLetterWikipedia">
                                    #qGetSchool.city#, #qGetSchool.stateName#
                                </a> 
                                &nbsp; #qGetSchool.zip# 
                            </td>  
                            <td><span class="placementLetterDetail">1<sup>st</sup> Semester Ends:</span></td>  
                            <td>
                                <cfif IsDate(qGetSchoolDates.semester_ends)>
                                    #DateFormat(qGetSchoolDates.semester_ends, 'mmmm d, yyyy')#
                                <cfelse>
                                    Not Available
                                </cfif>                                    
                            </td>                     
                        </tr>                            
                        <tr>
                            <td><span class="placementLetterDetail">Phone:</span></td>  
                            <td>#qGetSchool.phone#</td>  
                            <td><span class="placementLetterDetail">2<sup>nd</sup> Semester Begins:</span></td>  
                            <td>
                                <cfif IsDate(qGetSchoolDates.semester_begins)>
                                    #DateFormat(qGetSchoolDates.semester_begins, 'mmmm d, yyyy')#
                                <cfelse>
                                    Not Available
                                </cfif>
                            </td>                     
                        </tr>                            
                        <tr>
                            <td><span class="placementLetterDetail">Contact:</span></td>  
                            <td>#qGetSchool.contact#</td>  
                            <td><span class="placementLetterDetail">Year Ends:</span></td>  
                            <td>
                                <cfif IsDate(qGetSchoolDates.year_ends)>
                                    #DateFormat(qGetSchoolDates.year_ends, 'mmmm d, yyyy')#
                                <cfelse>
                                    Not Available
                                </cfif>
                            </td>                     
                        </tr>
                        <tr>
                            <td colspan="4">
                                <p style="margin-top:5px; margin-bottom:5px;">
                                    <cfif LEN(qGetSchool.nearbigcity)>
                                        The nearest big city is <a href="http://en.wikipedia.org/wiki/#qGetSchool.nearbigcity#" target="_blank" class="placementLetterWikipedia">#qGetSchool.nearbigcity#</a>. &nbsp;
                                    </cfif> 
                                    The closest arrival airport is #qGetSchool.airport_city#, #qGetSchool.airport_state#
                                    <cfif LEN(qGetSchool.major_air_code)>
                                        <a href="http://www.airnav.com/airport/#qGetSchool.major_air_code#" target="_blank" class="placementLetterAirport">(#qGetSchool.major_air_code#)</a>
                                    </cfif>                             
                                </p>
                            </td>
                        </tr>                 
                    </table>
            
                </td>
            </tr>
            
            <!--- Area Representative --->
            <tr class="placementLetterBlueplacementLetterDetail"><td><img src="../pics/pisAreaRep.png" /></td></tr> 
            <tr>
                <td> 

                    <table cellpadding="2" cellspacing="0" align="center" class="placementLetterTableNoBorder">
                        <tr>
                            <td width="10%"><span class="placementLetterDetail">Name:</span></td>
                            <td width="45%">#qGetAreaRepresentative.firstName# #qGetAreaRepresentative.lastName#</td>
                            <td width="10%"><span class="placementLetterDetail">Address:</span></td>
                            <td width="35%">
                                #qGetAreaRepresentative.address#
                                <cfif LEN(qGetAreaRepresentative.address2)>
                                    <br />#qGetAreaRepresentative.address2#
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="placementLetterDetail">Phone:</span></td>  
                            <td>#qGetAreaRepresentative.phone#</td>  
                            <td>&nbsp;</td>  
                            <td>#qGetAreaRepresentative.city#, #qGetAreaRepresentative.state# #qGetAreaRepresentative.zip#</td>                     
                        </tr>    
                        <tr>
                            <td><span class="placementLetterDetail">Email:</span></td>  
                            <td>#qGetAreaRepresentative.email#</td>  
                            <td>&nbsp;</td>  
                            <td>&nbsp;</td>  
                        </tr>                            
                                                
            		</table>
                    
                </td>
            </tr>
            
            <!--- Student Information ---> 
            <tr class="placementLetterBlueplacementLetterDetail"><td><img src="../pics/pisStudentInfo.png" /></td></tr>  
            <tr>
                <td>
                    <p style="margin-top:5px;">Student is applying for the #qGetProgramInfo.programName# program starting in #DateFormat(qGetSchoolDates.year_begins, 'mmmm')#.</p>	
                    
                    <p style="margin-bottom:5px;">
                        We will be sending you the complete Host Family application shortly. The student should plan to arrive within five days from start of school. 
                        Please advise us of #qGetStudentInfo.firstname#'<cfif right(qGetStudentInfo.firstname, 1) NEQ 's'>s</cfif> arrival information as soon as possible.
                    </p>
                </td>
            </tr>
            
            <tr>
                <td align="center">
                    <div class="placementLetterButtons">
                    	<img src="../pics/pisShareRoomIcon.png" height="16"> Sharing a Room 
	                    &nbsp; &middot; &nbsp;
                        <img src="../pics/pisWikipediaIcon.png" height="16"> Wikipedia Information 
                        &nbsp; &middot; &nbsp;
                        <img src="../pics/pisAirportIcon.png" height="16"> Airport Information              
                    </div>
                </td>
            </tr>                    
        </table>
        
    </cfsavecontent>
        
        
	<!--- Display Profile / Email Form --->
    <cfswitch expression="#FORM.pisAction#">
		
        <!--- Print PIS --->
        <cfcase value="printPIS">

			<!--- Include CSS --->
            <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css">
        
            <!--- Include PIS Template --->
            #PlacementInfo#

            <!--- Include Print Information --->
            <table class="placementLetterTable" align="center">
                <tr>
                    <td>Printed on #DateFormat(now(), 'mmm. d, yyyy')# at #TimeFormat(now(), 'HH:mm')# by #CLIENT.firstName# #CLIENT.lastName#</td>
                </tr>
            </table>

            <script language="javascript">
				print();
                // Close Window After 5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 5000);
            </script>
            
        </cfcase>
        
        <!--- Email Profile --->
        <cfcase value="emailPIS">

            <cfsavecontent variable="emailMessage">
                <p>We are pleased to give you the placement information for  #qGetStudentInfo.firstName# #qGetStudentInfo.familylastName# (###qGetStudentInfo.studentid#).</p>
                <p>If, for any reason, you are unable to view the file, you can reprint them by logging into AXIS, navigate to the Students Profile and look under the section "Letters".</p>
                 
                <Cfif LEN(FORM.emailAdditionalInfo)>
                    <p>Additional Info: #FORM.emailAdditionalInfo#</p>
                </Cfif>
                
                <p>
                    Thank you, <br />
                    #CLIENT.companyName#   
                </p>        
            </cfsavecontent>

            <!--- Create PDF File - Include PIS --->
            <cfdocument name="placementInfoPDF" format="pdf">
                <!--- Include CSS --->
                <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css">

	            <!--- Include PIS Template --->
                #placementInfo#	
            </cfdocument>
            
            <!--- Save PDF File --->
            <cffile action="write" file="#APPLICATION.PATH.temp##qGetStudentInfo.studentID#-placementInformation.pdf" output="#placementInfoPDF#" nameconflict="overwrite">    

            <!--- send email --->
            <cfinvoke component="internal.extensions.components.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#FORM.emailTo#">
                <cfinvokeargument name="email_cc" value="#CLIENT.email#">
                <cfinvokeargument name="email_subject" value="Placement Information for #qGetStudentInfo.firstName# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)">
                <cfinvokeargument name="email_message" value="#emailMessage#">
                <cfinvokeargument name="email_from" value="""#CLIENT.companyshort# - #CLIENT.firstname# #CLIENT.lastname#"" <#CLIENT.email#>">
                <cfinvokeargument name="email_file" value="#APPLICATION.PATH.temp##qGetStudentInfo.studentID#-placementInformation.pdf">
            </cfinvoke>
            
			<!--- Page Header --->
            <gui:pageHeader
                headerType="applicationNoHeader"
                 width="98%"
                filePath="../"
            />	

            <cfif SESSION.pageMessages.length()>
                <table class="placementLetterTable" align="center">
                    <tr>
                        <td>
                        
                            <!--- Page Messages --->
                            <gui:displayPageMessages 
                                pageMessages="#SESSION.pageMessages.GetCollection()#"
                                messageType="onlineApplication"
                                width="770px"
                                />
                        
                        </td>
                    </tr>
                </table>                                                    
            </cfif>

            <!--- Include Email Form --->
            <cfif ListFind("1,2,3,4", CLIENT.usertype)>
                #emailForm#
            </cfif>
                
			<!--- Include PIS Template --->
            #PlacementInfo#

			<!--- Page Footer --->
            <gui:pageFooter
                footerType="application"
                 width="98%"
                filePath="../"
            />
            
            <script language="javascript">
                // Close Window After 2 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 2000);
            </script>
            
        </cfcase>    
        
        <!--- Web Profile --->
        <cfdefaultcase>
				
			<!--- Page Header --->
            <gui:pageHeader
                headerType="applicationNoHeader"
                 width="98%"
                filePath="../"
            />	

            <cfif SESSION.formErrors.length()>
                <table class="placementLetterTable" align="center">
                    <tr>
                        <td>
                        
                            <!--- Form Errors --->
                            <gui:displayFormErrors 
                                formErrors="#SESSION.formErrors.GetCollection()#"
                                messageType="onlineApplication"
                                width="770px"
                                />
                                
                        </td>
                    </tr>
                </table>                                                    
            </cfif>
            
            <!--- Include Email Form --->
            <cfif ListFind("1,2,3,4", CLIENT.usertype)>
                #emailForm#
            </cfif>
                
			<!--- Include PIS Template --->
            #PlacementInfo#

			<!--- Page Footer --->
            <gui:pageFooter
                footerType="application"
                 width="98%"
                filePath="../"
            />
  
        </cfdefaultcase>
    
    </cfswitch>


</cfoutput>
