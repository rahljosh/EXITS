<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param URL variables --->
	<cfparam name="URL.curdoc" default="initial_welcome">
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
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>EXITS</title>
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="smg.css" type="text/css">
    <link rel="stylesheet" href="linked/css/baseStyle.css" type="text/css"> <!-- BaseStyle -->
    <link media="screen" rel="stylesheet" href="linked/css/colorbox.css" /> <!-- Modal ColorBox -->
    <link media="screen" rel="stylesheet" href="linked/css/buttons.css" /> <!-- Css Buttons -->
    <cfoutput>
		<link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
    	<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
		<script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
	</cfoutput>        
	<script type="text/javascript" src="linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
	<script type="text/javascript" src="linked/js/jquery.cfjs.js"></script> <!-- Coldfusion functions for jquery -->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->
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

<cfoutput>

<table width="100%" bgcolor="##FFFFFF" cellpadding="0" cellspacing="0" border="0" <cfif APPLICATION.isServerLocal> background="pics/development.jpg" </cfif> >
	<tr>
		<td valign="top">
            <table>
                <tr> 
                    <td>
                    <div style="font: bold Arial,sans-serif; margin:0px; padding: 2px;" >
                    	<font style="font: 150%">#CLIENT.companyname#</font> <img src="pics/logos/#CLIENT.companyid#_header_icon.png"><br>
                        Program Manager is #CLIENT.programmanager#<br>
                        #CLIENT.accesslevelname#
						<cfif CLIENT.levels GT 1>
                        	[ <a href="index.cfm?curdoc=forms/change_access_level" title="You have access to multiple regions, click here to change your access">Change Access</a> ]
                        </cfif>
                    </div>
                    <div style="padding: 2px;">
						#CLIENT.name# [ <a href="index.cfm" title="Click here to go to your home page">Home</a> ] [ <a href="index.cfm?curdoc=logout" title="Click here to logout">Logout</a> ]
                    </div>
                    </td>
                </tr>
            </table>
		</td>
        
   		<!----
		<td align="left">
		<cfinclude template="tools/region_access.cfm">
		</td>
		---->

		<cfif not isDefined('url.novelaro')>
        
            <cfif CLIENT.usertype EQ 8>
                <td>		
                   <!----
				    <!-- http://www.LiveZilla.net Chat Button Link Code -->
                    <a href="javascript:void(window.open('http://www.exitsapplication.com/livezilla/livezilla.php','','width=600,height=600,left=0,top=0,resizable=yes,menubar=no,location=yes,status=yes,scrollbars=yes'))"><img src="http://www.exitsapplication.com/livezilla/image.php?id=04" width="128" height="42" border="0" alt="LiveZilla Live Help"></a>
                    <noscript><div></div></noscript>
                    <!-- http://www.LiveZilla.net Chat Button Link Code --><!-- http://www.LiveZilla.net Tracking Code -->
                    <div id="livezilla_tracking" style="display:none"></div>
					<script language="JavaScript" type="text/javascript">var script = document.createElement("script");script.type="text/javascript";var src = "http://www.exitsapplication.com/livezilla/server.php?request=track&output=jcrpt&nse="+Math.random();setTimeout("script.src=src;document.getElementById('livezilla_tracking').appendChild(script)",1);</script>
                    <!-- http://www.LiveZilla.net Tracking Code -->
					---->
				</td>
			<!----
			<cfelse>		
				<td>	
					<!-- http://www.LiveZilla.net Tracking Code --><div id="livezilla_tracking" style="display:none"></div><script language="JavaScript" type="text/javascript">var script = document.createElement("script");script.type="text/javascript";var src = "http://www.exitsapplication.com/livezilla/server.php?request=track&output=jcrpt&nse="+Math.random();setTimeout("script.src=src;document.getElementById('livezilla_tracking').appendChild(script)",1);</script><!-- http://www.LiveZilla.net Tracking Code -->      
				</td>
			---->
            </cfif> 
            
        </cfif>
		
		<td valign="top">
            <u>Site Stats</u><br />
			<cfif listFind("1,2,3,4", CLIENT.userType)>
            	<a href="?curdoc=trackman">Users Online: #structcount(Application.Online)#</a>
            <cfelse>
            	Users Online: #structcount(Application.Online)#
            </cfif>
		</td>
		
		<cfif alert_messages.recordcount>
			<td bgcolor="##cc0000" valign="top">
                <div class="alerts"> 
                <h3>Alerts & Notifications</h3> 
                <cfloop query="alert_messages">
                    <a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#alert_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="white">#alert_messages.message#</font></a><br />
                </cfloop>
				</div>
			</td>
        </cfif>
		
		<cfif update_messages.recordcount>
			<td bgcolor="##005b01" valign="top">
                <div class="updates">
                <h3>System Updates</h3>
                <cfloop query="update_messages">
                	<a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#update_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="white">#message#</font></a><br />
                </cfloop>
                </div>
			</td>
		</cfif>

        <!--- Quick Search Options --->
		<cfif listFind("1,2,3,4", CLIENT.userType)>
            <td valign="top">
                <cfform name="quickSearchForm" id="quickSearchForm" method="post" action="" style="margin:0px; padding:0px;">
                
                	<input type="hidden" name="quickSearchStudentID" id="quickSearchStudentID" value="#FORM.quickSearchStudentID#" class="quickSearchField" />
                    <input type="hidden" name="quickSearchHostID" id="quickSearchHostID" value="#FORM.quickSearchHostID#" class="quickSearchField" /> 
                    <input type="hidden" name="quickSearchUserID" id="quickSearchUserID" value="#FORM.quickSearchUserID#" class="quickSearchField" />                
                
                    <table width="430px" cellpadding="2" cellspacing="0" class="quickSearchTable" align="right">
                        <tr>
                            <th colspan="4">
                                Quick Search
                                <!--- Display Error Messages Here ---> 
                                <cfif VAL(vQuickSearchNotFound)>
                                    <span class="errors">record not found</span>	
                                </cfif>
                            </th>
                        </tr>
                        <tr class="on">
                            <td class="subTitleRightNoBorderMiddle">Student: </td>
                            <td><input type="text" name="quickSearchAutoSuggestStudentID" id="quickSearchAutoSuggestStudentID" value="#FORM.quickSearchAutoSuggestStudentID#" onclick="quickSearchValidation();" class="mediumField quickSearchField" maxlength="20" /></td>
                            <td class="subTitleRightNoBorderMiddle">User: </td>
                            <td><input type="text" name="quickSearchAutoSuggestUserID" id="quickSearchAutoSuggestUserID" value="#FORM.quickSearchAutoSuggestUserID#" onclick="quickSearchValidation();" class="mediumField quickSearchField" maxlength="20" /></td>
                        </tr>
                        <tr class="on">
                            <td class="subTitleRightNoBorderMiddle">Host Family: </td>
                            <td><input type="text" name="quickSearchAutoSuggestHostID" id="quickSearchAutoSuggestHostID" value="#FORM.quickSearchAutoSuggestHostID#" onclick="quickSearchValidation();" class="mediumField quickSearchField" maxlength="20" /></td>
                            <td colspan="2" align="center"><span class="note">Type in ID ##, Name or Business Name</span></td>
                        </tr>
                    </table>
                </cfform> 
            </td>
        </cfif>
		
        <td width="130" align="right" rowspan="2" valign="top">
            <cfif CLIENT.usertype EQ 8 OR CLIENT.usertype EQ 11>
                <cfif CLIENT.usertype eq 11>
                    <cfquery name="get_intrep" datasource="#application.dsn#">
                        select intrepid
                        from smg_users
                        where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                    </cfquery>
                </cfif>
                <cfquery name="logo" datasource="#application.dsn#">
                    select logo
                    from smg_users 
                    <cfif CLIENT.usertype eq 11>
                    	where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_intrep.intrepid#">
                    <cfelse>
                    	where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                    </cfif>
                </cfquery>
                
				<cfif NOT LEN(logo.logo)>

                    <cfdirectory directory="#AppPath.companyLogo#" name="file" filter="#CLIENT.companyid#_header_logo.png">
                        <cfif file.recordcount>
                            <!--- SMG LOGO --->
                            <img src="pics/logos/#file.name#">
                       <cfelse>
                            <!--- SMG LOGO --->
                            <img src="pics/logos/exits.jpg">
                        </cfif>
                    <cfelse>
                        <!--- INTL. AGENT LOGO --->
                        <img src="pics/logos/#logo.logo#" height="71">
                    </cfif>
                    
                <cfelse>
                    <img src="pics/logos/#CLIENT.companyid#_header_logo.png">
                </cfif>
        </td>
    </tr>
    <tr height="10">
        <td colspan=8 valign="bottom" align="right"><img src="pics/logos/#CLIENT.companyid#_px.png" height=12 width="100%"></td>
    </tr>
</table>
<table width="100%" cellspacing="0" cellpadding="0" bgcolor="eeeeee">
	<tr> 
		<td>
           <cfinclude template="menu.cfm">
		</td>
	</tr>
</table>
<table width="100%" cellspacing="0" cellpadding="0">
	<tr> 
		<td><img src="pics/logos/#CLIENT.companyid#_px.png" width="100%" height="1"></td>
	</tr>
</table>
</cfoutput>
<br>
<!----Force emergency number---->
<cfif client.usertype eq 8 and not val(client.alreadySawEmergency)>
	
    <cfif checkEmergencyNumber.emergency_phone is  ''>
        <script language="javascript">
            // JQuery ColorBox Modal
            $(document).ready(function(){ 
                $.fn.colorbox( {href:'forms/emergencyNumber.cfm', iframe:true,width:'60%',height:'40%',onLoad: function() {  }} );
            });
			
			//$('#cboxClose').remove()  put this in the brackets of the function
			//escKey: false, overlayClose: false,  put this in the with other functions.
			
        </script>
    </cfif>
 
</cfif>
