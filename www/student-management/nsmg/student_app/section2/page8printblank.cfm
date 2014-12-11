<cftry>

<cfif LEN(URL.curdoc) OR IsDefined('url.path')>
	<cfset path = "">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [08] - Transcript of Grades</title>
	<style type="text/css">
	<!--
	body {
		margin-left: 0.3in;
		margin-top: 0.3in;
		margin-right: 0.3in;
		margin-bottom: 0.3in;
	}
	-->
	</style>		
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [08] - Transcript of Grades</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section2/page8printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">
	<tr><td align="center"><b>TRANSCRIPT OF GRADES continued</b></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center">
		<div align="justify">
			In English type names, hours per week, and the final <b>(American-equivalent)</b> grade for the classes you attended
			in the 9<sup>th</sup>, 10<sup>th</sup>, 11<sup>th</sup> and 12<sup>th</sup> grades. Indicate the grade in which you 
			are presently enrolled. In addition to this translation, please also attach a copy of each year’s transcript of grades 
			issued by your school.
		</div>
	</td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">
<tr>
	<td width="48%" valign="top">
	<!--- 9th grade --->
		<table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
			<tr><td colspan="3"><em>&nbsp; School Year &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; to &nbsp;</em></td></tr>
		<tr>
			<td align="center"><em>9<sup>th</sup> year classes</em></td><td align="center"><em>Hours <br>per week</em></td><td align="center"><em>Final Grade<br> (Am. Equivalent)</em></td>
		</tr>
		<!--- NEW CLASSES UP TO 14 --->
			<cfloop from="1" to="14" index="i">
			<tr>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
			</tr>
			</cfloop>		
		</table>	
	</td>
	
	<td width="4%">&nbsp;</td>

	<td width="48%" valign="top" align="left">
	<!--- 10th grade --->
		<table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
			<tr><td colspan="3"><em>&nbsp; School Year &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; to &nbsp;</em></td></tr>
		<tr>
			<td align="center"><em>10<sup>th</sup> year classes</em></td><td align="center"><em>Hours <br>per week</em></td><td align="center"><em>Final Grade<br> (Am. Equivalent)</em></td>
		</tr>
		<!--- NEW CLASSES UP TO 14 --->
			<cfloop from="1" to="14" index="i">
			<tr>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
			</tr>
			</cfloop>		
		</table>	
	</td>
</tr>
</table><br>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">
<tr>
	<td width="48%" valign="top">
	<!--- 11th grade --->
		<table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
			<tr><td colspan="3"><em>&nbsp; School Year &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; to &nbsp;</em></td></tr>
		<tr>
			<td align="center"><em>11<sup>th</sup> year classes</em></td><td align="center"><em>Hours <br>per week</em></td><td align="center"><em>Final Grade<br> (Am. Equivalent)</em></td>
		</tr>
		<!--- NEW CLASSES UP TO 14 --->
			<cfloop from="1" to="14" index="i">
			<tr>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
			</tr>
			</cfloop>		
		</table>	
	</td>
	
	<td width="4%">&nbsp;</td>
	
	<td width="48%" valign="top" align="left">
	<!--- 12th grade --->
		<table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
			<tr><td colspan="3"><em>&nbsp; School Year &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; to &nbsp;</em></td></tr>
		<tr>
			<td align="center"><em>12<sup>th</sup> year classes</em></td><td align="center"><em>Hours <br>per week</em></td><td align="center"><em>Final Grade<br> (Am. Equivalent)</em></td>
		</tr>
		<!--- NEW CLASSES UP TO 14 --->
			<cfloop from="1" to="14" index="i">
			<tr>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
			</tr>
			</cfloop>		
		</table>	
	</td>
</tr>
</table><br><br>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">
	<tr><td align="center">Please attach a copy of each year's transcript of grades.</td></tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center">
			Students must bring an official transcript with them for scheduling purposes in the American School. <br>
			All documents must be translated into English.
	</td></tr>
	<tr><td>&nbsp;</td></tr>
</table><br><br>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</body>
</html>

</cftry>