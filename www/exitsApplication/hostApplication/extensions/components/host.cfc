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

	
	<cffunction name="getHosts" access="public" returntype="query" output="false" hint="Gets a list with hosts, if HostID is passed gets a Host by ID">
    	<cfargument name="hostID" default="" hint="HostID is not required">
        
        <cfquery 
			name="qGetHosts" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
                	*         
                FROM 
                    smg_hosts
                    
                <cfif LEN(ARGUMENTS.hostID)>
                    WHERE
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>
                    
                ORDER BY 
                    familyLastName
		</cfquery>
		   
		<cfreturn qGetHosts>
	</cffunction>


	<cffunction name="getHostMemberByID" access="public" returntype="query" output="false" hint="Gets a host member by ID">
    	<cfargument name="childID" default="" hint="Child ID is not required">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="liveAtHome" default="" hint="liveAtHome is not required">
        <cfargument name="getAllMembers" default="0" hint="Returns all family members including deleted">
        <cfargument name="get18AndOlder" default="" hint="Returns all family members 18 and older">
        
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
                
                <cfif LEN(ARGUMENTS.get18AndOlder)>
                    AND
                        FLOOR(datediff (now(), birthDate)/365) >= <cfqueryparam cfsqltype="cf_sql_integer" value="18">
                </cfif>
				
		</cfquery>
		   
		<cfreturn qGetHostMemberByID>
	</cffunction>


	<cffunction name="getHostPets" access="public" returntype="query" output="false" hint="Gets a host pets by ID">
    	<cfargument name="animalID" default="" hint="Child ID is not required">
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
                    smg_family_references
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
    
        <!--- References --->
        <cfquery name="qGetReferences" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                *
            FROM 
                smg_family_references
            WHERE 
                referenceFor = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
        </cfquery>

		<cfscript>
			// Get Host Family Information
			var qGetHostInfo = getHosts(hostID=VAL(ARGUMENTS.hostID));
			
			// Get Host Family Members
			var qGetFamilyMembers = getHostMemberByID(hostID=ARGUMENTS.hostID);
			
			// Get Host Family Members
			var qGetFamilyMembersAtHome = getHostMemberByID(hostID=ARGUMENTS.hostID,liveAtHome="yes");
			
			// Get Host Family Members at Home
			var qGetFamilyMembers18AndOlder = APPLICATION.CFC.HOST.getHostMemberByID(hostID=APPLICATION.CFC.SESSION.getHostSession().ID,liveAtHome="yes", get18AndOlder=1);	
			
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
			
			// Set a struct for each section
			stResults.contactInfo = structNew();
			stResults.familyMembers = structNew();
			stResults.backgroundChecks = structNew();
			stResults.personalDescription = structNew();
			stResults.hostingEnvironment = structNew();
			stResults.religiousPreference = structNew();
			stResults.familyRules = structNew();
			stResults.familyAlbum = structNew();
			stResults.schoolInfo = structNew();
			stResults.communityProfile = structNew();
			stResults.confidentialData = structNew();
			stResults.references = structNew();


			/********************************************
				1 - Contact Info 
			********************************************/

			// Family Last Name
            if ( NOT LEN(TRIM(qGetHostInfo.familyLastName)) ) {
                SESSION.formErrors.Add("Please enter your family last name.");
            }			
            
            // Address
            if ( NOT LEN(TRIM(qGetHostInfo.address)) ) {
                SESSION.formErrors.Add("Your home address is not valid.");
            }	
    
            // City
            if ( NOT LEN(TRIM(qGetHostInfo.city)) ) {
                SESSION.formErrors.Add("You need to indicate which city your home is located in.");
            }	
    
            // State
            if ( NOT LEN(TRIM(qGetHostInfo.state)) ) {
                SESSION.formErrors.Add("Please indicate which state your home is located in.");
            }	
    
            // Zip
            if ( NOT isValid("zipcode", TRIM(qGetHostInfo.zip)) ) {
                SESSION.formErrors.Add("The zip code for home address is not a valid zip code.");
            }	
    
            // Mailing Address
            if ( NOT LEN(TRIM(qGetHostInfo.mailaddress)) ) {
                SESSION.formErrors.Add("Please indicate your mailing address.");
            }	
    
            // Mailing City
            if ( NOT LEN(TRIM(qGetHostInfo.mailcity)) ) {
                SESSION.formErrors.Add("Please indicate your mailing address city.");
            }	
    
            // Mailing State
            if ( NOT LEN(TRIM(qGetHostInfo.mailstate)) ) {
                SESSION.formErrors.Add("Please indicate your mailing address state.");
            }	
    
            // Mailing Zip
            if ( NOT isValid("zipcode", TRIM(qGetHostInfo.mailzip)) ) {
                SESSION.formErrors.Add("The zip code for mailing address is not a valid zip code.");
            }	
    
            // Phones
            if ( NOT LEN(TRIM(qGetHostInfo.phone)) AND NOT LEN(TRIM(qGetHostInfo.father_cell)) AND NOT LEN(TRIM(qGetHostInfo.mother_cell)) ) {
                SESSION.formErrors.Add("Please enter one of the Phone fields: Home, Father Cell or Mother Cell");
            }	
    
            // Valid Phone
            if ( LEN(TRIM(qGetHostInfo.phone)) AND NOT isValid("telephone", TRIM(qGetHostInfo.phone)) ) {
                SESSION.formErrors.Add("The home phone number you have entered does not appear to be valid. ");
            }	
    
            // Valid Email Address
            if ( LEN(TRIM(qGetHostInfo.email)) AND NOT isValid("email", TRIM(qGetHostInfo.email)) ) {
                SESSION.formErrors.Add("The email address you have entered does not appear to be valid.");
            }	
            
            // Valid Email Address
            if ( LEN(TRIM(qGetHostInfo.password)) LT 6 ) {
                SESSION.formErrors.Add("Your password must be at least 6 characters long.");
            }	
            
            // Valid Father's DOB
            if ( LEN(TRIM(qGetHostInfo.fatherdob)) AND NOT isValid("date", TRIM(qGetHostInfo.fatherdob)) ) {
                SESSION.formErrors.Add("Please enter a valid Date of Birth for the Father");
            }	
    
            // Valid Father's Phone
            if ( LEN(TRIM(qGetHostInfo.father_cell)) AND NOT isValid("telephone", TRIM(qGetHostInfo.father_cell)) ) {
                SESSION.formErrors.Add("Please enter a valid phone number for the Father's Cell Phone.");
            }	
    
            // Valid Mother's DOB
            if ( LEN(TRIM(qGetHostInfo.motherdob)) AND NOT isValid("date", TRIM(qGetHostInfo.motherdob)) ) {
                SESSION.formErrors.Add("The date you specified is not valid for Mother's Date of Birth");
            }	
            
            // Valid Mother's Phone
            if ( LEN(TRIM(qGetHostInfo.mother_cell)) AND NOT isValid("telephone", TRIM(qGetHostInfo.mother_cell)) ) {
                SESSION.formErrors.Add("Please enter a valid phoe number for Mother's Cell Phone");
            }
            
            // Functioning Business
            if ( NOT LEN(qGetHostInfo.homeIsFunctBusiness) ) {
                SESSION.formErrors.Add("Please indicate if your home is also a functioning business.");
            }
            
            // No business Des
            if ( qGetHostInfo.homeIsFunctBusiness EQ 1 AND NOT LEN(TRIM(qGetHostInfo.homeBusinessDesc)) )  {
                SESSION.formErrors.Add("You have indicated that your home is also a business, but have not provided details on the type of business.");
            }
            
            // No business Des
            if ( NOT LEN(TRIM(qGetHostInfo.fatherlastname)) AND NOT LEN(TRIM(qGetHostInfo.motherlastname)) )  {
                SESSION.formErrors.Add("If you are single, you must provide information for at least one of the host parents, either the father or mother. If you are not single, please provide information on both host parents.");
            }
            
            // Father is Required
            if ( LEN(TRIM(qGetHostInfo.fatherFirstName)) AND NOT LEN(TRIM(qGetHostInfo.fatherdob)) )  {
                SESSION.formErrors.Add("Please provide the birthdate for the Host Father.");
            }
            
            // Father is Required
            if ( LEN(TRIM(qGetHostInfo.fatherFirstName)) AND NOT LEN(TRIM(qGetHostInfo.fatherworktype)) )  {
                SESSION.formErrors.Add("Please provide the occupation for the Host Father.");
            }
            
            // Father Occupation
            if ( LEN(TRIM(qGetHostInfo.fatherworktype)) AND NOT LEN (qGetHostInfo.fatherfullpart) ) {
                SESSION.formErrors.Add("You provided a job for the host father, but didn't indicate if you work full or part time.");
            }
            
            // Father Employer
            if ( LEN(TRIM(qGetHostInfo.fatherworktype)) AND NOT LEN(TRIM(qGetHostInfo.fatherEmployeer)) ) {
                SESSION.formErrors.Add("You provided a job for the host father, but didn't indicate the employer.");
            }
            // Father is Required
            if ( LEN(TRIM(qGetHostInfo.motherFirstName)) AND NOT LEN(TRIM(qGetHostInfo.motherdob)) )  {
                SESSION.formErrors.Add("Please provide the birthdate for the Host Mother.");
            }
            
            // Father is Required
            if ( LEN(TRIM(qGetHostInfo.motherFirstName)) AND NOT LEN(TRIM(qGetHostInfo.motherworktype)) )  {
                SESSION.formErrors.Add("Please provide the occupation for the Host Mother.");
            }
            
            // Father Occupation
            if ( LEN(TRIM(qGetHostInfo.motherworktype)) AND NOT LEN(qGetHostInfo.motherfullpart) ) {
                SESSION.formErrors.Add("You provided a job for the host mother, but didn't indicate if you work full or part time.");
            }
            
            // Father Employer
            if ( LEN(TRIM(qGetHostInfo.motherworktype)) AND NOT LEN(TRIM(qGetHostInfo.motherEmployeer)) ) {
                SESSION.formErrors.Add("You provided a job for the host mother, but didn't indicate the employer.");
            }
    
            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.contactInfo.isComplete = true;
				stResults.contactInfo.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.contactInfo.isComplete = false;
				stResults.contactInfo.message = SESSION.formErrors.GetCollection();
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

			} 
			
            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.familyMembers.isComplete = true;
				
				if ( NOT qGetFamilyMembers.recordCount ) {
					stResults.familyMembers.message = "(assuming you have no other family members)";
				} else {
					stResults.familyMembers.message = "";
				}
					
            // Errors Found - Erase queue for next section	
            } else {
				stResults.familyMembers.isComplete = false;
				stResults.familyMembers.message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }
			
			
			/********************************************
				3 - Background Checks
			********************************************/
			
			// Section 1 Not Complete
			if ( NOT LEN(qGetHostInfo.fatherFirstName) AND NOT LEN(qGetHostInfo.fatherLastName) AND NOT LEN(qGetHostInfo.motherFirstName) AND NOT LEN(qGetHostInfo.motherLastName) ) {
				SESSION.formErrors.Add("Prior to complete this page, please complete page Name & Contact Info.");
			}
			
			// Father
			if ( LEN(qGetHostInfo.fatherFirstName) OR LEN(qGetHostInfo.fatherLastName) ) {
				
				// SSN
				if  ( NOT LEN(qGetHostInfo.fatherSSN) ) {
					SESSION.formErrors.Add("The SSN for #qGetHostInfo.fatherFirstName# #qGetHostInfo.fatherLastName# does not appear to be a valid SSN. Please make it is entered in the 999-99-9999 format.");
				}	
				
				// Signature
				if ( NOT qGetFatherCBCAuthorization.recordCount ) {
					SESSION.formErrors.Add("The CBC authorization signature for #qGetHostInfo.fatherFirstName# #qGetHostInfo.fatherLastName# is missing.");
				}	
			
			}

			// Mother
			if ( LEN(qGetHostInfo.motherFirstName) OR LEN(qGetHostInfo.motherLastName) ) {
				
				// SSN
				if  ( NOT LEN(qGetHostInfo.motherSSN) ) {
					SESSION.formErrors.Add("The SSN for #qGetHostInfo.motherFirstName# #qGetHostInfo.motherLastName# does not appear to be a valid SSN. Please make it is entered in the 999-99-9999 format.");
				}	
				
				// Signature
				if ( NOT qGetMotherCBCAuthorization.recordCount ) {
					SESSION.formErrors.Add("The CBC authorization signature for #qGetHostInfo.motherFirstName# #qGetHostInfo.motherLastName# is missing.");
				}	
			
			}

			// Members - Loop through query
			for( x=1; x LTE qGetFamilyMembers18AndOlder.recordCount; x++ ) {
				
				// Member CBC Authorization
				var qGetMemberCBCAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
					foreignTable="smg_host_children",
					foreignID=qGetFamilyMembers18AndOlder.childID[x], 
					documentTypeID=APPLICATION.DOCUMENT.hostMemberCBCAuthorization, 
					seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID
				);
				
				if ( NOT qGetMemberCBCAuthorization.recordCount ) {
					SESSION.formErrors.Add("The CBC authorization signature for host member #qGetFamilyMembers18AndOlder.name[x]# is missing.");										
				}
				
			}
			
            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.backgroundChecks.isComplete = true;
				stResults.backgroundChecks.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.backgroundChecks.isComplete = false;
				stResults.backgroundChecks.message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }
			
			
			/********************************************
				4 - Personal Description
			********************************************/
			
			// No Letter
			if ( NOT LEN(TRIM(qGetHostInfo.familyLetter)) ) {
            	SESSION.formErrors.Add("The letter is required. If you would like to move onto another portion of the application with out finishing your letter, please use the menu to the left to navigate past this page.");
			}
			
			// Letter to Short
			if ( LEN(TRIM(qGetHostInfo.familyLetter)) AND LEN(TRIM(qGetHostInfo.familyLetter)) LT 300 ) {
            	SESSION.formErrors.Add("Your letter is too short. If you would like to proceed to another portion of the application without finishing your letter, please use the menu to the left to navigate past this page.");
			}

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.personalDescription.isComplete = true;
				stResults.personalDescription.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.personalDescription.isComplete = false;
				stResults.personalDescription.message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }
			
			
			/********************************************
				5 - Hosting Environment
			********************************************/
			
			// Allergies
			if ( NOT LEN(qGetHostInfo.pet_allergies) ) {
				SESSION.formErrors.Add("Please indicate if you would be willing to host a student who is allergic to animals");
			}

			/*** Add Room Sharing ***/
			
			// Family Smokes
			if ( NOT LEN(TRIM(qGetHostInfo.hostSmokes)) ) {
				SESSION.formErrors.Add("Please indicate if any one in your family smokes");
			}
			
			// Family Smokes Conditions
			if ( qGetHostInfo.hostSmokes EQ "yes" AND NOT LEN(TRIM(qGetHostInfo.smokeConditions)) ) {
				SESSION.formErrors.Add("Please indicate under what conditions someone in your family smokes");
			}
			
			// Family Dietary Restrictions
			if ( NOT LEN(qGetHostInfo.famDietRest) ) {
				SESSION.formErrors.Add("Please indicate if your family follows any dietary restrictions");
			}
			
			// Family Dietary Description
			if ( qGetHostInfo.famDietRest EQ 1 AND NOT LEN(qGetHostInfo.famDietRestDesc) ) {
				SESSION.formErrors.Add("You have indicated that someone in your family follows a dietary restriction but have not describe it");
			}

			// Student Follow Dietary Restrictions
			if ( NOT LEN(qGetHostInfo.stuDietRest) ) {
				SESSION.formErrors.Add("Please indicate if the student is to follow any dietary restrictions");
			}

			// Student Follow Dietary Description
			if ( qGetHostInfo.stuDietRest EQ 1 AND NOT LEN(qGetHostInfo.stuDietRestDesc) ) {
				SESSION.formErrors.Add("You have indicated the student is to follow a dietary restriction but have not describe it");
			}

			// Hosting a student with dietary resctriction
			if ( NOT LEN(qGetHostInfo.dietaryRestriction) ) {
				SESSION.formErrors.Add("Please indicate if you would have problems hosting a student with dietary restrictions");
			}

			// Three Squares
			if ( NOT LEN(qGetHostInfo.threesquares) ) {
				SESSION.formErrors.Add("Please indicate if you are prepared to provide three (3) quality meals per day");
			}
			
            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.hostingEnvironment.isComplete = true;
				stResults.hostingEnvironment.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.hostingEnvironment.isComplete = false;
				stResults.hostingEnvironment.message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }

			
			/********************************************
				6 - Religious Preference
			********************************************/

            // Student Transportation
            if  ( NOT LEN(TRIM(qGetHostInfo.churchTrans)) ) {
				SESSION.formErrors.Add("Please indicate if you will provide transportation to the students religious services if they are different from your own.");
            }
			
            // Religious Affiliation
            if  ( NOT LEN(qGetHostInfo.informReligiousPref) ) {
				SESSION.formErrors.Add("Please indicate will voluntarily provide your religious affiliation.");
            }
			
			// Religious Preference
			if ( VAL(qGetHostInfo.informReligiousPref) AND NOT VAL(qGetHostInfo.religion) ) {
				SESSION.formErrors.Add("Please indicate your religious preference");
			}
			
            // Difficult different religion
            if  ( NOT LEN(qGetHostInfo.hostingDiff) ) {
				SESSION.formErrors.Add("Please indicate if anyone in your household has difficulty with hosting a student whoms religious differs from your own.");
            }
			
			// Religious Attandance
			if ( NOT LEN(qGetHostInfo.religious_participation) ) {
				SESSION.formErrors.Add("Please indicate How often do you go to your religious place of worship?");
			}
			
			// Expect Student
			if ( qGetHostInfo.religious_participation NEQ 'Inactive' AND NOT LEN(qGetHostInfo.churchFam) ) {
				SESSION.formErrors.Add("Please indicate if Would you expect your exchange student to attend services with your family?");
			}

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.religiousPreference.isComplete = true;
				stResults.religiousPreference.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.religiousPreference.isComplete = false;
				stResults.religiousPreference.message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }


			/********************************************
				7 - Family Rules
			********************************************/

            // Curfew School Nights
            if ( NOT LEN(TRIM(qGetHostInfo.houserules_curfewweeknights)) ) {
				SESSION.formErrors.Add("Please specify the curfew for school nights.");
            }	
            
            // Curfew Weekends
            if ( NOT LEN(TRIM(qGetHostInfo.houserules_curfewweekends)) ) {
				SESSION.formErrors.Add("Please specify the curfew for weekends.");
            }			
            
            // Chores
            if ( NOT LEN(TRIM(qGetHostInfo.houserules_chores)) ) {
				SESSION.formErrors.Add("Please list the chores that the student we responsible for.");
            }		
			
            // Computer Usage
            if ( NOT LEN(TRIM(qGetHostInfo.houserules_inet)) )  {
				SESSION.formErrors.Add("Please indicate any internet, computer or email usage restrictions you have.");
            }			
            
            // Expenses
            if ( NOT LEN(TRIM(qGetHostInfo.houserules_expenses)) )  {
				SESSION.formErrors.Add("Please indicate any expenses you expect the student to be responsible for.");
            }	

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.familyRules.isComplete = true;
				stResults.familyRules.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.familyRules.isComplete = false;
				stResults.familyRules.message = SESSION.formErrors.GetCollection();
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
				stResults.familyAlbum.isComplete = true;
				stResults.familyAlbum.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.familyAlbum.isComplete = false;
				stResults.familyAlbum.message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }


			/********************************************
				9 - School Info
			********************************************/
			
			// Selected School
			if ( NOT VAL(qGetHostInfo.schoolID) ) {
				SESSION.formErrors.Add("Please select a school from the drop down list");
			}
			
			// Works at School
			if ( NOT LEN(qGetHostInfo.schoolWorks) ) {
				SESSION.formErrors.Add("Please indicate if any member of your household works for the high school.");
			}		
			
			// Explanation of who works at school
			if ( qGetHostInfo.schoolWorks EQ 1 AND NOT LEN(TRIM(qGetHostInfo.schoolWorksExpl)) ) {
				SESSION.formErrors.Add("You have indicated that someone works with the school, but didn't explain.  Please provide details regarding the posistion.");
			}	
			
			//Been contacted by coach
			if ( NOT LEN(qGetHostInfo.schoolCoach) ) {
				SESSION.formErrors.Add("Please indicate if a coach has contacted you about hosting an exchange student.");
			}		
			
			// Coach explanation
			if ( qGetHostInfo.schoolCoach EQ 1 AND NOT LEN(TRIM(qGetHostInfo.schoolCoachExpl)) ) {
				SESSION.formErrors.Add("You have indicated that a coach contacted you, but didn't explain.  Please provide details regarding this contact.");
			}	
			
			// Other Transportation 
			if ( qGetHostInfo.schooltransportation is 'other' AND NOT LEN(TRIM(qGetHostInfo.schoolTransportationOther)) ) {
				SESSION.formErrors.Add("You indicated that the student will get to school but Other, but didn't specify what that other method would be.");
			}	
			
			// Transportaion
			if ( NOT LEN(TRIM(qGetHostInfo.schoolTransportation)) )  {
				SESSION.formErrors.Add("Please indicate how the student will get to school.");
			}
			
			// Extra Curricular Transportaion
			if ( NOT LEN(TRIM(qGetHostInfo.extraCuricTrans)) )  {
				SESSION.formErrors.Add("Please indicate if you will provide transportation to extracuricular activities.");
			}

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.schoolInfo.isComplete = true;
				stResults.schoolInfo.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.schoolInfo.isComplete = false;
				stResults.schoolInfo.message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }


			/********************************************
				10 - Community Profile
			********************************************/

            // nearbigCity
            if( NOT LEN(TRIM(qGetHostInfo.nearbigCity)) ) {
                SESSION.formErrors.Add("Please indicate the nearest town over 30,000 people.");
            }

			// major_air_code
            if( NOT LEN(TRIM(qGetHostInfo.major_air_code)) ) {
                SESSION.formErrors.Add("Please indicate your major airport code.");
            }

			// wintertemp
            if( NOT LEN(TRIM(qGetHostInfo.wintertemp)) ) {
                SESSION.formErrors.Add("Please indicate the average winter temp.");
            }

			// summertemp
            if( NOT LEN(TRIM(qGetHostInfo.summertemp)) ) {
                SESSION.formErrors.Add("Please indicate the average summer temp.");
            }
			
			// neighborhood            
            if( NOT LEN(TRIM(qGetHostInfo.neighborhood)) ) {
                SESSION.formErrors.Add("Please describe your neighborhood.");
            }

			// community
            if( NOT LEN(TRIM(qGetHostInfo.community)) ) {
                SESSION.formErrors.Add("Please describe your community.");
            }

            // avoidarea
            if( NOT LEN(TRIM(qGetHostInfo.avoidarea)) ) {
                SESSION.formErrors.Add("Please indicate if there are or are not areas to be avoided in your neighborhood.");
            }

			// special_cloths
            if( NOT LEN(TRIM(qGetHostInfo.special_cloths)) ) {
                SESSION.formErrors.Add("Please provide a list of any special cloths to bring.");
            }

			// point_interest
            if( NOT LEN(TRIM(qGetHostInfo.point_interest)) ) {
                SESSION.formErrors.Add("Please indicate any interests in your area.");
            }

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.communityProfile.isComplete = true;
				stResults.communityProfile.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.communityProfile.isComplete = false;
				stResults.communityProfile.message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }

			
			/********************************************
				11 - Confidential Data
			********************************************/

			// publicAssitance
			if ( NOT LEN(qGetHostInfo.publicAssitance) ) {
				SESSION.formErrors.Add("Please indicate if any member of your household is receiving any public assistance.");
			}	
			
			// publicAssitance
			if ( qGetHostInfo.publicAssitance EQ 1 AND NOT LEN(TRIM(qGetHostInfo.publicAssitanceExpl)) ) {
				SESSION.formErrors.Add("You have indicated that you receive public assistance, but did not explain.");
			}	
			
			// race
			if ( NOT LEN(TRIM(qGetHostInfo.race)) ) {
				SESSION.formErrors.Add("Please indicate the race of your household.");
			}
			
			// Income
			if ( NOT LEN(qGetHostInfo.income) ) {
				SESSION.formErrors.Add("Please indicate your household income.");
			}	
			
			// Crime Explanation
			if ( NOT LEN(qGetHostInfo.crime) ) {
				SESSION.formErrors.Add("Please indicate if any member in your household has beeen charged with a crime.");
			}	
			
			// Crime Explanation
			if ( qGetHostInfo.crime EQ 1 AND NOT LEN(TRIM(qGetHostInfo.crimeExpl)) ) {
				SESSION.formErrors.Add("You have indicated that someone has been charged with a crime, but did not explain.");
			}	
			
			// Child Protective Services
			if ( NOT LEN(qGetHostInfo.cps) ) {
				SESSION.formErrors.Add("Please indicate if you have been contacted by Child Protective Services.");
			}	
			
			// Child Protective Services
			if ( qGetHostInfo.cps EQ 1 AND NOT LEN(TRIM(qGetHostInfo.cpsExpl)) ) {
				SESSION.formErrors.Add("You have indicated that you have been contacted by Child Protective Services, but did not explain.");
			}	

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.confidentialData.isComplete = true;
				stResults.confidentialData.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.confidentialData.isComplete = false;
				stResults.confidentialData.message = SESSION.formErrors.GetCollection();
				SESSION.formErrors.clear();
            }


			/********************************************
				12- References
			********************************************/
			
			// Check if it is a single placement
			if ( LEN(qGetHostInfo.fatherFirstName) ) {
				vFather=1;
			} else {
				vFather=0;
			}
			
			if ( LEN(qGetHostInfo.motherFirstName) ) {
				vMother=1;
			} else {
				vMother=0;
			}
			
			// Total family members
			vTotalFamilyCount = vMother + vFather + qGetFamilyMembersAtHome.recordCount;
			
			// Single Parent
			if ( vTotalFamilyCount EQ 1 ) {
				vNumberOfRequiredReferences = 6;
			} else {
				vNumberOfRequiredReferences = 4;
			}
			
			vRemainingReferences = vNumberOfRequiredReferences - qGetReferences.recordcount;

			if ( VAL(vRemainingReferences) ) {
				SESSION.formErrors.Add("You need to provide an additional #vRemainingReferences# reference(s).");
			}

            // No Errors Found
            if ( NOT SESSION.formErrors.length() ) {
                stResults.applicationProgress = stResults.applicationProgress + 25;
				stResults.references.isComplete = true;
				stResults.references.message = "";
            // Errors Found - Erase queue for next section	
            } else {
				stResults.references.isComplete = false;
				stResults.references.message = SESSION.formErrors.GetCollection();
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
       
</cfcomponent>