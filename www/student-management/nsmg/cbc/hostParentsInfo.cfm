<!--- ------------------------------------------------------------------------- ----
	
	File:		hostParentsInfo.cfm
	Author:		Marcus Melo
	Date:		July 7, 2011
	Desc:		Host Family Required Fields for CBC
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="">

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.hostID" default="0">    
    <cfparam name="FORM.fatherLastName" default="">
    <cfparam name="FORM.fatherFirstName" default="">
    <cfparam name="FORM.fatherMiddleName" default="">
    <cfparam name="FORM.fatherDOB" default="">
    <cfparam name="FORM.fatherSSN" default="">
    <cfparam name="FORM.motherFirstName" default="">
    <cfparam name="FORM.motherLastName" default="">
    <cfparam name="FORM.motherMiddleName" default="">
    <cfparam name="FORM.motherDOB" default="">
    <cfparam name="FORM.motherSSN" default="">
	
	<cfscript>
    	if ( VAL(URL.hostID) ) {
			FORM.hostID = URL.hostID;	
		}
		
		if ( NOT VAL(FORM.hostID) ) {
			WriteOutput("An error has ocurred. Please go back and try again.");
			abort;
		}

		// Get Host Family Info
		qGetHostFamilyInfo = APPLICATION.CFC.HOST.getHosts(hostID=FORM.hostID);

		// These will set if SSN needs to be updated
		vUpdatefatherSSN = 0;
		vUpdatemotherSSN = 0;
	</cfscript>

    <!--- FORM Submitted --->
    <cfif FORM.submitted>

		<cfscript>
			// Data Validation - Check required Fields
			if ( NOT LEN(FORM.fatherFirstName) AND NOT LEN(FORM.motherFirstName) OR NOT LEN(FORM.fatherLastName) AND NOT LEN(FORM.motherLastName) ) {
				SESSION.formErrors.Add("Please enter at least one of the parents information.");
			}

			if ( LEN(FORM.fatherDOB) AND NOT IsDate(FORM.fatherDOB) ) {
				FORM.fatherDOB = '';
				SESSION.formErrors.Add("Please enter a valid Father's Date of Birth.");				
            }    
			
			if ( LEN(FORM.fatherSSN) AND Left(FORM.fatherSSN, 3) NEQ 'XXX' AND NOT isValid("social_security_number", Trim(FORM.fatherSSN)) ) {
				SESSION.formErrors.Add("Please enter a valid Father's SSN.");
            }    
			
			if ( LEN(FORM.motherDOB) AND NOT IsDate(FORM.motherDOB) ) {
				FORM.motherDOB = '';
				SESSION.formErrors.Add("Please enter a valid Mother's Date of Birth.");				
            }
			
			if ( LEN(FORM.motherSSN) AND Left(FORM.motherSSN, 3) NEQ 'XXX' AND NOT isValid("social_security_number", Trim(FORM.motherSSN)) ) {
				SESSION.formErrors.Add("Please enter a valid Mother's SSN.");
            }
		</cfscript>
        
        <!--- // Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>

            <cfscript>
                // Father SSN - Will update if it's blank or there is a new number
                if ( isValid("social_security_number", Trim(FORM.fatherSSN)) ) {
                    // Encrypt Social
                    FORM.fatherSSN = APPLICATION.CFC.UDF.encryptVariable(FORM.fatherSSN);
                    // Update
                    vUpdateFatherSSN = 1;
                } else if ( NOT LEN(FORM.fatherSSN) ) {
                    // Update - Erase SSN
                    vUpdateFatherSSN = 1;
                }
                
                // Mother SSN - Will update if it's blank or there is a new number
                if ( isValid("social_security_number", Trim(FORM.motherSSN)) ) {
                    // Encrypt Social
                    FORM.motherSSN = APPLICATION.CFC.UDF.encryptVariable(FORM.motherSSN);
                    // Update
                    vUpdateMotherSSN = 1;
                } else if ( NOT LEN(FORM.motherSSN) ) {
                    // Update - Erase SSN
                    vUpdateMotherSSN = 1;
                }
            </cfscript>

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                	smg_hosts
                SET 
                    fatherLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherLastName#">,
                    fatherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherFirstName#">,
                    fatherMiddleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherMiddleName#">,
                    <!--- Father SSN --->
                    <cfif VAL(vUpdateFatherSSN)>
                        fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherSSN#">,
                    </cfif>
                    fatherDOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.fatherDOB#" null="#NOT IsDate(FORM.fatherDOB)#">,
                    motherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherFirstName#">,
                    motherLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherLastName#">,
                    motherMiddleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherMiddleName#">,
                    <!--- Mother SSN --->
                    <cfif VAL(vUpdateMotherSSN)>
                        motherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherSSN#">,
                    </cfif>
                    motherDOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.motherDOB#" null="#NOT IsDate(FORM.motherDOB)#">
                WHERE 
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostID)#">
            </cfquery>			

			<cfscript>
                // Set Page Message
                SESSION.pageMessages.Add("Form successfully submitted.");

                // Reload page with updated information
                location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");
            </cfscript>
        
		</cfif>        
    
    <cfelse>
    
        <cfscript>
			FORM.fatherLastName = qGetHostFamilyInfo.fatherLastName;
			FORM.fatherFirstName = qGetHostFamilyInfo.fatherFirstName;
			FORM.fatherMiddleName = qGetHostFamilyInfo.fatherMiddleName;
			FORM.fatherDOB = qGetHostFamilyInfo.fatherDOB;
			FORM.fatherSSN = APPLICATION.CFC.UDF.decryptVariable(varString=qGetHostFamilyInfo.fatherSSN, displaySSN=1);
			FORM.motherFirstName = qGetHostFamilyInfo.motherFirstName;
			FORM.motherLastName = qGetHostFamilyInfo.motherLastName;
			FORM.motherMiddleName = qGetHostFamilyInfo.motherMiddleName;
			FORM.motherDOB = qGetHostFamilyInfo.motherDOB;
			FORM.motherSSN = APPLICATION.CFC.UDF.decryptVariable(varString=qGetHostFamilyInfo.motherSSN, displaySSN=1);
    	</cfscript>
    
    </cfif> <!--- FORM Submitted --->
    
</cfsilent>    

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />			

		<script type="text/JavaScript">
            // Jquery Masks 
            jQuery(function($){
                // DOB
                $("##fatherDOB").mask("99/99/9999");
                $("##motherDOB").mask("99/99/9999");
                // SSN
                $("##fatherSSN").mask("***-**-9999");
                $("##motherSSN").mask("***-**-9999");
            });	
            //-->
        </script>

        <!--- Close Window If Submitted Successfully --->
        <cfif SESSION.pageMessages.length()>
        
			<script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
            </script>
		
        </cfif>
    
        <!--- Table Header --->
        <gui:tableHeader
            imageName="family.gif"
            tableTitle="Info to Submit CBC - &nbsp; Host Family: #qGetHostFamilyInfo.familylastname# (###qGetHostFamilyInfo.hostID#)"
            width="98%"
            imagePath="../"
        />    
        
        <!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />
        
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />

        <form name="hostParentsCBC" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        	<input type="hidden" name="submitted" value="1">
            <input type="hidden" name="hostID" value="#FORM.hostID#">
        
            <table width="98%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
                <tr style="background-color:##e2efc7">
                	<th colspan="5">Host Father</th>
                </tr>
                <tr style="font-weight:bold; background-color:##ffffe6">
                	<td>First Name</td>
                    <td>Middle Name</td>
                    <td>Last Name</td>
                    <td>DOB</td>
                    <td>SSN</td>
                </tr>	
                <tr>
                    <td valign="top"><input type="text" name="fatherFirstName" class="mediumField" value="#FORM.fatherFirstName#"></td>
                    <td valign="top"><input type="text" name="fatherMiddleName" class="smallField" value="#FORM.fatherMiddleName#"></td>
                    <td valign="top"><input type="text" name="fatherLastName" class="mediumField" value="#FORM.fatherLastName#"></td>
                    <td valign="top">
                    	<input type="text" name="fatherDOB" id="fatherDOB" class="smallField" value="#DateFormat(FORM.fatherDOB,'mm-dd-yyyy')#" maxlength="10">
                    	<br /><font size="-2">mm/dd/yyyy</font>
					</td>                        
                    <td valign="top"><input type="text" name="fatherSSN" id="fatherSSN" value="#FORM.fatherSSN#" class="mediumField" maxlength="11"></td>
                </tr>	
                
                <tr><td colspan="5">&nbsp;</td></tr>
                
                <tr style="background-color:##e2efc7">
                	<th colspan="5">Host Mother</th>
                </tr>
                <tr style="font-weight:bold; background-color:##ffffe6">
                	<td>First Name</td>
                    <td>Middle Name</td>
                    <td>Last Name</td>
                    <td>DOB</td>
                    <td>SSN</td>
                </tr>	
                <tr>
                    <td valign="top"><input type="text" name="motherFirstName" class="mediumField" value="#FORM.motherFirstName#"></td>
                    <td valign="top"><input type="text" name="motherMiddleName" class="smallField" value="#FORM.motherMiddleName#"></td>
                    <td valign="top"><input type="text" name="motherLastName" class="mediumField" value="#FORM.motherLastName#"></td>
                    <td valign="top">
                    	<input type="text" name="motherDOB" id="motherDOB" class="smallField" value="#DateFormat(FORM.motherDOB,'mm-dd-yyyy')#" maxlength="10">
                    	<br /><font size="-2">mm/dd/yyyy</font>
                    </td>
                    <td valign="top"><input type="text" name="motherSSN" id="motherSSN" value="#FORM.motherSSN#" class="mediumField" maxlength="11"></td>
                </tr>		
            </table>
            
            <table width="98%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
            	<tr>
            		<td align="center"><input name="Submit" type="image" src="../pics/update.gif" border="0"></td>
            	</tr>
            </table>
        
        </form>					
    
        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="98%"
			imagePath="../"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />
    
</cfoutput>

