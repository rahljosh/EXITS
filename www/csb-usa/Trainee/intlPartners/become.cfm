
<!----Submit email---->
<Cfif isDefined('form.process')>
 
 <cfparam name="fname" default="Not filled in the request form">
 <cfparam name="companyName" default="Not filled in the request form">
    <cfparam name="address" default="Not filled in the request form">
    <cfparam name="city" default="Not filled in the request form">
    <!--<cfparam name="country" default="Not filled in the request form">-->
    <cfparam name="phone" default="Not filled in the request form">
    <cfparam name="fax" default="Not filled in the request form">
    <cfparam name="email" default="">
    <cfparam name="info" default="Not filled in the request form">

<cfmail to='sergei@iseusa.com' cc='jeimi@exitgroup.org' from='sergei@iseusa.com' subject='Become a Partner'>
     Information was submitted on the OUTBOUND web site on #dateformat(Now(), 'mm/dd/yyyy')#.
    
    Name: #form.fname#
    Company Name: #form.companyName#
    Address: #form.address#
    City: #form.city#
    Country: #form.country#
    Zip: #form.zip#
    Phone: #form.phone#
    Fax: #form.fax#
    E-Mail Address: #form.email#

    <!---Comments: #form.info#--->
    
    </cfmail>
</cfif>

<style type="text/css">
.mainContent {
	font-family: Verdana, Geneva, sans-serif;
	font-size: 10px;
}
.formText {
	font-family: Verdana, Geneva, sans-serif;
	font-size: 10px;
}
</style>

<div id="mainContent">
<h2>Become a Partner</h2>
<p> To become a CSB partner please fill out the form below and one of our Representatives will get back with you. We look forward to working with you.</p>
  <cfif isDefined('form.process')>
   
   Your message was sent!
   <cfelse>    		
			<!----Query to get states and id's---->
<cfquery name="states" datasource="caseusa">
select id, state
from smg_states
</cfquery>
     <cfoutput>
         <cfform id="form1" name="form1" method="post" action="become.cfm">
         <span class="formText">
          <input type="hidden" name="process" />
          Name <i>(First and Last)</i>
        <br />
            <cfinput type="text" name="fname" message="Please enter your last name." validate="noblanks" required="yes" id="fname" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
           
           <span class="formText">Company Name</span><br />
            <cfinput type="text" name="address" message="Please enter your Company's Name." required="yes" id="companyName" size=22 typeahead="no" showautosuggestloadingicon="true"  /><br />
            
      <span class="formText">Address </span><br />
            <cfinput type="text" name="address" message="Please enter your street address." required="yes" id="address" size=22 typeahead="no" showautosuggestloadingicon="true"  /><br />
       
           City<br />
            <cfinput type="text" name="city" id="city" size=22  /><br />
         
           State<br />
    	   <select name="state">
		      <option value="0"></option>
		      <cfloop query="states">
		        <option value=#state#>#state#</option>
	         </cfloop>
	       </select>
           <br />
           
           Country<br />
            <cfinput type="text" name="country" message="Please enter a country" required="yes" id="country" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
    
           Zipcode <br />
            <cfinput type="text" name="zip" message="Please enter a valid zip code." validateat="onSubmit" validate="zipcode" required="yes" id="zip" typeahead="no" showautosuggestloadingicon="true" maxlength="5" /><br />
             
            
           Phone Number<br />
            <cfinput type="text" name="phone" message="Please enter a valid phone number" pattern="(999) 999-9999" required="yes" id="phone" size=22 typeahead="no"/>
            <br />
           Fax<br />
            <cfinput type="text" name="fax" message="Please enter a valid fax number" pattern="(999) 999-9999" validateat="onSubmit" validate="telephone" required="yes" id="fax" size=22 typeahead="no" showautosuggestloadingicon="true" />
            <br />
           Email<br />
            <cfinput type="text" name="email" message="Please enter a valid email address." validateat="onSubmit" validate="email" required="yes" id="email" size=22 typeahead="no" showautosuggestloadingicon="true" /></span><br /><br />
     
        
          
        
        <input type="image" src="images/submit.jpg" /><br />
        </cfform>
      </cfoutput>
</cfif>
 <br />
        <br />
</div>
