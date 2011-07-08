<!--- ------------------------------------------------------------------------- ----
	
	File:		hostMemberInfo.cfm
	Author:		Marcus Melo
	Date:		July 7, 2011
	Desc:		Host Members Required Fields for CBC
				
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
	<cfparam name="FORM.totalMembers" default="0">    
    
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
		
		// Get Host Family Members
		qGetHostFamilyMembers = APPLICATION.CFC.CBC.getEligibleHostMember(hostID=FORM.hostID);
	</cfscript>

	<!--- Param Host Member Form Variables --->
	<cfloop query="qGetHostFamilyMembers">
        
        <cfparam name="FORM.childID#qGetHostFamilyMembers.currentRow#" default="#qGetHostFamilyMembers.childID#">
        <cfparam name="FORM.name#qGetHostFamilyMembers.currentRow#" default="#qGetHostFamilyMembers.name#">
        <cfparam name="FORM.middleName#qGetHostFamilyMembers.currentRow#" default="#qGetHostFamilyMembers.middleName#">
        <cfparam name="FORM.lastName#qGetHostFamilyMembers.currentRow#" default="#qGetHostFamilyMembers.lastName#">
        <cfparam name="FORM.sex#qGetHostFamilyMembers.currentRow#" default="#qGetHostFamilyMembers.sex#">
        <cfparam name="FORM.birthDate#qGetHostFamilyMembers.currentRow#" default="#qGetHostFamilyMembers.birthDate#">
        <cfparam name="FORM.SSN#qGetHostFamilyMembers.currentRow#" default="#APPLICATION.CFC.UDF.displaySSN(varString=qGetHostFamilyMembers.SSN, isMaskedSSN=1)#">

	</cfloop>    
	
    <!--- FORM Submitted --->
    <cfif FORM.submitted>

		<cfscript>
			// Data Validation - Check required Fields
			
			// Loop through form variables
            For ( i=1; i LTE FORM.totalMembers; i=i+1 ) {

				if ( NOT LEN(FORM["name" & i]) ) {
					SESSION.formErrors.Add("First Name is required for member ##" & i);
				}

				if ( NOT LEN(FORM["lastName" & i]) ) {
					SESSION.formErrors.Add("Last Name is required for member ##" & i);
				}

				if ( NOT LEN(FORM["sex" & i]) ) {
					SESSION.formErrors.Add("Gender is required for member ##" & i);
				}

				if ( LEN(FORM["birthDate" & i]) AND NOT IsDate(FORM["birthDate" & i]) ) {
					FORM["birthDate" & i] = '';
					SESSION.formErrors.Add("Please enter a valid DOB for member ##" & i);
				}    
				
				if ( LEN(FORM["SSN" & i]) AND Left(FORM["SSN" & i], 3) NEQ 'XXX' AND NOT isValid("social_security_number", Trim(FORM["SSN" & i])) ) {
					SESSION.formErrors.Add("Please enter a valid SSN for member ##" & i);
				}    

			}
		</cfscript>
        
        <!--- // Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
			
            <cfloop from="1" to="#FORM.totalMembers#" index="i">
            	
                <cfscript>
					// Set Up Variable that will determine if we need to update SSN
					FORM["updateSSN" & i] = 0;
				
					// Father SSN - Will update if it's blank or there is a new number
					if ( isValid("social_security_number", Trim(FORM["SSN" & i])) ) {
						// Encrypt Social
						FORM["SSN" & i] = APPLICATION.CFC.UDF.encryptVariable(FORM["SSN" & i]);
						// Update
						FORM["updateSSN" & i] = 1;
					} else if ( NOT LEN(FORM["SSN" & i]) ) {
						// Update - Erase SSN
						FORM["updateSSN" & i] = 1;
					}
				</cfscript>

                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE 
                        smg_host_children
                    SET 
                        name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['name' & i]#">,
                        middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['middleName' & i]#">,
                        lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['lastName' & i]#">,
                        sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['sex' & i]#">,
                        <!--- Father SSN --->
                        <cfif VAL(FORM["updateSSN" & i])>
                            SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['SSN' & i]#">,
                        </cfif>
                        birthDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM['birthDate' & i]#" null="#NOT IsDate(FORM['birthDate' & i])#">                        
                    WHERE 
                        childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM['childID' & i])#">
                    AND
                    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostID)#">
                </cfquery>			
                
            </cfloop>

			<cfscript>
                // Set Page Message
                SESSION.pageMessages.Add("Form successfully submitted.");

                // Reload page with updated information
                location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");
            </cfscript>
        
		</cfif>        
    
    </cfif> <!--- FORM Submitted --->
    
</cfsilent> 

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />			
		
        <cfloop query="qGetHostFamilyMembers">
        
			<script type="text/JavaScript">
                // Jquery Masks 
                jQuery(function($){
                    // DOB
                    $("##birthDate#qGetHostFamilyMembers.currentRow#").mask("99/99/9999");
                    // SSN
                    $("##SSN#qGetHostFamilyMembers.currentRow#").mask("***-**-9999");
                });	
                //-->
            </script>
            
		</cfloop>
        
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
            tableTitle="Info to Submit CBC - &nbsp; Host Family Members of #qGetHostFamilyInfo.familylastname# (###qGetHostFamilyInfo.hostID#)"
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
            
        <form name="hostMembersCBC" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        	<input type="hidden" name="submitted" value="1">
            <input type="hidden" name="hostID" value="#FORM.hostID#">
            <input type="hidden" name="totalMembers" value='#qGetHostFamilyMembers.recordcount#'>
            
            <table width="98%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
                <tr style="background-color:##e2efc7">
                	<th colspan="7">Eligible Host Family Members</th>
                </tr>
                <tr style="font-weight:bold; background-color:##ffffe6">
                	<td width="5px;">&nbsp;</td>
                    <td>First Name</td>
                    <td>Middle Name</td>
                    <td>Last Name</td>
                    <td>Gender</td>
                    <td>DOB</td>
                    <td>SSN</td>
                </tr>	
                <cfloop query="qGetHostFamilyMembers">
                    <input type="hidden" name="childID#qGetHostFamilyMembers.currentrow#" value="#qGetHostFamilyMembers.childID#">
                    <tr bgcolor="###iif(qGetHostFamilyMembers.currentrow MOD 2 ,DE("FFFFFF") ,DE("ffffe6") )#">
                        <td valign="top">#qGetHostFamilyMembers.currentRow#</td>
                        <td valign="top"><input type="text" name="name#qGetHostFamilyMembers.currentRow#" class="mediumField" value="#FORM['name' & qGetHostFamilyMembers.currentrow]#"></td>
                        <td valign="top"><input type="text" name="middleName#qGetHostFamilyMembers.currentRow#" size="8" value="#FORM['middleName' & qGetHostFamilyMembers.currentrow]#"></td>
                        <td valign="top"><input type="text" name="lastName#qGetHostFamilyMembers.currentRow#" class="mediumField" value="#FORM['lastName' & qGetHostFamilyMembers.currentrow]#"></td>
                        <td valign="top">
                        	<input type="radio" name="sex#qGetHostFamilyMembers.currentRow#" id="genderM#qGetHostFamilyMembers.currentRow#" value="Male" <cfif FORM['sex' & qGetHostFamilyMembers.currentrow] EQ 'male'> checked="checked" </cfif> > 
                            <label for="genderM#qGetHostFamilyMembers.currentRow#">Male</label>
                            &nbsp; 
                            <input type="radio" name="sex#qGetHostFamilyMembers.currentRow#" id="genderF#qGetHostFamilyMembers.currentRow#" value="Female" <cfif FORM['sex' & qGetHostFamilyMembers.currentrow] EQ 'female'> checked="checked" </cfif> > 
                            <label for="genderF#qGetHostFamilyMembers.currentRow#">Female</label>
                        </td>
                        <td valign="top">
                        	<input type="text" name="birthDate#qGetHostFamilyMembers.currentRow#" id="birthDate#qGetHostFamilyMembers.currentRow#" class="smallField" value="#DateFormat(FORM['birthDate' & qGetHostFamilyMembers.currentrow],'mm-dd-yyyy')#" maxlength="10">
                        	<br /><font size="-2">mm/dd/yyyy</font>
                        </td>
                        <td valign="top">
        					<input type="text" name="SSN#qGetHostFamilyMembers.currentRow#" id="SSN#qGetHostFamilyMembers.currentRow#" value="#FORM['SSN' & qGetHostFamilyMembers.currentrow]#" class="mediumField" maxlength="11">
                        </td>
                    </tr>	
                </cfloop>
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