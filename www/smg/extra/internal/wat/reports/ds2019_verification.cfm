<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param FORM variables --->
    <cfparam name="FORM.print" default="">
	<cfparam name="FORM.program" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.date" default="">

	<cfset toLine = "">
    
	<!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">

    <cfquery name="qGetProgram" datasource="MySQL">
        SELECT 
        	programID,
            programName,
            extra_sponsor
        FROM 
        	smg_programs
        WHERE
        	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.program)#">
    </cfquery>
    
    <cfquery name="qGetCandidates" datasource="MySQL">
        SELECT	 
        	c.candidateID, 
            c.lastname, 
            c.firstname,
            c.middlename, 
            c.sex, 
            c.dob, 
            c.birth_city,
            c.intRep,
            c.wat_vacation_start, 
            c.wat_vacation_end, 
            c.enddate, 
            c.startdate, 
            c.ds2019,
            birth.countryname as countrybirth,
          	resident.countryname as countryresident,
            citizen.countryname as countrycitizen
        FROM 	
        	extra_candidates c
        LEFT JOIN
        	smg_countrylist birth ON c.birth_country = birth.countryid
        LEFT JOIN 
        	smg_countrylist resident ON c.residence_country = resident.countryid
        LEFT JOIN 
        	smg_countrylist citizen ON c.citizen_country = citizen.countryid
        WHERE 
        	c.verification_received IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
        AND 
        	c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(client.companyID)#">
        AND 
        	c.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.program)#">
        AND 
        	c.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.intRep)#">
        AND 
        	(
            	c.ds2019 IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
            OR
            	c.ds2019 = <cfqueryparam cfsqltype="cf_sql_date" value="">
			)
        ORDER BY 
        	c.candidateID
    </cfquery>

	<!-----Intl. Rep.----->
    <cfquery name="qGetIntlAgent" datasource="MySQL">
        SELECT 
        	userID,
            companyID, 
            businessname, 
            fax, 
            email
        FROM 
        	smg_users
        WHERE
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.intRep)#">
    </cfquery>

	<cfscript>
		if ( qGetProgram.extra_sponsor EQ 'INTO' ) {
			// Set Sponsor
			setSponsor = qGetProgram.extra_sponsor;
		} else {
			// Default Sponsor
			setSponsor = 'WAT';	
		}
	</cfscript>
    
</cfsilent>
    
<style type="text/css">
	<!--
	.style1 { 
		font-family: Arial, Helvetica, sans-serif;
		font-size: 10; 	}
	.thin-border-bottom { 
		border-bottom: 1px solid #000000; }
		.thin-border-top { 
		border-top: 1px solid #000000; }
	.thin-border{ border: 1px solid #000000;}
	-->
</style>

<!----
<cfdocument format="pdf" orientation="landscape">
---->

<cfoutput>

<table width=100% align="center" border=0 bgcolor="FFFFFF">
    <tr>
        <td  valign="top" width=90>
            <span id="titleleft">
                <span class="style1">
                    TO:<br>
                    FAX:<br>
                    E-MAIL:<br><br><br>		
                </span>
            </span>                    
        </td>
        <td  valign="top" class="style1">
            <span id="titleleft">
                <cfif len(qGetIntlAgent.businessname) gt 40>#Left(qGetIntlAgent.businessname,40)#...<cfelse>#qGetIntlAgent.businessname#</cfif><br>
                #qGetIntlAgent.fax#<br>
                <a href="mailto:#qGetIntlAgent.email#">#qGetIntlAgent.email#</a><br><br><br>
                #DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br>	
            </span>
        </td>
        <td class="style1">
            <img src="../../../../#APPLICATION.CSB[setSponsor].logo#" />
        </td>	
        <td align="right" valign="top" class="style1"> 
            <div align="right">
                <span id="titleleft">
                    #APPLICATION.CSB[setSponsor].shortProgramName# <br> <!--- #companyshort.companyshort# --->
                    #companyshort.address#<br>
                    #companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
                    Phone: #APPLICATION.CSB[setSponsor].phone# <br> <!--- #companyshort.phone# --->
                    Toll Free: #APPLICATION.CSB[setSponsor].toolFreePhone# <br> <!--- #companyshort.toll_free# --->
                    Fax: #companyshort.fax# <br>
                </span>
            </div>	
        </td>
    </tr>		
</table>

<div id="pagecell_reports">
    <img src="../../pics/black_pixel.gif" width="100%" height="2">

    <div align="center" class="style1">
        <font size="+3"> DS 2019 Verification Report</font>
    </div>

    <img src="../../pics/black_pixel.gif" width="100%" height="2">

    <span class="style1"><br></span>
    <span class="style1"><br></span>

    <table width=100% frame=below cellpadding=7 cellspacing="0" class="thin-border-bottom" >
        <tr class="thin-border-bottom" >
            <td width=3% valign="top" class="style1"><strong>ID</strong></td>
            <td width=14% valign="top" class="style1"><strong>Last Name</strong></td>
            <td width=14% valign="top" class="style1"><strong>First Name</strong></td>
            <td width=14% valign="top" class="style1"><strong>Middle Name</strong></td>
            <td width=6% valign="top" class="style1"><strong>Sex</strong></td>
            <td width=9% valign="top" class="style1"><strong>Date of Birth</strong></td>
            <td width=10% valign="top" class="style1"><strong>City of Birth</strong></td>
            <td width=10% valign="top" class="style1"><strong>Country of Birth</strong></td>
            <td width=10% valign="top" class="style1"><strong>Country of Citizenship</strong></td>
            <td width=12% valign="top" class="style1"><strong>Country of Residence</strong></td>
            <td width=10% valign="top" class="style1"><strong>Start Date </strong></td>
            <td width=10% valign="top" class="style1"><strong>End Date </strong></td>
        </tr>        
        <cfloop query="qGetCandidates">
            <tr bgcolor="#iif(qGetCandidates.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
                <td class="style1" valign="top">#qGetCandidates.candidateID#</td>
                <td class="style1" valign="top">#qGetCandidates.lastname#</td>
                <td class="style1" valign="top">#qGetCandidates.firstname#</td>
                <td class="style1" valign="top">#qGetCandidates.middlename#</td>
                <td class="style1" valign="top">#qGetCandidates.sex#</td>
                <td class="style1" valign="top">#DateFormat(qGetCandidates.dob, 'mm/dd/yyyy')#</td>
                <td class="style1" valign="top">#qGetCandidates.birth_city#</td>
                <td class="style1" valign="top">#qGetCandidates.countrybirth#</td>
                <td class="style1" valign="top">#qGetCandidates.countrycitizen#</td>
                <td class="style1" valign="top" >#qGetCandidates.countryresident#</td>
                <td class="style1" valign="top">#DateFormat(qGetCandidates.startdate, 'mm/dd/yyyy')#</td>
                <td class="style1" valign="top">#DateFormat(qGetCandidates.enddate, 'mm/dd/yyyy')#</td>				
            </tr>
        </cfloop>
    </table>

    <table width="98%" cellpadding="2" cellspacing="0">
        <tr>
            <td valign="top" class="style1">
                <div align="justify">
                    Please take a look at all the information above. 
                    If there's anything wrong or misspelled, please correct it ON THIS FORM and return it to us dated and signed.<br /><br /><br /><br />
                </div>
            </td>
        </tr>
        <tr>
            <td align="left" valign="top">
                <table>
                    <tr><td class="style1"><b>Our best regards,</b></td></tr>
                    <tr><td class="style1"><b>#companyshort.verification_letter#</b><br></td></tr>
                    <tr><td class="style1"><b>#APPLICATION.CSB[setSponsor].name#</b></td></tr>
                </table>
            </td>
            <td align="right">
                <table width="300" align="right" class="thin-border" frame="border" cellpadding="2" cellspacing="0">
                    <tr>
                        <td class="style1" colspan=2><h3>Return check:</h3></td>
                    </tr>
                        <tr><td>Date:</td>
                        <td> ____________________________</td>
                    </tr>
                    <tr>
                        <td><br></td>
                    </tr>
                    <tr>
                        <td>Signature:</td>
                        <td> ____________________________</td>
                    </tr>			
                </table>
            </td>
        </tr>
    </table>
    
</div>

</cfoutput>
            
			<!----
            </cfdocument>
			---->