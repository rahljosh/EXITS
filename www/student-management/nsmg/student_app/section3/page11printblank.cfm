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
	<title>Page [11] - Health Questionnaire</title>
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

<cfif not IsDefined('url.curdoc')>
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
		<cfif IsDefined('url.curdoc')>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page11printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
		
<!--- MEDICAL HISTORY --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="4"><b>MEDICAL HISTORY</b> - <em>Have you had?</em></td></tr>
	<tr><td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td width="245"><em>Measles</em></td>
		<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td width="245"><em>Diabetes</em></td>	
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Mumps</em></td>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Cancer</em></td>	
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
		<td><em>Rubella</em></td>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Strokes</em></td>
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Concussion or Head Injuries</em></td>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Tuberculosis</em></td>		
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Rheumatic Fever or Heart Disease</em></td>
		<td align="right">&nbsp;</td>
		<td>&nbsp;</td>	
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td colspan="3"><em>Have you ever been hospitalized, had surgery, or been under extended medical care? </em></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td colspan="3"><em>If yes, for what reason?</em> &nbsp; <br><img src="#path#pics/line.gif" width="500" height="1" border="0" align="absmiddle"></td>
	</tr>	
</table><br>

<!--- SYSTEMIC REVIEW --->
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="4"><b>SYSTEMIC REVIEW</b> - <em>Do you have the following?</em></td></tr>
	<tr><td colspan="2" align="left"><b>Eyes-Ears-Nose-Throat:</b></td>
		<td colspan="2" align="left"><b>Skin</b></td>
	</tr>
	<tr><td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td width="245"><em>Eye disease or injury</em></td>
		<td width="90" align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td width="245"><em>Skin disease, hives, eczema</em></td>	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Do you wear glasses?</em></td>		
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Jaundice</em></td>
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
		<td><em>Frequent infection or boils</em></td>
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Headaches</em></td>	
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Abnormal pigmentation</em></td>	
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Glaucoma</em></td>
		<td colspan="2" align="left"><b>Neck:</b></td>
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Nosebleeds</em></td>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Stiffness</em></td>	
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Chronic sinus trouble</em></td>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Thyroid Trouble</em></td>

	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Ear Disease</em></td>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Enlarged glands</em></td>	
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Impaired hearing</em></td>
		<td colspan="2" align="left"><b>Respiratory: </b></td>
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Do you wear hearing aids?</em></td>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Spitting up blood</em></td>	
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Dizziness</em></td>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Chronic or frequent cough</em></td>	
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
		<td><em>Asthma</em></td>	
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td colspan="5"><em>Have you been in good general health most of your life? </em></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td colspan="5"><em>If not, please explain.</em> &nbsp; <br><img src="#path#pics/line.gif" width="500" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br>

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
		<td><em>Morphine, Codeine, Demerol, other narcotics</em></td>
		
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Sulfa drugs</em></td>
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Aspirin, empirin or other pain remedies</em></td>
		
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Adhesive tape or latex</em></td>
	</tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Tetanus, antitoxin or other serums</em></td>
		
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Iodine or merthiolate</em></td>
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
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="4"><em>Have you ever received any medical attention or counseling for: </em></td></tr>
	<tr><td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Depression</em></td>
		<td align="right">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp;
		</td>
		<td><em>Eating Disorders</em></td>
	</tr>
	<tr><td colspan="4"> &nbsp; <em>Please explain if yes.</em> &nbsp; <br><img src="#path#pics/line.gif" width="665" height="1" border="0" align="absmiddle"></td>
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

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</body>
</html>

</cftry>