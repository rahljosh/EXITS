<!--- ------------------------------------------------------------------------- ----
	
	File:		_detail.cfm
	Author:		Marcus Melo
	Date:		December 11, 2009
	Desc:		ISEUSA.com Host Family Leads

	Updated:	11/08/2011 - Ability to assign a lead to a follow up user
	
				02/01/2011 - Ability to assign a host lead to a region/area rep
				and enter status
				
				Office User  	Assign a region (required)
								Update status and comments (optional)
				Regional Man.	Assign an Area Representative (required)
								Update status and comments (optional)
				Area Rep.    	Update status and comments (optional)																	
				
----- ------------------------------------------------------------------------- --->
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
	  <script type="text/javascript">
	   $(function() {
			   $("#datepicker").datepicker({ dateFormat: "yy-mm-dd" }).val()
	   });
	  </script>
		<!--Smarty Streets-->
	<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
		<script src="//d79i1fxsrar4t.cloudfront.net/jquery.liveaddress/3.2/jquery.liveaddress.min.js"></script>
		<script> var liveaddress = jQuery.LiveAddress({
					key: '19728119051131453',
					autocomplete: 5,
					metadata:[{
						latitude: '#latitdue',
						longitude: '#longitude'
					}],
					addresses: [{
						address1: '#address',
						address2: '#address2',	// Not all these fields are required
						locality: '#city',
						administrative_area: '#state',
						postal_code: '#zip'
					}]
				});
	</script>
	<script>
	$(document).ready(function(){
		$('.phone').mask('(000) 000-0000');
	}
	</script>
<!--- Kill Extra Output --->
<cfsilent>
		
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
	<cfscript>
		// Param URL Variables
		param name="URL.Key" type="string" default=0;
		param name="URL.app_sent" type="string" default=0;		
		try {
			param name="URL.ID" type="numeric" default=0;	
		} catch (any excpt) {
			URL.ID = 0;
		}
		
		// Param Form Variables
		param name="FORM.submitted" default=0;
		param name="FORM.hostLeadJNID" default=0;
		param name="FORM.followUpID" default=0;
		param name="FORM.companyID" default=0;
		param name="FORM.regionID" default=0;
		param name="FORM.areaRepID" default=0;
		param name="FORM.statusID" default=0;
		param name="FORM.comments" default='';
		param name="familyFound" default=1;
		param name="displayForm" default=1;
		param name="form.hostid" default=0;
		/* 
			Check to see if passed key is the correct hash for the record. 
			This will stop people from tampering with the URLs.
		*/
		if ( Compare(APPLICATION.CFC.UDF.HashID(URL.id), URL.key) ) {
			// Wrong Key - Display message to user
			familyFound=0;
			SESSION.formErrors.Add('Host Family Lead could not be found (hashID mismatch). Please try again.');
		} 

		// Get the given host family lead record
		qGetHostLead = APPLICATION.CFC.HOST.getHostLeadByID(ID=URL.ID);
		
		// Get Companies
		qGetCompanies = APPLICATION.CFC.COMPANY.getCompanies(companyIDList=APPLICATION.SETTINGS.COMPANYLIST.ISE);
		
		// Get List of Status
		qGetStatus = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='hostLeadStatus');
		
		//get status of app, if they have started filling it out.
		//this will only apply if they app was started from the host lead page.
		
		
		// Get History
		qGetHostLeadHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
			applicationID=APPLICATION.CONSTANTS.type.hostFamilyLead,
			foreignTable='smg_host_lead',
			foreignID=qGetHostLead.ID
		);
		
		// Follow Up User List
		qGetFollowUpUserList = APPLICATION.CFC.USER.getUsers(userType=26);
		
		// FORM SUBMITTED
		if ( FORM.submitted ) {
			 
			// Host Lead User is able to enter a comment only
			if ( CLIENT.userType NEQ 26 ) {
			
				// Data Validation - Allow adding comment only up to 3 times, after that region is required
				if ( NOT VAL(FORM.regionID) AND qGetHostLeadHistory.recordCount GT 3 ) {
					// Get all the missing items in a list
					SESSION.formErrors.Add('You must select a region');
				}			
	
				if ( NOT VAL(FORM.statusID) ) {
					// Get all the missing items in a list
					SESSION.formErrors.Add('You must select a status');
				}			
				
				if ( ListFind("3,8", FORM.statusID) AND NOT LEN(FORM.comments) ) {
					// Get all the missing items in a list
					SESSION.formErrors.Add('This is a final decision. Comments are required.');
				}			
				
				// Managers Must Assign an Area Representative
				if ( CLIENT.userType EQ 5 AND NOT VAL(FORM.areaRepID) ) {
					// Get all the missing items in a list
					SESSION.formErrors.Add('You must select an area representative');
				}
			
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Do Not Display Form
				displayForm = 0;
				
				// Update / Add History Host Lead
				APPLICATION.CFC.HOST.updateHostLead(
					ID=FORM.ID,					
					followUpID=FORM.followUpID,
					regionID=FORM.regionID,
					areaRepID=FORM.areaRepID,
					statusID=FORM.statusID,
					enteredByID=CLIENT.userID,
					comments=FORM.comments					
				);
				
				// Get the latest updates
				qGetHostLead = APPLICATION.CFC.HOST.getHostLeadByID(ID=URL.ID);

				// Get History
				qGetHostLeadHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
					applicationID=APPLICATION.CONSTANTS.type.hostFamilyLead,
					foreignTable='smg_host_lead',
					foreignID=qGetHostLead.ID
				);

				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				
				// Refresh Page
				// Location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no"); 

			}
			
		} else {			
			// Set FORM Values
			FORM.followUpID = qGetHostLead.followUpID;
			FORM.companyID = qGetHostLead.companyID;
			FORM.regionID = qGetHostLead.regionID;
			FORM.areaRepID = qGetHostLead.areaRepID;
			FORM.statusID = qGetHostLead.statusID;
			// FORM.comments = qGetHostLead.comments;
		}
	</cfscript>
    
    <cfquery name="checkHostAppExist" datasource="#application.dsn#">
    select *
    from smg_hosts
    where email =<cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.email#">
	</cfquery>
   
</cfsilent>



<Cfif val(qGetHostLead.hostid)>
    <cfquery name=qGetHostInfo datasource="#application.dsn#">
    select applicationSent
	from smg_hosts
	where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostLead.hostid#">
    </cfquery>
</Cfif>
    	<div class="container content">
				<div class="row">

					<!-- Begin Content -->
					<div class="col-md-12">
						<!-- Alert Tabs -->
						<div class="tab-v2 margin-bottom-40">
							 <div class="headline"><h2 class="heading-lg">Host Family Found</h2></div>
								<div class="row">
									<div class="col-sm-6">
										<div class="tag-box tag-box-v3">

											<h2>Already a host application</h2>
											<p>Based on the email address assocated with this lead, it looks like the <cfoutput>#checkHostAppExist.FamilyLastName# (#checkHostAppExist.hostid#</cfoutput>)</a> family is in our system.</p><br>
											<p>If this is correct we can just associate this lead with that family and remove it from your list.</p><br>
											<p><button type="button" class="btn btn-success">Associate with this Host Family</button></p>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="tag-box tag-box-v3">

											<h2>This isn't the right host?</h2>
											<p>If the <cfoutput> #checkHostAppExist.FamilyLastName# (#checkHostAppExist.hostid#)</cfoutput> </a> family is not the correct application for this lead, enter the Host ID for this application..</p><br>
											<p>This will associate this lead with that family and remove it from your list.</p><br>
											<p><button type="button" class="btn btn-success">Assign Different Application</button></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>  
	