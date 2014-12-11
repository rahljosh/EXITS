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
	<title>Page [11] - Health Questionnaire</title>
	<style type="text/css">
		body {
			margin-left: 0.3in;
			margin-top: 0.3in;
			margin-right: 0.3in;
			margin-bottom: 0.3in;
		}
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
		<td class="tablecenter"><h2>Page [11] - Health Questionnaire</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page11printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
		
<!--- MEDICAL HISTORY --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="4"><b>MEDICAL HISTORY</b> - <em>Have you had?</em></td></tr>
	<tr>
		<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td width="245"><em>Diabetes</em></td>	
        <td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Strokes / Cerbral Hemorrhage</em></td>
	</tr>
	<tr>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Cancer</em></td>	
        <td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Concussion or Head Injuries</em></td>
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Chickenpox</em></td>	
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Broken Bones</em></td>		
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Epilepsy</em></td>	
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Sexually Transmitted Disease</em></td>
	</tr>
	
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td colspan="3"><em>Have you ever been hospitalized, had surgery or been treated for a chronic medical illness?</em></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="3"><em>Please Explain:</em> &nbsp; <br><img src="#path#pics/line.gif" width="500" height="1" border="0" align="absmiddle"></td>
	</tr>
   

</table>
<!--- SYSTEMIC REVIEW --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="4"><b>SYSTEMIC REVIEW</b> - <em>Do you have the following?</em></td></tr>
	<tr><td colspan="2" align="left"><b>Eyes-Ears-Nose-Throat:</b></td>
		
	</tr>
	<tr><td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td width="245"><em>Eye disease or injury</em></td>
        <td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Do you wear glasses?</em></td>	
	</tr>
	
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Double Vision</em></td>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Chronic Headaches</em></td>	
	</tr>
	
	
	<tr>
    	<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Chronic sinus trouble</em></td>
 	    <td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Ear Disease</em></td>
	
	</tr>
	
	<tr>
<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Impaired hearing</em></td>
        <td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Dizziness</em></td>
		
	</tr>
	
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Episodes of unconsciousness</em></td>
	 <td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Nosebleeds</em></td>
	</tr>
	
    <tr>
    	<td colspan="2" align="left"><b>Skin</b></td>
    </tr>
    <Tr>
    	<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td width="245"><em>Skin disease, hives, eczema</em></td>
        <td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Jaundice</em></td>
        
    </Tr>
    <tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td colspan="5"><em>Have you been in good general health most of your life? </em></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td colspan="5"><em>If not, please explain.</em> &nbsp; <br><img src="#path#pics/line.gif" width="500" height="1" border="0" align="absmiddle"></td>
	</tr>
</table>
<!--- ALLERGIES AND SENSITIVITIES --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="6"><b>ALLERGIES AND SENSITIVITIES</b> - <em>Is there a history of skin reaction or other reaction or sickness following injections or oral administration of:</em></td></tr>
	<tr><td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td width="245"><em>Penicillin or other antibiotics</em></td>
		
		<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td width="245"><em>Novocaine or other anesthetics</em></td>
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Aspirin, empirin or other pain remedies</em></td>
	
	</tr>

	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Any foods, such as egg, milk or chocolate</em></td>
		
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Any other drug or medication</em></td>
	</tr>
	<tr><td colspan="2"> &nbsp; <em>List: </em> &nbsp; <br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"> &nbsp; <em>List: </em> &nbsp; <br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Pets/Animals</em></td>
		
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Any other allergies?</em></td>
	</tr>
	<tr><td colspan="2"> &nbsp; <em>Please explain.</em> &nbsp; <br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"> &nbsp; <em>If yes, please list: </em> &nbsp; <br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>	
</table>
<!--- Psychological Issues --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="6"><b>PSYCHOLOGICAL ISSUES</b> - <em>Have you ever suffered from and/or received treatment for any of the following psychological issues:</em></td></tr>
	
    <tr>
    	<!--- ADHD --->
    	<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
        </td>
        <td width="245"><em>Attention Deficit Hyperactivity Disorder (ADHD)</em></td>
        <!--- Impulse-control disorders --->
        <td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
        </td>
        <td width="245"><em>Impulse-control disorders</em></td>
    </tr>
    <tr>
    	<!--- Anxiety disorders --->
    	<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
        </td>
        <td width="245"><em>Anxiety disorders</em></td>
       <!--- Dissociative disorders --->
    	<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
        </td>
        <td width="245"><em>Dissociative disorders</em></td>
    </tr>
 
    <tr>
    	<!--- Eating disorders --->
    	<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
        </td>
        <td width="245"><em>Eating disorders</em></td>
        	<!--- Cutting disorders --->
    	<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
        </td>
        <td width="245"><em>Cutting behavior (Factitious disorders)</em></td>
    </tr>
   
    <tr>
    	<!--- Depression --->
    	<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
        </td>
        <td width="245"><em>Depression</em></td>
        <!--- Substance Abuse --->
        <td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
        </td>
        <td width="245"><em>Substance Abuse</em></td>
    </tr>
    <tr>
    	<!--- Factitious disorders --->
    	<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
        </td>
        <td width="245"><em>Other</em></td>
        <td width="90" align="right" colspan="2"></td>
    </tr>
    <tr><td colspan="4"><em>If you answered yes to any of these, please provide a detailed explanation:</em></td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td colspan="4"><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
   
</table>

	<br><br>
	<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
		
		<tr>
			<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
			<td>&nbsp;</td>
			<td colspan="2"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		</tr>
        <tr><td><em>Student Signature</em></td><td>&nbsp;</td><td colspan="2"><em>Parent/Guardian Signature</em></td></tr>
		
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

</body>
</html>

</cftry>