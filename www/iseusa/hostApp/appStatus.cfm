
<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<Cfquery name="cl" datasource="mysql">
SELECT * 
FROM smg_hosts
WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(client.hostid)#"> 
</cfquery>

<cfset appNotComplete = 0>
<Cfoutput>
<!--------------------------->
<!----Name & Contact Info---->
<cfscript>
            // Data Validation
			
			// Family Last Name
            if ( NOT LEN(TRIM(cl.familylastname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please enter your family last name.");
            }			
        	
					
			// Address
            if ( NOT LEN(TRIM(cl.address)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Your home address is not valid.");
            }	

			// City
            if ( NOT LEN(TRIM(cl.city)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add(" Name & Contact Info You need to indicate which city your home is located in.");
            }	

			// State
            if ( NOT LEN(TRIM(cl.state)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add(" Name & Contact Info Please indicate which state your home is located in.");
            }	

			// Zip
            if ( NOT isValid("zipcode", TRIM(cl.zip)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add(" Name & Contact Info The zip code for home address is not a valid zip code.");
            }	

			
			// Mailing Address
            if ( NOT LEN(TRIM(cl.mailaddress)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please indicate your mailing address.");
            }	

			// Mailing City
            if (NOT LEN(TRIM(cl.mailcity)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please indicate your mailing address city.");
            }	

			// Mailing State
            if ( NOT LEN(TRIM(cl.mailstate)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please indicate your mailing address state.");
            }	

			// Mailing Zip
            if ( NOT isValid("zipcode", TRIM(cl.mailzip)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info The zip code for mailing address is not a valid zip code.");
            }	
	
			// Phones
            if ( NOT LEN(TRIM(cl.phone)) AND NOT LEN(TRIM(cl.father_cell)) AND NOT LEN(TRIM(cl.mother_cell)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add(" Name & Contact Info Please enter one of the Phone fields: Home, Father Cell or Mother Cell");
            }	
	
			// Valid Phone
            if ( LEN(TRIM(cl.phone)) AND NOT isValid("telephone", TRIM(cl.phone)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info The home phone number you have entered does not appear to be valid. ");
            }	
	
			// Valid Email Address
            if ( LEN(TRIM(cl.email)) AND NOT isValid("email", TRIM(cl.email)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info The email address you have entered does not appear to be valid.");
            }	
			
			// Valid Father's DOB
            if ( LEN(TRIM(cl.fatherdob)) AND NOT isValid("date", TRIM(cl.fatherdob)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please enter a valid Date of Birth for the Father");
            }	

			/*
			// Valid Father's SSN
            if ( LEN(TRIM(cl.fatherssn)) AND NOT isValid("social_security_number", TRIM(cl.fatherssn)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a valid Father's SSN");
            }	
			*/

			// Valid Father's Phone
            if ( LEN(TRIM(cl.father_cell)) AND NOT isValid("telephone", TRIM(cl.father_cell)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please enter a valid phone number for the Father's Cell Phone.");
            }	

			// Valid Mother's DOB
            if ( LEN(TRIM(cl.motherdob)) AND NOT isValid("date", TRIM(cl.motherdob)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info The date you specified is not valid for Mother's Date of Birth");
            }	
			
			/*
			// Valid Mother's SSN
            if ( LEN(TRIM(cl.motherssn)) AND NOT isValid("social_security_number", TRIM(cl.motherssn)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a valid Mother's SSN");
            }	
			*/

			// Valid Mother's Phone
            if ( LEN(TRIM(cl.mother_cell)) AND NOT isValid("telephone", TRIM(cl.mother_cell)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please enter a valid phoe number for Mother's Cell Phone");
			}
			// Functioning Business
            if ( cl.homeIsFunctBusiness EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please indicate if your home is also a functioning business.");
			}
			
			// No business Des
            if (( cl.homeIsFunctBusiness EQ 1) AND NOT LEN(TRIM(cl.homeBusinessDesc)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info You have indicated that your home is also a business, but have not provided details on the type of business.");
			}
			// No business Des
            if (NOT LEN(TRIM(cl.fatherlastname)) and not len(trim(cl.motherlastname)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info If you are single, you must provide information for at least one of the host parents, either the father or mother. If you are not single, please provide information on both host parents.");
			}
			
			// Father is Required
            if ( LEN(TRIM(cl.fatherfirstname)) and not len(trim(cl.fatherdob)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please provide the birthdate for the Host Father.");
			}
			
						// Father is Required
            if ( LEN(TRIM(cl.fatherfirstname)) and not len(trim(cl.fatherworktype)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please provide the occupation for the Host Father.");
			}
			
			// Father is Required
            if (LEN(TRIM(cl.motherfirstname)) and not len(trim(cl.motherdob)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please provide the birthdate for the Host Mother.");
			}
			
			// Mother First is Required
            if (LEN(TRIM(cl.motherfirstname)) and not len(trim(cl.motherworktype)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Name & Contact Info Please provide the occupation for the Host Mother.");
			}
		</cfscript>
        
        <cfif SESSION.formErrors.length()>
        <cfscript>
        	Session.formErrors.clear();
      	</cfscript>
	    <cfelse>
				<cfset appNotComplete = #appNotComplete# + 23.75>	
        </cfif>

<!------------------------>
<!----Family Members---->
<Cfquery name="familyMembers" datasource="mysql">
	SELECT *
	FROM smg_host_children
	WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(cl.hostid)#"> 
</cfquery>
<Cfif familyMembers.recordcount gt 0>
<Cfloop query="familyMembers">
			<cfscript>
            // Data Validation
			// Family Last Name
            if ( NOT LEN(TRIM(name)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Members Please enter the first name.");
            }			
        	

			
			if ( NOT LEN(TRIM(membertype)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Members Please enter the relation for #name#.");
            }	
			
			if ( NOT LEN(TRIM(birthdate)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Members Please enter the date of birth for #name#.");
            }
			
			if ( NOT LEN(TRIM(sex)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Members Please enter the sex of #name#.");
            }
			
			if ( NOT LEN(TRIM(sex)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family MembersPlease enter the sex of #name#.");
            }
	
			 </cfscript>
	</cfloop>
 </Cfif>
 
  <cfif SESSION.formErrors.length()>
  	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
  <cfelse>
				<cfset appNotComplete = #appNotComplete# + 23.75>	
  </cfif>

<!------------------------>
<!----Family Interests---->
		      
        <cfquery name="host_interests" datasource="MySQL">
        select interests, interests_other, playBand, playOrchestra, playCompSports, orcInstrument, bandInstrument, sportDesc
        from smg_hosts
        where hostid=#client.hostid#
        </cfquery>
        
        <cfquery name="get_interests" datasource="MySQL">
        select *
        from smg_interests
        order by interest
        </cfquery>
       <Cfset inttogo = 3 - len(host_interests.interests)>
 		<cfscript>
            // Data Validation
			//Play in Band
			 if ( len(host_interests.interests) LT 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Interests Please spedicfy at least #inttogo# more interest(s) from the list.");
			 }
			//Play in Band
			 if ( host_interests.playBand EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Interests Please indicate if any one in your home plays in a band.");
			 }
			
			// Competitve Sports
             if ( host_interests.playCompSports EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Interests Please indicate if any one in your home plays competitve sports.");
			 }
			 
			// Address Lookup
            if ( host_interests.playOrchestra EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Interests Please indicate if any one in your home plays in an orchestra.");
			 }	
			//Band Answer
			 if (( host_interests.playBand EQ 1) AND NOT LEN(TRIM(host_interests.bandinstrument)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Interests You have indicated that someone plays in a band, but you have not indicated what instrument they play.");
			}
			//Orchestra  Answer
			 if (( host_interests.playOrchestra EQ 1) AND NOT LEN(TRIM(host_interests.orcinstrument)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Interests You have indicated that someone plays in an orchestra, but you have not indicated what instrument they play.");
			}
			//Comp Sport  Answer
			 if (( host_interests.playCompSports EQ 1) AND NOT LEN(TRIM(host_interests.sportDesc)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Family Interests You have indicated that someone plays a competitive sport, but you have not indicated what sport they play.");
			}
		</cfscript>
		
		<cfif SESSION.formErrors.length()>
        	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
        <Cfelse>
		<cfset appNotComplete = #appNotComplete# + 23.75>	</cfif>
<!------------------------>
<!----Personal Description---->
    
         <cfscript>
            // Data Validation
			//No Letter
			 if (  (LEN(TRIM(cl.familyletter)) EQ 0)) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Personal Description The personal description is required. .");
			 }
			
			//Letter to Short
			 if (  (LEN(TRIM(cl.familyletter)) GTE 1) AND (LEN(TRIM(cl.familyletter)) LT 300)  ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Personal Description Your personal description is to short, please add more information.");
			 }
		
		</cfscript>
        
         <cfif SESSION.formErrors.length()>
         	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
         <Cfelse>
		 <cfset appNotComplete = #appNotComplete# + 23.75>	</cfif>  
	
<!------------------------>
<!----Family Album---->   

<Cfquery name="hostPicCat" datasource="mysql">
	select *
    from smg_host_pic_cat
    <!---Don't include Other description---->
    where catID != 7
</Cfquery>
<Cfquery name="hostPics" datasource="mysql">
	select *
    from smg_host_picture_album
    where fk_hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(client.hostid)#"> 
</Cfquery>
<cfloop query="hostPicCat">
	<cfquery dbtype="query" name="catExist">
    select id
    from hostPics
    where cat = #catId#
    </cfquery>
	<Cfif catExist.recordcount eq 0>
		 <cfscript>
                // Data Validation
                //No Letter
                 if (  1 EQ 1) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("Family Album You seem to be missing a picutre of: #hostPicCat.cat_name#.");
                 }
                                    
            </cfscript>
    </Cfif>

</cfloop> 
<cfif SESSION.formErrors.length()>
	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
<cfelse>
<cfset appNotComplete = #appNotComplete# + 23.75>	
</cfif>
 
<!------------------------>
<!----Hosting Environment---->   
     <cfquery name="get_kids" datasource="MySQL">
    select childid, name, shared
    from smg_host_children
    where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(client.hostid)#">  
    </cfquery>
    

      <cfscript>
            // Data Validation
						
			// Family Smokes
             if ( NOT LEN(TRIM(cl.smokes)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Hosting Environment Please indicate if any one in your family smokes.");
			 }
			 
			//Student Smokes
            if ( NOT LEN(TRIM(cl.acceptsmoking)) )   {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Hosting Environment Please indicate if you would be willing to host a student who smokes.");
			 }	
			 //Student smoke conditions
			 if (( cl.acceptsmoking EQ 1) AND NOT LEN(TRIM(cl.smokeconditions)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Hosting Environment You have indicated that you would host a student who smokes, but did not indicate under what conditions.");
			}
			
			 // Family Dietary Restrictions
             if ( NOT LEN(TRIM(cl.famDietRest)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Hosting Environment Please indicate if your family follows any dietary restrictions.");
			 }
			 if (( cl.famDietRest EQ 1) AND NOT LEN(TRIM(cl.famDietRestDesc)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Hosting Environment You have indicated that your family has dietary restrictions, but did not describe them.");
			}
			 
			// Student Dietery Restrictions
            if ( NOT LEN(TRIM(cl.stuDietRest)) )   {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Hosting Environment Please indicate if you expect the student to follow any dietary restrictions.");
			 }
			 if (( cl.stuDietRest EQ 1) AND NOT LEN(TRIM(cl.stuDietRestDesc)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Hosting Environment You have indicated that you expect the student to follow certain dietary restrictions, but did not describe them.");
			}
			 
			 // Three Squares
             if ( NOT LEN(TRIM(cl.threesquares)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Hosting Environment Please indicate if you are prepared to provide three (3) quality meals per day.");
			 }
			
			 
			// Allergies
            if  ( NOT LEN(TRIM(cl.pet_allergies)) ){
                // Get all the missing items in a list
                SESSION.formErrors.Add("Hosting Environment Please indicate if you would be willing to host a student who is allergic to animals.");
			 }
		</cfscript>
        
		
		<cfif SESSION.formErrors.length()>
        	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
        <Cfelse>
			<cfset appNotComplete = #appNotComplete# + 23.75>	
        </cfif>
        
<!------------------------>
<!----Religion Pref---->   
          <cfscript>
            // Data Validation
			//REligions Belief
			if ( NOT LEN(TRIM(cl.religion)) )   {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Religion Pref Please indicate your religious preference.");
			 }

			if (( cl.religion gt 0) AND (cl.religious_participation EQ -1))  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Religion Pref You have indicated a religious belief but have not answered the question: How often do you go to your religious establishment?");
			 }
			 if ((( cl.religious_participation EQ 4) OR (cl.religious_participation EQ 3) OR (cl.religious_participation EQ 2)) and (cl.churchtrans eq 3))  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Religion Pref You have indicated that you go attend religious services, but did not answer: Would you expect your exchange student to attend services with your family?");
			 }
			 // Student Transportation
			 if ( NOT LEN(TRIM(cl.churchtrans)) )   {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Religion Pref Please indicate if you will provide transportation to the students religious services if they are different from your own.");
			 }
			
			 
        </cfscript>
		
		<cfif SESSION.formErrors.length()>
        	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
        <cfelse>
				<cfset appNotComplete = #appNotComplete# + 23.75>	</cfif> 
        
   
<!------------------------>
<!----Church Info---->     
<cfif cl.churchid gt 0>
	<Cfquery name="churchInfo" datasource="mysql">
    select *
    from churches 
    where churchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(cl.churchid)#">  
    </cfquery>

            <cfscript>
            // Data Validation
			// Family Last Name
            if ( NOT LEN(TRIM(churchInfo.churchName)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Church Info Please enter the name of your religious institution.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(churchInfo.address)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Church Info Please enter the address.");
            }	
			
			// City
            if ( NOT LEN(TRIM(churchInfo.city)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Church Info Please enter the city.");
            }			
        	
        	// State
            if ( NOT LEN(TRIM(churchInfo.state)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please select the state");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(churchInfo.zip)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Church Info Please enter a zip code.");
            }			
        	
			// Family Last Name
            if ( NOT LEN(TRIM(churchInfo.pastor)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Church Info Please enter the religious leaders name.");
            }
			
			// Family Last Name
            if ( NOT LEN(TRIM(churchInfo.phone)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Church Info Please enter the phone number of your religious institution.");
            }	
 
        </cfscript>     
        
         <cfif SESSION.formErrors.length()>
         	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
         <cfelse>
		<cfset appNotComplete = #appNotComplete# + 23.75>	</cfif>
</cfif>     
        
        
 <!------------------------>
<!----Community Info---->         
        
        <cfscript>
           // Data Validation
			// Family Last Name
            if ( NOT LEN(TRIM(cl.population)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please enter the population of your city.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(cl.nearbigcity)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please enter the nearest major city.");
            }	
			
			// City
            if ( NOT LEN(TRIM(cl.near_City_Dist)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please enter the distance to the nearest major city.");
            }			
        	
        	// State
            if ( NOT LEN(TRIM(cl.near_pop)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please enter the population of the nearest major city.");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(cl.neighborhood)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please describe your neighborhood.");
            }			
        	
			// State
            if ( NOT LEN(TRIM(cl.local_Air_code)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please enter the local airport three letter code.");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(cl.major_Air_code)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please enter the major airport three letter code.");
            }	
			
			// Family Last Name
            if ( NOT LEN(TRIM(cl.community)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please describe your community.");
            }		
			
 			if ( NOT LEN(TRIM(cl.terrain1)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please describe your terrain as hilly or flat.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(cl.terrain2)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please indicate if the terrain has trees or no trees.");
            }	
			
			// Address
            if ( NOT LEN(TRIM(cl.terrain3)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please indicate in terrain, if you have any type of water near you.");
            }	
			
			// City
            if ( NOT LEN(TRIM(cl.wintertemp)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please enter the average winter temp.");
            }			
        	
        	// State
            if ( NOT LEN(TRIM(cl.summertemp)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please enter the average summer temp.");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(cl.snowy_winter)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please describe your neighborhood.");
            }			
        	
			// Family Last Name
            if ((cl.snowy_winter eq 3) AND  (cl.rainy_winter eq 3) AND  (cl.hot_summer eq 3) 
			      AND (cl.mild_summer eq 3) AND (cl.high_hummidity eq 3) AND (cl.dry_air eq 3) AND (cl.hot_summer eq 3) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please check at least one box to describe your seasons.");
            }	

			// Zip
            if ( NOT LEN(TRIM(cl.special_cloths)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please indicate anyparticular clothes, sports equipment, etc. that your student should consider bringing.");
            }
			
			// Zip
            if ( NOT LEN(TRIM(cl.point_interest)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Community Info Please describe the points of interest and available activities/opportunities for teenagers in your surrounding area.");
            }
        </cfscript>         
		
		<cfif SESSION.formErrors.length()>
        	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
        <cfelse>
				<cfset appNotComplete = #appNotComplete# + 23.75>	</cfif>      

<!------------------------>
<!----School Info----> 
<cfquery name="schoolInfo" datasource="mySql">
select *
from smg_schools
where schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(cl.schoolid)#">  
</Cfquery>
<cfscript>
          		
        	
			// Zip
            if ( NOT LEN(TRIM(cl.schooltransportation)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("School Info Please indicate how the student will get to school.");
            }
			
			// State
            if ( cl.schoolWorks EQ 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("School Info Please indicate if any member of your household works for the high school.");
            }		
			
			// State
            if ( (cl.schoolWorks EQ 1) AND (NOT LEN(TRIM(cl.schoolWorksExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("School Info You have indicated that someone works with the school, but didn't explain.  Please provide details regarding the posistion.");
            }	
			
			if ( cl.schoolCoach EQ 3 ) {
               // Get all the missing items in a list
               SESSION.formErrors.Add("School Info Please indicate if a coach has contacted you about hosting an exchange student.");
            }		
			
			// State
            if ( (cl.schoolCoach EQ 1) AND (NOT LEN(TRIM(cl.schoolCoachExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("School Info You have indicated that a coach contacted you, but didn't explain.  Please provide details regarding this contact.");
            }	
			
			
			// State
            if ( (cl.schooltransportation is 'other') AND (NOT LEN(TRIM(cl.schooltransportationother))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("School Info You indicated that the student will get to school but Other, but didn't specify what that other method would be.");
            }	

         // Data Validation
			//  Name
            if ( NOT LEN(TRIM(schoolInfo.schoolname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("School Info Please enter the name of the school.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(schoolInfo.address)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("School Info Please enter the address of the school.");
            }	
			
			// City
            if ( NOT LEN(TRIM(schoolInfo.city)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("School Info Please enter the city the school is located in.");
            }			
        	
        	// State
            if ( NOT LEN(TRIM(schoolInfo.state)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("School Info Please enter the state the school is located in.");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(schoolInfo.zip)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("School Info Please enter the school's zip code.");
            }	
        
        </cfscript> 
		
		<cfif SESSION.formErrors.length()>
        	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
        <cfelse>
		<cfset appNotComplete = #appNotComplete# + 23.75>	</cfif>
        
        
<!------------------------>
<!----House Rules ----> 
<cfscript>
            // Data Validation
			// Family Last Name
            if ( NOT LEN(TRIM(cl.houserules_smoke)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("House Rules Please enter your rules for smoking at the home.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(cl.houserules_curfewweeknights)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("House Rules Please specify the curfew for school nights.");
            }	
			
			// City
            if ( NOT LEN(TRIM(cl.houserules_curfewweekends)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("House Rules Please specify the curfew for weekends.");
            }			
        	
        	// State
            if ( NOT LEN(TRIM(cl.houserules_chores)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("House Rules Please list the chores that the student we responsible for.");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(cl.houserules_church)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("House Rules Please indicate any specific rules regarding religious expectations.");
            }			
 
			</cfscript>
            
            <cfif SESSION.formErrors.length()>
            	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
            <cfelse>
				<cfset appNotComplete = #appNotComplete# + 23.75>	
            </cfif>
<!------------------------>
<!----References---->
<Cfquery name="references" datasource="mysql">
	SELECT *
	FROM smg_family_references
	WHERE referencefor = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(cl.hostid)#">
</cfquery>

    <!---number kids at home---->
    <cfquery name="kidsAtHome" datasource="mysql">
    select count(childid) as kidcount
    from smg_host_children
    where liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
     and hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(cl.hostid)#">
    </cfquery>
 	<Cfquery name="get_host_info" datasource="mysql">
    select fatherfirstname, motherfirstname
    from smg_hosts
    where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(cl.hostid)#">
    </cfquery>

	<Cfset father=0>
    <cfset mother=0>
  
    <Cfif get_host_info.fatherfirstname is not ''>
        <cfset father = 1>
    </Cfif>
    <Cfif get_host_info.motherfirstname is not ''>
        <cfset mother = 1>
    </Cfif>
    
	<cfset client.totalfam = #mother# + #father# + #kidsAtHome.kidcount#>
    <Cfif client.totalfam eq 1>
	<cfset refs = 6>
<cfelse>
	<cfset refs = 4>
</Cfif>
<cfset remainingref = #refs# - #references.recordcount#>


<Cfloop query="references">
			<cfscript>
            // Data Validation
			// Family Last Name
            if ( NOT LEN(TRIM(firstname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("References Please enter the first name.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(lastname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("References Please enter the last name for #firstname#.");
            }	
			
			// City
            if ( NOT LEN(TRIM(address)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("References Please enter the address for #firstname#.");
            }			
        	
			// City
            if ( NOT LEN(TRIM(city)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("References Please enter the city for #firstname#.");
            }		
			
        	// State
            if ( NOT LEN(TRIM(state)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("References Please select the state for #firstname#.");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(zip)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("References Please enter a zip code for #firstname#.");
            }			
        	
			// Family Last Name
            if ( NOT LEN(TRIM(phone)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("References Please enter the phone number for #firstname#.");
            }	
		
			 </cfscript>
	</cfloop>
    <cfscript>
      	//Make sure there are enough references
			 if ( remainingref gt 0) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("References You need to provide an additional #remainingref# reference(s).");
            }	
    </cfscript>
     <cfif SESSION.formErrors.length()>
     	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
     <cfelse>
		<cfset appNotComplete = #appNotComplete# + 23.75>	
     </cfif>
<!------------------------>
<!----Finance Data---->        
     
        
 <cfscript>
           // Data Validation
			// Family Last Name
            if (NOT LEN(TRIM(cl.publicAssitance))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Finance Data Please indicate if any member of your household is receiving any public assistance.");
            }			
        	
			// Address
            if (NOT LEN(TRIM(cl.crime))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Finance Data Please indicate if any member in your household has beeen charged with a crime.");
            }	
			
			// City
    		  if ( (cl.crime EQ 1) AND (NOT LEN(TRIM(cl.crimeExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("Finance Data You have indicated that someone has been charged with a crime, but did not explain.");
            }			
        	
        	// State
            if(NOT LEN(TRIM(cl.income)))   {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Finance Data Please indicate your household income.");
            }		
	</cfscript>
	
	<cfif SESSION.formErrors.length()>
    	<cfscript>
        	Session.formErrors.clear();
      	</cfscript>
    <cfelse>
		<cfset appNotComplete = #appNotComplete# + 23.75>	
    </cfif>
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
    
</Cfoutput>