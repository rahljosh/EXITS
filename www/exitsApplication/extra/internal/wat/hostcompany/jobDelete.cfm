<!--- ------------------------------------------------------------------------- ----
	
	File:		jobDelete.cfm
	Author:		Bruno Lopes
	Date:		March 21, 2017
	Desc:		

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param Variables --->
    <cfparam name="jobID" default="0"> 
    
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0"> 
    <cfparam name="FORM.jobID" default="">    

    <cfquery name="qGetJobInfo" datasource="MySql">
        SELECT 
        	ID, 
            title, 
            description, 
            wage, 
            wage_type, 
            hours,
            avail_position, 
            sex, 
            low_wage,
            classification
        FROM 
        	extra_jobs
        WHERE
        	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#jobID#">
    </cfquery>     
	
    <cfif FORM.submitted>
		<!--- Update Job --->
        <cfquery datasource="MySql">
            DELETE FROM
                extra_jobs
            WHERE 
                extra_jobs.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#jobID#">
        </cfquery>    

		<cfscript>
            // Set Page Message
            SESSION.pageMessages.Add("Job removed successfully.");
        </cfscript>
    </cfif>

    <cfscript>
        // Set FORM Values
        FORM.title = qGetJobInfo.title;
        FORM.description = qGetJobInfo.description;
        FORM.wage = qGetJobInfo.wage;
        FORM.hours = qGetJobInfo.hours;
        FORM.sex = qGetJobInfo.sex;
        FORM.SEVISclassification = qGetJobInfo.classification;
    </cfscript>
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta name="Author" content="CSB">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>EXTRA - Exchange Training Abroad - Host Company Jobs Delete</title>
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="../../style.css" type="text/css">
    <link rel="stylesheet" href="../../linked/css/onlineApplication.css" type="text/css">
    <link rel="stylesheet" href="../../linked/css/baseStyle.css" type="text/css">
    <!-- Combine these into one single file -->
    <cfoutput>
    <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
    <script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script> <!-- jQuery -->
    <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
    </cfoutput>
	<style type="text/css">
    <!--
        body {
			margin:0px;
        }
    -->
    </style>
</head>
<body>

<!--- Reload Opener / Close PopUp --->
<cfif FORM.submitted AND NOT SESSION.formErrors.length()>
	<script type="text/JavaScript">
        $(document).ready(function() {
            // Reload Opener
            opener.location.reload();
            // Close Pop UP
            setTimeout(window.close, 2000);
        });	
    //-->
    </script>
</cfif>    

<cfoutput>

<form name="form" action="#CGI.SCRIPT_NAME#" method="post">
	<input type="hidden" name="submitted" value="1" />
    <input type="hidden" name="jobID" value="#jobID#" />

    <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
        <tr>
            <td bordercolor="##FFFFFF">
    
                <table width="100%" cellpadding="3" cellspacing="3" border="0">
                    <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                        <td colspan="4" class="style2" bgcolor="##8FB6C9">
                        	&nbsp;:: 
                            Delete Job
                        </td>
                    </tr>
				</table>    
    
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td valign="top">

                            <!--- Page Messages --->
                            <gui:displayPageMessages 
                                pageMessages="#SESSION.pageMessages.GetCollection()#"
                                messageType="section"
                                />
                            
                            <!--- Form Errors --->
                            <gui:displayFormErrors 
                                formErrors="#SESSION.formErrors.GetCollection()#"
                                messageType="section"
                                />
                                
                        </td>
                    </tr>
                </table>

                Confirm Job Delete?
    
                <table width="100%" cellpadding="3" cellspacing="3" border="0">
                    <tr>
                        <td class="style1" width="15%" align="right"><strong>Job Title:&nbsp;</strong></td>
                        <td class="style1">#FORM.title#</td>
                    	
                        <td class="style1" align="right"><strong>Gender:&nbsp;</strong></td>
                        <td class="style1">
                            <cfif NOT VAL(FORM.sex)>Either</cfif>
                            <cfif FORM.sex EQ 1>Male</cfif>
                            <cfif FORM.sex EQ 2>Female</cfif>
                        </td>
                    </tr>
                   
                    <tr>
                    	<td class="style1" align="right"><strong>Wage/Hour:&nbsp;</strong></td>
                        <td class="style1">#FORM.wage#</td>
                        <td class="style1" align="right"><strong>Description:&nbsp;</strong></td>
                        <td class="style1" rowspan="4" valign="top">#FORM.description#</td>
                    </tr>
                    <tr>
                        <td class="style1" width="15%" align="right"><strong>Hours/Week:&nbsp;</strong></td>
                        <td class="style1">#FORM.hours#</td>
                    </tr>
                    </table>
				
                <!--- Add/Edit Buttons --->
                <table width="100%" cellpadding="3" cellspacing="3" border="0">
                    <tr>
                        <td align="center">
                                <input name="submit" type="image" src="../../pics/delete.gif" alt="Edit Job" border="0">
                                 
                        </td>
                    </tr>
                </table>

            </td>
        </tr>
    </table> 
</form>

</cfoutput>

</body>
</html>