
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
<Cfif isDefined('URL.close')>
	<script language="javascript">
		// Close Window After 1/5 Seconds
		setTimeout(function() { parent.$.fn.colorbox.close(); }, 15);
	</script>
	<cfabort></cfabort>
</Cfif>

<cfscript>
	// Get Current Paperwork Season ID
	vCurrentSeasonID = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
</cfscript>
<cfif isDefined('form.submitted')>	


	<cfset URL.hostAppID = #FORM.hostAppID#>
	<cfquery name="checkIfNote" datasource="#APPLICATION.dsn#">
		select * 
		from smg_notes
		where hostAppID = #URL.hostAppID# 
	</cfquery>
	<cfif checkIfNote.recordcount gt 0>
	<cfquery name="updateHostInfo" datasource="#APPLICATION.dsn#">
		update smg_notes
		set appNotes = concat(IFNULL(appNotes,''),"#form.notes# <br> #client.name# - #DateFormat(now(), 'mmmm d, yyyy')#<hr>")
		where hostAppID = #URL.hostAppID#
	</cfquery>
	<cfelse>
		<cfquery name="updateHostInfo" datasource="#APPLICATION.dsn#">
		insert into smg_notes(appNotes, hostAppID) 
		values("#form.notes# <br> #client.name# - #DateFormat(now(), 'mmmm d, yyyy')#<hr>",#URL.hostAppID#)
		</cfquery>
	</cfif>
</cfif>
<cfquery name="notes" datasource="MySQL">
Select appNotes
from smg_notes
where hostAppID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostAppID#"> 
</cfquery>



	<div class="container content">
		<div class="row">
			<!-- Begin Content -->
			<div class="col-md-12">
				<!-- Alert Tabs -->
				<div class="tab-v2 margin-bottom-40">
					 <div class="headline"><h2 class="heading-lg">Notes on Host Family</h2></div>
						<div class="row">
							
								<div class="col-sm-10">
									<div class="tag-box tag-box-v3">	

										<div class="row">
											<div class="col-sm-12">
												<div class="panel panel-default">
												  <div class="panel-heading">
													<h3 class="panel-title">Notes since the current status change</h3>
												  </div>
												  <div class="panel-body">
													<cfif notes.appNotes is ''>
														No notes yet
													<cfelse>
														<cfoutput>#notes.appNotes#</cfoutput>
														<br>
													</cfif>
													
													<br>
												  </div>
												</div>
											</div>
										</div>
										<cfform method="post" action="app-notes.cfm?hostAppID=#URL.hostAppID#">
										<div class="row">
											<div class="col-sm-12">
												<div class="panel panel-default">
												  <div class="panel-heading">
													<h3 class="panel-title">Add a note</h3>
												  </div>
												  <div class="form-group g-mb-25">
														<textarea name="notes" class="form-control form-control-md rounded-0" id="exampleTextarea" rows="6"></textarea>
													  </div>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-6">
												<A href="app-notes.cfm?close=1" class="btn btn-u btn-u-lg btn-u-orange"><i class="fa fa-times-circle-o" aria-hidden="true"></i> Close</p></a>
											</div>
											<div class="col-sm-6">
												<cfoutput>
														<input type="hidden" name="hostAppID" value=#URL.hostAppID#>
														<input type="hidden" name="existing" value=#NOTES.recordcount#>
														<input type="hidden" name="submitted" value=1>
														<p align=center><button type="submit" class="btn btn-u btn-u-lg "><i class="fa fa-cloud" aria-hidden="true"></i> Add Note</button></p>
													 
												</cfoutput>
											</div>	
										</div>	
										</cfform>
									</div>
								</div>
							</div>
						</div>
				</div>
			</div>
		</div>
				
				



