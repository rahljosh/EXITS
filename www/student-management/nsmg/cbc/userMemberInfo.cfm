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
    <cfparam name="URL.userID" default="">

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.userID" default="0">    
	<cfparam name="FORM.totalMembers" default="0">    
    
	<cfscript>
    	if ( VAL(URL.userID) ) {
			FORM.userID = URL.userID;	
		}
		
		if ( NOT VAL(FORM.userID) ) {
			WriteOutput("An error has ocurred. Please go back and try again.");
			abort;
		}

		// Get Host Family Info
		qGetUserInfo = APPLICATION.CFC.USER.getUserByID(userID=FORM.userID);
		
		// Get Host Family Members
		qGetUserMembers = APPLICATION.CFC.CBC.getEligibleUserMember(userID=FORM.userID);
	</cfscript>

	<!--- Param Host Member Form Variables --->
	<cfloop query="qGetUserMembers">
        
        <cfparam name="FORM.ID#qGetUserMembers.currentRow#" default="#qGetUserMembers.ID#">
        <cfparam name="FORM.firstName#qGetUserMembers.currentRow#" default="#qGetUserMembers.firstName#">
        <cfparam name="FORM.middleName#qGetUserMembers.currentRow#" default="#qGetUserMembers.middleName#">
        <cfparam name="FORM.lastName#qGetUserMembers.currentRow#" default="#qGetUserMembers.lastName#">
        <cfparam name="FORM.sex#qGetUserMembers.currentRow#" default="#qGetUserMembers.sex#">
        <cfparam name="FORM.DOB#qGetUserMembers.currentRow#" default="#qGetUserMembers.DOB#">
        <cfparam name="FORM.SSN#qGetUserMembers.currentRow#" default="#APPLICATION.CFC.UDF.decryptVariable(varString=qGetUserMembers.SSN, displaySSN=1)#">

	</cfloop>    

    <!--- FORM Submitted --->
    <cfif FORM.submitted>

		<cfscript>
			// Data Validation - Check required Fields
			
			// Loop through form variables
            For ( i=1; i LTE FORM.totalMembers; i=i+1 ) {

				if ( NOT LEN(FORM["firstName" & i]) ) {
					SESSION.formErrors.Add("First Name is required for member ##" & i);
				}

				if ( NOT LEN(FORM["lastName" & i]) ) {
					SESSION.formErrors.Add("Last Name is required for member ##" & i);
				}

				if ( NOT LEN(FORM["sex" & i]) ) {
					SESSION.formErrors.Add("Gender is required for member ##" & i);
				}

				if ( LEN(FORM["DOB" & i]) AND NOT IsDate(FORM["DOB" & i]) ) {
					FORM["DOB" & i] = '';
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
                        smg_user_family
                    SET 
                        firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['firstName' & i]#">,
                        middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['middleName' & i]#">,
                        lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['lastName' & i]#">,
                        sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['sex' & i]#">,
                        <!--- SSN --->
                        <cfif VAL(FORM["updateSSN" & i])>
                            SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['SSN' & i]#">,
                        </cfif>
                        DOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM['DOB' & i]#" null="#NOT IsDate(FORM['DOB' & i])#">                        
                    WHERE 
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM['ID' & i])#">
                    AND
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">
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
		
        <cfloop query="qGetUserMembers">
        
			<script type="text/JavaScript">
                // Jquery Masks 
                jQuery(function($){
                    // DOB
                    $("##DOB#qGetUserMembers.currentRow#").mask("99/99/9999");
                    // SSN
                    $("##SSN#qGetUserMembers.currentRow#").mask("***-**-9999");
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
            tableTitle="Info to Submit CBC - &nbsp; User Members of #qGetUserInfo.firstName# #qGetUserInfo.lastName# (###qGetUserInfo.userID#)"
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

        <form name="userMembersCBC" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        	<input type="hidden" name="submitted" value="1">
            <input type="hidden" name="userID" value="#FORM.userID#">
            <input type="hidden" name="totalMembers" value='#qGetUserMembers.recordcount#'>
            
            <table width="98%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
                <tr style="background-color:##e2efc7">
                	<th colspan="7">Eligible User Members</th>
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
                <cfloop query="qGetUserMembers">
                    <input type="hidden" name="ID#qGetUserMembers.currentrow#" value="#qGetUserMembers.ID#">
                    <tr bgcolor="###iif(qGetUserMembers.currentrow MOD 2 ,DE("FFFFFF") ,DE("ffffe6") )#">
                        <td valign="top">#qGetUserMembers.currentRow#</td>
                        <td valign="top"><input type="text" name="firstName#qGetUserMembers.currentRow#" class="mediumField" value="#FORM['firstName' & qGetUserMembers.currentrow]#"></td>
                        <td valign="top"><input type="text" name="middleName#qGetUserMembers.currentRow#" size="8" value="#FORM['middleName' & qGetUserMembers.currentrow]#"></td>
                        <td valign="top"><input type="text" name="lastName#qGetUserMembers.currentRow#" class="mediumField" value="#FORM['lastName' & qGetUserMembers.currentrow]#"></td>
                        <td valign="top">
                        	<input type="radio" name="sex#qGetUserMembers.currentRow#" id="genderM#qGetUserMembers.currentRow#" value="Male" <cfif FORM['sex' & qGetUserMembers.currentrow] EQ 'male'> checked="checked" </cfif> > 
                            <label for="genderM#qGetUserMembers.currentRow#">Male</label>
                            &nbsp; 
                            <input type="radio" name="sex#qGetUserMembers.currentRow#" id="genderF#qGetUserMembers.currentRow#" value="Female" <cfif FORM['sex' & qGetUserMembers.currentrow] EQ 'female'> checked="checked" </cfif> > 
                            <label for="genderF#qGetUserMembers.currentRow#">Female</label>
                        </td>
                        <td valign="top">
                        	<input type="text" name="DOB#qGetUserMembers.currentRow#" id="DOB#qGetUserMembers.currentRow#" class="smallField" value="#DateFormat(FORM['DOB' & qGetUserMembers.currentrow],'mm-dd-yyyy')#" maxlength="10">
                        	<br /><font size="-2">mm/dd/yyyy</font>
                        </td>
                        <td valign="top">
        					<input type="text" name="SSN#qGetUserMembers.currentRow#" id="SSN#qGetUserMembers.currentRow#" value="#FORM['SSN' & qGetUserMembers.currentrow]#" class="mediumField" maxlength="11">
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