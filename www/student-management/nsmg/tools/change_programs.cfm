
<script type="text/javascript" language="javascript">
                       $(document).ready(function() {
               $(".jQueryModal").colorbox( {
                       width:"60%",
                       height:"90%",
                       iframe:true,
                       overlayClose:false,
                       escKey:false
               });
                       });
               </script>
<cfquery name="get_program" datasource="MySQL">
	SELECT programid, programname, fk_smg_student_app_programID, type, startdate, enddate, applicationDeadline, insurance_startdate, progress_reports_active ,insurance_enddate, preayp_date, smg_programs.companyid, programfee, insurance_batch, sevis_startdate, sevis_enddate,
			application_fee, insurance_w_deduct, insurance_wo_deduct, blank, hold, tripid, smg_programs.active, seasonid, smgseasonid, fieldviewable,
			smg_companies.companyshort
	FROM smg_programs
	INNER JOIN smg_companies ON smg_companies.companyid = smg_programs.companyid
	WHERE smg_programs.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.progid#">
	ORDER BY smg_companies.companyshort
</cfquery>

<cfquery name="program_types" datasource="mysql">
	SELECT * 
	FROM smg_program_type
	WHERE systemid = '1'
	ORDER BY programtype
</cfquery>
<cfquery name="student_app_program_types" datasource="mysql">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE  companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13,15,16" list="yes">)
    and isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	ORDER BY app_program
</cfquery>
<cfquery name="smg_trips" datasource="MySql">
	SELECT tripid, trip_place, trip_year  
	FROM smg_incentive_trip
</cfquery>

<cfquery name="smg_seasons" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
</cfquery>


	
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>Program Maintenance</h2></td>
		<td background="pics/header_background.gif" align="right"><a href="?curdoc=tools/programs">Programs List</a></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<Cfoutput>
	<Cfset new =0>
	<cfif get_program.insurance_w_deduct is 0.00 and get_program.insurance_wo_deduct is 0.00>
		<cfif #DateDiff('M', get_program.startdate, get_program.enddate)# GT 6>
			<cfset new = 1>
			<cfset get_program.insurance_w_deduct = 370>
			<cfset get_program.insurance_wo_deduct = 470>
		<cfelse>
			<cfset get_program.insurance_w_deduct = 275>
			<cfset get_program.insurance_wo_deduct = 220>
		</cfif>
	</cfif>
	
	<cfform action="index.cfm?curdoc=tools/qr_change_programs" method="post">
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr>
			<td><p>Make any changes, then click update.  </p></td>
		</tr>
	</table>
	
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><th align="center" colspan=2 bgcolor="e2efc7">Program Details</th></tr>
		<tr><td align="right">Program Name:</td>
			<td><input type="text" name="programname" value="#get_program.programname#"size=25> <input type="hidden" value="#get_program.programid#" name="programid"></td>
		</tr>
		<tr><td align="right">Program Type: </td>
			<td><select name="programtype">
				<option>Non - Assigned</option>
				<cfloop query="program_types">
				<option value="#programtypeid#" <cfif get_program.type is #programtypeid#>selected</cfif>>#programtype#</option>
				</cfloop>
				</select></td>
		</tr>
        <tr>
            <td align="right">Student Application: </td>
            <td> <select name="studentAppType">
                <option value=00>Select Type</option>
                <cfloop query="student_app_program_types">
                <option value="#app_programid#" <cfif get_program.fk_smg_student_app_programID is #app_programid#>selected</cfif>>#app_program#</option>
                </cfloop>
                </select>
            </td>
        </tr>
		<tr><td align="right">Start Date:</td>
			<td><cfinput type="text" name="startdate" value="#DateFormat(get_program.startdate, 'mm-dd-yyyy')#" size=9 maxlength="10" validate="date"> (mm-dd-yyyy)</td>
		</tr>
		<tr><td align="right">*End Date: </td>
			<td><cfinput type="text" name="enddate" value="#DateFormat(get_program.enddate, 'mm-dd-yyyy')#" size=9 maxlength="10" validate="date"> (mm-dd-yyyy)</td>
		</tr>
       <tr><td align="right">*Application Deadline: </td>
			<td><cfinput type="text" name="applicationDeadline" value="#DateFormat(get_program.applicationDeadline, 'mm-dd-yyyy')#" size=9 maxlength="10" validate="date"> (mm-dd-yyyy) program will not show on student application after this date</td>
		</tr>
		<tr><td align="right"><cfif #Right(cgi.HTTP_REFERER, 11)# is 'new_program'> <font color="red"></cfif>Default Fee: </td>
			<td><input type="text" name="programfee" value="#get_program.programfee#" size=10></td></tr>
	
	<!----Insurance Information---->
		<tr><td></td><td><font color="FF6600"><u><b>Insurance Information</b></u></font></td></tr>
		<tr><td align="right">Insurance Start Date: </td>
			<td><cfinput type="text" name="insurance_startdate" value="#DateFormat(get_program.insurance_startdate, 'mm-dd-yyyy')#" size=9 maxlength="10" validate="date"> (mm-dd-yyyy)</td></tr>
		<tr><td align="right">Insurance End Date: </td>
			<td><cfinput type="text" name="insurance_enddate" value="#DateFormat(get_program.insurance_enddate, 'mm-dd-yyyy')#" size=9 maxlength="10" validate="date"> (mm-dd-yyyy)</td>
		</tr>
				<tr><td align="right"> </td>
			<td><input type="checkbox" name="ins_batch" <cfif get_program.insurance_batch eq 1>checked</cfif>> Include Program in Batch Insurance Submission</td>
		</tr>
		<!----SEVIS Information---->
		<tr><td></td><td><font color="FF6600"><u><b>SEVIS Information</b></u></font></td></tr>
		<tr><td align="right">SEVIS Start Date: </td>
			<td><cfinput type="text" name="sevis_startdate" value="#DateFormat(get_program.sevis_startdate, 'mm-dd-yyyy')#" size=9 maxlength="10" validate="date"> (mm-dd-yyyy)</td></tr>
		<tr><td align="right">SEVIS End Date: </td>
			<td><cfinput type="text" name="sevis_enddate" value="#DateFormat(get_program.sevis_enddate, 'mm-dd-yyyy')#" size=9 maxlength="10" validate="date"> (mm-dd-yyyy)</td>
		</tr>
	
		
		
		
		<tr><td></td><td><font color="FF6600"><u><b>Pre-Ayp Start Date</b></u></font></td></tr>
		<tr><td align="right">Pre-Ayp Start Date:</td>
			<td><cfinput type="text" name="preayp_date" value="#DateFormat(get_program.preayp_date, 'mm-dd-yyyy')#" size=9 maxlength="10" validate="date"> (mm-dd-yyyy)</td>
		</tr>
		<tr><td></td><td><font color="FF6600"><u><b>Program Season</b></u></font></td></tr>
		<tr><td align="right">Program Season:</td>
			<td><select name="seasonid">
				<option value="0"></option>
				<cfloop query="smg_seasons">
                 <cfif smg_seasons.seasonid is #get_program.smgseasonid#><Cfset current_season = #seasonid#><Cfset current_season_label = #season#></cfif>
				<option value="#seasonid#" <cfif smg_seasons.seasonid is #get_program.seasonid#>selected</cfif>>#season#</option>
				</cfloop>
				</select></td>
		</tr>
		<tr><td></td><td>* School Dates.</td></tr>
		<tr><td></td><td><font color="FF6600"><u><b>SMG Reports Season</b></u></font></td></tr>		
		<tr><td align="right">SMG Season:</td>
			<td><select name="smgseasonid">
				<option value="0"></option>
				<cfloop query="smg_seasons">
               
				<option value="#seasonid#" <cfif smg_seasons.seasonid is #get_program.smgseasonid#>selected</cfif>>#season#</option>
				</cfloop>
				</select></td>
		</tr>
		<tr><td></td><td>* SMG Reports - Eg. 07 Jan Programs are considered 07/08 season.</td></tr>
		<tr><td></td><td><font color="FF6600"><u><b>Incentive Trip</b></u></font></td></tr>
		<tr><td align="right">Incentive Trip:</td>
			<td><select name="smg_trip">
				<option value="0">None</option>
				<cfloop query="smg_trips">
				<option value="#tripid#" <cfif smg_trips.tripid is #get_program.tripid#>selected</cfif>>#trip_place#</option>
				</cfloop>
				</select></td>
		</tr>
		<tr><th align="center" colspan=2 bgcolor="e2efc7">Program Options</th></tr>
		<tr>
					<tr>
			<td align="right"><Cfif client.companyid eq 14>District<cfelse>Region / State</Cfif> Status:</td>
			<td>
            <Cfif client.companyid eq 14>
            <a href="tools/districtStatus.cfm?programid=#url.progid#&seasonid=#current_season#&label=#current_season_label#&program=#get_program.programname#" class="jQueryModal">District Status</a>
            <Cfelse>
            <a href="tools/regionStatus.cfm?programid=#url.progid#&seasonid=#current_season#&label=#current_season_label#&program=#get_program.programname#" class="jQueryModal">Region Status</a>  |  <a href="tools/stateStatus.cfm?programid=#url.progid#&seasonid=#current_season#&label=#current_season_label#&program=#get_program.programname#" class="jQueryModal">State Status</a>
            </Cfif>
            </td>
		</tr>

    	<tr>
					<tr>
			<td align="right">Field Viewable:</td>
			<td><select name="fieldviewable">
			<option value=1 <cfif get_program.FIELDVIEWABLE is 1>selected</cfif> />Yes</option>
			<option value=0 <cfif get_program.FIELDVIEWABLE eq 0>selected</cfif> />No</option></td>
		</tr>
<tr>
			<td align="right">Progress Reports Active:</td>
			<td><select name="progress_reports_active">
			<option value=1 <cfif get_program.progress_reports_active is 1>selected</cfif> />Yes</option>
			<option value=0 <cfif get_program.progress_reports_active eq 0>selected</cfif> />No</option></td>
		</tr>		
				<tr>
                	<td></td><td>Student Status does NOT indicate the current status of students in this program.<br /> This allows you to globaly change the status of all students assigned to this program to ACTIVE or INACTIVE. <br /> Please be cautious in swithing the status willy nilly. <br />ALL students are switched to active/inactive regardless of any other factor. <br />This should really only be used to mark students as inactive when a program is done.</td>
		</tr>			
		<tr>
			<td align="right">Student Status:</td>
			<td><select name="student_status">
            <option value=9 selected></option>
			<option value=1 >ACTIVE</option>
			<option value=0 >INACTIVE</option> 
            </select> <input type="checkbox" name="change_status"> I've read the above statement and want to change the status of all students.
            </td>
		</tr>	
		
		<tr><td></td><td><font color="FF6600"><u><b>Insurance Fees</b></u></font></td></tr>
		<tr>
			<td align="right"><cfif #Right(cgi.HTTP_REFERER, 11)# is 'new_program' ><font color="red"></cfif>Deductible:</td>
			<td><input type="text" name ="insurance_w_deduct" value="#get_program.insurance_w_deduct#" size="5"></td>
		</tr>
		<tr>
			<td align="right"><cfif #Right(cgi.HTTP_REFERER, 11)# is 'new_program' ><font color="red"></cfif>Non-deductible:</td>
			<td><input type="text" name ="insurance_wo_deduct" value="#get_program.insurance_wo_deduct#" size="5"></td>
		</tr>
		<tr><td></td><td><font color="FF6600"><u><b>Invoicing Options</b></u></font></td></tr>
		<tr>
			<td align="right"><acronym title="Students in this program will not show on the regular invoice system.">Blank Only</acronym></td>
			<td><input type="checkbox" name="blank" value=1 <cfif get_program.blank is 1>checked</cfif>></td>
		</tr>
		<tr>
			<td align="right"><acronym title="Program will not show up in any sections until it is no longer on hold.">Hold</acronym></td>
			<td><input type="checkbox" name="hold" value=1 <cfif get_program.hold is 1>checked</cfif>></td>
		</tr>
		<cfif #Right(cgi.HTTP_REFERER, 11)# is 'new_program' or new is 1> 
		<Tr><td colspan=2>Insurance charges have been calculated off program length.<br>Click update to apply insurance charges and default fee.</td></Tr>
		</cfif>
<!--- 		<cfif get_program.enddate LTE #now()#>
			<tr bgcolor="e2efc7">
				<td colspan="2"><p>This program has expired.  You can not change the details on it.</p></td>
			</tr>
		<cfelse> --->
		<tr bgcolor="e2efc7">
			<td align="right">&nbsp; &nbsp; <input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.go(-1)"></td>
			<td align="left"> &nbsp; &nbsp; <input name="Submit" type="image" src="pics/update.gif" border=0></td>
		</tr>
		<!--- </cfif> --->
		<tr><td colspan=2 align="center"><font size="-2">* students in a given program will be marked inactive 10 days after the end date of their program.  Changing the end date may have undesirable results, so make sure you change it correctly.</td></tr>
	</table>
</cfform>
</cfoutput>

<cfinclude template="../table_footer.cfm">