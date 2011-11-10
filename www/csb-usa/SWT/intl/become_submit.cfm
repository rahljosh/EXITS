<script>
function test(){
	/*with (document.form) {
		if (firstname.value == '') {
			alert("FIRST NAME is Required");
			firstname.focus();
			return false;
		}
	}*/
}

</script>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
		    <td width="5%">&nbsp;</td>
		    <td width="90%" class="text">
            
    <cfparam name="companyName" default="Not filled in the request form">
	<cfparam name="primaryContact" default="Not filled in the request form">
	<cfparam name="title" default="Not filled in the request form">
    <cfparam name="owner" default="Not filled in the request form">
    <cfparam name="director" default="Not filled in the request form">
	<cfparam name="email" default="Not filled in the request form">
	<cfparam name="phoneNumber" default="Not filled in the request form">
	<cfparam name="mailingAddress" default="Not filled in the request form">
    <cfparam name="city" default="Not filled in the request form">
    <cfparam name="zip" default="Not filled in the request form">
	<cfparam name="country" default="Not filled in the request form">
    <cfparam name="website" default="Not filled in the request form">
    <cfparam name="founded" default="Not filled in the request form">
    <cfparam name="license" default="Not filled in the request form">
    <cfparam name="authority" default="Not filled in the request form">
	<cfparam name="numberOffices" default="Not filled in the request form">
	<cfparam name="yearExperience" default="Not filled in the request form">
    <cfparam name="registration" default="Not filled in the request form">
    <cfparam name="numberRegistration" default="Not filled in the request form">
    <cfparam name="numberParticipants" default="Not filled in the request form">
	<cfparam name="visaDenial" default="Not filled in the request form">
	<cfparam name="sponsorWorked" default="Not filled in the request form">
    <cfparam name="studentsEnrolled" default="Not filled in the request form">
    <cfparam name="numberAssistance" default="Not filled in the request form">
    <cfparam name="vacFrom" default="Not filled in the request form">
    <cfparam name="vacTo" default="Not filled in the request form">
  
	<cfset desc = 'SUMMER WORK & TRAVEL - International Become a Partner Info'>
  
 
  <cfif url.request is 'send'>
    <cfmail to="info@csb-usa.com" cc="#form.email#"  from="info@csb-usa.com" subject="#form.country# - #form.companyName# - Become a Partner" bcc="jeimi@exitgroup.org" type="html">

    #desc# from the CSB International website #dateformat(Now())#.
      
	  <p>
      <strong>Company Name:</strong> #form.companyName#<br>
      <strong>Primary Contact:</strong> #form.primaryContact#<br>
      <strong>Title:</strong> #form.title#<br />
      <strong>Name of Owner:</strong> #form.owner#<br />
      <strong>Name of Director:</strong> #form.director#<br>
      <strong>Primary Contact Email:</strong> #form.email#<br>
      <strong>Phone Number:</strong> #form.phoneNumber#<br>
      <strong>Mailing Address:</strong> #form.mailingAddress#, #form.city#,#form.zip#<br />
      <strong>Country:</strong> #form.country#<br />
      <strong>Website:</strong> #form.website#<br />
      <strong>Date Business was Founded:</strong> #form.founded#<br />
      <strong>Business License Number:</strong> #form.license#      <br>
      <strong>Issuing Authority:</strong> #form.authority#<br>
      <strong>Number of Offices:</strong> #form.numberOffices#<br />
      <strong>Number of Years of Previous Summer Work Travel Experience:</strong> #form.yearExperience#<br />
       <strong>Do you have a registration to operate cultural exchange programs?</strong> #form.registration#<br />
       <strong>Number of Registration (if applicable):</strong> #form.numberRegistration#<br />
       <strong>Number of Summer Work Travel Participants per Year:</strong> #form.numberParticipants#<br />
       <strong>Visa denial rate (percentage):</strong> #form.visaDenial#<br />
       <strong>Previous Sponsors you have worked with:</strong> #form.sponsorWorked#<br />
       <strong>Target Number of Participants to be Enrolled with CSB:</strong> #form.studentsEnrolled#<br />
       <strong>Target Number of Participants that Would Require Placement Assistance (percentage):</strong> #form.numberAssistance#<br />
       <strong>Official Summer Vacation Dates of Participants (average):</strong> <em>From</em> #form.vacFrom# <em>To:</em> #form.vacTo#<br>
     </p>
      
--
    </cfmail>
    
     <strong>The following information has been succesfully submitted to CSB Summer Work and Travel International Become a Partner.</strong><br><cfoutput>
                  <table width=90% align="center">
	      <tr>
		        <td class="text">
     <p>
      <strong>Company Name:</strong> #form.companyName#<br>
      <strong>Primary Contact:</strong> #form.primaryContact#<br>
      <strong>Title:</strong> #form.title#<br />
      <strong>Name of Owner:</strong> #form.owner#<br />
      <strong>Name of Director:</strong> #form.director#<br>
      <strong>Primary Contact Email:</strong> #form.email#<br>
      <strong>Phone Number:</strong> #form.phoneNumber#<br>
      <strong>Mailing Address:</strong> #form.mailingAddress#, #form.city#,#form.zip#<br />
      <strong>Country:</strong> #form.country#<br /><br />
      <strong>Website:</strong> #form.website#<br />
      <strong>Date Business was Founded:</strong> #form.founded#<br />
      <strong>Business License Number:</strong> #form.license#      <br>
      <strong>Issuing Authority:</strong> #form.authority#<br><br />
      <strong>Number of Offices:</strong> #form.numberOffices#<br />
      <strong>Number of Years of Previous Summer Work Travel Experience:</strong> #form.yearExperience#<br />
       <strong>Do you have a registration to operate cultural exchange programs?</strong> #form.registration#<br />
       <strong>Number of Registration (if applicable):</strong> #form.numberRegistration#<br />
       <strong>Number of Summer Work Travel Participants per Year:</strong> #form.numberParticipants#<br />
       <strong>Visa denial rate (percentage):</strong> #form.visaDenial#<br />
       <strong>Previous Sponsors you have worked with:</strong> #form.sponsorWorked#<br />
       <strong>Target Number of Participants to be Enrolled with CSB:</strong> #form.studentsEnrolled#<br />
       <strong>Target Number of Participants that Would Require Placement Assistance (percentage):</strong> #form.numberAssistance#<br />
       <strong>Official Summer Vacation Dates of Participants (average):</strong> <em>From</em> #form.vacFrom# <em>To:</em> #form.vacTo#<br>
     </p></td>
	        </tr>
      </table>
    </cfoutput>
  </cfif>