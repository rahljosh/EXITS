<cftry>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [16] - Liability Release</title>
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
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfoutput>

<cfif not IsDefined('url.curdoc')>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [16] - Liability Release</h2></td>
		<cfif IsDefined('url.curdoc')>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page16printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
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
	<tr><td>&nbsp;</td></tr>
	<tr><td><div align="justify">
		<p>We hereby release the exchange organization and all of its employees, field representatives and host families from 
		all liability, damages or claims which I may have incurred after the termination of the program.</p>
		<p>We understand that the participant will be subject to the authorities and teachers of the school
		where he/she may be assigned and that he/she will have to follow the rules given by the family with whom he/she may 
		live.  We also understand that the exchange organization reserves the right to terminate the participation 
		in the program of any participant whose conduct may be considered detrimental or incompatible with the interest and 
		security of the program.  If this decision is ever taken, the participant and his/her parents or legal guardians will be formally 
		warned and have no right to any refunds.</p>
		<p>We accept the right of the exchange organization to directly or indirectly cancel, change or substitute in emergencies or
		whenever normal circumstances change, those parts of the program whose alteration may be considered necessary.  Should there be a 
		geographic move of the student, the cost of transportation shall be mutually decided by the exchange organization and the International
		Representative.</p>
		<p>We also grant the exchange organization, the school where the participant may be assigned, and the family or families with whom 
		he/she may live, all necessary permissions to act as legal guardians and "in loco parenits" in any situation, especially in emergencies, whether 
		medical or other, including the possibility of permission for surgical operations or any other treatment.</p>
		<p>We guarantee the exchange organization that, although we may maintain in the future a friendly relationship with the school, local coordinator, and family, or families with whom we may establish contact through 
		the exchange organization or its employees, we will not make-use-of this knowledge to send in the future, directly or indirectly, students, relatives or 
		friends to said school, local coordinators, or families, unless it is through the exchange organization.</p>
		<p>The participant agrees to accept and uphold the standards of conduct set by the exchange organization, the school where he/she
		may be assigned, and the family or families with whom he/she may live, for the duration of the program.  he/she agrees to maintain friendly and respectful
		relations with his/her teachers and classmates and, especially with all the members of the family with whom he/she may be living, to accept the rules of conduct imposed by said family, to participate in the family life as much as possible, to try his/her best to adjust to the normal system of family life and
		to treat all the members of the family with respect. 
		</p>
	</div></td></tr>
</table><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
		<td width="210"><br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
		<td width="5"></td>
		<td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#path#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>		
		<td width="40"></td>
		<td width="210"><br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
		<td width="5"></td>
		<td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#path#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Signature of Parent</td>
		<td></td>
		<td>Date</td>
		<td></td>
		<td>Signature of Student</td>
		<td></td>
		<td>Date</td>	
	</tr>
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

<cfif not IsDefined('url.curdoc')>
</td></tr>
</table>
</cfif>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>