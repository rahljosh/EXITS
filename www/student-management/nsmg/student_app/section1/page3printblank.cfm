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
	<title>Page [03] - Personal Data</title>
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

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_interests" datasource="#APPLICATION.DSN#">
	SELECT interestid, interest
	FROM smg_interests
	WHERE student_app = 'yes'
	ORDER BY interest
</cfquery>

<cfoutput>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0> 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [03] - Personal Data</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page3printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
	<tr><td colspan="8"><em>Check any activity in which you participate in your home country (check at least 3 and no more than 6).</em></td></tr>
	<tr><cfloop query="get_interests">	
		<td><img src="#path#pics/checkN.gif" width="13" height="13" border="0"></td>
		<td>#interest#</td>
			<cfif (get_interests.currentrow MOD 4 ) is 0></tr><tr></cfif>
		</cfloop>
	<tr><td colspan="8"><em>Other:</em></td></tr>
	<tr><td colspan="8"><br><img src="#path#pics/line.gif" width="665" height="1" border="0" align="absmiddle"></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="660" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
    	<td width="48%"><em>Please choose your primary language:</em></td>
        <td width="4%">&nbsp;</td>
        <td width="48%"><em>Do you speak any secondary languages?</em></td>
  	</tr>
    <tr>
    	<td style="vertical-align:top;">
        	<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
      	</td>
        <td></td>
        <td>
        	<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"><br />
            <br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"><br />
            <br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
      	</td>
    </tr>
</table>
<br />

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">	
	<tr><td><em>Please list any other specific interests, hobbies and activities and any awards or commendations:</em></td></tr>
</table>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
<tr>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td><em>Do you Play in a band?</em></td></tr>
			<tr>
				<td>
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Do you play in an orchestra?</em></td></tr>					
			<tr>
				<td>
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what instrument(s)?</em></td></tr>
			<tr><td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Do you participate in any competitive sports?</em></td></tr>					
			<tr>
				<td>
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what sport(s)?</em></td></tr>
			<tr><td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>How often do you attend church?</em></td></tr>					
			<tr>
				<td>
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Are you active in any church groups?</em></td></tr>					
			<tr><td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Would you be willing to attend church with your host family?</em></td></tr>					
			<tr>
				<td>
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</td>
	<td width="4%">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td><em>Do you smoke?</em></td></tr>					
			<tr>
				<td> 
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<!--- Do not display for Canada Application --->
            <cfif NOT ListFind("14,15,16", get_student_info.app_indicated_program)>            	
                <tr>
                    <td><font size="-2" color="##FF0000">For your information: </font><font size="-2"><i>The purchase and/or smoking of cigarettes for persons under age 18 is illegal in most parts of the USA.  
                        Individual host families may have additional rules which must be followed by the student.</i></font>
                    </td>
                </tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Are you allergic to animals?</em></td></tr>					
			<tr>
				<td>
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what animals?</em></td></tr>					
			<tr><td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If you are allergic, is your allergy controlled by medications?</em></td></tr>					
			<tr>
				<td>
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Are you allergic to medications?</em></td></tr>					
			<tr>
				<td>
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
					<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
					<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what medication?</em></td></tr>					
			<tr><td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>			
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>How many years have you studied English?</em></td></tr>					
			<tr><td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</td>
</tr>
</table>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
	<tr><td><em>List the chores for which you are responsible at home.</em></td></tr>					
	<tr><td><div align="justify"><br><img src="#path#pics/line.gif" width="665" height="1" border="0" align="absmiddle"></div></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>Briefly give reasons for wanting to become an exchange student.</em></td></tr>
	<tr><td><div align="justify"><br><br><img src="#path#pics/line.gif" width="665" height="1" border="0" align="absmiddle"></div></td></tr>
	<tr><td>&nbsp;</td></tr>
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

</cfoutput>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>