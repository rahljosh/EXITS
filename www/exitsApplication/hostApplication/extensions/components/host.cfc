<!--- ------------------------------------------------------------------------- ----
	
	File:		host.cfc
	Author:		Marcus Melo
	Date:		October, 09 2009
	Desc:		This holds the functions needed for the host families
	
	Update: 
	
----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="host"
	output="false" 
	hint="A collection of functions for the host">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="host" output="false" hint="Returns the initialized Host object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getCompleteHostInfo" access="public" returntype="query" output="false" hint="Gets a list with hosts, if HostID is passed gets a Host by ID">
    	<cfargument name="hostID" default="" hint="HostID is not required">
        
        <cfquery 
			name="qGetCompleteHostInfo" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT DISTINCT
                	*,
                     <!--- Total Family At Home --->
                    (isFatherHome + isMotherHome + totalChildrenAtHome) AS totalFamilyMembers,
                    <!--- Regional Manager Info --->
                    rm.userID AS regionalManagerID,
                    (
                        CASE 
                            WHEN 
                                regionalManagerID IS NULL
                            THEN 
                                "Not Assigned"
                            ELSE 
                            	CAST(CONCAT(rm.firstName, ' ', rm.lastName) AS CHAR)
                                <!--- CAST(CONCAT(rm.firstName, ' ', rm.lastName,  ' (##', rm.userID, ')' ) AS CHAR) --->
                            END
                    ) AS regionalManager,
                    rm.email AS regionalManagerEmail
                FROM
                (
                    SELECT
                        h.*,
                        <!--- Host Family Display Name --->
                        CAST( 
                            CONCAT(                      
                                h.familyLastName,
                                ' - ', 
                                IFNULL(h.fatherFirstName, ''),                                                  
                                IF (h.fatherFirstName != '', IF (h.motherFirstName != '', ' and ', ''), ''),
                                IFNULL(h.motherFirstName, ''),
                                ' (##',
                                h.hostID,
                                ')'                    
                            ) 
                        AS CHAR) AS displayHostFamily,
                        <!--- Is father home? --->
                        (
                            CASE 
                                WHEN 
                                    h.fatherFirstName != '' 
                                THEN 
                                    1
                                WHEN 	
                                    h.fatherFirstName = ''  
                                THEN 
                                    0
                            END
                        ) AS isFatherHome,
                        <!--- Is mother home? --->
                        (
                            CASE 
                                WHEN 
                                    h.motherFirstName != '' 
                                THEN 
                                    1
                                WHEN 	
                                    h.motherFirstName = ''  
                                THEN 
                                    0                               
                            END
                        ) AS isMotherHome,
                        <!--- Total of Children at home --->
                        (
                            SELECT 
                                COUNT(shc.childID) 
                            FROM 
                                smg_host_children shc
                            WHERE
                                shc.hostID = h.hostID
                            AND
                                shc.liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                            AND	
                                shc.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        ) AS totalChildrenAtHome,
                        <!--- Region --->
                        (
                            CASE 
                                WHEN 
                                    r.regionID > 0
                                THEN 
                                    r.regionName 
                                ELSE 
                                    "Not Assigned"
                            END
                        ) AS regionName,
                        <!--- Get Regional Manager ID --->
                        (
                            SELECT 
                                rm.userID
                            FROM
                                smg_users rm
                            INNER JOIN
                                user_access_rights uarRM ON uarRM.userID = rm.userID
                            WHERE 
                                rm.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                            AND 
                                uarRM.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                            AND 
                                uarRM.regionID = r.regionID
                            LIMIT 1 
                        ) AS regionalManagerID,
						<!--- Regional Advisor Info --->
                        ra.userID AS regionalAdvisorID,
                        (
                            CASE 
                                WHEN 
                                    ra.userID IS NULL
                                THEN 
                                    "n/a"
                                ELSE 
                                	CAST(CONCAT(ra.firstName, ' ', ra.lastName) AS CHAR)
                                END
                        ) AS regionalAdvisor,
                        ra.email AS regionalAdvisorEmail,
                        <!--- Area Representative Info --->
                        ar.userID AS areaRepresentativeID,
                        (
                            CASE 
                                WHEN 
                                    ar.userID IS NULL
                                THEN 
                                    "Not Assigned"
                                ELSE 
                                	CAST(CONCAT(ar.firstName, ' ', ar.lastName) AS CHAR)
                            END
                        ) AS areaRepresentative,
                        ar.email AS areaRepresentativeEmail,
                        ar.email AS areaRepEmail,
                        ar.phone AS areaRepPhone,
                        ar.work_phone AS areaRepWorkPhone,
                        <!--- Facilitator --->
                        fac.userID AS facilitatorID,
                        (
                            CASE 
                                WHEN 
                                    fac.userID IS NULL
                                THEN 
                                    "Not Assigned"
                                ELSE 
                                    CAST(CONCAT(fac.firstName, ' ', fac.lastName) AS CHAR)
                            END
                        ) AS facilitator,
                        fac.email AS facilitatorEmail	                        
                    FROM 
                        smg_hosts h
                    <!--- Region --->
                    LEFT OUTER JOIN
                        smg_regions r ON r.regionID = h.regionID
                    <!--- Area Representative --->
                    LEFT OUTER JOIN
                        smg_users ar ON ar.userID = h.areaRepID
                    LEFT OUTER JOIN
                        user_access_rights uar ON uar.userID = ar.userID
                            AND
                                h.regionID = uar.regionID
					<!--- Regional Advisor Info --->
                    LEFT OUTER JOIN
                        smg_users ra ON ra.userID = uar.advisorID
					<!--- Facilitator --->
                    LEFT OUTER JOIN
                        smg_users fac ON fac.userID = r.regionFacilitator
                    WHERE
                        h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                    
				) AS tmpTable     

				<!--- Regional Manager Info --->
                LEFT OUTER JOIN
                    smg_users rm ON rm.userID = regionalManagerID
                             
                ORDER BY 
                    regionName,
                    familyLastName
		</cfquery>
		   
		<cfreturn qGetCompleteHostInfo>
	</cffunction>


	<cffunction name="getHostMemberByID" access="public" returntype="query" output="false" hint="Gets a host member by ID">
    	<cfargument name="childID" default="" hint="Child ID is not required">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="liveAtHome" default="" hint="liveAtHome is not required">
        <cfargument name="getAllMembers" default="0" hint="Returns all family members including deleted">
        <cfargument name="getCBCQualifiedMembers" default="" hint="Returns all qualified members to run CBCs, any one turning 18 in the next 18 months">
        
        <cfquery 
			name="qGetHostMemberByID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					childID,
                    hostID,
                    memberType,
                    birthDate,
                    FLOOR(datediff (now(), birthDate)/365) AS age,
                    sex,
                    liveAtHome,
                    name,
                    middleName,
                    lastName,
                    SSN,
                    cbc_form_received,
                    shared,
                    roomShareWith,
                    school,
                    liveAtHomePartTime,
                    interests,
                    employer,
                    gradeInSchool,
                    schoolActivities,
                    isDeleted
                FROM 
                    smg_host_children
                WHERE
                	1 = 1
                
                <cfif NOT VAL(ARGUMENTS.getAllMembers)>    
                    AND
	                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">    
                </cfif>
                
                <cfif LEN(ARGUMENTS.childID)>
                    AND
                        childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.childID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>

                <cfif LEN(ARGUMENTS.liveAtHome)>
                    AND
                        liveAtHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.liveAtHome#">
                </cfif>
                
                <!--- Gets any family member that are turning 18 in the next 18 months and live at home --->
                <cfif LEN(ARGUMENTS.getCBCQualifiedMembers)>
                    AND
                        FLOOR(DATEDIFF(DATE_ADD(CURRENT_DATE, INTERVAL 18 MONTH), birthdate)/365) >= <cfqueryparam cfsqltype="cf_sql_integer" value="18">
                    AND
                        liveAtHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                </cfif>
                
		</cfquery>
		   
		<cfreturn qGetHostMemberByID>
	</cffunction>


	<cffunction name="getHostPets" access="public" returntype="query" output="false" hint="Gets a host pets by ID">
    	<cfargument name="animalID" default="" hint="animalID is not required">
        <cfargument name="hostID" default="" hint="HostID is not required">
        
        <cfquery 
			name="qGetHostPets" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					*
                FROM 
                    smg_host_animals
                WHERE
                	1 = 1
                
                <cfif LEN(ARGUMENTS.animalID)>
                    AND
                        animalID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.animalID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>

		</cfquery>
		   
		<cfreturn qGetHostPets>
	</cffunction>
    
    
	<cffunction name="getHostReferences" access="public" returntype="query" output="false" hint="Gets a list of references">
        <cfargument name="hostID" default="#APPLICATION.CFC.SESSION.getHostSession().ID#" hint="HostID is not required">
        <cfargument name="refID" default="" hint="refID is not required">
        
        <cfquery 
			name="qGetHostReferences" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT 
                    *
                FROM 
                    smg_host_reference
                WHERE 
                    referenceFor = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                
				<cfif LEN(ARGUMENTS.refID)>
                    AND
                        refID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.refID)#">
                </cfif>
                
		</cfquery>
		   
		<cfreturn qGetHostReferences>
	</cffunction>
    

    <cffunction name="getApplicationProcess" access="public" returntype="struct" output="false" hint="Gets application process status">
        <cfargument name="hostID" default="#APPLICATION.CFC.SESSION.getHostSession().ID#" hint="HostID is not required">
    
        <cfquery name="qGetAppSections" datasource="#APPLICATION.DSN.Source#">
                SELECT
                    ap.section,
                    ap.description,
                    ap.appMenuColor,
                    (
                        CASE 
                            WHEN 
                                h.areaRepNotes != '' 
                            THEN 
                                h.areaRepNotes
                            WHEN 
                                h.regionalAdvisorNotes != '' 
                            THEN 
                                h.regionalAdvisorNotes
                            WHEN 
                                h.regionalManagerNotes != '' 
                            THEN 
                                h.regionalManagerNotes
                            WHEN 
                                h.facilitatorNotes != '' 
                            THEN 
                                h.facilitatorNotes
                        END
                    ) AS notes                    
                FROM 
                    smg_host_app_section ap
                LEFT OUTER JOIN	
                    smg_host_app_history h ON h.itemID = ap.ID                  
                    AND
                        h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                    AND
                        h.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(APPLICATION.CFC.SESSION.getHostSession().seasonID)#">
                WHERE
                	ap.appMenuColor != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                AND
                	ap.ID 
                    	BETWEEN 
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="2">
                    	AND 
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="13">
                ORDER BY
                	ap.listOrder
        </cfquery>

        <cfquery name="qGetReferences" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                *
            FROM 
                smg_host_reference
            WHERE 
                referenceFor = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
        </cfquery>
        
		<cfscript>
			var qGetDeniedSections = getDeniedSections();
			
			// Stores all the denied sections in a list
			var vDeniedSectionList = ValueList(qGetDeniedSections.section);
			
			// Get Host Family Information
			var qGetHostFamilyInfo = getCompleteHostInfo(hostID=VAL(ARGUMENTS.hostID));
			
			// Get Host Family Members
			var qGetFamilyMembers = getHostMemberByID(hostID=ARGUMENTS.hostID);
			
			// Get Host Family Members
			var qGetFamilyMembersAtHome = getHostMemberByID(hostID=ARGUMENTS.hostID,liveAtHome="yes");
			
			// Get Host Family Members at Home
			var qGetCBCQualifiedMembers = APPLICATION.CFC.HOST.getHostMemberByID(hostID=APPLICATION.CFC.SESSION.getHostSession().ID,getCBCQualifiedMembers=1);	
			
			// Father CBC Authorization
			var qGetFatherCBCAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
				foreignTable="smg_hosts",																		   
				foreignID=APPLICATION.CFC.SESSION.getHostSession().ID, 
				documentTypeID=APPLICATION.DOCUMENT.hostFatherCBCAuthorization, 
				seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID
			);
			
			// Mother CBC Authorization
			var qGetMotherCBCAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
				foreignTable="smg_hosts",																   	
				foreignID=APPLICATION.CFC.SESSION.getHostSession().ID, 
				documentTypeID=APPLICATION.DOCUMENT.hostMotherCBCAuthorization, 
				seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID
			);

			// Store results into a struct
			var stResults = StructNew();
			
			// Application Process (300 is the width of the bar so each of the 12 sections has a 25 value)
            stResults.applicationProgress = 0;
   		    stResults.isComplete = false;
			
			// Create an array so we can sort
			stResults.section = ArrayNew(1);
			
			// Set a struct for each section
			for ( i=1; i LTE qGetAppSections.recordCount; i++ ) {
				
				// Create Structure for each section
				stResults.section[i] = structNew();
				// Set Section Description
				stResults.section[i].link = qGetAppSections.section[i];
				// Set Section Description
				stResults.section[i].description = qGetAppSections.description[i];
				
				// Check if section has been denied
				if ( ListFindNoCase(vDeniedSectionList, qGetAppSections.section[i]) ) {
					// Section Denied
					stResults.section[i].isDenied = true;
					stResults.section[i].notes = qGetAppSections.notes[i];
				} else {
					stResults.section[i].isDenied = false;	
					stResults.section[i].notes = "";
				}
			
			}
			

			/********************************************
				1 - Contact Info 
			********************************************/

			// Family Last Name
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.familylastname)) ) {
                SESSION.formErrors.Add("Please enter your family last name.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.address)) ) {
                SESSION.formErrors.Add("Your home address is not valid.");
            }	

			// City
            if (NOT LEN(TRIM(qGetHostFamilyInfo.city)) ) {
                SESSION.formErrors.Add("You need to indicate which city your home is located in.");
            }	

			// State
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.state)) ) {
                SESSION.formErrors.Add("Please indicate which state your home is located in.");
            }	

			// Zip
            if ( NOT isValid("zipcode", TRIM(qGetHostFamilyInfo.zip)) ) {
                SESSION.formErrors.Add("The zip code for home address is not a valid zip code.");
				qGetHostFamilyInfo.zip = "";
            }	

			// Ethnicity
			if ( NOT LEN(TRIM(qGetHostFamilyInfo.race)) ) {
				SESSION.formErrors.Add("Please indicate your family's ethnicity.");
			}
			
			// Ethnicity
			if ( TRIM(qGetHostFamilyInfo.race) EQ 'other' AND NOT LEN(TRIM(qGetHostFamilyInfo.ethnicityOther)) ) {
				SESSION.formErrors.Add("Please indicate other ethnicity.");
			}

			// Primary Language
			if ( NOT LEN(TRIM(qGetHostFamilyInfo.primaryLanguage)) ) {
				SESSION.formErrors.Add("Please indicate what is the primary language spoken in your home.");
			}

			// Functioning Business
            if ( NOT LEN(qGetHostFamilyInfo.homeIsFunctBusiness) ) {
                SESSION.formErrors.Add("Please indicate if your home is also a functioning business.");
			}
			
			// No business Des
            if (( qGetHostFamilyInfo.homeIsFunctBusiness EQ 1) AND NOT LEN(TRIM(qGetHostFamilyInfo.homeBusinessDesc)) )  {
                SESSION.formErrors.Add("You have indicated that your home is also a business, but have not provided details on the type of business.");
			}
			
			// Mailing Address
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.mailaddress)) ) {
                SESSION.formErrors.Add("Please indicate your mailing address.");
            }	

			// Mailing City
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.mailcity)) ) {
                SESSION.formErrors.Add("Please indicate your mailing address city.");
            }	

			// Mailing State
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.mailstate)) ) {
                SESSION.formErrors.Add("Please indicate your mailing address state.");
            }	

			// Mailing Zip
            if ( NOT isValid("zipcode", TRIM(qGetHostFamilyInfo.mailzip)) ) {
                SESSION.formErrors.Add("The zip code for mailing address is not a valid zip code.");
				qGetHostFamilyInfo.mailzip = "";
            }	
	
			// Phones
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.phone)) AND NOT LEN(TRIM(qGetHostFamilyInfo.father_cell)) AND NOT LEN(TRIM(qGetHostFamilyInfo.mother_cell)) ) {
                SESSION.formErrors.Add("Please enter one of the Phone fields: Home, Father Cell or Mother Cell");
            }	
	
			// Valid Phone
            if ( LEN(TRIM(qGetHostFamilyInfo.phone)) AND NOT isValid("telephone", TRIM(qGetHostFamilyInfo.phone)) ) {
                SESSION.formErrors.Add("The home phone number you have entered does not appear to be valid. ");
            }	

			// Email Address
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.email)) ) {
                SESSION.formErrors.Add("Please provide an email address.");
            }	

			// Valid Email Address
            if ( LEN(TRIM(qGetHostFamilyInfo.email)) AND NOT isValid("email", TRIM(qGetHostFamilyInfo.email)) ) {
                SESSION.formErrors.Add("The email address you have entered does not appear to be valid.");
            }	
			
			/*
			// Valid Password
            if ( LEN(TRIM(qGetHostFamilyInfo.password)) LT 6) {
                SESSION.formErrors.Add("Your password must be at least 6 characters long.");
            }	
			*/
			
			// Check for last name
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.fatherlastname)) AND NOT LEN(TRIM(qGetHostFamilyInfo.motherlastname)) )  {
                SESSION.formErrors.Add("If you are single, you must provide information for at least one of the host parents, either the father or mother. If you are not single, please provide information on both host parents.");
			}

			// Check if there is a father
			if ( LEN(TRIM(qGetHostFamilyInfo.fatherFirstName)) ) {

				// Father DOB 
				if ( NOT LEN(TRIM(qGetHostFamilyInfo.fatherDOB)) )  {
					SESSION.formErrors.Add("Please provide date of birth for the Host Father.");
				}
				
				// Father DOB 
				if ( LEN(TRIM(qGetHostFamilyInfo.fatherDOB)) AND NOT isDate(TRIM(qGetHostFamilyInfo.fatherDOB)) )  {
					SESSION.formErrors.Add("Please provide a valid date of birth for Host Father.");
					qGetHostFamilyInfo.fatherDOB = '';
				}

				// Calculate Age
				if ( isDate(qGetHostFamilyInfo.fatherDOB) ) {
					vCalculateFatherAge = Datediff('yyyy',qGetHostFamilyInfo.fatherDOB, now());
				} else {
					vCalculateFatherAge = 0;
				}

				// Birthdate
				//if ( vCalculateFatherAge LTE 18 ) {
				//	SESSION.formErrors.Add("The host father date of birth indicates he is 18 years old. Please check host fathers's date of birth.");				
				//}	

				// Birthdate
				if ( vCalculateFatherAge GT 120 ) {
					SESSION.formErrors.Add("The host father date of birth indicates he is over 120 years old. Please check host father's date of birth.");				
				}	
				
				// Birthdate
				if ( isDate(qGetHostFamilyInfo.fatherDOB) AND qGetHostFamilyInfo.fatherDOB GT now() ) {
					SESSION.formErrors.Add("The host father date of birth indicates he has not been born yet. Please check host father's date of birth.");				
				}	
				
				// Father Education Level 
				if ( NOT LEN(qGetHostFamilyInfo.fatherEducationLevel) )  {
					SESSION.formErrors.Add("Please provide the highest education lever for Host Father.");
				}
				
				// Father Occupation
				if ( NOT LEN(TRIM(qGetHostFamilyInfo.fatherworktype)) )  {
					SESSION.formErrors.Add("Please provide the occupation for the Host Father.");
				}
				
				// Father Full/part time
				if ( LEN(TRIM(qGetHostFamilyInfo.fatherworktype)) AND NOT LEN (qGetHostFamilyInfo.fatherfullpart) ) {
					SESSION.formErrors.Add("You provided a job for the host father, but didn't indicate if you work full or part time.");
				}
				
				// Father Employer
				if ( LEN(TRIM(qGetHostFamilyInfo.fatherworktype)) AND NOT LEN(TRIM(qGetHostFamilyInfo.fatherEmployeer)) ) {
					SESSION.formErrors.Add("You provided a job for the host father, but didn't indicate the employer.");
				}

				// Valid Father's Phone
				if ( LEN(TRIM(qGetHostFamilyInfo.father_cell)) AND NOT isValid("telephone", TRIM(qGetHostFamilyInfo.father_cell)) ) {
					SESSION.formErrors.Add("Please enter a valid phone number for the Father's Cell Phone.");
				}	

				// Father Interests
				if ( NOT LEN(TRIM(qGetHostFamilyInfo.fatherInterests)) ) {
					SESSION.formErrors.Add("Please provide interests for host father");
				}

			}
			
			// Check if there is a mother
			if ( LEN(TRIM(qGetHostFamilyInfo.motherFirstName)) ) {
				
				// Mother DOB 
				if ( NOT LEN(TRIM(qGetHostFamilyInfo.motherDOB)) )  {
					SESSION.formErrors.Add("Please provide date of birth for the Host Mother.");
				}
				
				// Mother DOB 
				if ( LEN(TRIM(qGetHostFamilyInfo.motherDOB)) AND NOT isDate(TRIM(qGetHostFamilyInfo.motherDOB)) )  {
					SESSION.formErrors.Add("Please provide a valid date of birth for Host Mother.");
					qGetHostFamilyInfo.motherDOB = '';
				}

				// Calculate Age
				if ( isDate(qGetHostFamilyInfo.motherDOB) ) {
					vCalculateMotherAge = Datediff('yyyy',qGetHostFamilyInfo.motherDOB, now());
				} else {
					vCalculateMotherAge = 0;
				}

				// Birthdate
				//if ( vCalculateMotherAge LTE 18 ) {
				//	SESSION.formErrors.Add("The host mother date of birth indicates she is 18 years old. Please check host mother's date of birth.");				
				//}	

				// Birthdate
				if ( vCalculateMotherAge GT 120 ) {
					SESSION.formErrors.Add("The host mother date of birth indicates she is over 120 years old. Please check host mother's date of birth.");				
				}	
				
				// Birthdate
				if ( isDate(qGetHostFamilyInfo.motherDOB) AND qGetHostFamilyInfo.motherDOB GT now() ) {
					SESSION.formErrors.Add("The host mother date of birth indicates she has not been born yet. Please check host mother's date of birth.");				
				}	

				// Mother Education Level 
				if ( NOT LEN(qGetHostFamilyInfo.motherEducationLevel) )  {
					SESSION.formErrors.Add("Please provide the highest education lever for Host Mother.");
				}
				
				// Mother Occupation
				if ( NOT LEN(TRIM(qGetHostFamilyInfo.motherworktype)) )  {
					SESSION.formErrors.Add("Please provide the occupation for the Host Mother.");
				}
				
				// Mother Full/Part Time
				if ( NOT LEN(qGetHostFamilyInfo.motherfullpart) ) {
					SESSION.formErrors.Add("You provided a job for the host mother, but didn't indicate if you work full or part time.");
				}
				
				// Mother Employer
				if ( NOT LEN(TRIM(qGetHostFamilyInfo.motherEmployeer)) ) {
					SESSION.formErrors.Add("You provided a job for the host mother, but didn't indicate the employer.");
				}

				// Valid Mother's Phone
				if ( LEN(TRIM(qGetHostFamilyInfo.mother_cell)) AND NOT isValid("telephone", TRIM(qGetHostFamilyInfo.mother_cell)) ) {
					SESSION.formErrors.Add("Please enter a valid phone number for Mother's Cell Phone");
				}

				// Mother Interests
				if ( NOT LEN(TRIM(qGetHostFamilyInfo.motherInterests)) ) {
					SESSION.formErrors.Add("Please provide interests for host mother");
				}
			
			}
    
            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[1].isComplete = true;
				stResults.section[1].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[1].isComplete = false;
				stResults.section[1].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }
			

			/********************************************
				2 - Family Members 
			********************************************/
			
			// Loop through query
			for( x=1; x LTE qGetFamilyMembers.recordCount; x++ ) {
				
                // First Name
                if ( NOT LEN(TRIM(qGetFamilyMembers.name[x])) ) {
                    SESSION.formErrors.Add("Please enter the first name for #qGetFamilyMembers.name[x]#.");
                }			
				
				// Last Name
                if ( NOT LEN(TRIM(qGetFamilyMembers.lastName[x])) ) {
                    SESSION.formErrors.Add("Please enter the last name for #qGetFamilyMembers.name[x]#.");
                }			
				
				// Gender
                if ( NOT LEN(TRIM(qGetFamilyMembers.sex[x])) ) {
                    SESSION.formErrors.Add("Please enter the gender for #qGetFamilyMembers.name[x]#.");
                }
				
				// DOB
                if ( NOT isDate(TRIM(qGetFamilyMembers.birthdate[x])) ) {
                    SESSION.formErrors.Add("Please enter the date of birth for #qGetFamilyMembers.name[x]#.");
                }

				// Relation
				if ( NOT LEN(TRIM(qGetFamilyMembers.membertype[x])) ) {
                    SESSION.formErrors.Add("Please enter the relation for #qGetFamilyMembers.name[x]#.");
                }	
				
				// Living at home
				if ( NOT LEN(TRIM(qGetFamilyMembers.liveathome[x])) ) {
					SESSION.formErrors.Add("Please indicate if #qGetFamilyMembers.name[x]# is living at home.");
				}

				// Interests
				if ( NOT LEN(TRIM(qGetFamilyMembers.interests[x])) ) {
					SESSION.formErrors.Add("Please enter some interests for #qGetFamilyMembers.name[x]#.");
				}

				// School Activities
				if ( NOT LEN(qGetFamilyMembers.schoolActivities) ) {
					SESSION.formErrors.Add("Please indicate if the student participates in any sponsored school activities");
				}	

			} 
			
            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[2].isComplete = true;
				
				if ( NOT qGetFamilyMembers.recordCount ) {
					stResults.section[2].message = "(assuming you have no other family members)";
				} else {
					stResults.section[2].message = "";
				}
					
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[2].isComplete = false;
				stResults.section[2].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }
			
			
			/********************************************
				3 - Background Checks
			********************************************/
			
			// Section 1 Not Complete
			if ( NOT LEN(qGetHostFamilyInfo.fatherFirstName) AND NOT LEN(qGetHostFamilyInfo.fatherLastName) AND NOT LEN(qGetHostFamilyInfo.motherFirstName) AND NOT LEN(qGetHostFamilyInfo.motherLastName) ) {
				SESSION.formErrors.Add("Prior to complete this page, please complete page Name & Contact Info.");
			}
			
			// Father
			if ( LEN(qGetHostFamilyInfo.fatherFirstName) OR LEN(qGetHostFamilyInfo.fatherLastName) ) {
				
				// SSN
				if  ( NOT LEN(qGetHostFamilyInfo.fatherSSN) ) {
					SESSION.formErrors.Add("The SSN for #qGetHostFamilyInfo.fatherFirstName# #qGetHostFamilyInfo.fatherLastName# does not appear to be a valid SSN. Please make sure it is entered in the 999-99-9999 format.");
				}	
				
				// Signature
				if ( NOT qGetFatherCBCAuthorization.recordCount ) {
					SESSION.formErrors.Add("The CBC authorization signature for #qGetHostFamilyInfo.fatherFirstName# #qGetHostFamilyInfo.fatherLastName# is missing.");
				}	
			
			}

			// Mother
			if ( LEN(qGetHostFamilyInfo.motherFirstName) OR LEN(qGetHostFamilyInfo.motherLastName) ) {
				
				// SSN
				if  ( NOT LEN(qGetHostFamilyInfo.motherSSN) ) {
					SESSION.formErrors.Add("The SSN for #qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherLastName# does not appear to be a valid SSN. Please make sure it is entered in the 999-99-9999 format.");
				}	
				
				// Signature
				if ( NOT qGetMotherCBCAuthorization.recordCount ) {
					SESSION.formErrors.Add("The CBC authorization signature for #qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherLastName# is missing.");
				}	
			
			}

			// Members - Loop through query
			for( x=1; x LTE qGetCBCQualifiedMembers.recordCount; x++ ) {
				
				// Member CBC Authorization
				var qGetMemberCBCAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
					foreignTable="smg_host_children",
					foreignID=qGetCBCQualifiedMembers.childID[x], 
					documentTypeID=APPLICATION.DOCUMENT.hostMemberCBCAuthorization, 
					seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID
				);
				
				if ( NOT qGetMemberCBCAuthorization.recordCount ) {
					SESSION.formErrors.Add("The CBC authorization signature for host member #qGetCBCQualifiedMembers.name[x]# is missing.");										
				}
				
			}
			
            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[3].isComplete = true;
				stResults.section[3].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[3].isComplete = false;
				stResults.section[3].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }
			
			
			/********************************************
				4 - Personal Description
			********************************************/
			
			// No Letter
			if ( NOT LEN(TRIM(qGetHostFamilyInfo.familyLetter)) ) {
            	SESSION.formErrors.Add("The letter is required. If you would like to move onto another portion of the application with out finishing your letter, please use the menu to the left to navigate past this page.");
			}
			
			// Letter to Short
			if ( LEN(TRIM(qGetHostFamilyInfo.familyLetter)) AND LEN(TRIM(qGetHostFamilyInfo.familyLetter)) LT 300 ) {
            	SESSION.formErrors.Add("Your letter is too short. If you would like to proceed to another portion of the application without finishing your letter, please use the menu to the left to navigate past this page.");
			}

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[4].isComplete = true;
				stResults.section[4].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[4].isComplete = false;
				stResults.section[4].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }
			
			
			/********************************************
				5 - Hosting Environment
			********************************************/
			
			// Allergies
			if ( NOT LEN(qGetHostFamilyInfo.pet_allergies) ) {
				SESSION.formErrors.Add("Please indicate if you would be willing to host a student who is allergic to animals");
			}

			/*** Add Room Sharing ***/
			
			// Family Smokes
			if ( NOT LEN(TRIM(qGetHostFamilyInfo.hostSmokes)) ) {
				SESSION.formErrors.Add("Please indicate if any one in your family smokes");
			}
			
			// Family Smokes Conditions
			if ( qGetHostFamilyInfo.hostSmokes EQ "yes" AND NOT LEN(TRIM(qGetHostFamilyInfo.smokeConditions)) ) {
				SESSION.formErrors.Add("Please indicate under what conditions someone in your family smokes");
			}
			
			// Family Dietary Restrictions
			if ( NOT LEN(qGetHostFamilyInfo.famDietRest) ) {
				SESSION.formErrors.Add("Please indicate if your family follows any dietary restrictions");
			}
			
			// Family Dietary Description
			if ( qGetHostFamilyInfo.famDietRest EQ 1 AND NOT LEN(qGetHostFamilyInfo.famDietRestDesc) ) {
				SESSION.formErrors.Add("You have indicated that someone in your family follows a dietary restriction but have not describe it");
			}

			// Student Follow Dietary Restrictions
			if ( NOT LEN(qGetHostFamilyInfo.stuDietRest) ) {
				SESSION.formErrors.Add("Please indicate if the student is to follow any dietary restrictions");
			}

			// Student Follow Dietary Description
			if ( qGetHostFamilyInfo.stuDietRest EQ 1 AND NOT LEN(qGetHostFamilyInfo.stuDietRestDesc) ) {
				SESSION.formErrors.Add("You have indicated the student is to follow a dietary restriction but have not describe it");
			}

			// Hosting a student with dietary resctriction
			if ( NOT LEN(qGetHostFamilyInfo.dietaryRestriction) ) {
				SESSION.formErrors.Add("Please indicate if you would have problems hosting a student with dietary restrictions");
			}

			// Three Squares
			if ( NOT LEN(qGetHostFamilyInfo.threesquares) ) {
				SESSION.formErrors.Add("Please indicate if you are prepared to provide three (3) quality meals per day");
			}
			
            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[5].isComplete = true;
				stResults.section[5].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[5].isComplete = false;
				stResults.section[5].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }

			
			/********************************************
				6 - Religious Preference
			********************************************/

            // Student Transportation
            if  ( NOT LEN(TRIM(qGetHostFamilyInfo.churchTrans)) ) {
				SESSION.formErrors.Add("Please indicate if you will provide transportation to the students religious services if they are different from your own.");
            }
			
            // Religious Affiliation
            if  ( NOT LEN(qGetHostFamilyInfo.informReligiousPref) ) {
				SESSION.formErrors.Add("Please indicate will voluntarily provide your religious affiliation.");
            }
			
			// Religious Preference
			if ( VAL(qGetHostFamilyInfo.informReligiousPref) AND NOT VAL(qGetHostFamilyInfo.religion) ) {
				SESSION.formErrors.Add("Please indicate your religious preference");
			}
			
            // Difficult different religion
            if  ( NOT LEN(qGetHostFamilyInfo.hostingDiff) ) {
				SESSION.formErrors.Add("Please indicate if anyone in your household has difficulty with hosting a student whoms religious differs from your own.");
            }
			
			// Religious Attandance
			if ( NOT LEN(qGetHostFamilyInfo.religious_participation) ) {
				SESSION.formErrors.Add("Please indicate How often do you go to your religious place of worship?");
			}
			
			// Expect Student
			if ( qGetHostFamilyInfo.religious_participation NEQ 'Inactive' AND NOT LEN(qGetHostFamilyInfo.churchFam) ) {
				SESSION.formErrors.Add("Please indicate if Would you expect your exchange student to attend services with your family?");
			}

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[6].isComplete = true;
				stResults.section[6].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[6].isComplete = false;
				stResults.section[6].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }


			/********************************************
				7 - Family Rules
			********************************************/

            // Curfew School Nights
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.houserules_curfewweeknights)) ) {
				SESSION.formErrors.Add("Please specify the curfew for school nights.");
            }	
            
            // Curfew Weekends
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.houserules_curfewweekends)) ) {
				SESSION.formErrors.Add("Please specify the curfew for weekends.");
            }			
            
            // Chores
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.houserules_chores)) ) {
				SESSION.formErrors.Add("Please list the chores that the student we responsible for.");
            }		
			
            // Computer Usage
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.houserules_inet)) )  {
				SESSION.formErrors.Add("Please indicate any internet, computer or email usage restrictions you have.");
            }			
            
            // Expenses
            if ( NOT LEN(TRIM(qGetHostFamilyInfo.houserules_expenses)) )  {
				SESSION.formErrors.Add("Please indicate any expenses you expect the student to be responsible for.");
            }	

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[7].isComplete = true;
				stResults.section[7].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[7].isComplete = false;
				stResults.section[7].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }


			/********************************************
				8 - Family Album
			********************************************/
			
			var qCategoryList = APPLICATION.CFC.DOCUMENT.getDocumentType(documentGroup="familyAlbum");
			var qUploadedPictureCategoryList = APPLICATION.CFC.DOCUMENT.getDocuments(
				foreignTable="smg_hosts",	
				foreignID=APPLICATION.CFC.SESSION.getHostSession().ID, 
				documentGroup="familyAlbum"
			);
			
			var vCategoryArray = ListToArray(ValueList(qCategoryList.ID));
			var vUploadedPictureCategoryList = ValueList(qUploadedPictureCategoryList.documentTypeID);
						
			// Loop Through Uploaded Images Categories to check
			for( x=1; x LTE ArrayLen(vCategoryArray); x++ ) {
				
				if ( NOT ListFindNoCase(vUploadedPictureCategoryList, vCategoryArray[x]) AND qCategoryList.ID[x] NEQ 26 ) {
					SESSION.formErrors.Add("You seem to be missing a picutre of: #qCategoryList.name[x]#");
				}
				
			}
			
            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[8].isComplete = true;
				stResults.section[8].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[8].isComplete = false;
				stResults.section[8].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }


			/********************************************
				9 - School Info
			********************************************/
			
			// Selected School
			if ( NOT VAL(qGetHostFamilyInfo.schoolID) ) {
				SESSION.formErrors.Add("Please select a school from the drop down list");
			}
			
			// Works at School
			if ( NOT LEN(qGetHostFamilyInfo.schoolWorks) ) {
				SESSION.formErrors.Add("Please indicate if any member of your household works for the high school.");
			}		
			
			// Explanation of who works at school
			if ( qGetHostFamilyInfo.schoolWorks EQ 1 AND NOT LEN(TRIM(qGetHostFamilyInfo.schoolWorksExpl)) ) {
				SESSION.formErrors.Add("You have indicated that someone works with the school, but didn't explain.  Please provide details regarding the posistion.");
			}	
			
			//Been contacted by coach
			if ( NOT LEN(qGetHostFamilyInfo.schoolCoach) ) {
				SESSION.formErrors.Add("Please indicate if a coach has contacted you about hosting an exchange student.");
			}		
			
			// Coach explanation
			if ( qGetHostFamilyInfo.schoolCoach EQ 1 AND NOT LEN(TRIM(qGetHostFamilyInfo.schoolCoachExpl)) ) {
				SESSION.formErrors.Add("You have indicated that a coach contacted you, but didn't explain.  Please provide details regarding this contact.");
			}	

			// School Distance
			if ( NOT LEN(TRIM(qGetHostFamilyInfo.schoolDistance)) )  {
				SESSION.formErrors.Add("Please indicate how far is the school from your home.");
			}
			
			// Transportaion
			if ( NOT LEN(TRIM(qGetHostFamilyInfo.schoolTransportation)) )  {
				SESSION.formErrors.Add("Please indicate how the student will get to school.");
			}

			// Other Transportation 
			if ( qGetHostFamilyInfo.schooltransportation is 'other' AND NOT LEN(TRIM(qGetHostFamilyInfo.schoolTransportationOther)) ) {
				SESSION.formErrors.Add("You indicated that the student will get to school but Other, but didn't specify what that other method would be.");
			}	

			// Extra Curricular Transportaion
			if ( NOT LEN(TRIM(qGetHostFamilyInfo.extraCuricTrans)) )  {
				SESSION.formErrors.Add("Please indicate if you will provide transportation to extracuricular activities.");
			}

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[9].isComplete = true;
				stResults.section[9].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[9].isComplete = false;
				stResults.section[9].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }


			/********************************************
				10 - Community Profile
			********************************************/

            // nearbigCity
            if( NOT LEN(TRIM(qGetHostFamilyInfo.nearbigCity)) ) {
                SESSION.formErrors.Add("Please indicate the nearest town over 30,000 people.");
            }

			// major_air_code
            if( NOT LEN(TRIM(qGetHostFamilyInfo.major_air_code)) ) {
                SESSION.formErrors.Add("Please indicate your major airport code.");
            }

			// wintertemp
            if( NOT LEN(TRIM(qGetHostFamilyInfo.wintertemp)) ) {
                SESSION.formErrors.Add("Please indicate the average winter temp.");
            }

			// summertemp
            if( NOT LEN(TRIM(qGetHostFamilyInfo.summertemp)) ) {
                SESSION.formErrors.Add("Please indicate the average summer temp.");
            }
			
			// neighborhood            
            if( NOT LEN(TRIM(qGetHostFamilyInfo.neighborhood)) ) {
                SESSION.formErrors.Add("Please describe your neighborhood.");
            }

			// community
            if( NOT LEN(TRIM(qGetHostFamilyInfo.community)) ) {
                SESSION.formErrors.Add("Please describe your community.");
            }

            // avoidarea
            if( NOT LEN(TRIM(qGetHostFamilyInfo.avoidarea)) ) {
                SESSION.formErrors.Add("Please indicate if there are or are not areas to be avoided in your neighborhood.");
            }

			// special_cloths
            if( NOT LEN(TRIM(qGetHostFamilyInfo.special_cloths)) ) {
                SESSION.formErrors.Add("Please provide a list of any special cloths to bring.");
            }

			// point_interest
            if( NOT LEN(TRIM(qGetHostFamilyInfo.point_interest)) ) {
                SESSION.formErrors.Add("Please indicate any interests in your area.");
            }

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[10].isComplete = true;
				stResults.section[10].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[10].isComplete = false;
				stResults.section[10].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }

			
			/********************************************
				11 - Confidential Data
			********************************************/

			// publicAssitance
			if ( NOT LEN(qGetHostFamilyInfo.publicAssitance) ) {
				SESSION.formErrors.Add("Please indicate if any member of your household is receiving any public assistance.");
			}	
			
			// publicAssitance
			if ( qGetHostFamilyInfo.publicAssitance EQ 1 AND NOT LEN(TRIM(qGetHostFamilyInfo.publicAssitanceExpl)) ) {
				SESSION.formErrors.Add("You have indicated that you receive public assistance, but did not explain.");
			}	
						
			// Income
			if ( NOT LEN(qGetHostFamilyInfo.income) ) {
				SESSION.formErrors.Add("Please indicate your household income.");
			}	
			
			// Crime Explanation
			if ( NOT LEN(qGetHostFamilyInfo.crime) ) {
				SESSION.formErrors.Add("Please indicate if any member in your household has beeen charged with a crime.");
			}	
			
			// Crime Explanation
			if ( qGetHostFamilyInfo.crime EQ 1 AND NOT LEN(TRIM(qGetHostFamilyInfo.crimeExpl)) ) {
				SESSION.formErrors.Add("You have indicated that someone has been charged with a crime, but did not explain.");
			}	
			
			// Child Protective Services
			if ( NOT LEN(qGetHostFamilyInfo.cps) ) {
				SESSION.formErrors.Add("Please indicate if you have been contacted by Child Protective Services.");
			}	
			
			// Child Protective Services
			if ( qGetHostFamilyInfo.cps EQ 1 AND NOT LEN(TRIM(qGetHostFamilyInfo.cpsExpl)) ) {
				SESSION.formErrors.Add("You have indicated that you have been contacted by Child Protective Services, but did not explain.");
			}	

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[11].isComplete = true;
				stResults.section[11].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[11].isComplete = false;
				stResults.section[11].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }


			/********************************************
				12- References
			********************************************/
			
			// Single Parent
			if ( qGetHostFamilyInfo.totalFamilyMembers EQ 1 ) {
				vNumberOfRequiredReferences = 6;
			} else {
				vNumberOfRequiredReferences = 4;
			}
			
			vRemainingReferences = vNumberOfRequiredReferences - qGetReferences.recordcount;

			if ( VAL(vRemainingReferences) AND val(vRemainingReferences) gt 0 ) {
				SESSION.formErrors.Add("You need to provide an additional #vRemainingReferences# reference(s).");
			}


            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.section[12].isComplete = true;
				stResults.section[12].message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.section[12].isComplete = false;
				stResults.section[12].message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }
				
			// Set Application Complete true/false
			if ( stResults.applicationProgress EQ 300 ) {
				stResults.isComplete = true;
			}
			
			// Return structure
			return stResults;
		</cfscript>

    </cffunction>
    

	<cffunction name="submitApplication" access="public" returntype="struct" output="false" hint="Submits host family application">
		
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE 
                smg_hosts
            SET 
                hostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="7">,
                dateApplicationSubmitted = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE
                hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
        </cfquery>
        
		<cfscript>
			// Set Result Struct
			var stReturnMessage = StructNew();
			
			stReturnMessage.hfNotification = StructNew();
			stReturnMessage.hfNotification.pageMessages = "";
			stReturnMessage.hfNotification.formErrors = "";
			
			stReturnMessage.arNotification = StructNew();
			stReturnMessage.arNotification.pageMessages = "";
			stReturnMessage.arNotification.formErrors = "";

            // Get Host Family Info - Accessible from any page
            var qGetHostFamilyInfo = getCompleteHostInfo(hostID=APPLICATION.CFC.SESSION.getHostSession().ID);				

			// Set New Session Status
            APPLICATION.CFC.SESSION.setHostSessionApplicationStatus(applicationStatus=7);
            
			// Rebuild Left Menu to disable navigation after HF is submitted
			SESSION.leftMenu = APPLICATION.CFC.UDF.buildLeftMenu();

			// Create Email Object
			e = createObject("component","extensions.components.email");

			// Notify Host Family
			if ( isValid("email", qGetHostFamilyInfo.email) ) {
			
				// Get Subject and email body
				stEmailTemplate=getEmailTemplate(
					emailTemplate="hfNotification",
					hostFamilyLastName=qGetHostFamilyInfo.familylastname,
					areaRepresentativeName=qGetHostFamilyInfo.areaRepresentative
				);  

				// Try to send out email
				try {
				
					// Send Email
					e.sendEmail(
						emailTo=qGetHostFamilyInfo.email,
						emailSubject=stEmailTemplate.emailSubject,
						emailMessage=stEmailTemplate.emailBody
					);
					
					stReturnMessage.hfNotification.pageMessages = "Notification successfully sent to host family";

				// Deal with error - most likely not a valid email address - Append error message
				} catch( any error ) {
					stReturnMessage.hfNotification.formErrors = "There was a problem sending out an email notification to the host family";
				}
	
			}

			// Notify Area Representative
			if ( isValid("email", qGetHostFamilyInfo.areaRepresentativeEmail) ) {
				
				// Get Subject and email body
				stEmailTemplate = getEmailTemplate(
					emailTemplate="arNotification",
					hostFamilyLastName=qGetHostFamilyInfo.familylastname,
					areaRepresentativeName=qGetHostFamilyInfo.areaRepresentative
				);  
				
				// Try to send out email
				try {
				
					// Send Email
					e.sendEmail(
						emailTo=qGetHostFamilyInfo.areaRepresentativeEmail,
						emailSubject=stEmailTemplate.emailSubject,
						emailMessage=stEmailTemplate.emailBody
					);
					
					stReturnMessage.arNotification.pageMessages = "Notification successfully sent to area representative";

				// Deal with error - most likely not a valid email address - Append error message
				} catch( any error ) {
					stReturnMessage.arNotification.formErrors = "There was a problem sending out an email notification to the area representative";
				}
			
			}
			
			return stReturnMessage;
		</cfscript>
	
	</cffunction>

    
	<cffunction name="getEmailTemplate" access="public" returntype="struct" output="false" hint="Retuns templates based on actions">
        <cfargument name="emailTemplate" default="" hint="emailTemplate - Not required">
        <cfargument name="hostFamilyLastName" default="" hint="hostFamilyLastName - Not required">
        <cfargument name="areaRepresentativeName" default="" hint="areaRepresentativeName - Not required">
        
        <cfscript>
			// Declare Struct
			var stReturnData = StructNew();
			var stReturnData.emailSubject = "";
			var stReturnData.emailBody = "";	
		</cfscript>
    
    	<cfswitch expression="#ARGUMENTS.emailTemplate#">
        	
            <!--- Host Family Notification - Application Submitted --->
            <cfcase value="hfNotification">
            
                <cfscript>
					stReturnData.emailSubject = "#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='shortName')# - Host Family Application Submitted";
				</cfscript>

                <cfsavecontent variable="stReturnData.emailBody">
					<cfoutput>
                        <p>Dear #ARGUMENTS.hostFamilyLastName# Family,</p>
                        
                        <p>
                        	Congratulations on completing your host family application! You are now one step closer to hosting a student. 
                            We would like to thank you for taking the time to complete an application and to educate you on the rest of the process. 
                        </p>
                        
                        <p>
                        	Your Area Representative has received your application and is probably reviewing it at this very moment. Upon completing a thorough review, your Area Representative 
                            will either let you know about missing information or submit your application for further review from our management team and compliance dept. 
                            At any time during the process, you may be notified to make some changes on your application. This notification will come from your Area Representative. 
                            Please do not take this as insult but instead understand that we have a strict set of regulations which govern our program and the paperwork for which it supports. 
                        </p>
                        
                        <p>
                        	Once your application has been approved by our head office, you will receive a notification. You can also log in to the website at any time to view your current application status. 
                        	If at any time you feel that you are not being given the support you deserve, feel free to contact our main office at #APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='tollFree')#. 
                        </p>
                        
                        <p>We look forward to having you join our team of host families for this upcoming year!</p>
                        
                        <p>
                            Thank you, <br />
                            #APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='name')#
    					</p>
                    </cfoutput>
                </cfsavecontent>
                        
            </cfcase>
            
            <!--- Area Representative Notification - Application Submitted --->
            <cfcase value="arNotification">
            
                <cfscript>
					stReturnData.emailSubject = "#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='shortName')# - Host Family Application Submitted";
				</cfscript>

                <cfsavecontent variable="stReturnData.emailBody">
					<cfoutput>
                        <p>Dear #ARGUMENTS.areaRepresentativeName#,</p>
                        
                        <p>
                        	This email is being sent to notify you that a Host Family application has been submitted for the #ARGUMENTS.hostFamilyLastName# (###APPLICATION.CFC.SESSION.getHostSession().ID#) family. 
                            This family has been notified that you have started the review process and will be contacting them if any additional information is required.
                        </p>
                         
                        <p>
                        	Please log in to EXITS to view this application or click the link below for direct access (you must be logged in EXITS).
                            <a href="#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='exitsURL')#/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=7">View Host Family Application</a>
						</p>
                        
                        <p>
                        	Thank you for your hard work and continued support of our program! 
						</p>                            
                        
                        <p>
                            Best Regards, <br />
                            #APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='name')#
    					</p>
                    </cfoutput>
                </cfsavecontent>
                        
            </cfcase>
            
        </cfswitch>
        
        <cfscript>
			return stReturnData;
		</cfscript>

	</cffunction>     


	<cffunction name="getMenuHistory" access="public" returntype="query" output="false" hint="Gets a list of items and their approval history">
        <cfargument name="hostID" default="#APPLICATION.CFC.SESSION.getHostSession().ID#" hint="HostID is not required">
        <cfargument name="seasonID" default="#APPLICATION.CFC.SESSION.getHostSession().seasonID#" hint="Gets current paperwork season ID">
        <cfargument name="section" default="" hint="Used to build menu for a specific section">
        
        <cfquery 
			name="qGetMenuHistory" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
                    ap.section,
                    ap.description,
                    ap.appMenuColor,
                    h.areaRepStatus,
                    h.areaRepDateStatus,
                    h.areaRepNotes,                    
                    h.regionalAdvisorStatus,
                    h.regionalAdvisorDateStatus,
                    h.regionalAdvisorNotes,
                    h.regionalManagerStatus,
                    h.regionalManagerDateStatus,
                    h.regionalManagerNotes,
                    h.facilitatorStatus,
                    h.facilitatorDateStatus,
                    h.facilitatorNotes
                FROM 
                    smg_host_app_section ap
				LEFT OUTER JOIN	
					smg_host_app_history h ON h.itemID = ap.ID                  
                    AND
                        h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                    AND
                        h.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
                WHERE
                	appMenuColor != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                <!--- Check if we are bulding a menu for a specific section --->
				<cfif LEN(ARGUMENTS.section)>
                	AND
                    	section = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.section#">
                </cfif>
                ORDER BY
                	listOrder
		</cfquery>
		   
		<cfreturn qGetMenuHistory>
	</cffunction>
    
    
	<cffunction name="getDeniedSections" access="public" returntype="query" output="false" hint="Gets a list of items and their approval history">
        <cfargument name="hostID" default="#APPLICATION.CFC.SESSION.getHostSession().ID#" hint="HostID is not required">
        <cfargument name="seasonID" default="#APPLICATION.CFC.SESSION.getHostSession().seasonID#" hint="Gets current paperwork season ID">
        
        <cfquery 
            name="qGetDeniedSections" 
            datasource="#APPLICATION.DSN.Source#">
                SELECT
                    ap.section,
                    ap.description,
                    ap.appMenuColor,
                    (
                        CASE 
                            WHEN 
                                h.areaRepNotes != '' 
                            THEN 
                                h.areaRepNotes
                            WHEN 
                                h.regionalAdvisorNotes != '' 
                            THEN 
                                h.regionalAdvisorNotes
                            WHEN 
                                h.regionalManagerNotes != '' 
                            THEN 
                                h.regionalManagerNotes
                            WHEN 
                                h.facilitatorNotes != '' 
                            THEN 
                                h.facilitatorNotes
                        END
                    ) AS notes
                FROM 
                    smg_host_app_section ap
                LEFT OUTER JOIN	
                    smg_host_app_history h ON h.itemID = ap.ID                  
                    AND
                        h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                    AND
                        h.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
                WHERE
                    appMenuColor != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                AND
                    (
                        h.areaRepStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="denied">
                    OR
                        h.regionalAdvisorStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="denied">
                    OR
                        h.regionalManagerStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="denied">
                    OR
                        h.facilitatorStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="denied">
                    )
                    
				<!--- Get only denied sections when application has been sent back to the HF --->
                <cfif NOT listFind("8,9", APPLICATION.CFC.SESSION.getHostSession().applicationStatus)>
					AND
                    	1 != 1
                </cfif>
                    
                ORDER BY
                    listOrder
        </cfquery>
           
		<cfreturn qGetDeniedSections>
	</cffunction>    
        
       
</cfcomponent>