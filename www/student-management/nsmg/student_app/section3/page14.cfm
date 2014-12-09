<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [14] - Authorization to Treat a Minor</title>
</head>
<body>

<cftry>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cflocation url="?curdoc=section3/page14print&id=3&p=14" addtoken="no">
</cfif>

<script type="text/javascript">
<!--
function CheckLink()
{
  if (document.page14.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page14.CheckChanged.value = 1;
}
function NextPage() {
	document.page14.action = '?curdoc=section3/qr_page14&next';
	}
//-->
</SCRIPT>
<Cfquery name="companyInfo" datasource="#APPLICATION.dsn#">
    select *
    from smg_companies
    where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
      </Cfquery>
      
<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page14'>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [14] - Authorization to Treat a Minor and HIPAA Release</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page14print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section3/qr_page14" method="post" name="page14">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>

<!--- Check uploaded file - Upload File Button --->
<cfinclude template="../check_uploaded_file.cfm">
<cfsavecontent variable="publicAgreement">
<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td>
<h3>Authorization to Treat a Minor <cfif client.companyid neq 13> and HIPAA Release</cfif><br></h3>
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
<cfif client.companyid neq 13>
<h3>HIPAA-Compliant Authorization for Release of Health Information<br></h3>
<p>
I hereby authorize the protected health information for Exchange Student to be released as specified in this HIPAA compliant Authorization.
</p>
<ol>
<li>Description of Information To Be Disclosed: I authorize the release of any and all records and information pertaining to the Individual's medical care, treatment, and physical and psychological condition.</li>
<li>Entities Authorized to Disclose: I authorize any hospital, clinic or other medical facility, physician, nurse, physical or occupational therapist, chiropractor, psychiatrist, psychologist, medical practitioner, pharmacy, emergency medical service, basic life support service, advanced life support service, insurance company, the Medical Information Bureau or any other person or entity licensed to create and/or maintain protected health information for the Individual to disclose the Individual's health information as described above.</li>
<li>Information Disclosed To: I authorize the Individual's information to be disclosed to: 
<p>Company - #CLIENT.companyname# ("#CLIENT.companyshort#")  #companyInfo.address#, #companyInfo.city#, #companyInfo.state# #companyInfo.zip# 
Any of #CLIENT.companyshort#'s Student Facilitators, Program Managers, or Corporate Officers.
</p>
<p>The information will be used to assist the student, Designated Adults, and his/her natural family manage patient care. I authorize any third-party record retrieval agent to retrieve the protected health information as described above for use by Agent and other authorized recipients.</p>
</li>
<li> Expiration Date: This authorization expires three years after the date I sign it.</li>
<li> Right to Revoke: I understand that I have the right to revoke this authorization at any time by notifying Agent and the medical record custodian in writing. The revocation would not be effective for any actions taken in reliance upon this authorization prior to the receipt of revocation.</li>
<li> Re-disclosure: I recognize that protected health information disclosed to Agent or other authorized recipients may no longer be protected by HIPAA or other federal laws.</li>
<li>Eligibility for Benefits: Treatment, payment, enrollment in a health plan, or eligibility for health insurance benefits may not be conditioned on my signing this authorization.</li>
<li>Facsimiles: A copy or facsimile of this authorization is as valid as the original.</li>
<li>My Right to a Copy: I hereby understand that I have a right to a copy of this fully-executed authorization which I can obtain from #CLIENT.companyshort#’s representative in my home country
</li>
</ol>
<p>I have read and understood this authorization and authorize the disclosure of the protected health information as described above.</p>
</cfif>
</td></tr>
</table><br>
	</cfsavecontent>
    
    <cfsavecontent variable="phpAgreement">
<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td>
<h3>Authorization to Treat a Minor <cfif client.companyid neq 13> and HIPAA Release</cfif><br></h3>


<p>(We) the undersigned parent(s), or legal guardian of #get_student_info.firstname# #get_student_info.familylastname#, (hereafter "Exchange Student"), do hereby authorize and consent to the following: </p>
<p><strong>Authorization to Treat a Minor or Dependent</strong></p>
<p>I do hereby state that I have legal custody of the aforementioned Minor. I grant my authorization and consent for KCK International, Inc., that does business as the DMD Private High School Program (DMD/PHP), its officers, staff, Regional Managers, Area Representatives and Host Families (hereafter “Designated Adults”) to administer general first aid treatment for any minor injuries or illnesses experienced by the Exchange Student. If the injury or illness is life threatening or in need of professional medical treatment, I authorize the Designated Adults to summon any and all professional emergency personnel to attend, transport, and treat the minor and to issue consent for any medical or psychological treatment, and to be rendered under the general supervision of, any licensed physician, surgeon, dentist, hospital, psychologist, psychiatrist, nurse practitioner or other medical professional or institution duly licensed to practice in the state in which such treatment is to occur. I agree to assume financial responsibility for all expenses of such care. 
</p>
<p>
I also understand that certain vaccinations may be required for the Exchange Student to participate in certain schools and that the vaccination requirements vary across each state in the United States. If the documentation of these vaccinations has not been included in the student application submitted to DMD/PHP, I authorize the Designated Adults to have the required vaccines administered to the Exchange Student. I agree to assume financial responsibility for all expenses related to the administration of these vaccines.  
</p>
<p>
It is understood that this authorization is given in advance of any such medical treatment, but is given to provide authority and power on the part of the Designated Adult in the exercise of his or her best judgment upon the advice of any such medical or emergency personnel.
</p>

<h3>HIPAA-Compliant Authorization for Release of Health Information<br></h3>
<p>
I hereby authorize the protected health information for Exchange Student to be released as specified in this HIPAA compliant Authorization.
</p>
<ol>
<li>1. Description of Information To Be Disclosed: I authorize the release of any and all records and information pertaining to the Individual's medical care, treatment, and physical and psychological condition.</li>
<li> Entities Authorized to Disclose: I authorize any hospital, clinic or other medical facility, physician, nurse, physical or occupational therapist, chiropractor, psychiatrist, psychologist, medical practitioner, pharmacy, emergency medical service, basic life support service, advanced life support service, insurance company, the Medical Information Bureau or any other person or entity licensed to create and/or maintain protected health information for the Individual to disclose the Individual's health information as described above.</li>
<li>Information Disclosed To: I authorize the Individual's information to be disclosed to: 
<p>
Company – KCK International, Inc (“DMD/PHP”)  119 Cooper Street, Babylon, NY 11702 
Any of DMD/PHP’s Student Facilitators, Program Managers, or Corporate Officers.
</p>

<p>The information will be used to assist the student, Designated Adults, and his/her natural family manage patient care. I authorize any third-party record retrieval agent to retrieve the protected health information as described above for use by Agent and other authorized recipients.</p>
</li>
<li>Expiration Date: This authorization expires four years after the date I sign it.</li>
<li> Right to Revoke: I understand that I have the right to revoke this authorization at any time by notifying Agent and the medical record custodian in writing. The revocation would not be effective for any actions taken in reliance upon this authorization prior to the receipt of revocation.</li>
<li> Re-disclosure: I recognize that protected health information disclosed to Agent or other authorized recipients may no longer be protected by HIPAA or other federal laws.</li>
<li>Eligibility for Benefits: Treatment, payment, enrollment in a health plan, or eligibility for health insurance benefits may not be conditioned on my signing this authorization.</li>
<li>Facsimiles: A copy or facsimile of this authorization is as valid as the original./li>
<li>My Right to a Copy: I hereby understand that I have a right to a copy of this fully-executed authorization which I can obtain from DMD/PHP’s representative in my home country
</li>
</ol>
<p>I have read and understood this authorization and authorize the disclosure of the protected health information as described above.</p>

</td></tr>
</table><br> 
    
    
    </cfsavecontent>
    <cfif client.companyid eq 6>
    	#phpAgreement#
    <cfelse>
    	#publicAgreement#
    </cfif>
</div>
	
<!--- PAGE BUTTONS --->
<cfinclude template="../page_buttons.cfm">

</cfoutput>
</cfform>

<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>