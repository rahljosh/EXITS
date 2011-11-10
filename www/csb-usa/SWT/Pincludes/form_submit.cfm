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
            
    <cfparam name="lastName" default="Not filled in the request form">
	<cfparam name="firstName" default="Not filled in the request form">
	<cfparam name="dob" default="Not filled in the request form">
	<cfparam name="email" default="Not filled in the request form">
	<cfparam name="city" default="Not filled in the request form">
	<cfparam name="country" default="Not filled in the request form">
    <cfparam name="universityStudent" default="Not filled in the request form">
    <cfparam name="yearsStudy" default="Not filled in the request form">
	<cfparam name="comment" default="Not filled in the request form">
    <cfparam name="upload" default="Not filled in the request form">
  
	<cfset desc = 'SUMMER WORK & TRAVEL - International Partner Contact'>
  
 
  <cfif url.request is 'send'>
    <cfmail from="info@csb-usa.com" to="jeimi@exitgroup.org" subject="Apply with a CSB International Partner in your home country">

    #desc# from the CSB web site on #dateformat(Now())#.
      
	Last name: #form.lastName#
	First name: #form.firstName#
    Date of Birth: #form.dob#
    Email: #form.email#
    City: #form.city#
    Country: #form.country#
    Are you a University Student: #form.universityStudent#
    Year of Study: #form.yearsStudy#
    Do you have a job offer: #form.jobOffer#
   If Yes, Explain: #form.comment#   
--
    </cfmail>
    
     <strong>The following information has been succesfully submitted to CSB Summer Work and Travel from the apply with a CSB International Partner  in your home country.</strong><br><cfoutput>
                  <table width=90% align="center">
	      <tr>
		        <td class="text">
                 <p>Last name: #form.lastName#<br>
                  First name: #form.firstName#<br>
                  Date of Birth: #form.dob#<br>
                  Email: #form.email#<br>
                  City: #form.city#<br>
                  Country: #form.country#<br>
                  Are you a University Student #form.universityStudent#<br>
    			Year of Study: #form.yearsStudy#<br>
   				Do you have a job offer: #form.jobOffer#<br>
   				If Yes, Explain: #form.comment#><br>
                  <br>
                  </p></td>
	        </tr>
      </table>
    </cfoutput>
  </cfif>