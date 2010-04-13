<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.enteredDate" default="#DateFormat(Now(), 'mm/dd/yyyy')#">

    <cfinclude template="../querys/countrylist.cfm">

</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../../profile.css">
	<title>: EXTRA  ::  Candidate Profile :</title>
</head>
<body>

<link rel="stylesheet" href="profile.css" type="text/css">

<!--- Check if form submitted --->
<cfif FORM.submitted>

    <cfquery name="get_candidate_unqid" datasource="mysql">
        SELECT 
        	ec.*
        FROM 
        	extra_candidates ec
		INNER JOIN
        	smg_users u ON u.userID = ec.intRep
        WHERE
        	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        
        <cfif IsDate(FORM.enteredDate)>
			AND
            	ec.entryDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.enteredDate#">
        </cfif>
        
        ORDER BY
        	u.businessName,
            ec.candidateID
    </cfquery>

	<!--- Query did not return data --->
    <cfif NOT VAL(get_candidate_unqid.recordCount)>
        <p>
            Your search did not return any date. Please try again. <br>
            If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
        </p>
        <cfabort>
    </cfif>

	<cfloop query="get_candidate_unqid">
    
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
                uniqueid = <cfqueryparam value="#get_candidate_unqid.uniqueid#" cfsqltype="cf_sql_char">
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
    
        <!--- Include Profile Content --->
        <cfinclude template="candidate_profile_content.cfm">
     
        <!--- Add a Page Break --->
        <div style="page-break-after:always; margin-top:50px;"></div>
        
    </cfloop>

<cfelse>

	<!--- FORM NOT SUBMITTED --->

	<cfoutput>
    
        <table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC">
            <tr>
                <td>
                    <br>
                    <table cellpadding=3 cellspacing=3 border=1 align="center" width="50%" bordercolor="C7CFDC">
                        <tr>
                            <td valign="top">
                                <table width="100%" cellpadding=3 cellspacing=0 border=0>
                                    <form name="new_ticket" action="candidate/candidate_profile_batch.cfm" method="post" target="_blank">
                                    <input type="hidden" name="submitted" value="1">
                                    <tr bgcolor="C2D1EF">
                                    	<td class="style2" bgcolor="8FB6C9" colspan="2">&nbsp;:: Candidate Profile Batch</td>
                                    </tr>
                                    <tr>
                                        <td class="style1" valign="top" align="right"><b>Entered Date:</b></td>
                                        <td class="style1" align="left"><input type="text" name="enteredDate" value="#FORM.enteredDate#" class="date-pick"></td>
                                    </tr>
                                    <tr><td align="center" colspan="2"><input type="image" name="submit" value=" Submit " src="../pics/view.gif"></td></tr>
                                    </form>	
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br>
                </td>
            </tr>
        </table>
    
    </cfoutput>

</cfif>
