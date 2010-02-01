<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM Variable --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionID" default="">

	<cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
	
		// Get Regions
		qGetRegions = APPCFC.REGION.getUserRegions(companyID=CLIENT.companyID, userType=CLIENT.userType);
	
    	// FORM Submitted
		if (FORM.submitted) {
            
			// Data Validation
            
            // RegionID
            if ( NOT LEN(FORM.regionID) ) {
                ArrayAppend(Errors.Messages, "Please select at least one region.");			
            }
    	
		}    
    </cfscript>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EXITS - WebEx Report By Region</title>
</head>

<body>

<!--- FORM Submitted and there are no errors --->
<cfif FORM.submitted AND NOT VAL(ArrayLen(Errors.Messages))>

	<cfscript>
		// Get Regions
		qGetRegions = APPCFC.REGION.getRegionsByList(regionIDList=FORM.regionID, companyID=CLIENT.companyID);
	</cfscript>

    <table width="100%" cellpadding="6" cellspacing="0" align="center" frame="box">	
        <tr>
        	<th>WebEx Training Report</th>
        </tr>
        <tr>
        	<td><strong>Region</strong></td>
        </tr>
    </table>

	<br />
    
    <cfloop query="qGetRegions">

        <cfscript>
            // Get Results
            qGetResults = APPCFC.USER.reportTrainingByRegion(regionID=qGetRegions.regionID);
        </cfscript>

        <table width="100%" cellpadding="6" cellspacing="0" align="center" frame="box">		
            <tr>
            	<td><cfoutput><strong>#qGetRegions.regionname#</strong></td></cfoutput>
            </tr>
        </table>
    
        <table width="100%" cellpadding="6" cellspacing="0" align="center" frame="box">	
            <tr>
                <td width="40%" valign="top"><strong>Representative</strong></td>
                <td width="60%" valign="top"><strong>WebEx Training Dates</strong></td>
            </tr>
        </table>

        <cfoutput query="qGetResults" group="userID">

			<table width="100%" cellpadding="6" cellspacing="0" align="center" frame="box">	
				<tr>
                	<td width="40%" valign="top">
						#qGetResults.firstName# #qGetResults.lastName# (###qGetResults.userID#)
					</td>
					<td width="60%" valign="top"> 
                    <cfoutput>                        
                        <cfif LEN(qGetResults.date_trained)>
	                        #DateFormat(qGetResults.date_trained, 'mm/dd/yyyy')# - #qGetResults.notes# <br />
                        <cfelse>
                        	n/a    
                        </cfif>    
                    </cfoutput>
                    </td>
				</tr>
			</table>

        </cfoutput>           
		
        <br />
        
    </cfloop>
    
<cfelse>

<cfoutput>

    <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
        <tr valign="middle" height="24">
            <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
            <td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
            <td background="pics/header_background.gif"><h2>WebEx Reports</h2></td>
            <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>
    
    <table border="0" cellpadding="8" cellspacing="2" width="100%" class="section">
        <tr>
            <td>
    
                <!--- Display Errors --->
                <cfif VAL(ArrayLen(Errors.Messages))>
                    <table width="95%" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <font color="##FF0000">Please review the following items:</font> <br>
                
                                <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                                    #Errors.Messages[i]# <br>        	
                                </cfloop>
                            </td>
                        </tr>
                    </table> <br />                      
                </cfif>	
    
                <table cellpadding="4" cellspacing="0" align="center" width="96%">
                    <tr>
                        <td width="50%" valign="top">
                            <form action="index.cfm?curdoc=reports/webex_reports" method="post">
                                <input type="hidden" name="submitted" value="1" />
                                <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                    <tr><th colspan="2" bgcolor="e2efc7">WebEx Training by Region</th></tr>
                                    <tr align="left">
                                        <td>Region: </td>
                                        <td>
                                            <select name="regionID" multiple="multiple" size="6">
                                                <option value="0">All</option>
                                                <cfloop query="qGetRegions">
                                                    <option value="#regionID#">#regionName#</option>
                                                </cfloop>
                                            </select>
                                        </td>		
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                    </tr>
                                </table>
                            </form>
                        </td>
                        <td width="50%" valign="top">&nbsp;
                            
                        </td>		
                    </tr>
                </table>
        
            </td>
        </tr>
    </table>
    
    <cfinclude template="../table_footer.cfm">

</cfoutput>

</cfif>

</body>
</html>