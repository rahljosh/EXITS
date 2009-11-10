<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Missing Supervision Paperwork</title>
</head>

<body>

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfsetting requesttimeout="300">

<cfif form.seasonid EQ 0>
	In order to continue you must select a season. Please go back and try again.
	<cfabort>
<cfelseif NOT IsDefined('form.regionid')>
	In order to continue you must select a region. Please go back and try again.
	<cfabort>
</cfif>

<!--- Get Season --->
<cfquery name="get_season_paperwork" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
	WHERE seasonid = '#form.seasonid#'
</cfquery>

<!--- agreements for the 06-07 year but they place 07-08 kids --->
<cfset form.seasonid = form.seasonid>

<!--- Get Season --->
<cfquery name="get_season_placed" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
	WHERE seasonid = '#form.seasonid#'
</cfquery>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE companyid = '#client.companyid#'
		AND smgseasonid = '#form.seasonid#' <!--- smgseasonid / seasonid --->
</cfquery>
<cfset program_list = ValueList(get_program.programid)>

<!--- get company region --->
<cfquery name="get_regions" datasource="MySQL">
	SELECT regionid, regionname
	FROM smg_regions
	WHERE company = '#client.companyid#' 
		<cfif form.regionid NEQ '0'>
			AND (<cfloop list="#form.regionid#" index='reg'>
			regionid = '#reg#'
			<cfif reg EQ #ListLast(form.regionid)#><Cfelse>or</cfif>
			</cfloop> )
		</cfif>
	ORDER BY regionname
</cfquery> 

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>
<table width="670" cellpadding="3" cellspacing="0" align="center">
	<tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - Missing Area Representative Paperwork</span></td></tr>
</table><br>

<table width="670" cellpadding="3" cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Contract AYP: <b>#get_season_paperwork.season#</b>
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		</td>
	</tr>
	<tr><td align="center">* Reps currently placing or supervising students in the program(s) above</td></tr>
</table><br>

<!--- table header --->
<table width="670" cellpadding="3" cellspacing="0" align="center" frame="box">	
	<tr><th width="85%">Region</th><th width="15%">Total</th></tr>
</table><br>

<cfloop query="get_regions">
	
	<cfset current_region = get_regions.regionid>

	<cfquery name="get_reps" datasource="MySql">
		SELECT DISTINCT u.userid, u.firstname, u.lastname,
			pw.ar_info_sheet, pw.ar_ref_quest1, pw.ar_ref_quest2, pw.ar_agreement, pw.ar_training
		FROM smg_users u 
		INNER JOIN smg_students s ON (s.arearepid = u.userid OR s.placerepid = u.userid)
		INNER JOIN smg_programs p ON p.programid = s.programid
		LEFT JOIN smg_users_paperwork pw ON (pw.userid = u.userid AND pw.seasonid = p.smgseasonid)
		WHERE s.regionassigned = '#current_region#' 
			<cfif form.status NEQ 'all'>
			AND u.active = '#form.status#'
			</cfif>
			AND s.companyid = '#client.companyid#'
			AND p.smgseasonid = '#form.seasonid#'
			AND (pw.ar_info_sheet IS NULL OR pw.ar_ref_quest1 IS NULL OR pw.ar_ref_quest2 IS NULL OR pw.ar_agreement IS NULL OR pw.ar_training IS NULL)
		GROUP BY u.userid
		ORDER BY u.lastname
	</cfquery>

	<cfif get_reps.recordcount>
		<!--- table header --->
		<table width="670" cellpadding="3" cellspacing="0" align="center" frame="below">	
			<tr><th width="85%" bgcolor="##CCCCCC">#get_regions.regionname#</th>
			<th width="15%" bgcolor="##CCCCCC">#get_reps.recordcount#</th>
			</tr>
		</table>
		<table width="670" cellpadding="3" cellspacing="0" align="center" frame="below">
			<tr>
				<td width="30%"><b>Area Representative</b></td>
				<td width="70%"><b>Missing Placement Paperwork</b></td>
			</tr>	
			<cfloop query="get_reps">			 
				<tr bgcolor="#iif(get_reps.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
					<td>#firstname# #lastname# (###userid#)</td>
					<td><font size="-3" style="font-style:italic">
						<cfif ar_info_sheet EQ ''>AR Info Sheet &nbsp; &nbsp; </cfif>
						<cfif ar_ref_quest1 EQ ''>AR Ref Quest. 1 &nbsp; &nbsp; </cfif>
						<cfif ar_ref_quest2 EQ ''>AR Ref Quest. 2 &nbsp; &nbsp; </cfif>
						<cfif ar_agreement EQ ''>AR Agreement &nbsp; &nbsp; </cfif>
						<cfif ar_training EQ ''>AR Training Form &nbsp; &nbsp; </cfif>
						</font>
					</td>
				</tr>								
			</cfloop>			
		</table><br>
	</cfif>	

</cfloop>

</cfoutput>

</body>
</html>


<!----
USES PROGRAM ID INSTEAD OF SEASON ID 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Missing Supervision Paperwork</title>
</head>

<body>

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfsetting requesttimeout="300">

<cfif not IsDefined('form.programid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE (<cfloop list="#form.programid#" index="prog">
		   programid = #prog# 
			<cfif prog EQ #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<!--- get company region --->
<cfquery name="get_regions" datasource="MySQL">
	SELECT regionid, regionname
	FROM smg_regions
	WHERE company = '#client.companyid#' 
		<cfif form.regionid NEQ '0'>
			AND (<cfloop list="#form.regionid#" index='reg'>
			regionid = '#reg#'
			<cfif reg EQ #ListLast(form.regionid)#><Cfelse>or</cfif>
			</cfloop> )
		</cfif>
	ORDER BY regionname
</cfquery> 

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>
<table width="670" cellpadding="3" cellspacing="0" align="center">
	<tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - Missing Area Representative Paperwork</span></td></tr>
</table><br>

<table width="670" cellpadding="3" cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		</td>
	</tr>
	<tr><td align="center">* Reps currently placing or supervising students in the program(s) above</td></tr>
</table><br>

<!--- table header --->
<table width="670" cellpadding="3" cellspacing="0" align="center" frame="box">	
	<tr><th width="85%">Region</th><th width="15%">Total</th></tr>
</table><br>

<cfloop query="get_regions">
	
	<cfset current_region = get_regions.regionid>

	<cfquery name="get_reps" datasource="MySql">
		SELECT DISTINCT u.userid, u.firstname, u.lastname, u.ar_info_sheet, ar_ref_quest1, ar_ref_quest2, ar_agreement, ar_training
		FROM smg_users u
		INNER JOIN smg_students s ON (s.arearepid = u.userid OR s.placerepid = u.userid)
		WHERE s.regionassigned = '#current_region#' 
			<cfif form.status NEQ 'all'>
			AND u.active = '#form.status#'
			</cfif>
			AND (<cfloop list="#form.programid#" index="prog">
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			AND (u.ar_info_sheet IS NULL OR ar_ref_quest1 IS NULL OR ar_ref_quest2 IS NULL OR ar_agreement IS NULL OR ar_training IS NULL) 
		GROUP BY u.userid
		ORDER BY u.lastname
	</cfquery>

	<cfif get_reps.recordcount>
		<!--- table header --->
		<table width="670" cellpadding="3" cellspacing="0" align="center" frame="below">	
			<tr><th width="85%" bgcolor="##CCCCCC">#get_regions.regionname#</th>
				<td width="15%" align="center" bgcolor="CCCCCC"><b>#get_reps.recordcount#</b></td>
			</tr>
		</table>
		<table width="670" cellpadding="3" cellspacing="0" align="center" frame="below">
			<tr>
				<td width="30%"><b>Area Representative</b></td>
				<td width="70%"><b>Missing Placement Paperwork</b></td>
			</tr>	
			<cfloop query="get_reps">			 
				<tr bgcolor="#iif(get_reps.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td>#firstname# #lastname# (###userid#)</td>
					<td><font size="-3" style="font-style:italic">
						<cfif ar_info_sheet EQ ''>AR Info Sheet &nbsp; &nbsp; </cfif>
						<cfif ar_ref_quest1 EQ ''>AR Ref Quest. 1 &nbsp; &nbsp; </cfif>
						<cfif ar_ref_quest2 EQ ''>AR Ref Quest. 2 &nbsp; &nbsp; </cfif>
						<cfif ar_agreement EQ ''>AR Agreement &nbsp; &nbsp; </cfif>
						<cfif ar_training EQ ''>AR Training Form &nbsp; &nbsp; </cfif>
						</font>
					</td>
				</tr>								
			</cfloop>			
		</table><br>
	</cfif>	

</cfloop>

</cfoutput>

</body>
</html>
---->