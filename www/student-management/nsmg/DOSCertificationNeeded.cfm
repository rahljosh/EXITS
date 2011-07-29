<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>DOS Certification</title>
<link href="http://iseusa.com/css/ISEStyle.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
.wrapper {
	width: 700px;
	margin-right: auto;
	margin-left: auto;
}
.info {
	width: 580px;
	margin-right: auto;
	margin-left: auto;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 13px;
}
.infoBold {
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
}
.infoItalic {
	font-style: italic;
	font-family: Arial, Helvetica, sans-serif;

}
.clear {
	display: block;
	clear: both;
	height: 10px;
}
.boxTile2 {
	background-image: url(http://iseusa.com/login/images/loginTile.png);
	background-repeat: repeat-y;
	width: 700px;
}
.topColor {
	background-color: #073E55;
	height: 60px;
	width: 580px;
	float: left;
	margin-top: 25px;
}
#tripLogo {
	background-color: #FFF;
	height: 100px;
	width: 125px;
	position: absolute;
	z-index: 200;
}
-->
</style>
</head>

<body>
<script type="text/javascript">
function highlight(checkbox) {
   if (document.getElementById) {
      var tr = eval("document.getElementById(\"TR" + checkbox.value + "\")");
   } else {
      return;
   }
   if (tr.style) {
      if (checkbox.checked) {
         tr.style.backgroundColor = "lightgreen";
      } else {
         tr.style.backgroundColor = "white";
      }
   }
}
</script>




<cfoutput>
<div class="wrapper">
      <div class="boxTop"></div>
      <div class="boxTile2">
        <div class="info">
			<!----
          <div id="tripLogo"><img src="https://ise.exitsapplication.com/nsmg/pics/logos/#client.companyid#_header_logo.png"/></div>
            <div class="topColor"> 
            <h2 align="center">Account Suspended</h2><!-- end topColor --></div>---->

<span class="infoBold"><table align="center">
          	<tr>
            	<td><img src="http://www.iseusa.com/images/shucks.png" width="70" height="71" /></td>
            	<td><h1>Aw, Shucks...</h1></td>
            </tr>
          </table></span>
<p class="infoBold">
  
  <br /><br />
  
  Don't worry, you didn't do anything wrong, all new accounts are suspended if you haven't completed the 'Department of State Certification Test' within 30 days of your account being created. All Area Representatives are required to take the DOS Certification Test.<Br />
  <Br />
  You should have received an email from no_reply@traincaster.com with your login information. To take the test and/or retrieve your login information please visit:</p>
<p class="infoBold"> <a href="https://doslocalcoordinatortraining.traincaster.com/" target="_blank">https://doslocalcoordinatortraining.traincaster.com</a> <br />
  </p>
<p class="infoBold">If you have forgotten your login information, they will re-email it to you, be sure to check your spam folder if you don't receive it shortly after submitting the form. <Br /><br />
Once your test results are received, usually with in 24 hours, your account will be unlocked.
</p>
<span class="infoBold">
<h2>&nbsp;</h2>

</span>
<!-- end info --></div>
<div class="clear"></div>
<!-- end boxTile --></div>
      <div class="boxBot"></div>
  <!-- end wrapper --></div>
</cfoutput>
</body>
</html>







