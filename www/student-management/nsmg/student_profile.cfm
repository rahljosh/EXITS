<!--- ------------------------------------------------------------------------- ----
	
	File:		student_profile.cfm
	Author:		Marcus Melo
	Date:		March 25, 2010
	Desc:		Web Version of Student Profile

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
    
    <!--- CHECK SESSIONS --->
    <cfinclude template="check_sessions.cfm">
	
    <!--- Param URL Variables --->    
    <cfparam name="uniqueID" default="">
    <cfparam name="profileType" default="">

    <!--- Param FORM Variables --->    
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.isIncludeLetters" default="0">
    <cfparam name="FORM.isIncludePicture" default="0">
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


<Cfquery name="studentReligion" datasource="#application.dsn#">
select religionname
from smg_religions
where religionid = #qGetStudentInfo.religiousaffiliation#
</cfquery>

<cfif NOT LEN(uniqueID)>
	You have not specified a valid studentID.
	<cfabort>
</cfif>

<cfoutput>
<cfif client.userid eq 1>
	<cfdump var="#qGetStudentInfo#"></cfdump>
	<cfdump var="#parentLetter#"></cfdump>
	<cfdump var="#studentLetter#"></cfdump>
	<!--- Attach Parents Letter --->
                    <cfif parentLetter.recordcount>
                       #AppPath.onlineApp.parentLetter##parentLetter.name#
                     #AppPath.onlineApp.studentLetter##studentLetter.name#
                    </cfif>
</cfif>

<!--- Save Profile into a variable --->
<cfsavecontent variable="studentProfile">
    
    <link rel="stylesheet" href="linked/css/student_profile.css" type="text/css">

     <table class="profileTable" align="center">
     	<Tr>
        	<Td>
     
    <!--- Header --->
    <table align="center">
        <tr>
            
            <td class="bottom_center" width=800  valign="top">
            <img src="pics/#client.companyid#_short_profile_header.jpg" />
           <!---     <h1>#qGetCompany.companyName#</h1>                
                <span class="title">Program:</span> #qGetProgram.programname#<br />
                <!---
                <span class="title">Region:</span> #qGetRegion.regionname# 
                <cfif qGetStudentInfo.regionguar EQ 'yes'><strong> - #qGetRegionGuaranteed.regionname# Guaranteed</strong> <br /></cfif>
                <cfif VAL(qGetStudentInfo.state_guarantee)><strong> - #getStateGuranteed# Guaranteed</strong> <br /></cfif>
                --->
                <cfif VAL(qGetStudentInfo.scholarship)>Participant of Scholarship Program</cfif>
				---->
                <span class="title"><font size=+1>Name:</font></span><font size=+2>#qGetStudentInfo.firstname#</font><font size=+2> (###qGetStudentInfo.studentID#)</font>
            </td>
            <!----
            <td class="titleRight">
                <img src="pics/logos/#client.companyid#.gif" align="right" width="100px" height="100px"> <!--- Image is 144x144 --->
            </td>
			---->
        </tr>	
    </table>
    
    
    <!--- Student Information #qGetStudentInfo.countryresident# --->
    <table  align="center" border=0 cellpadding="4" cellspacing=0>
        <tr>           
            <td valign="top" width="660px">
                <span class="profileTitleSection"  bgcolor="##0854a0">STUDENT PROFILE</span>
                <table cellpadding="0" cellspacing="0" border="0" class="profiletable2">
                    <tr>
                        <td valign="top" width="330px">
                            <table cellpadding="4" cellspacing="0" border="0" class="inner_profileTable">                              
                                <tr>
                                    <td><span class="title">Sex:</span></td>
                                    <td>#qGetStudentInfo.sex#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Age:</span></td>
                                    <td>#DateDiff("yyyy", qGetStudentInfo.dob, now())#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Religious Affiliation:</span></td>
                                    
                                    <td>#studentReligion.religionname#</td>
                                </tr> 
                                <tr>
                                    <td><span class="title">Religious Participation:</span></td>
                                    <td>#qGetStudentInfo.religious_participation#</td>
                                </tr>        
                                                                  
                            </table>
                            
                        </td>
                        <td valign="top" width="330px">
                        
                            <table cellpadding="4" cellspacing="0" class="inner_profileTable" border=0>
                           
                               <!----
                                <tr>
                                    <td><span class="title">Place of Birth:</span></td>
                                    <td>#qGetStudentInfo.citybirth#</td>
                                </tr>
								---->
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
                                <tr>
                                    <td><span class="title">Program:</span></td>
                                    <td>#qGetProgram.programname#</td>
                                </tr>  
                                <Tr>
                                	<Td colspan=2>  <cfif VAL(qGetStudentInfo.scholarship)>Participant of Scholarship Program</cfif></Td>
                                </Tr>
                            </table>
                            
                        </td>
                        <td valign="center">
                        	<Table border=0>
                            	<Tr>
                                	<Td>
                                    
                                    <Cfif form.isIncludePicture eq 1>
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
                                    <cfelse>
											<cfif FileExists('c:/websites/student-management/nsmg/pics/flags/#qGetStudentInfo.countryresident#.jpg')>
                                            <cfimage source="pics/flags/#qGetStudentInfo.countryresident#.jpg" name="myImage">
                                            <cfelse>
                                            <cfimage source="pics/flags/0.jpg" name="myImage">
                                            </cfif>
                                            <cfset ImageScaleToFit(myimage, 150,100)>
                                            <cfif qGetStudentInfo.sex is 'female'>
                                                <cfimage source="pics/girl.png" name="topImage">
                                            <cfelse>
                                                <cfimage source="pics/boy.png" name="topImage">
                                            </cfif>
                                            <cfset ImagePaste(myImage,topImage,0,0)>
                                            <cfimage source="#myImage#" action="writeToBrowser" border=0>
             						</Cfif>
                                    </Td>
                                 </Tr>
                               </Table>
            			</td>
                    </tr>                        
                </table>
            
            </td>
        </tr>                
    </table>
     <!--- Siblings ---->
     <Cfquery name="sibling" datasource="#application.dsn#">
     select *
     from smg_student_siblings
     where studentid = #qGetStudentInfo.studentID#
     </cfquery>
     <cfquery name="numberSis" dbtype="query">
         select count(sex) as numberSis
         from sibling
         where sex = 'female'
     </cfquery>
     <cfquery name="numberBro" dbtype="query">
         select count(sex) as numberBro
         from sibling
         where sex = 'male'
     </cfquery>
    <table align="center" class="profileTable2">
        <tr bgcolor="##0854a0"><td colspan="3"><span class="profileTitleSection">SIBLINGS</span></td></tr>     
      
      
        <tr>
            <td>
           <span class="title">Sisters</span><cfif numberSis.recordcount eq 0> 0 <cfelse> #numberSis.numberSis# </cfif>
            </td>
            <td>
       		 <span class="title">Brothers</span><cfif numberBro.recordcount eq 0>0<cfelse> #numberBro.numberBro# </cfif>
            </td>
            
        </tr>    
    </table>
  
    <!--- Academic and Language Evaluation --->
    <table align="center" class="profileTable2">
        <tr bgcolor="##0854a0"><td colspan="3"><span class="profileTitleSection">ACADEMIC AND LANGUAGE EVALUATION</span></td></tr>     
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
    
    <table align="center" class="profileTable2">
        <tr bgcolor="##0854a0"><td colspan="4"><span class="profileTitleSection">PERSONAL INFORMATION</span></td></tr>            
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
                  
        <cfif VAL(qGetStudentInfo.privateschool)>
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
     <!--- Facts about country --->
     <Cfquery name="funFact" datasource="#application.dsn#">
     select funFact 
     from smg_countrylist
     where countryid = #qGetStudentInfo.countryResident#
     </cfquery>
     <Cfif funFact.funfact is not ''>
    <table align="center" class="profileTable2">
        <tr bgcolor="##0854a0"><td colspan="3"><span class="profileTitleSection">FACTS ABOUT #UCase(getCountryResident)#</span></td></tr>     
        <tr>
            <td>
            <cfif FileExists('c:/websites/student-management/nsmg/uploadedfiles/profileFactPics/#qGetStudentInfo.countryResident#.jpg')>
               <img src="uploadedfiles/profileFactPics/#qGetStudentInfo.countryResident#.jpg" align="right" height="150" width="200" />
            <cfelse>
            	<cfif FileExists('c:/websites/student-management/nsmg//pics/flags/#qGetStudentInfo.countryResident#.jpg')>
                    <cfimage source="pics/flags/#qGetStudentInfo.countryResident#.jpg" name="myImage">
                 <cfelse>                                                    
                     <cfimage source="pics/flags/0.jpg" name="myImage">
                </cfif>
            	<img src="pics/flags/#qGetStudentInfo.countryResident#.jpg" align="right" height="100" width="150" />
            </cfif>                             
           #funFact.funFact#                   
            </td>
        </tr>
       
 
       
    </table>
    </Cfif>
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
                    <td valign="top">
                      Additional Info: &nbsp; <textarea name="addInfo" cols="28" rows="5"></textarea>
                    </td>
                </tr>
                <cfif ListFind("1,2,3,4,5,6", CLIENT.usertype)>
                <tr>	
                    <td>
                        <input type="checkbox" name="isIncludeLetters" id="isIncludeLetters" value="1" <cfif FORM.isIncludeLetters> checked="checked" </cfif> /> 
                        &nbsp; 
                        <label for="isIncludeLetters">Include Student and Parent Letters <br />
                        </label>
                    (only to approved host families)</td>
                </tr>
                <tr>	
                    <td>
                        <input type="checkbox" name="isIncludePicture" id="isIncludePicture" value="1" <cfif FORM.isIncludePicture> checked="checked" </cfif> /> 
                        &nbsp; 
                        <label for="isIncludeLetters">Include Student Picture - instead of flag. <br />
                        </label>
                    (only to approved host families)</td>
                </tr>
                </cfif>
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
                
                <Cfif form.addInfo is not''>
                <p>Additional Info: #form.addInfo#</p>
                </Cfif>
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
