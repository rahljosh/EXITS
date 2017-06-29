

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param URL variables --->
	
    <cfparam name="URL.menu" default="">
    <cfparam name="URL.submenu" default="">
    <cfparam name="URL.action" default="">

    <!--- Quick Search Form --->
    <cfparam name="FORM.quickSearchAutoSuggestStudentID" default="">
    <cfparam name="FORM.quickSearchStudentID" default="">
    <cfparam name="FORM.quickSearchAutoSuggestUserID" default="">
    <cfparam name="FORM.quickSearchUserID" default="">
    <cfparam name="FORM.quickSearchAutoSuggestHostID" default="">
    <cfparam name="FORM.quickSearchHostID" default="">
    
    <cfparam name="client.alreadySawEmergency" default="0">

    <cfscript>
		// check to make sure we have a valid companyID
		if ( NOT VAL(CLIENT.companyID) ) {
			CLIENT.companyID = 5;
		}	
		
		vQuickSearchNotFound = 0;
		
		// Quick Search Student 
        if ( VAL(FORM.quickSearchStudentID) ) {
    		
			Location("index.cfm?curdoc=student_info&studentID=#FORM.quickSearchStudentID#", "no");
			
			/******* - No need to check if we have a valid record *******/
			/*
			// Create Object
			s = createObject("component","extensions.components.student");
			
            qQuickSearchStudent = s.getStudentByID(studentID=FORM.quickSearchStudentID,companyID=CLIENT.companyID,onlyApprovedApps=1);
        
            // Student Found
            if ( qQuickSearchStudent.recordCount ) {
                
                // Depending on usertype they see different student page
                switch ( CLIENT.usertype ) {
                    
                    case 9:
                        Location("index.cfm?curdoc=student_profile&uniqueID=#qQuickSearchStudent.uniqueID#", "no");
                        break;
                    
                    case 27: 
                        Location("index.cfm?curdoc=student/index&action=studentInformation&studentID=#qQuickSearchStudent.studentID#", "no");
                        break;
                    
                    default:
                        Location("index.cfm?curdoc=student_info&studentID=#qQuickSearchStudent.studentID#", "no");
                }				
            // Student Not Found
			} else {
				vQuickSearchNotFound = 1;	
			}	
			*/
        }
		
		// Quick Search Host Family
        if ( VAL(FORM.quickSearchHostID) ) {
			
			Location("?curdoc=host_fam_info&hostID=#FORM.quickSearchHostID#", "no");
			
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
		
		// Quick Search User
		if ( VAL(FORM.quickSearchUserID) ) {
			
			Location("?curdoc=user_info&userID=#FORM.quickSearchUserID#", "no");
			
			/******* - No need to check if we have a valid record *******/
			/*
			// Create Object
			u = createObject("component","extensions.components.user");
			
			qQuickSearchUser = u.getUsers(userID=FORM.quickSearchUserID,companyID=CLIENT.companyID);
			
			// User Found
			if ( qQuickSearchUser.recordCount ) {
				Location("?curdoc=user_info&userID=#qQuickSearchUser.userID#", "no");
			// Host Not Found
			} else {
				vQuickSearchNotFound = 1;
			}
			*/
			
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

	<cfif val(unify)>
		<cfinclude template="unify_css_include.cfm">
	</cfif>

   <!-- Remove the end item on the SMG.CSS for full bootstrap usage-->
    
    <link rel="stylesheet" href="smg.css" type="text/css">
    <link rel="stylesheet" href="linked/css/baseStyle.css" type="text/css"> <!-- BaseStyle -->
    <link media="screen" rel="stylesheet" href="linked/css/colorbox.css" /> <!-- Modal ColorBox -->
    <link media="screen" rel="stylesheet" href="linked/css/buttons.css" /> <!-- Css Buttons -->
    <link media="screen" rel="stylesheet" href="assets/css/custom.css" />
    <!-- Overrides to Bootstrap use assets/css/custom.css-->

  	<cfif VAL(includebootstrap)>
  		<link rel="stylesheet" href="assets/css/bootstrap.min.css">
			<link rel="stylesheet" href="assets/css/style.css">
			<cfoutput>
			<link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet -->
				<!----Jquery fixing josh---->
				<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
				<script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
				<script type="text/javascript" src="linked/js/jquery.tools.min.js"></script> 
			</cfoutput>
  		<!-- JS Global Compulsory -->
<!----
			<script type="text/javascript" src="/nsmg/assets/plugins/jquery/jquery.min.js"></script>
			<script type="text/javascript" src="/nsmg/assets/plugins/jquery/jquery-migrate.min.js"></script>
---->
			<script type="text/javascript" src="/nsmg/assets/plugins/bootstrap/js/bootstrap.min.js"></script>

			
			<script type="text/javascript" src="/nsmg/assets/js/plugins/style-switcher.js"></script>
			<!-- CSS Customization -->
			<link rel="stylesheet" href="assets/css/custom.css">
<!----			<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>---->
  	<cfelse>

  		<cfoutput>
				<link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
				<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
				<script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
			</cfoutput> 
		
			<script type="text/javascript" src="linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
			<script type="text/javascript" src="linked/js/jquery.cfjs.js"></script> <!-- Coldfusion functions for jquery -->
  		<script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

  	</cfif>

  	

<!-- Latest compiled and minified JavaScript -->

<!----	   
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
---->
<script src="//d79i1fxsrar4t.cloudfront.net/jquery.liveaddress/3.2/jquery.liveaddress.min.js"></script>
  <script>
		$('.dropdown-toggle').dropdown();
  </script>
    
</head>
<body>
<!----<cfinclude template="analytics.cfm">---->
<script type="text/javascript">
	// Avoid two selections on quick search
	var quickSearchValidation = function() {		
		$(".quickSearchField").val("");
	}
	
	$(function() {

		// Quick Search - Student Auto Suggest
		$("#quickSearchAutoSuggestStudentID").autocomplete({

			source: function(request, response) {
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
			},
			select: function(event, ui) {
				$("#quickSearchStudentID").val(ui.item.valueID);
				$("#quickSearchForm").submit();
			},
			minLength: 2	
			
		});

		// Quick Search - Host Auto Suggest  
		$("#quickSearchAutoSuggestHostID").autocomplete({

			source: function(request, response) {
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
			},
			select: function(event, ui) {
				$("#quickSearchHostID").val(ui.item.valueID);
				$("#quickSearchForm").submit();
			}, 
			minLength: 2
			
		});
		
		// Quick Search - User Auto Suggest
		$("#quickSearchAutoSuggestUserID").autocomplete({
														
			source: function(request, response) {
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
			},
			select: function(event, ui) {
				$("#quickSearchUserID").val(ui.item.valueID);
				$("#quickSearchForm").submit();
			},
			minLength: 2	
			
		});
		
	});	
</script>
<Cfif 1 eq 2>
	<cfinclude template="includes/_unify-header.cfm">
<cfelse>
	<cfinclude template="includes/_classic-header.cfm">
</Cfif>

