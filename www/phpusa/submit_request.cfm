<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>DMD &#45; Private High Schools Contact Us</title>
<link rel="shortcut icon" href="favicon.ico" />
<style type="text/css">
	.table {
		width: 700px;
	}
</style>
<link href="css/phpusa.css" rel="stylesheet" type="text/css" />
</head>
<body class="oneColFixCtrHdr">
<div id="container">
	<cfinclude template="header.cfm">
	<div class="spacer"></div>
	<div id="mainContent">
		
        <div class="spacerlg"></div>
		
        <cfparam name="FORM.new_account" default="person">
        <cfparam name="FORM.lastName" default="Not filled in the request form">
		<cfparam name="FORM.address" default="Not filled in the request form">
		<cfparam name="FORM.city" default="Not filled in the request form">
		<cfparam name="FORM.country" default="Not filled in the request form">
		<cfparam name="FORM.phone" default="Not filled in the request form">
		<cfparam name="FORM.fax" default="Not filled in the request form">
		<cfparam name="FORM.email" default="">
		<cfparam name="FORM.info" default="Not filled in the request form">

		<cfmail to='luke@phpusa.com' cc='craig@phpusa.com' from='php@phpusa.com' subject='Request for Info'>
            The following #FORM.new_account# requested information about PHP from the PHP web site on #dateformat(Now())#.
            
            Name: #form.lastName#
            Address: #form.address#
            City: #form.city#
            <cfif isDefined('form.country')>
            Country: #form.country#
            </cfif>
            Zip: #form.zip#
            Phone: #form.phone#
            Fax: #form.fax#
            E-Mail Address: #form.email#
		</cfmail>
<div class="spacerlg"></div>
<div class="spacerlg"></div>
<div class="clearfix"></div>
<TABLE align ="center">
  <tr>
       <td width="400px" border="0" align="right" cellpadding="0" cellspacing="0"></td>
       </tr>
              <tr>
                <td align="justify" class="menu">:: Student Form::</td>
              </tr>
           
            <tr>
            <td width="400px" align="right"></td>
          </tr>
          <tr>
            <td colspan="2" align="center"></td>
                
                  <tr>
                    <td class="menu">Request Submitted&nbsp;</td></tr></table>
                      <p class="text">
The following information was submitted to PHP: </p><cfoutput>
  <table width=400px align="center">
    <tr>
      <td class="menu"> Name: #form.lastName#<br>
        Address: #form.address#<br>
        City: #form.city#<br>
        <cfif isDefined('form.country')>
        Country: #form.country#<br>
        </cfif>
        Zip: #form.zip#<br>
        Phone: #form.phone#<br>
        Fax: #form.fax#<br>
        E-Mail Address: #form.email#<br>
        <br>
        </td>
    </tr>
  </table>
</cfoutput>
<p>You will be contacted shortly.</p>
   <div class="bottomGradient"></div>
  <!-- end #mainContent --></div>
  <div class="spacersm"></div>
<cfinclude template="footer.cfm">
  <div class="spacersm"></div>
<!-- end #container --></div>
</body>
</html>
