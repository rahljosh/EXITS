<CFIF not isdefined("form.school")>
	<CFSET form.school = "0">
</cfif>

<cfinclude template="../querys/get_local.cfm">

<cfquery name="get_host_school" datasource="MySQL">
	select *
	from smg_schools
	where schoolid = <cfqueryparam value="#form.school#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_school_dates" datasource="MySql">
	SELECT schooldateid, schoolid, smg_school_dates.seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends,
		smg_seasons.season
	FROM smg_school_dates
	INNER JOIN smg_seasons ON smg_seasons.seasonid = smg_school_dates.seasonid
	WHERE schoolid = <cfqueryparam value="#form.school#" cfsqltype="cf_sql_integer">
	AND smg_seasons.active = '1'
	ORDER BY smg_seasons.season
</cfquery>

<cfset season_list = ValueList(get_school_dates.seasonid)>

<cfquery name="get_seasons" datasource="MySql">
	SELECT seasonid, season, active
	FROM smg_seasons
	WHERE active = '1'
	<!--- get remaining seasons --->
	<cfif VAL(get_school_dates.recordcount)>
    	AND
        	seasonID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#season_list#" list="yes"> )
	</cfif>
	ORDER BY season
</cfquery>

<cfform action="?curdoc=querys/insert_school_info_pis" method="post" name=frmPhone>

<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
		<td background="pics/header_background.gif"><h2>School Information</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%" valign="top">
		<table border=0 cellpadding=2 cellspacing=0 align="left" width="100%">
			<tr bgcolor="e2efc7"><td class="label">School:</td><td class="form_text" colspan="3">
				<select name="school">
				<cfif #form.school# is 0><option value=0>New School
					<cfelse><option value=#get_host_school.schoolid# >#get_host_school.schoolname#</cfif>
				</select></td>
			</tr>
			<tr><td class="label">High School:</td><td class="form_text"> <cfinput type="text" name="name" size="23" value="#get_host_school.schoolname#"></td></tr>
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
							<option value="#state#" <Cfif local.state EQ state>selected</cfif>>#state#</option> <!--- host state for new schools --->
						<cfelse>
							<option value="#state#" <Cfif get_host_school.state EQ state >selected</cfif>>#state#</option> <!--- school's state --->
						</cfif>
					</cfloop>
				</select> &nbsp; &nbsp; &nbsp; &nbsp;
				Zip:  &nbsp; <cfinput type="text" name="zip" size="5" value="#get_host_school.zip#" maxlength="5"></td>
			</tr>
			<tr><td class="label">Contact:</td><td class="form_text" colspan=3><cfinput type="text" name="principal" size="23" value="#get_host_school.principal#"></td></tr>
			<tr><td class="label">Phone:</td><td class="form_text" colspan=3><cfinput type="text" name="phone" size="23" value="#get_host_school.phone#" onclick="javascript:getIt(this)"> nnn-nnn-nnnn</td></tr>
			<tr><td class="label">Fax:</td><td class="form_text" colspan=3><cfinput type="text" name="fax" size="23" value="#get_host_school.fax#" onclick="javascript:getIt2(this)"> nnn-nnn-nnnn</td></tr>
			<tr><td class="label">Contact Email:</td><td class="form_text" colspan=3> <cfinput name="email" size="23" type="text" value="#get_host_school.email#"></td></tr>
			<tr><td class="label">Web Site:</td><td class="form_text" colspan=3> <cfinput name="url" size="23" type="text" value="#get_host_school.url#"> <Cfif #get_host_school.url# is ''><cfelse><a href="#get_host_school.url#" target=_blank>Visit Web Site </a></cfif></td></tr>	
		</table>
	</td>
	<td width="20%" align="right" valign="top">
		<table border=0 cellpadding=2 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<div class="section"><br>
<table border=0 cellpadding=3 cellspacing=0 width=80%>
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
</div>

<table border=0 cellpadding=2 cellspacing=0 width=100% class="section">
	<tr><td align="left"><input name="reset" type="reset" value="Clear Fields"></td>
		<td align="left"><input name="Submit" type="image" src="pics/next.gif" align="left" border=0></td>
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