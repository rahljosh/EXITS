<!--- ------------------------------------------------------------------------- ----
	
	File:		studentProfileTemplate.cfm
	Author:		Marcus Melo
	Date:		November 11, 2010
	Desc:		Student Profile Template
				Used in:
				student_profile.cfm
				student_profile_email.cfm

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfparam name="uniqueID" default="">

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
	</cfscript>

    <cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#qGetStudentInfo.studentID#.*">    

	<cfdirectory directory="#AppPath.onlineApp.studentLetter#" name="studentLetter" filter="#qGetStudentInfo.studentid#.*">
    
	<cfdirectory directory="#AppPath.onlineApp.parentLetter#" name="parentLetter" filter="#qGetStudentInfo.studentid#.*">    

</cfsilent>

<cfoutput>

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

</cfoutput>
