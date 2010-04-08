<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/maintemplate.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!-- InstanceBeginEditable name="doctitle" -->
<title>CASE: view students</title>
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
</style></head>

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
    <cfif not isDefined('client.viewstudents') or client.viewstudents neq 1>
    	<cflocation url="viewStudentslogin.cfm">
    
    <cfelse>
 		
 
    
	<cfquery name="get_students" datasource="mysql">
	SELECT     	studentid,  dob, firstname, interests, interests_other, smg_countrylist.countryname, smg_religions.religionname
	FROM       	smg_students
	INNER JOIN 	smg_countrylist ON smg_countrylist.countryid = smg_students.countryresident
	LEFT JOIN 	smg_religions ON smg_religions.religionid = smg_students.religiousaffiliation
    LEFT JOIN 	smg_programs ON smg_programs.programid = smg_students.programid
	WHERE 	   	smg_students.active = '1' 
			 	AND hostid = '0' 
				AND direct_placement = '0'
                AND smg_students.companyid = 10
                
	ORDER BY rand()
	LIMIT 9 
</cfquery>
<div id="mainContent">
<div id="ContentTop"></div>
<div id="content">
  <div id="aboutCase">
    <p class="header2">Incoming Students    </p>
    <p class="incomingstudenttext">Below are some of the students that are in the program this year.</p>
    <p class="incomingstudenttext"> Request more information and be contacted by a representative in your region by filling out this form.<br />
      </p>
    <p class="12ptRed">ALL STUDENTS SHOWING ON THIS WEB PAGE HAVE BEEN ASSIGNED TO A SPECIFIC REGION. ACCORDING TO OUR INTERNATIONAL AGREEMENTS, WE CANNOT TRANSFER STUDENTS OUT OF SPECIFIC REGIONS. THESE STUDENTS ARE ONLY TO BE USED AS A SAMPLE OFCASE STUDENTS AND MIGHT NOT BE AVAILABLE IN YOUR SPECIFIC REGION.</p>
    <p class="12ptRed">Refreshing your page will enable you to view more students </p>
    
   <table width="600" border="0"> 
     <cfoutput query="get_students">  
     

  <CFSET image_path1="C:\websites\student-management\nsmg\uploadedfiles\web-students\#get_students.studentid#.*">
   <CFSET image_path2="C:\websites\student-management\nsmg\uploadedfiles\web-students\#get_students.studentid#.jpg">
      <tr>
        <td><CFIF FileExists(image_path1)>
      						<span class="style1"><img src="http://case.exitsapplication.com/nsmg/uploadedfiles/web-students/#get_students.studentid#.*" width="133"> 			<cfelseif FileExists(image_path2)>
                            <span class="style1"><img src="http://case.exitsapplication.com/nsmg/uploadedfiles/web-students/#get_students.studentid#.jpg" width="133">
	   					    <CFELSE>
	        				Sorry, no picture available at this time.</span>	
	    				</CFIF></td>
        <td bgcolor="##FFFFFF">&nbsp;</td>
        <td class="gradient">
          <p class="StudentName">Name: #get_students.firstname# #get_students.studentid#<cfif dob EQ ''><cfelse>(#datediff('yyyy',dob,now())#)</cfif><br />
            Home Country: #get_students.countryname#<br />
            Religion: #get_students.religionname#<br />
            Interests:
                 <cfloop list=#get_students.interests# index=i>
				<cfquery name="get_interests" datasource="caseusa">
				Select interest 
				from smg_interests 
				where interestid = #i#
				</cfquery>
				#LCASE(get_interests.interest)# &nbsp;&nbsp; 
			</cfloop></p>
            
          <p><span class="StudentName">About #get_students.firstname#:</span> <span class="incomingstudenttext">#get_students.interests_other#</span></p>
        </td>
      </tr>
      </cfoutput>
     
    </table>
    <p class="12ptRed">&nbsp;</p>

  </div>
</div>
</cfif>
<div id="Contentbottom"></div>
</div>
<!-- InstanceEndEditable -->
    </div><!-- end mainbody -->
    <!-- This clearing element should immediately follow the #mainContent div in order to force the #container div to contain all child floats --><br class="clearfloat" />
<div id="footer"><span class="footertext">19 Charmer Court, Middletown, NJ 07748   I   (732) 671-6448    I    (800) 458-8336<br />
  <span class="copyright">U.S. Department of State – Toll free: (866) 283-9090 – jvisas@state.gov</span></span></div><!-- end footer -->
  </div><!-- end #wrapper -->
</body>
<!-- InstanceEnd --></html>
