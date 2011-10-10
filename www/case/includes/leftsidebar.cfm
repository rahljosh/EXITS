  <div id="sidebar">
      <div id="AccountLogin">
        <div id="loginInfo"> 
        <div class="LoginBut">   <cfif isDefined('url.old')>
        <span class="Login">USER ID</span> <form method="post" action=" http://www.case-usa.org/internal/loginprocess.cfm">
          <input type="text" name="username" label="user id" message="A username is required to login." required="yes" />
        <br />
        <form id="form1" name="form1" method="post" action="">
          <span class="Login">PASSWORD</span>
          <input type="password" name="password" label="password" message="A password is required to login." required="yes"/>
          <span class="loginButton">Forget Login? </span>
          <input name="Submit" type="submit" value="Login" />
         <br />
        </form>
        <cfelse>
        <div class="LoginBut"><a href="http://case.exitsapplication.com/"><img src="../images/login.png" width="150" height="32" alt="login" border="0"/></a><br /><Br />
        </div>
        </cfif>
        </div>
        <div class="clearfix"></div>
        <!-- end LoginBut -->
        </div><!-- end LoginInfo -->
        <div class="clearfix"></div>
      </div><!-- end AccountLogin -->
      <div id="sidebarEnd"></div>
      <div id="sidebarSpacer"></div>
      <div id="hostfamilyinfo"></div>
          <ul><li class="List"><a href="../viewStudents.cfm">View Students</a></li>
      <li class="List"><a href="../contactARep.cfm">Become a Host Family</a></li></ul>
      <div id="studentinfo"></div>
          <ul><li class="List"><a href="http://www.case-usa.org/trips/studentTours.cfm">Student Tours</a></li>
      <li class="List"><a href="../contactAStudent.cfm">Become a Student</a></li>
      <li class="List"><a href="http://www.esecutive.com/index.php">Student Insurance</a></li></ul>
       <div id="repInfo"></div>
           <ul>
           <li class="List"><a href="../beARep.cfm">Become a Rep</a></li></ul>
      <div id="sidebarEnd"></div>
</div><!-- end sidebar -->
