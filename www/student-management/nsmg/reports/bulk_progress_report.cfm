<!--- ------------------------------------------------------------------------- ----
	
	File:		bulk_progress_report.cfm
	Author:		Marcus Melo
	Date:		December 1, 2009
	Desc:		This page allows the user to print multiple progress reports based on
				ny approval date.

	Status:		In Development
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output ---->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
    <!--- Param Form Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionID" default="">
    <cfparam name="FORM.dateFrom" default="">
    <cfparam name="FORM.dateTo" default="#now()#">
    <cfparam name="FORM.displayReport" default="0">

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />
    
    <cfscript>
		// Get Regions
		qGetRegions = APPCFC.region.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=CLIENT.usertype);
		
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);

		// Check if FORM has been submitted
		if ( VAL(FORM.submitted) ) {

			if (NOT IsDate(FORM.dateFrom)) {
				ArrayAppend(Errors.Messages, "Please enter a valid from date (mm/dd/yyyy).");
				FORM.dateFrom = '';
			}		
			
			if (NOT IsDate(FORM.dateTo)) {
				ArrayAppend(Errors.Messages, "Please enter a valid to date (mm/dd/yyyy)");
				FORM.dateTo = '';
			}		

			// There are no errors
			if ( NOT VAL(ArrayLen(Errors.Messages)) ) {
				// Display Reports
				FORM.displayReport = 1;
			}
		}
	</cfscript>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Progress Reports</title>

<cfif VAL(FORM.displayReport)>
	<!--- Get stylesheets for the report ---->
    <link rel="stylesheet" href="../smg.css" type="text/css">
</cfif>

</head>

<body>

<cfoutput>

<cfif VAL(ArrayLen(Errors.Messages))>
	
	<!--- Display Errors --->
    <table border="0" cellpadding="0" cellspacing="10" width="50%">    			
        <tr>
        	<td><strong>Bulk Progress Reports</strong></td>
        </tr>
        <tr>
            <td>
                <font color="##FF0000">Please review the following item(s):</font> <br>
                <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                    #Errors.Messages[i]# <br>        	
                </cfloop>
                <br />
            </td>
        </tr>                                          
    </table>

<cfelseif VAL(FORM.displayReport)>
	<!--- Display Reports --->
    
	<!--- Call Progress Report CustomTag and pass the form variables --->
    <gui:progressReport
        regionID="#FORM.regionID#"
        dateFrom="#FORM.dateFrom#"
        dateTo="#FORM.dateTo#"
        />
    
<cfelse>
	<!--- DISPLAY FORM --->
    <table width="50%" cellpadding="0" cellspacing="0" border="0" height="24">
        <tr valign="middle" height="24">
            <td height="24" width=13 background="pics/header_leftcap.gif">&nbsp;</td>
            <td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
            <td background="pics/header_background.gif"><h2>Bulk Progress Reports</h2></td>
            <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>
    
    <!--- Progress Reports --->
    <!--- #cgi.SCRIPT_NAME#?#cgi.QUERY_STRING# --->
    <form action="reports/bulk_progress_report.cfm" method="POST" target="_blank">
    <input type="hidden" name="submitted" value="1" />

    <table border="0" cellpadding="0" cellspacing="10" width="50%" class="section">
        <tr>
            <td valign="top">Region : </td>
            <td align="left">
                <select name="regionID" multiple="multiple" size="6">
                    <cfloop query="qGetRegions">
                        <option value="#regionID#">
                            #regionname# &nbsp; 
                        </option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td colspan="2"><u>NY Approval Date</u></td>
        </tr>
        <tr>
            <td>From : </td>
            <td> 
                <input type="text" name="dateFrom" value="#DateFormat(FORM.dateFrom, 'mm/dd/yyyy')#" class="datePicker" maxlength="10"> &nbsp; mm/dd/yyyy
            </td>
        </tr>
        <tr>
            <td>To : </td>
            <td>
                <input type="text" name="dateTo" value="#DateFormat(FORM.dateTo, 'mm/dd/yyyy')#" class="datePicker" maxlength="10"> &nbsp; mm/dd/yyyy
            </td>
        </tr>
        <tr><td colspan="2" align="center"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
    </table>

    </form>
    
    <!--- Table Footer --->
    <table width="50%" cellpadding="0" cellspacing="0" border="0">
        <tr valign="bottom">
            <td width="9" valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
            <td width="100%" background="pics/header_background_footer.gif"></td>
            <td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
    </table>    

</cfif>

</cfoutput>

</body>
</html>
