<!--- ------------------------------------------------------------------------- ----
	
	File:		select_batch.cfm
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

</cfsilent>

<cfoutput>

<cfform action="candidate/batchimmigrationLetter.cfm" method="post" name="batch">
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
                    bind="cfc:extra.extensions.components.user.getVerificationDate({intRep})" /> 
            </td>
        </tr>
        <tr>
	        <td colspan=2 align="center"><input type="submit" value="Generate Report"  class="style1" /></td>
        </tr>
	</table>
</cfform>

</cfoutput>

