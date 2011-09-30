<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Tour FAQs</title>
<link href="../css/maincss.css" rel="stylesheet" type="text/css" />

<style type="text/css">
<!--
a:link {
	color: #003;
	text-decoration: none;
}
a:visited {
	color: #003;
	text-decoration: none;
}
a:hover {
	color: #003;
	text-decoration: none;
}
a:active {
	color: #003;
	text-decoration: none;
}
a {
	font-weight: bold;
}
.lightGreen {
	color: #000;
	
	background-repeat: repeat;
	text-align: center;
	background-color: #a5aac7;
}
h1 {
	font-family: Arial, Helvetica, sans-serif;
	border-bottom-width: medium;
	border-bottom-style: double;
	border-bottom-color: #999;
}
-->
</style>
<script language="javascript"> 
function toggle(showHideDiv, switchImgTag) {
        var ele = document.getElementById(showHideDiv);
        var imageEle = document.getElementById(switchImgTag);
        if(ele.style.display == "block") {
                ele.style.display = "none";
		imageEle.innerHTML = '<img src="../images/buttons/yesme.png">';
        }
        else {
                ele.style.display = "block";
                imageEle.innerHTML = '<img src="../images/buttons/yesme.png">';
        }
}
</script>
</head>

<body>

<cfsilent>
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    <!----Set Default Properties---->
    <Cfquery name="getStudentInfo" datasource="mysql">
    select s.familylastname, s.firstname, s.email, c.countryname , s.uniqueid, s.randid
    from smg_students s
    LEFT JOIN smg_countrylist c on c.countryid = s.countrybirth
     where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.verifiedStudent#"> 
    </cfquery>
    <cfparam name="FORM.emailTo" default="#getStudentInfo.email#">
</cfsilent>





<Cfif isDefined('form.sendEmail')>
	<cfif not isValid("email", FORM.emailTO)>
		 <cfscript>
                // Primary
                if (1 eq 1 ) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("This email address does not appear to be valid.");
                }		
         </cfscript>
	<cfelse>
		<cfoutput>
            <cfquery datasource="mysql">
            update smg_students
            set email = '#form.emailTO#'
            where studentid = #client.verifiedStudent#
            limit 1
            </cfquery>
           <cfsavecontent variable="emailMessage">
                        <p>A request to register for a trip with MPD has been received from the CASE website.  Please verify that you can receive email at this address.</p>
                        <p>To verify your account click on this link: <a href="http://www.case-usa.org/trips/step3.cfm?verify=#getStudentInfo.uniqueid#&email=#form.emailTo#">Verify My Account</a> </p>
                        <Br /><br />
                        <p>If that link doesn't work, copy this link into your browser: http://www.case-usa.org/trips/step3.cfm and enter the code below.</p>
                        <p>Verification Code: #getStudentInfo.randid# 
                       
           </cfsavecontent>
           <!--- send email --->
                    <cfinvoke component="cfc.email" method="send_mail">
                   
                    <cfinvokeargument name="email_to" value="#FORM.emailTo#">
					
                        <cfinvokeargument name="email_cc" value="trips@iseusa.com">
                        <cfinvokeargument name="email_subject" value="Email Verification">
                        <cfinvokeargument name="email_message" value="#emailMessage#">
                        <cfinvokeargument name="email_from" value="""Trip Support"" <trips@iseusa.com>">
                    </cfinvoke>
                    <cfset client = StructClear(client)>
                    <cflocation url="step3.cfm" addtoken="no">
        </cfoutput>
    </cfif>
</Cfif>

<div id="wrapper">
<cfinclude template="../includes/header.cfm">
<div id="mainbody">
<cfinclude template="../includes/leftsidebar.cfm">
<div id="trip">

<gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />

<h1>Please verify that this is you:</h1>
<Cfoutput>
<Table>
	<Tr>
    	<Td width=60%>
        <!----Student Info---->
            <table border=0>
                <tr>
                  <td rowspan=2><img src="http://ise.exitsapplication.com/nsmg/uploadedfiles/web-students/#client.verifiedStudent#.jpg" height=150/></td>
                    <td rowspan=2>&nbsp;</td><Td><span class="greyText">Name</span><br /><span class="bigLabel"> <strong>#Left(getStudentInfo.firstname, 1)#. #getStudentInfo.familylastname#</strong></span></Td>
                </tr>
            
                <tr>
                    <Td valign="top"><span class="greyText">Country of Birth</span><br /><span class="bigLabel"><strong>#getStudentInfo.countryname#</strong></span></td>
                </tr>
            </table>
		</td>
        <td>
        <!----Yes / N0----->
       
        	<Table>
            	<Tr>
                	<td>
                      <div id="headerDivImg">
        			  	 <a id="imageDivLink" href="javascript:toggle('contentDivImg', 'imageDivLink');"><img src="../images/buttons/Yesme.png" border=0 /></a> 
                      </div>
                    </td>
                </Tr>
                <Tr>
                	<Td><a href="step1.cfm?no"> <img src="../images/buttons/nome.png" border=0 /> </Td>
            	</Tr>
            </Table>
        </td>
      </Tr>
  </Table>
  <br /><Br />
        <div id="contentDivImg" style="display: none;"> 
          <strong>To continue, please enter an email address of an account that you can access.  You will need to verify this email address before you can finish registering for your trip.</strong>
        <cfform action="step2.cfm" method="post">
        <input type="hidden" name="sendEmail" />
          <table align="Center">
            <Tr>
                <td><span class="greyText">Email Address</span></td><Td><input type="text" size="20" name="emailTo" value="#FORM.emailTo#" /></Td>
            </Tr>
            <Tr>
            	<td colspan=2><em>Please confirm that your email address is correct, then click submit and check your email immediately for further information on your trip</em></td>
            </Tr>
            <tr>
            	<td align="Center" colspan=2><input type="image" src="../images/buttons/submitBlue.png" /></td>
            </tr>
           </table>
           <br />
         
           </cfform>
            </div>


</Cfoutput>


    <!-- trips --></div>
    <!-- mainbody --> </div>
    <div class="clearfix"></div>
<cfinclude template="../includes/footer.cfm">
<!-- wrapper --></div>



</body>
</html>
