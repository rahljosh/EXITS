<!--- ------------------------------------------------------------------------- ----
	
	File:		batchImmigrationLetter.cfm
	Author:		Marcus Melo
	Date:		January 10, 2011
	Desc:		Batch Immigration Letter

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.verification_received" default="">
    <cfparam name="FORM.submitted" default="0">

	<cfif FORM.submitted>

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
                verification_received = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.verification_received#">
            AND 
                programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
            <cfif VAL(FORM.intRep)>
            AND 
                intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intRep#">
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
                programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
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
    
    </cfif>

</cfsilent>

<cfoutput>

<!--- Batch Immigration Form --->
<cfif NOT FORM.submitted>

    <cfform action="candidate/batchImmigrationLetter.cfm" method="post" name="batch" target="_blank">
        <input type="hidden" name="submitted" value="1">
        <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
            <tr valign="middle" height="24">
                <td valign="middle" bgcolor="##E4E4E4"  class="style1" colspan="2">
                    <strong>
                        Select the Intl. Rep. and program you would like to generate batch immigration letters for.  
                        Candidates will only show up on this list once.  Once the report is ran, the candidate will be marked as letter printed and no longer show up on this list.  
                        To print additional copies, click on Immigration Letter on the candidates profile.
                    </strong>
                </td>
            </tr>
            <tr>
                <td class="style1" align="right"><strong>Program:</strong></td>
                <td class="style1" align="left">
                    <cfselect
                        name="programID" 
                        id="programID"
                        class="style1"
                        value="programID"
                        display="programName"
                        selected="#FORM.programID#"
                        bind="cfc:extra.extensions.components.program.getProgramsRemote()" 
                        bindonload="true" /> 
                </td>
            </tr>
            <tr>
                <td class="style1" align="right"><strong>Intl. Rep.:</strong></td>
                <td class="style1" align="left">
                    <cfselect
                        name="intRep" 
                        id="intRep"
                        class="style1"
                        value="userID"
                        display="businessName"
                        selected="#FORM.intRep#"
                        bind="cfc:extra.extensions.components.user.getIntlRepRemote({programID})" /> 
                </td>
            </tr>
            <tr>
                <td class="style1" align="right"><strong>Verification Received:</strong></td>
                <td class="style1" align="left">
                    <cfselect 
                        name="verification_received" 
                        id="verification_received"
                        class="style1"
                        value="verificationReceived"
                        display="verificationReceived"
                        selected="#FORM.verification_received#"
                        bind="cfc:extra.extensions.components.user.getVerificationDate({intRep},{programID})" /> 
                </td>
            </tr>
            <tr>
                <td colspan=2 align="center"><input type="submit" value="Generate Report"  class="style1" /></td>
            </tr>
        </table>
    </cfform>

<!--- Batch Immigration Letter --->
<cfelse>

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

</cfif>

</cfoutput>