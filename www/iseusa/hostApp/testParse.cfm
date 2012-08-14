<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>

<style type="text/css">
#GreyBorder {
    border: thin solid #CCC;
    height: 100%;
    width: 500px;
}
#city {
    font-family: Arial, Helvetica, sans-serif;
    color: #000;
    background-color: #FFF;
    padding: 7px;
    float: left;
    position: relative;
    z-index: 25;
    margin-left: 10px;
    margin-top: -15px;
}
#feeback {
	font-family: Arial, Helvetica, sans-serif;
	color: #666;
	background-color: #FFF;
	padding: 7px;
	float: right;
	position: relative;
	z-index: 25;
	font-style: italic;
	margin-right: 10px;
	font-size: 12px;
	bottom: 15px;
}
.clearfix {
    display: block;
    clear: both;
    height: 5px;
}
p {
    padding-top: 0px;
    padding-right: 15px;
    padding-bottom: 0px;
    padding-left: 15px;
    font-family: Arial, Helvetica, sans-serif;
    color: #000;
}
</style>
</head>


<body>
<!----Remove ALL html---->
<cfscript>
function stripHTML(str) {
   return REReplaceNoCase(str,"<[^>]*>","","ALL");
}
</cfscript>
<!----Remove Table Tags---->
<cfscript>
function stripHTMLTable(str) {
   return REReplaceNoCase(str,"</?p.*?>]*>","","ALL");
}
</cfscript>
<!----remove Paragraph Tags---->
<cfscript>
function stripHTMLParagraph(str) {
   return REReplaceNoCase(str,"</?p.*?>","","ALL");

}
</cfscript>
<!----Add back in WIKI links---->
<cfscript>
function addLink(str) {
   return REReplaceNoCase(str,"/wiki/","http://en.wikipedia.org/wiki/","ALL");

}
</cfscript>
<!----Add color box link---->
<cfscript>
function addColorBox(str) {
   return REReplaceNoCase(str,"/wiki/","http://en.wikipedia.org/wiki/","ALL");

}
</cfscript>



<cfhttp method="get" url="http://en.wikipedia.org/wiki/Pocatello,_ID" />
<cfoutput>
<cfset infoResults = reMatchNoCase("(<p[>])(.*?)(</p>)", cfhttp.fileContent)>

<cfset blurb = #infoResults[1]#>
<cfset blurb = stripHTMLParagraph(blurb)>
<cfset blurb = addLink(blurb)>

<cfset popResults = reMatchNoCase("(<b>Population</b>)(.*?)(</table>)", cfhttp.fileContent)>

<!----Population Info---->
<cfloop array="#popResults#" index="data">
<cfset cityPop = reMatchNoCase("(City</th>)(.*?)(</td>)", data)> 
<cfset metroPop = reMatchNoCase("(Metro</a></b></td>)(.*?)(</td>)", data)>  
<cfset cityPopulation = #cityPop[1]#>
<cfset cityPopulation = stripHTML(cityPopulation)> 
<cfset metroPopulation = #metroPop[1]#>
<cfset metroPopulation = stripHTML(metroPopulation)> 
</cfloop>

<!----Weather Info---->


<cfset weatherTable = reMatchNoCase("(Climate Data)(.*?)(</table>)", cfhttp.fileContent)>

<cfset weather = #weatherTable[1]#>
<cfset weather = stripHTMLParagraph(weather)>
<cfset weather = addLink(weather)>


<!----Climate Info---->
<cfset climateInfo = reMatchNoCase("(Climate</span></h3>)(.*?)(</p>)", cfhttp.fileContent)>

<cfset localClimate = #climateInfo[1]#>
<cfset localClimate = stripHTMLParagraph(localClimate)>
<cfset localClimate = addLink(localClimate)>
</cfoutput>


<cfoutput>
<div id="GreyBorder">
  <div id="city">Pocatello, ID</div>
  <div class="clearfix">&nbsp;</div>
<p>
    #blurb#
    <br />
    #cityPopulation#<br />
    #metroPopulation#<br />
#localClimate#

</p>
 <div class="clearfix">&nbsp;</div>
<div id="feeback">info from wikipedia</div>
<!--- end GreyBorder ---></div>

<table class="wikitable collapsible" style="width:90%; text-align:center; font-size:90%; line-height: 1.1em; margin:auto;">
<tr>
<th colspan="14">
#weather#
 
</cfoutput>



</body>
</html>

</body>
</html>