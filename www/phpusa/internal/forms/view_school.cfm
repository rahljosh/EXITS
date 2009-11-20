<HEAD>
<!----Script to show diff fields---->			
<script type="text/javascript">
<!--
function changeDiv(the_div,the_change)
{
  var the_style = getStyleObject(the_div);
  if (the_style != false)
  {
	the_style.display = the_change;
  }
}
function hideAll()
{
  changeDiv("1","none");
  changeDiv("2","none");

}
function getStyleObject(objectId) {
  if (document.getElementById && document.getElementById(objectId)) {
	return document.getElementById(objectId).style;
  } else if (document.all && document.all(objectId)) {
	return document.all(objectId).style;
  } else {
	return false;
  }
}
// -->
</script>
</head>

<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: xx-small;
}
.style3 {font-size: x-small}
.style6 {font-size: 12px}
.style10 {font-size: 16px; font-weight: bold; color: #000066; }
underline{border-bottom: 1px}
-->
</style>

<cfif not IsDefined('url.sc')>
	<table width=680 cellpadding=0 cellspacing=0 border=0 align="center">
		<tr><td>Sorry, an error has ocurred. Please go back try again.</td></tr>
	</table>
	<cfabort>
</cfif>

<cfquery name="get_school" datasource="mysql">
	SELECT sc.*,
		smg_states.state as us_state, smg_states.statename
	FROM php_schools sc
	LEFT JOIN smg_states ON smg_states.id = sc.state
	WHERE schoolid = <cfqueryparam value="#url.sc#" cfsqltype="cf_sql_integer">
</cfquery>

<cfinclude template="../querys/get_states.cfm">

<cfform method="post" action="querys/update_school.cfm"> 

<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		<td bgcolor="#e9ecf1"><h2>V i e w  &nbsp; S c h o o l  <br><br></td>
		<td bgcolor="#e9ecf1" align="right"><a href="index.cfm?curdoc=lists/schools">Back to Schools List</a></td>
	</tr>
</table>

<cfoutput>

<cfinput type="hidden" name="schoolid" value="#get_school.schoolid#">

<table width="90%" align="center"  bgcolor="##ffffff" cellpadding=0 cellspacing=0>
	<tr>
		<td wdith=15>
		<cfif client.usertype lte 4>
			<cfinput type="radio" name="usertype" onClick="hideAll(); changeDiv('1','block');" checked value="personal">School Info 
			<cfinput type="radio" name="usertype" onClick="hideAll(); changeDiv('2','block');" value="billing">Website Info &nbsp;&nbsp;
		</cfif>
		</td>
		<td align="right"><strong><font size=+1>#get_school.schoolname#</font></strong></td>
	</tr>
</table>
					
<!----Inclues for School Info---->
<cfif client.usertype NEQ 8>
	<div id="1" STYLE="display:block">
		<cfinclude template="int_school_info.cfm">
	</div>
</cfif>

<div id="2" STYLE="display:none">
	<Cfinclude template="ext_school_info.cfm">
</div>

<!----Enrollemnt Dates---->
<cfquery name="get_school_dates" datasource="mysql">
	SELECT schooldateid, schoolid, php_school_dates.seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends,
		smg_seasons.season
	FROM php_school_dates
	INNER JOIN smg_seasons ON smg_seasons.seasonid = php_school_dates.seasonid
	WHERE schoolid = '#url.sc#'
		AND smg_seasons.active = '1'
	ORDER BY smg_seasons.season
</cfquery>

<cfset season_list = ValueList(get_school_dates.seasonid)>

<cfquery name="get_seasons" datasource="mysql">
	SELECT DISTINCT seasonid, season, active
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

<!----End of School Includes---->
<table width = 90% border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor=##ffffff>
	<tr>
	<td colspan=10  class="box">
	<table border=0 cellpadding=3 cellspacing=0 width=100%>
	<cfinput type="hidden" name="count" value="#get_school_dates.recordcount#">
	<cfif get_school_dates.recordcount NEQ '0'>
	<tr bgcolor="C2D1EF"><th colspan="6"><b>School Dates</b></th></tr>
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
			<td align="center"><cfinput type="Text" name="enrollment#currentrow#" size="10" value="#DateFormat(enrollment, 'mm/dd/yyyy')#" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="year_begins#currentrow#"  size="10" value="#DateFormat(year_begins, 'mm/dd/yyyy')#" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="semester_ends#currentrow#" size="10" value="#DateFormat(semester_ends, 'mm/dd/yyyy')#" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="semester_begins#currentrow#" size="10" value="#DateFormat(semester_begins, 'mm/dd/yyyy')#" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="year_ends#currentrow#"  size="10" value="#DateFormat(year_ends, 'mm/dd/yyyy')#" validate="date" maxlength="10"></td>
		</tr>
		</cfloop>
	</cfif>
		<!--- NEW DATES --->
		<cfif get_seasons.recordcount GT '0'>
		<tr bgcolor="C2D1EF"><th colspan="6">Add New Season for School Dates</th>
		</tr>
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
			<td align="center"><cfinput type="Text" name="enrollment" size="10" value="" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="year_begins"  size="10" value="" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="semester_ends" size="10" value="" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="semester_begins" size="10" value="" validate="date" maxlength="10"></td>
			<td align="center"><cfinput type="Text" name="year_ends"  size="10" value="" validate="date" maxlength="10"></td>
		</tr>
		<tr><td colspan="6"><font size="-2" color="000099">* In order to add new dates you must select a season.</font></td></tr>
		<cfelse>
			<cfinput type="hidden" name="seasonid" value="0">
		</cfif>
	</table><br>
	</td>
</tr>
<tr>

	<td colspan=10  class="box">
	
<!----Community Info---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 colspan=4>
	<tr valign=middle height=24>
		<td align="center" bgcolor="C2D1EF"><b>Community Information</b></td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%" valign="top">
		<table border=0 cellpadding=4 cellspacing=0 align="left" width="100%">
			
			<tr><td colspan="2">Would you describe the community as:</td></tr>
			<tr><td colspan="2">
				<cfif #get_school.communitytype# is 'Urban'><cfinput type="radio" name="communitytype" value="Urban" checked><cfelse><cfinput type="radio" name="communitytype" value="Urban"> </cfif>Urban
				<cfif #get_school.communitytype# is 'suburban'><cfinput type="radio" name="communitytype" value="suburban" checked><cfelse><cfinput type="radio" name="communitytype" value="suburban"></cfif>Suburban
				<cfif #get_school.communitytype# is 'small'><cfinput type="radio" name="communitytype" value="small" checked><cfelse><cfinput type="radio" name="communitytype" value="small"></cfif>Small Town
				<cfif #get_school.communitytype# is 'rural'><cfinput type="radio" name="communitytype" value="rural" checked><cfelse><cfinput type="radio" name="communitytype" value="rural"></cfif>Rural
				</td></tr>
			<tr><td class="label">Closest City:</td><td class="form_text"><cfinput type="text" name="nearbigcity" size=20 value="#get_school.nearbigcity#"></td></tr>
			<tr><td class="label">Distance:</td><td class="form_text"> <cfinput name="bigcitydistance" size=3 type="text" value="#get_school.bigcitydistance#">miles</td></tr>
			<tr><td class="label">Major Airport Code:</td><td class="form_text"><cfinput type="text" name="major_air_code" size=3 value="#get_school.major_air_code#" onchange="javascript:this.value=this.value.toUpperCase();"></td></tr>
			
			<tr><td class="label">Arrival Airport Code:</td><td class="form_text"><cfinput type="text" name="local_air_code" size=3 value="#get_school.local_air_code#" onchange="javascript:this.value=this.value.toUpperCase();"></td></tr>
			<tr><td class="label">Arrival Airport City: </td><td class="form_text"><cfinput type="text" name="airport_city" size="20" value="#get_school.airport_city#"></td></tr>
			<tr><td class="label" >Arrival Airport State: </td><td width=10>
				<cfinclude template="../querys/states.cfm">
				<select name="airport_state">
				<option>
					<cfloop query = states>
						<option value="#state#" <Cfif get_school.airport_state is #state#>selected</cfif>>#State#</option>
					</cfloop>
				</select></td></tr>
			<tr bgcolor="C2D1EF"><td colspan="2">Points of interest in the community:</td>
			</tr>
			<tr bgcolor="C2D1EF"><td colspan="2"><textarea cols="60" rows="4" name="pert_info" wrap="VIRTUAL"><cfoutput>#get_school.pert_info#</cfoutput></textarea></td>
			</tr>					
		</table>
	</td>
	<td width="20%" align="right" valign="top">
				
	</td>
	</tr>
</table>
	</td>
</tr>
<tr>
	<td align="center" colspan=2 bordercolor="FFFFFF">
		<table>
			<tr>
				<td><input name="Submit" type="image" src="pics/update.gif" alt="Update School"  border=0></input>&nbsp; &nbsp; &nbsp;</td>
				<cfif client.usertype LTE 4>
				<td><a href="querys/delete_school.cfm?sc=#get_school.schoolid#" onClick="return areYouSure(this);"><img src="pics/delete-btn.gif" border="0" alt="Delete #get_school.schoolname#"></img></a> </td>
				</cfif>
			</tr>
		</table>
	</td>
</tr>
</table>
</cfoutput>

</cfform>
