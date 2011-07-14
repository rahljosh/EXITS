<cfsetting requesttimeout="9999">

<!--- Param FORM variables --->
<cfparam name="FORM.programID" default="0">
<cfparam name="FORM.studentStatus" default="1">
<cfparam name="FORM.countryID" default="0">
<cfparam name="FORM.userID" default="0">
<cfparam name="FORM.printOption" default="1">
<cfparam name="FORM.submitted" default="0">

<cfquery name="qGetIntlRepList" datasource="MySql">
    SELECT 
        userid, 
        businessname
    FROM 
        smg_users
    WHERE         
        usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
    AND 
        businessname != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
    ORDER BY 
        businessname
</cfquery>

<cfscript>
	// Get Program List
	qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
</cfscript>

<cfquery name="qGetCountry" datasource="MySQL">
	SELECT
    	countryID,
        countryname
    FROM
    	smg_countrylist
</cfquery>

<cfoutput>
<!--- Form --->
<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" name="form" onSubmit="return formValidation()">
<input type="hidden" name="submitted" value="1" />

<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
    <tr valign="middle" height="24">
        <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Intl. Rep. Reports -> Candidate by Citizenship and Residence
 
 

</font>
        </td>
    </tr>
    <tr valign="middle" height="24">
        <td valign="middle" colspan="2">&nbsp;</td>
    </tr>
    <tr valign="middle">
        <td align="right" valign="middle" class="style1"><b>Intl. Rep.:</b> </td>
        <td valign="middle">  
            <select name="userID" class="style1">
                <option value="All">---  All International Representatives  ---</option>
                <cfloop query="qGetIntlRepList">
                    <option value="#qGetIntlRepList.userID#" <cfif qGetIntlRepList.userID EQ FORM.userID> selected</cfif> >#qGetIntlRepList.businessname#</option>
                </cfloop>
            </select>
        </td>
    </tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Program:</b></td>
        <td> 
            <select name="programID" class="style1">
                <option value="0">---  All Programs  ---</option>
                <cfloop query="qGetProgramList">
                	<option value="#programID#" <cfif qGetProgramList.programID eq FORM.programID> selected</cfif> >#programname#</option>
                </cfloop>
            </select>
        </td>
    </tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Country:</b></td>
        <td> 
            <select name="countryID" class="style1">
                <option value="0">---  All Countries  ---</option>
                <cfloop query="qGetCountry">
                	<option value="#countryID#" <cfif qGetCountry.countryID eq FORM.countryID> selected</cfif> >#countryname#</option>
                </cfloop>
            </select>
        </td>
    </tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Country:</b></td>
        <td> 
            <select name="studentStatus" class="style1">
            	<option value="All" <cfif "All" eq FORM.studentStatus> selected</cfif>>All</option>
                <option value="0" <cfif 0 eq FORM.studentStatus> selected</cfif>>Canceled</option>
                <option value="1" <cfif 1 eq FORM.studentStatus> selected</cfif>>Active</option>
            </select>
        </td>
    </tr>
    <Tr>
        <td align="right" class="style1"><b>Format: </b></td>
        <td  class="style1"> 
            <input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1">Onscreen (View Only)</label>
            <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2">Print (FlashPaper)</label> 
            <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked </cfif> > <label for="printOption3">Print (PDF)</label>
		</td>           
    </Tr>
    <tr>
        <td colspan=2 align="center"><br />
            <input type="submit" value="Generate Report" class="style1" />
            <br />
		</td>
	</tr>
</table>

</form>

</cfoutput>

<cfif NOT VAL(FORM.submitted)>
	<cfabort>
</cfif>

<cfquery name="qGetAgents" datasource="MySQL">
    SELECT
        ec.intrep,
        ec.residence_country,
        ec.citizen_country,
        u.businessName,
        u.country,
        scl.countryname
    FROM
        extra_candidates ec
    INNER JOIN 
        smg_users u ON u.userid = ec.intrep
    INNER JOIN
        smg_countrylist scl ON scl.countryid = u.country
    WHERE
    	1 = 1
	<cfif FORM.studentStatus IS NOT "All">
    	AND
        	ec.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentStatus#">
    </cfif>
    <cfif VAL(FORM.userID)>
        AND
            intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
    </cfif>
    <cfif VAL(FORM.programID)>
        AND
            programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
    </cfif>
    <cfif VAL(FORM.countryID)>
        AND
        (
            citizen_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.countryID#">
        OR
            residence_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.countryID#">
        )
    </cfif>
</cfquery>

<cfquery name="qFilterCountry1" dbtype="query">
   	
        SELECT
            citizen_country AS country
        FROM
            qGetAgents
        
        UNION ALL
        
        SELECT
            residence_country AS country
        FROM
            qGetAgents

</cfquery>

<cfquery name="qFilterCountry" dbtype="query">
   	
	SELECT
    	DISTINCT(country)
    FROM
    	qFilterCountry1
    WHERE
    	country >= 1
    <cfif VAL(FORM.countryID)>
        AND
        	country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.countryID#">
    </cfif>

</cfquery>

<cffunction name="filterGetAgents">

	<cfargument name="citizen" default="0">
    <cfargument name="residence" default="0">
    <cfargument name="agentid" default="0">
    <cfargument name="onlyCitizens" default="0">
    <cfargument name="onlyResidents" default="0">
    
    <cfquery name="qFilterGetAgents" dbtype="query">
        SELECT
            *
        FROM
            qGetAgents
        WHERE
            1 = 1
        <cfif VAL(ARGUMENTS.citizen)>
        	AND
            	citizen_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.citizen)#">
        </cfif>
        <cfif VAL(ARGUMENTS.residence)>
        	AND
            	residence_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.residence)#">
        </cfif>
        <cfif VAL(ARGUMENTS.agentid)>
        	AND
            	intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.agentid#">
        </cfif>
        <cfif VAL(ARGUMENTS.onlyCitizens)>
        	AND
            	citizen_country >= 1
        </cfif>
        <cfif VAL(ARGUMENTS.onlyResidents)>
        	AND
            	residence_country >= 1
        </cfif>
    </cfquery>
    
    <cfreturn qFilterGetAgents>

</cffunction>

<style type="text/css">
<!--
.tableTitleView {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	padding:2px;
	color:#FFFFFF;
	background:#4F8EA4;
}
-->
</style>

<cfscript>
	grandTotalCitizens = filterGetAgents(onlyCitizens = 1, citizen = #VAL(FORM.countryID)#).recordCount;
	grandTotalResidents = filterGetAgents(onlyResidents = 1, residence = #VAL(FORM.countryID)#).recordCount;
</cfscript>

<cfoutput>
<table>
    <tr>
    	<td align="right">
        	<strong><small>Citizens (Grand Total):</small></strong>
        </td>
        <td>
        	<strong><small>#grandTotalCitizens#</small></strong>
        </td>
    </tr>
    <tr>
        <td align="right">
        	<strong><small>Residents (Grand Total):</small></strong>
        </td>
        <td>
        	<strong><small>#grandTotalResidents#</small></strong>
        </td>
    </tr>
</table>
</cfoutput>

<table cellpadding="3" cellspacing="1">
	
    <cfloop query="qFilterCountry">
    
    	<cfquery name="qGetCountry2" datasource="MySQL">
            SELECT
                countryID,
                countryname
            FROM
                smg_countrylist
            WHERE
            	countryID = #qFilterCountry.country#
        </cfquery>
    
    	<cfscript>
			totalCitizensPerCountry = filterGetAgents(citizen = qFilterCountry.country).recordCount;
			totalResidentsPerCountry = filterGetAgents(residence = qFilterCountry.country).recordCount;
		</cfscript>
        
        <cfset citizenPercent = totalCitizensPerCountry/grandTotalCitizens * 100>
        <cfset residentPercent = totalResidentsPerCountry/grandTotalResidents * 100>
        
        <tr>
            <cfoutput>
                <td><strong><small>#qGetCountry2.countryname#</small></strong></td>
                <td></td>
                <td align="center"><strong><small>Total Citizens: #totalCitizensPerCountry# (#numberFormat(citizenPercent, "0.00")#%)</small></strong></td>
                <td align="center"><strong><small>Total Residents: #totalResidentsPerCountry# (#numberFormat(residentPercent, "0.00")#%)</small></strong></td>
            </cfoutput>
        </tr>
        
        <tr bordercolor="#3366CC">
            <td style="background-color:#003366; font:Arial, Helvetica, sans-serif; color:#FFFFFF"><strong><small>Agent Country</small></strong></td>
            <td style="background-color:#003366; font:Arial, Helvetica, sans-serif; color:#FFFFFF"><strong><small>International Agent</small></strong></td>
            <td align="center" style="background-color:#003366; font:Arial, Helvetica, sans-serif; color:#FFFFFF"><strong><small>Citizens</small></strong></td>
            <td align="center" style="background-color:#003366; font:Arial, Helvetica, sans-serif; color:#FFFFFF"><strong><small>Residents</small></strong></td>
        </tr>
        
        <cfquery name="qFilterAgents" dbtype="query">
            SELECT
                DISTINCT(intrep) AS intrep, businessName, countryname
            FROM
                qGetAgents
            WHERE
                citizen_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#qFilterCountry.country#">
            OR
                residence_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#qFilterCountry.country#">
            ORDER BY
            	businessname
        </cfquery>
        
        <cfoutput query="qFilterAgents">
        
            <cfscript>
                totalCitizensPerAgent = filterGetAgents(citizen = qFilterCountry.country, agentid = qFilterAgents.intrep).recordCount;
                totalResidentsPerAgent = filterGetAgents(residence = qFilterCountry.country, agentid = qFilterAgents.intrep).recordCount;
            </cfscript>
            
            <tr>
                <td><small>#qFilterAgents.countryname#</small></td>
                <td><small>#qFilterAgents.businessName#</small></td>
                <td align="center"><small>#totalCitizensPerAgent#</small></td>
                <td align="center"><small>#totalResidentsPerAgent#</small></td>
            </tr>
        
        </cfoutput>
        <tr>
            <td colspan="4">
            ---------------------------------------------------------------------------------------------------------------------------------------------------------------
            </td>
        </tr>
        <tr height="15">
            <td colspan="4">
            </td>
        </tr>

    </cfloop>

</table>