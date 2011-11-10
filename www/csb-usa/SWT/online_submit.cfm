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
	<cfparam name="email" default="Not filled in the request form">
	<cfparam name="phoneNumber" default="Not filled in the request form">
	<cfparam name="mailingAddress" default="Not filled in the request form">
	<cfparam name="country" default="Not filled in the request form">
	<cfparam name="yearinBusiness" default="Not filled in the request form">
	<cfparam name="numberOffices" default="Not filled in the request form">
	<cfparam name="numberParticipants" default="Not filled in the request form">
	<cfparam name="visaDenial" default="Not filled in the request form">
	<cfparam name="sponsorWorked" default="Not filled in the request form">
    <cfparam name="studentEnrolled" default="Not filled in the request form">
    <cfparam name="numberAssistance" default="Not filled in the request form">
  
	<cfset desc = 'SUMMER WORK & TRAVEL - International Partner Contact'>
  
 
  <cfif url.request is 'send'>
    <cfmail from="info@csb-usa.com" to="#form.email#, anca@csb-usa.com" bcc="jeimi@exitgroup.org" subject="#form.companyName#">

    #desc# from the CSB web site on #dateformat(Now())#.
      
	Company name: #form.companyName#
	Primary Contact: #form.primaryContact#
    Title: #form.title#
    Email: #form.email#
    Phone Number: #form.phoneNumber#
    Mailing Address: #form.mailingAddress#
    Country: #form.country#
    Number of Years in Business: #form.yearInBusiness#
    Number of Offices: #form.numberOffices#
    Number Summer Work Travel Participants per Year: #form.numberParticipants#
    Visal Denial Rate (Percentage): #form.visaDenial#
    Previous Sponsors You Have Worked With: #form.sponsorWorked#
    Target Number of Students to be Enrolled with CSB: #form.studentsEnrolled#
    Number of Participants That Would Require Placement Assistance (Percentage): #form.numberAssistance#
      
--
    </cfmail>
    
     <strong>The following information has been succesfully submitted to CSB Summer Work and Travel.</strong><br><cfoutput>
                  <table width=90% align="center">
	      <tr>
		        <td class="text">
                  <p>Company name: #form.companyName#<br>
                  Primary Contact: #form.primaryContact#<br>
                  Title: #form.title#<br>
                  Email: #form.email#<br>
                  Phone Number: #form.phoneNumber#<br>
                  Mailing Address: #form.mailingAddress#<br>
                  Country: #form.country#<br>
                  Number of Years in Business: #form.yearInBusiness#<br>
                  Number of Offices: #form.numberOffices#<br>
                  Number Summer Work Travel Participants per Year: #form.numberParticipants#<br>
                  Visal Denial Rate (Percentage): #form.visaDenial#<br>
                  Previous Sponsors You Have Worked With: #form.sponsorWorked#<br>
                  Target Number of Students to be Enrolled with CSB: #form.studentsEnrolled#<br>
                  Number of Participants That Would Require Placement Assistance (Percentage): #form.numberAssistance#<br>
                  </p></td>
	        </tr>
      </table>
    </cfoutput>
  </cfif>