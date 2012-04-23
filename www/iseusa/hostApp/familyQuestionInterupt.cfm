
<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<cfparam name="submitForm" default=0>
<cfquery name="qHostParentsMembers" datasource="mysql">
select h.fatherfirstname, h.fatherdob, h.fatherlastname, h.motherfirstname, h.motherlastname, h.motherdob, h.fatherssn, h.motherssn
from smg_hosts h
where h.hostid = #client.hostid# 
</cfquery>
<cfquery name="qHostParentsCBC" datasource="mysql">
select cbc_type,  date_sent
from smg_hosts_cbc
where hostid = #client.hostid#
</cfquery>
<cfquery name="checkFatherCBC" dbtype="query">
select *
from qHostParentsCBC
where cbc_type = 'father'
</cfquery>
<cfquery name="checkMotherCBC" dbtype="query">
select *
from qHostParentsCBC
where cbc_type = 'mother'
</cfquery>
<cfquery name="qHostFamilyMembers" datasource="mysql">
select k.name, k.lastname, k.birthdate, k.cbc_form_received, k.childid, k.membertype, k.ssn, k.liveathome
from smg_host_children k
where k.hostid = #client.hostid# 
</cfquery>
<cfquery name="qActiveSeasons" datasource="mysql">
select s.seasonid, s.season 
from smg_seasons s
where active = 1
</cfquery>



<!--- Process Form Submission --->
    <cfif isDefined('FORM.processCBC')>
    
    	<!----Validate Father SSN, if needed---->
  		<cfif isDefined('form.fatherssn')>
    	    <cfscript>
            // Data Validation
			
			// Valid SSN
           if  ( LEN(TRIM(form.fatherssn)) NEQ 11) {
                // Get all the missing items in a list
               SESSION.formErrors.Add("The SSN for #form.fatherfirstname# does not appear to be a valid SSN. <br> Please make sure the SSN is entered in the 999-99-9999 format.");
           }	
		   if (not len(trim(form.fathersig))){
                // Get all the missing items in a list
               SESSION.formErrors.Add("The signature for #form.fatherfirstname# is missing");
           }	
		 </cfscript>
   		</cfif>	
        <!----Validate Mother ssn, if needed---->
        <cfif isDefined('form.motherssn')>
    	    <cfscript>
            // Data Validation
			
			// Valid SSN
           if  ( LEN(TRIM(form.motherssn)) NEQ 11) {
                // Get all the missing items in a list
               SESSION.formErrors.Add("The SSN for #form.motherfirstname# does not appear to be a valid SSN. <br> Please make sure the SSN is entered in the 999-99-9999 format.");
           }	
		   if (not len(trim(form.mothersig))){
                // Get all the missing items in a list
               SESSION.formErrors.Add("The signature for #form.motherfirstname# is missing");
           }
		 </cfscript>
   		</cfif>	
        <!----check to make sure that the person should have a background check run---->
        
        
        <Cfloop list="#famList#" index="x">
            <cfquery name="cbcCheck" datasource="mysql">
            select k.name, k.lastname, k.birthdate, k.cbc_form_received, k.childid, k.membertype, k.ssn, k.liveathome
            from smg_host_children k
            where k.childid = #x# 
            </cfquery>
            <Cfif isDefined('#form[x & "_ssn"]#')>
        	<Cfif #DateDiff('yyyy',cbcCheck.birthdate,now())# gte 18 and cbcCheck.liveathome is 'yes'>
            
				<cfscript>
                    // Data Validation
                    
                    // Valid SSN
                   if  ( LEN(TRIM(#form[x & "_ssn"]#)) NEQ 11) {
                        // Get all the missing items in a list
                       SESSION.formErrors.Add("The SSN for #form[x & "_name"]# does not appear to be a valid SSN. <br> Please make sure the SSN is entered in the 999-99-9999 format.");
                   }	
                    // Valid Signature
                   if  ( NOT LEN(TRIM(#form[x & "_sig"]#))) {
                        // Get all the missing items in a list
                       SESSION.formErrors.Add("The signature for #form[x & "_name"]# is missing.");
                   }	
                
                </cfscript>
        	</Cfif>
            </Cfif>
        </Cfloop>

        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
			<!--- the key for encrypting and decrypting the ssn. --->
            <cfset ssn_key = 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR'>
            <!----insert fathers ssn if defiend---->
            <Cfif isDefined('form.fatherssn')>
				 <cfset encfatherssn = encrypt("#trim(form.fatherssn)#", "#ssn_key#", "desede", "hex")>
                    <Cfquery name="insertFatherSSN" datasource="mysql">
                    update smg_hosts
                    set fatherSSN = '#encfatherssn#'
                    where hostid = #client.hostid#
                    </cfquery>
                      <cfif DirectoryExists('C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/')>
        				<cfelse>
           				 <cfdirectory action = "create" directory = "C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/" >
        				</cfif>
                    <cfdocument format="PDF" filename="C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/#form.fatherSig#cbcAuthorization.pdf" overwrite="yes">
                    <!--- form.pr_id and form.report_mode are required for the progress report in print mode.
                    form.pdf is used to not display the logo which isn't working on the PDF. --->
                    <cfset form.report_mode = 'print'>
                    <cfset form.pdf = 1>
                    <cfinclude template="completedCBCAuth.cfm">
                    <br /><Br />
                    <Cfoutput>
                    Electronically Signed<Br />
                    #form.fatherSig#<br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<Br />
                    IP: #cgi.REMOTE_ADDR# 
                    </Cfoutput>
                </cfdocument>    
             </Cfif>
             <!----Insert mothers ssn if defined---->
             <Cfif isDefined('form.motherssn')>
				 <cfset encmotherssn = encrypt("#trim(form.motherssn)#", "#ssn_key#", "desede", "hex")>
                    <Cfquery name="insertMotherSSN" datasource="mysql">
                    update smg_hosts
                    set motherSSN = '#encmotherssn#'
                    where hostid = #client.hostid#
                    </cfquery>
                    
				
                      <cfif DirectoryExists('C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/')>
        				<cfelse>
           				 <cfdirectory action = "create" directory = "C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/" >
        				</cfif>
                    <cfdocument format="PDF" filename="C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/#form.motherSig#_cbcAuthorization.pdf" overwrite="yes">
                    <!--- form.pr_id and form.report_mode are required for the progress report in print mode.
                    form.pdf is used to not display the logo which isn't working on the PDF. --->
                    <cfset form.report_mode = 'print'>
                    <cfset form.pdf = 1>
                    <cfinclude template="completedCBCAuth.cfm">
                    <br /><Br />
                    <Cfoutput>
                    Electronically Signed<Br />
                    #form.motherSig#<br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<Br />
                    IP: #cgi.REMOTE_ADDR# 
                    </Cfoutput>
                </cfdocument> 
             </Cfif>
              <Cfloop list="#famList#" index="x">
               <cfquery name="cbcCheck" datasource="mysql">
                select k.name, k.lastname, k.birthdate, k.cbc_form_received, k.childid, k.membertype, k.ssn, k.liveathome
                from smg_host_children k
                where k.childid = #x# 
                </cfquery>
        			<Cfif #DateDiff('yyyy',cbcCheck.birthdate,now())# gte 18 and cbcCheck.liveathome is 'yes'>
            
					 <cfset encssn = encrypt("#trim(form[x & "_ssn"])#", "#ssn_key#", "desede", "hex")>
                        <Cfquery name="insertkidsssn" datasource="mysql">
                        update smg_host_children
                        set ssn = '#encssn#'
                        where childid = #x#
                        </cfquery>
                     </Cfif>
                      
                      <cfif DirectoryExists('C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/')>
        				<cfelse>
           				 <cfdirectory action = "create" directory = "C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/" >
        				</cfif>
                    <cfdocument format="PDF" filename="C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/#form[x & "_sig"]#_cbcAuthorization.pdf" overwrite="yes">
                    <!--- form.pr_id and form.report_mode are required for the progress report in print mode.
                    form.pdf is used to not display the logo which isn't working on the PDF. --->
                    <cfset form.report_mode = 'print'>
                    <cfset form.pdf = 1>
                    <Cfset form.childid = #x#>
                    
                    <cfinclude template="completedCBCAuth.cfm">
                    <br /><Br />
                    <Cfoutput>
                    Electronically Signed<Br />
                    #form[x & "_sig"]#<br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<Br />
                    IP: #cgi.REMOTE_ADDR# 
                    </Cfoutput>
                </cfdocument> 
                
              	</Cfloop>
              <!----Udpate Lead Table that Application is in process---->
            <cfquery datasource="mysql">
            update smg_host_lead 
            set statusID = 8
            where email = '#client.hostemail#'
            </cfquery>
            
            <!----Begin Processing---->
            <!----Begin Processing---->
            <!----Begin Processing---->
            <!--- Kill extra output --->
           
                
                <cfsetting requesttimeout="9999">
            
        
                
                <cftry>
                    <!--- param variables --->
                    <cfparam name="hostID" type="numeric" default="#client.hostid#">
            
                    <!--- param FORM variables --->
                    <cfparam name="FORM.submitted" type="numeric" default="1">
                
                    <cfparam name="FORM.memberIDs" default="0">
                    
                   <cfif isDefined('form.motherssn')>
                        <cfparam name="FORM.mothercompanyID" default="1">
                        <cfparam name="FORM.motherSeasonID" default="#form.season#">
                        <cfparam name="FORM.motherdate_authorized" default="#now()#">
                        <cfparam name="FORM.motherIsNoSSN" default="0">
                    <cfelse>
                    	 <cfparam name="FORM.mothercompanyID" default="0">
       					 <cfparam name="FORM.motherSeasonID" default="0">
       					 <cfparam name="FORM.motherdate_authorized" default="">
      					 <cfparam name="FORM.motherIsNoSSN" default="0">
                    </cfif>
                    
                    <cfif isDefined('form.fatherssn')>
                    	<cfparam name="FORM.fathercompanyID" default="1">
                    	<cfparam name="FORM.fatherSeasonID" default="#form.season#">
                    	<cfparam name="FORM.fatherdate_authorized" default="#now()#">
                    	<cfparam name="FORM.fatherIsNoSSN" default="0">
                   	<cfelse>
                    	<cfparam name="FORM.fathercompanyID" default="">
                    	<cfparam name="FORM.fatherSeasonID" default="0">
                    	<cfparam name="FORM.fatherdate_authorized" default="">
                    	<cfparam name="FORM.fatherIsNoSSN" default="0">
                    </cfif> 
                    <cfcatch type="any">
                    
                        <cfscript>
                            // set default values
                            hostID = 0;
                            FORM.submitted = 0;
                        </cfscript>
                        
                    </cfcatch>
                </cftry>  
                
        
            <!----Don't Process CBC's yet---->
            
                <cfscript>
                    // Gets List of Companies
                    qGetCompanies = APPCFC.COMPANY.getCompanies();
                
                    // Gets Host Family Information
                    qGetHost = APPCFC.HOST.getHosts(hostID=hostID);
            
                    // Get Host Mother CBC
                    qGetCBCMother = APPCFC.CBC.getCBCHostByID(
                        hostID=hostID, 
                        cbcType='mother'
                    );
                    
                    // Get Mother Available Seasons
                    qGetMotherSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMother.seasonID));
                    
                    // Gets Host Father CBC
                    qGetCBCFather = APPCFC.CBC.getCBCHostByID(
                        hostID=hostID, 
                        cbcType='father'
                    );
                    
                    // Get Father Available Seasons
                    qGetFatherSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCFather.seasonID));
            
                    // Get Family Member CBC
                    qGetHostMembers = APPCFC.CBC.getEligibleHostMember(hostID=hostID);
            
                    // Set Variables
                    motherIDs = ValueList(qGetCBCMother.cbcfamID);
                    fatherIDs = ValueList(qGetCBCFather.cbcfamID);
                    memberIDs = ValueList(qGetHostMembers.childID);
                    
                    // Create Structure to store errors
                    Errors = StructNew();
                    // Create Array to store error messages
                    Errors.Messages = ArrayNew(1);
                </cfscript>
                
                <!--- Form Submitted --->
                <cfif VAL(FORM.submitted)>
            		
                    <cfscript>
                        // Check if we have valid data for host mother
                        if ( VAL(FORM.motherSeasonID) AND LEN(FORM.motherdate_authorized) ) {
                            // Insert Host Mother CBC
                            APPCFC.CBC.insertHostCBC(
                                hostID=FORM.hostID,
                                familyMemberID=0,
                                cbcType='mother',
                                seasonID=FORM.motherSeasonID, 
                                companyID=FORM.mothercompanyID,
                                dateAuthorized=FORM.motherdate_authorized,
                                isNoSSN=FORM.motherIsNoSSN
                            );		
                        }
                        
                        // Check if we have valid data for host father
                        if ( VAL(FORM.fatherSeasonID) AND LEN(FORM.fatherdate_authorized) ) {
                            // Insert Host Father CBC
                            APPCFC.CBC.insertHostCBC(
                                hostID=FORM.hostID,
                                familyMemberID=0,
                                cbcType='father',
                                seasonID=FORM.fatherSeasonID, 
                                companyID=FORM.fathercompanyID,
                                dateAuthorized=FORM.fatherdate_authorized,
                                isNoSSN=FORM.fatherIsNoSSN
                            );	
                        }
                    </cfscript>
                    
                    <!--- FAMILY MEMBERS --->
                    <cfif VAL(FORM.memberIDs)>
                    
                        <cfloop list="#FORM.memberIDs#" index="memberID">
                            
                            <!--- Param Form Variables / New Season --->
                            
                            <cfparam name="FORM.#memberID#companyID" default="1">
                            <cfparam name="FORM.#memberID#seasonID" default="#form.season#">
                            <cfparam name="FORM.#memberID#date_authorized" default="#now()#">
                            <cfparam name="FORM.#memberID#IsNoSSN" default="0">
                            
                            <cfscript>
                                // Check if we have valid data for family members
                                if ( VAL(FORM[memberID & 'seasonID']) AND LEN(FORM[memberID & 'date_authorized']) ) {
                                    // Insert Host Father CBC
                                    APPCFC.CBC.insertHostCBC(
                                        hostID=FORM.hostID,
                                        familyMemberID=memberID,
                                        cbcType='member',
                                        seasonID=FORM[memberID & 'seasonID'],
                                        companyID=FORM[memberID & 'companyID'],
                                        dateAuthorized=FORM[memberID & "date_authorized"],
                                        isNoSSN=FORM[memberID & "isNoSSN"]
                                    );	
                                }
                            </cfscript>
                            
                        </cfloop>
                        
                    </cfif>
                    
                    <!--- CBC FLAG/SSN HOST MOTHER 
                    <cfloop list="#FORM.motherIDs#" index="cbcID">
                        
                        <!--- Param Form Variables --->
                        <cfparam name="FORM.#cbcID#motherIsNoSSN" default="0">
                        
                        <cfscript>
                            // update Host Mother CBC Flag & SSN options
                            APPCFC.CBC.updateHostOptions(
                                cbcfamID=cbcID,
                                isNoSSN=FORM[cbcID & "motherIsNoSSN"],
                                flagCBC=0
                            );			
                        </cfscript>
            
                    </cfloop>
                    ---->
                    <!--- CBC FLAG/SSN HOST FATHER
                    <cfloop list="#FORM.fatherIDs#" index='cbcID'>
                    
                        <!--- Param Form Variables --->
                        <cfparam name="FORM.#cbcID#fatherIsNoSSN" default="0">
                        
                        <cfscript>
                            // update Host Father CBC Flag & SSN options
                            APPCFC.CBC.updateHostOptions(
                                cbcfamID=cbcID,
                                isNoSSN=FORM[cbcID & "fatherIsNoSSN"],
                                flagCBC=0
                            );			
                        </cfscript>
            
                    </cfloop>
                     ---->
                    <!--- CBC FLAG/SSN HOST MEMBERS ---->
                    <cfloop list="#FORM.memberIDs#" index='cbcID'>
                    
                        <!--- Param Form Variables --->
                        <cfparam name="FORM.#cbcID#memberCBCFamID" default="0">
                        <cfparam name="FORM.#cbcID#memberIsNoSSN" default="0">
            
                        <cfscript>
                            // update Host Member CBC Flag & SSN options
                            APPCFC.CBC.updateHostOptions(
                                cbcfamID=FORM[cbcID & "memberCBCFamID"],					
                                isNoSSN=FORM[cbcID & "memberIsNoSSN"],
                                flagCBC=0
                            );			
                        </cfscript>
                        
                    </cfloop>
                    
                    <!--- Submit Batch 10/20/2009 --->
                    <cfscript>
                        // Declare newBatchID
                        newBatchID = 0;
                        // Set errorCount used in data validation
                        errorCount = 0;
                        
                        // Get CBCs Host Parents Updated
                        qGetCBCHost = APPCFC.CBC.getPendingCBCHost(
                            companyID=CLIENT.companyID,
                            hostID=FORM.hostID,
                            userType='mother,father'
                        );	
            
                        // Get CBCs Host Members Updated
                        qGetCBCMember = APPCFC.CBC.getPendingCBCHostMember(
                            companyID=CLIENT.companyID,
                            hostID=FORM.hostID
                        );	
                    </cfscript>  
            
                    <!--- Submit CBC Host Parents --->
                    <cfloop query="qGetCBCHost">
                        
                        <cfscript>
                            // Set processCBC to 1, if error is found it is set to 0 and it does not validate.
                            processCBC = 1;
                        
                            // Data Validation
                            // First Name
                            if ( NOT LEN(Evaluate(qGetCBCHost.cbc_type & "firstname")) ) {
                                ArrayAppend(Errors.Messages, "Missing first name for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "lastname")# (###qGetCBCHost.hostid#).");			
                                processCBC = 0;
                            }
                            // Last Name
                            if ( NOT LEN(Evaluate(qGetCBCHost.cbc_type & "lastname")) )  {
                                ArrayAppend(Errors.Messages, "Missing last name for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "firstname")# (###qGetCBCHost.hostid#).");
                                processCBC = 0;
                            }
                            // DOB
                            if ( NOT LEN(Evaluate(qGetCBCHost.cbc_type & "dob")) OR NOT IsDate(Evaluate(qGetCBCHost.cbc_type & "dob")) )  {
                                ArrayAppend(Errors.Messages, "DOB is missing or is not a valid date for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "firstname")# #Evaluate(qGetCBCHost.cbc_type & "lastname")# (###qGetCBCHost.hostid#).");
                                processCBC = 0;
                            }
                            // SSN
                            if ( NOT VAL(qGetCBCHost.isNoSSN) AND NOT LEN(Evaluate(qGetCBCHost.cbc_type & "ssn")) )  {
                                ArrayAppend(Errors.Messages, "Missing SSN for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "firstname")# #Evaluate(qGetCBCHost.cbc_type & "lastname")# (###qGetCBCHost.hostid#).");
                                processCBC = 0;
                            }
                            
                            // Data Validation
                            if ( VAL(processCBC) ) {
            
                                // Get Company ID
                                qGetCompanyID = APPCFC.COMPANY.getCompanies(companyID=qGetCBCHost.companyID);
                            
                                // Process Batch
                                APPCFC.CBC.processBatch(
                                    companyID=qGetCBCHost.companyID,
                                    companyShort=qGetCompanyID.companyShort,
                                    userType=qGetCBCHost.cbc_type,
                                    hostID=qGetCBCHost.hostid,
                                    cbcID=qGetCBCHost.CBCFamID,
                                    // XML variables
                                    username=qGetCompanyID.gis_username,
                                    password=qGetCompanyID.gis_password,
                                    account=qGetCompanyID.gis_account,
                                    SSN=Evaluate(qGetCBCHost.cbc_type & 'ssn'),
                                    lastName=Evaluate(qGetCBCHost.cbc_type & 'lastname'),
                                    firstName=Evaluate(qGetCBCHost.cbc_type & 'firstname'),
                                    middleName=Left(Evaluate(qGetCBCHost.cbc_type & 'middlename'),1),
                                    DOBYear=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'yyyy'),
                                    DOBMonth=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'mm'),
                                    DOBDay=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'dd'),
                                    noSSN=qGetCBCHost.isNoSSN
                                );
            
                            }
                        </cfscript>
                    
                    </cfloop>
            
                    <!--- Submit CBC Host Member --->
                    <cfloop query="qGetCBCMember">
                        
                        <cfscript>
                            // Set processCBC to 1, if error is found it is set to 0 and it does not validate.
                            processCBC = 1;
                            
                            // Data Validation
                            if ( NOT LEN(qGetCBCMember.name) ) {
                                ArrayAppend(Errors.Messages, "Missing first name for #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");			
                                processCBC = 0;
                            }
                        
                            if ( NOT LEN(qGetCBCMember.lastname) )  {
                                ArrayAppend(Errors.Messages, "Missing last name for #qGetCBCMember.name# member of (###qGetCBCMember.hostid#).");
                                processCBC = 0;
                            }
                            
                            if ( NOT LEN(qGetCBCMember.birthdate) OR NOT IsDate(qGetCBCMember.birthdate) )  {
                                ArrayAppend(Errors.Messages, "Missing DOB for #qGetCBCMember.name# #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");
                                processCBC = 0;
                            }
                
                            if ( NOT VAL(qGetCBCMember.isNoSSN) AND NOT LEN(qGetCBCMember.ssn) )  {
                                ArrayAppend(Errors.Messages, "Missing SSN for #qGetCBCMember.name# #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");
                                processCBC = 0;
                            }
                        
                            // Data Validation
                            if ( VAL(processCBC) ) {
                                
                                // Get Company ID
                                qGetCompanyID = APPCFC.COMPANY.getCompanies(companyID=qGetCBCMember.companyID);
                            
                                // Process Batch
                                APPCFC.CBC.processBatch(
                                    companyID=qGetCompanyID.companyID,
                                    companyShort=qGetCompanyID.companyShort,
                                    userType='member',
                                    hostID=qGetCBCMember.hostid,
                                    cbcID=qGetCBCMember.CBCFamID,
                                    // XML variables
                                    username=qGetCompanyID.gis_username,
                                    password=qGetCompanyID.gis_password,
                                    account=qGetCompanyID.gis_account,
                                    SSN=qGetCBCMember.ssn,
                                    lastName=qGetCBCMember.lastName,
                                    firstName=qGetCBCMember.name,
                                    middleName=Left(qGetCBCMember.middleName,1),
                                    DOBYear=DateFormat(qGetCBCMember.birthdate, 'yyyy'),
                                    DOBMonth=DateFormat(qGetCBCMember.birthdate, 'mm'),
                                    DOBDay=DateFormat(qGetCBCMember.birthdate, 'dd'),
                                    noSSN=qGetCBCMember.isNoSSN
                                );	
            
                            }
                        </cfscript>
                                
                    </cfloop>
                
                    <cfscript>
                        // We are not refreshing the page in order to keep the error message information so refresh queries to get CBCs that were just ran.
                        
                        // Get Host Mother CBC
                        qGetCBCMother = APPCFC.CBC.getCBCHostByID(
                            hostID=hostID, 
                            cbcType='mother'
                        );
                        
                        // Get Mother Available Seasons
                        qGetMotherSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMother.seasonID));
                        
                        // Gets Host Father CBC
                        qGetCBCFather = APPCFC.CBC.getCBCHostByID(
                            hostID=hostID, 
                            cbcType='father'
                        );
                        
                        // Get Father Available Seasons
                        qGetFatherSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCFather.seasonID));
                
                        // Get Family Member CBC
                        qGetHostMembers = APPCFC.CBC.getEligibleHostMember(hostID=hostID);
                
                        // Set Variables
                        motherIDs = ValueList(qGetCBCMother.cbcfamID);
                        fatherIDs = ValueList(qGetCBCFather.cbcfamID);
                        memberIDs = ValueList(qGetHostMembers.childID);
                    </cfscript>
                    
                </cfif> <!--- VAL(FORM.submitted) --->
                                    
            
            
            
            
            
            <!------------------------>
            <!------------------------>
            <!------------------------>
            
            <!----
            <cflocation url="?page=familyInterests">
			---->
			
            <cflocation url="?page=familyInterests">
		</cfif>	

 </cfif>

<h2>Criminal Background Check</h2>
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
Due to Department of State Regulations&dagger;, criminal background checks will need to be run on the following persons.  Please provide the following information on each person so that we can complete the background check. <Br />
<Br />

<cfform method="post" action="?page=familyQuestionInterupt">

<cfoutput>
<input type="hidden" name="processCBC"/>
<input type="hidden" name="hostid" value="#client.hostid#" />
<input type="hidden" name="submitted" value="1" />

<h3>Family Members</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border">
   <Tr>
   	<Th>Name</Th><th>Relation</th><th>Date of Birth</th><th>Age</th><th>Social Security</th>
    </Tr>
   <Cfif qHostParentsMembers.recordcount eq 0>
    <tr>
    	<td>Currently, no family members require a backgroundcheck.</td>
    </tr>
    <cfelse>
    <Cfloop query="qHostParentsMembers">
    <cfif fatherfirstname is not ''>
        <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
            <Td><h3><p class=p_uppercase>#fatherfirstname# #fatherlastname#</h3></Td>
            <Td><h3><p class=p_uppercase>Host Father</h3></Td>
            <Td><h3>#DateFormat(fatherdob, 'mmm d, yyyy')#</h3></Td>
            <td><h3>#DateDiff('yyyy',fatherdob,now())#</h3></td> 
             <input type="hidden" value="#fatherfirstname#" name="fatherfirstname" />
            <td>
          	<cfif checkFatherCBC.recordcount eq 0>
            	<cfinput type="text"  name="fatherssn"  mask="999-99-9999" size=12 typeahead="no" showautosuggestloadingicon="true" value="#fatherssn#">
                <cfset submitForm = 1>
      		<cfelse>
            	Request Submitted
            </cfif>
            </td>
      </tr>
    </cfif>
    <cfif motherfirstname is not ''>
        <tr >
            <Td><h3><p class=p_uppercase>#motherfirstname# #motherlastname#</h3></Td>
            <Td><h3><p class=p_uppercase>Host Mother</h3></Td>
            <Td><h3>#DateFormat(motherdob, 'mmm d, yyyy')#</h3></Td>
            <td><h3>#DateDiff('yyyy',motherdob,now())#</h3></td> 
           <input type="hidden" value="#motherfirstname#" name="motherfirstname" />
           
            <td>
            <cfif checkMotherCBC.recordcount eq 0>
            	<cfinput type="text"  name="motherssn"  mask="999-99-9999" size=12 typeahead="no" showautosuggestloadingicon="true" value="#motherssn#">
                <cfset submitForm = 1>
      		<cfelse>
            	Request Submitted
            </cfif>
            </td>

        </tr>
    </cfif>
    </Cfloop>
    <tr>
    	<Td colspan=7><hr width=60% align="center"></Td>
    </tr>
    <cfset famMembersList =''>
    <Cfloop query="qHostFamilyMembers">
    <Cfif #DateDiff('yyyy',birthdate,now())# gte 18>
		<cfset famMembersList = #ListAppend(famMembersList,#qHostFamilyMembers.childid#)#>
	</Cfif>
        <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
            <Td><h3><p class=p_uppercase>#name# #lastname#</h3></Td>
            <td><h3><p class=p_uppercase>#membertype#</h3></td>
            <Td><h3>#DateFormat(birthdate, 'mmm d, yyyy')#</h3></Td>
            <td><h3>#DateDiff('yyyy',birthdate,now())#</h3></td> 
			<Cfif #DateDiff('yyyy',birthdate,now())# gte 18 and liveathome is 'yes'>
                
                <td>
                <input type="hidden" name="#qHostFamilyMembers.childid#_name" value="#name#" />
              <Cfif ssn is not ''>
              	Request Submitted
              <cfelse>
                <cfinput type="text" name="#qHostFamilyMembers.childid#_ssn" mask="999-99-9999" size=12 typeahead="no"  showautosuggestloadingicon="true" value="#ssn#">
                <cfset submitForm = 1></td>
              </Cfif>	
            <cfelse>
                <td colspan=2 >Background check is not required for #name#.</td>
            </Cfif> 
        </tr>

    </Cfloop>
    <input type="hidden" name="famList" value="#famMembersList#" />
    </cfif>
   </table>
<h3>Season</h3>
	<table width=100% cellspacing=0 cellpadding=2 class="border">
   <Tr  bgcolor="##deeaf3">
   	<Th align="center">I/We are submitting this authorization for a criminal background check on the above individuals.  Please use our typed name in place of a signature to initiate the background check process.<br />
    
    </th>
    
    </Tr>
    <tr  bgcolor="##deeaf3">
    
    	<td >
        <table align="center">
        	<Cfloop query="qHostParentsMembers">
            <cfif fatherfirstname is not ''>
            <tr>
                <Td><h3><p class=p_uppercase>#fatherfirstname# #fatherlastname#</h3></Td>
                <Td>
                <cfif checkFatherCBC.recordcount eq 0>
                	<input type="text" name="FatherSig" size=20/></Td>
                <cfelse>
            		Request Submitted
            	</cfif>
            </tr>    
            </cfif>
            <cfif motherfirstname is not ''>
            <tr>
                <Td><h3><p class=p_uppercase>#motherfirstname# #motherlastname#</h3></Td>
                <Td>
                <cfif checkMotherCBC.recordcount eq 0>
                	<input type="text" name="MotherSig" size=20/>
                <cfelse>
            		Request Submitted
            	</cfif>
                </Td>
            </tr>    
            </cfif>
            </cfloop>
            <Cfloop query="qHostFamilyMembers">
				<Cfif #DateDiff('yyyy',birthdate,now())# gte 18 and liveathome is 'yes'>
                    <tr>
                		<Td><h3><p class=p_uppercase>#name# #lastname#</p></h3></Td><td>
                        <Cfif ssn is not ''>
                        Request Submitted
                        <cfelse>
                        <input type="text" name="#qHostFamilyMembers.childid#_sig" />
                        </Cfif>
                        </td>
                    </tr>
                </Cfif>
			</Cfloop>
        	</table>
        </td>
     </tr>
    </table>
</cfoutput>

<p>&nbsp;</p>
<p><Br />
</p>
<p>By providing this information and clicking on submit I do hereby authorize verification of all information in my application for involvement with the Exchange Program from all necessary sources and additionally authorize any duly recognized agent of General Information Services, Inc. to obtain the said records and such disclosures.</p>
<p>Information entered on this Authorization will be used exclusively by General Information Services, Inc. for identification purposes and for the release of information that will be considered in determining any suitability for participation in the Exchange Program. </p>
<p>Upon proper identification and via a request submitted directly to General Information Services, Inc., I have the right to request from General Information Services, Inc. information about the nature and substance of all records on file about me at the time of my request.  This may include the type of information requested as well as those who requested reports from General Information Services, Inc.  within the two-year period preceding my request.</p>
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right">
        
        <cfif submitForm eq 0>
        <a href="?page=familyInterests"><img src="../images/buttons/submitBlue.png" border=0 /></a>
        <cfelse>
        <input name="Submit" type="image" src="../images/buttons/submitBlue.png" border=0>
        </cfif>
        </td>
	</tr>
</table>
</cfform>
<p><b>As part of our background check, reports from several sources may be obtained.  Reports may include, but not be limited to, criminal history reports, Social Security verifications, address histories,and Sex Offender Registries.  Should any results from the aforementioned reports indicate that driving history records will need to be reviewed during a more comprehensive assessment, an additional authorization and release will be requested at that time.  You have a the right, upon written request, to complete and accurate disclosure of the nature and scope of the background check. 
</b></p>

<h3><u>Department Of State Regulations</u></h3>
<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(7)</a></strong><br />
<em> Verify that each member of the host family household 18 years of age and older, as well as any new adult member added to the household, or any member of the host family household who will turn eighteen years of age during the exchange student's stay in that household, has undergone a criminal background check (which must include a search of the Department of Justice's National Sex Offender Public Registry);</em>

<br /><br />
<!---
<h3>Great!  Your done with the fast, simple questions. Now we need to get to know your family a little better.  The next few pages include questions that are key items we use to find kids that will ultimately fit best with your family. </h3>
<br />
<div align="center"><a href="index.cfm?page=familyInterests">Lets get started....</a></div>
---->
