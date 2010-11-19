<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param URL Variables --->
    <cfparam name="URL.uniqueid" default="">

    <cfinclude template="../querys/get_candidate_unqid.cfm">
    <cfinclude template="../querys/countrylist.cfm">
    
    <cfquery name="qProgram" datasource="mysql">
        SELECT 
            programid, 
            programname, 
            companyid, 
            extra_sponsor
        FROM 
            smg_programs
        WHERE 
            programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqid.programid#">
        ORDER BY 
            programname
    </cfquery>
    
    <Cfquery name="qCandidatePlaceCompany" datasource="MySQL">
        SELECT 
        	*
        FROM 
        	extra_candidate_place_company
        WHERE 
        	candidateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqid.candidateid#">
        ORDER BY 
        	candcompid DESC
    </Cfquery>
    
    <!-----Int Rep----->
    <Cfquery name="qIntRep" datasource="MySQL">
        SELECT 
        	userid, 
            firstname, 
            lastname, 
            businessname, 
            country
        FROM 
        	smg_users
        WHERE 
        	usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND 
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqid.intrep#">
    </Cfquery>
    
    <cfquery name="qRequestedPlacement" datasource="mysql">
        SELECT 
        	*
        FROM 
        	extra_candidates
        INNER JOIN 
        	extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.requested_placement
        WHERE 
        	uniqueid = <cfqueryparam cfsqltype="cf_sql_char" value="#get_candidate_unqid.uniqueid#">
    </cfquery>

	<!--- Query of Queries --->
    <cfquery name="qHomeCountry" dbtype="query">
        SELECT 
        	countryID,
            countryname
        FROM 
        	countrylist
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqid.home_country#">
    </cfquery>
	
    <cfquery name="qBirthCountry" dbtype="query">
        SELECT 
        	countryID,
            countryname
        FROM 
        	countrylist
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqid.birth_country#">
    </cfquery>

    <cfquery name="qCitizenCountry" dbtype="query">
        SELECT 
        	countryID,
            countryname
        FROM 
        	countrylist
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqid.citizen_country#">
    </cfquery>

    <cfquery name="qResidenceCountry" dbtype="query">
        SELECT 
        	countryID,
            countryname
        FROM 
        	countrylist
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqid.residence_country#">
    </cfquery>

</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../../profile.css">
	<title>: EXTRA  ::  Candidate Profile :</title>
</head>
<body>

<cfif NOT LEN(URL.uniqueid)>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- candidate does not exist --->
<cfif get_candidate_unqid.recordcount EQ 0>
	The candidate ID you are looking for, <cfoutput>#URL.candidateid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the candidate record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view the candidate
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>
	
<link rel="stylesheet" href="profile.css" type="text/css">

<!--- Include Profile Content --->
<cfinclude template="candidate_profile_content.cfm">
 
