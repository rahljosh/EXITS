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
	<title>Page [21] - State Preference</title>
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
		<td class="tablecenter"><h2>Page [21] - <cfif CLIENT.companyID NEQ 14>State<cfelse>District</cfif> Choice </h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page21printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
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

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr>
		<td>
			<div align="justify"><cfinclude template="state_guarantee_text.cfm"></div>
            
			<cfif CLIENT.companyID NEQ 14>
                <!--- Regular State Guarantee Choice --->
            
                <table>
                    <tr><td>State Choice Price:</td>
                    <td>Please contact your rep for current prices for state guarantees.</td></tr>
                </table><br>
                <img src="#path#pics/usa-map.gif"><br><br>
                <img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes, submit my choices as indicated below. 
                <img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No, I am not interested in a state choice.
                <br><br>
                <table width="100%" border=0 cellpadding=2 cellspacing=0 align="center">
                    <tr>
                        <td width="90">1st Choice:</td>
                        <td width="130" align="left"><br><img src="#path#pics/line.gif" width="125" height="1" border="0" align="absmiddle"></td>
                        <td width="90">&nbsp; 2nd Choice:</td>
                        <td width="130" align="left"><br><img src="#path#pics/line.gif" width="125" height="1" border="0" align="absmiddle"></td>
                        <td width="90">&nbsp; 3rd Choice:</td>
                        <td width="130" align="left"><br><img src="#path#pics/line.gif" width="125" height="1" border="0" align="absmiddle"></td>
                	</tr>
                </table>
		  <cfelse>
              <!--- Exchange Service Information --->
          
              <img src="#path#pics/ESI-Map.png" width="650" height="380" align="middle"><br>

              <table cellpadding="2" cellspacing="2" style="margin:10px;">
                  <tr>
                      <td width="90">1st Choice:</td>
                      <td width="450" align="left"><br><img src="#path#pics/line.gif" width="445" height="1" border="0" align="absmiddle"></td>
                  </tr>
                  <tr>                        
                      <td width="90">2nd Choice:</td>
                      <td width="450" align="left"><br><img src="#path#pics/line.gif" width="445" height="1" border="0" align="absmiddle"></td>
                  </tr>
                  <tr>                        
                      <td width="90">3rd Choice:</td>
                      <td width="450" align="left"><br><img src="#path#pics/line.gif" width="445" height="1" border="0" align="absmiddle"></td>
                  </tr>                        							
              </table>

          </cfif>
                
		</td>
	</tr>
</table><br><br>

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