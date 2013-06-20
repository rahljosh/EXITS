<cfparam name="URL.hostID" default="0">
<cfparam name="FORM.isNotQualified" default="1">
<cfparam name="FORM.explanation" default="">
<cfparam name="FORM.submitted" default="">

<cfscript>
	qGetHostEligibilityReason = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
		applicationID=7,
		foreignTable='smg_hosts',
		foreignID=URL.hostID
	);
	
	errorMsg = "";
</cfscript>

<cfquery name="qGetHostEligibility" datasource="#APPLICATION.DSN#">
	SELECT
    	isNotQualifiedToHost
   	FROM
    	smg_hosts
   	WHERE
    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
</cfquery>

<!--- Process Form Submission --->
<cfif LEN(FORM.submitted)>
	
    <cfscript>
		if (FORM.isNotQualified EQ 'on') {
			isNotQualifiedNum = 1;
		} else {
			isNotQualifiedNum = 0;
		}
	</cfscript>

	<cfif isNotQualifiedNum EQ 1 AND NOT LEN(FORM.explanation)>
    
    	<cfset errorMsg = "You must enter an explanation if the host family is not qualified">
        
  	<cfelse>
    
    	<cfquery datasource="#APPLICATION.DSN#">
            UPDATE
                smg_hosts
            SET
                isNotQualifiedToHost = <cfqueryparam cfsqltype="cf_sql_integer" value="#isNotQualifiedNum#">
                <cfif isNotQualifiedNum EQ 1>
                	,active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfif>
           	WHERE
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
        </cfquery>
        
        <cfif isNotQualifiedNum EQ 1>
            
			<cfscript>
                APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
                    applicationID=7,
                    foreignTable='smg_hosts',
                    foreignID=URL.hostID,
                    enteredByID=CLIENT.userID,
                    comments=FORM.explanation,
                    dateCreated=NOW()
                );
            </cfscript>
            
      	</cfif>
        
        <cflocation url="index.cfm?curdoc=host_fam_info&hostid=#URL.hostid#" addtoken="No">
        
    </cfif>

</cfif>

<cfif errorMsg NEQ ''>
	<script type="text/javascript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

<script type="text/javascript">
	$(document).ready(function() {
		displayExplanation('<cfoutput>#qGetHostEligibilityReason.comments#</cfoutput>');			 
	});

	var displayExplanation = function(comments) {
		if ($("#isNotQualified").is(':checked')) {
			$("#explanationRow").html("<td>Explanation:</td><td><textarea name='explanation' id='explanation' value='' /></td>");
			$("#explanation").val(comments);
		} else {
			$("#explanationRow").html("");
		}
	}
</script>

<!--- this table is so the form is not 100% width. --->
<table align="center">
	<tr>
    	<td>
    
    		<!--- header of the table --->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
                    <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Host Eligibility</h2></td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
            
            <cfform action="?curdoc=forms/host_fam_eligibility_form&hostID=#URL.hostID#" method="post">
				<input type="hidden" name="submitted" value="1" />
                
                <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
                	<tr>
                        <td width="20%" align="right">
                            <input type="checkbox" name="isNotQualified" id="isNotQualified" onclick="displayExplanation('<cfoutput>#qGetHostEligibilityReason.comments#</cfoutput>');"
								<cfif qGetHostEligibility.isNotQualifiedToHost EQ 1>
                                	checked="checked"
                                    disabled="disabled"
								</cfif> />
                        </td>
                        <td width="80%" style=" vertical-align:middle;">
                            Not Qualified
                        </td>
                    </tr>
                    <tr id="explanationRow">
                  	</tr>
                </table>
                
                <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
                    <tr>
                        <td align="center"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
                    </tr>
                </table>

         	</cfform>
            
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign=bottom >
                    <td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
                    <td width=100% background="pics/header_background_footer.gif"></td>
                    <td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
                </tr>
            </table>
    
    	</td>
  	</tr>
</table>
