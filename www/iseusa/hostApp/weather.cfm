<cfquery name="local" datasource="MySQL">
	select city,state,zip
	from smg_hosts
	where hostid = #client.hostid#
</cfquery>
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
<cfoutput>
<cfhttp method="get" url="http://en.wikipedia.org/wiki/#local.city#,_#local.state#" />
<cfset infoResults = reMatchNoCase("(<p[>])(.*?)(</p>)", cfhttp.fileContent)>
<!----Weather Info---->
<cfset weatherTable = reMatchNoCase("(Climate Data)(.*?)(</table>)", cfhttp.fileContent)>

<cfset weather = #weatherTable[1]#>
<cfset weather = stripHTMLParagraph(weather)>
<cfset weather = addLink(weather)>


<table class="wikitable collapsible" style="width:90%; text-align:center; font-size:90%; line-height: 1.1em; margin:auto;">
<tr>
<th colspan="14">
#weather#
</cfoutput>