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
	<cfparam name="email" default="Not filled in the request form">
  
	<cfset desc = 'Exchange Service International Email Signup:'>
  
 
  <cfif url.request is 'send'>
    <cfmail to="info@exchange-service.org" from='Exchange Service International <info@exchange-service.org>' subject="Add me to your Email list: Keep me informed" bcc="jeimi@exitgroup.org" type="html">

    #desc# We will get back with you as soon as possible. #dateformat(Now())#.<Br /> <Br />
      
    <strong>Email:</strong> #form.email#<br /> 
    
    </cfmail>
    
     <strong>Your email has been successfully submitted to Exchange Service International.</strong><br>
	
  </cfif>