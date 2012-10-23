
<!--- ------------------------------------------------------------------------- ----
	
	File:		startHostApp.cfm
	Author:		Josh Rahl
	Date:		March 3, 2011
	Desc:		Host Family Application - Intial Page

	Updated:	
					
----- ------------------------------------------------------------------------- --->
<link href="../linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
<link href="css/hostApp.css" rel="stylesheet" type="text/css" />
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<!--- Kill Extra Output --->

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionID" default="0">
    <cfparam name="FORM.familylastname" default="">
	<!--- Father --->
    <cfparam name="FORM.fatherlastname" default="">
    <cfparam name="FORM.fatherfirstname" default="">
    <cfparam name="FORM.fathermiddlename" default="">
    <cfparam name="FORM.fatherdob" default="">
    <cfparam name="FORM.fatherbirth" default="">
    <cfparam name="FORM.fatherssn" default="">
    <cfparam name="FORM.fatherworktype" default="">
    <cfparam name="FORM.fatherEmployeer" default="">
    <cfparam name="FORM.father_cell" default="">
    <cfparam name="FORM.fatherfullpart" default="3">
	<!--- Mother --->    
    <cfparam name="FORM.motherfirstname" default="">
    <cfparam name="FORM.motherlastname" default="">
    <cfparam name="FORM.mothermiddlename" default="">
    <cfparam name="FORM.motherdob" default="">
    <cfparam name="FORM.motherbirth" default="">
    <cfparam name="FORM.motherssn" default="">
    <cfparam name="FORM.motherworktype" default="">
    <cfparam name="FORM.motherEmployeer" default="">
    <cfparam name="FORM.mother_cell" default="">
    <cfparam name="FORM.motherfullpart" default="3">
    <!--- Address --->
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.password" default="">
    <!--- Mailing Address --->
    <cfparam name="FORM.mailaddress" default="">
    <cfparam name="FORM.mailaddress2" default="">
    <cfparam name="FORM.mailcity" default="">
    <cfparam name="FORM.mailstate" default="">
    <cfparam name="FORM.mailzip" default="">
    <cfparam name="FORM.homeIsFunctBusiness" default="3">
    <cfparam name="FORM.homeBusinessDesc" default="">

    <cfquery name="qGetHostInfo" datasource="mysql">
        SELECT  
        	*
        FROM 
        	smg_hosts shl
        LEFT JOIN 
        	smg_states on smg_states.state = shl.state
        WHERE 
        	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
    </cfquery>

    <cfquery name="qGetStates" datasource="mysql">
        SELECT 
        	state, 
            statename
        FROM 
        	smg_states
        ORDER BY 
        	id
    </cfquery>
<cfoutput>
<cfinclude template="approveDenyInclude.cfm">
</cfoutput>
	<!--- Process Form Submission --->
    <cfif VAL(FORM.submitted)>
        
        <cfscript>
            // Data Validation
			
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.familylastname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your family last name.");
            }			
        	
			// Address Lookup
            if ( FORM.lookup_success NEQ 1 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please lookup the address");
            }	
			
			// Address
            if ( NOT LEN(TRIM(FORM.address)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Your home address is not valid.");
            }	

			// City
            if (NOT LEN(TRIM(FORM.city)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You need to indicate which city your home is located in.");
            }	

			// State
            if ( NOT LEN(TRIM(FORM.state)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate which state your home is located in.");
            }	

			// Zip
            if ( NOT isValid("zipcode", TRIM(FORM.zip)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("The zip code for home address is not a valid zip code.");
            }	

			
			// Mailing Address
            if ( NOT LEN(TRIM(FORM.mailaddress)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate your mailing address.");
            }	

			// Mailing City
            if (NOT LEN(TRIM(FORM.mailcity)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate your mailing address city.");
            }	

			// Mailing State
            if (NOT LEN(TRIM(FORM.mailstate)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate your mailing address state.");
            }	

			// Mailing Zip
            if ( NOT isValid("zipcode", TRIM(FORM.mailzip)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("The zip code for mailing address is not a valid zip code.");
            }	
	
			// Phones
            if ( NOT LEN(TRIM(FORM.phone)) AND NOT LEN(TRIM(FORM.father_cell)) AND NOT LEN(TRIM(FORM.mother_cell)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter one of the Phone fields: Home, Father Cell or Mother Cell");
            }	
	
			// Valid Phone
            if ( LEN(TRIM(FORM.phone)) AND NOT isValid("telephone", TRIM(FORM.phone)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("The home phone number you have entered does not appear to be valid. ");
            }	
	
			// Valid Email Address
            if ( LEN(TRIM(FORM.email)) AND NOT isValid("email", TRIM(FORM.email)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("The email address you have entered does not appear to be valid.");
            }	
			
			// Valid Email Address
            if ( LEN(Trim(FORM.password)) lt 8) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Your password must be at least 8 characters long.");
            }	
			
			// Valid Father's DOB
            if ( LEN(TRIM(FORM.fatherdob)) AND NOT isValid("date", TRIM(FORM.fatherdob)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a valid Date of Birth for the Father");
            }	

			/*
			// Valid Father's SSN
            if ( LEN(TRIM(FORM.fatherssn)) AND NOT isValid("social_security_number", TRIM(FORM.fatherssn)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a valid Father's SSN");
            }	
			*/

			// Valid Father's Phone
            if ( LEN(TRIM(FORM.father_cell)) AND NOT isValid("telephone", TRIM(FORM.father_cell)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a valid phone number for the Father's Cell Phone.");
            }	

			// Valid Mother's DOB
            if ( LEN(TRIM(FORM.motherdob)) AND NOT isValid("date", TRIM(FORM.motherdob)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("The date you specified is not valid for Mother's Date of Birth");
            }	
			
			/*
			// Valid Mother's SSN
            if ( LEN(TRIM(FORM.motherssn)) AND NOT isValid("social_security_number", TRIM(FORM.motherssn)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a valid Mother's SSN");
            }	
			*/

			// Valid Mother's Phone
            if ( LEN(TRIM(FORM.mother_cell)) AND NOT isValid("telephone", TRIM(FORM.mother_cell)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a valid phoe number for Mother's Cell Phone");
			}
			// Functioning Business
            if ( FORM.homeIsFunctBusiness EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if your home is also a functioning business.");
			}
			
			// No business Des
            if (( FORM.homeIsFunctBusiness EQ 1) AND NOT LEN(TRIM(FORM.homeBusinessDesc)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that your home is also a business, but have not provided details on the type of business.");
			}
			// No business Des
            if (NOT LEN(TRIM(FORM.fatherlastname)) and not len(trim(FORM.motherlastname)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("If you are single, you must provide information for at least one of the host parents, either the father or mother. If you are not single, please provide information on both host parents.");
			}
			
			// Father is Required
            if ( LEN(TRIM(FORM.fatherfirstname)) and not len(trim(FORM.fatherdob)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please provide the birthdate for the Host Father.");
			}
			
			// Father is Required
            if ( LEN(TRIM(FORM.fatherfirstname)) and not len(trim(FORM.fatherworktype)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please provide the occupation for the Host Father.");
			}
			
			// Father Occupation
            if ( LEN(TRIM(FORM.fatherworktype)) and (FORM.fatherfullpart eq 3 ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You provided a job for the host father, but didn't indicate if you work full or part time.");
			}
			
			// Father Employer
            if ( LEN(TRIM(FORM.fatherworktype))  and not len(trim(FORM.fatherEmployeer)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You provided a job for the host father, but didn't indicate the employer.");
			}
			// Father is Required
            if (LEN(TRIM(FORM.motherfirstname)) and not len(trim(FORM.motherdob)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please provide the birthdate for the Host Mother.");
			}
			
						// Father is Required
            if (LEN(TRIM(FORM.motherfirstname)) and not len(trim(FORM.motherworktype)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please provide the occupation for the Host Mother.");
			}
			// Father Occupation
            if ( LEN(TRIM(FORM.motherworktype)) and (FORM.motherfullpart eq 3 ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You provided a job for the host mother, but didn't indicate if you work full or part time.");
			}
			// Father Employer
            if ( LEN(TRIM(FORM.motherworktype))  and not len(trim(FORM.motherEmployeer)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You provided a job for the host mother, but didn't indicate the employer.");
			}
		</cfscript>
     
		<!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
           
			<!--- No Erros --->				
        		
            <!--- Update Record --->
            <cfquery datasource="mysql">
                UPDATE 
                    smg_hosts 
                SET
                    familylastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(FORM.familylastname)#">,
                    <!--- Father --->
                    fatherlastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherlastname#" null="#yesNoFormat(TRIM(FORM.fatherlastname) EQ '')#">,
                    fatherfirstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherfirstname#" null="#yesNoFormat(TRIM(FORM.fatherfirstname) EQ '')#">,
                    fathermiddlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fathermiddlename#" null="#yesNoFormat(TRIM(FORM.fathermiddlename) EQ '')#">,
                    fatherdob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.fatherdob#" null="#yesNoFormat(TRIM(FORM.fatherdob) EQ '')#">,
                    <cfif IsDate(FORM.fatherdob)>
	                    fatherbirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#Year(TRIM(FORM.fatherdob))#">,
                    </cfif>
                    fatherworktype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherworktype#" null="#yesNoFormat(TRIM(FORM.fatherworktype) EQ '')#">,
                    father_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#" null="#yesNoFormat(TRIM(FORM.father_cell) EQ '')#">,
                    <Cfif fatherfullpart neq 3>
                    fatherfullpart = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fatherfullpart#">,
                    </Cfif>
                    fatherEmployeer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(FORM.fatherEmployeer)#">,
					<!--- Mother --->
                    motherfirstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherfirstname#" null="#yesNoFormat(TRIM(FORM.motherfirstname) EQ '')#">,
                    motherlastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherlastname#" null="#yesNoFormat(TRIM(FORM.motherlastname) EQ '')#">,
                    mothermiddlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mothermiddlename#" null="#yesNoFormat(TRIM(FORM.mothermiddlename) EQ '')#">,
                    motherdob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.motherdob#" null="#yesNoFormat(TRIM(FORM.motherdob) EQ '')#">,
                    <cfif IsDate(FORM.motherdob)>
                    	motherbirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#Year(TRIM(FORM.motherdob))#">,
                    </cfif>
                    motherworktype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherworktype#" null="#yesNoFormat(TRIM(FORM.motherworktype) EQ '')#">,
                    mother_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mother_cell#" null="#yesNoFormat(TRIM(FORM.mother_cell) EQ '')#">,
                    <cfif motherfullpart neq 3>
                    motherfullpart = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.motherfullpart#">,
                    </cfif>
                    motherEmployeer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(FORM.motherEmployeer)#">,
					<!--- Address --->
                    address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#" null="#yesNoFormat(TRIM(FORM.address2) EQ '')#">,
                    city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                    state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                    zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                    phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#" null="#yesNoFormat(TRIM(FORM.phone) EQ '')#">,
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#" null="#yesNoFormat(TRIM(FORM.email) EQ '')#">,
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.password#">,
                    <!--- Mailing Address --->
                    mailaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailaddress#">,
                    mailaddress2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailaddress2#" null="#yesNoFormat(TRIM(FORM.mailaddress2) EQ '')#">,
                    mailcity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailcity#">,
                    mailstate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailstate#">,
                    mailzip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailzip#">,
                    homeIsFunctBusiness = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.homeIsFunctBusiness#">,
                    homeBusinessDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homeBusinessDesc#">,
                    lead = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                WHERE 
                    hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostid#">
            </cfquery>
            
           
    
    	</cfif> <!--- NOT SESSION.formErrors.length() --->
    
    <!--- FORM NOT SUBMITTED --->
    <cfelse>
    
         <cfscript>
			 // Set FORM Values   
			FORM.familylastname = qGetHostInfo.familylastname;
			// Father --->
			FORM.fatherlastname = qGetHostInfo.fatherlastname;
			FORM.fatherfirstname = qGetHostInfo.fatherfirstname;
			FORM.fathermiddlename = qGetHostInfo.fathermiddlename;
			FORM.fatherbirth = qGetHostInfo.fatherbirth;
			FORM.fatherdob = qGetHostInfo.fatherdob;
			FORM.fatherssn = qGetHostInfo.fatherssn;
			FORM.fatherworktype = qGetHostInfo.fatherworktype;
			FORM.fatherEmployeer = qGetHostInfo.fatheremployeer;
			FORM.father_cell = qGetHostInfo.father_cell;
			FORM.fatherfullpart = qGetHostInfo.fatherfullpart;
			
			// Mother --->    
			FORM.motherfirstname = qGetHostInfo.motherfirstname;
			FORM.motherlastname = qGetHostInfo.motherlastname;
			FORM.mothermiddlename = qGetHostInfo.mothermiddlename;
			FORM.motherbirth = qGetHostInfo.motherbirth;
			FORM.motherdob = qGetHostInfo.motherdob;
			FORM.motherssn = qGetHostInfo.motherssn;
			FORM.motherworktype = qGetHostInfo.motherworktype;
			FORM.mother_cell = qGetHostInfo.mother_cell;
			FORM.motherfullpart = qGetHostInfo.motherfullpart;
			FORM.motherEmployeer = qGetHostInfo.motherEmployeer;
			// Address --->
			FORM.address = qGetHostInfo.address;
			FORM.address2 = qGetHostInfo.address2;
			FORM.city = qGetHostInfo.city;
			FORM.state = qGetHostInfo.state;
			FORM.zip = qGetHostInfo.zip;
			FORM.phone = qGetHostInfo.phone;
			FORM.email = qGetHostInfo.email;
			FORM.password = qGetHostInfo.password;
			// Mailing Address --->
			FORM.mailaddress = qGetHostInfo.mailaddress;
			FORM.mailaddress2 = qGetHostInfo.mailaddress2;
			FORM.mailcity = qGetHostInfo.mailcity;
			FORM.mailstate = qGetHostInfo.mailstate;
			FORM.mailzip = qGetHostInfo.mailzip;
			FORM.homeIsFunctBusiness = qGetHostInfo.homeIsFunctBusiness;
			FORM.homeBusinessDesc = qGetHostInfo.homeBusinessDesc;
         	
			// the default values in the database for these used to be "na", so remove any.
         	if ( FORM.father_cell EQ 'na' ) {
				FORM.father_cell = '';
			}
			
			if ( FORM.mother_cell EQ 'na' )  {
				FORM.mother_cell = '';
			}
         </cfscript>
         
    </cfif>    

	<!--- lookup_success may be set to 1 to not require lookup on edit. --->
    <cfset FORM.lookup_success = 0>
    <cfset FORM.lookup_address = '#qGetHostInfo.address##chr(13)##chr(10)##qGetHostInfo.city# #qGetHostInfo.state# #qGetHostInfo.zip#'>
    <cfset FORM.allow_fatherssn = 0>
    <cfset FORM.allow_motherssn = 0>

	<!----
    <!--- address lookup turned on. --->
    <cfif application.address_lookup>
        <cfinclude template="includes/address_lookup_#application.address_lookup#.cfm">
    <!--- address lookup turned off. --->
    <cfelse>
        <!--- set to true so lookup is not required. --->
        <cfset FORM.lookup_success = 1>
        <Cfset application.address_lookup = 0>
    </cfif>
    ---->
	<cfset FORM.lookup_success = 1>
    <Cfset application.address_lookup = 0>



<script language="javascript">
	// JQuery Document Ready
	$(document).ready(function() {
		// Call animated scroll to anchor/id function - This will scroll up the page to the student detail div
		$('html,body').animate({scrollTop: $("#hostFamilyHeader").offset().top},'fast');
		// Set focus to the first field
		$("#familylastname").focus();
	});

	function ShowHide(){
		$("#slidingDiv").animate({"height": "toggle"}, { duration: 1000 });
	}

	// Copy Fields
	function FillFields(box) 
	{
		if (box.checked == false) { 
			document.my_form.mailaddress.value  = '';
			document.my_form.mailaddress2.value = '';
			document.my_form.mailcity.value = '';
			document.my_form.mailstate.value = '';
			document.my_form.mailzip.value = '';
		} else {
			document.my_form.mailaddress.value  = document.my_form.address.value;
			document.my_form.mailaddress2.value = document.my_form.address2.value;
			document.my_form.mailcity.value = document.my_form.city.value;
			document.my_form.mailstate.value = document.my_form.state.value;
			document.my_form.mailzip.value = document.my_form.zip.value;
		}
	}

	function checkForm() {
		<cfif application.address_lookup NEQ 2>
			if (document.my_form.state.value.length == 0) {alert("Please select the State."); return false; }
		</cfif>
		if (document.my_form.lookup_success.value != 1) {alert("Please lookup the address."); return false; }
		if (document.my_form.phone.value.length == 0 && document.my_form.father_cell.value.length == 0 && document.my_form.mother_cell.value.length == 0) {alert("Please enter one of the Phone fields."); return false; }
		return true;
	}

	
</script>

<cfoutput>

<cfform method="post" action="viewParents.cfm?itemID=#url.itemID#" name="my_form"  onsubmit="return validate(this)"> 
    <input type="hidden" name="submitted" value="1">
    <input type="hidden" name="allow_fatherssn" value="#FORM.allow_fatherssn#">
    <input type="hidden" name="allow_motherssn" value="#FORM.allow_motherssn#">
    <!--- this gets set to 1 by the javascript lookup function on success. --->
    <input type="hidden" name="lookup_success" value="#FORM.lookup_success#">

	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        />

    <div align="center">
      <span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + One phone field is required</span>
    </div>
  
  <h2>Home Address, Phone & Email</h2>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr>
        <td class="label"><h3>Family Name<span class="redtext">*</span></h3> </td>
        <td colspan=3><input type="text" name="familylastname" id="familylastname" value="#FORM.familylastname#" size="20" maxlength="150"></td>
    </tr>

    <tr bgcolor="##deeaf3">
        <td class="label">
        
        <h3>Address <span class="redtext">*</span></h3></td>
        <td colspan=2>
        	<cfinput type="text" name="address" value="#FORM.address#" size="40" maxlength="150"  validate="noblanks" >
            <font size="1">NO PO BOXES 
        </td>
        <td rowspan=2> <p><font size=-1><em>physical address where<Br /> 
          student will be living.<br />Mailing address can be<br />
           added below, if different.</em></font></p></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td></td>
        <td colspan=3><cfinput type="text" name="address2" value="#FORM.address2#" size="40" maxlength="150"></td>
    </tr>
    <tr>			 
        <td class="label"><h3>City <span class="redtext">*</span></h3></td>
        <td colspan=3><cfinput type="text" name="city" value="#FORM.city#" size="20" maxlength="150"></td>
    </tr>

    <tr bgcolor="##deeaf3">
        <td class="label"><h3>State <span class="redtext">*</span></h3></td>
        <td>
			<cfselect NAME="state" query="qGetStates" value="state" display="statename" selected="#FORM.state#" queryPosition="below">
				<option></option>
			</cfselect>
        </td>
        <td class="zip"><h3>Zip<span class="redtext">*</span></h3> </td>
        <td><cfinput type="text" name="zip" value="#FORM.zip#" size="5" maxlength="5" ></td>
    </tr>
	

    <tr >
        <td ><h3>Phone <span class="redtext">+</span></h3></td>
        <td colspan=3><cfinput type="text" name="phone" value="#FORM.phone#" size="16" placeholder="(208) 867-5309" maxlength="14" mask="(999) 999-9999"></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td ><h3>Email</h3></td>
        <td colspan=3><cfinput type="text" name="email" value="#FORM.email#" size="30" maxlength="200"></td>
    </tr>
    <tr>
        <td ><h3>Password</h3></td>
        <td colspan=3><cfinput type="text" name="password" value="#FORM.password#" size="30" maxlength="200"> 
        8 characters minimum</td>
    </tr>
  </table>
 <h2>Home Based Business</h2>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3">
        <td class="label" colspan=3><h3>Is the residence the site of a functioning business?(e.g. daycare, farm)<span class="redtext">*</span></h3> </td>
        <td>
            <cfinput type="radio" name="homeIsFunctBusiness" id="homeIsFunctBusiness1" value="1"
            	checked="#FORM.homeIsFunctBusiness eq 1#" onclick="document.getElementById('describeBusiness').style.display='table-row';" 
            	 />
            <label for="homeIsFunctBusiness1">Yes</label>
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            
            <cfinput type="radio" name="homeIsFunctBusiness" id="homeIsFunctBusiness0" value="0"
            	checked="#FORM.homeIsFunctBusiness eq 0#" onclick="document.getElementById('describeBusiness').style.display='none';" 
           		 />
            <label for="homeIsFunctBusiness0">No</label>
		 </td>
	</tr>
  
     <Tr>
	     <td align="left" colspan=4 id="describeBusiness" <cfif FORM.homeBusinessDesc is ''>  style="display: none;"</cfif>><Br /><strong>Please Describe<span class="redtext">*</span></strong><br><textarea cols="50" rows="4" name="homeBusinessDesc" wrap="VIRTUAL" placeholder="Name of Business, Nature of Business, etc"><Cfoutput>#FORM.homeBusinessDesc#</cfoutput></textarea></td>
	</tr>   
</table>
<br />
<!----
<a onclick="ShowHide(); return false;" href="##">+/- Need to add a mailing address that is different from the home address above?</a>
<div id="slidingDiv" display:"none">
---->
<h3>Mailing Address <font size=-1><input name="ShipSame" id="ShipSame" type="checkbox" class="formCheckbox" onClick="FillFields(this)" value="Same"<cfif IsDefined('FORM.ShipSame')> checked</cfif>><label for="ShipSame">Use Home Address</label></font></h3>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
   <tr bgcolor="##deeaf3">
        <td class="label"><h3>Address <span class="redtext">*</span></h3></td>
        <td colspan=3>
        	<cfinput type="text" name="mailaddress" value="#FORM.mailaddress#" size="40" maxlength="150" ></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td></td>
        <td colspan=3><cfinput type="text" name="mailaddress2" value="#FORM.mailaddress2#" size="40" maxlength="150"></td>
    </tr>
    <tr>			 
        <td class="label"><h3>City <span class="redtext">*</span></h3></td>
        <td colspan=3><cfinput type="text" name="mailcity" value="#FORM.mailcity#" size="20" maxlength="150"></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td class="label"><h3>State <span class="redtext">*</span></h3></td>
        <td>
			<cfselect NAME="mailstate" query="qGetStates" value="state" display="statename" selected="#FORM.mailstate#" queryPosition="below">
				<option></option>
			</cfselect>
        </td>
        <td class="zip"><h3>Zip<span class="redtext">*</span></h3> </td>
        <td><cfinput type="text" name="mailzip" value="#FORM.mailzip#" size="5" maxlength="5" ></td>
    </tr>
  </table>
  <!----
  </div>
  ---->
<br />
  <h2>Father's Information</h2>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr>
    	<td class="label"><h3>Last Name</h3></td>
        <td><cfinput type="text" name="fatherlastname" value="#FORM.fatherlastname#" size="20" maxlength="150"></td>
    </tr>
    <tr bgcolor="##deeaf3">
    	<td class="label"><h3>First Name</h3></td>
        <td><cfinput type="text" name="fatherfirstname" value="#FORM.fatherfirstname#" size="20" maxlength="150"></td>
    </tr>
    <tr>
    	<td class="label"><h3>Middle Name</h3></td>
        <td><cfinput type="text" name="fathermiddlename" value="#FORM.fathermiddlename#" size="20" maxlength="150"></td>
    </tr>
    <tr bgcolor="##deeaf3">
    	<td class="label"><h3>Date of Birth</h3></td>
        <td><cfinput type="text" name="fatherdob" value="#dateFormat(FORM.fatherdob, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" placeholder="MM/DD/YYYY"> </td>
    </tr>

    <tr >
    	<td class="label"><h3>Occupation</h3></td>
        <td><cfinput type="text" name="fatherworktype" value="#FORM.fatherworktype#" size="50" maxlength="200"> 
        <input name="fatherfullpart" type="radio" value="1" <cfif form.fatherfullpart eq 1>checked</cfif>> Full Time  
        <input name="fatherfullpart" type="radio" value="0" <cfif form.fatherfullpart eq 0>checked</cfif>> Part Time </td>
    </tr>
 <tr >
    	<td class="label"><h3>Employer</h3></td>
        <td><cfinput type="text" name="fatherEmployeer" value="#FORM.fatherEmployeer#" size="50" maxlength="200"> 
         </td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td class="label"><h3>Cell Phone <span class="redtext">+</span></h3></td>
        <td colspan=3><cfinput type="text" name="father_cell" value="#FORM.father_cell#" size="14" maxlength="14" placeholder="(208) 867-5309"  mask="(999) 999-9999" ></td>
    </tr>
        <cfif FORM.allow_fatherssn eq 1>
        <tr>
        	<td class="label"><h3>SSN</h3></td>
            <td><cfinput type="text" name="fatherssn" value="#FORM.fatherssn#" size="11" maxlength="11" mask="999-99-9999" > <em>We use this durring the background check.</em></td>
        </tr>	
    </cfif>
</table>

<br />
  <h2>Mother's Information</h2>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr>
    	<td class="label"><h3>Last Name</h3></td>
        <td><cfinput type="text" name="motherlastname" value="#FORM.motherlastname#" size="20" maxlength="150"></td>
    </tr>
    <tr  bgcolor="##deeaf3">
    	<td class="label"><h3>First Name</h3></td>
        <td><cfinput type="text" name="motherfirstname" value="#FORM.motherfirstname#" size="20" maxlength="150"></td>
    </tr>
    <tr>
    	<td class="label"><h3>Middle Name</h3></td>
        <td><cfinput type="text" name="mothermiddlename" value="#FORM.mothermiddlename#" size="20" maxlength="150"></td>
    </tr>			
    <tr  bgcolor="##deeaf3">
    	<td class="label"><h3>Date of Birth</h3></td>
        <td><cfinput type="text" name="motherdob" value="#dateFormat(FORM.motherdob, 'mm/dd/yyyy')#" size="12" maxlength="10" mask="99/99/9999" placeholder="MM/DD/YYYY"> </td>
    </tr>

    <tr>
    	<td class="label"><h3>Occupation</h3></td>
        <td><cfinput type="text" name="motherworktype" value="#FORM.motherworktype#" size="50" maxlength="200">  
		<input name="motherfullpart" type="radio" value="1" <cfif form.motherfullpart eq 1>checked</cfif>> Full Time  
        <input name="motherfullpart" type="radio" value="0" <cfif form.motherfullpart eq 0>checked</cfif>> Part Time </td>
    </tr>
 <tr >
    	<td class="label"><h3>Employer</h3></td>
        <td><cfinput type="text" name="motherEmployeer" value="#FORM.motherEmployeer#" size="50" maxlength="200"> 
         </td>
    </tr>
    <tr   bgcolor="##deeaf3">
        <td class="label"><h3>Cell Phone <span class="redtext">+</span></h3></td>
        <td colspan=3><cfinput type="text" name="mother_cell" value="#FORM.mother_cell#" size="14" maxlength="14" placeholder="(208) 867-5309" mask="(999) 999-9999" ></td>
    </tr>
        <cfif FORM.allow_motherssn eq 1>
        <tr>
        	<td class="label"><h3>SSN</h3></td>
            <td><cfinput type="text" name="motherssn" value="#FORM.motherssn#" size="11" maxlength="11" mask="999-99-9999" validate="social_security_number" message="Please enter a valid Mother's SSN."> <em>We use this durring the background check.</em></td>
        </tr>		
    </cfif>
</table> 		

<cfinclude template="updateInfoInclude.cfm">
</cfform>

<cfinclude template="approveDenyButtonsInclude.cfm">
</cfoutput>

