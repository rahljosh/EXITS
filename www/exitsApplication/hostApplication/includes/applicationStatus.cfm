<!--- ------------------------------------------------------------------------- ----
	
	File:		applicationStatus.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Calculate Status

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>
		vApplicationProgress = 0;
	</cfscript>
    
    <!--- Host Family Information --->
    <cfquery name="qGetHFInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	* 
        FROM 
        	smg_hosts
        WHERE 
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
    </cfquery>
    
	<cfscript>
		// Family Last Name
		if ( NOT LEN(TRIM(qGetHFInfo.familylastname)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please enter your family last name.");
		}			
			  
		// Address
		if ( NOT LEN(TRIM(qGetHFInfo.address)) ) {
		  // Missing - Add to the error list
		  SESSION.formErrors.Add("Name & Contact Info Your home address is not valid.");
		}	
		
		// City
		if ( NOT LEN(TRIM(qGetHFInfo.city)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add(" Name & Contact Info You need to indicate which city your home is located in.");
		}	
		
		// State
		if ( NOT LEN(TRIM(qGetHFInfo.state)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add(" Name & Contact Info Please indicate which state your home is located in.");
		}	
		
		// Zip
		if ( NOT isValid("zipcode", TRIM(qGetHFInfo.zip)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add(" Name & Contact Info The zip code for home address is not a valid zip code.");
		}	
		
		// Mailing Address
		if ( NOT LEN(TRIM(qGetHFInfo.mailaddress)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please indicate your mailing address.");
		}	
		
		// Mailing City
		if (NOT LEN(TRIM(qGetHFInfo.mailcity)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Name & Contact Info Please indicate your mailing address city.");
		}	
		
		// Mailing State
		if ( NOT LEN(TRIM(qGetHFInfo.mailstate)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please indicate your mailing address state.");
		}	
		
		// Mailing Zip
		if ( NOT isValid("zipcode", TRIM(qGetHFInfo.mailzip)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info The zip code for mailing address is not a valid zip code.");
		}	
		
		// Phones
		if ( NOT LEN(TRIM(qGetHFInfo.phone)) AND NOT LEN(TRIM(qGetHFInfo.father_cell)) AND NOT LEN(TRIM(qGetHFInfo.mother_cell)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add(" Name & Contact Info Please enter one of the Phone fields: Home, Father Cell or Mother Cell");
		}	
		
		// Valid Phone
		if ( LEN(TRIM(qGetHFInfo.phone)) AND NOT isValid("telephone", TRIM(qGetHFInfo.phone)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info The home phone number you have entered does not appear to be valid. ");
		}	
		
		// Valid Email Address
		if ( LEN(TRIM(qGetHFInfo.email)) AND NOT isValid("email", TRIM(qGetHFInfo.email)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info The email address you have entered does not appear to be valid.");
		}	
		
		// Valid Father's DOB
		if ( LEN(TRIM(qGetHFInfo.fatherdob)) AND NOT isValid("date", TRIM(qGetHFInfo.fatherdob)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please enter a valid Date of Birth for the Father");
		}	
		
		/*
		// Valid Father's SSN
		if ( LEN(TRIM(qGetHFInfo.fatherssn)) AND NOT isValid("social_security_number", TRIM(qGetHFInfo.fatherssn)) ) {
		  // Missing - Add to the error list
		  SESSION.formErrors.Add("Please enter a valid Father's SSN");
		}	
		*/
		
		// Valid Father's Phone
		if ( LEN(TRIM(qGetHFInfo.father_cell)) AND NOT isValid("telephone", TRIM(qGetHFInfo.father_cell)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please enter a valid phone number for the Father's Cell Phone.");
		}	
		
		// Valid Mother's DOB
		if ( LEN(TRIM(qGetHFInfo.motherdob)) AND NOT isValid("date", TRIM(qGetHFInfo.motherdob)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info The date you specified is not valid for Mother's Date of Birth");
		}	
		
		/*
		// Valid Mother's SSN
		if ( LEN(TRIM(qGetHFInfo.motherssn)) AND NOT isValid("social_security_number", TRIM(qGetHFInfo.motherssn)) ) {
		  // Missing - Add to the error list
		  SESSION.formErrors.Add("Please enter a valid Mother's SSN");
		}	
		*/
		
		// Valid Mother's Phone
		if ( LEN(TRIM(qGetHFInfo.mother_cell)) AND NOT isValid("telephone", TRIM(qGetHFInfo.mother_cell)) ) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please enter a valid phoe number for Mother's Cell Phone");
		}
		
		// FhomeIsFunctBusiness
		if (qGetHFInfo.homeIsFunctBusiness EQ 3) {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please indicate if your home is also a functioning business.");
		}
		
		// homeBusinessDesc
		if (( qGetHFInfo.homeIsFunctBusiness EQ 1) AND NOT LEN(TRIM(qGetHFInfo.homeBusinessDesc)) )  {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info You have indicated that your home is also a business, but have not provided details on the type of business.");
		}
		
		// fatherlastname
		if (NOT LEN(TRIM(qGetHFInfo.fatherlastname)) and not len(trim(qGetHFInfo.motherlastname)) )  {
		 	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info If you are single, you must provide information for at least one of the host parents, either the father or mother. If you are not single, please provide information on both host parents.");
		}
		
		// fatherdob
		if ( LEN(TRIM(qGetHFInfo.fatherfirstname)) and not len(trim(qGetHFInfo.fatherdob)) )  {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please provide the birthdate for the Host Father.");
		}
		
		// fatherworktype
		if ( LEN(TRIM(qGetHFInfo.fatherfirstname)) and not len(trim(qGetHFInfo.fatherworktype)) )  {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please provide the occupation for the Host Father.");
		}
		
		// motherdob
		if (LEN(TRIM(qGetHFInfo.motherfirstname)) and not len(trim(qGetHFInfo.motherdob)) )  {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please provide the birthdate for the Host Mother.");
		}
		
		// motherworktype
		if (LEN(TRIM(qGetHFInfo.motherfirstname)) and not len(trim(qGetHFInfo.motherworktype)) )  {
		  	// Missing - Add to the error list
		  	SESSION.formErrors.Add("Name & Contact Info Please provide the occupation for the Host Mother.");
		}
    
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>


    <!--- Family Members --->
    <cfquery name="qGetFamilyMembers" datasource="#APPLICATION.DSN.Source#">
    	SELECT 
        	*
    	FROM 
        	smg_host_children
    	WHERE 
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHFInfo.hostID)#">
    </cfquery>

	<cfif qGetFamilyMembers.recordcount>
    
        <cfloop query="qGetFamilyMembers">
        
			<cfscript>
                // Family Last Name
                if ( NOT LEN(TRIM(name)) ) {
                    // Missing - Add to the error list
                    SESSION.formErrors.Add("Family Members Please enter the first name.");
                }			
                
                if ( NOT LEN(TRIM(membertype)) ) {
                    // Missing - Add to the error list
                    SESSION.formErrors.Add("Family Members Please enter the relation for #name#.");
                }	
                
                if ( NOT LEN(TRIM(birthdate)) ) {
                    // Missing - Add to the error list
                    SESSION.formErrors.Add("Family Members Please enter the date of birth for #name#.");
                }
                
                if ( NOT LEN(TRIM(sex)) ) {
                    // Missing - Add to the error list
                    SESSION.formErrors.Add("Family Members Please enter the sex of #name#.");
                }
                
                if ( NOT LEN(TRIM(sex)) ) {
                    // Missing - Add to the error list
                    SESSION.formErrors.Add("Family MembersPlease enter the sex of #name#.");
                }
            </cfscript>
        
        </cfloop>
        
    </cfif>
	
    <cfscript>
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>


	<!--- Family Interests --->			      
    <cfquery name="qGetHostInterests" datasource="#APPLICATION.DSN.Source#">
        select 
        	interests, 
            interests_other, 
            playBand,
            playOrchestra, 
            playCompSports, 
            orcInstrument, 
            bandInstrument, 
            sportDesc
        from 
        	smg_hosts
        where 
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHFInfo.hostID)#">
    </cfquery>
    
    <cfscript>
		vRequiredInterests = 3 - len(qGetHostInterests.interests);
	
		//Play in Band
		if ( len(qGetHostInterests.interests) LT 3) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Family Interests Please spedicfy at least #vRequiredInterests# more interest(s) from the list.");
		}
		
		//Play in Band
		if ( qGetHostInterests.playBand EQ 3) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Family Interests Please indicate if any one in your home plays in a band.");
		}
		
		// Competitve Sports
		if ( qGetHostInterests.playCompSports EQ 3) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Family Interests Please indicate if any one in your home plays competitve sports.");
		}
		
		// Address Lookup
		if ( qGetHostInterests.playOrchestra EQ 3) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Family Interests Please indicate if any one in your home plays in an orchestra.");
		}	
		
		//Band Answer
		if (( qGetHostInterests.playBand EQ 1) AND NOT LEN(TRIM(qGetHostInterests.bandinstrument)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Family Interests You have indicated that someone plays in a band, but you have not indicated what instrument they play.");
		}
		
		//Orchestra  Answer
		if (( qGetHostInterests.playOrchestra EQ 1) AND NOT LEN(TRIM(qGetHostInterests.orcinstrument)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Family Interests You have indicated that someone plays in an orchestra, but you have not indicated what instrument they play.");
		}
		
		//Comp Sport  Answer
		if (( qGetHostInterests.playCompSports EQ 1) AND NOT LEN(TRIM(qGetHostInterests.sportDesc)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Family Interests You have indicated that someone plays a competitive sport, but you have not indicated what sport they play.");
		}
		
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>


	<!--- Personal Description --->
    <cfscript>
		//No Letter
		if (  (LEN(TRIM(qGetHFInfo.familyletter)) EQ 0)) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Personal Description The personal description is required. .");
		}
		
		//Letter to Short
		if ( (LEN(TRIM(qGetHFInfo.familyletter)) GTE 1) AND (LEN(TRIM(qGetHFInfo.familyletter)) LT 300)  ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Personal Description Your personal description is to short, please add more information.");
		}

		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>


	<!--- Family Album --->   
    <cfquery name="qGetHostPicturesCategories" datasource="#APPLICATION.DSN.Source#">
    	SELECT 
        	*
    	FROM 
        	smg_host_pic_cat 
        WHERE 
        	catID != <cfqueryparam cfsqltype="cf_sql_integer" value="7"> <!---Don't include Other description --->
    </cfquery>
    
    <cfquery name="qGetHostPictures" datasource="#APPLICATION.DSN.Source#">
        SELECT 
            *
        FROM 
            smg_host_picture_album
        WHERE 
            fk_hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHFInfo.hostID)#">
    </cfquery>
        
    <cfloop query="qGetHostPicturesCategories">
    
        <cfquery name="catExist" dbtype="query">
            select 
            	id
            from 
            	qGetHostPictures
            where 
            	cat = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostPicturesCategories.catId)#">
        </cfquery>
        
		<cfscript>
            if ( NOT VAL(catExist.recordcount) )  {
                // Missing - Add to the error list
                SESSION.formErrors.Add("Family Album You seem to be missing a picutre of: #qGetHostPicturesCategories.cat_name#.");
            }
        </cfscript>
        
    </cfloop> 
    
    <cfscript>
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>


	<!--- Hosting Environment --->   
    <cfscript>
		// Family Smokes
		if ( NOT LEN(TRIM(qGetHFInfo.smokes)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Hosting Environment Please indicate if any one in your family smokes.");
		}
		
		//Student Smokes
		if ( NOT LEN(TRIM(qGetHFInfo.acceptsmoking)) )   {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Hosting Environment Please indicate if you would be willing to host a student who smokes.");
		}	
		
		//Student smoke conditions
		if (( qGetHFInfo.acceptsmoking EQ 1) AND NOT LEN(TRIM(qGetHFInfo.smokeconditions)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Hosting Environment You have indicated that you would host a student who smokes, but did not indicate under what conditions.");
		}
		
		// Family Dietary Restrictions
		if ( NOT LEN(TRIM(qGetHFInfo.famDietRest)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Hosting Environment Please indicate if your family follows any dietary restrictions.");
		}
		
		if (( qGetHFInfo.famDietRest EQ 1) AND NOT LEN(TRIM(qGetHFInfo.famDietRestDesc)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Hosting Environment You have indicated that your family has dietary restrictions, but did not describe them.");
		}
		
		// Student Dietery Restrictions
		if ( NOT LEN(TRIM(qGetHFInfo.stuDietRest)) )   {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Hosting Environment Please indicate if you expect the student to follow any dietary restrictions.");
		}
		
		if (( qGetHFInfo.stuDietRest EQ 1) AND NOT LEN(TRIM(qGetHFInfo.stuDietRestDesc)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Hosting Environment You have indicated that you expect the student to follow certain dietary restrictions, but did not describe them.");
		}
		
		// Three Squares
		if ( NOT LEN(TRIM(qGetHFInfo.threesquares)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Hosting Environment Please indicate if you are prepared to provide three (3) quality meals per day.");
		}
		
		// Allergies
		if  ( NOT LEN(TRIM(qGetHFInfo.pet_allergies)) ){
			// Missing - Add to the error list
			SESSION.formErrors.Add("Hosting Environment Please indicate if you would be willing to host a student who is allergic to animals.");
		}
		
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>
    

	<!--- Religion Pref --->   
    <cfscript>
		//REligions Belief
		if ( NOT LEN(TRIM(qGetHFInfo.religion)) )   {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Religion Pref Please indicate your religious preference.");
		}
		
		if (( qGetHFInfo.religion gt 0) AND (qGetHFInfo.religious_participation EQ -1))  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Religion Pref You have indicated a religious belief but have not answered the question: How often do you go to your religious establishment?");
		}
		
		if ((( qGetHFInfo.religious_participation EQ 4) OR (qGetHFInfo.religious_participation EQ 3) OR (qGetHFInfo.religious_participation EQ 2)) and (qGetHFInfo.churchtrans eq 3))  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Religion Pref You have indicated that you go attend religious services, but did not answer: Would you expect your exchange student to attend services with your family?");
		}
		
		// Student Transportation
		if ( NOT LEN(TRIM(qGetHFInfo.churchtrans)) )   {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Religion Pref Please indicate if you will provide transportation to the students religious services if they are different from your own.");
		}
		
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>


	<!--- Church Info --->     
    <cfif VAL(qGetHFInfo.churchid)>
    	
        <cfquery name="churchInfo" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                *
            FROM 
                churches 
            WHERE 
                churchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHFInfo.churchid)#">
        </cfquery>
    
		<cfscript>
			// churchName
			if ( NOT LEN(TRIM(churchInfo.churchName)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("Church Info Please enter the name of your religious institution.");
			}			
			
			// Address
			if ( NOT LEN(TRIM(churchInfo.address)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("Church Info Please enter the address.");
			}	
			
			// City
			if ( NOT LEN(TRIM(churchInfo.city)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("Church Info Please enter the city.");
			}			
			
			// State
			if ( NOT LEN(TRIM(churchInfo.state)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("Please select the state");
			}		
			
			// Zip
			if ( NOT LEN(TRIM(churchInfo.zip)) )  {
				// Missing - Add to the error list
				SESSION.formErrors.Add("Church Info Please enter a zip code.");
			}			
			
			// pastor
			if ( NOT LEN(TRIM(churchInfo.pastor)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("Church Info Please enter the religious leaders name.");
			}
			
			// phone
			if ( NOT LEN(TRIM(churchInfo.phone)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("Church Info Please enter the phone number of your religious institution.");
			}	
			
			// No Errors Found
			if ( NOT SESSION.formErrors.length() ) {
				vApplicationProgress = vApplicationProgress + 27;
			// Errors Found - Erase queue for next section	
			} else {
				SESSION.formErrors.clear();
			}
        </cfscript>     
    
    </cfif>     
        

    <!--- Community Info --->         
    <cfscript>
		// population
		if ( NOT LEN(TRIM(qGetHFInfo.population)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please enter the population of your city.");
		}			
		
		// nearbigcity
		if ( NOT LEN(TRIM(qGetHFInfo.nearbigcity)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please enter the nearest major city.");
		}	
		
		// near_City_Dist
		if ( NOT LEN(TRIM(qGetHFInfo.near_City_Dist)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please enter the distance to the nearest major city.");
		}			
		
		// near_pop
		if ( NOT LEN(TRIM(qGetHFInfo.near_pop)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please enter the population of the nearest major city.");
		}		
		
		// neighborhood
		if ( NOT LEN(TRIM(qGetHFInfo.neighborhood)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please describe your neighborhood.");
		}			
		
		// local_Air_code
		if ( NOT LEN(TRIM(qGetHFInfo.local_Air_code)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please enter the local airport three letter code.");
		}		
		
		// major_Air_code
		if ( NOT LEN(TRIM(qGetHFInfo.major_Air_code)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please enter the major airport three letter code.");
		}	
		
		// community
		if ( NOT LEN(TRIM(qGetHFInfo.community)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please describe your community.");
		}		
		
		// terrain1
		if ( NOT LEN(TRIM(qGetHFInfo.terrain1)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please describe your terrain as hilly or flat.");
		}			
		
		// terrain2
		if ( NOT LEN(TRIM(qGetHFInfo.terrain2)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please indicate if the terrain has trees or no trees.");
		}	
		
		// terrain3
		if ( NOT LEN(TRIM(qGetHFInfo.terrain3)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please indicate in terrain, if you have any type of water near you.");
		}	
		
		// wintertemp
		if ( NOT LEN(TRIM(qGetHFInfo.wintertemp)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please enter the average winter temp.");
		}			
		
		// summertemp
		if ( NOT LEN(TRIM(qGetHFInfo.summertemp)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please enter the average summer temp.");
		}		
		
		// snowy_winter
		if ( NOT LEN(TRIM(qGetHFInfo.snowy_winter)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please describe your neighborhood.");
		}			
		
		// snowy_winter ...
		if (
				qGetHFInfo.snowy_winter EQ 3
			AND 
				qGetHFInfo.rainy_winter EQ 3
			AND 
				qGetHFInfo.hot_summer EQ 3 
			AND 
				qGetHFInfo.mild_summer EQ 3 
			AND 
				qGetHFInfo.high_hummidity EQ 3 
			AND 
				qGetHFInfo.dry_air EQ 3 
			AND 
				qGetHFInfo.hot_summer EQ 3 ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please check at least one box to describe your seasons.");
		}	
		
		// special_cloths
		if ( NOT LEN(TRIM(qGetHFInfo.special_cloths)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please indicate anyparticular clothes, sports equipment, etc. that your student should consider bringing.");
		}
		
		// point_interest
		if ( NOT LEN(TRIM(qGetHFInfo.point_interest)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Community Info Please describe the points of interest and available activities/opportunities for teenagers in your surrounding area.");
		}
		
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>         


	<!--- School Info ---> 
    <cfquery name="schoolInfo" datasource="#APPLICATION.DSN.Source#">
    	SELECT
        	*
    	FROM 
        	smg_schools
    	WHERE
        	schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHFInfo.schoolid)#">
    </cfquery>
    
    <cfscript>
		// schooltransportation
		if ( NOT LEN(TRIM(qGetHFInfo.schooltransportation)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info Please indicate how the student will get to school.");
		}
		
		// schoolWorks
		if ( qGetHFInfo.schoolWorks EQ 3 ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info Please indicate if any member of your household works for the high school.");
		}		
		
		// schoolWorks
		if ( (qGetHFInfo.schoolWorks EQ 1) AND (NOT LEN(TRIM(qGetHFInfo.schoolWorksExpl))) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info You have indicated that someone works with the school, but didn't explain.  Please provide details regarding the posistion.");
		}	
		
		// schoolCoach
		if ( qGetHFInfo.schoolCoach EQ 3 ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info Please indicate if a coach has contacted you about hosting an exchange student.");
		}		
		
		// schoolCoach
		if ( (qGetHFInfo.schoolCoach EQ 1) AND (NOT LEN(TRIM(qGetHFInfo.schoolCoachExpl))) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info You have indicated that a coach contacted you, but didn't explain.  Please provide details regarding this contact.");
		}	
		
		// school_trans
		if ( (qGetHFInfo.school_trans is 'other') AND (NOT LEN(TRIM(qGetHFInfo.other_trans))) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info You indicated that the student will get to school but Other, but didn't specify what that other method would be.");
		}	
		
		//  schoolname
		if ( NOT LEN(TRIM(schoolInfo.schoolname)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info Please enter the name of the school.");
		}			
		
		// address
		if ( NOT LEN(TRIM(schoolInfo.address)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info Please enter the address of the school.");
		}	
		
		// city
		if ( NOT LEN(TRIM(schoolInfo.city)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info Please enter the city the school is located in.");
		}			
		
		// State
		if ( NOT LEN(TRIM(schoolInfo.state)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info Please enter the state the school is located in.");
		}		
		
		// Zip
		if ( NOT LEN(TRIM(schoolInfo.zip)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("School Info Please enter the school's zip code.");
		}	
		
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript> 
    

	<!--- House Rules  ---> 
    <cfscript>
		// houserules_smoke
		if ( NOT LEN(TRIM(qGetHFInfo.houserules_smoke)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("House Rules Please enter your rules for smoking at the home.");
		}			
		
		// houserules_curfewweeknights
		if ( NOT LEN(TRIM(qGetHFInfo.houserules_curfewweeknights)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("House Rules Please specify the curfew for school nights.");
		}	
		
		// houserules_curfewweekends
		if ( NOT LEN(TRIM(qGetHFInfo.houserules_curfewweekends)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("House Rules Please specify the curfew for weekends.");
		}			
		
		// houserules_chores
		if ( NOT LEN(TRIM(qGetHFInfo.houserules_chores)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("House Rules Please list the chores that the student we responsible for.");
		}		
		
		// houserules_church
		if ( NOT LEN(TRIM(qGetHFInfo.houserules_church)) )  {
			// Missing - Add to the error list
			SESSION.formErrors.Add("House Rules Please indicate any specific rules regarding religious expectations.");
		}	
		
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>
    
    
	<!--- References --->
    <cfquery name="qGetReferences" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	*
        FROM 
        	smg_family_references
        WHERE 
        	referencefor = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHFInfo.hostID)#">
    </cfquery>
    
    <!---number kids at home --->
    <cfquery name="qGetTotalMembersAtHome" dbtype="query">
        SELECT 
        	childID
        FROM 
        	qGetFamilyMembers
        WHERE 
    		liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
    </cfquery>
    
    <cfscript>
		if ( LEN(qGetHFInfo.fatherfirstname) ) {
			vFather=1;
		} else {
			vFather=0;
		}
		
		if ( LEN(qGetHFInfo.motherfirstname) ) {
			vMother=1;
		} else {
			vMother=0;
		}
		
		vTotalFamilyCount = vMother + vFather + qGetTotalMembersAtHome.recordCount;
		
		// Single Parent
		if ( vTotalFamilyCount EQ 1 ) {
			vNumberOfRequiredReferences = 6;
		} else {
			vNumberOfRequiredReferences = 4;
		}
		
		vRemainingReferences = vNumberOfRequiredReferences - qGetReferences.recordcount;
	</cfscript>
    
    <cfloop query="qGetReferences">
    
		<cfscript>
			// firstname
			if ( NOT LEN(TRIM(firstname)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("References Please enter the first name.");
			}			
			
			// lastname
			if ( NOT LEN(TRIM(lastname)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("References Please enter the last name for #firstname#.");
			}	
			
			// City
			if ( NOT LEN(TRIM(address)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("References Please enter the address for #firstname#.");
			}			
			
			// City
			if ( NOT LEN(TRIM(city)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("References Please enter the city for #firstname#.");
			}		
			
			// State
			if ( NOT LEN(TRIM(state)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("References Please select the state for #firstname#.");
			}		
			
			// Zip
			if ( NOT LEN(TRIM(zip)) )  {
				// Missing - Add to the error list
				SESSION.formErrors.Add("References Please enter a zip code for #firstname#.");
			}			
			
			// phone
			if ( NOT LEN(TRIM(phone)) ) {
				// Missing - Add to the error list
				SESSION.formErrors.Add("References Please enter the phone number for #firstname#.");
			}	
        </cfscript>
        
    </cfloop>
    
    <cfscript>
		//Make sure there are enough references
		if ( vRemainingReferences GT 0 ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("References You need to provide an additional #vRemainingReferences# reference(s).");
		}
		
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>


	<!--- Finance Data --->        
    <cfscript>
		// publicAssitance
		if (NOT LEN(TRIM(qGetHFInfo.publicAssitance))) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Finance Data Please indicate if any member of your household is receiving any public assistance.");
		}			
		
		// crime
		if (NOT LEN(TRIM(qGetHFInfo.crime))) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Finance Data Please indicate if any member in your household has beeen charged with a crime.");
		}	
		
		// crimeExpl
		if ( (qGetHFInfo.crime EQ 1) AND (NOT LEN(TRIM(qGetHFInfo.crimeExpl))) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Finance Data You have indicated that someone has been charged with a crime, but did not explain.");
		}			
		
		// income
		if( NOT LEN(TRIM(qGetHFInfo.income)) ) {
			// Missing - Add to the error list
			SESSION.formErrors.Add("Finance Data Please indicate your household income.");
		}	
		
		// No Errors Found
		if ( NOT SESSION.formErrors.length() ) {
			vApplicationProgress = vApplicationProgress + 27;
		// Errors Found - Erase queue for next section	
		} else {
			SESSION.formErrors.clear();
		}
    </cfscript>
    
</cfsilent>