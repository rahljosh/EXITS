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
	<title>Page [13] - Immunization Record</title>
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
		<td class="tablecenter"><h2>Page [13] - Immunization Record</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page13printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td><b>IMMUNIZATIONS REQUIRED FOR SCHOOL ADMITTANCE</b></td></tr>
	<tr>
    	<td>
    		<div align="justify">
				<cfif ListFind("14,15,16", get_student_info.app_indicated_program)>     
                    <!--- Canada Application --->       	
                    Pupils enrolled in kindergarten through grade 12 are required to have written proof on file at their
                    public or nonpublic school that they have been immunized against DTaP (diphtheria, pertussis, tetanus), poliomyelitis, measles,
                    mumps, rubella, hepatitis B and varicella. Failure to do so is cause for exclusion from school. Required immunizations may
                    vary from school to school.
                <cfelse>
                    <!--- USA - Public High School --->
                    Pupils enrolled in kindergarten through grade 12 (in the United States) are required to have written proof on file at their
                    public or nonpublic school that they have been immunized against DTaP (diphtheria, pertussis, tetanus), poliomyelitis, measles,
                    mumps, rubella, hepatitis B and varicella. Failure to do so is cause for exclusion from school. Required immunizations may
                    vary from state to state.
                </cfif>	
			</div>
		</td>
    </tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><b>MINIMUM IMMUNIZATION REQUIREMENTS:</b></td></tr>
	<tr><td>Five or more doses of DTaP</td></tr>
	<tr><td>Three or more doses of trivalent oral polio vaccine (TOPV).</td></tr>
	<tr><td>Two doses measles vaccine.</td></tr>
	<tr><td>Two doses mumps vaccine.</td></tr>
	<tr><td>Two doses rubella vaccine.</td></tr>
    <tr><td>Two doses of Hepatitis A vaccine.</td></tr>
	<tr><td>Three doses of Hepatitis B vaccine.</td></tr>
	<tr><td>Two doses of Varicella vaccine (Two doses required if first dose issued after thirteenth birthday).</td></tr>
    <tr><td>Two doses of Meningococcal vaccine (Two doses required if older than 16).</td></tr>
	<tr><td>If the final dose of any of the above vaccines occurs before the third birthday, a booster shot is required.</td></tr>
</table><br>

<table width="670" border=1 cellpadding=3 cellspacing=0  bordercolor="CCCCCC" align="center">
	<tr><td align="center"><b>IMMUNIZATIONS</b></td><td colspan="6" align="center"><b>DATES (mm/dd/yyyy)</b></td></tr>
	<!--- DTaP --->
	<tr>
		<td align="center" width="130" valign="top"><b>DTaP</b></td>
		<td align="center" width="90" valign="top"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><br> <small>2nd </small></td>
		<td align="center" width="90" valign="top"><br> <small>3rd </small></td>
		<td align="center" width="90" valign="top"><br> <small>4th </small></td>
		<td align="center" width="90" valign="top"><br> <small>5th </small></td>
		<td align="center" width="90" valign="top"><br> <small>6th <br> Booster, if required </small></td>				
	</tr>
	
	<!--- TOPV --->
	<tr>
		<td align="center" width="130" valign="top"><b>TOPV</b></td>
		<td align="center" width="90" valign="top"><br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><br> <small>2nd</small></td>
		<td align="center" width="90" valign="top"><br> <small>3rd</small></td>
		<td align="center" width="90" valign="top"><br> <small>4th <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
	
	<!--- MEASLES --->	
	<tr>
		<td align="center" width="130" valign="top"><b>Measles</b></td>
		<td align="center" width="90" valign="top"><br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><br> <small>2nd</small></td>
		<td align="center" width="90" valign="top"><br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
	
	<!--- MUMPS --->
	<tr>
		<td align="center" width="130" valign="top"><b>Mumps</b></td>
		<td align="center" width="90" valign="top"><br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><br> <small>2nd</small></td>
		<td align="center" width="90" valign="top"><br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>	
	
	<!--- RUBELLA --->
	<tr>
		<td align="center" width="130" valign="top"><b>Rubella</b></td>
		<td align="center" width="90" valign="top"><br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><br> <small>2nd</small></td>
		<td align="center" width="90" valign="top"><br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
	
	<!--- VARICELLA --->
	<tr>
		<td align="center" width="130" valign="top"><b>Varicella</b> <br> <small>(chickenpox)</small></td>
		<td align="center" width="90" valign="top"><br> <small>date of disease </small></td>
		<td align="center" width="90" valign="top"><br> <small>1st </small></td>
		<td align="center" width="90" valign="top"><br> <small>2nd</small></td>
		<td align="center" width="90" valign="top"><br> <small>3rd <br> Booster, if required <small></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
    
    <!--- HEPATITIS A--->
	<tr>
		<td align="center" width="130" valign="top"><b>Hepatitis A</b></td>
		<td align="center" width="90" valign="top"><br> <small>1st </small><br><br></td>
		<td align="center" width="90" valign="top"><br> <small>2nd </small><br><br></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
							
	<!--- HEPATITIS B--->
	<tr>
		<td align="center" width="130" valign="top"><b>Hepatitis B</b></td>
		<td align="center" width="90" valign="top"><br> <small>1st </small><br><br></td>
		<td align="center" width="90" valign="top"><br> <small>2nd </small><br><br></td>
		<td align="center" width="90" valign="top"><br> <small>3rd </small><br><br></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
    
    <!--- MENINGOCOCCAL--->
	<tr>
		<td align="center" width="130" valign="top"><b>Meningococcal</b></td>
		<td align="center" width="90" valign="top"><br> <small>1st </small><br><br></td>
		<td align="center" width="90" valign="top"><br> <small>2nd </small><br><br></td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>
		<td align="center" width="90" valign="top">&nbsp;</td>				
	</tr>
</table><br>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
    <tr>
        <td>
            <div align="justify">
                <cfif ListFind("14,15,16", get_student_info.app_indicated_program)>     
                    <!--- Canada Application --->       	
                    Any immunizations not available in your country are available here, but they are expensive and are not
                    covered by insurance. The student must be prepared to pay for any immunizations they receive in Canada. Please make every
                    effort to obtain all immunizations before your departure from your home country.
                <cfelse>
                    <!--- USA - Public High School --->
                    Any immunizations not available in your country are available here, but they are expensive and are not
                    covered by insurance. The student must be prepared to pay for any immunizations they receive in the USA. Please make every
                    effort to obtain all immunizations before your departure from your home country.
                </cfif>	
            </div>
        </td>
    </tr>
</table><br><br>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td width="315"><em>Signature of Physician</em></td><td width="40">&nbsp;</td><td width="315"><em>Date</em></td></tr>
	<tr>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
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