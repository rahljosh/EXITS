<!--- This is used to set the relative directory, print_application.cfm sets this to an empty string --->
<cfparam name="relative" default="../">
<cfif LEN(URL.curdoc)>
	<cfset relative = "">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#relative#app.css"</cfoutput>>
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_interests" datasource="MySQL">
	SELECT interestid, interest
	FROM smg_interests
	WHERE student_app = 'yes'
	ORDER BY interest
</cfquery>

<cfquery name="qGetLanguages" datasource="MySql">
	SELECT
        l.ID,
        l.studentID,
        l.languageID,
        l.isPrimary,
        alk.name
	FROM
    	smg_student_app_language l
 	LEFT OUTER JOIN
    	applicationLookUp alk ON alk.fieldID = l.languageID
       	AND
          	alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="language">
  	WHERE
      	l.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.studentID#">
</cfquery>

<cfquery name="qGetPrimaryLanguage" dbtype="query">
	SELECT
    	*
   	FROM
    	qGetLanguages
   	WHERE
    	isPrimary = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<cfquery name="qGetSecondaryLangauges" dbtype="query">
	SELECT
    	*
   	FROM
    	qGetLanguages
   	WHERE
    	isPrimary = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
  	ORDER BY
    	name ASC
</cfquery>

<cfoutput query="get_student_info">

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0> 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0" height="33">
	<tr height="33">
		<td width="8" class="tableside"><img src="#relative#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#relative#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [03] - Personal Data</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page3print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#relative#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
	<tr><td colspan="8"><em>Check any activity in which you participate in your home country (check at least 3 and no more than 6).</em></td></tr>
	<tr><cfloop query="get_interests">	
		<td><cfif ListFind(get_student_info.interests, interestid, ",")><img src="#relative#pics/checkY.gif" width="13" height="13" border="0"><cfelse><img src="#relative#pics/checkN.gif" width="13" height="13" border="0"></cfif></td>
		<td>#interest# <cfif ListFind(get_student_info.interests, interestid, ",")>x</cfif></td>
			<cfif (get_interests.currentrow MOD 4 ) is 0></tr><tr></cfif>
		</cfloop>
	<tr><td colspan="8"><em>Other:</em></td></tr>
	<tr><td colspan="8">#app_other_interest#<br><img src="#relative#pics/line.gif" width="660" height="1" border="0" align="absmiddle"></td></tr>
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
        	#qGetPrimaryLanguage.name#
      	</td>
        <td></td>
        <td>
        	<cfloop query="qGetSecondaryLangauges">
            	#qGetSecondaryLangauges.name#
                <br />
            </cfloop>
      	</td>
    </tr>
</table>
<br />

<table width="660" border=0 cellpadding=0 cellspacing=0 align="center">
<tr><td><em>Please list any other specific interests, hobbies and activities and any awards or commendations:</em></td></tr>
</table>

<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
<tr>
	<td width="48%" valign="top">
		<table width="100%" border=0 cellpadding=0 cellspacing=0>
			<tr><td><em>Do you Play in a band?</em></td></tr>
			<tr>
				<td>
					<cfif band is 'yes'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
					<cfif band is 'no'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>	
					<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Do you play in an orchestra?</em></td></tr>					
			<tr>
				<td>
					<cfif orchestra is 'yes'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
					<cfif orchestra is 'no'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>	
					<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what instrument(s)?</em></td></tr>
			<tr><td>#app_play_instrument#<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Do you participate in any competitive sports?</em></td></tr>					
			<tr>
				<td>
					<cfif comp_sports is 'yes'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
					<cfif comp_sports is 'no'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>													
					<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what sport(s)?</em></td></tr>
			<tr><td>#app_play_sport#<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>How often do you attend church?</em></td></tr>					
			<tr>
				<td>
					<cfif religious_participation is 'active'>Active (1-2x times a week)</cfif>
					<cfif religious_participation is 'average'>Average (1x a week)</cfif>
					<cfif religious_participation is 'little interest'>Little Interest (occasionally)</cfif>
					<cfif religious_participation is 'inactive'>Inactive (Never attend)</cfif>
					<cfif religious_participation is 'no interest'>No Interest</cfif>
					<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Are you active in any church groups?</em></td></tr>					
			<tr><td>#churchgroup#<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Would you be willing to attend church with your host family?</em></td></tr>					
			<tr>
				<td>
					<cfif churchfam is 'yes'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
					<cfif churchfam is 'no'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>													
					<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
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
					<cfif smoke is 'yes'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
					<cfif smoke is 'no'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>													
					<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
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
					<cfif animal_allergies is 'yes'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
					<cfif animal_allergies is 'no'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>									
					<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what animals?</em></td></tr>					
			<tr><td>#app_allergic_animal#<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If you are allergic, is your allergy controlled by medications?</em></td></tr>					
			<tr>
				<td>
					<cfif app_take_medicine is 'yes'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
					<cfif app_take_medicine is 'no'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>																
					<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>Are you allergic to medications?</em></td></tr>					
			<tr>
				<td>
					<cfif med_allergies is 'yes'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
					<cfif med_allergies is 'no'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>													
					<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>If yes, what medication?</em></td></tr>					
			<tr><td>#app_allergic_medication#<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>			
			<tr><td>&nbsp;</td></tr>
			<tr><td><em>How many years have you studied English?</em></td></tr>					
			<tr><td>#yearsenglish#<br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</td>
</tr>
</table>

<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
	<tr><td><em>List the chores for which you are responsible at home.</em></td></tr>					
	<tr><td><div align="justify">#chores_list#<br><img src="#relative#pics/line.gif" width="660" height="1" border="0" align="absmiddle"></div></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>Briefly give reasons for wanting to become an exchange student.</em></td></tr>
	<tr><td><div align="justify">#app_reasons_student#<br><img src="#relative#pics/line.gif" width="660" height="1" border="0" align="absmiddle"></div></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#relative#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#relative#pics/p_spacer.gif"></td>
		<td width="42"><img src="#relative#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

</body>
</html>