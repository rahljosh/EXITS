<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
<link href="css/maincss.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div id= "mainbody">
<div id="sidebar">
      <div id="AccountLogin">
        <div id="loginInfo"><span class="Login">USER ID</span> <form method="post" action="internal/loginprocess.cfm">
          <input type="text" name="username" label="user id" message="A username is required to login." required="yes" />
        <br />
        <form id="form1" name="form1" method="post" action="">
          <span class="Login">PASSWORD</span>
          <input type="password" name="password" label="password" message="A password is required to login." required="yes"/>
          <span class="loginButton">Forget Login? </span>
          <input name="Submit" type="submit" value="Login" />
          <br />
        </form>
        <div class="LoginBut">
          <a href="http://case.exitsapplication.com/"><img src="/var/www/html/case/images/JanStudents.png" width="137" height="20" border="0" /></a>
        </div>
        </div>
      </div>
      <div id="sidebarEnd"></div>
      <div id="sidebarSpacer"></div>
      <div id="hostfamilyinfo"></div>
          <ul><li class="List"><a href="/viewStudents.cfm">View Students</a></li>
      <li class="List"><a href="/contactARep.cfm">Become a Host Family</a></li></ul>
      <div id="studentinfo"></div>
          <ul><li class="List"><a href="/studentTours.cfm">Student Tours</a></li>
      <li class="List"><a href="/contactAStudent.cfm">Become a Student</a></li>
      <li class="List"><a href="http://www.esecutive.com/index.php">Student Insurance</a></li></ul>
       <div id="repInfo"></div>
           <ul>
           <li class="List"><a href="/beARep.cfm">Become a Rep</a></li></ul>
      <div id="sidebarEnd"></div>
      <div id="sidebarSpacer"></div>
    </div>
    </div>
</body>
</html>
