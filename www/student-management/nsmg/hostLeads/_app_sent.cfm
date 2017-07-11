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
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	  <cfscript>
		// check to make sure we have a valid companyID
		if ( NOT VAL(CLIENT.companyID) ) {
			CLIENT.companyID = 5;
		}	
		
		vQuickSearchNotFound = 0;
		
	
		
		// Quick Search Host Family
        if ( VAL(FORM.quickSearchHostID) ) {
			
			Location("?looked_up_host=#FORM.quickSearchHostID#&id=#FORM.leadid#", "no");
			
			/******* - No need to check if we have a valid record *******/
			/*
			// Create Object
			h = createObject("component","extensions.components.host");
			
            qQuickSearchHostFamily = h.getHosts(hostID=FORM.quickSearchHostID,companyID=CLIENT.companyID);
		
            // Host Found
            if ( qQuickSearchHostFamily.recordCount ) {
				Location("?curdoc=host_fam_info&hostID=#qQuickSearchHostFamily.hostID#", "no");
			// Host Not Found
			} else {
				vQuickSearchNotFound = 1;
			}
			*/
		
		}
		
	
		
	</cfscript>
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
			<cfif isDefined('form.assignCurrentHost')>
			 <cfquery datasource="#APPLICATION.DSN#">
					UPDATE
						smg_host_lead
					SET
						statusID = 14,
						<cfif VAL(qGetHostLead.regionID)>
						regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostLead.regionID)#">,
						</cfif>
						<cfif VAL(qGetHostLead.areaRepID)>
						areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostLead.areaRepID)#">,
						</cfif>
						dateConverted = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,

						hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostID)#">
					WHERE	                        
						ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostLead.ID#">
			 </cfquery>
			 <div class="row">
			 	<div class="col-md-8">
					<div class="panel panel-success">
					  <div class="panel-heading">
						<h3 class="panel-title">Success!</h3>
					  </div>
					  <div class="panel-body">
						The lead has been linked to the host family.<br>
						The lead status has been updated to "Converted to Host"
						<br>
					  </div>
					</div>
				 </div>
			  </div>
						
			<script language="javascript">
                // Close Window After 1/5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 1900);
            </script>
            <cfabort></cfabort>
			</cfif>

         <cfquery datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_host_lead
                SET
                    statusID = 14,
                    <cfif VAL(qGetHostLead.regionID)>
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostLead.regionID)#">,
		 			</cfif>
                    <cfif VAL(qGetHostLead.areaRepID)>
                    areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostLead.areaRepID)#">,
                    </cfif>
                    dateConverted = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,

                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostID)#">
                WHERE	                        
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostLead.ID#">
         </cfquery>
 		<cfif NOT val(FORM.current_host_active)>
			 <cfquery datasource="#APPLICATION.DSN#">
					UPDATE
						smg_hosts
					SET
						<cfif VAL(qGetHostLead.regionID)>
						regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostLead.regionID)#">,
						</cfif>
						<cfif VAL(qGetHostLead.areaRepID)>
						areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostLead.areaRepID)#">,
						</cfif>
						active = 1
					WHERE	                        
						 hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostID)#">
			</cfquery>
		</cfif>
			
				<script type="text/javascript" language="JavaScript">
			 	<cfoutput>
				  var #toScript(FORM.hostid, "hostID")#;
			  	</cfoutput>
	
			  $(function() {
				    if ('app' !== $('body').attr('id')) {
					window.open = ('../?curdoc=host_fam_info&hostid='+hostID+'','_blank');
				  }
				});
			</script>
			  <div class="row">
			 	<div class="col-md-8">
					<div class="panel panel-success">
					  <div class="panel-heading">
						<h3 class="panel-title">Success!</h3>
					  </div>
					  <div class="panel-body">
					  <cfoutput>
					  You lead was added and will show up in 'Initial - Please Contact' when the page is reloaded.
						</cfoutput>
						
						
						<br>
					  </div>
					</div>
				 </div>
			  </div>
											
			<script language="javascript">
                // Close Window After 1/5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 15);
            </script>
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
 
    	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.email#">  
    	
    	 
    	<cfif len(#qGetHostLead.address#)>
    	OR (address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.address#">
			and city =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.city#">)
		</cfif>
	</cfquery>
    
    <cfif isDefined('url.looked_up_host')>
    	<cfquery name="manual_host" datasource="#APPLICATION.dsn#">
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
    	HOSTID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.looked_up_host#">
    	</cfquery>
    	
    </cfif>

	

<body>

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
							 <div class="headline"><h2 class="heading-lg">Assign this lead to a host family</h2></div>
							<div class="row">
								<cfif checkHostAppExist.recordcount neq 0>	
									<div class="col-sm-10">
										<div class="tag-box tag-box-v3">	
									
									<div class="row">
										<div class="col-sm-12">
											<div class="panel panel-default">
											  <div class="panel-heading">
												<h3 class="panel-title">Are these two families the same?</h3>
											  </div>
											  <div class="panel-body">
												Based on the email address or street address and city enetered for this lead, a HF exists in the system.<br>
												Would you like to associate the lead with this host family?	
												<br>
											  </div>
											</div>
											</div>

									</div>

	
									<div class="row">
										<div class="col-sm-12">
											<div class="panel panel-default">

											  <div class="panel-body">
											  <div class="row">
											  	<div class="col-sm-6">
													<div class="panel panel-default">
													  <div class="panel-heading">
														<h3 class="panel-title">Your Lead Details</h3>
													  </div>
													  <div class="panel-body">
														<cfoutput>
															<div class="col-sm-10">
															<strong>#qGetHostLead.firstname# #qGetHostLead.lastname#</strong><br>
															<Cfif checkHostAppExist.address is #qGetHostLead.address#><mark></cfif>#qGetHostLead.address#<br>
															#qGetHostLead.city#</mark> #qGetHostLead.state#, #qGetHostLead.zipCode#<br>
															Email:<br>
																<Cfif checkHostAppExist.email is #qGetHostLead.email#><mark></cfif>#qGetHostLead.email#</mark>
															</div>
														</cfoutput>
														</ul>
													  </div>
													</div>
												</div>
												
												<div class="col-sm-6">
													<div class="panel panel-default">
													  <div class="panel-heading">
														<h3 class="panel-title">What we found</h3>
													  </div>
													  <div class="panel-body">
														<Cfif checkHostAppExist.recordcount gt 0>	
													<cfoutput>
														#checkHostAppExist.displayName# (#checkHostAppExist.hostid#)<br>
														<Cfif checkHostAppExist.address is #qGetHostLead.address#><mark></cfif>#checkHostAppExist.address#<br>
															#checkHostAppExist.city#</mark> #checkHostAppExist.state#, #checkHostAppExist.zip#<br>
															Email:<br>
														<Cfif checkHostAppExist.email is #qGetHostLead.email#><mark></cfif> #checkHostAppExist.email#</mark>
													</cfoutput>
													
													<cfelse>
													<div class="row">
														<div class="col-sm-2">
														<span class="fa-stack fa-2x">
														  <i class="fa fa-ban fa-stack-2x"></i>
														  <i class="fa fa-envelope fa-stack-1x"></i>
														</span>
													</div>
													<div class="col-sm-10">
														We didn't find any host families with the same email or home address address.
													</div>
													</div>
													
													</cfif>
													  </div>
													</div>
												</div>
												  </div>
													<div class="row">
														<div class="col-sm-6">
														
															<cfoutput>
																<cfform name="assignCurrentHost" action="convert_lead.cfm?leadID=#URL.id#&hostID=#checkHostAppExist.hostID#&key=#URL.key#&skip=1" method="post">
																	<input type="hidden" name="leadID" value="#url.id#">
																	<input type="hidden" name="hostID" value="#checkHostAppExist.hostID#">
																	<input type="hidden" name="dont_check" value=1>
																	<p align=center><button type="submit" class="btn btn-u btn-u-lg btn-u-orange"><i class="fa fa-random" aria-hidden="true"></i> NO, update email</button></p>
																</cfform>	 
															</cfoutput>
														</div>
														<div class="col-sm-6">
															<cfoutput>
																<cfform name="assignCurrentHost" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
																	<input type="hidden" name="leadID" value="#url.id#">
																	<input type="hidden" name="hostID" value="#checkHostAppExist.hostID#">
																	<input type="hidden" name="current_host_active" value="#checkHostAppExist.active#">
																	<input type="hidden" name="submitted" value=1>
																	<input type="hidden" name="checkHost" value=1>

																	<p align=center><button type="submit" class="btn btn-u btn-u-lg "><i class="fa fa-user-circle" aria-hidden="true"></i> YES, check HF Status</button></p>
																</cfform>	 
															</cfoutput>
														</div>	
													</div>	
												</cfif>
												
												
												</div>
										  </div>
										 
										 <cfif checkHostAppExist.recordcount eq 0>		
										<!----
										  <div class="row">
										<div class="col-sm-6">
											<div class="panel panel-default">
											  <div class="panel-heading">
												<h3 class="panel-title">Assign this lead to a current host family</h3>
											  </div>
											  <div class="panel-body">
												<p>We automatically check for matching email and stree addresses to help eliminate duplicate host families. A misspelling in an email or street address can result in zero results, even though we do in fact already have this lead in the system as a host family. </p>
												<br>
											  </div>
											</div>
											</div>
											
											
											<div class="col-sm-6">
								
												<div class="panel panel-default">
												  <div class="panel-heading">
													<h3 class="panel-title">Your Lead Details</h3>
												  </div>
												  <div class="panel-body">
													<cfoutput>
														<div class="col-sm-10">
														<strong>#qGetHostLead.firstname# #qGetHostLead.lastname#</strong><br>
														<mark>#qGetHostLead.address#<br>
														#qGetHostLead.city#</mark> #qGetHostLead.state#, #qGetHostLead.zipCode#<br>
														Email:<br>
														<mark>#qGetHostLead.email#</mark>
														</div>
													</cfoutput>
													</ul>
												  </div>
												</div>
											</div>
											</div>
										 	---->			
										<div class="panel panel-default">
											  <div class="panel-heading">
												<h3 class="panel-title">Search for a family you know is this lead</h3>
											  </div>
												<div class="panel-body">
											 	
											
												
													<cfform name="quickSearchForm" id="quickSearchForm" method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
														<input type="hidden" name="manual_assign_host" value=1>
														<input type="hidden" name="quickSearchHostID" id="quickSearchHostID" value="#FORM.quickSearchHostID#" class="quickSearchField" /> 
														<input type="hidden" name="leadID" value="<cfoutput>#URL.ID#</cfoutput>">
														<input type="text" name="quickSearchAutoSuggestHostID" id="quickSearchAutoSuggestHostID"  onclick="quickSearchValidation();" maxlength="30" placeholder="Search by last name or ID number" class="form-control input-lg quickSearchField"/>
													</cfform>
													<br>

												 </div>
           								 		
							<cfif isDefined('url.looked_up_host')>
									<div class="row">
										<div class="col-sm-12">
											

											  <div class="panel-body">
											  	<div class="col-sm-6">
													<div class="panel panel-default">
													  <div class="panel-heading">
														<h3 class="panel-title">Your Lead Details</h3>
													  </div>
													  <div class="panel-body">
														<cfoutput>
															<div class="col-sm-10">
															<strong>#qGetHostLead.firstname# #qGetHostLead.lastname#</strong><br>
															<Cfif checkHostAppExist.address is #qGetHostLead.address#><mark></cfif>#qGetHostLead.address#<br>
															#qGetHostLead.city#</mark> #qGetHostLead.state#, #qGetHostLead.zipCode#<br>
															Email:<br>
																<Cfif checkHostAppExist.email is #qGetHostLead.email#><mark></cfif>#qGetHostLead.email#</mark>
															</div>
														</cfoutput>
														</ul>
													  </div>
													</div>
												</div>
												
												<div class="col-sm-6">
													<div class="panel panel-default">
													  <div class="panel-heading">
														<h3 class="panel-title">Chosen Host Family</h3>
													  </div>
													  <div class="panel-body">
														<Cfif manual_host.recordcount gt 0>	
													<cfoutput>
														#manual_host.displayName# (#manual_host.hostid#)<br>
														<Cfif manual_host.address is #qGetHostLead.address#><mark></cfif>#manual_host.address#<br>
															#manual_host.city#</mark> #manual_host.state#, #manual_host.zip#<br>
															Email:<br>
														<Cfif manual_host.email is #qGetHostLead.email#><mark></cfif> #manual_host.email#</mark>
													</cfoutput>
													
													<cfelse>
													<div class="row">
														<div class="col-sm-2">
														<span class="fa-stack fa-2x">
														  <i class="fa fa-ban fa-stack-2x"></i>
														  <i class="fa fa-envelope fa-stack-1x"></i>
														</span>
													</div>
													<div class="col-sm-10">
														We didn't find any host families based on the host ID/last name you entered.
													</div>
													</div>
													
													</cfif>
													  </div>
													</div>
												</div>
										
										</div>
									</div>
									<cfoutput>
										<cfform name="assignCurrentHost" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
													<input type="hidden" name="leadID" value="#url.id#">
													<input type="hidden" name="hostID" value="#manual_host.hostid#">
													<input type="hidden" name="current_host_active" value="#checkHostAppExist.active#">
													<input type="hidden" name="submitted" value=1>
													<input type="hidden" name="assignCurrentHost" value=1>
												
											<p align=center><button type="submit" class="btn btn-u btn-u-lg "><i class="fa fa-user-circle" aria-hidden="true"></i> Link lead to chosen host family</button></p>
												</cfform>	
											</cfoutput>
												</cfif> 

										
								</div>
							</div>
						</div>
					</cfif>
										 
										
				</div>

											
								</div>	
										
							</div>
							
										</div>
									 
								
						
					</div>
				</div>  


				  <!---- Live serach for host family  ---->


   