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
	<title>Page [20] - Region Preference</title>
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

<cfoutput>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [20] - Regional Choice </h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page20printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr>
		<td width="110"><em>Student's Name</em></td>
		<td width="560"><br><img src="#path#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br><br>

<table width=670 border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td><p>You can choose your region if you so desire. Both the Semester and Academic Year students can choose a region.<br>
	  You must request a regional choice by printing and signing this page. Your application must be received in the U.S. Office prior to April 15th.</p>
	    <p>The student exchange company reserves the right in August, if a placement is not forthcoming, to place a student out of their Regional Choice area. No extra fee is then collected. </p></td>
	</tr>
</table><br>

<table width=670 border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td><div align="justify">
		If you would like to specify a region, select option A, 
		confirm your request of region, print this page, sign it and upload it back into the system with original signatures.<br>
		If you do not want a regional choice, select option B. 
		If option B is selected you do not need to print this page, sign it and upload it back into the system.</div>
	    <br><br></td></tr>	
	<tr>
		<td>A. <img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> &nbsp; I would like to request a specific regional choice.<br></td>
	</tr>	
	<tr>
		<td>B. <img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> &nbsp; I do not wish a regional choice.<br>
		  <br></td>
	</tr>	
	<tr>
	  <td>			
			<b>Note: There will be additional charges if you make a regional choice, please contact your representative for details.</b><br>
			<br>
			
			
			 <table width=670 border=0 cellpadding=0 cellspacing=0 align="center">
                        <tr><td colspan="3"><h2>Select your regions below, then click Next:</h2><br><br></td></tr>
                        <tr>
							<td width="10%"></td>
                            <td valign="top"><input type="radio" name="region_choice" value="6">West<br><img src="https://ise.exitsapplication.com/nsmg/student_app/pics/west.jpg" width="45%"></td>
                            <td valign="top"><input type="radio" name="region_choice" value="7"  >Central<br><img src="https://ise.exitsapplication.com/nsmg/student_app/pics/central.jpg" width="45%"></td>
                        </tr>
                        <tr>
							<td width="10%"></td>
                            <td valign="top"><input type="radio" name="region_choice" value="8" >South<br><img src="https://ise.exitsapplication.com/nsmg/student_app/pics/south.jpg" width="45%"></td>
                            <td valign="top"><input type="radio" name="region_choice" value="9"  >East<br><img src="https://ise.exitsapplication.com/nsmg/student_app/pics/east.jpg" width="45%"></td>
                           
                        </tr>
                    </table>			
		</td>
	</tr>
</table><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
		<td width="315"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td width="40"></td>
		<td width="315"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Student's Name (print clearly)</td>
		<td></td>
		<td>Student's Signature</td>
	</tr>
</table><br><br>
<table width="660" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
		<td width="315"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td width="40"></td>
		<td width="315"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Parent's Name (print clearly)</td>
		<td></td>
		<td>Parent's Signature</td>
	</tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

</cfoutput>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
