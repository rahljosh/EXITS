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
            low_wage
        FROM 
        	extra_jobs
        WHERE
        	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
		AND
        	hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">           
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

            if ( LEN(FORM.low_wage) AND NOT IsNumeric(FORM.low_wage) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Low Wage must be a numeric value');
            }			
			
            if ( NOT LEN(FORM.wage_type) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Wage Type is required');
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
                        low_wage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.low_wage)#">,
                        wage_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wage_type#">,
                        hours = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hours#">, 
                        sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,       
                        avail_position = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.avail_position#">
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
                        low_wage,
                        wage_type,
                        hours, 
                        sex,       
                        avail_position
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.title#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.description#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.wage)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.low_wage)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wage_type#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hours#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,       
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.avail_position#">
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
			FORM.low_wage = qGetJobInfo.low_wage;
			FORM.wage_type = qGetJobInfo.wage_type;
			FORM.hours = qGetJobInfo.hours;
			FORM.sex = qGetJobInfo.sex;
			FORM.avail_position = qGetJobInfo.avail_position;
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
                    	<td class="style1" width="15%" align="right"><strong>Hours:&nbsp;</strong></td>
                        <td class="style1"><input type="text" name="hours" value="#FORM.hours#" class="style1" size="35" maxlength="100" tabindex="6"></td>
                    </tr>
                    <tr>
                    	<td class="style1" align="right"><strong>Gender:&nbsp;</strong></td>
                        <td class="style1">
                            <input type="radio" name="sex" id="genderEither" value="0" <cfif NOT VAL(FORM.sex)> checked="checked" </cfif> tabindex="2" /><label for="genderEither">Either</label>
                            <input type="radio" name="sex" id="genderMale" value="1" <cfif FORM.sex EQ 1> checked="checked" </cfif> /><label for="genderMale">Male</label>
                            <input type="radio" name="sex" id="genderFemale" value="2" <cfif FORM.sex EQ 2> checked="checked" </cfif> /><label for="genderFemale">Female</label>
                        </td>
                    	<td class="style1" align="right"><strong>Available Positions:&nbsp;</strong></td>
                        <td class="style1">
                        	<select name="avail_position" id="avail_position" class="style1" tabindex="7">
                                <cfloop from="0" to="20" index="i">
                                	<option value="#i#" <cfif FORM.avail_position EQ i> selected="selected" </cfif> >#i#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr>
                    	<td class="style1" align="right"><strong>Low Wage:&nbsp;</strong></td>
                        <td class="style1"><input type="text" name="low_wage" value="#FORM.low_wage#" class="style1" size="35" maxlength="100" tabindex="3"></td>
                        <td class="style1" align="right"><strong>Description:&nbsp;</strong></td>
                        <td class="style1" rowspan="4" valign="top"><textarea name="description" class="style1" cols="40" rows="6" tabindex="8">#FORM.description#</textarea></td>
                    </tr>
                    <tr>
                    	<td class="style1" align="right"><strong>Wage:&nbsp;</strong></td>
                        <td class="style1"><input type="text" name="wage" value="#FORM.wage#" class="style1" size="35" maxlength="100" tabindex="4"></td>
                    </tr>
                    <tr>
                    	<td class="style1" align="right"><strong>Wage Type:&nbsp;</strong></td>
                        <td class="style1">
                        	<select name="wage_type" id="wage_type" class="style1" tabindex="5">
                                <option value="" <cfif NOT LEN(FORM.wage_type)> selected="selected" </cfif> ></option>
                                <cfloop list="#listWageTypes#" index="type">
                                	<option value="#type#" <cfif FORM.wage_type EQ type> selected="selected" </cfif> >#type#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
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