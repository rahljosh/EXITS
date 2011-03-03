<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<script src="http://code.jquery.com/jquery-latest.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
function ShowHide(){
$("#slidingDiv").animate({"height": "toggle"}, { duration: 1000 });
}
//]]>
</script>
<style type="text/css">
<!--
#footer3 {
	clear: both;
	height: 40%;
	margin: 0;
	background-color: #000;
	padding-top: 0;
	padding-right: 0;
	padding-bottom: 0;
	padding-left: 0;
	bottom: -8px;
	display: block;
}
.tripsTours {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	width: 675px;
	margin-left: 35px;
	margin-top: 10px;
	padding: 0px;
	text-align: left;
}
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	color: #000;
	text-decoration: none;
}
a:hover {
	color: #0B954E;
	text-decoration: none;
}
a {
	font-weight: bold;
}
a:active {
	text-decoration: none;
}
.Boxx {
	border: 2px dashed #000066;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	color: #000066;
}
.Titles {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 14px;
}
.TitlesLG {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 20px;
}
.SubTitle {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 12px;
}
.SubTitleLG {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 16px;
}
.BottonText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
	font-style: normal;
	line-height: normal;
	font-weight: lighter;
	font-variant: normal;
	color: #6B8098;
	background-image: url(file:///JW%20BACKUP/SMG/ISE/site/trips/images/botton.gif);
	background-repeat: no-repeat;
	background-position: center center;
	text-align: center;
	vertical-align: middle;
}
.RegularText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	color:#000000;
	font-style: normal;
	font-weight: normal;
}
.style1 {color: #FFFFFF}
.style2 {font-size: 12px}
.style4 {font-size: 12}
.style5 {color: #FFFFFF; font-weight: bold; }
.style6 {
	color: #FFFFFF;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	}
.image-right {
border:solid 1px;
margin-right: 0px;
margin-left: 15px;
}
.image-left {
border:solid 1px;
margin-right: 15px;
margin-left: 0px;
}
.whtMiddletours2{
	background-image: url(../images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
}
.bBackground {
	background-color: #C5DCEA;
	border: thin solid #000;
	text-align: center;
}
<!----New CSS---->
#footer3 {
	clear: both;
	height: 40%;
	margin: 0;
	background-color: #000;
	padding-top: 0;
	padding-right: 0;
	padding-bottom: 0;
	padding-left: 0;
	bottom: -8px;
	display: block;
}
.tripsTours {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	width: 675px;
	margin-left: 35px;
	margin-top: 10px;
	padding: 0px;
	text-align: left;
}
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	color: #000;
	text-decoration: none;
}
a:hover {
	color: #0B954E;
	text-decoration: none;
}
a {
	font-weight: bold;
}
a:active {
	text-decoration: none;
}
.Boxx {
	border: 2px dashed #000066;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	color: #000066;
}
.Titles {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 14px;
}
.TitlesLG {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 20px;
}
.SubTitle {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 12px;
}
.SubTitleLG {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 16px;
}
.BottonText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
	font-style: normal;
	line-height: normal;
	font-weight: lighter;
	font-variant: normal;
	color: #6B8098;
	background-image: url(file:///JW%20BACKUP/SMG/ISE/site/trips/images/botton.gif);
	background-repeat: no-repeat;
	background-position: center center;
	text-align: center;
	vertical-align: middle;
}
.RegularText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	color:#000000;
	font-style: normal;
	font-weight: normal;
}
.style1 {color: #FFFFFF}
.style2 {font-size: 12px}
.style4 {font-size: 12}
.style5 {color: #FFFFFF; font-weight: bold; }
.style6 {
	color: #FFFFFF;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	}
.image-right {
border:solid 1px;
margin-right: 0px;
margin-left: 15px;
}
.image-left {
border:solid 1px;
margin-right: 15px;
margin-left: 0px;
}
.whtMiddletours2{
	background-image: url(../images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
}
.bBackground {
	background-color: #C5DCEA;
	border: thin solid #000;
	text-align: center;
}
.border{border:solid 1px;}
<!----- ----->
H1 { text-transform: capitalize }
.p_uppercase { 
text-transform: capitalize;
padding-top: 2px;
margin: 0px;
}
.redtext {
	color: #FF0000;
}
#slidingDiv {
    display: none;

}
-->
</style>
</head>

<body>

<select name="field_data_loc[key]" class="form-select required" id="edit-field-data-loc-key" onChange="ShowHide();" >
<option value="didnotchoose" selected="selected">Choose</option>
<option value="web" >Website/URL</option>
<option value="file">File to upload</option>
</select>

<div id="slidingDiv" display:"none">
url
</div>

<div id= "file" style="display: none;">
file
</div>
<div id= "web" style="display: none;">
web
</div>

</body>
</html>




