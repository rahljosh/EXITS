
<cfquery name="get_access" datasource="#application.dsn#">
    SELECT uar.id, uar.companyid, uar.regionid, uar.usertype, r.regionname, c.companyshort, c.team_id, ut.usertype AS usertypename
    FROM user_access_rights uar
    INNER JOIN smg_regions r ON uar.regionid = r.regionid
    	AND
        	r.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    INNER JOIN smg_companies c ON uar.companyid = c.companyid
    INNER JOIN smg_usertype ut ON uar.usertype = ut.usertypeid
    WHERE 
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            c.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>
    AND 
    	uar.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    ORDER BY uar.companyid, uar.regionid, uar.usertype
</cfquery>
<body>
	<div class="wrapper">
		<!--=== Header ===-->
		<div class="header">
			<div class="container">
				<!-- Logo -->
				<a class="logo" href="index.cfm">
					<img src="assets/img/logos/ise-eagle.png" alt="Logo">
				</a>
				<!-- End Logo -->

				<!-- Topbar -->
				<div class="topbar">
					<ul class="loginbar pull-right">
						<li><a href="page_faq.html"><i class="fa fa-home"></i>Home</a></li>
						<li class="topbar-devider"></li>
						<li class="hoverSelector">
							<i class="fa fa-globe"></i>
							<a>Access</a>
							<ul class="languages hoverSelectorBlock">
							<cfoutput query="get_access">
								<li <cfif client.companyid eq #companyid#> class="active"</cfif>>
									<a href="##">#team_id#<li <cfif client.companyid eq #companyid#><i class="fa fa-check"></i></cfif></a>
								</li>
								</cfoutput>
							</ul>
						</li>

						<li class="topbar-devider"></li>
						<li><a href="logout.cfm"><i class="fa fa-sign-out"></i> Logout</a></li>
					</ul>
				</div>
				<!-- End Topbar -->

				<!-- Toggle get grouped for better mobile display -->
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-responsive-collapse">
					<span class="sr-only">Toggle navigation</span>
					<span class="fa fa-bars"></span>
				</button>
				<!-- End Toggle -->
			</div><!--/end container-->

			<!-- Collect the nav links, forms, and other content for toggling -->
			<div class="collapse navbar-collapse mega-menu navbar-responsive-collapse">
				<div class="container">
					<ul class="nav navbar-nav">
						<!-- Students -->
						<li class="dropdown">
							<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">
								Students
							</a>
							<ul class="dropdown-menu">
								<li class="dropdown-submenu">
									<a href="javascript:void(0);"><i class="fa fa-list-ol"></i> List all..</a>
									<ul class="dropdown-menu">
										<li><a href="index.cfm?curdoc=students&Placed">Placed</a></li>
										<li><a href="index.cfm?curdoc=students&Uplaced">Unplaced</a></li>
										<li><a href="index.cfm?curdoc=app_process/apps_received">Received</a></li>
										<li><a href="index.cfm?curdoc=app_process/apps_received&hold">On Hold</a></li>
										<li><a href="index.cfm?curdoc=app_process/apps_received&denied">Denied</a></li>
										</li>
									</ul>
								</li>
								<li><a href="page_about2.html"><i class="fa fa-pie-chart"></i> Reports </a></li>
							</ul>
						</li>
						<!-- End Students -->

						<!-- Hosts -->
						<li class="dropdown active">
							<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">
								Hosts
							</a>
							<ul class="dropdown-menu">
								<li class="dropdown-submenu">
									<a href="javascript:void(0);"><i class="fa fa-list-ol"></i> List all..</a>
									<ul class="dropdown-menu">
										<li><a href="index.cfm?curdoc=host_fam&hosting">Hosting</a></li>
										<li><a href="index.cfm?curdoc=host_fam&notHosting">Not Hosting</a></li>
									</ul>
								</li>
								<li><a href="page_about2.html"><i class="fa fa-pie-chart"></i> Reports </a></li>
							</ul>
						</li>
						<!-- End Hosts -->
	
						<!-- Schools -->
						<li class="dropdown">
							<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">
								Schools
							</a>
							<ul class="dropdown-menu">	
								<li class="dropdown-submenu">
									<a href="javascript:void(0);"><i class="fa fa-list-ol"></i> List all..</a>
									<ul class="dropdown-menu">
										<li><a href="index.cfm?curdoc=schools&hosting">in your state</a></li>
										<li><a href="index.cfm?curdoc=schools&withFamily">assigned to families</a></li>
									</ul>
								</li>
								<li><a href="blog_timeline.html"><i class="fa fa-pie-chart"></i> Reports</a></li>
							</ul>
						</li>
						<!-- End Schools -->

						<!-- Users -->
						<li class="dropdown">
							<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">
								Users
							</a>
							<ul class="dropdown-menu">	
							<li><a href="index.cfm?curdoc=users"><i class="fa fa-list-ol"></i>  List all..</a></li>
							<li><cfoutput><a href="index.cfm?curdoc=user_info&userID=#CLIENT.userID#">
							<i class="fa fa-user-circle-o" ></i>My Info</a></cfoutput></li>
							<li><cfoutput><a href=""><i class="fa fa-pie-chart"></i> Reports</a></cfoutput></li>
							</ul>
						</li>
						<!-- End Portfolio -->

						<!-- Features -->
						<li class="dropdown">
							<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">
								Documents
							</a>
							<ul class="dropdown-menu">
								<!----<li class="dropdown-submenu">
									<a href="javascript:void(0);">Headers</a>
									<ul class="dropdown-menu">
										<li><a href="feature_header_default.html">Header Default</a></li>
										<li><a href="feature_header_default_no_topbar.html">Header Default without Topbar</a></li>
										<li><a href="feature_header_default_centered.html">Header Default Centered</a></li>
										<li><a href="feature_header_default_fixed.html">Header Default Fixed (Sticky)</a></li>
										<li><a href="feature_header_default_login_popup.html">Header Default Login Popup</a></li>
										<li><a href="feature_header_v1.html">Header v1</a></li>
										<li><a href="feature_header_v2.html">Header v2</a></li>
										<li><a href="feature_header_v3.html">Header v3</a></li>
										<li><a href="feature_header_v4.html">Header v4</a></li>
										<li><a href="feature_header_v4_logo_centered.html">Header v4 Centered Logo</a></li>
										<li><a href="feature_header_v5.html">Header v5</a></li>
										<li><a href="feature_header_v6_transparent.html">Header v6 Transparent</a></li>
										<li><a href="feature_header_v6_semi_dark_transparent.html">Header v6 Dark Transparent</a></li>
										<li><a href="feature_header_v6_semi_white_transparent.html">Header v6 White Transparent</a></li>
										<li><a href="feature_header_v6_border_bottom.html">Header v6 Border Bottom</a></li>
										<li><a href="feature_header_v6_classic_dark.html">Header v6 Classic Dark</a></li>
										<li><a href="feature_header_v6_classic_white.html">Header v6 Classic White</a></li>
										<li><a href="feature_header_v6_dark_dropdown.html">Header v6 Dark Dropdown</a></li>
										<li><a href="feature_header_v6_dark_scroll.html">Header v6 Dark on Scroll</a></li>
										<li><a href="feature_header_v6_dark_search.html">Header v6 Dark Search</a></li>
										<li><a href="feature_header_v6_dark_res_nav.html">Header v6 Dark in Responsive</a></li>
										<li><a href="page_home12.html">Header v7 Left Sidebar</a></li>
										<li><a href="page_home13.html">Header v7 Right Sidebar</a></li>
										<li><a href="feature_header_v8.html">Header v8</a></li>
									</ul>
								</li>
								<li class="dropdown-submenu">
									<a href="javascript:void(0);">Footers</a>
									<ul class="dropdown-menu">
										<li><a href="feature_footer_default.html#footer-default">Footer Default</a></li>
										<li><a href="feature_footer_v1.html#footer-v1">Footer v1</a></li>
										<li><a href="feature_footer_v2.html#footer-v2">Footer v2</a></li>
										<li><a href="feature_footer_v3.html#footer-v3">Footer v3</a></li>
										<li><a href="feature_footer_v4.html#footer-v4">Footer v4</a></li>
										<li><a href="feature_footer_v5.html#footer-v5">Footer v5</a></li>
										<li><a href="feature_footer_v6.html#footer-v6">Footer v6</a></li>
										<li><a href="feature_footer_v7.html#footer-v7">Footer v7</a></li>
										<li><a href="feature_footer_v8.html#footer-v8">Footer v8</a></li>
									</ul>
								</li>---->
								<li><a href="feature_gallery.html"><i class="fa fa-file-pdf-o"></i> DOS &amp; CSIET </a></li>
								<li><a href="feature_animations.html"><i class="fa fa-file-pdf-o"></i> Management Information</a></li>
								<li><a href="feature_parallax_counters.html"><i class="fa fa-file-pdf-o"></i> Payment Forms</a></li>
								<li><a href="feature_testimonials_quotes.html"><i class="fa fa-file-pdf-o"></i> Placement Information </a></li>
								<li><a href="feature_icon_blocks.html"><i class="fa fa-file-pdf-o"></i> Flyers, Ads, and Public Relations </a></li>
								<li><a href="feature_team_blocks.html"><i class="fa fa-file-pdf-o"></i> Convalidation</a></li>
								<li><a href="feature_news_blocks.html"><i class="fa fa-file-pdf-o"></i> Recruitment Information</a></li>
								<li><a href="feature_parallax_blocks.html"><i class="fa fa-file-pdf-o"></i> School Information</a></li>
								<li><a href="feature_funny_boxes.html"><i class="fa fa-file-pdf-o"></i> Student Services and Issues</a></li>
								<li><a href="feature_call_to_actions.html"><i class="fa fa-file-pdf-o"></i> Training Information</a></li>
								<li><a href="feature_call_to_actions.html"><i class="fa fa-file-pdf-o"></i> Representative Manuals</a></li>
								<li><a href="feature_call_to_actions.html"><i class="fa fa-file-pdf-o"></i> Host Family</a></li>
							</ul>
						</li>
						<!-- End Features -->

						<!-- Shortcodes -->
						<li class="dropdown mega-menu-fullwidth">
							<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">
								Reports
							</a>
							<ul class="dropdown-menu">
								<li>
									<div class="mega-menu-content disable-icons">
										<div class="container">
											<div class="row equal-height">
												<div class="col-md-3 equal-height-in">
													<ul class="list-unstyled equal-height-list">
														<li><h3>Students</h3></li>
														<li><a href="shortcode_typo_tagline_boxes.html"><i class="fa fa-file"></i> Compliance Paperwork by Region</a></li>
														<li><a href="shortcode_typo_boxshadows.html"><i class="fa fa-files-o"></i> Double Placement Paperwork by Region</a></li>
														<li><a href="shortcode_typo_testimonials.html"><i class="fa fa-files-o"></i> Double Placement Paperwork by Intl. Rep</a></li>
														<li><a href="shortcode_typo_headings.html"><i class="fa fa-plane"></i> Flight Information</a></li>
														<li><a href="shortcode_typo_dividers.html"><i class="fa fa-plus-circle"></i> Help Community Service</a></li>
														<li><a href="shortcode_typo_blockquote.html"><i class="fa fa-file-text-o"></i> Placement Paperwork by Region</a></li>
														<li><a href="shortcode_compo_labels.html"><i class="fa fa-flag-checkered"></i> Progress Reports</a></li>
														<li><a href="shortcode_compo_messages.html"><i class="fa fa-comment"></i> Relocation</a></li>
														<li><a href="shortcode_typo_grid.html"><i class="fa fa-comments"></i> Second Visit Compliance</a></li>
														<li><a href="../index.cfm?curdoc=report/studentManagement/_studentByRegion"><i class="fa fa-users"></i> Students by Region</a></li>
													</ul>
												</div>
												<div class="col-md-3 equal-height-in">
													<ul class="list-unstyled equal-height-list">
														<li><h3>Host Families</h3></li>
														<li><a href="shortcode_btn_general.html"><i class="fa fa-address-book-o"></i> CBC Authorization</a></li>
														<li><a href="shortcode_btn_brands.html"><i class="fa fa-list-ul"></i> Host Families List</a></li>
														<li><a href="shortcode_btn_effects.html"><i class="fa fa-list-ul"></i>Welcome Families List</a></li>
													</ul>
												</div>
												<div class="col-md-3 equal-height-in">
													<ul class="list-unstyled equal-height-list">
														<li><h3>Representatives</h3></li>
														<li><a href="shortcode_thumbnails.html"><i class="fa fa-sitemap"></i> Regional Hierarchy Report</a></li>
														<li><a href="shortcode_accordion_and_tabs.html"><i class="fa fa-exclamation-circle"></i> Missing Area Representative Paperwork</a></li>
														<li><a href="shortcode_timeline1.html"><i class="fa fa-map-marker"></i> Compliance Mileage Report</a></li>
														<li><a href="shortcode_timeline2.html"><i class="fa fa-graduation-cap"></i> User Training List</a></li>
														<li><a href="shortcode_table_general.html"><i class="fa fa-suitcase"></i> Incentive Trip Report</a></li>
													</ul>
												</div>
												<div class="col-md-3 equal-height-in">
													<ul class="list-unstyled equal-height-list">
														<li><h3>Office </h3></li>
														<li><a href="shortcode_form_general1.html"><i class="fa fa-list-alt"></i> Compliance Check Placement</a></li>
														<li><a href="shortcode_form_layouts_advanced.html"><i class="fa fa-list-alt"></i> Compliance Students per State/Country</a></li>
														<li><a href="shortcode_form_advanced.html"><i class="fa fa-certificate"></i> DOS Certification</a></li>
														<li><a href="shortcode_form_states.html"><i class="fa fa-arrows"></i> DOS Relocation</a></li>
														<li><a href="shortcode_form_sliders.html"><i class="fa fa-user-o"></i>Recruitment</a></li>
														<li><a href="shortcode_form_general.html"><i class="fa fa-futbol-o"></i> Region Goal</a></li>
														<li><a href="shortcode_form_layouts.html"><i class="fa fa-futbol-o"></i> Region Goal by Program</a></li>
														
														
													</ul>
												</div>
											</div>
										</div>
									</div>
								</li>
							</ul>
						</li>
						<!-- End Shortcodes -->

						<!-- Demo Pages -->
						<li class="dropdown mega-menu-fullwidth">
							<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">
								Tools
							</a>
							<ul class="dropdown-menu">
								<li>
									<div class="mega-menu-content disable-icons">
										<div class="container">
											<div class="row equal-height">
												<div class="col-md-3 equal-height-in">
													<ul class="list-unstyled equal-height-list">
														<cfif APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID,role="runCBC")>   
															<li><a href="index.cfm?curdoc=cbc/cbc_menu">CBC Batch</a></li>
														</cfif>
														<cfif CLIENT.userType EQ 1 OR CLIENT.userID EQ 17438 OR CLIENT.userID EQ 17095>
															<li><a href="index.cfm?curdoc=compliance/combine_hosts">Merge Host Family</a></li>   
														</cfif>
														<li><a href="index.cfm?curdoc=tools/countryMaintenance">Country Maintenance</a></li> 
						                				<li><a href="index.cfm?curdoc=tools/verification_received"><cfoutput>#CLIENT.DSFormName#</cfoutput> Verification List</a></li>
														<li><a href="index.cfm?curdoc=tools/importFLSID">FLS Import Tool</a></li>
														<li><a href="index.cfm?curdoc=tools/intlRepAllocation">International Rep. Allocation</a></li>
					                				    <li><a href="index.cfm?curdoc=insurance/index">Insurance</a>
													    <li><a href="index.cfm?curdoc=insurance/insurance_codes">Insurance Policy Codes</a></li>
						                				
													</ul>
												</div>

												<div class="col-md-3 equal-height-in">
													<ul class="list-unstyled equal-height-list">
														<li><a href="index.cfm?curdoc=tools/programs">Programs</a></li>
														<li><a href="index.cfm?curdoc=tools/progress_report_questions">PR Questions</a></li>
														<li><a href="index.cfm?curdoc=tools/receiveHostApp">Receive Apps</a></li>
														<li><a href="index.cfm?curdoc=tools/regions">Region Maintenance</a></li>
														<li><a href="One-Pages/Shipping/index.html">Shipping</a></li>
													</ul>
												</div>
												<div class="col-md-3 equal-height-in">
													<ul class="list-unstyled equal-height-list">
														 <cfif ListFind("1,2,3", CLIENT.userType)>
															<li><a href="index.cfm?curdoc=userPayment/index">Representative Payments</a>
															<li><a href="index.cfm?curdoc=userPayment/index&action=bonusReport">Bonus Report</a></li>
															<li><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=maintenance">Fee Maintenance</a></li>
															<li><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=potentialCredits">Potential Credits</a></li>
															<li><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=payReps">Pay Representatives</a></li>
															<li><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=checkSummary">Check Summary</a></li>
															<li><a href="#CGI.SCRIPT_NAME#?curdoc=tools/payment_type_report">Payment Reports </a></li>	
														</cfif>
													</ul>
												</div>
												<div class="col-md-3 equal-height-in">
													<ul class="list-unstyled equal-height-list">
														 <li><a href="index.cfm?curdoc=sevis/menu">SEVIS Batch</a>					
														<!--- SEVIS Dev Access --->
														<cfif CLIENT.usertype EQ 1>
																<li><a href="index.cfm?curdoc=sevis_test/menu">SEVIS Batch Dev</a></li>
														</cfif>					
														<li><a href="index.cfm?curdoc=forms/update_alerts">System Messages</a></li>
														<li><a href="index.cfm?curdoc=virtualFolder/globalSettings">Virtual Folder Options</a></li>
														<li><a href="index.cfm?curdoc=tools/smg_welcome_pictures">Welcome Pictures</a></li>
														<!--- This tool should only be visible to Tal Stanecky, Tom Policastro, Doug Camerlengo, Paul McLaughlin, James Griffiths, and Global Administrators --->
														<cfif ListFind("16718,13538,19422,18602,19159,17427,23345",CLIENT.userID) OR CLIENT.userType EQ 1>
															<li><a href="index.cfm?curdoc=tools/incentiveTripPoints">Incentive Trip Points</a></li>
														</cfif>
													</ul>
												</div>
											</div>
										</div>
									</div>
								</li>
							</ul>
						</li>
						<!-- End Demo Pages -->

						<!-- Search Block -->
						<li>
							<i class="search fa fa-search search-btn"></i>
							<div class="search-open">
								<div class="input-group animated fadeInDown" style="display: inline !important">
								<cfform name="quickSearchForm" id="quickSearchForm" method="post" action="/nsmg/index.cfm?curdoc=#URL.curdoc#" style="margin:0px; padding:0px;">
									<select name="quick_search_by" id="quick_search_by" class="form-control"  style="float:left; width:35%" onchange="cleanQuickSearch()">
										<option value="student">Student</option>
										<option value="host_family">Host Family</option>
										<option value="user">User</option>
										<option value="school">School</option>
									</select>

									<input type="text" name="quickSearchAutoSuggestID" id="quickSearchAutoSuggestID" value="" style="float:right; width:63%" maxlength="20" class="form-control" placeholder="Search" />
									
									<input type="hidden" name="quickSearchID" id="quickSearchID" value="#FORM.quickSearchID#" class="quickSearchField" />  
									</cfform>  
								</div>
							</div>
						</li>
						<!-- End Search Block -->
					</ul>
				</div><!--/end container-->
			</div><!--/navbar-collapse-->
		</div>
		<!--=== End Header ===-->
		

	
	