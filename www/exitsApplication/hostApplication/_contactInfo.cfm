<!--- ------------------------------------------------------------------------- ----
	
	File:		contactInfo.cfm
	Author:		Josh Rahl
	Date:		March 3, 2011
	Desc:		Contact Information

	Updated:	01/27/13 - Using cfinput instead of input saves text between quotes,
				per instance  "Smith"
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionID" default="0">
    <cfparam name="FORM.familylastname" default="">
    <!--- Ethnicity --->
    <cfparam name="FORM.race" default="">
    <cfparam name="FORM.ethnicityOther" default="">
    <cfparam name="FORM.primaryLanguage" default="">
    <!----Previous Hosting---->
    <Cfparam name="FORM.previousHostingExperience" default="">
    <Cfparam name="FORM.previousHosting" default="">
    <!--- Address --->
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.password" default="">
	<!--- Father --->
    <cfparam name="FORM.fatherlastname" default="">
    <cfparam name="FORM.fatherFirstName" default="">
    <cfparam name="FORM.fathermiddlename" default="">
    <cfparam name="FORM.fatherDOB" default="">
    <cfparam name="FORM.fatherbirth" default="">
    <cfparam name="FORM.fatherEducationLevel" default="">
    <cfparam name="FORM.fatherworktype" default="">
    <cfparam name="FORM.fatherEmployeer" default="">
    <cfparam name="FORM.father_cell" default="">
    <cfparam name="FORM.fatherfullpart" default="">
    <cfparam name="FORM.fatherInterests" default="">
	<!--- Mother --->    
    <cfparam name="FORM.motherFirstName" default="">
    <cfparam name="FORM.motherlastname" default="">
    <cfparam name="FORM.mothermiddlename" default="">
    <cfparam name="FORM.motherDOB" default="">
    <cfparam name="FORM.motherbirth" default="">
    <cfparam name="FORM.motherEducationLevel" default="">
    <cfparam name="FORM.motherworktype" default="">
    <cfparam name="FORM.motherEmployeer" default="">
    <cfparam name="FORM.mother_cell" default="">
    <cfparam name="FORM.motherfullpart" default="">
    <cfparam name="FORM.motherInterests" default="">
    <!--- Mailing Address --->
    <cfparam name="FORM.mailaddress" default="">
    <cfparam name="FORM.mailaddress2" default="">
    <cfparam name="FORM.mailcity" default="">
    <cfparam name="FORM.mailstate" default="">
    <cfparam name="FORM.mailzip" default="">
    <cfparam name="FORM.homeIsFunctBusiness" default="">
    <cfparam name="FORM.homeBusinessDesc" default="">

    <cfquery name="qGetHostInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT  
        	*
        FROM 
        	smg_hosts shl
        LEFT JOIN 
        	smg_states on smg_states.state = shl.state
        WHERE 
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
    </cfquery>

    <cfquery name="qGetStates" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	state, 
            statename
        FROM 
        	smg_states
        ORDER BY 
        	id
    </cfquery>
    
    <cfscript>
		// Get Languages
		qGetLanguages = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey="language", sortBy="name");	
	</cfscript>

	<!--- Process Form Submission --->
    <cfif VAL(FORM.submitted)>
        
        <cfscript>
            // Data Validation
			
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.familylastname)) ) {
                SESSION.formErrors.Add("Please enter your family last name.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(FORM.address)) ) {
                SESSION.formErrors.Add("Your home address is not valid.");
            }	

			// City
            if (NOT LEN(TRIM(FORM.city)) ) {
                SESSION.formErrors.Add("You need to indicate which city your home is located in.");
            }	

			// State
            if ( NOT LEN(TRIM(FORM.state)) ) {
                SESSION.formErrors.Add("Please indicate which state your home is located in.");
            }	

			// Zip
            if ( NOT isValid("zipcode", TRIM(FORM.zip)) ) {
                SESSION.formErrors.Add("The zip code for home address is not a valid zip code.");
				FORM.zip = "";
            }	

			// Ethnicity
			if ( NOT LEN(TRIM(FORM.race)) ) {
				SESSION.formErrors.Add("Please indicate your family's ethnicity.");
			}
			
			// Ethnicity
			if ( ListFind(FORM.race,'Other') AND NOT LEN(TRIM(FORM.ethnicityOther)) ) {
				SESSION.formErrors.Add("Please indicate other ethnicity.");
			}

			// Primary Language
			if ( NOT LEN(TRIM(FORM.primaryLanguage)) ) {
				SESSION.formErrors.Add("Please indicate what is the primary language spoken in your home.");
			}
			
			// Previous Experience
            if ( NOT LEN(FORM.previousHosting) ) {
                SESSION.formErrors.Add("Please indicate if you have had pervious hosting experience.");
			}
			
			// Previous Experience Desc
            if (( FORM.previousHosting EQ 1) AND NOT LEN(TRIM(FORM.previousHostingExperience)) )  {
                SESSION.formErrors.Add("You have indicated that you have had experience hosting, but have not provided details on previous hosting experience.");
			}
			
			
			// Functioning Business
            if ( NOT LEN(FORM.homeIsFunctBusiness) ) {
                SESSION.formErrors.Add("Please indicate if your home is also a functioning business.");
			}
			
			// No business Des
            if (( FORM.homeIsFunctBusiness EQ 1) AND NOT LEN(TRIM(FORM.homeBusinessDesc)) )  {
                SESSION.formErrors.Add("You have indicated that your home is also a business, but have not provided details on the type of business.");
			}
			
			// Mailing Address
            if ( NOT LEN(TRIM(FORM.mailaddress)) ) {
                SESSION.formErrors.Add("Please indicate your mailing address.");
            }	

			// Mailing City
            if ( NOT LEN(TRIM(FORM.mailcity)) ) {
                SESSION.formErrors.Add("Please indicate your mailing address city.");
            }	

			// Mailing State
            if ( NOT LEN(TRIM(FORM.mailstate)) ) {
                SESSION.formErrors.Add("Please indicate your mailing address state.");
            }	

			// Mailing Zip
            if ( NOT isValid("zipcode", TRIM(FORM.mailzip)) ) {
                SESSION.formErrors.Add("The zip code for mailing address is not a valid zip code.");
				FORM.mailzip = "";
            }	
	
			// Phones
            if ( NOT LEN(TRIM(FORM.phone)) AND NOT LEN(TRIM(FORM.father_cell)) AND NOT LEN(TRIM(FORM.mother_cell)) ) {
                SESSION.formErrors.Add("Please enter one of the Phone fields: Home, Father Cell or Mother Cell");
            }	
	
			// Valid Phone
            if ( LEN(TRIM(FORM.phone)) AND NOT isValid("telephone", TRIM(FORM.phone)) ) {
                SESSION.formErrors.Add("The home phone number you have entered does not appear to be valid. ");
            }	

			// Email Address
            if ( NOT LEN(TRIM(FORM.email)) ) {
                SESSION.formErrors.Add("Please provide an email address.");
            }	
			
			// Valid Email Address
            if ( LEN(TRIM(FORM.email)) AND NOT isValid("email", TRIM(FORM.email)) ) {
                SESSION.formErrors.Add("The email address you have entered does not appear to be valid.");
            }	
			
			/*
			// Valid Password
            if ( LEN(TRIM(FORM.password)) LT 6) {
                SESSION.formErrors.Add("Your password must be at least 6 characters long.");
            }	
			*/
			
			// Check for last name
            if ( NOT LEN(TRIM(FORM.fatherlastname)) AND NOT LEN(TRIM(FORM.motherlastname)) )  {
                SESSION.formErrors.Add("If you are single, you must provide information for at least one of the host parents, either the father or mother. If you are not single, please provide information on both host parents.");
			}
			
			// Primary Host Parent DOB 
			if ( NOT LEN(TRIM(FORM.motherDOB)) )  {
				SESSION.formErrors.Add("Please provide the date of birth for the Primary Host Parent.");
			}
			
			// Primary Host Parent DOB 
			if ( LEN(TRIM(FORM.motherDOB)) AND NOT isDate(TRIM(FORM.motherDOB)) )  {
				SESSION.formErrors.Add("Please provide a valid date of birth for the Primary Host Parent.");
				FORM.motherDOB = '';
			}

			// Calculate Age
			if ( isDate(FORM.motherDOB) ) {
				vCalculateMotherAge = Datediff('yyyy',FORM.motherDOB, now());
			} else {
				vCalculateMotherAge = 0;
			}

			// Birthdate
			if ( vCalculateMotherAge GT 120 ) {
				SESSION.formErrors.Add("The Primary Host Parent's date of birth indicates that they are over 120 years old. Please check the Primary Host Parent's date of birth.");				
			}	
			
			// Birthdate
			if ( isDate(FORM.motherDOB) AND FORM.motherDOB GT now() ) {
				SESSION.formErrors.Add("The Primary Host Parent's date of birth indicates that they have not been born yet. Please check the Primary Host Parent's date of birth.");				
			}	

			// Primary Host Parent Education Level 
			if ( NOT LEN(FORM.motherEducationLevel) )  {
				SESSION.formErrors.Add("Please provide the highest education level for Primary Host Parent.");
			}
			
			// Primary Host Parent Occupation
			if ( NOT LEN(TRIM(FORM.motherworktype)) )  {
				SESSION.formErrors.Add("Please provide the occupation for the Primary Host Parent.");
			}
			
			// Primary Host Parent Full/Part Time
			if ( NOT LEN(FORM.motherfullpart) ) {
				SESSION.formErrors.Add("You provided a job for the Primary Host Parent, but didn't indicate if they work full or part time.");
			}
			
			// Primary Host Parent Employer
			if ( NOT LEN(TRIM(FORM.motherEmployeer)) ) {
				SESSION.formErrors.Add("You provided a job for the Primary Host Parent, but didn't indicate the employer.");
			}

			// Valid Primary Host Parent's Phone
			if ( LEN(TRIM(FORM.mother_cell)) AND NOT isValid("telephone", TRIM(FORM.mother_cell)) ) {
				SESSION.formErrors.Add("Please enter a valid phone number for the Primary Host Parent's Cell Phone");
			}

			// Primary Host Parent Interests
			if ( NOT LEN(TRIM(FORM.motherInterests)) ) {
				SESSION.formErrors.Add("Please provide interests for the Primary Host Parent");
			}
			
			// Check if there is an additional host parent (stored in the db as the father)
			if ( FORM.otherHostParent NEQ "none" ) {

				// Other Host Parent DOB 
				if ( NOT LEN(TRIM(FORM.fatherDOB)) )  {
					SESSION.formErrors.Add("Please provide the date of birth for the Other Host Parent.");
				}
				
				// Other Host Parent DOB 
				if ( LEN(TRIM(FORM.fatherDOB)) AND NOT isDate(TRIM(FORM.fatherDOB)) )  {
					SESSION.formErrors.Add("Please provide a valid date of birth for the Other Host Parent.");
					FORM.fatherDOB = '';
				}

				// Calculate Age
				if ( isDate(FORM.fatherDOB) ) {
					vCalculateFatherAge = Datediff('yyyy',FORM.fatherDOB, now());
				} else {
					vCalculateFatherAge = 0;
				}	

				// Birthdate
				if ( vCalculateFatherAge GT 120 ) {
					SESSION.formErrors.Add("The Other Host Parent's date of birth indicates that they are over 120 years old. Please check the Other Host Parent's date of birth.");				
				}	
				
				// Birthdate
				if ( isDate(FORM.fatherDOB) AND FORM.fatherDOB GT now() ) {
					SESSION.formErrors.Add("The Other Host Parent's date of birth indicates that they have not been born yet. Please check the Other Host Parent's date of birth.");				
				}	
				
				// Other Host Parent Education Level 
				if ( NOT LEN(FORM.fatherEducationLevel) )  {
					SESSION.formErrors.Add("Please provide the highest education level for the Other Host Parent.");
				}
				
				// Other Host Parent Occupation
				if ( NOT LEN(TRIM(FORM.fatherworktype)) )  {
					SESSION.formErrors.Add("Please provide the occupation for the Other Host Parent.");
				}
				
				// Other Host Parent Full/part time
				if ( LEN(TRIM(FORM.fatherworktype)) AND NOT LEN (FORM.fatherfullpart) ) {
					SESSION.formErrors.Add("You provided a job for the Other Host Parent, but didn't indicate if they work full or part time.");
				}
				
				// Other Host Parent Employer
				if ( LEN(TRIM(FORM.fatherworktype)) AND NOT LEN(TRIM(FORM.fatherEmployeer)) ) {
					SESSION.formErrors.Add("You provided a job for the Other Host Parent, but didn't indicate the employer.");
				}

				// Valid Other Host Parent's Phone
				if ( LEN(TRIM(FORM.father_cell)) AND NOT isValid("telephone", TRIM(FORM.father_cell)) ) {
					SESSION.formErrors.Add("Please enter a valid phone number for the Other Host Parent's Cell Phone.");
				}	

				// Other Host Parent Interests
				if ( NOT LEN(TRIM(FORM.fatherInterests)) ) {
					SESSION.formErrors.Add("Please provide interests for the Other Host Parent");
				}

			}
		</cfscript>
        
        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
            
            <cfscript>
				// Erase value on ethnicityOther if other is not selected
				if ( NOT ListFind(FORM.race,'Other')) {
					FORM.ethnicityOther = '';
				}
			</cfscript>
        		
            <!--- Update Record --->
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                    smg_hosts 
                SET
                    familylastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.familylastname)#">,
                    primaryHostParent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.primaryHostParent#">,
                    otherHostParent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.otherHostParent#">,
					<!--- Address --->
                    address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                    city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                    state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                    zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                    phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
					<!--- password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.password#">, --->
                    <!--- Business --->
                    homeIsFunctBusiness = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.homeIsFunctBusiness#">,
                    homeBusinessDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(FORM.homeBusinessDesc, 300)#">,
                    <!----Previous Hosting Experience  ---->
                    previousHosting = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.previousHosting#">,
                    previousHostingExperience =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.previousHostingExperience#">,
                    <!--- Mailing Address --->
                    mailaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailaddress#">,
                    mailaddress2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailaddress2#">,
                    mailcity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailcity#">,
                    mailstate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailstate#">,
                    mailzip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailzip#">,
                    <!--- Ethnicity --->
                    race = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.race#">,
                    ethnicityOther = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ethnicityOther#">,
                    primaryLanguage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.primaryLanguage#">,
                    <!--- Father --->
                    fatherlastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherlastname#">,
                    fatherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherFirstName#">,
                    fathermiddlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fathermiddlename#">,
                    fatherDOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.fatherDOB#" null="#yesNoFormat(TRIM(FORM.fatherDOB) EQ '')#">,
                    <cfif IsDate(FORM.fatherDOB)>
	                    fatherbirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#Year(TRIM(FORM.fatherDOB))#">,
                    </cfif>
                    fatherEducationLevel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherEducationLevel#">,
                    fatherworktype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherworktype#">,
                    father_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#">,
                    fatherfullpart = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fatherfullpart#" null="#yesNoFormat(NOT LEN(FORM.fatherfullpart))#">,
                    fatherEmployeer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherEmployeer)#">,
                    fatherInterests = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherInterests)#">,
					<!--- Mother --->
                    motherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherFirstName#">,
                    motherlastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherlastname#">,
                    mothermiddlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mothermiddlename#">,
                    motherDOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.motherDOB#" null="#yesNoFormat(TRIM(FORM.motherDOB) EQ '')#">,
                    <cfif IsDate(FORM.motherDOB)>
                    	motherbirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#Year(TRIM(FORM.motherDOB))#">,
                    </cfif>
                    motherEducationLevel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherEducationLevel#">,
                    motherworktype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherworktype#">,
                    mother_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mother_cell#">,
                    motherfullpart = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.motherfullpart#" null="#yesNoFormat(NOT LEN(FORM.motherfullpart))#">,
                    motherEmployeer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherEmployeer)#">,
                    motherInterests = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherInterests)#">
                    <!--- lead = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> --->
                WHERE 
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            </cfquery>
            
            <cfscript>
				// Successfully Updated - Set navigation page
				Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
			</cfscript>
    
    	</cfif> <!--- NOT SESSION.formErrors.length() --->
    
    <!--- FORM NOT SUBMITTED --->
    <cfelse>
    
         <cfscript>
			 // Set FORM Values   
			FORM.familylastname = qGetHostInfo.familylastname;
			FORM.primaryHostParent = qGetHostInfo.primaryHostParent;
			FORM.otherHostParent = qGetHostInfo.otherHostParent;
			// Address --->
			FORM.address = qGetHostInfo.address;
			FORM.address2 = qGetHostInfo.address2;
			FORM.city = qGetHostInfo.city;
			FORM.state = qGetHostInfo.state;
			FORM.zip = qGetHostInfo.zip;
			FORM.phone = qGetHostInfo.phone;
			FORM.email = qGetHostInfo.email;
			// FORM.password = qGetHostInfo.password;
			FORM.homeIsFunctBusiness = qGetHostInfo.homeIsFunctBusiness;
			FORM.homeBusinessDesc = qGetHostInfo.homeBusinessDesc;
			FORM.previousHosting  = qGetHostInfo.previousHosting;
			FORM.previousHostingExperience = qGetHostInfo.previousHostingExperience;
			// Mailing Address --->
			FORM.mailaddress = qGetHostInfo.mailaddress;
			FORM.mailaddress2 = qGetHostInfo.mailaddress2;
			FORM.mailcity = qGetHostInfo.mailcity;
			FORM.mailstate = qGetHostInfo.mailstate;
			FORM.mailzip = qGetHostInfo.mailzip;
			FORM.race = qGetHostInfo.race;
			FORM.ethnicityOther = qGetHostInfo.ethnicityOther;
			FORM.primaryLanguage = qGetHostInfo.primaryLanguage;
			// Father --->
			FORM.fatherlastname = qGetHostInfo.fatherlastname;
			FORM.fatherFirstName = qGetHostInfo.fatherFirstName;
			FORM.fathermiddlename = qGetHostInfo.fathermiddlename;
			FORM.fatherbirth = qGetHostInfo.fatherbirth;
			FORM.fatherDOB = qGetHostInfo.fatherDOB;
			FORM.fatherEducationLevel = qGetHostInfo.fatherEducationLevel;
			FORM.fatherworktype = qGetHostInfo.fatherworktype;
			FORM.fatherEmployeer = qGetHostInfo.fatheremployeer;
			FORM.father_cell = qGetHostInfo.father_cell;
			FORM.fatherfullpart = qGetHostInfo.fatherfullpart;
			FORM.fatherInterests = qGetHostInfo.fatherInterests;
			// Mother --->    
			FORM.motherFirstName = qGetHostInfo.motherFirstName;
			FORM.motherlastname = qGetHostInfo.motherlastname;
			FORM.mothermiddlename = qGetHostInfo.mothermiddlename;
			FORM.motherbirth = qGetHostInfo.motherbirth;
			FORM.motherDOB = qGetHostInfo.motherDOB;
			FORM.motherEducationLevel = qGetHostInfo.motherEducationLevel;
			FORM.motherworktype = qGetHostInfo.motherworktype;
			FORM.mother_cell = qGetHostInfo.mother_cell;
			FORM.motherfullpart = qGetHostInfo.motherfullpart;
			FORM.motherEmployeer = qGetHostInfo.motherEmployeer;
			FORM.motherInterests = qGetHostInfo.motherInterests;
         	
			// the default values in the database for these used to be "na", so remove any.
         	if ( FORM.father_cell EQ 'na' ) {
				FORM.father_cell = '';
			}
			
			if ( FORM.mother_cell EQ 'na' )  {
				FORM.mother_cell = '';
			}
         </cfscript>
         
    </cfif>    

</cfsilent>

<script type="text/javascript">
	function ShowHide(){
		$("#slidingDiv").animate({"height": "toggle"}, { duration: 300 });
	}

	// Copy Fields
	function FillFields(box) {
		if (box.checked == false) { 
			$("#mailaddress").val("");
			$("#mailaddress2").val("");
			$("#mailcity").val("");
			$("#mailstate").val("");
			$("#mailzip").val("");
		} else {
			$("#mailaddress").val($("#address").val());
			$("#mailaddress2").val($("#address2").val());
			$("#mailcity").val($("#city").val());
			$("#mailstate").val($("#state").val());
			$("#mailzip").val($("#zip").val());
		}
	}

	function checkForm() {
		if (document.my_form.state.value.length == 0) {alert("Please select the State."); return false; }
		if (document.my_form.phone.value.length == 0 && document.my_form.father_cell.value.length == 0 && document.my_form.mother_cell.value.length == 0) {alert("Please enter one of the Phone fields."); return false; }
		return true;
	}
	
	function updateOtherHostParent() {
		if ($("#otherHostParent").val() == "none") {
			$("#otherHostParentFields").hide();
		} else {
			$("#otherHostParentFields").show();
		}
	}
</script>

<cfoutput>

    <h1 class="enter" id="hostFamilyHeader">#FORM.familylastname# Family Application</h1>
    
    <p>
        Completing the host family application will take between 15 and 60 minutes.  
        You do not have to complete it all at once, feel free to come back and complete it.
    </p>
    
    <p>Use the menu on the left to navigate to any section of the application.</p>

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
    
    <cfform method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" name="my_form"  onsubmit="return validate(this)"> <!--- onSubmit="return checkForm();" --->
        <input type="hidden" name="submitted" value="1">
        
        <h3>Name &amp; Contact Info</h3>
        
        <span class="required">* Required fields &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr>
                <td class="label" width="180px"><h3>Family Name <span class="required">*</span></h3></td>
                <td colspan="3"><cfinput type="text" name="familylastname" id="familylastname" value="#FORM.familylastname#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Address <span class="required">*</span></h3></td>
                <td colspan="2">
                    <cfinput type="text" name="address" id="address" value="#FORM.address#" class="xLargeField" maxlength="150" validate="noblanks"> <br />
                    <font size="1">NO PO BOXES</font>
                </td>
                <td rowspan="2"> 
                    <p style="font-size:-1;">
                        <em>
                            physical address where student will be living. <br />
                            Mailing address can be added below, if different.
                        </em>
                    </p>
                </td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td></td>
                <td colspan="3"><cfinput type="text" name="address2" id="address2" value="#FORM.address2#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>			 
                <td class="label"><h3>City <span class="required">*</span></h3></td>
                <td colspan="3"><cfinput type="text" name="city" id="city" value="#FORM.city#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>State <span class="required">*</span></h3></td>
                <td>
                    <cfselect name="state" id="state" query="qGetStates" value="state" display="statename" selected="#FORM.state#" queryPosition="below" class="largeField">
                        <option></option>
                    </cfselect>
                </td>
                <td class="zip"><h3>Zip <span class="required">*</span></h3> </td>
                <td><cfinput type="text" name="zip" id="zip" value="#FORM.zip#" class="mediumField" maxlength="10"></td>
            </tr>
            <tr>
                <td><h3>Phone <span class="required">+</span></h3></td>
                <td colspan="3"><cfinput type="text" name="phone" value="#FORM.phone#" class="mediumField" placeholder="(999) 999-9999" mask="(999) 999-9999" maxlength="14"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td><h3>Email</h3></td>
                <td colspan="3"><cfinput type="text" name="email" value="#FORM.email#" class="xLargeField" maxlength="200"></td>
            </tr>
            <!---
            <tr>
                <td><h3>Password</h3></td>
                <td colspan="3">
                    <cfinput type="text" name="password" value="#FORM.password#" class="xLargeField" maxlength="30"> 
                    <font size="1">6 characters minimum</font>
                </td>
            </tr>
			--->
        </table> <br />
        
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label" valign="top" colspan="2"><h3>What is the ethnicity of your family? <span class="required">*</span></h3></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td colspan="2">
                    
                    <table width="100%">
                        <tr>
                            <td width="10px"><input type="checkbox" name="race" id="raceAmericanIndian" value="American Indian or Alaska Native" <cfif listFind(FORM.race,"American Indian or Alaska Native")>checked</cfif> /></td>
                            <td><label for="raceAmericanIndian">American Indian or Alaska Native</label></td>

                            <td width="10px"><input type="checkbox" name="race" id="raceAsian" value="Asian" <cfif listFind(FORM.race,"Asian")>checked</cfif> /></td>
                            <td><label for="raceAsian">Asian</label></td>
                            
                            <td width="10px"><input type="checkbox" name="race" id="raceAfrican" value="Black or African American" <cfif listFind(FORM.race,"Black or African American")>checked</cfif> /></td>
                            <td><label for="raceAfrican">Black or African American</label></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="race" id="raceHispanic" value="Hispanic or Latino" <cfif listFind(FORM.race,"Hispanic or Latino")>checked</cfif> /></td>
                            <td><label for="raceHispanic">Hispanic or Latino</label></td>
                            
                            <td><input type="checkbox" name="race" id="raceHawaiian" value="Native Hawaiian or Other Pacific Islander" <cfif listFind(FORM.race,"Native Hawaiian or Other Pacific Islander")>checked</cfif> /></td>
                            <td><label for="raceHawaiian">Native Hawaiian or Other Pacific Islander</label></td>
                           
                            <td><input type="checkbox" name="race" id="raceWhite" value="White" <cfif listFind(FORM.race,"White")>checked</cfif> /></td>
                            <td><label for="raceWhite">White</label></td>
                        </tr>
                        <tr>
                        	<td><input type="checkbox" name="race" id="ethnicityOther" value="Other" <cfif listFind(FORM.race,"Other")>checked</cfif> /></td>
                            <td colspan="5">
                            	<label for="ethnicityOther">Other:</label> &nbsp;
                        		<input type="text" name="ethnicityOther" value="#FORM.ethnicityOther#" class="largeField" maxlength="100" />
                            </td>
                        </tr>
                    </table>
            
                </td>
            </tr> 
            <tr>
                <td class="label"><h3>Primary language spoken in your home <span class="required">*</span></h3></td>
                <td>
                	<select name="primaryLanguage" id="primaryLanguage" class="largeField">
                        <option value="" <cfif NOT LEN(FORM.primaryLanguage)> selected="selected" </cfif></option>
                        <cfloop query="qGetLanguages">
	                        <option value="#qGetLanguages.name#" <cfif FORM.primaryLanguage EQ qGetLanguages.name> selected="selected" </cfif> >#qGetLanguages.name#</option>
                    	</cfloop>
                    </select>
                </td>
            </tr>
            
        </table>  
 

        <br />

         <h3>Previous Hosting Experience</h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Have you ever hosted a foreign exchange student before?<span class="required">*</span></h3> </td>
                <td>
                    <cfinput type="radio" name="previousHosting" id="previousHosting1" value="1" checked="#FORM.previousHosting eq 1#" onclick="document.getElementById('previousHostingExperience').style.display='table-row';"/>
                    <label for="homeIsFunctBusiness1">Yes</label>        
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        
                    <cfinput type="radio" name="previousHosting" id="previousHosting0" value="0" checked="#FORM.previousHosting eq 0#" onclick="document.getElementById('previousHostingExperience').style.display='none';" />
                    <label for="previousHostingExperience0">No</label>
                </td>
            </tr>
            <tr>
                <td align="left" id="previousHostingExperience" <cfif FORM.previousHosting is ''>class="displayNone"</cfif>>
                    <strong>Please list the organizations you've worked with and how many <br /> kids you hosted with each organization.<span class="required">*</span></strong><br />
                    <textarea cols="50" rows="4" name="previousHostingExperience" placeholder="International Student Exchange, 5">#FORM.previousHostingExperience#</textarea>
                </td>
            </tr>   
        </table>

         <br />
        
        <h3>Home Based Business</h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Is the residence the site of a functioning business?(e.g. daycare, farm) <span class="required">*</span></h3> </td>
                <td>
                    <cfinput type="radio" name="homeIsFunctBusiness" id="homeIsFunctBusiness1" value="1" checked="#FORM.homeIsFunctBusiness eq 1#" onclick="document.getElementById('describeBusiness').style.display='table-row';"/>
                    <label for="homeIsFunctBusiness1">Yes</label>        
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        
                    <cfinput type="radio" name="homeIsFunctBusiness" id="homeIsFunctBusiness0" value="0" checked="#FORM.homeIsFunctBusiness eq 0#" onclick="document.getElementById('describeBusiness').style.display='none';" />
                    <label for="homeIsFunctBusiness0">No</label>
                </td>
            </tr>
            <tr>
                <td align="left" id="describeBusiness" <cfif FORM.homeBusinessDesc is ''>class="displayNone"</cfif>>
                    <strong>Please Describe <span class="required">*</span></strong><br />
                    <textarea cols="50" rows="4" name="homeBusinessDesc" placeholder="Name of Business, Nature of Business, etc">#FORM.homeBusinessDesc#</textarea>
                </td>
            </tr>   
        </table> <br />
        
        <h3>
            Mailing Address 
            <cfif NOT LEN(FORM.mailaddress)>
                <input name="ShipSame" id="ShipSame" type="checkbox" class="formCheckbox" onClick="FillFields(this)" value="Same"<cfif IsDefined('FORM.ShipSame')> checked</cfif>>
                <label for="ShipSame"><font size="-1">Use Home Address</font></label>
            </cfif>
        </h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label" width="180px"><h3>Address <span class="required">*</span></h3></td>
                <td colspan="3"><cfinput type="text" name="mailaddress" id="mailaddress" value="#FORM.mailaddress#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td></td>
                <td colspan="3"><cfinput type="text" name="mailaddress2" id="mailaddress2" value="#FORM.mailaddress2#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>			 
                <td class="label"><h3>City <span class="required">*</span></h3></td>
                <td colspan="3"><cfinput type="text" name="mailcity" id="mailcity" value="#FORM.mailcity#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>State <span class="required">*</span></h3></td>
                <td>
                    <cfselect name="mailstate" id="mailstate" query="qGetStates" value="state" display="statename" selected="#FORM.mailstate#" queryPosition="below" class="largeField">
                        <option></option>
                    </cfselect>
                </td>
                <td class="zip"><h3>Zip <span class="required">*</span></h3> </td>
                <td><cfinput type="text" name="mailzip" id="mailzip" value="#FORM.mailzip#" class="smallField" maxlength="10"></td>
            </tr>
        </table> <br />
        
        <h3>
        	Primary Host Parent: &nbsp;
            <select name="primaryHostParent">
                <option value="mother" <cfif FORM.primaryHostParent EQ "mother">selected="selected"</cfif>>Host Mother</option>
                <option value="father" <cfif FORM.primaryHostParent EQ "father">selected="selected"</cfif>>Host Father</option>
            </select>
   		</h3>
        
       	<table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label" width="180px"><h3>First Name (Legal name only, please no nicknames)</h3></td>
                <td><cfinput type="text" name="motherFirstName" value="#FORM.motherFirstName#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3>Last Name</h3></td>
                <td><cfinput type="text" name="motherlastname" value="#FORM.motherlastname#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3>Middle Name</h3></td>
                <td><cfinput type="text" name="mothermiddlename" value="#FORM.mothermiddlename#" class="xLargeField" maxlength="150"></td>
            </tr>			
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Date of Birth</h3></td>
                <td><cfinput type="text" name="motherDOB" value="#dateFormat(FORM.motherDOB, 'mm/dd/yyyy')#" class="mediumField" maxlength="10" mask="99/99/9999" placeholder="MM/DD/YYYY"> </td>
            </tr>
            <tr>
                <td class="label"><h3>Highest level of formal education <span class="required">*</span></h3></td>
                <td>
                	<select name="motherEducationLevel" id="motherEducationLevel">
                    	<option value="" <cfif NOT LEN(FORM.motherEducationLevel)>selected="selected"</cfif> ></option>
                    	<option value="Grade school or less" <cfif FORM.motherEducationLevel EQ 'Grade school or less'>selected="selected"</cfif> >Grade school or less</option>
                    	<option value="Some high school" <cfif FORM.motherEducationLevel EQ 'Some high school'>selected="selected"</cfif> >Some high school</option>
                    	<option value="High school graduate" <cfif FORM.motherEducationLevel EQ 'High school graduate'>selected="selected"</cfif> >High school graduate</option>
                    	<option value="Grade school or less" <cfif FORM.motherEducationLevel EQ 'Grade school or less'>selected="selected"</cfif> >Grade school or less</option>
                    	<option value="Some college" <cfif FORM.motherEducationLevel EQ 'Some college'>selected="selected"</cfif> >Some college</option>
                    	<option value="2-year college/technical school" <cfif FORM.motherEducationLevel EQ '2-year college/technical school'>selected="selected"</cfif> >2-year college/technical school</option>
                    	<option value="4-year college" <cfif FORM.motherEducationLevel EQ '4-year college'>selected="selected"</cfif> >4-year college</option>
                    	<option value="Some postgraduate work" <cfif FORM.motherEducationLevel EQ 'Some postgraduate work'>selected="selected"</cfif>>Some postgraduate work</option>
                        <option value="Postgraduate degree" <cfif FORM.motherEducationLevel EQ 'Postgraduate degree'>selected="selected"</cfif> >Postgraduate degree</option>
                    </select>
                </td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Job Title <span class="required">*</span></h3></td>
                <td>
                    <cfinput type="text" name="motherworktype" value="#FORM.motherworktype#" class="xLargeField" maxlength="200">  
                    <input name="motherfullpart" id="motherFullTime" type="radio" value="1" <cfif FORM.motherfullpart eq 1>checked</cfif>> <label for="motherFullTime">Full Time</label>
                    <input name="motherfullpart" id="motherPartTime" type="radio" value="0" <cfif FORM.motherfullpart eq 0>checked</cfif>> <label for="motherPartTime">Part Time</label>
                    <input name="motherfullpart" id="motherPartTime" type="radio" value="2" <cfif FORM.motherfullpart eq 2>checked</cfif>> <label for="motherRetired">Retired</label>
                </td>
            </tr>
            <tr>
                <td class="label"><h3>Employer <span class="required">*</span></h3></td>
                <td><cfinput type="text" name="motherEmployeer" value="#FORM.motherEmployeer#" class="xLargeField" maxlength="100"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Cell Phone <span class="required">+</span></h3></td>
                <td colspan="3"><cfinput type="text" name="mother_cell" value="#FORM.mother_cell#" size="14" maxlength="14" placeholder="(999) 999-9999" mask="(999) 999-9999" ></td>
            </tr>
            <tr>
                <td class="label" valign="top" ><h3>Interests <span class="required">*</span></h3></td>
                <td><textarea name="motherInterests" rows="5" cols="50">#FORM.motherInterests#</textarea></td>
            </tr>
        </table> <br/>
        
        <h3>
        	Other Host Parent: &nbsp;
      		<select name="otherHostParent" id="otherHostParent" onchange="updateOtherHostParent()">
            	<option value="father" <cfif FORM.otherHostParent EQ "father">selected="selected"</cfif>>Host Father</option>
                <option value="mother" <cfif FORM.otherHostParent EQ "mother">selected="selected"</cfif>>Host Mother</option>
                <option value="none" <cfif FORM.otherHostParent EQ "none">selected="selected"</cfif>>None</option>
            </select>
        </h3>
        
    	<table width="100%" cellspacing="0" cellpadding="2" class="border" id="otherHostParentFields" <cfif FORM.otherHostParent EQ "none">style="display:none;"</cfif>>
            <tr bgcolor="##deeaf3" id="otherHostParentFields">
                <td class="label" width="180px"><h3>First Name (Legal name only, please no nicknames)</h3></td>
                <td><cfinput type="text" name="fatherFirstName" value="#FORM.fatherFirstName#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3>Last Name</h3></td>
                <td><cfinput type="text" name="fatherlastname" value="#FORM.fatherlastname#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3>Middle Name</h3></td>
                <td><cfinput type="text" name="fathermiddlename" value="#FORM.fathermiddlename#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Date of Birth</h3></td>
                <td><cfinput type="text" name="fatherDOB" value="#dateFormat(FORM.fatherDOB, 'mm/dd/yyyy')#" class="mediumField" maxlength="10" mask="99/99/9999" placeholder="MM/DD/YYYY"> </td>
            </tr>
            <tr>
                <td class="label"><h3>Highest level of formal education <span class="required">*</span></h3></td>
                <td>
                    <select name="fatherEducationLevel" id="fatherEducationLevel">
                        <option value="" <cfif NOT LEN(FORM.fatherEducationLevel)>selected="selected"</cfif> ></option>
                        <option value="Grade school or less" <cfif FORM.fatherEducationLevel EQ 'Grade school or less'>selected="selected"</cfif> >Grade school or less</option>
                        <option value="Some high school" <cfif FORM.fatherEducationLevel EQ 'Some high school'>selected="selected"</cfif> >Some high school</option>
                        <option value="High school graduate" <cfif FORM.fatherEducationLevel EQ 'High school graduate'>selected="selected"</cfif> >High school graduate</option>
                        <option value="Grade school or less" <cfif FORM.fatherEducationLevel EQ 'Grade school or less'>selected="selected"</cfif> >Grade school or less</option>
                        <option value="Some college" <cfif FORM.fatherEducationLevel EQ 'Some college'>selected="selected"</cfif> >Some college</option>
                        <option value="2-year college/technical school" <cfif FORM.fatherEducationLevel EQ '2-year college/technical school'>selected="selected"</cfif> >2-year college/technical school</option>
                        <option value="4-year college" <cfif FORM.fatherEducationLevel EQ '4-year college'>selected="selected"</cfif> >4-year college</option>
                        <option value="Some postgraduate work" <cfif FORM.fatherEducationLevel EQ 'Some postgraduate work'>selected="selected"</cfif>>Some postgraduate work</option>
                        <option value="Postgraduate degree" <cfif FORM.fatherEducationLevel EQ 'Postgraduate degree'>selected="selected"</cfif> >Postgraduate degree</option>
                    </select>
                </td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Job Title <span class="required">*</span></h3></td>
                <td>
                    <cfinput type="text" name="fatherworktype" value="#FORM.fatherworktype#" class="xLargeField" maxlength="200"> 
                    <input name="fatherfullpart" id="fatherFullTime" type="radio" value="1" <cfif FORM.fatherfullpart eq 1>checked</cfif>> <label for="fatherFullTime">Full Time</label>
                    <input name="fatherfullpart" id="fatherPartTime" type="radio" value="0" <cfif FORM.fatherfullpart eq 0>checked</cfif>> <label for="fatherPartTime">Part Time</label>
                    <input name="fatherfullpart" id="fatherPartTime" type="radio" value="2" <cfif FORM.fatherfullpart eq 2>checked</cfif>> <label for="fatherRetired">Retired</label>
                </td>
            </tr>
            <tr>
                <td class="label"><h3>Employer <span class="required">*</span></h3></td>
                <td><cfinput type="text" name="fatherEmployeer" value="#FORM.fatherEmployeer#" class="xLargeField" maxlength="100"> </td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Cell Phone <span class="required">+</span></h3></td>
                <td colspan="3"><cfinput type="text" name="father_cell" value="#FORM.father_cell#" size="14" maxlength="14" placeholder="(999) 999-9999"  mask="(999) 999-9999" ></td>
            </tr>
            <tr>
                <td class="label" valign="top" ><h3>Interests <span class="required">*</span></h3></td>
                <td><textarea name="fatherInterests" rows="5" cols="50">#FORM.fatherInterests#</textarea></td>
            </tr>
        </table>

        <!--- Check if FORM submission is allowed --->
        <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
            <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
                <tr>
                    <td align="right"><input name="Submit" type="image" src="images/buttons/Next.png" border="0"></td>
                </tr>
            </table>
		</cfif>
            
	</cfform>
    
</cfoutput>