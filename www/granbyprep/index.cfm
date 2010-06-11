<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<link rel="shortcut icon" href="favicon.ico" />
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Granby Prep Academy</title>
<style type="text/css">
<!--
body {
	font: 100% Verdana, Arial, Helvetica, sans-serif;
	background: #666666;
	margin: 0; /* it's good practice to zero the margin and padding of the body element to account for differing browser defaults */
	padding: 0;
	text-align: center; /* this centers the container in IE 5* browsers. The text is then set to the left aligned default in the #container selector */
	color: #000000;
}

/* Tips for Elastic layouts 
1. Since the elastic layouts overall sizing is based on the user's default fonts size, they are more unpredictable. Used correctly, they are also more accessible for those that need larger fonts size since the line length remains proportionate.
2. Sizing of divs in this layout are based on the 100% font size in the body element. If you decrease the text size overall by using a font-size: 80% on the body element or the #container, remember that the entire layout will downsize proportionately. You may want to increase the widths of the various divs to compensate for this.
3. If font sizing is changed in differing amounts on each div instead of on the overall design (ie: #sidebar1 is given a 70% font size and #mainContent is given an 85% font size), this will proportionately change each of the divs overall size. You may want to adjust based on your final font sizing.
*/
.oneColElsCtrHdr #container {
	width: 831px;  /* this width will create a container that will fit in an 800px browser window if text is left at browser default font sizes */
	background: #FFFFFF; /* the auto margins (in conjunction with a width) center the page */
	border: 1px solid #000000;
	text-align: left; /* this overrides the text-align: center on the body element. */
	margin-top: 0;
	margin-right: auto;
	margin-bottom: 0;
	margin-left: auto;
}
.oneColElsCtrHdr #header {
	padding: 0;  /* this padding matches the left alignment of the elements in the divs that appear beneath it. If an image is used in the #header instead of text, you may want to remove the padding. */
	background-color: #DDDDDD;
	background-image: url(images/header.png);
	background-repeat: no-repeat;
	height: 526px;
	width: 831px;
} 
.oneColElsCtrHdr #header h1 {
	margin: 0; /* zeroing the margin of the last element in the #header div will avoid margin collapse - an unexplainable space between divs. If the div has a border around it, this is not necessary as that also avoids the margin collapse */
	padding: 10px 0; /* using padding instead of margin will allow you to keep the element away from the edges of the div */
}
.oneColElsCtrHdr #mainContent {
	padding: 0;
	background-color: #FFFFFF;
	background-image: url(images/mission.png);
	background-repeat: no-repeat;
	height: 131px;
	width: 831px;
}
.oneColElsCtrHdr #footer {
	background-image: url(images/footer.png);
	background-repeat: no-repeat;
	height: 78px;
	width: 831px;
	padding: 0;
} 
.oneColElsCtrHdr #footer p {
	margin: 0; /* zeroing the margins of the first element in the footer will avoid the possibility of margin collapse - a space between divs */
	padding: 10px 0; /* padding on this element will create space, just as the the margin would have, without the margin collapse issue */
}a:link {
	color: #000;
	text-decoration: none;
}
a:hover {
	color: #1269AA;
	text-decoration: underline;
}
a:active {
	color: #000;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
}
#menu {
	text-align: center;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	height: 25px;
	padding-top: 8px;
}
-->
</style></head>

<body class="oneColElsCtrHdr">

<div id="container">
  <div id="header">
  <!-- end #header --></div>
   <div id="menu"> <a href="about.cfm"> About Granby</a>  &nbsp;|&nbsp;  <a href="courses.cfm">Courses Offered</a> &nbsp; | &nbsp; <a href="student.cfm">Student Life</a>  &nbsp;|&nbsp; <a href="school.cfm"> School Features</a>  &nbsp;| &nbsp; <a href="sports.cfm">Sports Offered </a> &nbsp;|&nbsp;  <a href="area.cfm">Area </a> </div>
  <div id="mainContent">
    <h1>&nbsp;</h1>
	<!-- end #mainContent --></div>
  <div id="footer">
    <p>&nbsp;</p>
  <!-- end #footer --></div>
<!-- end #container --></div>
</body>
</html>
