
<Cfquery name="repInfo" datasource="MySQL">
select firstname, lastname, email, phone
from smg_users
where userid = #client.userid#
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Bookmarks</title>
<style type="text/css">
<!--
body {
	margin: 0;
	padding: 0;
	color: #000;
	font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
	font-size: 95%;
	line-height: 1.4;
	background-color: #FFF;
	text-align: center;
}

/* ~~ Element/tag selectors ~~ */
ul, ol, dl { /* Due to variations between browsers, it's best practices to zero padding and margin on lists. For consistency, you can either specify the amounts you want here, or on the list items (LI, DT, DD) they contain. Remember that what you do here will cascade to the .nav list unless you write a more specific selector. */
	padding: 0;
	margin: 0;
}
h1, h2, h3, h4, h5, h6, p {
	margin-top: 5;	 /* removing the top margin gets around an issue where margins can escape from their containing div. The remaining bottom margin will hold it away from any elements that follow. */
	padding-right: 8px;
	padding-left: 8px; /* adding the padding to the sides of the elements within the divs, instead of the divs themselves, gets rid of any box model math. A nested div with side padding can also be used as an alternate method. */
	margin-bottom: 5px;
	padding-top: 0px;
	padding-bottom: 0px;
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

/* ~~ this fixed width container surrounds all other elements ~~ */
.container {
	width: 450px;
	background: #FFF; /* the auto value on the sides, coupled with the width, centers the layout */
	margin-top: 0;
	margin-right: auto;
	margin-bottom: 0;
	margin-left: auto;
	height: 650px;
}

/* ~~ This is the layout information. ~~ 

1) Padding is only placed on the top and/or bottom of the div. The elements within this div have padding on their sides. This saves you from any "box model math". Keep in mind, if you add any side padding or border to the div itself, it will be added to the width you define to create the *total* width. You may also choose to remove the padding on the element in the div and place a second div within it with no width and the padding necessary for your design.

*/
.content {

	padding: 10px 0;
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
.clearfloat { /* this class can be placed on a <br /> or empty div as the final element following the last floated div (within the #container) if the overflow:hidden on the .container is removed */
	clear:both;
	height:0;
	font-size: 1px;
	line-height: 0px;
}
#menu {
	height: 25px;
	width: 450px;
	margin-top: 0px;
	margin-right: auto;
	margin-bottom: 0px;
	margin-left: auto;
	background-color: #FFF;
}
-->
</style></head>

<body>
<cfoutput>
<div id="menu"><table width="425" border="0" cellspacing="0">
  <tr>
    <td><a href="BMsave.cfm? filetype=pdf"><img src="images/save.png" height="20" alt="save icon" border="0" /></a></td>
    </tr>
</table>
</div>
<div class="container">
  <table width="450" height="650" border="1" cellpadding="0" cellspacing="0" align="left">
    <tr>
      <td width="150"><img src="images/Bookmark_03.png" width="148" height="136" /><br /><img src="images/Bookmark_05.png" width="149" height="55" />
      <p>Enrich your life Hosting International High School Students. Participants enjoy and learn from the experience by bringing the world to your back door!</p><h3>#repInfo.firstname# #repInfo.lastname#<br />#repInfo.phone#</h3><h5>#repInfo.email#</h5>
      <img src="images/Bookmark_07.png" width="150" height="20" /><br />
      <img src="images/Bookmark_08.png" /></td>
      <td width="150"><img src="images/Bookmark_03.png" width="148" height="136" /><br /><img src="images/Bookmark_05.png" width="149" height="55" />
      <p>Enrich your life Hosting International High School Students. Participants enjoy and learn from the experience by bringing the world to your back door!</p><h3>#repInfo.firstname# #repInfo.lastname#<br />#repInfo.phone#</h3><h5>#repInfo.email#</h5>
      <img src="images/Bookmark_07.png" width="150" height="20" /><br />
      <img src="images/Bookmark_08.png" /></td>
      <td width="150"><img src="images/Bookmark_03.png" width="148" height="136" /><br /><img src="images/Bookmark_05.png" width="149" height="55" />
      <p>Enrich your life Hosting International High School Students. Participants enjoy and learn from the experience by bringing the world to your back door!</p><h3>#repInfo.firstname# #repInfo.lastname#<br />#repInfo.phone#</h3><h5>#repInfo.email#</h5>
      <img src="images/Bookmark_07.png" width="150" height="20" /><br />
      <img src="images/Bookmark_08.png" /></td>
    </tr>
  </table>
<!-- end .container --></div>
</cfoutput>
</body>
</html>
