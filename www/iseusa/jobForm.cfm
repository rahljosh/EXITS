<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
<style type="text/css">
<!--
-->
.loginBox {
	float: right;
	height: 52px;
	width: 300px;
	margin-top: 10px;
	margin-right: 20px;
	padding: 30px;
	background-color: #CCC;
}
.testimonial {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 13px;
	font-style: italic;
	line-height: 16px;
	padding: 10px;
}
.succes {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 13px;
	line-height: 16px;
	padding: 10px;
	background-color: #3F9;
}
.testimonialBold {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 13px;
	font-style: italic;
	line-height: 16px;
	padding: 10px;
	font-weight: bold;
}
</style>
</head>
<!----Query to get states and id's---->

<cfquery name="states" datasource="#APPLICATION.DSN.Source#">
select id, state, statename
from smg_states
</cfquery>

<cfoutput>
<body class="oneColFixCtr">
<div id="topBar">
<cfinclude template="topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="title.cfm"><!-- end title --></div>
<div class="tabsBar"><cfinclude template="tabsBar.cfm"><!-- end tabsBar --></div>
<div id="mainContent">
  <div id="mainContent2">
    <div id="subPages">
      <div class="whtTop"></div>
      <div class="whtMiddle">
        <div class="subPic"><img src="images/beArep.png" width="415" height="277" alt="Meet our Students" />
          <div class="loginBox">
          <cfif isDefined('form.send_email')>
            <cfoutput>
         <cfsavecontent variable="email_message">
 
         
The following information was submitted from www.iseusa.com in regards to job opportunities.<br />
<Br />
<table>
	<tr>
    	<td>Position:</td><td>#form.job_type#</td>
    </tr>  
   	<tr>
    	<td>Submitted:</td><td>#DateFormat(now(), 'mm/dd/yy')# at #TimeFormat(now(),'h:m tt')#</td>
    </tr>  
	<tr>
    	<td>Name: </td><td>#form.firstname# #form.lastname#</td>
    </tr>
	<tr>
    	<td>Address:</td><td>#form.address#</td>
    </tr>    
	<tr>
    	<td>City:</td><td>#form.city#</td>
    </tr>    
	<tr>
    	<td>State:</td><td>#state#</td>
    </tr>  
	<tr>
    	<td>Zip:</td><td>#form.zip#</td>
    </tr>  
	<tr>
    	<td>Phone:</td><td>#form.phone#</td>
    </tr>  
	<tr>
    	<td>Email:</td><td>#form.email#</td>
    </tr>  
</table>
<br />
#form.comments#<br /><br />
Sent From: #cgi.HTTP_REFERER#
    </cfsavecontent>
			    </cfoutput>
			<!--- send email --->
            <cfinvoke component="cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="bob@iseusa.com">
                <cfinvokeargument name="email_subject" value="ISE Job Opportunities">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="International Student Exchange <support@iseusa.com>">
            </cfinvoke>
                      <span class="success">Thank you for your interest in International Student Exhange.  You should be contacted shortly regarding this position.</span>
          <cfelse>
          
          <span class="testimonial"><cfif form.job_type is "Manager">""Our Area Rep is very helpful and has been available to our family any time we needed to talk to her." Jan Gavilanes- Host Mother<cfelse>"We have hosted for several years now with ISE. I enjoyed this organization so much that I became a rep for them." Sue Kinney- Area Representative</cfif></span>
          </cfif>
          </div>
        </div>
        <div class="formRep">
          <p class="p1"><span class="bold">Job Opportunities</span><br /></p>
         <p>First Name<br />
         <cfoutput>
         <form method="post" action="jobForm.cfm">
         <input name="send_email" type="hidden" />
            <input type="text" name="firstname" id="First Name" />
            <br />
            Last Name<br />
            <input type="text" name="lastname" id="First Name2" />
            <br />
            Email<br />
            <input type="text" name="email" id="First Name3" />
            <br />
            Street Address
            <br />
            <input type="text" name="address" id="First Name4" />
            <br />
            City
            <br />
            <input type="text" name="city" id="First Name5" />
            <br />
            State of Residence<br />
		    <select name="state">
		      <option value="0"></option>
		      <cfloop query="states">
		        <option value=#state#>#state# - #statename#</option>
		        </cfloop>
		      </select>
            <br />
            Zip Code<br />
            <input type="text" name="zip" id="First Name7" />
            <br />
            Home Phone<br />
            <input type="text" name="phone" id="First Name8" />
            <br />
          Cell Phone<br />
            <input type="text" name="cellphone" id="First Name9" />
            <br />
            Why are you interested in this position</span><span class="loginButton"><br />
            
            <textarea name="comments" id="comments" cols="25" rows="5"></textarea>
            <br />
            Position: <cfif form.job_type is not ''>#form.job_type#<cfelse>Not Defined</cfif><br />
            <input type="hidden" name="job_type" value="#form.job_type#" />
            <input type="image" src="images/submitRed.png" />
          </p>
        </form>
        </cfoutput>
        </div>
        
<p class="p1">&nbsp;</p>
        <!-- end whtMiddle -->
      </div>
      <div class="whtBottom"></div>
      <!-- end lead -->
    </div>
    <h1>&nbsp;</h1>
    <!-- end mainContent -->
  </div>
</div>
<!-- end container -->
</div>

</cfoutput>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">

