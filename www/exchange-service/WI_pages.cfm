<cfparam name="url.page" default="WI">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Exchange Service International: Bringing the F-1 program to public schools</title>
<link href="css/ESI.css" rel="stylesheet" type="text/css" />
<link rel="shortcut icon" href="Districts/favicon.ico" />
<script language="JavaScript1.1">
<!--

/*
JavaScript Image slideshow:
By JavaScript Kit (www.javascriptkit.com)
Over 200+ free JavaScript here!
*/

var slideimages=new Array()
var slidelinks=new Array()
function slideshowimages(){
for (i=0;i<slideshowimages.arguments.length;i++){
slideimages[i]=new Image()
slideimages[i].src=slideshowimages.arguments[i]
}
}

function slideshowlinks(){
for (i=0;i<slideshowlinks.arguments.length;i++)
slidelinks[i]=slideshowlinks.arguments[i]
}

function gotoshow(){
if (!window.winslide||winslide.closed)
winslide=window.open(slidelinks[whichlink])
else
winslide.location=slidelinks[whichlink]
winslide.focus()
}

//-->
</script>
</head>

<body>
<div class="container">
<!--- HEADER  --->
<cfinclude template="includes/header.cfm">

<!---LOGO AND SLIDESHOW SECTION--->
  <div class="INdisplay">
  	<div class="INleft"><table width="250" border="0" cellspacing="0" cellpadding="5" align="center">
  <tr>
    <td><a href="Districts/index.cfm"><img src="images/logo_ESI.jpg" width="250" height="88" alt="Exchange Student International logo" /></a></td>
  </tr>
  <tr>
    <td height="99">Exchange Service International &#8211; Wisconsin Districts</td>
  </tr>
</table>
<!-- end display left --></div>
    <div class="INright">
    <a href="javascript:gotoshow()"><img src="images/IL/SLIDESHOW/pic1.jpg" name="slide" width="665" height="262" border="0"/></a>
    
  
<script>
<!--
//configure the paths of the images, plus corresponding target links
slideshowimages("images/WI/SLIDESHOW/pic1.jpg","images/WI/SLIDESHOW/pic2.jpg")
slideshowlinks("WI_pages.cfm","WI_pages.cfm")

//configure the speed of the slideshow, in miliseconds
var slideshowspeed=5000

var whichlink=0
var whichimage=0
function slideit(){
if (!document.images)
return
document.images.slide.src=slideimages[whichimage].src
whichlink=whichimage
if (whichimage<slideimages.length-1)
whichimage++
else
whichimage=0
setTimeout("slideit()",slideshowspeed)
}
slideit()

//-->
</script></div>
<!-- end display --></div>

<!---DROP DOWN MENU--->
<div class="menu">
<cfinclude template="menu/ESI_Menu.cfm">
</div>

<!---LEFT SIDE BAR--->
<cfinclude template="includes/sidebar1.cfm">

<!---MAIN CONTENT--->
  <div class="content">
  <cfinclude template= "WI/#url.page#.cfm">
    <!-- end .content --></div>
    
  <!---RIGHT SIDEBAR--->  
<cfinclude template="includes/sidebar2.cfm">

<!---FOOTER --->
  <div class="footer">
 
    <!-- end .footer --></div>
  <!-- end .container --></div>
</body>
</html>
