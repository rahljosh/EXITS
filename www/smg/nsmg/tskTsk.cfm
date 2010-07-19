<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Tsk Tsk Tsk</title>
<link href="http://trips.exitsapplication.com/STB.css" rel="stylesheet" type="text/css" />
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
	background-image: url(http://trips.exitsapplication.com/images/loginTile.png);
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
            	<td><h1>Ah, Snap. Look at you!</h1></td>
            </tr>
          </table></span>
<span class="infoBold">
<br />
<br />
Trying to be all cleaver.  Good thinking, but we thought of it too.<Br /><br />
Please follow the instructions displayed that you are clearly trying to avoid, and your account will be restored to full access.
<br /><br />
<div align="center"><A HREF="javascript:history.go(-1)">Go back, and we'll just forget all about this little mishap</A></div>  
</span>


<!-- end info --></div>
<div class="clear"></div>
<!-- end boxTile --></div>
      <div class="boxBot"></div>
  <!-- end wrapper --></div>
</cfoutput>
</body>
</html>







