<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/maintemplate.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!-- InstanceBeginEditable name="doctitle" -->
<title>CASE: Host Family Form</title>
<!-- InstanceEndEditable -->
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
<!-- InstanceBeginEditable name="head" -->


<link href="css/maincss.css" rel="stylesheet" type="text/css" />
<!-- InstanceEndEditable -->
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
-->
</style>

<link rel="shortcut icon" href="favicon.ico" />

</head>

<body>
<div id="wrapper">
  <div id="header">
    <div id="topBullets">
      <p><a href= "https://www.google.com/a/case-usa.org/ServiceLogin?service=mail&passive=true&rm=false&continue=http%3A%2F%2Fmail.google.com%2Fa%2Fcase-usa.org%2F&bsv=zpwhtygjntrz&ltmpl=default&ltmplcache=2" class="toprightlinks2"></a><a href= "headquarterNews.cfm" class="toprightlinks3"></a><a href= "../contact.cfm"class="toprightlinks4"></a><a href= "../FAQ.cfm"class="toprightlinks5"></a></p>
    </div><!-- end topBullets -->
  </div><!-- end header -->
  <div id="main-nav"><a href="index.cfm" class="home1"></a><a href="aboutCase.cfm" class= "about2"></a> <a href="hostFamilies.cfm" class="hostfam3"></a><a href="students.cfm" class="students4"></a><a href="representatives.cfm" class="rep5"></a><a href="contact.cfm" class="contact6"></a> </div>
  <div id= "spacer"> </div>
  <div id= "mainbody">
    <div id="sidebar">
      <div id="AccountLogin">
        <div id="loginInfo"><span class="Login">USER ID</span> <form method="post" action=" http://www.case-usa.org/internal/loginprocess.cfm">
          <input type="text" name="username" label="user id" message="A username is required to login." required="yes" />
        <br />
        <form id="form1" name="form1" method="post" action="">
          <span class="Login">PASSWORD</span>
          <input type="password" name="password" label="password" message="A password is required to login." required="yes"/>
          <span class="loginButton">Forget Login? </span>
          <input name="Submit" type="submit" value="Login" />
          <br />
        </form>
        <div class="LoginBut"><a href="http://jan.case-usa.org/"><img src="images/JanStudents.png" width="137" height="20" border=0 /></a>
        </div>
        <!-- end LoginBut -->
        </div><!-- end LoginInfo -->
      </div><!-- end AccountLogin -->
      <div id="sidebarEnd"></div>
      <div id="sidebarSpacer"></div>
      <div id="hostfamilyinfo"></div>
          <ul><li class="List"><a href="viewStudents.cfm">View Students</a></li>
      <li class="List"><a href="contactARep.cfm">Become a Host Family</a></li></ul>
      <div id="studentinfo"></div>
          <ul><li class="List"><a href="studentTours.cfm">Student Tours</a></li>
      <li class="List"><a href="contactAStudent.cfm">Become a Student</a></li>
      <li class="List"><a href="http://www.esecutive.com/index.php">Student Insurance</a></li></ul>
       <div id="repInfo"></div>
           <ul>
           <li class="List"><a href="beARep.cfm">Become a Rep</a></li></ul>
      <div id="sidebarEnd"></div>
      <div id="storeTag"></div>
           <ul><li class="List"><a href="Store/store.cfm">Start Shopping</a></li></ul>
      <div id="sidebarEnd2"></div>
    </div><!-- end sidebar -->
    <!-- InstanceBeginEditable name="MainContent" -->

<!----Query to get states and id's---->

<cfquery name="states" datasource="caseusa">
select id, state
from smg_states
</cfquery>

<cfoutput>

<div id="mainContent">
<div id="ContentTop"></div>
<div id="content">
<div id="aboutCase">
<div id="hostFamilyPic"></div>

<form id="ContactForm" name="ContactForm" method="post" action="email_rep.cfm">
          <p class="header2">Become a Host Family</p>
          <p class="forminfo">Fill out the following form to receive more information on being <br />
            a host family and a Representative in your area will contact you shortly</p>
        <p><span class="forminfo">First Name<br />
            <input type="text" name="firstname" id="First Name" />
            <input type="hidden" name="contact_type" value="host" />
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
		        <option value=#id#>#state#</option>
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
            High School Name<br />
            <input type="text" name="highschool" id="First Name10" />
            <br />
            Where did you learn about CASE<br />
            <input type="text" name="learnaboutcase" id="First Name11" />
  <br />
            Comments</span><span class="loginButton"><br />
            </span>
            <textarea name="comments" id="comments" cols="45" rows="5"><cfif isDefined('url.rp')>Please send me the password to view students on the website.
            </cfif>
            </textarea>
            <br />
            <input type="submit" name="submit" id="submit" value="Submit" />
          </p>
        </form></div>
        
</div>
<div id="Contentbottom"></div>
</div>
</cfoutput>
<!-- InstanceEndEditable -->
    </div><!-- end mainbody -->
    <!-- This clearing element should immediately follow the #mainContent div in order to force the #container div to contain all child floats --><br class="clearfloat" />
<div id="footer"><span class="footertext">264 Midland Avenue Unit 5&nbsp;&nbsp; I  &nbsp;&nbsp;Saddle Brook, NJ 07663 &nbsp;&nbsp; I  &nbsp;&nbsp; (201) 773-8299  &nbsp;&nbsp;  I  &nbsp;&nbsp;  (800) 458-8336<br />
  <span class="copyright">U.S. Department of State – Toll free: (866) 283-9090 – jvisas@state.gov</span></span></div><!-- end footer -->
  </div><!-- end #wrapper -->
</body>
<!-- InstanceEnd --></html>
