
<!--- Kill extra output --->

	    <Cfparam name="form.ssn" default="">
        <cfparam name="form.zip" default="">
        <cfparam name="form.dob" default="">
        <cfparam name="form.email" default="">
        <cfparam name="form.verifyEmail" default="">
        <cfparam name="form.submitted" default="0">
        <cfparam name="form.old_password" default="">
        <cfparam name="form.enctSSN" default="">
	
	<!--- Import CustomTag  ---->
	<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
	<!--- FORM Submitted --->
    <cfif FORM.submitted>
    		<cfscript>
               // Get User
               qGetUser = APPLICATION.CFC.USER.getUserByID(client.userid);
            </cfscript>
		<Cfif '#form.old_password#' NEQ '#qGetUser.password#'>
        	<cfscript>
				SESSION.formErrors.Add("Your current password is invalid.");
			</cfscript>
        </Cfif>
		<cfscript>
		 
                // Father SSN - Will update if it's blank or there is a new number
                if ( isValid("social_security_number", Trim(FORM.SSN)) ) {
                    // Encrypt Social
                    FORM.enctSSN = APPLICATION.CFC.UDF.encryptVariable(FORM.SSN);
                    // Update
                }
          
		// Data Validation - Check required Fields
			if ( NOT LEN(FORM.zip) OR (LEN(FORM.zip) GT 5)) {
				SESSION.formErrors.Add("Please enter a valid zip code.");
			}
			// Data Validation - Check required Fields
			if ((FORM.email) NEQ (FORM.verifyEmail)) {
				SESSION.formErrors.Add("Your email addresses do not match. ");
			}
			
			// Valid Email Address
            if ( LEN(TRIM(FORM.email)) AND NOT isValid("email", TRIM(FORM.email)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("The email address you have entered does not appear to be valid.");
            }
			// Valid Email Address
            if ( NOT LEN(TRIM(FORM.email)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("The email address you have entered does not appear to be valid.");
            }	

			if ( LEN(FORM.DOB) AND NOT IsDate(FORM.DOB) ) {
				FORM.DOB = '';
				SESSION.formErrors.Add("Please enter a valid Date of Birth.");				
            } 
		if ( NOT LEN(FORM.DOB) ) {
				FORM.DOB = '';
				SESSION.formErrors.Add("Please enter a valid Date of Birth.");				
            } 
			// Data Validation - Check required Fields  			
			if ( LEN(FORM.SSN) AND Left(FORM.SSN, 3) NEQ 'XXX' AND NOT isValid("social_security_number", Trim(FORM.SSN)) ) {
				SESSION.formErrors.Add("Please enter a valid SSN.");
            }    
		// Data Validation - Check required Fields  			
			if ( NOT LEN(FORM.SSN) ) {
				SESSION.formErrors.Add("Please enter a SSN.");
            }   
		</cfscript>
        <Cfset errorMsg = ''>
        <!----Password Check---->
        <cfif trim(form.old_password) EQ ''>
			<cfset errorMsg = "Please enter the Old Password.">
		<cfelseif trim(form.new_password) EQ ''>
            <cfset errorMsg = "Please enter the New Password.">
        <cfelseif trim(form.verify_new_password) EQ ''>
            <cfset errorMsg = "Please verify the New Password.">
        <cfelseif trim(form.old_password) EQ trim(form.new_password)>
            <cfset errorMsg = "New Password cannot be the same as Old Password.">
        <cfelseif len(trim(form.new_password)) LT 8>
            <cfset errorMsg = "New Password must be at least 8 characters.">
        <cfelseif trim(form.new_password) NEQ trim(form.verify_new_password)>
            <cfset errorMsg = "Verify New Password must be the same as New Password.">
        </cfif>
        <cfif errorMsg NEQ ''>
        	<cfscript>
				SESSION.formErrors.Add("#errorMsg#");
			</cfscript>
        <cfelse>
			<cfset contains_alpha = 0>
            <cfset contains_numeric = 0>
            <cfloop index="i" from="1" to="#len(trim(form.new_password))#">
                <cfset character = mid(trim(form.new_password), i, 1)>
                <cfif character GTE 'A' AND character LTE 'Z'>
                    <cfset contains_alpha = 1>
                </cfif>
                <cfif isNumeric(character)>
                    <cfset contains_numeric = 1>
                </cfif>
            </cfloop>
            <cfif not (contains_alpha AND contains_numeric)>
				<cfscript>
                    SESSION.formErrors.Add("New Password must include both alphabetic and numeric characters.");
                </cfscript>
             </cfif>
        </cfif>
           <cfscript>
                // Father SSN - Will update if it's blank or there is a new number
                if ( isValid("social_security_number", Trim(FORM.SSN)) ) {
                    // Encrypt Social
                    FORM.SSN = APPLICATION.CFC.UDF.encryptVariable(FORM.SSN);
                    // Update
                    vUpdateUserSSN = 1;
                } 
            </cfscript>

     
     	<!---End of Password Check---->   
		 <cfif NOT SESSION.formErrors.length()>
    
     <cfquery name="updateInfo" datasource="#application.dsn#">
     update smg_users
     set ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.enctSSN#">,
     	 email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
         password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.new_password#">,
         dob = <cfqueryparam cfsqltype="cf_sql_date" value="#form.dob#">,
         zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">
     where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
     
     </cfquery>
     <cfset temp = DeleteClientVariable("needsSSN")>
     <cflocation url="index.cfm?curdoc=initial_welcome">
     </cfif>   
      </cfif>
    <!--- // Check if there are no errors --->
     
	
    
        
     

<style type="text/css">
	
	ul, li {
		margin:0;
		padding:0;
		list-style-type:none;
	}
	#outerContainer {
	width:800px;
	margin-right:auto;
	margin-left:auto;

}
	#container {
	width:400px;
	padding:0px;
	background:#fefefe;
	margin:0 auto;
	border:1px solid #c4cddb;
	border-top-color:#d3dbde;
	border-bottom-color:#bfc9dc;
	box-shadow:0 1px 1px #ccc;
	border-radius:5px;
	position:relative;
}
h1 {
	margin:0;
	padding:10px 0;
	font-size:24px;
	text-align:center;
	background:#eff4f7;
	border-bottom:1px solid #dde0e7;
	box-shadow:0 -1px 0 #fff inset;
	border-radius:5px 5px 0 0; /* otherwise we get some uncut corners with container div */
	text-shadow:1px 1px 0 #fff;
}

form ul li {
	margin:10px 20px;

}
form ul li:last-child {
	text-align:center;
	margin:20px 0 25px 0;

}
input {
	padding:10px 10px;
	border:1px solid #d5d9da;
	border-radius:5px;
	box-shadow: 0 0 5px #e8e9eb inset;
	width:328px; /* 400 (#container) - 40 (li margins) -  10 (span paddings) - 20 (input paddings) - 2 (input borders) */
	
	outline:0; /* remove webkit focus styles */
	font-size:16px; color:#333;
}
input:focus {
	border:1px solid #b9d4e9;
	border-top-color:#b6d5ea;
	border-bottom-color:#b8d4ea;
	box-shadow:0 0 5px #b9d4e9;
}

label {
	color:#555;
}
#container span {
	background:#f6f6f6;
	padding:3px 5px;
	display:block;
	border-radius:5px;
	margin-top:5px;
}

button {
	background: #57a9eb; /* Old browsers */
	background: -moz-linear-gradient(top, #57a9eb 0%, #3a76c4 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#57a9eb), color-stop(100%,#3a76c4)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #57a9eb 0%,#3a76c4 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #57a9eb 0%,#3a76c4 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top, #57a9eb 0%,#3a76c4 100%); /* IE10+ */
	background: linear-gradient(top, #57a9eb 0%,#3a76c4 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#57a9eb', endColorstr='#3a76c4',GradientType=0 ); /* IE6-9 */
	border:1px solid #326fa9;
	border-top-color:#3e80b1;
	border-bottom-color:#1e549d;
	color:#fff;
	text-shadow:0 1px 0 #1e3c5e;
	font-size:.875em;
	padding:8px 15px;
	width:150px;
	border-radius:20px;
	box-shadow:0 1px 0 #bbb, 0 1px 0 #9cccf3 inset;
}
button:active {
	background: #3a76c4; /* Old browsers */
	background: -moz-linear-gradient(top, #3a76c4 0%, #57a9eb 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#3a76c4), color-stop(100%,#57a9eb)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #3a76c4 0%,#57a9eb 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #3a76c4 0%,#57a9eb 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top, #3a76c4 0%,#57a9eb 100%); /* IE10+ */
	background: linear-gradient(top, #3a76c4 0%,#57a9eb 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#3a76c4', endColorstr='#57a9eb',GradientType=0 ); /* IE6-9 */
	box-shadow:none;
	text-shadow:0 -1px 0 #1e3c5e;
}

#pswd_info {
	position:absolute;
	bottom:220px;
	bottom: -115px\9; /* IE Specific */
	right:55px;
	width:250px;
	padding:15px;
	background:#fefefe;
	font-size:.875em;
	border-radius:5px;
	box-shadow:0 1px 3px #ccc;
	border:1px solid #ddd;
}

#pswd_info h4 {
	margin:0 0 10px 0;
	padding:0;
	font-weight:normal;
}

#pswd_info::before {
	content: "\25BC";
	position:absolute;
	bottom:-16px;
	left:45%;
	font-size:14px;
	line-height:14px;
	color:#ddd;
	text-shadow:none;
	display:block;
}

.invalid {
	background:url(pics/invalid.png) no-repeat 0 50%;
	padding-left:22px;
	line-height:24px;
	color:#ec3f41;
}
.valid {
	background:url(pics/valid.png) no-repeat 0 50%;
	padding-left:22px;
	line-height:24px;
	color:#3a7d34;
}

#pswd_info {
	display:none;
}

.descriptiveText {	
	font-size:16px;
	float:right;
	display:block;
	margin-top:10px;
	
	
}	
.descriptiveText p {
	margin:20px;	
	font-size:16px;
	
}	
.descriptiveText ol {
	margin:10px;	
	font-size:16px;
	background-color:#fff;	
}	


</style>

	

		
       

<cfoutput>
	
      <cfscript>
	  		FORM.SSN = APPLICATION.CFC.UDF.displaySSN(varString='#form.ssn#', displayType='user');
	  </cfscript>
	 <script src="linked/js/jquery.validateAccountInfo.js"></script>
        
  <div id="outerContainer">
   	<!--- Form Errors --->
        <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="onlineApplication"
        />
		<div style="width:49%;float:left;display:block;margin-top:10px">
                <div id="container">
                <h1>Account Security & Verification</h1>
                <cfform action="?curdoc=forms/verifyInfo">
                <input type="hidden" name="submitted" value="1">
                <input type="hidden" name="enctSSN" value="#form.enctSSN#">
                    <ul>
                        <li>
                            <label for="username">Email Address</label>
                            <span><input id="email" name="email" type="text" placeholder="user@domain.com" value="#form.email#" class="placeholderText" /></span>
                        </li>
                         <li>
                            <label for="username">Verify Email Address</label>
                            <span><input id="email" name="verifyEmail" type="text" placeholder="user@domain.com" value="#form.verifyemail#" class="placeholderText" /></span>
                        </li>
                        <li>
                            <label for="username">Date of Birth</label>
                            <span><cfinput id="dob" name="dob" type="text" placeholder="MM/DD/YYYY" value="#form.dob#" mask="99/99/9999" class="placeholderText" /></span>
                        </li>
                        <li>
                            <label for="username">Social Security</label>
                            <span><cfinput id="social" name="ssn" type="text" placeholder="123-45-6789" value="#form.ssn#" mask="???-??-9999" class="placeholderText" /></span>
                        </li>
                        <li>
                            <label for="pswd">Zip Code</label>
                            <span><input id="zip" type="text" name="zip" placeholder="33334" value="#form.zip#" maxlength=5 class="placeholderText" class="placeholderText" /></span>
                        </li>
                        <li>
                            <label for="pswd">Current Password:</label>
                            <span><input id="currentpswd" type="password" name="old_password" placeholder="********" value="#form.old_password#" class="placeholderText" /></span>
                        </li>
                        <li>
                            <label for="pswd">New Password:</label>
                            <span><input id="pswd" type="password" name="new_password" placeholder="6%tDf$s" class="placeholderText"  /></span>
                        </li>
                        <li>
                            <label for="pswd">Confirm Password:</label>
                            <span><input id="pswd2" type="password" name="verify_new_password" placeholder="" /></span>
                        </li>
                        <li>
                            <button type="submit">Validate</button>
                        </li>
                    </ul>
                </cfform>
                
                <div id="pswd_info">
                    <h4>Password must meet the following requirements:</h4>
                    <ul>
                        <li id="letter" class="invalid">At least <strong>one letter</strong></li>
                        <li id="number" class="invalid">At least <strong>one number</strong></li>
                        <li id="length" class="invalid">Be at least <strong>8 characters</strong></li>
                    </ul>
                </div>
                </div>
              </div>
     
                    <!--- ------------------------------------------------------------------------- ---->
	<!---- Right Column---->
    <!--- ------------------------------------------------------------------------- ---->
    <!--- ------------------------------------------------------------------------- ---->
    <!--- ------------------------------------------------------------------------- ---->
  <div class="descriptiveText" style="width:46%;background-color:##eff4f7;float:right;display:block;">
   
   <p>To increase account access security and to ensure that we are in compliance with Dept. of State regulations, we have implemented a continuing account verification tool.</p>
  <p>From time to time, you will be asked to submit certain information on your account to make sure that we have current and accurate information on everyone who is accessing EXITS and help ensure the safety of our students, host families, and users.</p>
  <p>Along with verifying information on your account, account passwords must now meet minimum requirements:
  	
    <ol>
    	<li>  They need to be 8 characters long</li>
        <li>  Must contain at least 1 letter</li>
        <li>  Must contain at least 1 number</li>
    </ol>
   
    </p>
  <p>Once the form at the left is succesfully submited, you will immediatly have full account access.</p>
  
  </div>
</div>      
	

</cfoutput>




