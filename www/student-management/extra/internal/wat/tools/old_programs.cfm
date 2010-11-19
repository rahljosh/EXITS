<!-----------<cfif session.usertype LTE '4'>

<cfif NOT IsDefined('url.active')>
	<cfset url.active = '1'>
</cfif>
----------------------------------->
<!------<Cfquery name="programs" datasource="MySQL">
	SELECT programid, programname, type, startdate, enddate, insurance_startdate, insurance_enddate, smg_programs.companyid, programfee,
			application_fee, insurance_w_deduct, insurance_wo_deduct, blank, hold, smg_programs.tripid, smg_programs.active,
			smg_companies.companyshort,
			smg_program_type.programtype,
			smg_incentive_trip.trip_place, smg_incentive_trip.trip_year,
	<!----		smg_seasons.season,
			smg.season as smgseason ---->
			


	FROM smg_programs
	INNER JOIN smg_companies ON smg_companies.companyid = smg_programs.companyid
	LEFT JOIN smg_program_type ON smg_program_type.programtypeid = smg_programs.type
<!-----	LEFT JOIN smg_incentive_trip ON smg_incentive_trip.tripid = smg_programs.tripid
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_programs.seasonid
	LEFT JOIN smg_seasons smg ON smg.seasonid = smg_programs.smgseasonid
	WHERE smg_programs.active = <cfqueryparam value="#url.active#" cfsqltype="cf_sql_integer">
	<cfif session.companyid NEQ 5>
		AND smg_programs.companyid = #session.companyid#
	</cfif>
	ORDER BY smg_companies.companyshort          ------------>
</Cfquery>
------------->

<style type="text/css">

body,td,th {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style1 {font-size: 10px}

</style>
<cfquery name="programstools" datasource="MySql">
	SELECT programid, programname, type, smg_program_type.programtype, startdate, enddate, insurance_startdate, insurance_enddate, smg_programs.companyid, smg_companies.companyname, programfee, smg_programs.active, smg_programs.hold
	FROM smg_programs
    INNER JOIN smg_companies ON smg_companies.companyid = smg_programs.companyid
    LEFT JOIN smg_program_type ON smg_program_type.programtypeid = smg_programs.type
    WHERE smg_programs.companyid = #client.companyid#
</cfquery>


<form method=post action="?curdoc=tools/new_program">

<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
	<tr bgcolor="E4E4E4">
	  <td width="85%" class="title1"> Program Maintenence</td>
		<td width="15%" class="title1"><!---<cfoutput>#programstools.active# </cfoutput>----></td>
	</tr>
</table><br />


<table width=95% border=0 align="center" cellpadding=4 cellspacing=0 class="section">
  <tr>
		<td bgcolor="4F8EA4"><strong><font color="#FFFFFF">Status
        </div>        
        </strong></td>
		<td bgcolor="4F8EA4"><strong><font color="#FFFFFF">Program Name
        </div>
		</strong></td>
		<td bgcolor="4F8EA4"><strong><font color="#FFFFFF">Type
        </div>
		</strong></td>
		<td bgcolor="4F8EA4"><font color="#FFFFFF"><strong>Start Date
        </div>
		</strong></td>
		<td bgcolor="4F8EA4"><font color="#FFFFFF"><strong>End Date
        </div>
		</strong></td>
		<td bgcolor="4F8EA4"><strong><font color="#FFFFFF">Company
        </div>
		</strong></td>
	
	  <!--- <td><b>Fee's</b></td> --->
	</tr>
	<cfoutput query="programstools">
	<tr bgcolor="#iif(programstools.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#"> <!---  --->
		<Td>
		  
		    <cfif #enddate# lt #now()#>
		      <font color="red">expired
		      <cfelseif hold is 1>
		      <font color="##3300CC">hold
		      <cfelseif #enddate# gt #now()#>
		      <font color="green">active
	        </cfif>
	    </div></Td>
		<td><a href="?curdoc=tools/change_programs&programid=#programid#">#programname# </a></div></td>
		<td>
		  
		    <cfif programtype is ''>
		      <font face="Verdana, Arial, Helvetica, sans-serif" color="red">None Assigned
		      <cfelse>
		      #programtype# 
	        </cfif>
        </div></td>
		<td>
		  </span>
	   #DateFormat(startdate, 'mm-dd-yyyy')#</div></td>
		<td>
		  </span>
	   #DateFormat(enddate, 'mm-dd-yyyy')#</div></td>
		<td>
		  </span>
	   #companyname#</div></td>
		
		<!--- <td>#programfee# *</td> --->
	</tr>
	</cfoutput>
	<Tr>
		<td colspan=8 align="center"><a href="index.cfm?curdoc=tools/new_program" class="style1"><input name="Submit" type="image" src="../pics/add-program.gif" alt="Add Program" border=0></a></td>
	</Tr>
	<tr><td colspan=8></span></td>
	</tr>
</table>
</form>
<!------------
<cfelse>
You do not have sufficient rights to edit programs.
</cfif>----------->

<!--- TURN PROGRAMS TO INACTIVE 
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM smg_programs p
	LEFT JOIN smg_program_type ON type = programtypeid
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	WHERE enddate < '#DateFormat(now(), 'yyyy-mm-dd')#'
	ORDER BY companyshort, programname
</cfquery>
<cfoutput query="get_program">
	<cfquery name="update" datasource="MySql">
		UPDATE smg_programs 
		SET active = '0'
		WHERE programid = '#get_program.programid#'
		LIMIT 1
	</cfquery>
</cfoutput>
---->

<!-----<cfinclude template="../footer.cfm"> --->