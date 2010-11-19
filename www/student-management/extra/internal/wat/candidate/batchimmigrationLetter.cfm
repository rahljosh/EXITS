<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param FORM variables --->
	<cfparam name="FORM.selected_rep" default="All">
    <cfparam name="FORM.selected_program" default="0">
    <cfparam name="FORM.date" default="">

    <cfquery name="qGetCandidate" datasource="MySql">
        SELECT 
        	candidateid, 
            uniqueid, 
            firstname, 
            middlename, 
            lastname,
            ds2019
        FROM 
        	extra_candidates
        WHERE 
        	verification_received = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date#">
        
        AND 
        	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.selected_program#">
        
		<cfif VAL(FORM.selected_rep)>
        AND 
        	intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.selected_rep#">
        </cfif>
    </cfquery>

    <cfquery name="qGetProgram" datasource="MySql">
        SELECT 
            programID,
            programName,
            extra_sponsor
        FROM 
            smg_programs
        WHERE 
            programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.selected_program#">
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

<style type="text/css" media="print">
	.page-break {page-break-after: always}
	<!--
	.style1 {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 14;
	}
	
	.style2 {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 18;
	}
	
	p.breakhere { page-break-after: always }
	-->
</style>

<cfif NOT VAL(qGetCandidate.recordcount)>
	No records were found that match your criteria.<br />
	Please use your browsers back button to select different criteria and resubmit.
	<cfabort>
</cfif>

<cfoutput>

    <cfloop query="qGetCandidate">

        <!--- Header --->
        <table width="700px" border="0">
            <tr>
                <td class="style1">
                    <img src="../../../../#APPLICATION.CSB[setSponsor].logo#"> <br />
                </td>
                <td class="style2" width="100%" align="right">
                    #APPLICATION.CSB[setSponsor].name# <br />
                    119 Cooper Street <br />
                    Babylon, New York 11702 <br />
                    #APPLICATION.CSB[setSponsor].toolFreePhone#
                </td>
            </tr>
        </table>
        
        <span class="style1"> <br /> </span>
        
        <table width="700px" border="0">
            <tr>
                <td valign="top" class="style1">TO: </td>
                <td class="style1">
                    United States Embassy/Consulate <br />
                    Social Security Administration <br /> <br />
                </td>
            </tr>
            <tr>
                <td valign="top" class="style1">From: </td>
                <td class="style1">
                    Craig Brewer <br />
                    Executive Director <br />
                    Responsible Officer <br />
                    United States Department of State Designated Sponsor #APPLICATION.CSB[setSponsor].programNumber#
               </td>
            </tr>
        </table>
        
        <br /> <br /> <br />
       
        <table width="700px" border="0">
            <tr>
                <td>
                    <p class="style1"> 
                        To Whom it May Concern: <br /> <br /> 
                    </p>
                    
                    <p class="style1">
                        Please accept this letter as an official document attesting to the fact that 
                        <strong>#qGetCandidate.firstname# #qGetCandidate.middlename# #qGetCandidate.lastname#</strong> 
                        is a participant in the #APPLICATION.CSB[setSponsor].name# Summer Work Travel Program. <br />
                        Form DS-2019 number #qGetCandidate.ds2019# has been issued for the above mentioned participant. <br /> <br />
                        
                        #APPLICATION.CSB[setSponsor].name# is a sponsor of exchange visitors to the United States, participating in 
                        Exchange Visitor Program #APPLICATION.CSB[setSponsor].programNumber#, designated by the United States Department of State. 
                        Such participants have been admitted under Section 101 (A) (15) (J) of the Immigration and Nationality Act. 
                        Their J-1 visa status is evidenced by the DS-2019 Form and the J-1 visa in their passports. <br /> <br />
                        
                        According to the Immigration Reform and Control Act of 1986 (IRCA), the participants of this program are eligible for employment. 
                        The participants of this program are also entitled to receive compensation from employers for theirs efforts while they are on the 
                        program. For payroll purposes, the participants must obtain Social Security Numbers. <br /> <br />
                        
                        Each participant has been sponsored by #APPLICATION.CSB[setSponsor].name# as indicated on the DS-2019 Form. <br /> <br />
        
                        #APPLICATION.CSB[setSponsor].name# would like to thank you in advance for your cooperation. 
                        If you should have any questions or concerns, please feel free to contact us at #APPLICATION.CSB[setSponsor].toolFreePhone#. <br /> <br /> <br /> 
                    </p>
        
                    <p class="style1">
                        Kind Regards,  <br /> <br />            
                        <img src="http://www.student-management.com/extra/internal/uploadedfiles/craig_signature.gif">  <br /> 
                        Craig Brewer <br />
                        Executive Director/Responsible Officer
                    </p>
                </td>
            </tr>
        </table>            
        
        <div style="page-break-after:always"></div>
    
	</cfloop>

</cfoutput>
