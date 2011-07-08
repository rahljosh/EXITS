<!--- ------------------------------------------------------------------------- ----
	
	File:		userInfo.cfm
	Author:		Marcus Melo
	Date:		July 7, 2011
	Desc:		User Required Fields for CBC
				
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
    <cfparam name="FORM.firstName" default="">
    <cfparam name="FORM.middleName" default="">
    <cfparam name="FORM.lastName" default="">
    <cfparam name="FORM.DOB" default="">
    <cfparam name="FORM.SSN" default="">

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

		// This will set if SSN needs to be updated
		vUpdateUserSSN = 0;
	</cfscript>

    <!--- FORM Submitted --->
    <cfif FORM.submitted>

		<cfscript>
			// Data Validation - Check required Fields
			if ( NOT LEN(FORM.firstName) ) {
				SESSION.formErrors.Add("First Name is required.");
			}

			if ( NOT LEN(FORM.lastName) ) {
				SESSION.formErrors.Add("Last Name is required.");
			}

			if ( LEN(FORM.DOB) AND NOT IsDate(FORM.DOB) ) {
				FORM.DOB = '';
				SESSION.formErrors.Add("Please enter a valid Date of Birth.");				
            }    
			
			if ( LEN(FORM.SSN) AND Left(FORM.SSN, 3) NEQ 'XXX' AND NOT isValid("social_security_number", Trim(FORM.SSN)) ) {
				SESSION.formErrors.Add("Please enter a valid SSN.");
            }    
		</cfscript>
        
        <!--- // Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>

            <cfscript>
                // Father SSN - Will update if it's blank or there is a new number
                if ( isValid("social_security_number", Trim(FORM.SSN)) ) {
                    // Encrypt Social
                    FORM.SSN = APPLICATION.CFC.UDF.encryptVariable(FORM.SSN);
                    // Update
                    vUpdateUserSSN = 1;
                } else if ( NOT LEN(FORM.SSN) ) {
                    // Update - Erase SSN
                    vUpdateUserSSN = 1;
                }
            </cfscript>

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                	smg_users
                SET 
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstName#">,
                    middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.middleName#">,
                    lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastName#">,
                    <!--- Father SSN --->
                    <cfif VAL(vUpdateUserSSN)>
                        SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SSN#">,
                    </cfif>
                    DOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.DOB#" null="#NOT IsDate(FORM.DOB)#">
                WHERE 
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">
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
			FORM.firstName = qGetUserInfo.firstName;
			FORM.middleName = qGetUserInfo.middleName;
			FORM.lastName = qGetUserInfo.lastName;
			FORM.DOB = qGetUserInfo.DOB;
			FORM.SSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetUserInfo.SSN, isMaskedSSN=1);
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
                $("##DOB").mask("99/99/9999");
                // SSN
                $("##SSN").mask("***-**-9999");
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
            tableTitle="Info to Submit CBC - &nbsp; User: #qGetUserInfo.firstName# #qGetUserInfo.lastName# (###qGetUserInfo.userID#)"
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

        <form name="userCBC" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        	<input type="hidden" name="submitted" value="1">
            <input type="hidden" name="userID" value="#FORM.userID#">
        
            <table width="98%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
                <tr style="background-color:##e2efc7">
                	<th colspan="5">User: #qGetUserInfo.firstname# #qGetUserInfo.lastname# (###qGetUserInfo.userid#)</th>
                </tr>
                <tr style="font-weight:bold; background-color:##ffffe6">
                	<td>First Name</td>
                    <td>Middle Name</td>
                    <td>Last Name</td>
                    <td>DOB</td>
                    <td>SSN</td>
                </tr>	
                <tr>
                    <td valign="top"><input type="text" name="firstName" class="mediumField" value="#FORM.firstName#"></td>
                    <td valign="top"><input type="text" name="middleName" class="smallField" value="#FORM.middleName#"></td>
                    <td valign="top"><input type="text" name="lastName" class="mediumField" value="#FORM.lastName#"></td>
                    <td valign="top">
                    	<input type="text" name="DOB" id="DOB" class="smallField" value="#DateFormat(FORM.DOB,'mm-dd-yyyy')#" maxlength="10">
                    	<br /><font size="-2">mm/dd/yyyy</font>
					</td>                        
                    <td valign="top"><input type="text" name="SSN" id="SSN" value="#FORM.SSN#" class="mediumField" maxlength="11"></td>
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