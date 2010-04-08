<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>School Information</title>
</head>

<body>

<CFIF not isdefined("url.schoolid")>
	<CFSET url.schoolid = "0">
</cfif>

<script>
function areYouSure() { 
   if(confirm("You are about to delete this High School. You will not be able to recover this information. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

<cfquery name="get_school" datasource="caseusa">
	SELECT *
	FROM smg_schools
	WHERE schoolid = <cfqueryparam value="#url.schoolid#" cfsqltype="cf_sql_integer">
	ORDER BY schoolname
</cfquery>

<cfquery name="get_school_dates" datasource="caseusa">
	SELECT distinct schooldateid, schoolid, smg_school_dates.seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends,
		smg_seasons.season
	FROM smg_school_dates
	INNER JOIN smg_seasons ON smg_seasons.seasonid = smg_school_dates.seasonid
	WHERE schoolid = <cfqueryparam value="#url.schoolid#" cfsqltype="cf_sql_integer">
	AND smg_seasons.active = '1'
	ORDER BY smg_seasons.season
</cfquery>

<cfset season_list = ValueList(get_school_dates.seasonid)>

<cfquery name="get_seasons" datasource="caseusa">
	SELECT seasonid, season, active
	FROM smg_seasons
	WHERE active = '1'
	<!--- get remaining seasons --->
	<cfif get_school_dates.recordcount GT '0'>
		AND (
		 <cfloop list="#season_list#" index='school_seasons'>
			 seasonid != '#school_seasons#'
			 <cfif school_seasons EQ #ListLast(season_list)#><Cfelse>AND</cfif>
		  </cfloop> )
	</cfif>
	ORDER BY season
</cfquery>

<cfform action="?curdoc=querys/insert_school_list" method="post">

<cfinput type="hidden" name="schoolid" value="#url.schoolid#">

<cfoutput>
<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
	<td background="pics/header_background.gif"><h2>School Information</td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
<tr>
	<td align="left" width="45%">
		<table border=0 cellpadding=4 cellspacing=0>
			<tr><td class="label">High School:</td><td class="form_text" colspan="2"> <cfinput type="text" name="name" size="30" value="#get_school.schoolname#"></td></tr>
			<tr><td class="label">Address:</td><td class="form_text" colspan="2"> <cfinput type="text" name="address" size="30" value="#get_school.address#"></td></tr>
			<tr><td></td><td class="form_text" colspan="2"><cfinput type="text" name="address2" size="30" value="#get_school.address2#"></td></tr>
			<tr><td class="label">City: </td><td class="form_text" colspan="2"><cfinput type="text" name="city" size="20" value="#get_school.city#"></td></tr> 
			<tr>
				<td class="label">State:</td><td width="10" class="form_Text">
					<cfinclude template="../querys/states.cfm">
					<select name="state">
					<option>
					<cfloop query = states><option value="#state#" <Cfif get_school.state is #state#>selected</cfif>>#State#</option></cfloop>
					</select></td>
					<td>&nbsp; &nbsp; &nbsp; Zip: <cfinput type="text" name="zip" size="5" value="#get_school.zip#" maxlength="5"></td>
			</tr>
			<tr><td class="label">Contact:</td><td class="form_text" colspan="2"><cfinput type="text" name="principal" size=30 value="#get_school.principal#"></td></tr>
			<tr><td class="label">Phone:</td><td class="form_text" colspan="2"><cfinput type="text" name="phone" size=15 value="#get_school.phone#" onclick="javascript:getIt(this)"> nnn-nnn-nnnn</td></tr>
			<tr><td class="label">Fax:</td><td class="form_text" colspan="2"><cfinput type="text" name="fax" size=15 value="#get_school.fax#" onclick="javascript:getIt2(this)"> nnn-nnn-nnnn</td></tr>
			<tr><td class="label">Contact Email:</td><td class="form_text" colspan="2"> <cfinput name="email" size=30 type="text" value="#get_school.email#"></td></tr>
			<tr>
				<td class="label">Web Site:</td><td class="form_text" colspan="2"> <cfinput name="url" size=30 type="text" value="#get_school.url#"> <cfoutput><Cfif #get_school.url# is ''><cfelse><br><a href="http://#get_school.url#" target=_blank>Visit Web Site </a></cfif> </cfoutput></td>
			</tr>
		</table>
	</td>
	<cfif client.usertype LTE 4>
	<td align="left" valign="top">
		<table border=0 cellpadding=4 cellspacing=0 align="left">
			<tr><td><div id="subMenuNav"> 
						<div id="subMenuLinks"><a class="nav_bar" href="" onClick="javascript: win=window.open('reports/students_in_school.cfm?schoolid=#url.schoolid#', 'Settings', 'height=500, width=680, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Students</a></div>
					</div></td>
			</tr>
		</table>
	</td>
	</cfif>
</tr>	
</table>

<div class="section"><br>

<table border=0 cellpadding=3 cellspacing=0 width=750>
	<cfinput type="hidden" name="count" value="#get_school_dates.recordcount#">
	<cfif get_school_dates.recordcount NEQ '0'>
	<tr><th colspan="6" bgcolor="e2efc7"><b>School Dates</b></th></tr>
		<tr>
			<td align="center"><b>Season</b></td>		
			<td align="center"><b>Enrollment/Orientation</b> <br><font size="-2">mm/dd/yyyy</font></td>		
			<td align="center"><b>Year Begins</b> <br><font size="-2">mm/dd/yyyy</font></td>		
			<td align="center"><b>1<sup>st</sup> Semester Ends</b> <br><font size="-2">mm/dd/yyyy</font></td>
			<td align="center"><b>2<sup>nd</sup> Semester Begins</b> <br><font size="-2">mm/dd/yyyy</font></td>	
			<td align="center"><b>Year Ends</b> <br><font size="-2">mm/dd/yyyy</font></td>		
		</tr>
		<cfloop query="get_school_dates">
		<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
			<td align="center"><b>#season#</b> <cfinput type="hidden" name="schooldateid#currentrow#" value="#schooldateid#"></td>
			<td align="center"><cfinput type="Text" name="enrollment#currentrow#" size="8" value="#DateFormat(enrollment, 'mm/dd/yyyy')#" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="year_begins#currentrow#"  size="8" value="#DateFormat(year_begins, 'mm/dd/yyyy')#" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="semester_ends#currentrow#" size="8" value="#DateFormat(semester_ends, 'mm/dd/yyyy')#" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="semester_begins#currentrow#" size="8" value="#DateFormat(semester_begins, 'mm/dd/yyyy')#" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="year_ends#currentrow#"  size="8" value="#DateFormat(year_ends, 'mm/dd/yyyy')#" validate="date" maxlength="10"></td>
		</tr>
		</cfloop>
	</cfif>
	<!--- NEW DATES --->
	<cfif get_seasons.recordcount GT '0'>
	<tr><th colspan="6" bgcolor="e2efc7">Add New Season for School Dates</th></tr>
	<tr>
		<td align="center"><b>Season</b></td>		
		<td align="center"><b>Enrollment/Orientation</b> <br><font size="-2">mm/dd/yyyy</font></td>		
		<td align="center"><b>Year Begins</b> <br><font size="-2">mm/dd/yyyy</font></td>		
		<td align="center"><b>1<sup>st</sup> Semester Ends</b> <br><font size="-2">mm/dd/yyyy</font></td>
		<td align="center"><b>2<sup>nd</sup> Semester Begins</b> <br><font size="-2">mm/dd/yyyy</font></td>	
		<td align="center"><b>Year Ends</b> <br><font size="-2">mm/dd/yyyy</font></td>							
	</tr>
	<tr>
		<td align="center">
			<cfselect name="seasonid" required="yes" message="You must select a season">
				<option value="0">Select a Season</option>
				<cfloop query="get_seasons">
				<option value="#seasonid#">#season#</option>
				</cfloop>
			</cfselect>
		</td>
		<td align="center"><cfinput type="Text" name="enrollment" size="8" value="" validate="date" maxlength="10"></td>
		<td align="center"><cfinput type="Text" name="year_begins"  size="8" value="" validate="date" maxlength="10"></td>
		<td align="center"><cfinput type="Text" name="semester_ends" size="8" value="" validate="date" maxlength="10"></td>
		<td align="center"><cfinput type="Text" name="semester_begins" size="8" value="" validate="date" maxlength="10"></td>
		<td align="center"><cfinput type="Text" name="year_ends"  size="8" value="" validate="date" maxlength="10"></td>
	</tr>
	<tr><td colspan="6"><font size="-2" color="000099">* In order to add new dates you must select a season.</font></td></tr>
	<cfelse>
		<cfinput type="hidden" name="seasonid" value="0">
	</cfif>
</table><br>

</div>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><cfif client.usertype LTE '4'><a href="?curdoc=querys/delete_school&schoolid=#schoolid#" onClick="return areYouSure(this);"><img src="pics/delete.gif" border="0"></img></a></cfif> &nbsp; &nbsp; &nbsp;</td>
		<td align="left"> &nbsp;  &nbsp; &nbsp;<input name="Submit" type="image" src="pics/update.gif" border=0></td>
	</tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>

</cfform>
	
</body>
</html>