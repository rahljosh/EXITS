<!--- ------------------------------------------------------------------------- ----
	
	File:		hostCompanyInfo.cfm
	Author:		Marcus Melo
	Date:		December 07, 2010
	Desc:		Host Family Information

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param Variables --->
    <cfparam name="ID" default="0"> 
    <cfparam name="hostCompanyID" default="0"> 
    
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0"> 
    <cfparam name="FORM.title" default=""> 
    <cfparam name="FORM.description" default="">    
    <cfparam name="FORM.wage" default="">    
    <cfparam name="FORM.wage_type" default="">    
    <cfparam name="FORM.low_wage" default="">    
    <cfparam name="FORM.hours" default="">    
    <cfparam name="FORM.sex" default="0">    
    <cfparam name="FORM.avail_position" default="">    
	
    <cfscript>
		listWageTypes = "Hourly,Salary,Shift,Weekly";
	</cfscript>		

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
        	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
		AND
        	hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">           
    </cfquery>     
	
    <cfquery name="qSEVISJobClassification" datasource="MySql">
    select *
    from extra_sevis_sub_fieldstudy
    order by subfieldid 
    </cfquery>
    <cfif FORM.submitted>

        <!--- Data Validation --->
		<cfscript>		
            if ( NOT LEN(FORM.title) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Title is required');
            }
			
            if ( LEN(FORM.wage) AND NOT IsNumeric(FORM.wage) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Wage must be a numeric value');
            }	
		</cfscript>

        <!--- // Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>

			<!--- Update Job --->
            <cfif qGetJobInfo.recordCount>    
    
                <cfquery datasource="MySql">
                    UPDATE 
                        extra_jobs 
                    SET 
                        title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.title#">,
                        description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.description#">,
                        wage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.wage)#">,
                        hours = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hours#">, 
                        sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,
                        classification = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SEVISclassification#">
                            
                    WHERE 
                        extra_jobs.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
                </cfquery>    

				<cfscript>
                    // Set Page Message
                    SESSION.pageMessages.Add("Job successfully updated.");
                </cfscript>
    
            <cfelse>
            
                <cfquery datasource="MySql">
                    INSERT INTO 
                        extra_jobs 
                    (
                        hostCompanyID,
                        title,
                        description,
                        wage,
                        hours, 
                        sex,
                        classification
                         
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.title#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.description#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.wage)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hours#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SEVISclassification#">    
                    )
                </cfquery>    

				<cfscript>
                    // Set Page Message
                    SESSION.pageMessages.Add("Job successfully added.");
                </cfscript>
    
            </cfif>
        
        </cfif>
        
    <cfelse>
    
 		<cfscript>
			// Set FORM Values
			FORM.title = qGetJobInfo.title;
			FORM.description = qGetJobInfo.description;
			FORM.wage = qGetJobInfo.wage;
			FORM.hours = qGetJobInfo.hours;
			FORM.sex = qGetJobInfo.sex;
			FORM.SEVISclassification = qGetJobInfo.classification;
		</cfscript>
    
    </cfif>
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta name="Author" content="CSB">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>EXTRA - Exchange Training Abroad - Host Company Jobs</title>
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
    <input type="hidden" name="ID" value="#ID#" />
	<input type="hidden" name="hostCompanyID" value="#hostCompanyID#" />

    <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
        <tr>
            <td bordercolor="##FFFFFF">
    
                <table width="100%" cellpadding="3" cellspacing="3" border="0">
                    <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                        <td colspan="4" class="style2" bgcolor="##8FB6C9">
                        	&nbsp;:: 
                            <cfif qGetJobInfo.recordCount> 
                            	Edit Job
                            <cfelse>
                            	Add New Job
                            </cfif>
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
    
                <table width="100%" cellpadding="3" cellspacing="3" border="0">
                    <tr>
                        <td class="style1" width="15%" align="right"><strong>Job Title:&nbsp;</strong></td>
                        <td class="style1"><input type="text" name="title" value="#FORM.title#" class="style1" size="35" maxlength="100" tabindex="1"></td>
                    	
                        <td class="style1" align="right"><strong>Gender:&nbsp;</strong></td>
                        <td class="style1">
                            <input type="radio" name="sex" id="genderEither" value="0" <cfif NOT VAL(FORM.sex)> checked="checked" </cfif> tabindex="2" /><label for="genderEither">Either</label>
                            <input type="radio" name="sex" id="genderMale" value="1" <cfif FORM.sex EQ 1> checked="checked" </cfif> /><label for="genderMale">Male</label>
                            <input type="radio" name="sex" id="genderFemale" value="2" <cfif FORM.sex EQ 2> checked="checked" </cfif> /><label for="genderFemale">Female</label>
                        </td>
                    </tr>
                   
                    <tr>
                    	<td class="style1" align="right"><strong>Wage/Hour:&nbsp;</strong></td>
                        <td class="style1"><input type="text" name="wage" value="#FORM.wage#" class="style1" size="35" maxlength="100" tabindex="4"></td>
                        <td class="style1" align="right"><strong>Description:&nbsp;</strong></td>
                        <td class="style1" rowspan="4" valign="top"><textarea name="description" class="style1" cols="40" rows="6" tabindex="8">#FORM.description#</textarea></td>
                    </tr>
                    <tr>
                        <td class="style1" width="15%" align="right"><strong>Hours/Week:&nbsp;</strong></td>
                        <td class="style1"><input type="text" name="hours" value="#FORM.hours#" class="style1" size="35" maxlength="100" tabindex="6"></td>
                    </tr>
                    </table>
                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                     <Tr>
                    <td class="style1" width="15%" align="right"><strong>SEVIS Classification:</strong> </td>
                   <td class="style1" colspan=5>
                        <select name="SEVISclassification">
                        <option value=""></option>
                        <cfloop query="qSEVISJobClassification">
                        <option value="#code#" <cfif FORM.SEVISclassification eq #code#>selected</cfif>>#code# - #subfield#</option>
                        </cfloop>
                        </td>
                    </Tr>
                </table>
				
                <!--- Add/Edit Buttons --->
                <table width="100%" cellpadding="3" cellspacing="3" border="0">
                    <tr>
                        <td align="center">
                            <cfif qGetJobInfo.recordCount> 
                                <input name="submit" type="image" src="../../pics/save.gif" alt="Edit Job" border="0">
                            <cfelse>
                                <input name="submit" type="image" src="../../pics/add-job.gif" alt="Add Job" border="0">
                            </cfif>                                    
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
