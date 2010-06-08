<!--- ------------------------------------------------------------------------- ----
	
	File:		insurance_menu.cfm
	Author:		Marcus Melo
	Date:		January 06, 2010
	Desc:		Manages Insurance Information

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param URL Variables --->
	<cfparam name="URL.history" default="no">
    
    <cfquery name="qGetInsurancePolicies" datasource="caseUSA">
        SELECT 
            insuTypeID,
            type,
            provider,
            ayp5,
            ayp10,
            ayp12,
            active 
        FROM 
            smg_insurance_type 
        WHERE
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            provider = <cfqueryparam cfsqltype="cf_sql_varchar" value="global">
    </cfquery>

    <cfquery 
        name="qGetPrograms" 
        datasource="caseUSA">
            SELECT
                p.programID,
                p.programName,
                p.type,
                p.startDate,
                p.endDate,
                p.insurance_startDate,
                p.insurance_endDate,
                p.sevis_startDate,
                p.sevis_endDate,
                p.preAyp_date,
                p.companyID,
                p.programFee,
                p.application_fee,
                p.insurance_w_deduct,
                p.insurance_wo_deduct,
                p.blank,
                p.hold,
                p.progress_reports_active,
                p.seasonID,
                p.smgSeasonID,
                p.tripID,
                p.active,
                p.fieldViewable,
                p.insurance_batch,
                c.companyName,
                c.companyShort
            FROM 
                smg_programs p
            LEFT OUTER JOIN
                smg_companies c ON c.companyID = p.companyID                    
            WHERE
                p.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            AND
                p.endDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            ORDER BY 
               p.startDate DESC,
               p.programName
    </cfquery>

</cfsilent>

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<script type="text/javascript" language="javascript">
	//Confirm Update
	function areYouSure() { 
	   if(confirm("You're about to update the records, this can not be undone, are you sure?")) { 
		 form.submit(); 
			return true; 
	   } else { 
			return false; 
	   } 
	} 
</script>		

<cfoutput>

<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
    <tr valign="middle" height="24">
        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
        <td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>Insurance - Excel files and Reports</h2></td>
        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<table border="0" cellpadding="8" cellspacing="2" width="100%" class="section">
	<tr>
    	<td>
        
            <!--- EARLY RETURN HEADER --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Early Return</th></tr>
                <tr><td colspan="2" align="center"><font size="-2">According to Flight Departure Info</font></td></tr>
            </table>
            
            <table cellpadding="6" cellspacing="0" align="center" width="96%">
                <tr>
                    <td width="50%" valign="top">
                        <form action="insurance/early_return.cfm" method="POST">
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Early Return</th></tr>
                                <tr align="left">
                                    <td>Program :</td>
                                    <td>
                                    	<select name="programID" size="6" multiple>
                                            <cfloop query="qGetPrograms"><option value="#ProgramID#">#programname#</option></cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr align="left">
                                    <td>Policy Type :</td>
                                    <td>
                                        <select name="policyID">
                                            <option value="0"></option>
                                            <cfloop query="qGetInsurancePolicies">
                                                <option value="#insuTypeID#">#qGetInsurancePolicies.type#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                            </table>
                        </form>
                    </td>
                    <td width="50%" valign="top">&nbsp;
                        
                    </td>
                </tr>
            </table>
            
            <br><br>
            
		</td>
    </tr>
</table>

</cfoutput>
<cfinclude template="../table_footer.cfm">