<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param FORM variables --->
	<cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.print" default="">
	<cfparam name="FORM.program" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.email_intrep" default="0">
    <cfparam name="FORM.email_self" default="0">

	<cfinclude template="../querys/get_company_short.cfm">

    <cfquery name="qGetIntRepList" datasource="MySql">
        SELECT 
            userid, 
            businessname
        FROM 
            smg_users
        WHERE 
            usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">            
        ORDER BY 
            businessname
    </cfquery>

    <cfquery name="qGetProgramList" datasource="MySql">
        SELECT 
        	programname, 
            programid
        FROM 
        	smg_programs 
        WHERE 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
    </cfquery>

</cfsilent>    
    
<script language="JavaScript" type="text/javascript"> 
	<!-- Begin
	function formHandler2(form){
	var URL = document.formagent.agent.options[document.formagent.agent.selectedIndex].value;
	window.location.href = URL;
	}
	// End -->
</script>

<style type="text/css">
	<!--
	.thin-border-bottom { 
		border-bottom: 1px solid #000000; }
		.thin-border-top { 
		border-top: 1px solid #000000; }
	.thin-border{ border: 1px solid #000000;}
	-->
</style>

<cfoutput>

<form action="reports/ds2019_verification_wt_screen.cfm" method="post">
	<input type="hidden" name="submitted" value="1" />

    <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
        <tr valign="middle" height="24">
            <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
            	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;DS 2019 Verification Report</font>
            </td>
        </tr>
        <tr valign="middle" height="24">
			<td valign="middle" colspan=2>&nbsp;</td>
        </tr>
        <tr valign="middle">
            <td align="right" valign="middle" class="style1"><b>International Rep:</b> </td>
		    <td valign="middle">  
                <select name="intrep" class="style1">
                    <option value="0"></option>
                    <cfloop query="qGetIntRepList">
                    <option value="#userid#" <cfif IsDefined('FORM.intrep')><cfif qGetIntRepList.userid eq #FORM.intrep#> selected</cfif></cfif>> #qGetIntRepList.businessname# </option>
                    </cfloop>
                </select>
    
            </td>
	    </tr>
    	<tr>
            <td valign="middle" align="right" class="style1"><b>Program: </b></td><td> 
                <select name="program" class="style1">
                    <option value="0"></option>
                    <cfloop query="qGetProgramList">
                    <option value=#programid# <cfif IsDefined('FORM.program')><cfif qGetProgramList.programid eq #FORM.program#> selected</cfif></cfif>>#programname#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" class="style1"><b>Email Options:</b></td>
            <td class="style1">
            	<input type="checkbox" name="email_intrep" value="1" />Send email to Intl. Rep. (if on file)<BR />
                <input type="checkbox" name="email_self" value="1" />I would like to receive a copy of the email. (#CLIENT.email#)
			</td>
        </tr>
        <Tr>
            <td align="right" class="style1"><b>Format:</b></td>
            <td class="style1"> 
            	<input type="radio" name="print" value="0" checked="checked"> Onscreen (View Only) 
                <input type="radio" name="print" value="1"> Print (FlashPaper) 
                <input type="radio" name="print" value="2"> Print (PDF)
			</td>                
        </Tr>
        <tr>
            <td colspan=2 align="center"><br />
    	    	<input type="submit" value="Generate Report" class="style1" />
        	</td>
       </tr>
    </table>

</form>

</cfoutput>