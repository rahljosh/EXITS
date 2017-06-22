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


		
<!--- Kill Extra Output --->


	<cfparam name="FORM.quickSearchAutoSuggestHostID" default="">
    <cfparam name="FORM.quickSearchHostID" default="">
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	


	<cfparam name="manual_assign_host" default=0>



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
					window.top.location.href = '../?curdoc=host_fam_info&hostid='+hostID;
				  }
				});
			</script>
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
    <cfif val(manual_assign_host)>
    	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.quicksearchhostid#">
    <Cfelse>
    	email =<cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.email#">
    </cfif>
  
	</cfquery>
		
	
<body>

<Cfif val(qGetHostLead.hostid)>
    <cfquery name=qGetHostInfo datasource="#application.dsn#">
    select applicationSent
	from smg_hosts
	where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostLead.hostid#">
    </cfquery>
</Cfif>
    	<div class="">
				<div class="row">
					<!-- Begin Content -->
					<div class="col-md-12">
						<!-- Alert Tabs -->
						<div class="tab-v2 margin-bottom-40">
							 <div class="headline"><h2 class="heading-lg">Hey! Existing Host Family information was found!</h2></div>
								<div class="row">
									<div class="col-sm-10">
										<div class="tag-box tag-box-v3">	
										<Cfif checkHostAppExist.recordcount gt 0 and  manual_assign_host eq 0 >	
											<h3>Are these two families the same?</h3>

<p>Based on the email address enetered in this lead, this HF exists in the system.</p>
<p>Two different HF cannot have the same email address.</p<br>
										<cfelseif val(manual_assign_host)>
											<p>Please review the details below that where returned based on your search on the <cfoutput>#checkHostAppExist.FamilyLastName# (#checkHostAppExist.hostid#</cfoutput>)</a> family.   </p><br>
										<cfelse>
			 								If doesn't look like we have a matching host family in the system for this lead. 
										</cfif>
				 							<div class="row">
				 							
												<div class="col-sm-6">
												<div class="heading heading-v4 margin-bottom-10">
														<h4>Lead Details</h4>
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
														<h4>Existing Host Family Details</h4>
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
											<!----
											<p>If you would like to associate this lead with a DIFFERENT family, please search there name or ID number here.</p><br>
											<cfform name="quickSearchForm" id="quickSearchForm" method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
												<input type="hidden" name="manual_assign_host" value=1>
												<input type="hidden" name="quickSearchHostID" id="quickSearchHostID" value="#FORM.quickSearchHostID#" class="quickSearchField" /> 
												<input type="text" name="quickSearchAutoSuggestHostID" id="quickSearchAutoSuggestHostID" value="#FORM.quickSearchAutoSuggestHostID#" onclick="quickSearchValidation();" maxlength="30" placeholder="Search by last name or ID number" class="form-control input-lg quickSearchField"/>
                							</cfform>
           									<br>
           									---->
												
												<br>
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
											</div>
										</div>
									
								
								</div>
							</div>
						</div>
					</div>
				</div>  


				  <!---- Live serach for host family  ---->


   