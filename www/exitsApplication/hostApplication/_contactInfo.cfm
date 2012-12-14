<!--- ------------------------------------------------------------------------- ----
	
	File:		contactInfo.cfm
	Author:		Josh Rahl
	Date:		March 3, 2011
	Desc:		Contact Information

	Updated:	
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionID" default="0">
    <cfparam name="FORM.familylastname" default="">
	<!--- Father --->
    <cfparam name="FORM.fatherlastname" default="">
    <cfparam name="FORM.fatherFirstName" default="">
    <cfparam name="FORM.fathermiddlename" default="">
    <cfparam name="FORM.fatherdob" default="">
    <cfparam name="FORM.fatherbirth" default="">
    <cfparam name="FORM.fatherworktype" default="">
    <cfparam name="FORM.fatherEmployeer" default="">
    <cfparam name="FORM.father_cell" default="">
    <cfparam name="FORM.fatherfullpart" default="">
	<!--- Mother --->    
    <cfparam name="FORM.motherFirstName" default="">
    <cfparam name="FORM.motherlastname" default="">
    <cfparam name="FORM.mothermiddlename" default="">
    <cfparam name="FORM.motherdob" default="">
    <cfparam name="FORM.motherbirth" default="">
    <cfparam name="FORM.motherworktype" default="">
    <cfparam name="FORM.motherEmployeer" default="">
    <cfparam name="FORM.mother_cell" default="">
    <cfparam name="FORM.motherfullpart" default="">
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
            }	
	
			// Phones
            if ( NOT LEN(TRIM(FORM.phone)) AND NOT LEN(TRIM(FORM.father_cell)) AND NOT LEN(TRIM(FORM.mother_cell)) ) {
                SESSION.formErrors.Add("Please enter one of the Phone fields: Home, Father Cell or Mother Cell");
            }	
	
			// Valid Phone
            if ( LEN(TRIM(FORM.phone)) AND NOT isValid("telephone", TRIM(FORM.phone)) ) {
                SESSION.formErrors.Add("The home phone number you have entered does not appear to be valid. ");
            }	
	
			// Valid Email Address
            if ( LEN(TRIM(FORM.email)) AND NOT isValid("email", TRIM(FORM.email)) ) {
                SESSION.formErrors.Add("The email address you have entered does not appear to be valid.");
            }	
			
			// Valid Password
            if ( LEN(TRIM(FORM.password)) LT 6) {
                SESSION.formErrors.Add("Your password must be at least 6 characters long.");
            }	
			
			// Valid Father's DOB
            if ( LEN(TRIM(FORM.fatherdob)) AND NOT isValid("date", TRIM(FORM.fatherdob)) ) {
                SESSION.formErrors.Add("Please enter a valid Date of Birth for the Father");
            }	

			// Valid Father's Phone
            if ( LEN(TRIM(FORM.father_cell)) AND NOT isValid("telephone", TRIM(FORM.father_cell)) ) {
                SESSION.formErrors.Add("Please enter a valid phone number for the Father's Cell Phone.");
            }	

			// Valid Mother's DOB
            if ( LEN(TRIM(FORM.motherdob)) AND NOT isValid("date", TRIM(FORM.motherdob)) ) {
                SESSION.formErrors.Add("The date you specified is not valid for Mother's Date of Birth");
            }	
			
			// Valid Mother's Phone
            if ( LEN(TRIM(FORM.mother_cell)) AND NOT isValid("telephone", TRIM(FORM.mother_cell)) ) {
                SESSION.formErrors.Add("Please enter a valid phoe number for Mother's Cell Phone");
			}
			
			// Functioning Business
            if ( NOT LEN(FORM.homeIsFunctBusiness) ) {
                SESSION.formErrors.Add("Please indicate if your home is also a functioning business.");
			}
			
			// No business Des
            if (( FORM.homeIsFunctBusiness EQ 1) AND NOT LEN(TRIM(FORM.homeBusinessDesc)) )  {
                SESSION.formErrors.Add("You have indicated that your home is also a business, but have not provided details on the type of business.");
			}
			
			// No business Des
            if ( NOT LEN(TRIM(FORM.fatherlastname)) AND NOT LEN(TRIM(FORM.motherlastname)) )  {
                SESSION.formErrors.Add("If you are single, you must provide information for at least one of the host parents, either the father or mother. If you are not single, please provide information on both host parents.");
			}
			
			// Father is Required
            if ( LEN(TRIM(FORM.fatherFirstName)) AND NOT LEN(TRIM(FORM.fatherdob)) )  {
                SESSION.formErrors.Add("Please provide the birthdate for the Host Father.");
			}
			
			// Father is Required
            if ( LEN(TRIM(FORM.fatherFirstName)) AND NOT LEN(TRIM(FORM.fatherworktype)) )  {
                SESSION.formErrors.Add("Please provide the occupation for the Host Father.");
			}
			
			// Father Occupation
            if ( LEN(TRIM(FORM.fatherworktype)) AND NOT LEN (FORM.fatherfullpart) ) {
                SESSION.formErrors.Add("You provided a job for the host father, but didn't indicate if you work full or part time.");
			}
			
			// Father Employer
            if ( LEN(TRIM(FORM.fatherworktype)) AND NOT LEN(TRIM(FORM.fatherEmployeer)) ) {
                SESSION.formErrors.Add("You provided a job for the host father, but didn't indicate the employer.");
			}
			// Father is Required
            if ( LEN(TRIM(FORM.motherFirstName)) AND NOT LEN(TRIM(FORM.motherdob)) )  {
                SESSION.formErrors.Add("Please provide the birthdate for the Host Mother.");
			}
			
			// Father is Required
            if ( LEN(TRIM(FORM.motherFirstName)) AND NOT LEN(TRIM(FORM.motherworktype)) )  {
                SESSION.formErrors.Add("Please provide the occupation for the Host Mother.");
			}
			
			// Father Occupation
            if ( LEN(TRIM(FORM.motherworktype)) AND NOT LEN(FORM.motherfullpart) ) {
                SESSION.formErrors.Add("You provided a job for the host mother, but didn't indicate if you work full or part time.");
			}
			
			// Father Employer
            if ( LEN(TRIM(FORM.motherworktype)) AND NOT LEN(TRIM(FORM.motherEmployeer)) ) {
                SESSION.formErrors.Add("You provided a job for the host mother, but didn't indicate the employer.");
			}
		</cfscript>
        
        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
            
			<!--- No Erros --->				
        		
            <!--- Update Record --->
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                    smg_hosts 
                SET
                    familylastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.familylastname)#">,
                    <!--- Father --->
                    fatherlastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherlastname#">,
                    fatherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherFirstName#">,
                    fathermiddlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fathermiddlename#">,
                    fatherdob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.fatherdob#" null="#yesNoFormat(TRIM(FORM.fatherdob) EQ '')#">,
                    <cfif IsDate(FORM.fatherdob)>
	                    fatherbirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#Year(TRIM(FORM.fatherdob))#">,
                    </cfif>
                    fatherworktype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherworktype#">,
                    father_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#">,
                    fatherfullpart = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fatherfullpart#" null="#yesNoFormat(NOT LEN(FORM.fatherfullpart))#">,
                    fatherEmployeer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherEmployeer)#">,
					<!--- Mother --->
                    motherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherFirstName#">,
                    motherlastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherlastname#">,
                    mothermiddlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mothermiddlename#">,
                    motherdob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.motherdob#" null="#yesNoFormat(TRIM(FORM.motherdob) EQ '')#">,
                    <cfif IsDate(FORM.motherdob)>
                    	motherbirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#Year(TRIM(FORM.motherdob))#">,
                    </cfif>
                    motherworktype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherworktype#">,
                    mother_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mother_cell#">,
                    motherfullpart = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.motherfullpart#" null="#yesNoFormat(NOT LEN(FORM.motherfullpart))#">,
                    motherEmployeer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherEmployeer)#">,
					<!--- Address --->
                    address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                    city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                    state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                    zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                    phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.password#">,
                    <!--- Mailing Address --->
                    mailaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailaddress#">,
                    mailaddress2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailaddress2#">,
                    mailcity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailcity#">,
                    mailstate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailstate#">,
                    mailzip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mailzip#">,
                    homeIsFunctBusiness = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.homeIsFunctBusiness#">,
                    homeBusinessDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homeBusinessDesc#">,
                    lead = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
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
			// Father --->
			FORM.fatherlastname = qGetHostInfo.fatherlastname;
			FORM.fatherFirstName = qGetHostInfo.fatherFirstName;
			FORM.fathermiddlename = qGetHostInfo.fathermiddlename;
			FORM.fatherbirth = qGetHostInfo.fatherbirth;
			FORM.fatherdob = qGetHostInfo.fatherdob;
			FORM.fatherworktype = qGetHostInfo.fatherworktype;
			FORM.fatherEmployeer = qGetHostInfo.fatheremployeer;
			FORM.father_cell = qGetHostInfo.father_cell;
			FORM.fatherfullpart = qGetHostInfo.fatherfullpart;
			// Mother --->    
			FORM.motherFirstName = qGetHostInfo.motherFirstName;
			FORM.motherlastname = qGetHostInfo.motherlastname;
			FORM.mothermiddlename = qGetHostInfo.mothermiddlename;
			FORM.motherbirth = qGetHostInfo.motherbirth;
			FORM.motherdob = qGetHostInfo.motherdob;
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

</cfsilent>

<script language="javascript">
	// JQuery Document Ready
	$(document).ready(function() {
		// Call animated scroll to anchor/id function - This will scroll up the page to the student detail div
		//$('html,body').animate({scrollTop: $("#hostFamilyHeader").offset().top},'fast');
		// Set focus to the first field
		$("#familylastname").focus();
	});

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
</script>

<cfoutput>

    <h1 class="enter" id="hostFamilyHeader">#lcase(FORM.familylastname)# Family Application</h1>
    
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
        
        <span class="required">* Required fields &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + One phone field is required</span>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr>
                <td class="label" width="110px"><h3>Family Name <span class="required">*</span></h3></td>
                <td colspan="3"><input type="text" name="familylastname" id="familylastname" value="#FORM.familylastname#" class="xLargeField" maxlength="150"></td>
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
                <td colspan="3"><input type="text" name="address2" id="address2" value="#FORM.address2#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>			 
                <td class="label"><h3>City <span class="required">*</span></h3></td>
                <td colspan="3"><input type="text" name="city" id="city" value="#FORM.city#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>State <span class="required">*</span></h3></td>
                <td>
                    <cfselect name="state" id="state" query="qGetStates" value="state" display="statename" selected="#FORM.state#" queryPosition="below" class="largeField">
                        <option></option>
                    </cfselect>
                </td>
                <td class="zip"><h3>Zip <span class="required">*</span></h3> </td>
                <td><input type="text" name="zip" id="zip" value="#FORM.zip#" class="mediumField" maxlength="5"></td>
            </tr>
            <tr>
                <td><h3>Phone <span class="required">+</span></h3></td>
                <td colspan="3"><cfinput type="text" name="phone" value="#FORM.phone#" class="mediumField" placeholder="(999) 999-9999" maxlength="14" mask="(999) 999-9999"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td><h3>Email</h3></td>
                <td colspan="3"><input type="text" name="email" value="#FORM.email#" class="xLargeField" maxlength="200"></td>
            </tr>
            <tr>
                <td><h3>Password</h3></td>
                <td colspan="3">
                    <input type="text" name="password" value="#FORM.password#" class="xLargeField" maxlength="30"> 
                    <font size="1">6 characters minimum</font>
                </td>
            </tr>
        </table> <br />
        
        <h3>Home Based Business</h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label" colspan="3"><h3>Is the residence the site of a functioning business?(e.g. daycare, farm) <span class="required">*</span></h3> </td>
                <td>
                    <cfinput type="radio" name="homeIsFunctBusiness" id="homeIsFunctBusiness1" value="1" checked="#FORM.homeIsFunctBusiness eq 1#" onclick="document.getElementById('describeBusiness').style.display='table-row';"/>
                    <label for="homeIsFunctBusiness1">Yes</label>        
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        
                    <cfinput type="radio" name="homeIsFunctBusiness" id="homeIsFunctBusiness0" value="0" checked="#FORM.homeIsFunctBusiness eq 0#" onclick="document.getElementById('describeBusiness').style.display='none';" />
                    <label for="homeIsFunctBusiness0">No</label>
                </td>
            </tr>
            <tr>
                <td align="left" colspan="4" id="describeBusiness" <cfif FORM.homeBusinessDesc is ''>class="displayNone"</cfif>>
                    <strong>Please Describe <span class="required">*</span></strong><br />
                    <textarea cols="50" rows="4" name="homeBusinessDesc" placeholder="Name of Business, Nature of Business, etc">#FORM.homeBusinessDesc#</textarea>
                </td>
            </tr>   
        </table> <br />
        
        <h3>
            Mailing Address <input name="ShipSame" id="ShipSame" type="checkbox" class="formCheckbox" onClick="FillFields(this)" value="Same"<cfif IsDefined('FORM.ShipSame')> checked</cfif>>
            <label for="ShipSame"><font size="-1">Use Home Address</font></label>
        </h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Address <span class="required">*</span></h3></td>
                <td colspan="3"><input type="text" name="mailaddress" id="mailaddress" value="#FORM.mailaddress#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td></td>
                <td colspan="3"><input type="text" name="mailaddress2" id="mailaddress2" value="#FORM.mailaddress2#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>			 
                <td class="label"><h3>City <span class="required">*</span></h3></td>
                <td colspan="3"><input type="text" name="mailcity" id="mailcity" value="#FORM.mailcity#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>State <span class="required">*</span></h3></td>
                <td>
                    <cfselect name="mailstate" id="mailstate" query="qGetStates" value="state" display="statename" selected="#FORM.mailstate#" queryPosition="below" class="largeField">
                        <option></option>
                    </cfselect>
                </td>
                <td class="zip"><h3>Zip <span class="required">*</span></h3> </td>
                <td><input type="text" name="mailzip" id="mailzip" value="#FORM.mailzip#" class="smallField" maxlength="5"></td>
            </tr>
        </table> <br />
        
        <h3>Father's Information</h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>First Name</h3></td>
                <td><input type="text" name="fatherFirstName" value="#FORM.fatherFirstName#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3>Last Name</h3></td>
                <td><input type="text" name="fatherlastname" value="#FORM.fatherlastname#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3>Middle Name</h3></td>
                <td><input type="text" name="fathermiddlename" value="#FORM.fathermiddlename#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Date of Birth</h3></td>
                <td><cfinput type="text" name="fatherdob" value="#dateFormat(FORM.fatherdob, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" placeholder="MM/DD/YYYY"> </td>
            </tr>
            <tr>
                <td class="label"><h3>Occupation</h3></td>
                <td>
                    <input type="text" name="fatherworktype" value="#FORM.fatherworktype#" class="xLargeField" maxlength="200"> 
                    <input name="fatherfullpart" id="fatherFullTime" type="radio" value="1" <cfif FORM.fatherfullpart eq 1>checked</cfif>> <label for="fatherFullTime">Full Time</label>
                    <input name="fatherfullpart" id="fatherPartTime" type="radio" value="0" <cfif FORM.fatherfullpart eq 0>checked</cfif>> <label for="fatherPartTime">Part Time</label>
                </td>
            </tr>
            <tr>
                <td class="label"><h3>Employer</h3></td>
                <td><input type="text" name="fatherEmployeer" value="#FORM.fatherEmployeer#" class="xLargeField" maxlength="200"> </td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Cell Phone <span class="required">+</span></h3></td>
                <td colspan="3"><cfinput type="text" name="father_cell" value="#FORM.father_cell#" size="14" maxlength="14" placeholder="(999) 999-9999"  mask="(999) 999-9999" ></td>
            </tr>
        </table> <br />
        
        <h3>Mother's Information</h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>First Name</h3></td>
                <td><input type="text" name="motherFirstName" value="#FORM.motherFirstName#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3>Last Name</h3></td>
                <td><input type="text" name="motherlastname" value="#FORM.motherlastname#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3>Middle Name</h3></td>
                <td><input type="text" name="mothermiddlename" value="#FORM.mothermiddlename#" class="xLargeField" maxlength="150"></td>
            </tr>			
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Date of Birth</h3></td>
                <td><cfinput type="text" name="motherdob" value="#dateFormat(FORM.motherdob, 'mm/dd/yyyy')#" class="mediumField" maxlength="10" mask="99/99/9999" placeholder="MM/DD/YYYY"> </td>
            </tr>
            
            <tr>
                <td class="label"><h3>Occupation</h3></td>
                <td>
                    <input type="text" name="motherworktype" value="#FORM.motherworktype#" class="xLargeField" maxlength="200">  
                    <input name="motherfullpart" id="motherFullTime" type="radio" value="1" <cfif FORM.motherfullpart eq 1>checked</cfif>> <label for="motherFullTime">Full Time</label>
                    <input name="motherfullpart" id="motherPartTime" type="radio" value="0" <cfif FORM.motherfullpart eq 0>checked</cfif>> <label for="motherPartTime">Part Time</label>
                </td>
            </tr>
            <tr>
                <td class="label"><h3>Employer</h3></td>
                <td><input type="text" name="motherEmployeer" value="#FORM.motherEmployeer#" class="xLargeField" maxlength="200"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label"><h3>Cell Phone <span class="required">+</span></h3></td>
                <td colspan="3"><cfinput type="text" name="mother_cell" value="#FORM.mother_cell#" size="14" maxlength="14" placeholder="(999) 999-9999" mask="(999) 999-9999" ></td>
            </tr>
        </table> 		
        
        <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
            <tr>
                <td align="right"><input name="Submit" type="image" src="images/buttons/Next.png" border="0"></td>
            </tr>
        </table>
    
	</cfform>
    
</cfoutput>