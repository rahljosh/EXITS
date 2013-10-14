<!--- ------------------------------------------------------------------------- ----
	
	File:		header.cfm
	Author:		Marcus Melo
	Date:		August 24, 2010
	Desc:		Applicaton Header

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param Variables --->
    <cfparam name="CLIENT.userID" default="0">
    <cfparam name="URL.ID" default="0">
	
    <!--- Quick Search Form --->
    <cfparam name="FORM.quickSearchAutoSuggestCandidateID" default="">
    <cfparam name="FORM.quickSearchCandidateUniqueID" default="">
    <cfparam name="FORM.quickSearchAutoSuggestHostCompID" default="">
    <cfparam name="FORM.quickSearchHostCompID" default="">
    <cfparam name="FORM.quickSearchAutoSuggestUserUniqueID" default="">
    <cfparam name="FORM.quickSearchUserUniqueID" default="">

    <cfscript>
		vQuickSearchNotFound = 0;
		
		// Quick Search Student 
        if ( LEN(FORM.quickSearchCandidateUniqueID) ) {
			Location("index.cfm?curdoc=candidate/candidate_info&uniqueid=#FORM.quickSearchCandidateUniqueID#", "no");
        }
		
		// Quick Search Host Company
        if ( VAL(FORM.quickSearchHostCompID) ) {
			Location("index.cfm?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#FORM.quickSearchHostCompID#", "no");
		}
		
		// Quick Search International Representative
		if ( LEN(FORM.quickSearchUserUniqueID) ) {
			Location("index.cfm?curdoc=intRep/intrep_info&uniqueID=#FORM.quickSearchUserUniqueID#", "no");
		}
			
	</cfscript>
    
    <cfscript>
		// SET LINKS
		link7 = '../trainee/index.cfm';
		link8 = '../wat/index.cfm';
		link9 = '../h2b/index.cfm';
	
		// SET CLIENT.COMPANYID
		if( VAL(URL.ID) ) {
			CLIENT.companyid = URL.ID;
		}
	</cfscript>

	<cfif NOT VAL(CLIENT.userid)>
        <cflocation url="../../index.cfm" addtoken="no">
    </cfif>

    <cfinclude template="querys/get_company.cfm">

    <cfquery name="qAlertMessages" datasource="mysql">
        SELECT 
        	*
        FROM
        	smg_news_messages
        WHERE
        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="alert">
        AND 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">            
        AND
        	expires > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        AND
        	startdate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        AND
        	lowest_level >= <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">
    </cfquery>
    
    <cfquery name="qUpdateMessages" datasource="mysql">
        SELECT 
        	*
        FROM 
        	smg_news_messages 
        WHERE 
        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="update">
        AND 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">            
        AND
        	expires > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        AND
        	startdate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        AND 
        	lowest_level >= <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">
    </cfquery>

    <!--- GET OTHER COMPANIES USER HAS ACCESS TO --->
    <cfquery name="qGetCompanyAccess" datasource="MySql">
        SELECT 
            uar.userid, uar.companyid, uar.usertype,
            c.companyshort
        FROM 
            user_access_rights uar
        INNER JOIN 
            smg_companies c ON c.companyid = uar.companyid
        WHERE 
            uar.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
        AND 
            c.system_id = <cfqueryparam cfsqltype="cf_sql_integer" value="4">
        AND
            uar.companyid != <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        GROUP BY 
            uar.companyid
        ORDER BY 
            c.companyshort	
    </cfquery>

</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta name="Author" content="CSB International">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>EXTRA - Exchange Training Abroad</title>
    <link rel="shortcut icon" href="../pics/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="../style.css" type="text/css">
    <link rel="stylesheet" href="../linked/css/onlineApplication.css" type="text/css">
    <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css">
    <link rel="stylesheet" href="../linked/css/datePicker.css" type="text/css">
    <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
    <link media="screen" rel="stylesheet" href="../linked/css/colorbox.css" /> <!-- Modal ColorBox -->
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/base/jquery-ui.css"/>
    <!-- Combine these into one single file -->
    <cfoutput>
    <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
    <script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
    <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
    </cfoutput>
    <script type="text/javascript" src="../linked/js/jquery.popupWindow.js"></script> <!-- Jquery PopUp Window -->
    <script type="text/javascript" src="../linked/js/jquery.validate.js"></script> <!-- jquery form validation -->
    <script type="text/javascript" src="../linked/js/jquery.metadata.js"></script> <!-- jquery form validation -->
    <script type="text/javascript" src="../linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
    <script type="text/javascript" src="../linked/js/basescript.js"></script> <!-- baseScript -->
</head>
<body>

<script type="text/javascript">
	// Avoid two selections on quick search
	var quickSearchValidation = function() {		
		$(".quickSearchField").val("");
	}
	
	$(function() {
		
		// Quick Search - Student Auto Suggest
		$("#quickSearchAutoSuggestCandidateID").autocomplete({

			source: function(request, response) {
				$.ajax({
					url: "../../extensions/components/candidate.cfc?method=remoteLookUpCandidate",
					dataType: "json",
					data: { 
						searchString: request.term
					},
					success: function(data) {
						response( $.map( data, function(item) {
							return {
								//label: item.DISPLAYNAME,
								value: item.DISPLAYNAME,
								valueID: item.UNIQUEID
							}
						}));
					}
				})
			},
			select: function(event, ui) {
				$("#quickSearchCandidateUniqueID").val(ui.item.valueID);
				$("#quickSearchForm").submit();
			},
			minLength: 2	

		});
		
		// Quick Search - Host Auto Suggest  
		$("#quickSearchAutoSuggestHostCompID").autocomplete({

			source: function(request, response) {
				$.ajax({
					url: "../../extensions/components/hostCompany.cfc?method=remoteLookUpHostComp",
					dataType: "json",
					data: { 
						searchString: request.term
					},
					success: function(data) {
						response( $.map( data, function(item) {
							return {
								//label: item.DISPLAYNAME,
								value: item.DISPLAYNAME,
								valueID: item.HOSTCOMPID
							}
						}));
					}
				})
			},
			select: function(event, ui) {
				$("#quickSearchHostCompID").val(ui.item.valueID);
				$("#quickSearchForm").submit();
			}, 
			minLength: 2
			
		});
		
		// Quick Search - User Auto Suggest
		$("#quickSearchAutoSuggestUserUniqueID").autocomplete({
														
			source: function(request, response) {
				$.ajax({
					url: "../../extensions/components/user.cfc?method=remoteLookUpUser",
					dataType: "json",
					data: { 
						searchString: request.term
					},
					success: function(data) {
						response( $.map( data, function(item) {
							return {
								//label: item.DISPLAYNAME,
								value: item.DISPLAYNAME,
								valueID: item.UNIQUEID
							}
						}));
					}
				})
			},
			select: function(event, ui) {
				$("#quickSearchUserUniqueID").val(ui.item.valueID);
				$("#quickSearchForm").submit();
			},
			minLength: 2	
			
		});
		
	});	
</script>

<cfoutput>

<table width="90%" border="0" align="center" bordercolor="##CCCCCC" bgcolor="##FFFFFF" style="padding-bottom:5px;">
    <Tr>
        <td width=98 rowspan=4 bordercolor="##FFFFFF" align="center">
            <a href="index.cfm?curdoc=initial_welcome"><img src="../pics/extra-logo.jpg" width="60" height="81" border="0"></a>
        </td>
    </tr>
    <tr>
        <td width="400" valign=top bordercolor="##FFFFFF" class="style1">
			<cfif qGetCompanyAccess.recordcount>
                <span class="style5" style="font-weight:bold;">
                	Choose another Program: &nbsp;
                    <!--- List Companies --->
                    <cfloop query="qGetCompanyAccess">
                        <a href="#Evaluate("link" & companyid)#?id=#companyid#" class="style4">#companyshort#</a>
                        <cfif qGetCompanyAccess.currentRow NEQ qGetCompanyAccess.recordcount>&nbsp; | &nbsp;</cfif>
                    </cfloop>
                </span>
            	<br><hr color="669966" size="1" width="385" align="left">
            </cfif>

			<strong>#get_company.companyshort# Program</strong>
			
            <span class="style5">Welcome back #CLIENT.firstname#! </span>
			
            [ <A href="index.cfm?curdoc=initial_welcome" class="style4"><b>Home</b></a> ] 
            [ <a href="../logout.cfm" class="style4"><b>Logout</b></a> ]
            
            <div style="margin-top:5px; font-size:0.9em;">
                <strong>Last Login:</strong> #DateFormat(CLIENT.lastlogin, 'mmm d, yyyy')#
                <strong>at</strong> #TimeFormat(CLIENT.lastlogin, 'h:mm tt')# 
            </div>
		</td>
        
		<!--- Update Messages --->
		<cfif qUpdateMessages.recordcount AND curdoc NEQ 'initial_welcome'>
            <td width="110px" valign="top" bordercolor="##FFFFFF" class="style1">
                <table bgcolor="##009966" width="100%">
                    <tr>
                        <td>
                            <span class="style5">
                                <font color="FFFFFF" style="font-weight:bold; text-decoration:underline;">System Updates:</font><br>
                                <cfloop query="qUpdateMessages">
                                    <font color="##FFFFFF"><b>#message#</b></font><br>
                                </cfloop>
                            </span>         
                        </td>
                    </tr>
                </table>
	        </td>
		</cfif>
        
        <!--- Alert Messages --->
        <cfif qAlertMessages.recordcount AND curdoc NEQ 'initial_welcome'>    
            <td width="110px" align="right" valign="top" bordercolor="##FFFFFF" class="style1">
                <table bgcolor="##CC3300" width="40%">
                    <tr>
                        <td>
                        	<font color="FFFFFF" style="font-weight:bold; text-decoration:underline;">Alerts:</font><br>
                            <cfloop query="qAlertMessages">
                                <font color="##FFFFFF"><b>#message#</b></font><br>
                            </cfloop>
                        </td>
                    </tr>
                </table>
            </td>
    	</cfif>
        
        <td align="right" valign="top" bordercolor="##FFFFFF" class="style5">
        
        	<table>
                <tr>
					<!--- Quick Search Options --->
                    <cfif listFind("1,2,3,4", CLIENT.userType)>
                	<td valign="top">
                        <cfform name="quickSearchForm" id="quickSearchForm" method="post" action="" style="margin:0px; padding:0px;">
                        
                           	<input type="hidden" name="quickSearchCandidateUniqueID" id="quickSearchCandidateUniqueID" value="#FORM.quickSearchCandidateUniqueID#" class="quickSearchField"/>
                           	<input type="hidden" name="quickSearchHostCompID" id="quickSearchHostCompID" value="#FORM.quickSearchHostCompID#" class="quickSearchField" />
                            <input type="hidden" name="quickSearchUserUniqueID" id="quickSearchUserUniqueID" value="#FORM.quickSearchUserUniqueID#" class="quickSearchField" />
                            <table width="700em" cellpadding="2" cellspacing="0" class="quickSearchTable" align="right">
                                <tr>
                                    <th colspan="6">
                                        Quick Search
                                        <!--- Display Error Messages Here ---> 
                                        <cfif VAL(vQuickSearchNotFound)>
                                            <span class="errors">record not found</span>	
                                        </cfif>
                                    </th>
                                </tr>
                                
                                <tr class="on">
                                
                                    <td class="subTitleRightNoBorderMiddle">
                                        Candidate:
                                    </td>
                                    <td>
                                        <input type="text" name="quickSearchAutoSuggestCandidateID" id="quickSearchAutoSuggestCandidateID" value="#FORM.quickSearchAutoSuggestCandidateID#" onclick="quickSearchValidation();" class="mediumField quickSearchField" maxlength="20" />
                                    </td>
                                                                  
                                    <td class="subTitleRightNoBorderMiddle">
                                        Host Company:
                                    </td>
                                    <td>
                                        <input type="text" name="quickSearchAutoSuggestHostCompID" id="quickSearchAutoSuggestHostCompID" value="#FORM.quickSearchAutoSuggestHostCompID#" onclick="quickSearchValidation();" class="mediumField quickSearchField" maxlength="20" />
                                    </td>
                                    
                                    <td class="subTitleRightNoBorderMiddle">
                                    	Intl. Rep.: 
                                    </td>
                                    <td><input type="text" name="quickSearchAutoSuggestUserUniqueID" id="quickSearchAutoSuggestUserUniqueID" value="#FORM.quickSearchAutoSuggestUserUniqueID#" onclick="quickSearchValidation();" class="mediumField quickSearchField" maxlength="20" /></td>
                    
                                </tr>
                                
                            </table>
                        </cfform> 
                	</td>
                    </cfif>
                </tr>
            </table>
            
        </td>
	</tr>
    <tr>
        <td colspan=4 valign="bottom" bordercolor="##FFFFFF">
        	<cfinclude template="menu.cfm">
        </td>
	</tr>
</table>

<script type="text/javascript">
    var ddmx = new DropDownMenuX('menu1');
    ddmx.delay.show = 0;
    ddmx.delay.hide = 400;
    ddmx.position.levelX.left = 2;
    ddmx.init();
</script>

</cfoutput>