<!--- ------------------------------------------------------------------------- ----
	
	File:		batchSupportLetter.cfm.cfm
	Author:		Marcus Melo
	Date:		January 10, 2011
	Desc:		Batch Immigration Letter

	Updated: 	07/22/2011 - Including supportLetter.cfm so we don't have to 
				update two files.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.verification_received" default="">
    <cfparam name="FORM.submitted" default="0">

	<cfif FORM.submitted>

        <cfquery name="qGetResults" datasource="MySql">
            SELECT 
                candidateid, 
                uniqueid 
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
    
    </cfif>

</cfsilent>

<cfoutput>

<!--- Batch Immigration Form --->
<cfif NOT FORM.submitted>

    <cfform action="candidate/batchSupportLetter.cfm" method="post" name="batch" target="_blank">
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
    
    <cfif NOT VAL(qGetResults.recordcount)>
        No records were found that match your criteria.<br />
        Please use your browsers back button to select different criteria and resubmit.
        <cfabort>
    </cfif>
	
    <cfloop query="qGetResults">
    	
        <cfscript>
			// SET FORM VARIABLE THAT IS USED ON supportLetter.cfm
			FORM.uniqueID = qGetResults.uniqueID;
		</cfscript>

        <!--- Include Letter --->
        <cfinclude template="supportLetter.cfm">
        
        <!--- Add Page Break --->
        <cfif qGetResults.currentRow NEQ qGetResults.recordCount>
	        <div style="page-break-after:always"></div>
    	</cfif>
        
	</cfloop>

</cfif>

</cfoutput>