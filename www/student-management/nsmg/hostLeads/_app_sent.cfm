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


		
<!--- Kill Extra Output --->


	<cfparam name="FORM.quickSearchAutoSuggestHostID" default="">
    <cfparam name="FORM.quickSearchHostID" default="">
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
	<!-- JS Global Compulsory -->
	<cfoutput>
		<link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
		<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
		<script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->	
	</cfoutput>

	<cfparam name="manual_assign_host" default=0>
	<script type="text/javascript" src="../assets/plugins/bootstrap/js/bootstrap.min.js"></script>


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
	</cfscript>	
	
		<cfif val(FORM.submitted)>
	
			<cfscript>
				// FORM SUBMITTED
				// Update / Add History Host Lead
					APPLICATION.CFC.HOST.updateHostLead(
						ID=FORM.leadID,					
						followUpID=qGetHostLead.followUpID,
						regionID=qGetHostLead.regionID,
						areaRepID=qGetHostLead.areaRepID,
						statusID=14,
						enteredByID=CLIENT.userID,
						hostID = FORM.hostID,
						comments='Lead assigned to existing host application.'					
					);
					// Set Page Message
					SESSION.pageMessages.Add("Lead succesfully assocaited with host.");

					// Refresh Page
					// Location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no"); 
			</cfscript>
			<script language="javascript">
                // Close Window After 1/5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
            </script>
            
            <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="95%"
            />
            <cfabort></cfabort>
		<cfelse>
			<Cfscript>
				// Set FORM Values
			FORM.followUpID = qGetHostLead.followUpID;
			FORM.companyID = qGetHostLead.companyID;
			FORM.regionID = qGetHostLead.regionID;
			FORM.areaRepID = qGetHostLead.areaRepID;
			FORM.statusID = qGetHostLead.statusID;
			// FORM.comments = qGetHostLead.comments;	
			</Cfscript>
		
		</cfif>
		
		<Cfscript>
		// search
		vQuickSearchNotFound = 0;
		</Cfscript>
		
 
    <cfquery name="checkHostAppExist" datasource="#application.dsn#">
    select *,
    CAST( 
			CONCAT(                      
				IFNULL(h.fatherFirstName, ''),  
				IF(h.fatherLastName != h.motherLastName, ' ', ''), 
				IF(h.fatherLastName != h.motherLastName, h.fatherlastname, ''),
				IF(h.fatherFirstName != '', IF (h.motherFirstName != '', ' and ', ''), ''),
				IFNULL(h.motherFirstName, ''), 
				' ',
				h.familyLastName
				) 
		AS CHAR) AS displayName
    from smg_hosts h
    where 
    <cfif val(manual_assign_host)>
    	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.quicksearchhostid#">
    <Cfelse>
    	email =<cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.email#">
    </cfif>
  
	</cfquery>
   
<body>
<!----<cfinclude template="analytics.cfm">---->
<script type="text/javascript">
	// Avoid two selections on quick search
	var quickSearchValidation = function() {		
		$(".quickSearchField").val("");
	}
	
	$(function() {

		// Quick Search - Host Auto Suggest  
		$("#quickSearchAutoSuggestHostID").autocomplete({

			source: function(request, response) {
				$.ajax({
					url: "../extensions/components/host.cfc?method=remoteLookUpHost",
					dataType: "json",
					data: { 
						searchString: request.term
					},
					success: function(data) {
						response( $.map( data, function(item) {
							return {
								//label: item.DISPLAYNAME,
								value: item.DISPLAYNAME,
								valueID: item.HOSTID
							}
						}));
					}
				})
			},
			select: function(event, ui) {
				$("#quickSearchHostID").val(ui.item.valueID);
				$("#quickSearchForm").submit();
			}, 
			minLength: 2
			
		});
		
	
		
	});	
</script>

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
							 <div class="headline"><h2 class="heading-lg">Assign to Current Host Family</h2></div>
								<div class="row">
								
									<div class="col-sm-10">
										<div class="tag-box tag-box-v3">
										
										
											<h2>Host Family Match</h2>
										<Cfif checkHostAppExist.recordcount gt 0 and  manual_assign_host eq 0 >	
											<p>Based on the email address assocated with this lead, it looks like the email address is already associtaed with the <cfoutput>#checkHostAppExist.FamilyLastName# (#checkHostAppExist.hostid#</cfoutput>)</a> family.</p><br>
										<cfelseif val(manual_assign_host)>
											<p>Please review the details below that where returned based on your search on the <cfoutput>#checkHostAppExist.FamilyLastName# (#checkHostAppExist.hostid#</cfoutput>)</a> family.   </p><br>
										<cfelse>
			 								If doesn't look like we have a matching host family in the system for this lead. 
										</cfif>
				 							<div class="row">
				 							
												<div class="col-sm-6">
												<div class="heading heading-v4 margin-bottom-10">
														<h5>Lead Details</h5>
														</div>
													<div class="tag-box tag-box-v4">
														
													<cfoutput>
														#qGetHostLead.firstname# #qGetHostLead.lastname#<br>
														#qGetHostLead.address#<br>
														#qGetHostLead.city# #qGetHostLead.state#, #qGetHostLead.zipCode#<br>
														#qGetHostLead.email#
													</cfoutput>
													</div>
												</div>
									
												<div class="col-sm-6">
												<div class="heading heading-v4 margin-bottom-10">
														<h5>Host Family Details</h5>
														</div>
													<div class="tag-box tag-box-v4">
													<Cfif checkHostAppExist.recordcount gt 0>	
													<cfoutput>
														#checkHostAppExist.displayName#<br>
														#checkHostAppExist.address#<br>
														#checkHostAppExist.city# #checkHostAppExist.state#, #checkHostAppExist.zip#<br>
														#checkHostAppExist.email#
													</cfoutput>
													<cfelse>
													<div class="row">
														<div class="col-sm-2">
														<span class="fa-stack fa-2x">
														  <i class="fa fa-ban fa-stack-2x"></i>
														  <i class="fa fa-users fa-stack-1x"></i>
														</span>
													</div>
													<div class="col-sm-10">
														No suggestsions, please search below.
													</div>
													</div>
													
													</cfif>
													</div>
												</div>
											</div>
												<cfoutput>
												
											
											
											
											<p>If you would like to associate LEAD Deatails with Host Family Information, click the button below.</p><br>
											<!----
											<p>If you would like to associate this lead with a DIFFERENT family, please search there name or ID number here.</p><br>
											<cfform name="quickSearchForm" id="quickSearchForm" method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
												<input type="hidden" name="manual_assign_host" value=1>
												<input type="hidden" name="quickSearchHostID" id="quickSearchHostID" value="#FORM.quickSearchHostID#" class="quickSearchField" /> 
												<input type="text" name="quickSearchAutoSuggestHostID" id="quickSearchAutoSuggestHostID" value="#FORM.quickSearchAutoSuggestHostID#" onclick="quickSearchValidation();" maxlength="30" placeholder="Search by last name or ID number" class="form-control input-lg quickSearchField"/>
                							</cfform>
           									<br>
           									---->
											<p>Once you associate this lead with a family, the family will be  removed from your list.</p><br>
											
											
											<cfform name="assignCurrentHost" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="defaultForm">
													<input type="hidden" name="leadID" value="#url.id#">
													<input type="hidden" name="hostID" value="#checkHostAppExist.hostID#">
													<input type="hidden" name="submitted" value=1>
													
													<p align=center><button type="submit" class="btn btn-u">Associate Lead with Host</button></p>
											</cfform>	 
											
											</cfoutput>
											
											</div>
										</div>
									
								
								</div>
							</div>
						</div>
					</div>
				</div>  
			
				  <!---- Live serach for host family  ---->


   