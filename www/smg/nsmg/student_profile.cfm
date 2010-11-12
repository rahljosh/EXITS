<!--- ------------------------------------------------------------------------- ----
	
	File:		student_profile.cfm
	Author:		Marcus Melo
	Date:		March 25, 2010
	Desc:		Web Version of Student Profile

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customtags/gui/" prefix="gui" />	
    
    <!--- CHECK SESSIONS --->
    <cfinclude template="check_sessions.cfm">
	
    <!--- Param URL Variables --->    
    <cfparam name="uniqueID" default="">
    <cfparam name="profileType" default="">

    <!--- Param FORM Variables --->    
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.isIncludeLetters" default="0">
    <cfparam name="FORM.emailTo" default="">

    <cfscript>	
		// Get Student by uniqueID
		qGetStudentInfo = APPCFC.STUDENT.getStudentByID(uniqueID=uniqueID);
		
		// Get Region
		qGetRegion = APPCFC.REGION.getRegions(regionID=qGetStudentInfo.regionassigned);

		// Get Region Guaranteed
		qGetRegionGuaranteed = APPCFC.REGION.getRegions(regionID=qGetStudentInfo.regionalguarantee);
		
		// Get International Representative
		qIntlRep = APPCFC.USER.getUserByID(userID=qGetStudentInfo.intrep);
		
		// Get Company
		qGetCompany = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		
		// Get Program
		qGetProgram = APPCFC.PROGRAM.getPrograms(programID=qGetStudentInfo.programid);
		
		// Get Countries
		getCountryBirth = APPCFC.LOOKUPTABLES.getCountry(countryID=qGetStudentInfo.countrybirth).countryName;
		getCountryCitizen = APPCFC.LOOKUPTABLES.getCountry(countryID=qGetStudentInfo.countrycitizen).countryName;
		getCountryResident = APPCFC.LOOKUPTABLES.getCountry(countryID=qGetStudentInfo.countryresident).countryName;
		
		// Get State Guarantee
		getStateGuranteed = APPCFC.LOOKUPTABLES.getState(stateID=qGetStudentInfo.state_guarantee).stateName;
		
		// Get Private School Range
		qPrivateSchool = APPCFC.LOOKUPTABLES.getPrivateSchool(privateSchoolID=qGetStudentInfo.privateschool);
		
		// Get Interests
		qGetInterests = APPCFC.LOOKUPTABLES.getInterest(interestID=qGetStudentInfo.interests);
		
		// set Interest List
		interestList = ValueList(qGetInterests.interest, ", &nbsp; ");
		
		/*** These are used for the email template ***/

		// Variables to store letters
		studentLetterContent = '';
		parentLetterContent = '';
		
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
		
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {

			// Data Validation
			if ( NOT IsValid("email", FORM.emailTo) ) {
				ArrayAppend(Errors.Messages, "Please enter a valid email address");
			}

		}
	</cfscript>

    <cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#qGetStudentInfo.studentID#.*">    

	<cfdirectory directory="#AppPath.onlineApp.studentLetter#" name="studentLetter" filter="#qGetStudentInfo.studentid#.*">
    
	<cfdirectory directory="#AppPath.onlineApp.parentLetter#" name="parentLetter" filter="#qGetStudentInfo.studentid#.*">    

</cfsilent>

<cfif NOT LEN(uniqueID)>
	You have not specified a valid studentID.
	<cfabort>
</cfif>

<cfoutput>

<!--- Save Profile into a variable --->
<cfsavecontent variable="studentProfile">
    
    <link rel="stylesheet" href="linked/css/student_profile.css" type="text/css">
     
    <!--- Header --->
    <table align="center" class="profileTable">
        <tr>
            <td class="titleLeft" valign="bottom">
                <!--- <span class="title">International Representative:</span> <br /> #qIntlRep.businessname# <br /><br /><br /> --->
                 <br /><br /><br />
                <span class="title">Today's Date:</span> #DateFormat(now(), 'mmm d, yyyy')#<br />
            </td> 
            <td class="titleCenter">
                <h1>#qGetCompany.companyName#</h1>                
                <span class="title">Program:</span> #qGetProgram.programname#<br />
                <!---
                <span class="title">Region:</span> #qGetRegion.regionname# 
                <cfif qGetStudentInfo.regionguar EQ 'yes'><strong> - #qGetRegionGuaranteed.regionname# Guaranteed</strong> <br /></cfif>
                <cfif VAL(qGetStudentInfo.state_guarantee)><strong> - #getStateGuranteed# Guaranteed</strong> <br /></cfif>
                --->
                <cfif VAL(qGetStudentInfo.scholarship)>Participant of Scholarship Program</cfif>
            </td>
            <td class="titleRight">
                <img src="pics/logos/#client.companyid#.gif" align="right" width="100px" height="100px"> <!--- Image is 144x144 --->
            </td>
        </tr>	
    </table>
    
    
    <!--- Student Information --->
    <table  align="center" class="profileTable">
        <tr>
            <td valign="top" width="140px">
                <div align="left">
                    <cfif studentPicture.recordcount>
                        <img src="uploadedfiles/web-students/#studentPicture.name#" width="135">
                    <cfelse>
                        <img src="pics/no_stupicture.jpg" width="135">
                    </cfif>
                    <br />
                </div>
            </td>
            <td valign="top" width="660px">
                <span class="profileTitleSection">STUDENT PROFILE</span>
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr>
                        <td valign="top" width="330px">
                        
                            <table cellpadding="2" cellspacing="2" border="0">
                                <tr>
                                    <td><span class="title">Name:</span></td>
                                    <td>#qGetStudentInfo.firstname# (###qGetStudentInfo.studentID#)</td>
                                </tr>	
                                <tr>
                                    <td><span class="title">Sex:</span></td>
                                    <td>#qGetStudentInfo.sex#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Age:</span></td>
                                    <td>#DateDiff("yyyy", qGetStudentInfo.dob, now())#</td>
                                </tr>                                    
                            </table>
                            
                        </td>
                        <td valign="top" width="330px">
                        
                            <table cellpadding="2" cellspacing="2" border="0">
                                <tr>
                                    <td><span class="title">Place of Birth:</span></td>
                                    <td>#qGetStudentInfo.citybirth#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Country of Birth:</span></td>
                                    <td>#getCountryBirth#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Country of Citizenship:</span></td>
                                    <td>#getCountryCitizen#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Country of Residence:</span></td>
                                    <td>#getCountryResident#</td>
                                </tr>
                            </table>
                            
                        </td>
                    </tr>                        
                </table>
            
            </td>
        </tr>                
    </table>
    
    
    <!--- Academic and Language Evaluation --->
    <table align="center" class="profileTable">
        <tr><td colspan="3"><span class="profileTitleSection">ACADEMIC AND LANGUAGE EVALUATION</span></td></tr>     
        <tr>
            <td width="250px"><span class="title">Band:</span> <cfif qGetStudentInfo.band is ''><cfelse>#qGetStudentInfo.band#</cfif></td>
            <td width="200px"><span class="title">Orchestra:</span> <cfif qGetStudentInfo.orchestra is ''><cfelse>#qGetStudentInfo.orchestra#</cfif></td>
            <td width="200px"><span class="title">Est. GPA: </span> <cfif qGetStudentInfo.orchestra is ''><cfelse>#qGetStudentInfo.estgpa#</cfif></td>
        </tr>
        <tr>
            <td>
                <cfif qGetStudentInfo.grades EQ 12>
                     <span class="title">Must be placed in:</span> #qGetStudentInfo.grades#th grade
                <cfelse>				
                     <span class="title">Last Grade Completed:</span>
                    <cfif NOT VAL(qGetStudentInfo.grades)>
                        n/a
                    <cfelse>
                        #qGetStudentInfo.grades#th grade
                    </cfif>
                </cfif>
            </td>
            <td>
                <span class="title">Years of English:</span>
                <cfif NOT VAL(qGetStudentInfo.yearsenglish)>
                    n/a
                <cfelse>
                    #qGetStudentInfo.yearsenglish#
                </cfif>
            </td>
            <td>
                <span class="title">Convalidation needed:</span>
                <cfif NOT LEN(qGetStudentInfo.convalidation_needed)>
                    no
                <cfelse>
                    #qGetStudentInfo.convalidation_needed#
                </cfif>
            </td>
        </tr>
    </table>
    
    <table align="center" class="profileTable">
        <tr><td colspan="4"><span class="profileTitleSection">PERSONAL INFORMATION</span></td></tr>            
        <tr>
            <td width="110px"><span class="title">Allergies</span></td>
            <td width="140px"><span class="title">Animal:</span> <cfif qGetStudentInfo.animal_allergies is ''>no<cfelse>#qGetStudentInfo.animal_allergies#</cfif></td>
            <td width="200px"><span class="title">Medical Allergies:</span> <cfif qGetStudentInfo.med_allergies is ''>no<cfelse>#qGetStudentInfo.med_allergies#</cfif></td>
            <td width="200px"><span class="title">Other:</span> <cfif qGetStudentInfo.other_allergies is ''>no<cfelse>#qGetStudentInfo.other_allergies#</cfif></td>
        </tr>
        <tr>
            <td colspan="4">
                <span class="title">Interests:</span> #interestList#
            </td>
        </tr>	
    
        <cfif qGetStudentInfo.aypenglish EQ 'yes'>
            <tr>
                <td colspan="4"><span class="title">Pre-AYP:</span> The Student Participant of the Pre-AYP English Camp.</td>
            </tr>
        </cfif>	
            
        <cfif qGetStudentInfo.ayporientation EQ 'yes'>
            <tr>
                <td colspan="4"><span class="title">Pre-AYP:</span> The Student Participant of the Pre-AYP Orientation Camp.</td>
            </tr>
        </cfif>	
        
        <cfif qGetStudentInfo.iffschool EQ 'yes'>    
            <tr>
                <td colspan="4"><span class="title">IFF:</span>The Student Accepts IFF School.</td>
            </tr>
        </cfif>
                  
        <cfif qGetStudentInfo.privateschool>
            <tr>
                <td colspan="4"><span class="title">Private HS:</span>The Student Accepts Private HS #qPrivateSchool.privateschoolprice#.</td>
            </tr>
        </cfif>		
                
        <tr>
            <td colspan="4">
                <span class="title">Comments:</span> 
                <div class="comments">#qGetStudentInfo.interests_other#</div>
            </td>
        </tr>
    </table>

</cfsavecontent>


<!--- Display Profile / Email Form --->
<cfswitch expression="#profileType#">
	
    <!--- Web Profile --->
	<cfcase value="web">

		<!--- Include Profile Template --->
        #studentProfile#

    </cfcase>


    <!--- PDF Profile --->
	<cfcase value="pdf">
    
        <cfdocument format="pdf">
        
            <!--- Include Profile Template --->
            #studentProfile#
        
        </cfdocument>
        
    </cfcase>
	
    
    <!--- Email Profile --->
	<cfcase value="email">
		
        <!--- Email FORM --->
        <link rel="stylesheet" type="text/css" href="smg.css">
        
        <!--- Table Header --->
        <gui:tableHeader
            width="380px"
            imageName="students.gif"
            tableTitle="Email Student Profile and Letters"
            tableRightTitle=""
        />
        
        <form name="#cgi.SCRIPT_NAME#" method="post">
            <input type="hidden" name="submitted" value="1" />
            <input type="hidden" name="uniqueID" value="#uniqueID#" />
            <input type="hidden" name="profileType" value="email" />
            
            <table width="380px" border="0" cellpadding="5" cellspacing="5" class="section" style="padding:15px;">
            
                <!--- Display Errors --->
                <cfif VAL(ArrayLen(Errors.Messages))>
                    <tr>
                        <td>
                            <font color="##FF0000">Please review the following items:</font> <br />
                
                            <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                                #Errors.Messages[i]#    	
                            </cfloop> <br />
                        </td>
                    </tr>
                </cfif>	
            
                <tr>	
                    <td><b>Student: #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)</b></td>
                </tr>
                <tr>	
                    <td>Please enter an email address below and click on submit.</td>
                </tr>
                <tr>	
                    <td>
                        Email Address: &nbsp; <input type="text" name="emailTo" value="" size="30" maxlength="100" />			
                    </td>
                </tr>
                <tr>	
                    <td>
                        <input type="checkbox" name="isIncludeLetters" id="isIncludeLetters" value="1" <cfif FORM.isIncludeLetters> checked="checked" </cfif> /> 
                        &nbsp; 
                        <label for="isIncludeLetters">Include Student and Parent Letters</label>
                    </td>
                </tr>
                <tr>	
                    <td align="center">
                        <input name="Submit" type="image" src="pics/submit.gif" border=0 alt=" Send Email ">
                        &nbsp; &nbsp; &nbsp;
                        <input type="image" value="close window" src="pics/close.gif" alt=" Close this Screen " onClick="javascript:window.close()">
                    </td>
                </tr>	
            </table>
        
        </form>
                    
        <!--- Table Footer --->
        <gui:tableFooter
            width="380px"
        />
        
		<!--- FORM Submitted --->
        <cfif FORM.submitted AND NOT VAL(ArrayLen(Errors.Messages))>
        
            <!--- Student Profile --->
            <cfsavecontent variable="studentProfile">
                
				<!--- Include Profile Template --->
                #studentProfile#
                    
            </cfsavecontent>
            <!--- End of Student Profile --->
            
            
            <!--- Student Letter --->
            <cfif LEN(qGetStudentInfo.letter)>
                
                <cfsavecontent variable="studentLetterContent">  
                    <div style="page-break-after:always"></div>
                    <table align="center" class="profileTable">
                        <tr><td><span class="profileTitleSection">STUDENT LETTER OF INTRODUCTION</span></td></tr>
                        <tr>
                            <td>
                                <div class="comments">
                                    #qGetStudentInfo.letter# 
                                </div> <br/>
                            </td>
                        </tr>
                    </table>
                </cfsavecontent>        
            
            </cfif>
            <!--- End of Student Letter --->
            
            
            <!--- Parent Letter --->
            <cfif LEN(qGetStudentInfo.familyletter)>
            
                <cfsavecontent variable="parentLetterContent"> 
                    <div style="page-break-after:always"></div>
                    <table align="center" class="profileTable">
                        <tr><td><span class="profileTitleSection">PARENTS LETTER OF INTRODUCTION</span></td></tr>
                        <tr>
                            <td>
                                <div class="comments">
                                    #qGetStudentInfo.familyletter# 
                                </div> <br/>
                            </td>
                        </tr>
                    </table>
                </cfsavecontent>        
                
            </cfif>
            <!--- End of Parent Letter --->
            
            
            <cfsavecontent variable="emailMessage">
                
                <cfif FORM.isIncludeLetters>
                    <p>Please see attached student profile, student letter and parent letter.</p>
                <cfelse>
                    <p>Please see attached student profile.</p>
                </cfif>
                
                <p>Student Name: #qGetStudentInfo.firstName# (###qGetStudentInfo.studentid#) student profile attached.</p>
                
                <p>
                    Thank you, <br />
                    #qGetCompany.companyName#   
                </p>        
            </cfsavecontent>
            
            
            <!--- Create PDF File - Include Profile and Letters --->
            <cfdocument name="profile" format="pdf">
                
                <!--- Student Profile --->
                #studentProfile#	
                
                <cfif FORM.isIncludeLetters>
                    <!--- Student Letter --->
                    #studentLetterContent#
                    
                    <!--- Parent Letter --->
                    #parentLetterContent#  
                </cfif>
                        
            </cfdocument>
            
            
            <!--- Save PDF File --->
            <cffile action="write" file="#AppPath.temp##qGetStudentInfo.studentID#-profile.pdf" output="#profile#" nameconflict="overwrite">    
            
            
            <!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#FORM.emailTo#">
                <cfinvokeargument name="email_subject" value="#qGetCompany.companyShort_noColor# Student Profile - #qGetStudentInfo.firstName# (###qGetStudentInfo.studentid#)">
                <cfinvokeargument name="email_message" value="#emailMessage#">
                <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
            
                <!--- Attach Students Profile --->
                <cfinvokeargument name="email_file" value="#AppPath.temp##qGetStudentInfo.studentID#-profile.pdf">
         
                <cfif FORM.isIncludeLetters>
                    <!--- Attach Students Letter --->
                    <cfif studentLetter.recordcount>
                        <cfinvokeargument name="email_file2" value="#AppPath.onlineApp.studentLetter##studentLetter.name#">
                    </cfif>
                    
                    <!--- Attach Parents Letter --->
                    <cfif parentLetter.recordcount>
                        <cfinvokeargument name="email_file3" value="#AppPath.onlineApp.parentLetter##parentLetter.name#">
                    </cfif>
                </cfif>    	
                
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

		<!--- Include Profile Template --->
        #studentProfile#
    
    </cfdefaultcase>

</cfswitch>

</cfoutput>
