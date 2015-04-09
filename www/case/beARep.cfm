<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CASE: Host Family Form</title>
<link href="css/maincss.css" rel="stylesheet" type="text/css" />
<!----
<style type="text/css">
<!--
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #000;
}
a:hover {
	text-decoration: none;
	color: #333;
}
a:active {
	text-decoration: none;
	color: #333;
}
-->
</style>
---->
<link href="css/maincss.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #000;
}
a:hover {
	text-decoration: none;
	color: #98002E;
}
a:active {
	text-decoration: none;
	color: #000;
}
.clearfix {
	display: block;
	clear: both;
	height: 30px;
}
-->
</style>

<link rel="shortcut icon" href="favicon.ico" />

</head>

<body>
<div id="wrapper">
 <cfinclude template="includes/header.cfm">
  <div id= "mainbody">
    <cfinclude template="includes/leftsidebar.cfm">
    
    <!----Query to get states and id's---->

<cfquery name="states" datasource="smg">
select id, state, statename
from smg_states
where id < 51
</cfquery>

<cfoutput>
  
  <div id="mainContent">
  <div id="ContentTop"></div>
  <div id="content">
  <div id="aboutCase">
  <div id="form2ContactRep"></div>
    
  <form id="ContactForm" name="ContactForm" method="post" action="email_rep.cfm">
    <p class="header2">Become a Rep</p>
    <p class="forminfo">Fill out the following form to receive more information on being <br />
      a CASE Area Representative and a Regional Manager in your <br />
      area will contact you shortly. </p>
  <p class="forminfo">&nbsp;</p>
    <p><span class="forminfo">First Name<br />
      <input type="hidden" name="contact_type" value="rep" />
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
          <option value=#id#>#state# - #statename#</option>
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
      Where did you learn about CASE<br />
      <input type="text" name="learnaboutcase" id="First Name11" />
      <br />
      Comments</span><span class="loginButton"><br />
        </span>
      <textarea name="comments" id="comments" cols="45" rows="5"></textarea>
      <br />
      <input type="submit" name="submit" id="submit" value="Submit" />
      </p>
    </form></div>
    
  </div>
  <div id="Contentbottom"></div>
  </div>
</cfoutput>
</div><!-- end mainbody -->
    <!-- This clearing element should immediately follow the #mainContent div in order to force the #container div to contain all child floats --><br class="clearfloat" />
<cfinclude template="includes/footer.cfm">
</div><!-- end wrapper -->
</body>
</html>
