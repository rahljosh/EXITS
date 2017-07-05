  <!-- CSS Global Compulsory -->
	<link rel="stylesheet" href="../assets/plugins/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="../assets/css/style.css">

	<!-- CSS Header and Footer -->
	<link rel="stylesheet" href="../assets/css/headers/header-default.css">
	<link rel="stylesheet" href="../assets/css/footers/footer-v1.css">

	<!-- CSS Implementing Plugins -->
	<link rel="stylesheet" href="../assets/plugins/animate.css">
	<link rel="stylesheet" href="../assets/plugins/line-icons/line-icons.css">
	<script src="https://use.fontawesome.com/b474fc74fd.js"></script>
<!--	<link rel="stylesheet" href="../assets/plugins/font-awesome/css/font-awesome.min.css">-->

	<!-- CSS Page Style -->
	<link rel="stylesheet" href="../assets/css/pages/page_log_reg_v1.css">
	<!----Profile---->
	<link rel="stylesheet" href="../assets/css/pages/profile.css">
	<link rel="stylesheet" href="../assets/plugins/scrollbar/css/jquery.mCustomScrollbar.css">

	<!----Form Elements---->
	<link rel="stylesheet" href="../assets/plugins/sky-forms-pro/skyforms/css/sky-forms.css">
	<link rel="stylesheet" href="../assets/plugins/sky-forms-pro/skyforms/custom/custom-sky-forms.css">

	<!-- CSS Implementing Plugins -->

	<!----User Profile Elements---->
	<!-- CSS Page Style -->
	<link rel="stylesheet" href="../assets/css/pages/profile.css">


	<!-- CSS Theme -->
	<link rel="stylesheet" href="../assets/css/theme-colors/blue.css" id="style_color">
	<link rel="stylesheet" href="../assets/css/theme-skins/dark.css">

	<!-- CSS Customization -->
	<link rel="stylesheet" href="../assets/css/custom.css">
	<!--Format Date Picker-->	

	<cfparam name="unify" default="">
    <!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	




  <!--- Param URL Variables --->
  <cfparam name="URL.hostID" default="">
  <cfparam name="URL.leadID" default="">
  <cfparam name="URL.skip" default="0">
  <cfparam name="URL.skip" default="0">
 	<cfoutput>
			<link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
			<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
			<script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
		</cfoutput> 
	<script type="text/javascript" src="../assets/js/jquery.maskedinput.js"></script>
	<script>
	jQuery(function($){
	  
	   $("#father_cell").mask("(999) 999-9999");
	  
	});	
	</script>

	<cfscript>
		SESSION.FormErrors.clear();
	</cfscript>
	<!--- Param FORM Variables --->
	<cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.hostID" default="0">    
    <cfparam name="FORM.fatherLastName" default="">
    <cfparam name="FORM.fatherFirstName" default="">
  
   
    <cfparam name="FORM.father_cell" default="">
  
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.zipLookup" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.password" default="">
    <cfparam name="FORM.companyID" default="">
    <cfparam name="FORM.regionid" default="#CLIENT.regionid#">
    <cfparam name="FORM.arearepid" default="#CLIENT.userid#">
    <cfparam name="FORM.subAction" default="">
	<cfparam name="FORM.sourceCode" default="Representative">
    <cfparam name="FORM.sourceType" default="">
    <cfparam name="FORM.sourceOther" default="">

	<cfparam name="FORM.skip" default="0">
	<cfif val(FORM.skip)>
		<cfset URL.skip =1>	
    </cfif>
	
		
		<cfscript>	

		// Check if we have a valid URL.hostID
		if ( VAL(URL.hostID) AND NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;
		}
		
		//Random Password for account, if needed
		strPassword = APPLICATION.CFC.UDF.randomPassword(length=8);
		
		// Get State List
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
		
		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=CLIENT.usertype);
		
		// Get Current User Information
		qGetUserComplianceInfo = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID);
		
		vCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().season;
	</cfscript>
 
    <cfif VAL(FORM.submitted)>      	
	
	<cfscript>
		SESSION.FormErrors.clear();
			// Data Validation - Check required Fields
		   
			

			if ( LEN(FORM.email) AND NOT isValid("email", Trim(FORM.email)) ) {
				SESSION.formErrors.Add("email");
			}    
			
			if (  NOT LEN(FORM.fatherFirstName)  ) {
				SESSION.formErrors.Add("fatherFirstName");
			}
			
			if (  NOT LEN(FORM.fatherLastName)  ) {
				SESSION.formErrors.Add("fatherLastName");
			}

			if (NOT VAL(FORM.regionid) ) {
				SESSION.formErrors.Add("regionID");
			}
			
			if ( NOT LEN(FORM.sourceCode) ) {
				SESSION.formErrors.Add("source");
			}
			
			// Check for email address. 
			if ( NOT LEN(TRIM(FORM.email)) ) {
				//Get all the missing items in a list
				SESSION.formErrors.Add("email");
			}
			
			// Check for email address. 
			if ( LEN(TRIM(FORM.email)) AND NOT isValid("email", TRIM(FORM.email)) ) {
				//Get all the missing items in a list
				SESSION.formErrors.Add("email");
			}
        </cfscript>
    
          <!--- Check for duplicate accounts --->
		<cfif isValid("email", FORM.email)>
        	<!----Check if thte email is assocated with another account---->
        	<cfscript>
				if (VAL(FORM.hostID)) {
					qCheckEmail = APPLICATION.CFC.host.checkHostEmail(hostID=FORM.hostID,email=FORM.email,companyID=CLIENT.companyID);
				} else {
					qCheckEmail = APPLICATION.CFC.host.checkHostEmail(email=FORM.email,companyID=CLIENT.companyID);
				}
                // Check for email address. 
                if ( qCheckEmail.recordCount ) {
                    //Get all the missing items in a list
                    SESSION.formErrors.Add("email_found");
                    
                }
            </cfscript>
        </cfif>
        <Cfif len(form.address)>
            <!----Make sure the address isn't a duplicate to a family already hosting---->
			<Cfquery name="checkAddress" datasource="#APPLICATION.dsn#">
				SELECT email, hostID,
				   CAST( 
						CONCAT(                      
							IFNULL(h.fatherFirstName, ''),  
							IF(h.fatherLastName != h.motherLastName, ' ', ''), 
							IF(h.fatherLastName != h.motherLastName, h.fatherlastname, ''),
							IF(h.fatherFirstName != '', IF (h.motherFirstName != '', ' and ', ''), ''),
							IFNULL(h.motherFirstName, ''), 
							' ',
							h.familyLastName,
							' (##',
							h.hostID,
							')'                    
							) 
							AS CHAR) AS  displayHostFamily
				FROM smg_hosts h
				WHERE address = '#FORM.address#'
				AND city = '#FORM.city#'
			</Cfquery>
			<cfscript>
				// Check for matching address. 
				if ( checkAddress.recordCount ) {
					SESSION.formErrors.Add("address_found");
				}
			</cfscript>
        </Cfif>
    
 
	<!--- // Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
			<cfquery name="get_stateID" datasource="#APPLICATION.dsn#">
			select id
			from smg_states
			where state = '#FORM.state#'
			</cfquery>
			
			<Cfquery name="insertHostLead" datasource="#APPLICATION.dsn#">
				insert into smg_host_lead (
					hostid,
					firstname, 
					lastname, 
					<cfif len(form.address)>
					address,
					address2,
					city,
					<cfif len(form.state)>
					stateID,					
					</cfif>
					zipCode,
					</cfif>
					phone,
					email,
					contactWithRepName,
					hearAboutUs,
					arearepid,
					regionid,
					statusID,
					password,
					dateCreated,
					httpReferer,
					remoteAddress,
					companyid)
				values(
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherFirstName)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherLastName)#">,
                        <cfif len(form.address)>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
							<cfif len(FORM.state)>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_stateID.id#">,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLIENT.name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sourceCode#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#strPassword#">,
                       	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDRESS#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                        
				)
			</Cfquery>
						<!--- Insert HashID pick up any others that haven't been updated --->
					<cfquery 
						name="qGetHostNoHashID" 
						datasource="#APPLICATION.DSN#">
							SELECT
								ID
							FROM
								smg_host_lead
							WHERE
								hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
					</cfquery>

					
						<cfquery datasource="#APPLICATION.DSN#">
							UPDATE
								smg_host_lead
							SET
								hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.hashID(qGetHostNoHashID.ID)#">
							WHERE
								ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostNoHashID.ID#">
						</cfquery>
					
					
					<cfscript>
						// Update / Add History Host Lead
						APPLICATION.CFC.HOST.updateHostLead(
							ID=qGetHostNoHashID.ID,					
							followUpID=CLIENT.userid,
							regionID=FORM.regionID,
							areaRepID=CLIENT.userid,
							statusID=1,
							enteredByID=CLIENT.userID,
							comments='Lead manually added'					
						);
					</cfscript>
               <script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 100);
            </script>
		</cfif>
	</cfif>

	<div class="wrapper">
		<!--=== Breadcrumbs ===-->
		
		<div class="tab-v2 margin-bottom-40">
							
	
	<div class="row">

		
	</div>	
		<!--=== End Breadcrumbs ===-->

		<!--=== Content Part ===-->
		<div class="">
			<div class="row">
				<cfoutput>
	

				<!-- Begin Content --> 
				<div class="col-md-12 tab-pane fade in active">
					
					<!-- Checkout-Form -->
					<form name="hostFamilyInfo" id="hostFamilyInfo" action="new_lead.cfm" method="post" id="sky-form" class="sky-form">
					<Cfif val(#URL.skip#)>
					<input type="hidden" name="skip" value="1">
					</Cfif>
					<input type="hidden" name="submitted" value="1">
					<input type="hidden" name="areaRepID" value="#FORM.areaRepID#">
						<header>Add Host Lead</header>
						<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "email_found" )# or #arrayFind( #SESSION.formErrors.GetCollection()#, "address_found" )#>
							<fieldset 
								<section>
								<div class="alert alert-danger" role="alert">
									<p>
									It looks like there are host familie(s) that match information that you have entered.  For families that are already in EXITS, simply visit the profile page for that family and start a new application by clicking on the "Host <cfoutput>#vCurrentSeason#</cfoutput>" button.<br>
									<em>clicking a link below will open a new browser window</em>
									</p>
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "address_found" )#>
										<p>The following families share this address:<br>
											<cfloop query="#checkAddress#">
												<A href="../index.cfm?curdoc=host_fam_info&hostID=#hostid#" target="new">#displayHostFamily#</a><Br>
											</cfloop>
										</p>
									</cfif>
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "email_found" )#>
										<p>The following families share this email address:<br>
											<cfloop query="#qCheckEmail#">
												<A href="../index.cfm?curdoc=host_fam_info&hostID=#hostid#" target="new">#displayHostFamily#</A><Br>
											</cfloop>
										</p>
									</cfif>
									
								</div>
								</section>
							</fieldset>						
						</cfif>	
						<fieldset>
							<div class="row">
								<section class="col col-6">
									<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherFirstName" )#> state-error</cfif>">
										<i class="icon-prepend fa fa-user"></i>
										<input type="text" name="fatherFirstName" placeholder="First name" value="#FORM.fatherFirstName#">
									</label>
									<div class="note">Legal first name
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherFirstName" )#>
										is required
									</cfif>
									</div>
								</section>
							
								<section class="col col-6">
									<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherLastName" )#> state-error</cfif>">
										<i class="icon-prepend fa fa-user"></i>
										<input type="text" name="fatherLastName" placeholder="Last name"value="#FORM.fatherLastName#">
									</label>
									<div class="note">Legal last name
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherLastName" )#>
										is required
									</cfif>
									</div>
								</section>
							</div>
							<div class="row">
							
							<section class="col col-6">
								<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "email" )#> state-error</cfif> <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "email_found" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-envelope"></i>
									<input type="text" name="email" id="email" placeholder="Email" value="#FORM.email#">
								</label>
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "email" )#>
										<div class="note note-error">Enter a valid email</div>
									</cfif>
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "email_found" )#>
										<div class="note note-error">"The #qCheckEmail.displayHostFamily# family is already using this email address. </div>
									</cfif>	
							</section>
							<section class="col col-6">
							<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "father_cell" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-mobile-phone"></i>
								<input type="text" name="father_cell" id="father_cell" placeholder="Phone" value="#FORM.father_cell#">
							</label>
							<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "father_cell" )#>
								<div class="note note-error">Enter a valid phone number</div>
							</cfif>
							</section>
						</div>
						
						</fieldset>
					
						
						
						<header>Address</header>
						<fieldset>
						<div class="row">
							<section class="col col-10">
									<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "address" )#> state-error</cfif> <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "address_found" )#> state-error</cfif>">
									<i class="icon-prepend fa fa-map-marker"></i>
										<input type="text" id="address" name="address" placeholder="Address" value="#FORM.address#">
									</label>
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "address" )#>
									<div class="note note-error">Address is required</div>
									</cfif>
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "address_found" )#>
										<div class="note note-error">There is already an account registerd to the #checkAddress.displayHostFamily# family at this address.</div>
									</cfif>
							</section>
						</div>
						<div class="row">
							<section class="col col-10">
									<label for="file" class="input">
									<i class="icon-prepend fa fa-map-marker"></i>
										<input type="text" id="address2" name="address2" placeholder="Additional Address Information" value="#FORM.address2#">
									</label>
										
							</section>
						</div>
						<div class="row">
							<section class="col col-4">
								<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "city" )#> state-error</cfif> <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "address_found" )#> state-error</cfif>  ">
								<i class="icon-prepend fa fa-location-arrow"></i>
									<input type="text" name="city" id="city" placeholder="City" value="#FORM.city#">
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "city" )#>
								<div class="note note-error">City is required</div>
								</cfif>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "address_found" )#>
									<div class="note note-error">There is already an account registerd to the #checkAddress.displayHostFamily# family at this address.</div>
								</cfif>
							</section>
							<section class="col col-4">
								<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "state" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-location-arrow"></i>
									<input type="text" name="state" id="state" placeholder="State" value="#FORM.state#">
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "state" )#>
								<div class="note note-error">State is required</div>
								</cfif>
							</section>
							<section class="col col-4">
								<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "zip" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-location-arrow"></i>
									<input type="text" name="zip" id="zip" placeholder="Zip/Postal Code" value="#FORM.zip#">
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "birthday" )#>
								<div class="note note-error">Zip is required</div>
								</cfif>
							</section>
						</div>
						</fieldset>
					
					
						
						<header>Source & Region</header>
						<fieldset>
							<div class="row">
							
							<section class="col col-6">
								
								<label class="select <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "source" )#> state-error</cfif>">
								
									<select name="sourceCode">
										 <option value="">Select Source</option>
										 <option value="Church Group" <cfif FORM.sourceCode EQ "Church Group">selected</cfif>>Church Group</option>
										 <option value="Friend / Acquaintance" <cfif FORM.sourceCode EQ "Friend / Acquaintance">selected</cfif>>Friend / Acquaintance</option>
										 <option value="Facebook" <cfif FORM.sourceCode EQ "Facebook">selected</cfif>>Facebook</option>
										 <option value="Fair / Trade Show" <cfif FORM.sourceCode EQ "Fair / Trade Show">selected</cfif>>Fair / Trade Show</option> 
										 <option value="Google Search" <cfif FORM.sourceCode EQ "Google Search">selected</cfif>>Google Search</option>
										 <option value="Newspaper Ad" <cfif FORM.sourceCode EQ "Newspaper Ad">selected</cfif>>Newspaper Ad</option>
										 <option value="Past Host Family" <cfif FORM.sourceCode EQ "Past Host Family">selected</cfif>>Past Host Family</option>
										 <option value="Phone-A-Thon" <cfif FORM.sourceCode EQ "Phone-A-Thon">selected</cfif>>Phone-A-Thon</option>
										 <option value="Printed Material" <cfif FORM.sourceCode EQ "Printed Material">selected</cfif>>Printed Material</option>
										 <option value="Representative" <cfif FORM.sourceCode EQ "Representative" >selected</cfif>>Representative</option> 
										 <option value="Yahoo Search" <cfif FORM.sourceCode EQ "Yahoo Search">selected</cfif>>Yahoo Search</option> 
										 <option value="Other" <cfif FORM.sourceCode EQ "Other">selected</cfif>>Other</option> 
									</select>
								
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "source" )#>
								<div class="note note-error">Source is required</div>
								</cfif>
							</section>

							<section class="col col-6">
								
								<label class="select <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "regionID" )#> state-error</cfif>">
								
									<select name="regionid">
										 <cfif APPLICATION.CFC.USER.isOfficeUser()>
											<option value="">Select Region</option>
										</cfif>
										<cfloop query="qGetRegionList">
											<option value="#qGetRegionList.regionid#" <cfif FORM.regionid EQ qGetRegionList.regionid>selected</cfif>>#qGetRegionList.regionname#</option>
										</cfloop>
									</select>
								
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "regionid" )#>
								<div class="note note-error">Region is required</div>
								</cfif>
							</section>
						</div>
						</fieldset>	
					
						<fieldset>
							<section>
								<label class="textarea">
									<textarea rows="3" name="info" placeholder="Additional info"></textarea>
								</label>
							</section>
						</fieldset>
							
						<footer>
							<input type="submit" class="btn-u" value="Add Lead"></input>
						
						</footer>
					</form>
					<!-- End Checkout-Form -->
</cfoutput>
					<div class="margin-bottom-40"></div>

					
				</div>
				<!-- End Content -->
			</div>
		</div><!--/container-->
		<!--=== End Content Part ===-->
</div>

		<!--Smarty Streets-->
		<!--Smarty Streets-->
	<script src="//ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="//d79i1fxsrar4t.cloudfront.net/jquery.liveaddress/3.4/jquery.liveaddress.min.js"></script>
	<script> var liveaddress = jQuery.LiveAddress({
					key: '19728119051131453',
					autocomplete: 5,

					addresses: [{
						address1: '#address',
						address2: '#address2',	// Not all these fields are required
						locality: '#city',
						administrative_area: '#state',
						postal_code: '#zip'
					}]
				});
		</script>


			
		
	

	
		<!-- JS Global Compulsory -->
		<script type="text/javascript" src="assets/plugins/jquery/jquery.min.js"></script>
		<script type="text/javascript" src="assets/plugins/jquery/jquery-migrate.min.js"></script>
		<script type="text/javascript" src="assets/plugins/bootstrap/js/bootstrap.min.js"></script>
		<!-- JS Implementing Plugins -->
		<script type="text/javascript" src="assets/plugins/back-to-top.js"></script>
		<script type="text/javascript" src="assets/plugins/smoothScroll.js"></script>
		<script src="assets/plugins/sky-forms-pro/skyforms/js/jquery.validate.min.js"></script>
		<script src="assets/plugins/sky-forms-pro/skyforms/js/jquery.maskedinput.min.js"></script>
		<script src="assets/plugins/sky-forms-pro/skyforms/js/jquery-ui.min.js"></script>
		<script src="assets/plugins/sky-forms-pro/skyforms/js/jquery.form.min.js"></script>
		<!-- JS Customization -->
		<script type="text/javascript" src="assets/js/custom.js"></script>
		<!-- JS Page Level -->
		<script type="text/javascript" src="assets/js/app.js"></script>
		<script type="text/javascript" src="assets/js/forms/order.js"></script>
		<script type="text/javascript" src="assets/js/plugins/masking.js"></script>
		<script type="text/javascript" src="assets/js/forms/review.js"></script>
		<script type="text/javascript" src="assets/js/plugins/validation.js"></script>
		<script type="text/javascript" src="assets/js/plugins/datepicker.js"></script>
		<script type="text/javascript" src="assets/js/plugins/style-switcher.js"></script>
		<script type="text/javascript">
			jQuery(document).ready(function() {
				App.init();
				Masking.initMasking();
				Datepicker.initDatepicker();
				Validation.initValidation();
				StyleSwitcher.initStyleSwitcher();
			});
			
		

		</script>

	<!----clear errors so they don't show up if closed---->
	<cfscript>
		SESSION.FormErrors.clear();
	</cfscript>
	<!--[if lt IE 9]>
	<script src="assets/plugins/respond.js"></script>
	<script src="assets/plugins/html5shiv.js"></script>
	<script src="assets/plugins/placeholder-IE-fixes.js"></script>
	<script src="assets/plugins/sky-forms-pro/skyforms/js/sky-forms-ie8.js"></script>
	<![endif]-->

	<!--[if lt IE 10]>
	<script src="assets/plugins/sky-forms/version-2.0.1/js/jquery.placeholder.min.js"></script>
	<![endif]-->
</body>
</html>
