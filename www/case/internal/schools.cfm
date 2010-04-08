<cfif not isDefined("url.order")>
	<cfset url.order = "schoolname">
</cfif>

<cfquery name="schools" datasource="caseusa">
	SELECT *
	FROM smg_schools
	<cfif client.usertype EQ '9'>
		WHERE schoolid = '0'
	</cfif>
	order by #url.order#
</cfquery>

<style type="text/css">
<!--
div.scroll {
	height: 325px;
	width: 100%;
	overflow: auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
}
-->
</style>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
	<td background="pics/header_background.gif"><h2>Schools </td><td background="pics/header_background.gif" align="right"><cfoutput>[ &nbsp; #schools.recordcount# schools displayed &nbsp; ]</cfoutput></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class=section>
	<tr> 
		<td width=50 align="left"><a href="index.cfm?curdoc=schools&order=schoolid">ID</a></td>
		<td width=220 align="left"><a href="index.cfm?curdoc=schools&order=schoolname">School Name</a></td>
		<td width=180 align="left"><a href="index.cfm?curdoc=schools&order=principal">Principal</a></td>
		<td width=100 align="left"><a href="index.cfm?curdoc=schools&order=city">City</a></td>
		<td width=50 align="left"><a href="index.cfm?curdoc=schools&order=state">State</a></td>
	</tr>
</table>

<div class="scroll">
<table border=0 cellpadding=4 cellspacing=0 width=100%>
<cfoutput query="schools">
<cfif client.usertype LT 5>
<cfset urllink ="?curdoc=forms/school_app_1&schoolid=#schoolid#"> 
<cfelse>
<cfset urllink="?curdoc=forms/school_app_1&schoolid=#schoolid#"> 
</cfif>
<tr bgcolor="#iif(schools.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
		<td width=50 align="left"><a href='#urllink#'>#schoolid#</a></td>
		<td width=220 align="left"><a href='#urllink#'>#schoolname#</a></td>
		<td width=180 align="left"><a href='#urllink#'>#principal#</a></td>
		<td width=100 align="left">#city#</td>
		<td width=50 align="left">#state#</td>
	</tr>
</cfoutput>
</table>
</div>

<cfif #client.usertype# LTE '4'> <!--- OFFICE PEOPLE --->
<table border=0 cellpadding=4 cellspacing=0 width=100% class=section>
<tr><td align="center">
		<form action="index.cfm?curdoc=forms/school_app_1" method="post"><input type="submit" value="   Add School   "></form>
</td></tr>
</table>
</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table><br>

