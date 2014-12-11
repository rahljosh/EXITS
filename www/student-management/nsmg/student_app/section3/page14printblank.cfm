

<cfif LEN(URL.curdoc) OR IsDefined('url.path')>
	<cfset path = "">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [14] - Authorization to Treat a Minor</title>
	<style type="text/css">
	<!--
	body {
		margin-left: 0.3in;
		margin-top: 0.3in;
		margin-right: 0.3in;
		margin-bottom: 0.3in;
	}
	-->
	</style>	
</head>
<Cfquery name="companyInfo" datasource="#APPLICATION.dsn#">
    select *
    from smg_companies
    where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
      </Cfquery>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [14] - Authorization to Treat a Minor and HIPAA Release</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page14printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<cfsavecontent variable="publicAgreement">

<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td>
    <article style="font-size:10px;">
<h3>Authorization to Treat a Minor <cfif client.companyid neq 13> and HIPAA Release</cfif><br></h3>
<p>(We) the undersigned parent(s), or legal guardian of _________________________________________, (hereafter "Exchange Student"), do hereby authorize and consent to the following: </p>
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
</article>
</cfif>
</td></tr>
</table><br>
	</cfsavecontent>
    
    <cfsavecontent variable="phpAgreement">
<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td>
    <article style="font-size:10px;">
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
</article>
</td></tr>
</table><br> 
    
    
    </cfsavecontent>
    <cfif client.companyid eq 6>
    	#phpAgreement#
    <cfelse>
    	#publicAgreement#
    </cfif>
	
	<hr class="bar"></hr><br><br>
	
	<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td><em>Parent/Guardian Signature</em></td><td>&nbsp;</td><td colspan="2"><em>Date</td></tr>
		<tr>
			<td><br><img src="../pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td colspan="2"><br><img src="../pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		</tr>
	
	</table><br><br>
	</div>


<!--- FOOTER OF TABLE --->


<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>


</body>
</html>

