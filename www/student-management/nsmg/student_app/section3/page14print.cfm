<cfscript>
	// These are used to set the vStudentAppRelativePath directory for images nsmg/student_app/pics and uploaded files nsmg/uploadedFiles/
	// Param Variables
	param name="vStudentAppRelativePath" default="../";
	param name="vUploadedFilesRelativePath" default="../../";
	
	if ( LEN(URL.curdoc) ) {
		vStudentAppRelativePath = "";
		vUploadedFilesRelativePath = "../";
	}
</cfscript>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#vStudentAppRelativePath#app.css"</cfoutput>>	
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfoutput query="get_student_info">

<cfset doc = 'page14'>

<!--- PRINT ATTACHED FILE INSTEAD OF PAGE --->
<cfif NOT LEN(URL.curdoc)>
	<cfinclude template="../print_include_file.cfm">
<cfelse>
	<cfset printpage = 'yes'>	
</cfif>

<!--- PRINT PAGE IF THERE IS NO ATTACHED FILE OR FILE IS PDF OR DOC --->
<cfif printpage EQ 'yes'>

	<cfif NOT LEN(URL.curdoc)>
	<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
	<tr><td>
	</cfif>
	
	<!--- HEADER OF TABLE --->
	<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
		<tr height="33">
			<td width="8" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topleft.gif" width="8"></td>
			<td width="26" class="tablecenter"><img src="#vStudentAppRelativePath#pics/students.gif"></td>
			<td class="tablecenter"><h2>Page [14] - Authorization to Treat a Minor and HIPAA Release</h2></td>
			<cfif LEN(URL.curdoc)>
			<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page14print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
			</cfif>
			<td width="42" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topright.gif" width="42"></td>
		</tr>
	</table>
	
	<div class="section"><br>
	
	<cfif LEN(URL.curdoc)>
		<cfinclude template="../check_upl_print_file.cfm">
	</cfif>
	
	<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td>
<h3>International Student Exchange (ISE) Authorization to Treat a Minor and HIPAA Release<br></h3>
<p>(We) the undersigned parent(s), or legal guardian of #get_student_info.firstname# #get_student_info.familylastname#, (hereafter "Exchange Student"), do hereby authorize and consent to the following: </p>
<p><strong>Authorization to Treat a Minor or Dependent</strong></p>
<p>I do hereby state that I have legal custody of the aforementioned Minor. I grant my authorization and consent for #CLIENT.companyName# (#CLIENT.companyShort#), its officers, staff, Regional Managers, Area Representatives and Host Families (hereafter "Designated Adults") to administer general first aid treatment for any minor injuries or illnesses experienced by the Exchange Student. If the injury or illness is life threatening or in need of professional medical treatment, I authorize the Designated Adults to summon any and all professional emergency personnel to attend, transport, and treat the minor and to issue consent for any medical or psychological treatment, and to be rendered under the general supervision of, any licensed physician, surgeon, dentist, hospital, psychologist, psychiatrist, nurse practitioner or other medical professional or institution duly licensed to practice in the state in which such treatment is to occur. I agree to assume financial responsibility for all expenses of such care. 
</p>
<p>
I also understand that certain vaccinations may be required for the Exchange Student to participate in certain schools and that the vaccination requirements vary across each state in the United States. If the documentation of these vaccinations has not been included in the student application submitted to #CLIENT.companyShort#, I authorize the Designated Adults to have the required vaccines administered to the Exchange Student. I agree to assume financial responsibility for all expenses related to the administration of these vaccines. 
</p>
<p>
It is understood that this authorization is given in advance of any such medical treatment, but is given to provide authority and power on the part of the Designated Adult in the exercise of his or her best judgment upon the advice of any such medical or emergency personnel.
</p>
<h3>HIPAA-Compliant Authorization for Release of Health Information<br></h3>
<p>
I hereby authorize the protected health information for Exchange Student to be released as specified in this HIPAA compliant Authorization.
</p>
<ol>
<li>Description of Information To Be Disclosed: I authorize the release of any and all records and information pertaining to the Individual's medical care, treatment, and physical and psychological condition.</li>
<li>Entities Authorized to Disclose: I authorize any hospital, clinic or other medical facility, physician, nurse, physical or occupational therapist, chiropractor, psychiatrist, psychologist, medical practitioner, pharmacy, emergency medical service, basic life support service, advanced life support service, insurance company, the Medical Information Bureau or any other person or entity licensed to create and/or maintain protected health information for the Individual to disclose the Individual's health information as described above.</li>
<li>Information Disclosed To: I authorize the Individual's information to be disclosed to: 
<p>Company - International Student Exchange ("ISE")  119 Cooper Street, Babylon, NY 11702 
Any of ISE's Student Facilitators, Program Managers, or Corporate Officers.
</p>
<p>The information will be used to assist the student, Designated Adults, and his/her natural family manage patient care. I authorize any third-party record retrieval agent to retrieve the protected health information as described above for use by Agent and other authorized recipients.</p>
</li>
<li> Expiration Date: This authorization expires three years after the date I sign it.</li>
<li> Right to Revoke: I understand that I have the right to revoke this authorization at any time by notifying Agent and the medical record custodian in writing. The revocation would not be effective for any actions taken in reliance upon this authorization prior to the receipt of revocation.</li>
<li> Re-disclosure: I recognize that protected health information disclosed to Agent or other authorized recipients may no longer be protected by HIPAA or other federal laws.</li>
<li>Eligibility for Benefits: Treatment, payment, enrollment in a health plan, or eligibility for health insurance benefits may not be conditioned on my signing this authorization.</li>
<li>Facsimiles: A copy or facsimile of this authorization is as valid as the original.</li>
<li>My Right to a Copy: I hereby understand that I have a right to a copy of this fully-executed authorization which I can obtain from ISE�s representative in my home country
</li>
</ol>
<p>I have read and understood this authorization and authorize the disclosure of the protected health information as described above.</p>

</td></tr>
</table><br>
	
	<hr class="bar"></hr><br>
	
	<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td><em>Family Physician</em></td><td>&nbsp;</td><td colspan="2"><em>Phone</em></td></tr>
		<tr>
			<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td colspan="2"><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		</tr>
		<tr><td width="315"><em>Address</em></td><td width="40">&nbsp;</td><td width="160"><em>City</em></td><td width="155"><em>Country</em></td></tr>
		<tr>
			<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="160" height="1" border="0" align="absmiddle"></td>
			<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
		</tr>
	</table><br><br>
	
	<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td><em>Parent/Guardian Signature</em></td><td>&nbsp;</td><td colspan="2"><em>Date</td></tr>
		<tr>
			<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td colspan="2"><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		</tr>
		<tr><td width="315"><em>Address</em></td><td width="40">&nbsp;</td><td width="160"><em>City</em></td><td width="155"><em>Country</em></td></tr>
		<tr>
			<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="160" height="1" border="0" align="absmiddle"></td>
			<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="155" height="1" border="0" align="absmiddle"></td>
		</tr>
		<tr><td colspan="4"><em>Telephone where Parent/Guardian may be reached</em></td></tr>
		<tr><td><em>Business</em></td><td>&nbsp;</td><td colspan="2"><em>Home</em></td></tr>
		<tr>
			<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td colspan="2"><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		</tr>
	</table><br><br>
	</div>
	
	<!--- FOOTER OF TABLE --->
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr height="8">
			<td width="8"><img src="#vStudentAppRelativePath#pics/p_bottonleft.gif" width="8"></td>
			<td width="100%" class="tablebotton"><img src="#vStudentAppRelativePath#pics/p_spacer.gif"></td>
			<td width="42"><img src="#vStudentAppRelativePath#pics/p_bottonright.gif" width="42"></td>
		</tr>
	</table>
	
	
	<cfif NOT LEN(URL.curdoc)>
	</td></tr>
	</table>
	</cfif>

</cfif>

</cfoutput>
</body>
</html>