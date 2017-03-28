<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
	<script type="text/javascript" src="js/tabs.js"></script>
     
<style type="text/css">
/* <![CDATA[ */

.sectionBody * {margin: 0; padding: 0;}

.sectionBody {
	float: right;
	margin-top: 5px;
	margin-right: 40px;
	margin-bottom: 0px;
	margin-left: 20px;
} 
.sectionBody .section.vertical a {
	color: #0068AC;
}
.sectionBody .section.vertical p {
	padding-top: 7px;
	padding-right: 7px;
	padding-bottom: 7px;
	padding-left: 7px;
	font-size: 80%;
}
.sectionBody .section.vertical .box h1, h2, h3, h4, h5 {
	font-weight: normal;
	line-height: normal;
	margin-top: 0;
	margin-right: 0;
	margin-bottom: 7px;
	margin-left: 7px;
}
.sectionBody .section.vertical .box h1 {
	font-size: 20px;
}
.sectionBody .section.vertical .box h2 {
	font-size: 16px;
	margin-left: 7px;
}
.sectionBody .section.vertical .box h3 {
	font-size: 14px;
	margin-left: 7px;
}

.sectionBody .section {
	width: 600px;
	background: #EFEFEF;
	margin: 0 0 30px;
}
.sectionBody ul.tabs {
	height: 40px;
	line-height: 42px;
	list-style: none;
	border-bottom: 1px solid #DDD;
	background: #FFF;
	font-size: 90%;
}
.sectionBody .tabs li {
	float: left;
	display: inline;
	color: #A7A9AC;
	cursor: pointer;
	background: #E6E7E8;
	border: 1px solid #E4E4E4;
	border-bottom: 1px solid #F9F9F9;
	position: relative;
	margin-top: 0;
	margin-right: 1px;
	margin-bottom: -1px;
	margin-left: 0;
	padding-top: 0;
	padding-right: 13px;
	padding-bottom: 1px;
	padding-left: 20px;
}
.sectionBody .tabs li:hover,
.sectionBody .vertical .tabs li:hover {
	color: #0068AC;
	padding: 0 13px;
	background: #7CA4C9;
	border: 1px solid #0068AC;
}
.sectionBody .tabs li.current {
	color: #444;
	background: #EFEFEF;
	padding: 0 13px 2px;
	border: 1px solid #D4D4D4;
	border-bottom: 1px solid #EFEFEF;
}
.sectionBody .box {
	display: none;
	border: 1px solid #D4D4D4;
	border-width: 0 1px 1px;
	background-color: #0068AC;
	padding: 0 12px;
}
.sectionBody .box.visible {
	display: block;
	padding: 10px;
}

.sectionBody .section.vertical {
	width: 500px;
	border-left: 160px solid #FFF;
}
.sectionBody .vertical .tabs {
	width: 160px;
	float: left;
	display: inline;
	margin: 0 0 0 -160px;
}
.sectionBody .vertical .tabs li {
	border: 1px solid #E4E4E4;
	border-right: 1px solid #F9F9F9;
	width: 132px;
	height: 40px;
	margin-top: 0;
	margin-right: 0;
	margin-bottom: 1px;
	margin-left: 0;
	padding-top: 8;
	padding-right: 13px;
	padding-bottom: 8;
	padding-left: 13px;
}
.sectionBody .vertical .tabs li:hover {
	width: 131px;
}
.sectionBody .vertical .tabs li.current {
	width: 133px;
	color: #fff;
	background: #0068AC;
	border: 1px solid #0068AC;
  border-right: 1px solid #0068AC;
  margin-right: -1px;
}
.sectionBody .vertical .box {
  border-width: 1px;
}

/* ]]> */
.box .news {
	font-size: 75%;
	font-style: italic;
	font-weight: bold;
	color: #000;
	height: 20px;
	width: 95%;
	padding-left: 20px;
	left: 0px;
	bottom: 0px;
	background-color: #E5EAF5;
	background-position: left bottom;
	padding-top: 10px;
	padding-bottom: 5px;
}
</style>

<div class="sectionBody">
<div class="section vertical">

	<ul class="tabs">
	  <li class="current">FACEBOOK</li>
      <li>NEWSLETTER</li>
      <li>WEBSTORE</li>
	</ul>

	<div class="box visible">
 <div style="background-color: #FFF; margin: 8px auto 8px auto;"><iframe
src="https://www.facebook.com/plugins/likebox.php?href=<?PHP echo $_SESSION[facebook]; ?>&amp;width=490&amp;colorscheme=light&amp;show_faces=false&amp;border_color&amp;stream=true&amp;header=true&amp;font=arial&amp;height=435" scrolling="yes" frameborder="0" style="border:none; overflow:hidden; width: 473px; height: 325px; background: white; float: left;" allowTransparency="true"></iframe>
<div class="clearfloat">&nbsp;</div>
</div>
	</div>

	<div class="box">
  <div style="background-color: #FFF; padding: 10px; margin-top: 10px; margin-bottom: 10px;">
<p align="right"><small>ISE NEWSLETTER | May 27, 2014</small></p>
<h1>The Insider</h1>

<h3>Check out our new Mini-Documentary</h3>
<p>We followed a student and her host family for an entire semester. The video showcases the experience of hosting. <a href="https://www.youtube.com/watch?v=-ScNJmjdlGo" target="_blank" class="blueLink">click here >></a></p>
<div class="dotLine">&nbsp;</div>
<br />
<h3>Project HELP Hours</h3>
<p>We sent out certificates to all of the students that registered hours. We had an estimated 25,000 hours this year of community service. If you have any pictures, send them our way.<!-- <a href="https://www.iseusa.com/student-project-help.cfm" class="blueLink">click here >></a>--></p>
<p><strong>Great Job!</strong></p>
<br />
<div class="news"><a href="https://www.iseusa.com/newsletter/host/may_host_newsletter.cfm" target="_blank">LATEST NEWSLETTER >></a></div>
</div>
	</div>
	

<!-- WEBSTORE -->
<div class="box">
<div style="background-color: #FFF; padding: 10px; margin-top: 10px; margin-bottom: 10px;">

<h1><a href="webstore/index.php" target="_blank" class="blueLink" >Web Store</a></h1>
<div class="dotLine">&nbsp;</div>
 <div class="clearfloat" style="height: 10px;">&nbsp;</div>
 <div class="asideImg" style="float:right; margin: 10px;"><a href="webstore/index.cfm" target="_blank"><img src="http://www.iseusa.com/images/ISE_webstore.png" width="200" height="150" alt="ISE swag"  class="asideBrd" /></a></div>
<p>The ISE Webstore has many great items for you to share with friends and family</p>
     


 <div class="clearfloat" style="height: 10px;">&nbsp;</div>
<div class="news"><a href="http://www.iseusa.com/webstore/" target="_blank" >START SHOPPING >></a></div>
<div class="clearfloat">&nbsp;</div></div>
	</div>
<!-- WEBSTORE -->    
    
</div><!-- .section -->
</div>