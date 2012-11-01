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
            pw.ar_ref_quest1, 
            pw.ar_ref_quest2, 
            pw.ar_cbc_auth_form, 
            pw.ar_agreement 
		FROM 
        	smg_users u 
        INNER JOIN
        	user_access_rights uar ON uar.userID = u.userID AND uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#">
		LEFT OUTER JOIN 
        	smg_users_paperwork pw ON pw.userid = u.userid AND pw.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
		WHERE 
        	1 = 1
        AND   (uar.usertype = 5 OR uar.usertype = 6 OR uar.usertype = 7)
			<cfif FORM.status NEQ 'All'>
            AND	
                u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.status)#">
            </cfif>            
            
            AND
            (
                    pw.ar_ref_quest1 IS NULL 
                OR 
                    pw.ar_ref_quest2 IS NULL 
                OR
                    pw.ar_cbc_auth_form IS NULL
                OR 
                    pw.ar_agreement IS NULL 
            )
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
						<cfif NOT LEN(ar_ref_quest1)>AR Ref Quest. 1 &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_ref_quest2)>AR Ref Quest. 2 &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_cbc_auth_form)>CBC Authorization Form &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_agreement)>AR Agreement &nbsp; &nbsp; </cfif>
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