<!--- ------------------------------------------------------------------------- ----
	
	File:		cbcAuthorization.cfm
	Author:		Marcus Melo
	Date:		December 10, 2012
	Desc:		CBC Authorization Page
				documentTypeID = 16 - Host Father CBC Authorization
				documentTypeID = 17 - Host Mother CBC Authorization
				documentTypeID = 18 - Host Member CBC Authorization

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>
		// Father CBC Authorization
		qGetFatherCBCAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",																		   
			foreignID=APPLICATION.CFC.SESSION.getHostSession().ID, 
			documentTypeID=APPLICATION.DOCUMENT.hostFatherCBCAuthorization, 
			seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID
		);
		
		// Mother CBC Authorization
		qGetMotherCBCAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",																   	
			foreignID=APPLICATION.CFC.SESSION.getHostSession().ID, 
			documentTypeID=APPLICATION.DOCUMENT.hostMotherCBCAuthorization, 
			seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID
		);
		
		// Get Host Family Members at Home
		qGetAllFamilyMembersAtHome = APPLICATION.CFC.HOST.getHostMemberByID(hostID=APPLICATION.CFC.SESSION.getHostSession().ID,liveAtHome="yes");	
		
		// Get Host Family Members at Home
		qGetCBCQualifiedMembers = APPLICATION.CFC.HOST.getHostMemberByID(hostID=APPLICATION.CFC.SESSION.getHostSession().ID,getCBCQualifiedMembers=1);	

		vCBCQualifiedMembersList = ValueList(qGetCBCQualifiedMembers.childID);
		
		// Defaults to true
		vIsPreviousInfoCompleted = true;
		
		// Sets to true when an authorization is generated
		vSendOutEmail = false;
		
		// Set Current Row
		vSSNCurrentRow = 0;
		vSignatureCurrentRow = 0;		
	</cfscript>

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.fatherSSN" default="">
    <cfparam name="FORM.fatherSignature" default="">
    <cfparam name="FORM.motherSSN" default="">
    <cfparam name="FORM.motherSignature" default="">
    
	<!--- Host Members --->
    <cfloop query="qGetAllFamilyMembersAtHome">
        
		<cfscript>
            // Member CBC Authorization
            qGetMemberCBCAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
                foreignTable="smg_host_children",
                foreignID=qGetAllFamilyMembersAtHome.childID, 
                documentTypeID=APPLICATION.DOCUMENT.hostMemberCBCAuthorization, 
                seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID
            );
        </cfscript>
        
    	<cfparam name="FORM.#qGetAllFamilyMembersAtHome.childID#memberSSN" default="">
        <cfparam name="FORM.#qGetAllFamilyMembersAtHome.childID#memberSignature" default="">
        <cfparam name="FORM.#qGetAllFamilyMembersAtHome.childID#documentID" default="#qGetMemberCBCAuthorization.ID#">
        
    </cfloop>
    
    <!--- For showing the date for required child CBCs --->
    <cfquery name="qGetSeasonEndDate" datasource="#APPLICATION.DSN.Source#">
        SELECT endDate
        FROM smg_seasons
        WHERE seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.selectedSeason#">
    </cfquery>
    
    <!--- FORM Submitted --->    
	<cfif VAL(FORM.submitted)>
		
        <cfscript>
			// Data Validation

			// Father
			if ( (LEN(qGetHostFamilyInfo.fatherFirstName) OR LEN(qGetHostFamilyInfo.fatherLastName)) AND (qGetHostFamilyInfo.otherHostParent NEQ "none") ) {
				
				// SSN
				if  ( NOT LEN(qGetHostFamilyInfo.fatherSSN) AND NOT IsValid("ssn", FORM.fatherSSN) ) {
					SESSION.formErrors.Add("The SSN for #qGetHostFamilyInfo.fatherFirstName# #qGetHostFamilyInfo.fatherLastName# does not appear to be a valid SSN. Please make sure it is entered in the 999-99-9999 format.");
				}	
				
				// Signature
				if ( NOT qGetFatherCBCAuthorization.recordCount AND NOT LEN(TRIM(FORM.fatherSignature)) ) {
					SESSION.formErrors.Add("The CBC authorization signature for #qGetHostFamilyInfo.fatherFirstName# #qGetHostFamilyInfo.fatherLastName# is missing.");
				}	
				
			
			}
			
			// Mother
			if (LEN(qGetHostFamilyInfo.motherFirstName) OR LEN(qGetHostFamilyInfo.motherLastName)) {
				
				// SSN
				if  ( NOT LEN(qGetHostFamilyInfo.motherSSN) AND NOT IsValid("ssn", FORM.motherSSN) ) {
					SESSION.formErrors.Add("The SSN for #qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherLastName# does not appear to be a valid SSN. Please make sure it is entered in the 999-99-9999 format.");
				}	
				
				// Signature
				if ( NOT qGetMotherCBCAuthorization.recordCount AND NOT LEN(TRIM(FORM.motherSignature)) ){
					SESSION.formErrors.Add("The CBC authorization signature for #qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherLastName# is missing.");
				}	
				
			
			}
			
			// Family Members
			for ( i=1; i LTE qGetCBCQualifiedMembers.recordCount; i++ ) {
				
				// SSN
				if  ( NOT LEN(qGetCBCQualifiedMembers.ssn[i]) AND NOT IsValid("ssn", FORM[qGetCBCQualifiedMembers.childID[i] & "memberSSN"]) ) {
					SESSION.formErrors.Add("The SSN for #qGetCBCQualifiedMembers.name[i]# does not appear to be a valid SSN. Please make sure it is entered in the 999-99-9999 format.");
				}	
				
				// Signature
				if ( NOT LEN(FORM[qGetCBCQualifiedMembers.childID[i] & "documentID"]) AND NOT LEN(TRIM(FORM[qGetCBCQualifiedMembers.childID[i] & "memberSignature"])) ){
					SESSION.formErrors.Add("The CBC authorization signature for #qGetCBCQualifiedMembers.name[i]# is missing");
				}	
				
				vMemberName = TRIM(qGetCBCQualifiedMembers.name[i]) & " " & TRIM(qGetCBCQualifiedMembers.lastName[i]);
				
				
			}			
		</cfscript>
        
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>
			
            <!---- Father SSN --->
            <cfif NOT LEN(qGetHostFamilyInfo.fatherSSN)>
                
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 	
                    	smg_hosts
                    SET 
                    	fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(FORM.fatherSSN)#">
                    WHERE 
                    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
                </cfquery>
			
            </cfif>
            
            <!---- Mother SSN --->
            <cfif NOT LEN(qGetHostFamilyInfo.motherSSN)>
                
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 	
                    	smg_hosts
                    SET 
                    	motherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(FORM.motherSSN)#">
                    WHERE 
                    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
                </cfquery>
			
            </cfif>
            
            <!--- Member SSN --->
            <cfloop query="qGetCBCQualifiedMembers">
            
				<cfif NOT LEN(qGetCBCQualifiedMembers.SSN)>

                    <cfquery datasource="#APPLICATION.DSN.Source#">
                        UPDATE 	
                            smg_host_children
                        SET 
                            SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(FORM[qGetCBCQualifiedMembers.childID & 'memberSSN'])#">
                        WHERE 
                            childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCBCQualifiedMembers.childID#">
                        AND
                        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
                    </cfquery>
				
                </cfif>
                            
            </cfloop>
            
            <cfscript>
				/***************************
					Father Authorization 
				***************************/
				if ( NOT qGetFatherCBCAuthorization.recordCount AND LEN(qGetHostFamilyInfo.fatherFirstName) AND LEN(qGetHostFamilyInfo.fatherlastname) ) {
				
					// Generate CBC Authorization
					stResult = APPLICATION.CFC.DOCUMENT.generateCBCAuthorization(
						foreignTable = "smg_hosts",
						foreignID = APPLICATION.CFC.SESSION.getHostSession().ID,
						documentTypeID = APPLICATION.DOCUMENT.hostFatherCBCAuthorization,
						address = qGetHostFamilyInfo.address,
						city = qGetHostFamilyInfo.city,
						state = qGetHostFamilyInfo.state,
						zip = qGetHostFamilyInfo.zip,
						signature = FORM.fatherSignature																		  
					);
					
					if ( stResult.isSuccess ) {
						// Send Out Email
						vSendOutEmail = true;
						
						// Insert CBC
						APPLICATION.CFC.CBC.insertHostCBC(
							hostID=qGetHostFamilyInfo.hostID,
							cbcType="father",
							seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID,
							companyID=qGetHostFamilyInfo.companyID,
							isNoSSN=0,
							dateAuthorized=NOW());
					} else {
						// Set Error Message
						SESSION.formErrors.Add(stResult.message);
					}
				
				}
				
				
				/***************************
					Mother Authorization 
				***************************/
				if ( NOT qGetMotherCBCAuthorization.recordCount AND LEN(qGetHostFamilyInfo.motherFirstName) AND LEN(qGetHostFamilyInfo.motherlastname) ) {
					
					// Generate CBC Authorization
					stResult = APPLICATION.CFC.DOCUMENT.generateCBCAuthorization(
						foreignTable = "smg_hosts",
						foreignID = APPLICATION.CFC.SESSION.getHostSession().ID,
						documentTypeID = APPLICATION.DOCUMENT.hostMotherCBCAuthorization,
						address = qGetHostFamilyInfo.address,
						city = qGetHostFamilyInfo.city,
						state = qGetHostFamilyInfo.state,
						zip = qGetHostFamilyInfo.zip,
						signature = FORM.motherSignature																		  
					);
					
					if ( stResult.isSuccess ) {
						// Send Out Email
						vSendOutEmail = true;
						
						// Insert CBC
						APPLICATION.CFC.CBC.insertHostCBC(
							hostID=qGetHostFamilyInfo.hostID,
							cbcType="mother",
							seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID,
							companyID=qGetHostFamilyInfo.companyID,
							isNoSSN=0,
							dateAuthorized=NOW());
					} else {
						// Set Error Message
						SESSION.formErrors.Add(stResult.message);
					}
				
				}
				
				
				/***************************
					Member Authorization 
				***************************/
				for ( i=1; i LTE qGetCBCQualifiedMembers.recordCount; i++ ) {
					
					if ( NOT LEN(FORM[qGetCBCQualifiedMembers.childID[i] & "documentID"]) AND LEN(qGetCBCQualifiedMembers.name[i]) AND LEN(qGetCBCQualifiedMembers.lastName[i]) ) {
					
						// Generate CBC Authorization
						stResult = APPLICATION.CFC.DOCUMENT.generateCBCAuthorization(
							foreignTable = "smg_host_children",
							foreignID = qGetCBCQualifiedMembers.childID[i],
							documentTypeID = APPLICATION.DOCUMENT.hostMemberCBCAuthorization,
							address = qGetHostFamilyInfo.address,
							city = qGetHostFamilyInfo.city,
							state = qGetHostFamilyInfo.state,
							zip = qGetHostFamilyInfo.zip,
							signature = FORM[qGetCBCQualifiedMembers.childID[i] & 'memberSignature']																		  
						);
							
						if ( stResult.isSuccess ) {
							// Send Out Email
							vSendOutEmail = true;
							
							// Insert CBC
							APPLICATION.CFC.CBC.insertHostCBC(
								hostID=qGetHostFamilyInfo.hostID,
								cbcType="member",
								familyMemberID=qGetCBCQualifiedMembers.childID[i],
								seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID,
								companyID=qGetHostFamilyInfo.companyID,
								isNoSSN=0,
								dateAuthorized=NOW());
						} else {
							// Set Error Message
							SESSION.formErrors.Add(stResult.message);
						}
					
					}
					
				}
			</cfscript>
            
            <!--- Send Out a copy of the files --->
            <cfif vSendOutEmail AND isValid("email", qGetHostFamilyInfo.email)>
            
				<cfscript>
                    // Set File ##
                    vCurrentEmailFile=1;
                
                    // Host Parents Authorization
                    qGetHostParentsAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
                        foreignTable="smg_hosts",	
                        foreignID=APPLICATION.CFC.SESSION.getHostSession().ID, 
                        seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID,
                        documentGroup="cbcAuthorization"
                    );
                    
					// Make sure there are valid family members, if not pass 0
					if ( qGetCBCQualifiedMembers.recordCount ) {
						vMemberChildIDList = ValueList(qGetCBCQualifiedMembers.childID);
					} else {
						vMemberChildIDList = 0;
					}
					
                    // Host Members Authorization
                    qGetMembersCBCAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
                        foreignTable="smg_host_children",																   
                        foreignIDList=vMemberChildIDList, 
                        seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID,
                        documentGroup="cbcAuthorization"
                    );
                </cfscript>
                
                <cfsavecontent variable="vHostCBCEmailMessage">
                    <cfoutput>	
                        <p>Dear Host Family,</p>
                        
                        <p>Attached are copies of the Criminal Background Check Authorization that you and any required members of your family electronically signed.</p> <br />
                        
                        Regards-<br />
                        #APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='shortName')# Support
                    </cfoutput>
                </cfsavecontent>    
                
                <cfinvoke component="extensions.components.email" method="sendEmail">
                    <cfinvokeargument name="emailTo" value="#qGetHostFamilyInfo.email#">       
                    <cfinvokeargument name="emailFrom" value="#SESSION.COMPANY.EMAIL.support#">
                    <cfinvokeargument name="emailSubject" value="Host Family Application - CBC Authorization Forms">
                    <cfinvokeargument name="emailMessage" value="#vHostCBCEmailMessage#">
                    
                    <!--- Host Parents CBC Authorization --->
                    <cfloop query="qGetHostParentsAuthorization">
                    
                        <cfinvokeargument name="emailFile#vCurrentEmailFile#" value="#qGetHostParentsAuthorization.filePath#">
                        
                        <cfscript>
                            // Increase Row
                            vCurrentEmailFile ++;
                        </cfscript>
                        
                    </cfloop>
                    
                    <!--- Host Members CBC Authorization --->
                    <cfloop query="qGetMembersCBCAuthorization">
                    
                        <cfinvokeargument name="emailFile#vCurrentEmailFile#" value="#qGetMembersCBCAuthorization.filePath#">
                        
                        <cfscript>
                            // Increase Row
                            vCurrentEmailFile ++;
                        </cfscript>
                        
                    </cfloop>
                
                </cfinvoke>	
			
			</cfif>                
            <!--- End of Send Out a copy of the files --->                    
        
			<!--- Go to next section --->
            <cfscript>
				if ( NOT SESSION.formErrors.length() ) {
					// Successfully Updated - Set navigation page
					Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
				}
			</cfscript>				
            
		</cfif>

    <!--- FORM Not Submitted --->	
    <cfelse>

		<cfscript>
			// Section 1 Not Complete
			if ( NOT LEN(qGetHostFamilyInfo.fatherFirstName) AND NOT LEN(qGetHostFamilyInfo.fatherLastName) AND NOT LEN(qGetHostFamilyInfo.motherFirstName) AND NOT LEN(qGetHostFamilyInfo.motherLastName) ) {
				SESSION.formErrors.Add("Prior to complete this page, please complete page Name & Contact Info.");
			}
		
			// Address
			if ( NOT LEN(qGetHostFamilyInfo.address) OR NOT LEN(qGetHostFamilyInfo.city) OR NOT LEN(qGetHostFamilyInfo.state) OR NOT LEN(qGetHostFamilyInfo.zip) ) {
				 SESSION.formErrors.Add("A complete address is missing. Please click on Name & Contact info in the left menu and enter the address prior to complete this section."); 
			}
			
			// Host Mother - Check if we have a valid DOB 
			if ( LEN(qGetHostFamilyInfo.motherFirstName) AND NOT isDate(qGetHostFamilyInfo.motherdob) )  {
                SESSION.formErrors.Add("Date of birth is missing for the Primary Host Parent #qGetHostFamilyInfo.motherFirstName#. Please click on Name & Contact info in the left menu and enter the date of birth prior to complete this section.");
            } 
		
			// Host Father - Check if we have a valid DOB 
            if ( LEN(qGetHostFamilyInfo.fatherFirstName) AND NOT isDate(qGetHostFamilyInfo.fatherdob) AND qGetHostFamilyInfo.otherHostParent NEQ "none" )  {
                SESSION.formErrors.Add("Date of birth is missing for the Other Host Parent #qGetHostFamilyInfo.fatherFirstName#. Please click on Name & Contact info in the left menu and enter the date of birth prior to complete this section.");
            }
			
			// Family Members - Check if we have a valid DOB for all members 
			for ( i=1; i LTE qGetAllFamilyMembersAtHome.recordCount; i++ ) {	

				if ( NOT LEN(qGetAllFamilyMembersAtHome.lastName[i]) ) {				
					SESSION.formErrors.Add("Last Name is missing for host member #qGetAllFamilyMembersAtHome.name[i]#. Please click on Family Members in the left menu and enter the date of birth prior to complete this section.");
				}

				if ( LEN(qGetAllFamilyMembersAtHome.name[i]) AND NOT isDate(qGetAllFamilyMembersAtHome.birthDate[i]) ) {				
					SESSION.formErrors.Add("Date of birth is missing for host member #qGetAllFamilyMembersAtHome.name[i]#. Please click on Family Members in the left menu and enter the date of birth prior to complete this section.");
				}
			
			}
			
			// No Errors Found
			if ( SESSION.formErrors.length() ) {
				
				// Previous information is missing, do not allow page submission
				vIsPreviousInfoCompleted = false;	
				
			}
		</cfscript>		
    
	</cfif>    

</cfsilent>

<cfoutput>
	
    <h2>Criminal Background Check</h2>
    
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
         
	
    

    <cfif vIsPreviousInfoCompleted>

        Due to Department of State Regulations&dagger;, criminal background checks will need to be run on the following persons.  
        Please provide the following information on each person so that we can complete the background check. <br /><br />
    
        <cfform method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
            <input type="hidden" name="submitted" value="1" />
    
            <h3>Host Parent(s)</h3>
            
            <span class="required">* Required fields</span>
            
            <table width="100%" cellspacing="0" cellpadding="4" class="border">
                <tr bgcolor="##deeaf3">
                    <th width="28%">Name</th>
                    <th width="17%">Relation</th>
                    <th width="20%">Date of Birth</th>
                    <th width="10%">Age</th>
                    <th width="25%">Social Security ## <span class="required">*</span></th>
                </tr>
                
                <!--- Primary Host Parent --->
                <cfif LEN(qGetHostFamilyInfo.motherFirstName) OR LEN(qGetHostFamilyInfo.motherlastname)>
                    <tr <cfif vSSNCurrentRow MOD 2> bgcolor="##deeaf3" </cfif> >
                        <td><h3>#qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherlastname#</h3></td>
                        <td><h3><cfif qGetHostFamilyInfo.primaryHostParent EQ "mother">Host Mother<cfelse>Host Father</cfif></h3></td>
                        <td><h3>#DateFormat(qGetHostFamilyInfo.motherdob, 'mmm d, yyyy')#</h3></td>
                        <td><h3><cfif isDate(qGetHostFamilyInfo.motherdob)>#DateDiff('yyyy',qGetHostFamilyInfo.motherdob,now())#</cfif></h3></td> 
                        <td>
                            <cfif NOT LEN(qGetHostFamilyInfo.motherSSN)>
                                <cfinput type="text" name="motherSSN" value="#FORM.motherSSN#" mask="999-99-9999" class="mediumField" maxlength="50">
                            <cfelse>
                                Submitted <!--- #FORM.motherSSN# --->
                            </cfif>
                        </td>
                    </tr>
                    <cfscript>
                        // Increase value of current row
                        vSSNCurrentRow ++;
                    </cfscript>
                </cfif>
                
                <!--- Other Host Parent --->
                <cfif qGetHostFamilyInfo.otherHostParent NEQ "none">
                    <tr <cfif vSSNCurrentRow MOD 2> bgcolor="##deeaf3" </cfif> >
                        <td><h3>#qGetHostFamilyInfo.fatherFirstName# #qGetHostFamilyInfo.fatherlastname#</h3></td>
                        <td><h3><cfif qGetHostFamilyInfo.otherHostParent EQ "mother">Host Mother<cfelse>Host Father</cfif></h3></td>
                        <td><h3>#DateFormat(qGetHostFamilyInfo.fatherdob, 'mmm d, yyyy')#</h3></td>
                        <td><h3><cfif isDate(qGetHostFamilyInfo.fatherdob)>#DateDiff('yyyy', qGetHostFamilyInfo.fatherdob, now())#</cfif></h3></td> 
                        <td>
                            <cfif NOT LEN(qGetHostFamilyInfo.fatherSSN)>
                                <cfinput type="text" name="fatherSSN" value="#FORM.fatherSSN#" mask="999-99-9999" class="mediumField" maxlength="50">
                            <cfelse>
                                Submitted <!--- #FORM.fatherSSN# --->
                            </cfif>
                        </td>
                    </tr>
                    <cfscript>
                        // Increase value of current row
                        vSSNCurrentRow ++;
                    </cfscript>
                </cfif>
                		
            </table> <br />             
            
            <!--- Host Members --->
            <h3>Host Members(s)</h3>

            <table width="100%" cellspacing="0" cellpadding="4" class="border">
                <tr bgcolor="##deeaf3">
                    <th width="28%">Name</th>
                    <th width="17%">Relation</th>
                    <th width="20%">Date of Birth</th>
                    <th width="10%">Age Now</th>
                    
                    <th width="25%">Social Security ## <span class="required">*</span></h3></th>
                </tr>
                
                <cfif NOT qGetAllFamilyMembersAtHome.recordCount>
                	<tr <cfif qGetAllFamilyMembersAtHome.currentRow MOD 2> bgcolor="##deeaf3"</cfif> >
                    	<td colspan="5">There are no family members on file, if you would like to add a family member please click on "Family Members" on the left menu</td>
                    </tr>
                </cfif>            

                <cfloop query="qGetAllFamilyMembersAtHome">
                    <tr <cfif vSSNCurrentRow MOD 2 EQ 0> bgcolor="##deeaf3"</cfif> >
                        <td><h3>#qGetAllFamilyMembersAtHome.name# #qGetAllFamilyMembersAtHome.lastName#</h3></td>
                        <td><h3>#qGetAllFamilyMembersAtHome.membertype#</h3></td>
                        <td><h3><cfif isDate(qGetAllFamilyMembersAtHome.birthDate)>#DateFormat(qGetAllFamilyMembersAtHome.birthDate, 'mmm d, yyyy')#</cfif></h3></td>
                        <td><h3>#qGetAllFamilyMembersAtHome.age# </h3></td> 
                       
                        <cfif ListFind(vCBCQualifiedMembersList, qGetAllFamilyMembersAtHome.childID)>
                            <td>	
                                <cfif NOT LEN(qGetAllFamilyMembersAtHome.ssn)>
                                    <cfinput type="text" name="#qGetAllFamilyMembersAtHome.childID#memberSSN" value="#FORM[qGetAllFamilyMembersAtHome.childID & 'memberSSN']#" mask="999-99-9999" class="mediumField" maxlength="50">
                                <cfelse>
                                    Submitted <!--- #FORM[qGetAllFamilyMembersAtHome.childID & 'memberSSN']# --->
                                </cfif>
                            </td>                        	
                        <cfelse>
                            <td>Not required</td>
                        </cfif> 
                    </tr>            
                </cfloop>
                <tr>
                	<td colspan=5 bgcolor="##deeaf3"> <em>Background checks are required for anyone turning 18 on or before #DateFormat(qGetSeasonEndDate.endDate,'mm/dd/yyyy')#</em></td>
                </tr>
            </table> <br />
   
    		<!--- Singatures --->
            <h3>Signature(s)</h3>
            
            <p>
                I/We are submitting this authorization for a criminal background check on the above individuals.  
                Please use our typed name in place of a signature to initiate the background check process.<br />
            </p>
            
            <table width="100%" cellspacing="0" cellpadding="4" class="border">
                <tr bgcolor="##deeaf3">
                    <th>Name</th>
                    <th>Signature <span class="required">*</span></h3></th>
                </tr>
                
                <!--- Primary Host Parent --->
                <cfif LEN(qGetHostFamilyInfo.motherFirstName)>
                    <tr <cfif vSignatureCurrentRow MOD 2> bgcolor="##deeaf3" </cfif> >
                        <td><h3>#qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherlastname#</h3></td>
                        <td>
                            <cfif NOT qGetMotherCBCAuthorization.recordcount>
                                <input type="text" name="motherSignature" value="#FORM.motherSignature#" class="largeField"/>
                            <cfelse>
                            	<a href="publicDocument.cfm?ID=#qGetMotherCBCAuthorization.ID#&Key=#APPLICATION.CFC.DOCUMENT.generateHashID(qGetMotherCBCAuthorization.ID)#" target="_blank">Download Copy of Electronic Authorization</a>
                            </cfif>
                        </td>
                    </tr> 
                    <cfscript>
                        // Increase value of current row
                        vSignatureCurrentRow ++;
                    </cfscript>
                </cfif>
                
                <!--- Other Host Parent --->
                <cfif qGetHostFamilyInfo.otherHostParent NEQ "none">
                    <tr <cfif vSignatureCurrentRow MOD 2> bgcolor="##deeaf3" </cfif> >
                        <td><h3>#qGetHostFamilyInfo.fatherFirstName# #qGetHostFamilyInfo.fatherlastname#</h3></td>
                        <td>
                            <cfif NOT qGetFatherCBCAuthorization.recordcount>
                                <input type="text" name="fatherSignature" value="#FORM.fatherSignature#" class="largeField"/>
                            <cfelse>
                                <a href="publicDocument.cfm?ID=#qGetFatherCBCAuthorization.ID#&Key=#APPLICATION.CFC.DOCUMENT.generateHashID(qGetFatherCBCAuthorization.ID)#" target="_blank">Download Copy of Electronic Authorization</a>
                                <!--- <a href="#APPLICATION.CFC.SESSION.getHostSession().PATH.relativeDocs##qGetFatherCBCAuthorization.fileName#" target="_blank">View CBC Authoriaztion</a> --->
                            </cfif>
                        </td>                        
                    </tr>  
                    <cfscript>
                        // Increase value of current row
                        vSignatureCurrentRow ++;
                    </cfscript>
                </cfif>
                
                <!--- Host Member --->
                <cfloop query="qGetCBCQualifiedMembers">

                    <tr <cfif vSignatureCurrentRow MOD 2> bgcolor="##deeaf3" </cfif> >
                        <td><h3>#qGetCBCQualifiedMembers.name# #qGetCBCQualifiedMembers.lastName#</h3></td>
                        <td>
                      
                            <cfif NOT LEN(FORM[qGetCBCQualifiedMembers.childID & "documentID"])>
                                <input type="text" name="#qGetCBCQualifiedMembers.childID#memberSignature" value="#FORM[qGetCBCQualifiedMembers.childID & 'memberSignature']#" class="largeField" />
                            <cfelse>
                                <a href="publicDocument.cfm?ID=#FORM[qGetCBCQualifiedMembers.childID & 'documentID']#&Key=#APPLICATION.CFC.DOCUMENT.generateHashID(FORM[qGetCBCQualifiedMembers.childID & 'documentID'])#" target="_blank">Download Copy of Electronic Authorization</a>
                            </cfif>
							
                        </td>
                    </tr>
                    <cfscript>
                        // Increase value of current row
                        vSignatureCurrentRow ++;
                    </cfscript>
                    
                </cfloop>
    
            </table>
    
            <p>
                By providing this information and clicking on submit I do hereby authorize verification of all information in my application for involvement with the Exchange Program from 
                all necessary sources and additionally authorize any duly recognized agent of General Information Services, Inc. to obtain the said records and such disclosures.
            </p>
            
            <p>
                Information entered on this Authorization will be used exclusively by General Information Services, Inc. for identification purposes and for the release of information that will 
                be considered in determining any suitability for participation in the Exchange Program. 
            </p>
            
            <p>
                Upon proper identification and via a request submitted directly to General Information Services, Inc., I have the right to request from General Information Services, Inc. 
                information about the nature and substance of all records on file about me at the time of my request.  This may include the type of information requested as well as those who requested 
                reports from General Information Services, Inc.  within the two-year period preceding my request.
            </p>

			<!--- Check if FORM submission is allowed --->
            <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
                <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
                    <tr>
                        <td align="right">
                            <input name="Submit" type="image" src="images/buttons/BlkSubmit.png" border="0" onClick="this.form.submit(); this.disabled=true;">
                        </td>
                    </tr>
                </table>
			</cfif>
                        
            <p style="font-weight:bold;">
                As part of our background check, reports from several sources may be obtained.  Reports may include, but not be limited to, criminal history reports, Social Security verifications, 
                address histories, and Sex Offender Registries.  Should any results from the aforementioned reports indicate that driving history records will need to be reviewed during a more comprehensive 
                assessment, an additional authorization and release will be requested at that time.  
                You have a the right, upon written request, to complete and accurate disclosure of the nature and scope of the background check. 
            </p>
            
            <h3><u>Department Of State Regulations</u></h3>
            
            <p>
                &dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(7)</a></strong><br />
                <em>Verify that each member of the host family household 18 years of age and older, as well as any new adult member added to the household, or any member of the host family household who will turn eighteen years of age during the exchange student's stay in that household, has undergone a criminal background check (which must include a search of the Department of Justice's National Sex Offender Public Registry);</em>
            </p>            
            
        </cfform>

	</cfif>        
        
</cfoutput>