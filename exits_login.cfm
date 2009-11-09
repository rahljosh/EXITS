<HTML>
<HEAD>
<TITLE>EXITS - EXchange Information Technologis System Login Portal</TITLE>
<META NAME="Keywords" CONTENT="homestay, exchange student, foreign students, student exchange, work and travel, trainee program, trainee, foreign students, foreign exchange, student exchange, student exchange program, high school, high school program">
<META NAME="Description" CONTENT="SMG helps manage 4 American Foreign Exchange companies. ISE, INTO, DMD and ASA are all experts in the placement of foreign students in American public and private high schools.  SMG also helps manage Work and Travel programs as well as the Trainee Programs for university students.  SMG provides the managerial leadership that has quickly moved SMG and its affiliates to the top of the exchange industry.  Its emphasis on quality performance for all of its employees and independent contractors has made SMG unique among its competitors.  The quantitative growth of SMG to over 3,000 students annualy is only one indicator of its qualitative nature.">
<META NAME="Author" CONTENT="support@student-management.com">
<link href="flash/style.css" rel="stylesheet" type="text/css">
</HEAD>
<BODY>
<style type="text/css">
body {font:Arial, Helvetica, sans-serif;}
.thin-border{ border: 1px solid #000000;
			  font:Arial, Helvetica, sans-serif;}
.dashed-border {border: 1px dashed #FF9933;}
    </style>
<div align="center">
  <table width="770" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img src="images/int_agent.gif" width="770" height="43"></td>
    </tr>
    <tr>
      <td background="flash/images/about_02.gif"><div align="center" class="style1"><br>
       <h3>EXITS Login</h3>
        </div>
        <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="100%">
			<cfif not isDefined('form.email')>
			<p class="style3">All International Agents have user accounts created on the SMG system. Please enter the requestd information below.<br>
            	<br>
				
				 <form method="post" action="int_agent.cfm">
				 <div align="center" class="style3">Email Address: <input type="text" name="email" size=25> <input type="submit" value="submit"></div>
			  </p>
			  	
				</form>
			  	<cfelse>
				<cfquery name="check_email" datasource="mysql">
				select username, password, email
				from smg_users
				where username = '#form.email#' and usertype = 8
				</cfquery>
				<cfif check_email.recordcount neq 1>
				<cfoutput>
				We do not have an account with that email address associated with it.  This could be due to a misspelling on our end, or outdated records. 
				Please fill in the following information and your account will be manually verified and your login information sent.
				<form method="post" action="send_account_info.cfm">
				<table align="center">
					<tr>
						<td>Business Name:</td><td> <input type="text" name="businessname" size=20></td>
					</tr>
					<tr>
						<td>Email:</td><td> <input type="text" name="email" size=20 value=#form.email#></td><td>*account info will be sent to this address</td>
					</tr>
					<tr>
						<td>Address:</td><td> <input type="text" name="address" size=20></td>
					</tr>
					<tr>
						<td>Address:</td><td> <input type="text" name="address2" size=20></td>
					</tr>
					<tr>
						<td>City:</td><td> <input type="text" name="city" size=20></td>
					</tr>
					<tr>
						<td>Country:</td><td> <input type="text" name="country" size=20></td>
					</tr>
					<tr>
						<td>Phone:</td><td> <input type="text" name="phone" size=20></td>
					</tr>
					
				</table>
				<br>
				<div align="center"><input type="submit" value="submit"></form>
				</cfoutput>
				<br><br>
				If live support is available, you can request your information through them as well.
				<table cellpadding="0" cellspacing="0" border="0"><tr><td align="center"><a href="http://srv0.velaro.com/visitor/requestchat.aspx?siteid=2837&showwhen=inqueue" target="VelaroChat"  onClick="this.newWindow = window.open('http://srv0.velaro.com/visitor/requestchat.aspx?siteid=2837&showwhen=inqueue', 'VelaroChat', 'toolbar=no,location=no,directories=no,menubar=no,status=no,scrollbars=no,resizable=yes,replace=no');this.newWindow.focus();this.newWindow.opener=window;return false;"><img alt="Velaro Live Help" src="http://srv0.velaro.com/visitor/check.aspx?siteid=2837&showwhen=inqueue" border="0"></a></td></tr><tr><td align="center"></b></a></font></td></tr></table>
			</div>
				
				<cfelse>
				Your login information has been sent to your email address. If you do not receive the email with in
				20 minutes, please contact <a href="mailto:ssupport@student-management.com">support@student-management.com</a>.  
				<br><br>Once you have received your login information you can login at <A href="http://www.student-management.com">www.student-management.com</A>
				
				</cfif>
			  </cfif>
			  </td>
          </tr>
      </table></td></tr>
    <tr>
      <td><img src="flash/images/about_04.gif" width="770" height="79"></td>
    </tr>
  </table>
</div>
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-880717-1";
urchinTracker();
</script>
</BODY>
</HTML>