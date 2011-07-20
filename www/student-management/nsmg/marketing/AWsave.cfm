
<Cfquery name="repInfo" datasource="MySQL">
select firstname, lastname, email, phone
from smg_users
where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
</cfquery>

<cfdocument format="PDF" margintop=".45" marginbottom=".25" marginright=".25" marginleft=".25" backgroundvisible="yes" overwrite="no" fontembed="yes" bookmark="false" localurl="no" saveasname="SchoolAroundtheWorld.pdf" >

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
<style type="text/css">
<!--
body {
	background: #FFF;
	color: #000;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 40px;

}
p {
	text-align: justify;
	padding-top: 30px;
	padding-bottom: 8px;
	font-family: "Comic Sans MS", cursive;
	font-size: 40px;
	padding-left: 50px;
	padding-right: 50px;
}

/* ~~ Element/tag selectors ~~ */
ul, ol, dl { /* Due to variations between browsers, it's best practices to zero padding and margin on lists. For consistency, you can either specify the amounts you want here, or on the list items (LI, DT, DD) they contain. Remember that what you do here will cascade to the .nav list unless you write a more specific selector. */
	padding: 0;
	margin: 0;
}
h1, h2, h3, h4, h5, h6 {
	margin-top: 0;	 /* removing the top margin gets around an issue where margins can escape from their containing div. The remaining bottom margin will hold it away from any elements that follow. */
	padding-right: 15px;
	padding-left: 15px; /* adding the padding to the sides of the elements within the divs, instead of the divs themselves, gets rid of any box model math. A nested div with side padding can also be used as an alternate method. */
}
a img { /* this selector removes the default blue border displayed in some browsers around an image when it is surrounded by a link */
	border: none;
}
/* ~~ Styling for your site's links must remain in this order - including the group of selectors that create the hover effect. ~~ */
a:link {
	color: #42413C;
	text-decoration: underline; /* unless you style your links to look extremely unique, it's best to provide underlines for quick visual identification */
}
a:visited {
	color: #6E6C64;
	text-decoration: underline;
}
a:hover, a:active, a:focus { /* this group of selectors will give a keyboard navigator the same hover experience as the person using a mouse. */
	text-decoration: none;
}

/* ~~ this fixed width container surrounds the other divs ~~ */
.container {
	width: 2550px;
	background: #FFF;
	margin: 0 auto; /* the auto value on the sides, coupled with the width, centers the layout */
}

/* ~~ the header is not given a width. It will extend the full width of your layout. It contains an image placeholder that should be replaced with your own linked logo ~~ */
.header {
	background: #FFF;
}

/* ~~ This is the layout information. ~~ 

1) Padding is only placed on the top and/or bottom of the div. The elements within this div have padding on their sides. This saves you from any "box model math". Keep in mind, if you add any side padding or border to the div itself, it will be added to the width you define to create the *total* width. You may also choose to remove the padding on the element in the div and place a second div within it with no width and the padding necessary for your design.

*/

.content {
	padding-top: 0px;
	padding-right: 0;
	padding-bottom: 0px;
	padding-left: 0;
	background-color: #efefef;
	width: 2550px;
}

/* ~~ The footer ~~ */
.footer {
	padding: 0px;
	background-color: #1055A2;
}

/* ~~ miscellaneous float/clear classes ~~ */
.fltrt {  /* this class can be used to float an element right in your page. The floated element must precede the element it should be next to on the page. */
	float: right;
	margin-left: 8px;
}
.fltlft { /* this class can be used to float an element left in your page. The floated element must precede the element it should be next to on the page. */
	float: left;
	margin-right: 8px;
}
.clearfloat { /* this class can be placed on a <br /> or empty div as the final element following the last floated div (within the #container) if the #footer is removed or taken out of the #container */
	clear:both;
	height:0;
	font-size: 1px;
	line-height: 0px;
}
.clearfix {
	display: block;
	clear: both;
	height: 100px;
	width: 2450px;
	text-align: center;
	padding-top: 35px;
	padding-bottom: 35px;
	font-family: "Comic Sans MS", cursive;
	font-size: 47px;
	font-weight: bold;
}
.pic {
	float: left;
	margin-right: 40px;
	margin-left: 45px;
}
.picR {
	float: right;
	margin-right: 45px;
	margin-left: 40px;
}

-->
</style></head>

<body>
<Cfoutput>
<div class="container">
  <div class="header"><img src="images/print/#client.companyid#_Wprint_03.jpg" width="2542" height="757" alt="school around the world ISE banner" /><!-- end .header --></div>
  <div class="content">
   <table width="2500" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="2500" ><img src="images/print/Wprint_05.jpg" width="2542" height="124" alt="school day in Brazil" /></td>
  </tr>
  <tr>
    <td><div class="pic"><img src="images/print/Wprint_07.jpg" width="704" height="437" /></div>
    <p>The school day in Brazil runs from 7 a.m. to noon, and students typically go home at noon to share lunch with their family. Lunch is the most important meal of the day. Most schools require students to wear a uniform. Math, geography, history, science, Portuguese (the national language of Brazil), and physical education are the main subjects studied by students in Brazil. Many schools can barely afford to teach those subjects, which means that courses like art and music are often left out in poorer areas. The average class size is 30 or more students. Most schools do not have a computer in the classrooms, or have only one or two computers for 30 students to share.</p></td>
  </tr>
  <tr>
    <td><img src="images/print/Wprint_11.jpg" width="2542" height="121" alt="school day in China" /></td>
  </tr>
  <tr>
    <td><div class="picR"><img src="images/print/Wprint_13.jpg" width="716" height="370" /></div>
    <p>Because China is in the northern hemisphere, its summer months are in line with Asia, Europe, and North America. The school year in China typically runs from the beginning of September to mid-July. Summer vacation is generally spent in summer classes or studying for entrance exams. The average school day runs from 7:30 a.m. to 5 p.m., with a two-hour lunch break. Formal education in China lasts for nine years. China provides all students with uniforms, but does not require they be worn.</p></td>
  </tr>
  <tr>
    <td><img src="images/print/Wprint_17.jpg" width="2542" height="116" alt="school day in south korea" /></td>
  </tr>
  <tr>
    <td><div class="pic"><img src="images/print/Wprint_19.jpg" width="645" height="362" /></div>
    <p>The school year in South Korea typically runs from March to February. The year is divided into two semesters (March to July and September to February). School days are from 8 a.m. to 4 p.m., but many stay later into the evening. In addition, students help clean up their classroom before leaving. Most students remain in the same room while their teachers rotate throughout the day. Each room has about thirty students with ten computers for them to share.</p></td>
  </tr>
  <tr>
    <td><img src="images/print/Wprint_23.jpg" width="2542" height="121" alt="school day in france" /></td>
  </tr>
  <tr>
    <td><div class="picR"><img src="images/print/Wprint_25.jpg" width="737" height="458" /></div>
    <p>The school day in France typically runs from 8 a.m. to 4 p.m., with a half day on Saturday, although students do not attend school on Wednesday or Sunday. Lunch is a two-hour break for public school students. Students usually attend school from ages 6 to 18. The average number of students per class is 23. Uniforms are not required, but religious dress of any kind is banned. The school year for this country in the northern hemisphere stretches from August to June, and is divided into four seven-week terms, with one to two weeks of vacation in between.</p></td>
  </tr>
  <tr>
    <td align="center"><div class="clearfix">
    #repInfo.firstname# #repInfo.lastname# &nbsp; | &nbsp; P: #repInfo.phone# &nbsp;| &nbsp;#repInfo.email#
</div>
</td>
  </tr>
</table>
    <!-- end .content --></div>
  <div class="footer">
    <img src="images/print/#client.companyid#_Wprint_30.jpg" width="2542" height="130" />    <!-- end .footer --></div>
  <!-- end .container --></div>
  </cfoutput>
</body>
</html>
</cfdocument>