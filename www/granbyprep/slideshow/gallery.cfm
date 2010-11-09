<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<script src="../SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
<link href="../SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />
<link href="../css/granby.css" rel="stylesheet" type="text/css" />
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Granby Preparatory Academy: Athletics</title>
<link href="scripts/styles.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="scripts/xpath.js"></script>
<script type="text/javascript" src="scripts/SpryData.js"></script>
<script type="text/javascript" src="scripts/SpryEffects.js"></script>
<script type="text/javascript">
var dsAlbumBook = new Spry.Data.XMLDataSet("slideshow.xml", "/AlbumBook");
var dsAlbums = new Spry.Data.XMLDataSet("slideshow.xml", "/AlbumBook/Album");
var dsSlides = new Spry.Data.XMLDataSet("slideshow.xml", "/AlbumBook/Album[@path = '{dsAlbums::@path}']/Slide");
</script>
<script src="scripts/gallery.js"  type="text/javascript"></script>
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
-->
</style></head>
<body id="gallery">
<body class="oneColElsCtrHdr">

<div id="container">
<div href="javascript:void(0)" onclick="window.location.href='http://www.granbyprep.com'">
  <div id="headerBar">
    <div id="clickright">
  <a href="../index.cfm"><img src="../images/click.png" width="190" height="170" border="0" /></a>
  <!-- BEGIN ProvideSupport.com Graphics Chat Button Code -->
<div id="ciQmQ6" style="z-index:100;position:absolute"></div><div id="scQmQ6" style="display:inline"></div><div id="sdQmQ6" style="display:none"></div><script type="text/javascript">var seQmQ6=document.createElement("script");seQmQ6.type="text/javascript";var seQmQ6s=(location.protocol.indexOf("https")==0?"https":"http")+"://image.providesupport.com/js/granbyprep/safe-standard.js?ps_h=QmQ6&ps_t="+new Date().getTime();setTimeout("seQmQ6.src=seQmQ6s;document.getElementById('sdQmQ6').appendChild(seQmQ6)",1)</script><noscript><div style="display:inline"><a href="http://www.providesupport.com?messenger=granbyprep">Live Support Chat</a></div></noscript>
<!-- END ProvideSupport.com Graphics Chat Button Code -->
  <!-- end clickright --></div>
  <!-- end header --></div></div>
  <div id="menu">
<cfinclude template ="../menu.cfm">
  </div>
<div id="mainContent">
   <noscript>
<h1>This page requires JavaScript. Please enable JavaScript in your browser and reload this page.</h1>
</noscript>
<div id="wrap">

  <div spry:region="dsAlbumBook dsAlbums" spry:choose="">
    <div spry:when="{dsAlbums::ds_RowCount} &gt; 1">
      
    </div>
    <div spry:default="">
     
    </div>
  </div>
  <div id="previews">
    <div id="galleries" spry:detailregion="dsAlbums" spry:if="{ds_RowCount} &gt; 1">
	  <div>
      <p class="descTitle">Viewing Album:</p>
      <select name="select" id="gallerySelect" onchange="dsAlbums.setCurrentRowNumber(this.selectedIndex);" spry:repeatchildren="dsAlbums">
        <option spry:if="{ds_RowNumber} == {ds_CurrentRowNumber}" selected="selected">{@title}</option>
        <option spry:if="{ds_RowNumber} != {ds_CurrentRowNumber}">{@title}</option>
      </select>
      <p class="descTitle" spry:if="'{@description}' != ''">Description:</p>
      <p class="albumBookDesc" spry:if="'{@description}' != ''">{@description}</p>
	  </div>

    </div>
    <div id="controls">
      <ul id="transport">
        <li><a href="#" onclick="StopSlideShow(); AdvanceToNextImage(true); return false;" title="Previous">Previous</a></li>
        <li class="pausebtn"><a href="#" onclick="if (gSlideShowOn) StopSlideShow(); else StartSlideShow(); return false;" title="Play/Pause" id="playLabel">Play</a></li>
        <li><a href="#" onclick="StopSlideShow(); AdvanceToNextImage(); return false;" title="Next">Next</a></li>
      </ul>
    </div>
    <div id="thumbnails" spry:region="dsSlides dsAlbums">
      <div spry:repeat="dsSlides" onclick="HandleThumbnailClick('{ds_RowID}');" onmouseover="GrowThumbnail(this.getElementsByTagName('img')[0], '{@thumbWidth}', '{@thumbHeight}');" onmouseout="ShrinkThumbnail(this.getElementsByTagName('img')[0]);"> <img id="tn{ds_RowID}" alt="thumbnail for {@src}" src="{dsAlbums::@path}/{@src}" width="24" height="24" style="left: 0px; right: 0px;" /> </div>
      <p class="ClearAll"></p>
    </div>
  </div>
  <div id="picture">
    <div id="mainImageOutline" style="width: 0px; height: 0px;"><img id="mainImage" alt="main image" />
    </div>
	<div align="center" id="caption" spry:detailregion="dsSlides">{@caption}</div>
  </div>
  <p class="clear"></p>
</div>
  <!-- end mainContent --></div>
  <div class="clearfix"></div>
<div id="footer">
    <p>Granby Preparatory Academy &nbsp; |&nbsp;  (800) 766-4656 or (631) 893-4540 &nbsp; |  &nbsp;66 School Street, Granby , MA 01033<br />
    For more information contact us at info@granbyprep.com</p>
  <!-- end footer --></div>
<!-- end container --></div>
<script type="text/javascript">
<!--
var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"SpryAssets/SpryMenuBarDownHover.gif", imgRight:"SpryAssets/SpryMenuBarRightHover.gif"});
//-->
</script>
</body>
</html>
