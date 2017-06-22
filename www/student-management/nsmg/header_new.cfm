

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param URL variables --->
	
    <cfparam name="URL.menu" default="">
    <cfparam name="URL.submenu" default="">
    <cfparam name="URL.action" default="">

    <!--- Quick Search Form --->
    <cfparam name="FORM.quickSearchAutoSuggestID" default="">
    <cfparam name="FORM.quickSearchID" default="">
    <cfparam name="FORM.quick_search_by" default="">
    
    <cfparam name="client.alreadySawEmergency" default="0">

    <cfscript>
			// check to make sure we have a valid companyID
			if ( NOT VAL(CLIENT.companyID) ) {
				CLIENT.companyID = 5;
			}	

			if ( VAL(FORM.quickSearchID)) {

				if (FORM.quick_search_by == 'student') {
					Location("index.cfm?curdoc=student_info&studentID=#FORM.quickSearchID#", "no");	
				} else if (FORM.quick_search_by == 'host_family') {
					Location("?curdoc=host_fam_info&hostID=#FORM.quickSearchID#", "no");
				} else if (FORM.quick_search_by == 'user') {
					Location("?curdoc=user_info&userID=#FORM.quickSearchID#", "no");
				} else if (FORM.quick_search_by == 'school') {
					Location("?curdoc=school_info&schoolid=#FORM.quickSearchID#", "no");
				}

			}
		</cfscript>

	    <cfquery name="get_messages" datasource="#application.dsn#">
	        SELECT 
	        	*
	        FROM 
	        	smg_news_messages
	        WHERE 
	        	messagetype IN ('alert','update')
	        AND 
	        	expires > #now()# 
	        AND 
	        	startdate < #now()#
	        AND 
	        	lowest_level >= <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">
	        AND 
	          <cfif CLIENT.companyID EQ 10 or CLIENT.companyID EQ 11 or CLIENT.companyid EQ 13 or CLIENT.companyid EQ 14>
	          		companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
	          <cfelse>
	        	(
	            	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
	            OR 
	            	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
	            )
	            </cfif>
	        ORDER BY 
	        	startdate DESC
	        
	    </cfquery>
	    
	    <cfquery name="alert_messages" dbtype="query">
	        SELECT 
	        	*
	        FROM 
	        	get_messages
	        WHERE 
	        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="alert">
	    </cfquery>
	    
	    <cfquery name="update_messages" dbtype="query">
	        SELECT 
	        	*
	        FROM 
	        	get_messages 
	        WHERE 
	        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="update">
	    </cfquery>
	    <cfif client.usertype eq 8>
	        <cfquery name="checkEmergencyNumber" datasource="#application.dsn#">
	        select emergency_phone
	        from smg_users
	        where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
	        </cfquery>
	    </cfif>
	</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="en"> <!--<![endif]-->
<head>

<!--- ------------------------------------------------------------------------- ----
	
	Layout and CSS.  If Unify, modify what we load
				
----- ------------------------------------------------------------------------- --->
	
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
   <!-- Web Fonts -->
	<link rel='stylesheet' type='text/css' href='//fonts.googleapis.com/css?family=Open+Sans:400,300,600&amp;subset=cyrillic,latin'>

   <!-- Remove the end item on the SMG.CSS for full bootstrap usage-->
    
    <link rel="stylesheet" href="smg.css" type="text/css">
    <link rel="stylesheet" href="linked/css/baseStyle.css" type="text/css"> <!-- BaseStyle -->
    <link media="screen" rel="stylesheet" href="linked/css/colorbox.css" /> <!-- Modal ColorBox -->
    <link media="screen" rel="stylesheet" href="linked/css/buttons.css" /> <!-- Css Buttons -->
    <!-- Overrides to Bootstrap use assets/css/custom.css-->
    <cfoutput>
			<link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
			<!---
			<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
			<script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
		--->
		</cfoutput> 

		<!-- JS Global Compulsory -->
		<script type="text/javascript" src="/nsmg/assets/plugins/jquery/jquery.min.js"></script>
		<script type="text/javascript" src="/nsmg/assets/plugins/jquery/jquery-migrate.min.js"></script>
		<script type="text/javascript" src="/nsmg/assets/plugins/bootstrap/js/bootstrap.min.js"></script>
		<!-- JS Implementing Plugins -->
		<!---<script type="text/javascript" src="/nsmg/assets/plugins/back-to-top.js"></script>
		<script type="text/javascript" src="/nsmg/assets/plugins/smoothScroll.js"></script>--->
		<!-- JS Customization -->
		<script type="text/javascript" src="/nsmg/assets/js/custom.js"></script>
		<!-- JS Page Level -->
		<script type="text/javascript" src="/nsmg/assets/js/app.js"></script>
		<script type="text/javascript" src="/nsmg/assets/js/plugins/style-switcher.js"></script>

		<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

		<script type="text/javascript">
			jQuery(document).ready(function() {
				App.init();
				StyleSwitcher.initStyleSwitcher();

			});


		</script>
		<!---
		<script type="text/javascript" src="linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
		<script type="text/javascript" src="linked/js/jquery.cfjs.js"></script> <!-- Coldfusion functions for jquery -->
		<script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->
		--->

		<cfinclude template="unify_css_include.cfm">

<!-- Latest compiled and minified JavaScript -->

<!----	   
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
---->
<script src="//d79i1fxsrar4t.cloudfront.net/jquery.liveaddress/3.2/jquery.liveaddress.min.js"></script>
<script>
	//$('.dropdown-toggle').dropdown();
</script>

<style>
.ui-autocomplete {
	z-index: 999999;
}
</style>
    
</head>
<body>
<!----<cfinclude template="analytics.cfm">---->

<script type="text/javascript">
	// Avoid two selections on quick search
	var cleanQuickSearch = function() {		
		//$(".quickSearchField").val("");
		$("#quickSearchAutoSuggestID").val('');
		$("#quickSearchAutoSuggestID").focus();
	}
	
	$(function() {
		// Quick Search - Student Auto Suggest
		$("#quickSearchAutoSuggestID").autocomplete({

			source: function(request, response) {
				if ($('#quick_search_by').val() == 'student') {
					$.ajax({
						url: "extensions/components/student.cfc?method=remoteLookUpStudent",
						dataType: "json",
						data: { 
							searchString: request.term
						},
						success: function(data) {
							response( $.map( data, function(item) {
								return {
									//label: item.DISPLAYNAME,
									value: item.DISPLAYNAME,
									valueID: item.STUDENTID
								}
							}));
						}
					})

				} else if ($('#quick_search_by').val() == 'host_family') {
					$.ajax({
						url: "extensions/components/host.cfc?method=remoteLookUpHost",
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
				} else if ($('#quick_search_by').val() == 'user') {
					$.ajax({
						url: "extensions/components/user.cfc?method=remoteLookUpUser",
						dataType: "json",
						data: { 
							searchString: request.term
						},
						success: function(data) {
							response( $.map( data, function(item) {
								return {
									//label: item.DISPLAYNAME,
									value: item.DISPLAYNAME,
									valueID: item.USERID
								}
							}));
						}
					})
				} else if ($('#quick_search_by').val() == 'school') {
					$.ajax({
						url: "extensions/components/school.cfc?method=remoteLookUpSchool",
						dataType: "json",
						data: { 
							searchString: request.term
						},
						success: function(data) {
							response( $.map( data, function(item) {
								return {
									//label: item.DISPLAYNAME,
									value: item.DISPLAYNAME,
									valueID: item.SCHOOLID
								}
							}));
						}
					})
				}
				},

				select: function(event, ui) {
					$("#quickSearchID").val(ui.item.valueID);
					$("#quickSearchForm").submit();
				},
				minLength: 2
		});
		
	});	
</script>

<cfinclude template="includes/_unify-header.cfm">


