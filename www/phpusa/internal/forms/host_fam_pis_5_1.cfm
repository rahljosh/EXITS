<CFIF not isdefined("form.school")>
	<CFSET form.school = "0">
</cfif>

<cfinclude template="../querys/get_local.cfm">

<cfquery name="get_host_school" datasource="mysql">
	select *
	from php_schools
	where schoolid = <cfqueryparam value="#form.school#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_school_dates" datasource="mysql">
	SELECT schooldateid, schoolid, school_dates.seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends,
		smg_seasons.season
	FROM php_school_dates school_dates
	INNER JOIN smg_seasons ON smg_seasons.seasonid = school_dates.seasonid
	WHERE schoolid = <cfqueryparam value="#form.school#" cfsqltype="cf_sql_integer">
	AND smg_seasons.active = '1'
	ORDER BY smg_seasons.season
</cfquery>

<cfset season_list = ValueList(get_school_dates.seasonid)>

<cfquery name="get_seasons" datasource="mysql">
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

<cfform action="?curdoc=querys/insert_school_info_pis" method="post" name=frmPhone>

<cfoutput>
<h2>&nbsp;&nbsp;&nbsp;&nbsp;S t u d e n t &nbsp;&nbsp;&nbsp;  I n f o r m a t i o n <font size=-2>[ <cfoutput><a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a></cfoutput> ] </font></h2>

<table width="90%" border=1 align="center" cellpadding=8 cellspacing=8 bordercolor="##C2D1EF" bgcolor="##FFFFFF" class="section">
	<tr><td width="80%" valign="top" class="box">
		<table border=0 cellpadding=2 cellspacing=0 align="left" width="100%">
			<tr bgcolor="e2efc7"><td bgcolor="C2D1EF" class="label">School:</td><td colspan="3" bgcolor="C2D1EF" class="form_text">
				<select name="school">
				<cfif #form.school# is 0><option value=0>New School
					<cfelse><option value=#get_host_school.schoolid# >#get_host_school.schoolname#</cfif>
				</select></td>
			</tr>
			<tr><td class="label">High School:</td><td class="form_text"> <cfinput type="text" name="schoolname" size="23" value="#get_host_school.schoolname#"></td></tr>
			<tr><td class="label">Address:</td><td class="form_text"> <cfinput type="text" name="address" size="23" value="#get_host_school.address#"></td></tr>
			<tr><td></td><td class="form_text"> <cfinput type="text" name="address2" size="23" value="#get_host_school.address2#"></td></tr>
			<tr><td class="label">City: </td><td class="form_text"><cfinput type="text" name="city" size="23" value="#get_host_school.city#"></td></tr> 
			<tr><td class="label" >State:</td>
				<td class="form_Text">
				<cfinclude template="../querys/states.cfm">
				
				<select name="state">
					<option>
					<cfloop query = states>
					
						<cfif form.school EQ '0'>
							<option value=#id# <Cfif local.id EQ id>selected</cfif>>#state#</option> <!--- host state for new schools --->
						<cfelse>
							<option value=#id# <Cfif get_host_school.state EQ id >selected</cfif>>#state#</option> <!--- school's state --->
						</cfif>
					</cfloop>
				</select> &nbsp; &nbsp; &nbsp; &nbsp;
				Zip:  &nbsp; <cfinput type="text" name="zip" size="5" value="#get_host_school.zip#" maxlength="5"></td>
			</tr>
			<tr><td class="label">Contact:</td><td class="form_text" colspan=3><cfinput type="text" name="contact" size="23" value="#get_host_school.contact#"></td></tr>
			<tr><td class="label">Phone:</td><td class="form_text" colspan=3><cfinput type="text" name="phone" size="23" value="#get_host_school.phone#" onclick="javascript:getIt(this)"> nnn-nnn-nnnn</td></tr>
			<tr><td class="label">Fax:</td><td class="form_text" colspan=3><cfinput type="text" name="fax" size="23" value="#get_host_school.fax#" onclick="javascript:getIt2(this)"> nnn-nnn-nnnn</td></tr>
			<tr><td class="label">Contact Email:</td><td class="form_text" colspan=3> <cfinput name="email" size="23" type="text" value="#get_host_school.email#"></td></tr>
			<tr><td class="label">Web Site:</td><td class="form_text" colspan=3> <cfinput name="website" size="23" type="text" value="#get_host_school.website#"> <Cfif #get_host_school.website# is ''><cfelse><a href="#get_host_school.website#" target=_blank>Visit Web Site </a></cfif></td></tr>	
		</table>
	</td>
	<td width="20%" align="right" valign="top" class="box">
		<table border=0 cellpadding=2 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<div class="section"><br>
  <table width="90%"  border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C2D1EF" bgcolor="##FFFFFF">
    <tr>
      <td class="box"><table width=100% border=0 align="center" cellpadding=3 cellspacing=0>
        <cfinput type="hidden" name="count" value="#get_school_dates.recordcount#">
        <cfif get_school_dates.recordcount NEQ '0'>
          <tr bgcolor="C2D1EF">
            <th colspan="6"><b>School Dates</b></th>
          </tr>
          <tr>
            <td align="center"><b>Season</b></td>
            <td align="center"><b>Enrollment/Orientation</b> <br>
                <font size="-2">mm/dd/yyyy</font></td>
            <td align="center"><b>Year Begins</b> <br>
                <font size="-2">mm/dd/yyyy</font></td>
            <td align="center"><b>1<sup>st</sup> Semester Ends</b> <br>
                <font size="-2">mm/dd/yyyy</font></td>
            <td align="center"><b>2<sup>nd</sup> Semester Begins</b> <br>
                <font size="-2">mm/dd/yyyy</font></td>
            <td align="center"><b>Year Ends</b> <br>
                <font size="-2">mm/dd/yyyy</font></td>
          </tr>
          <cfloop query="get_school_dates">
            <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,de("ffffe6") )#">
              <td align="center"><b>#season#</b>
                  <cfinput type="hidden" name="schooldateid#currentrow#" value="#schooldateid#"></td>
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
          <tr bgcolor="C2D1EF">
            <th colspan="6">Add New Season for School Dates</th>
          </tr>
          <tr>
            <td align="center"><b>Season</b></td>
            <td align="center"><b>Enrollment/Orientation</b> <br>
                <font size="-2">mm/dd/yyyy</font></td>
            <td align="center"><b>Year Begins</b> <br>
                <font size="-2">mm/dd/yyyy</font></td>
            <td align="center"><b>1<sup>st</sup> Semester Ends</b> <br>
                <font size="-2">mm/dd/yyyy</font></td>
            <td align="center"><b>2<sup>nd</sup> Semester Begins</b> <br>
                <font size="-2">mm/dd/yyyy</font></td>
            <td align="center"><b>Year Ends</b> <br>
                <font size="-2">mm/dd/yyyy</font></td>
          </tr>
          <tr>
            <td align="center"><cfselect name="seasonid" required="yes" message="You must select a season">
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
          <tr>
            <td colspan="6"><font size="-2" color="000099">* In order to add new dates you must select a season.</font></td>
          </tr>
          <cfelse>
          <cfinput type="hidden" name="seasonid" value="0">
        </cfif>
      </table></td>
    </tr>
  </table>
  <br>
</div>

<table width=90% border=0 align="center" cellpadding=2 cellspacing=0 class="section">
	<tr><td align="left"><input name="reset" type="reset" value="Clear Fields"></td>
		<td align="left"><input name="Submit" type="image" src="pics/next.gif" align="left" alt="next" border=0></td>
	</tr>
</table>


</cfoutput>
</cfform>