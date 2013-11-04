<!--- ------------------------------------------------------------------------- ----
	
	File:		page24.cfm
	Author:		James Griffiths
	Date:		October 23, 2013
	Desc:		HIPAA Release

----- ------------------------------------------------------------------------- --->

<cfparam name="URL.display" default="web"><!---web,print--->
<cfparam name="URL.printBlank" default="0">

<cfscript>
	if (CGI.HTTP_HOST IS "jan.case-usa.org" OR CGI.HTTP_HOST IS "www.case-usa.org") {
		CLIENT.org_code = 10;
		bgcolor = "FFFFFF";
	} else {
		CLIENT.org_code = 5;
		bgcolor = "B5D66E";
	}
	
	path = "";
	if (URL.display EQ "print") {
		path = "../";
		param name="vStudentAppRelativePath" default="../";
		param name="vUploadedFilesRelativePath" default="../../";
	}
	
	qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
	qGetStudent = APPLICATION.CFC.STUDENT.getStudentByID(studentID=CLIENT.studentID);
	
	doc = 'page24';
</cfscript>

<style type="text/css">
	body {
		margin: 0px;
		padding:0px;
	}
	p {
		margin: 0px;
		padding: 2px;
		font-size:12px;
	}
	#signatureTable td {
		margin: 0px;
		padding: 0px;
	}
</style>

<cftry>
	<cfoutput>
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
                <link rel="stylesheet" type="text/css" href="#path#app.css">
            </head>
            <body>
            
            	<cfif URL.display EQ "print" AND NOT VAL(URL.printBlank)>
                    <cfinclude template="../print_include_file.cfm">
                <cfelse>
                    <cfset printpage = 'yes'>	
                </cfif>
                
                <cfif printpage EQ "yes">
                
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr height="33">
                            <td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
                            <td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
                            <td class="tablecenter"><h2>Page [24] - HIPAA Release</h2></td>
                            <td align="right" class="tablecenter">
                                <cfif URL.display EQ "web">
                                    <a href="" onClick="javascript: win=window.open('section4/page24.cfm?display=print', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;">
                                        <img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img>
                                    </a>
                                    &nbsp; &nbsp;
                                </cfif>
                            </td>
                            <td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
                        </tr>
                    </table>
                    
                    <div class="section">
                        <br/>
                        <cfif URL.display EQ "web">
                            <cfinclude template="../check_uploaded_file.cfm">
                            <table width="670px" cellpadding=3 cellspacing=0 align="center"><tr><td></td></tr></table>
                            <br/>
                        </cfif>
                        <table width="670px" cellpadding=3 cellspacing=0 align="center">
                            <tr>
                                <td>
                                    <p>
                                        <center><b><u>HIPAA-Compliant Authorization for Release of Health Information</u></b></center>
                                    </p>
                                    <p>
                                        In the spring of 2003, HIPAA set forth certain guidelines to protect the patient's/student's rights for health information confidentiality. Under these new guidelines we are now required to have written consent in order to obtain the health information from any healthcare provide or insurance company. Without this consent we will be unable to contact your health care provider or insurance company.
                                    </p>
                                    <p>
                                        I hereby authorize the protected health information for #qGetStudent.familyLastName#, #qGetStudent.firstName# #qGetStudent.middleName# #DateFormat(qGetStudent.dob,"mm/dd/yyyy")# ("Individual") to be released as specified in this HIPAA compliant Authorization.
                                    </p>
                                    <p>
                                        <b>1. Description of Information To Be Disclosed:</b> I authorize the release of any and all records and information pertaining to the Individual's medical care, treatment, and physical and psychological condition including, but not limited to:
                                        <br/>
                                        <div style="margin-left:60px; font-size:10px;">
                                            Accreditation Forms, Admission, Advance Directives, Ambulance, Anesthesia, Billing Records, Cath Films, Catheterization/Angiography Claims History, Consent Forms, Consultations/Evaluations, Correspondence, CPR/Code Sheets, CT Scan Reports, CT Scans, Diagnostic Testing, Discharge/Transfer Summary, Echocardiogram, Echocardiogram Tapes, Education Records, EKG, Emergency Room, Graphic/Flow Charts, History/Physical, Implant Related Records, Laboratory, Medication Records, MRI Reports, MRI Scans, Nurse's Notes Nursery, Operative Records, Pathology Report, Pathology Slides, Patient Care Plan, Photographs, Physical Therapy, Physician Orders, Physician Progress Notes, Post Anesthesia, Prescriptions, Psychiatry/Social Service, Radiation Records, Rehabilitation, Respiratory, Speech Pathology, Transfusion Records, Ultrasound Reports, Ultrasounds Videos, X-ray Films, X-ray Reports, Complete Medical Record (includes information regarding insurance, demographics, referral documents and records from other facilities).
                                        </div>
                                    </p>
                                    <p>
                                        I recognize that the protected health information may include psychiatric information, drug and alcohol information and/or HIV information. _______ (Individual's/Representative's initials)
                                    </p>
                                    <p>
                                        <b>2. Entities Authorized to Disclose:</b> I authorize any hospital, clinic or other medical facility, physician, nurse, physical or occupational therapist, chiropractor, psychiatrist, psychologist, medical practitioner, pharmacy, emergency medical service, basic life support service, advanced life support service, insurance company, the Medical Information Bureau or any other person or entity licensed to create and/or maintain protected health information for the Individual to disclose the Individual's health information as described above.
                                    </p>
                                    <p>
                                        <b>3. Information Disclosed To:</b> I authorize the Individual's information to be disclosed to:
                                        <br/>
                                        <div style="margin-left:60px; font-size:10px;">
                                            <b>Company -</b> #qGetCompany.companyName# ("#qGetCompany.companyShort#") 
                                            <br/>
                                            <b>Address -</b> #qGetCompany.address#, #qGetCompany.city#, #qGetCompany.state# #qGetCompany.zip#
                                            <br/>
                                            Any of #qGetCompany.companyShort#'s Student Facilitors, Program Managers, or Corporate Officers.
                                        </div>
                                    </p>
                                    <p>
                                        The information will be used to assist the student and his/her natural family and US host family manager patient care. I authorize any third-party record retrieval agent to retrieve the protected health information as described above for use by Agent and other authorized recipients.
                                    </p>
                                    <p>
                                        <b>4. Expiration Date:</b> This authorization expires three years after the date I sign it.
                                    </p>
                                    <p>
                                        <b>5. Right to Revoke:</b> I understand that I have the right to revoke this authorization at any time by notifying Agent and the medical record custodian in writing. The revocation would not be effective for any actions taken in reliance upon this authorization prior to the receipt of revocation.
                                    </p>
                                    <p>
                                        <b>6. Re-disclosure:</b> I recognize that protected health information disclosed to Agent or other authorized recipients may no longer be protected by HIPAA or other federal laws.
                                    </p>
                                    <p>
                                        <b>7. Eligibility for Benefits:</b> Treatment, payment, enrollment in a health plan, or eligibility for health insurance benefits may not be conditioned on my signing this authorization.
                                    </p>
                                    <p>
                                        <b>8. Facsimiles:</b> A copy or facsimile of this authorization is as valid as the original.
                                    </p>
                                    <p>
                                        <b>9. My Right to a Copy:</b> I hereby understand that I have a right to a copy of this fully-executed authorization which I can obtain from #qGetCompany.companyShort#’s representative in my home country
                                    </p>
                                    <p>
                                        I have read and understood this authorization and authorize the disclosure of the protected health information as described above.
                                    </p>
                                    <p>
                                        <table id="signatureTable" width="100%" style="padding:0px; margin:0px;">
                                            <tr>
                                                <td>
                                                    Student signature:
                                                    <br/>
                                                    <img src="../pics/line.gif" width="420px" height="1" border="0" align="absmiddle" style="margin-left:105px;">
                                                </td>
                                                <td>
                                                    Date: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; /
                                                    <br/>
                                                    <img src="../pics/line.gif" width="100px" height="1" border="0" align="absmiddle" style="margin-left:35px;">
                                                </td>
                                            </tr>
                                            <tr><td>&nbsp;</td></tr>
                                            <tr>
                                                <td colspan="2">
                                                    Parent or legal guardian: Print Name:
                                                    <br/>
                                                    <img src="../pics/line.gif" width="470px" height="1" border="0" align="absmiddle" style="margin-left:210px;">
                                                </td>
                                            </tr>
                                            <tr><td>&nbsp;</td></tr>
                                            <tr>
                                                <td>
                                                    Parent or legal guardian signature:
                                                    <br/>
                                                    <img src="../pics/line.gif" width="330px" height="1" border="0" align="absmiddle" style="margin-left:195px;">
                                                </td>
                                                <td>
                                                    Date: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; /
                                                    <br/>
                                                    <img src="../pics/line.gif" width="100px" height="1" border="0" align="absmiddle" style="margin-left:35px;">
                                                </td>
                                            </tr>
                                            <tr><td>&nbsp;</td></tr>
                                            <tr>
                                                <td colspan="2">
                                                    Relationship of Representative to Individual:
                                                    <br/>
                                                    <img src="../pics/line.gif" width="430px" height="1" border="0" align="absmiddle" style="margin-left:250px;">
                                                </td>
                                            </tr>
                                        </table>
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <cfif URL.display EQ "web">
                        <table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
                            <tr>
                                <td align="center" valign="bottom" class="buttontop">
                                    <form action="?curdoc=section4/page25&id=4&p=25" method="post">
                                        <input name="Submit" type="image" src="pics/next_page.gif" border=0 alt="Go to the next page">
                                    </form>
                                </td>
                            </tr>
                        </table>
                    </cfif>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr height="8">
                            <td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
                            <td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
                            <td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
                        </tr>
                    </table>
               	</cfif>
            </body>
        </html>
	</cfoutput>
    
    <cfcatch type="any">
        <cfinclude template="../error_message.cfm">
    </cfcatch>

</cftry>