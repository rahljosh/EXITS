<!--- ------------------------------------------------------------------------- ----
	
	File:		missing_area_rep_paperwork.cfm
	Author:		Marcus Melo
	Date:		January 21, 2009
	Desc:		Missing Area Rep Paperwork

	Updated:  	01-21-2010 - Display all reps and not only reps that are current supervising or placed a student.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Param Form Variables --->
	<cfparam name="FORM.seasonID" default="0">
    <cfparam name="FORM.regionID" default="0">
    <cfparam name="FORM.status" default="ALL">

	<!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">

	<!--- Get Season --->
    <cfquery name="qGetSeasonPaperwork" datasource="MySql">
        SELECT 
        	seasonID, 
            season
        FROM 
        	smg_seasons
        WHERE 
        	seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
    </cfquery>
          
    <!--- Get Program --->
    <cfquery name="qGetProgram" datasource="MYSQL">
        SELECT	
        	*
        FROM
        	smg_programs 
        LEFT JOIN 
        	smg_program_type ON type = programtypeid
        WHERE 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        AND 
        	smgseasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#"> <!--- smgseasonID / seasonID --->
    </cfquery>
    
    <cfset program_list = ValueList(qGetProgram.programid)>

	<!--- get company region --->
    <cfquery name="qGetRegions" datasource="MySQL">
        SELECT 
        	regionID, 
            regionname
        FROM 
        	smg_regions
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		AND            
            company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
            <cfif VAL(FORM.regionID)>
                AND 
                	regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
            </cfif>
        ORDER BY regionname
    </cfquery> 

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Missing Supervision Paperwork</title>
</head>

<body>

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfif FORM.seasonID EQ 0>
	In order to continue you must select a season. Please go back and try again.
	<cfabort>
<cfelseif NOT IsDefined('FORM.regionID')>
	In order to continue you must select a region. Please go back and try again.
	<cfabort>
</cfif>

<cfoutput>
<table width="800px" cellpadding="3" cellspacing="0" align="center">
	<tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - Missing Area Representative Paperwork</span></td></tr>
</table><br>

<table width="800px" cellpadding="3" cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Contract AYP: <b>#qGetSeasonPaperwork.season#</b>
		Program(s) Included in this Report:<br>
		<cfloop query="qGetProgram"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		</td>
	</tr>
</table><br>

<!--- table header --->
<table width="800px" cellpadding="3" cellspacing="0" align="center" frame="box">	
	<tr><th width="85%">Region</th><th width="15%">Total</th></tr>
</table><br>

<cfloop query="qGetRegions">
	
	<cfquery name="qGetReps" datasource="MySql">
		SELECT DISTINCT 
        	u.userid, 
            u.firstname, 
            u.lastname,
			pw.ar_info_sheet, 
            pw.ar_ref_quest1, 
            pw.ar_ref_quest2, 
            pw.ar_cbc_auth_form, 
            pw.ar_agreement, 
            pw.ar_training
		FROM 
        	smg_users u 
        INNER JOIN
        	user_access_rights uar ON uar.userID = u.userID AND uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#">
		LEFT OUTER JOIN 
        	smg_users_paperwork pw ON pw.userid = u.userid AND pw.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
		WHERE 
            	pw.ar_info_sheet IS NULL 
            OR 
            	pw.ar_ref_quest1 IS NULL 
            OR 
            	pw.ar_ref_quest2 IS NULL 
            OR
            	pw.ar_cbc_auth_form IS NULL
            OR 
            	pw.ar_agreement IS NULL 
            OR 
            	pw.ar_training IS NULL
		GROUP BY 
        	u.userid
		ORDER BY 
        	u.lastname
	</cfquery>

	<cfif qGetReps.recordcount>
		<!--- table header --->
		<table width="800px" cellpadding="3" cellspacing="0" align="center" frame="below">	
			<tr><th width="85%" bgcolor="##CCCCCC">#qGetRegions.regionname#</th>
			<th width="15%" bgcolor="##CCCCCC">#qGetReps.recordcount#</th>
			</tr>
		</table>
		<table width="800px" cellpadding="3" cellspacing="0" align="center" frame="below">
			<tr>
				<td width="30%"><b>Area Representative</b></td>
				<td width="70%"><b>Missing AR Paperwork</b></td>
			</tr>
			<cfloop query="qGetReps">			 
				<tr bgcolor="#iif(qGetReps.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
					<td>#firstname# #lastname# (###userid#)</td>
					<td width="100%"><font size="-4" style="font-style:italic">
						<cfif NOT LEN(ar_info_sheet)>AR Info Sheet &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_ref_quest1)>AR Ref Quest. 1 &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_ref_quest2)>AR Ref Quest. 2 &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_cbc_auth_form)>CBC Authorization Form &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_agreement)>AR Agreement &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_training)>AR Training Form &nbsp; &nbsp; </cfif>
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

<cfif not IsDefined('FORM.programid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<!--- Get Program --->
<cfquery name="qGetProgram" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE (<cfloop list="#FORM.programid#" index="prog">
		   programid = #prog# 
			<cfif prog EQ #ListLast(FORM.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<!--- get company region --->
<cfquery name="qGetRegions" datasource="MySQL">
	SELECT regionID, regionname
	FROM smg_regions
	WHERE company = '#CLIENT.companyid#' 
		<cfif FORM.regionID NEQ '0'>
			AND (<cfloop list="#FORM.regionID#" index='reg'>
			regionID = '#reg#'
			<cfif reg EQ #ListLast(FORM.regionID)#><Cfelse>or</cfif>
			</cfloop> )
		</cfif>
	ORDER BY regionname
</cfquery> 

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>
<table width="800px" cellpadding="3" cellspacing="0" align="center">
	<tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - Missing Area Representative Paperwork</span></td></tr>
</table><br>

<table width="800px" cellpadding="3" cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="qGetProgram"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		</td>
	</tr>
	<tr><td align="center">* Reps currently placing or supervising students in the program(s) above</td></tr>
</table><br>



<!--- table header --->
<table width="800px" cellpadding="3" cellspacing="0" align="center" frame="box">	
	<tr><th width="85%">Region</th><th width="15%">Total</th></tr>
</table><br>

<cfloop query="qGetRegions">
	
	<cfset current_region = qGetRegions.regionID>

	<cfquery name="qGetReps" datasource="MySql">
		SELECT DISTINCT u.userid, u.firstname, u.lastname, u.ar_info_sheet, ar_ref_quest1, ar_ref_quest2, ar_agreement, ar_training
		FROM smg_users u
		INNER JOIN smg_students s ON (s.arearepid = u.userid OR s.placerepid = u.userid)
		WHERE s.regionassigned = '#current_region#' 
			<cfif FORM.status NEQ 'all'>
			AND u.active = '#FORM.status#'
			</cfif>
			AND (<cfloop list="#FORM.programid#" index="prog">
				s.programid = #prog# 
				<cfif prog is #ListLast(FORM.programid)#><Cfelse>or</cfif>
				</cfloop> )
			AND (u.ar_info_sheet IS NULL OR ar_ref_quest1 IS NULL OR ar_ref_quest2 IS NULL OR ar_agreement IS NULL OR ar_training IS NULL) 
		GROUP BY u.userid
		ORDER BY u.lastname
	</cfquery>

	<cfif qGetReps.recordcount>
		<!--- table header --->
		<table width="800px" cellpadding="3" cellspacing="0" align="center" frame="below">	
			<tr><th width="85%" bgcolor="##CCCCCC">#qGetRegions.regionname#</th>
				<td width="15%" align="center" bgcolor="CCCCCC"><b>#qGetReps.recordcount#</b></td>
			</tr>
		</table>
		<table width="800px" cellpadding="3" cellspacing="0" align="center" frame="below">
			<tr>
				<td width="30%"><b>Area Representative</b></td>
				<td width="70%"><b>Missing Placement Paperwork</b></td>
			</tr>	
			<cfloop query="qGetReps">			 
				<tr bgcolor="#iif(qGetReps.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
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