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
	<cfparam name="industry" default="Not filled in the request form">
	<cfparam name="address" default="Not filled in the request form">
	<cfparam name="city" default="Not filled in the request form">
	<cfparam name="zip" default="Not filled in the request form">
	<cfparam name="primaryContact" default="Not filled in the request form">
	<cfparam name="phoneNumber" default="Not filled in the request form">
	<cfparam name="phoneType" default="Not filled in the request form">
    <cfparam name="faxNumber" default="Not filled in the request form">
	<cfparam name="email" default="Not filled in the request form">
	<cfparam name="start" default="Not filled in the request form">
	<cfparam name="end" default="Not filled in the request form">
    <cfparam name="hire" default="Not filled in the request form">
	<cfparam name="experience" default="Not filled in the request form">
    <cfparam name="housing" default="Not filled in the request form">
    <cfparam name="pickup" default="Not filled in the request form">
    <cfparam name="comment" default="Not filled in the request form">
  
	<cfset desc = 'SUMMER WORK & TRAVEL - How to Apply Info'>
  
 
  <cfif url.request is 'send'>
    <cfmail to="#form.email#, anca@csb-usa.com" from="info@csb-usa.com" subject="CSB How to Apply Form" bcc="jeimi@exitgroup.org" type="html">

    #desc# from the CSB How to Apply Form on the web site on #dateformat(Now())#.
      
	<p><strong>Company Name:</strong> #form.companyName#<br />
    <strong>Industry:</strong> #form.industry#<br />
    <strong>Mailing address:</strong> #form.address#,#form.city# , #form.zip#<br />
    <strong>Primary Contact:</strong>#form.primaryContact#<br />
    <strong>Telephone Number:</strong> #form.phoneNumber#  type: #form.phoneType#<br />
    <strong>Fax Number:</strong> #form.faxNumber#<br />
    <strong>E-Mail:</strong> #form.email#<br />
    <strong>Hiring need:</strong> <em>Start date:</em> #form.start#, <em>End date:</em> #form.end#<br />
    <strong>How many Summer Work Travel participant you wish to hire?</strong> #form.hire#<br />
     <strong>Do you have previous experience with J-1 programs?</strong> #form.experience#<br />
     <strong>Would you be able to provide housing?</strong> #form.housing#<br />
     <strong>Would you be able to assist with pick-up?</strong> #form.pickup#<br />
      <strong>Comments:</strong> #form.comment#</p>
                  <p>&nbsp;</p>
    
      
--
    </cfmail>
    
     <strong>The following information has been succesfully submitted to CSB Summer Work and Travel.</strong><br><cfoutput>
                  <table width=90% align="center">
	      <tr>
		        <td class="text">
                  
<p><strong>Company Name:</strong> #form.companyName#<br />
    <strong>Industry:</strong> #form.industry#<br />
    <strong>Mailing address:</strong> #form.address#,#form.city# , #form.zip#<br />
    <strong>Primary Contact:</strong>#form.primaryContact#<br />
    <strong>Telephone Number:</strong> #form.phoneNumber#  type: #form.phoneType#<br />
    <strong>Fax Number:</strong> #form.faxNumber#<br />
    <strong>E-Mail:</strong> #form.email#<br />
    <strong>Hiring need:</strong> <em>Start date:</em> #form.start#, <em>End date:</em> #form.end#<br />
    <strong>How many Summer Work Travel participant you wish to hire?</strong> #form.hire#<br />
     <strong>Do you have previous experience with J-1 programs?</strong> #form.experience#<br />
     <strong>Would you be able to provide housing?</strong> #form.housing#<br />
     <strong>Would you be able to assist with pick-up?</strong> #form.pickup#<br />
      <strong>Comments:</strong> #form.comment#</p>
                  <p>&nbsp;</p></td>
	        </tr>
      </table>
    </cfoutput>
  </cfif>