<!--- ------------------------------------------------------------------------- ----
	
	File:		menu.cfm
	Author:		Marcus Melo
	Date:		March 17, 2010
	Desc:		Menu

	Updated:	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<cfscript>
		// Host Family Application
		allowedUsers = '1,510,12313,7203,1077,17071,17427';
		
        // Get Company Info
        qGetCompany = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
    </cfscript>

</cfsilent>

<!--- Only changing menu type for some users --->
<cfswitch expression="#CLIENT.userType#">

    <cfcase value="5,6,7,9">
		<script type="text/javascript">
			function clickHeader(header) {
				var elem = header.parentNode.getElementsByTagName('ul').item(0);
				if (hasClass(elem,"MenuBarSubmenuVisible")) {
					elem.className = elem.className.replace(/\bMenuBarSubmenuVisible\b/,'');
				} else {
					$(".MenuBarSubmenuVisible").removeClass("MenuBarSubmenuVisible");
					elem.className = elem.className + " MenuBarSubmenuVisible";
				}
			}
			
			function clickInnerMenu(section) {
				var elem = section.parentNode.getElementsByTagName('ul').item(0);
				if (hasClass(elem,"MenuBarSubmenuVisible")) {
					elem.className = elem.className.replace(/\bMenuBarSubmenuVisible\b/,'');
				} else {
					elem.className = elem.className + " MenuBarSubmenuVisible";
				}
			}
			
			function hasClass(element, cls) {
				return (' ' + element.className + ' ').indexOf(' ' + cls + ' ') > -1;
			}
		</script>
	</cfcase>
    
    <cfdefaultcase>
    	<script src="/nsmg/SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
    </cfdefaultcase>

</cfswitch>

<link href="/nsmg/SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />

<cfoutput>

<!--- Menu for ISE, Case, ES --->
<cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.All, CLIENT.companyID)>

    <cfswitch expression="#CLIENT.userType#">
    
        <!--- Menu for Int. Agents --->
        <cfcase value="8">
            <ul id="MenuBar1" class="MenuBarHorizontal">
            
                <li>
                    <a href="index.cfm?curdoc=intrep/studentList">Students</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=intrep/studentList&status=unplaced">Unplaced</a></li>
                        <li><a href="index.cfm?curdoc=intrep/studentList&status=pending">Pending</a></li>
                        <li><a href="index.cfm?curdoc=intrep/studentList&status=placed">Placed</a></li>
                        <li><a href="index.cfm?curdoc=intrep/studentList&status=all">All</a></li>
                        <li><a href="index.cfm?curdoc=intrep/int_php_students">Private High School</a></li>
                    </ul>
                </li>
            
                <li>
                    <a href="index.cfm?curdoc=branch/branches">Branches</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=branch/add_branch">Add Branch</a></li>
                        <li><a href="index.cfm?curdoc=branch/branches">View Branches</a></li>
                    </ul>
                </li>
            
                <li>
                    <a href="##">Tools</a>
                    <ul>
						<li><a href="index.cfm?curdoc=tools/verification_received">#CLIENT.DSFormName# Verification List</a></li>                        
                        <li><a href="index.cfm?curdoc=intRep/index&action=flightInformationList">Flight Information</a></li>
                        <li><a href="index.cfm?curdoc=intrep/email_welcome">Email Messages</a></li>
                        <li><a href="index.cfm?curdoc=intrep/update_alerts">News Messages</a></li>
                        <li><a href="index.cfm?curdoc=intrep/reports/labels_select_pro">Generate ID Cards</a></li>
                    </ul>
                </li>
            
                <li><a href="index.cfm?curdoc=user_info&userID=#CLIENT.userID#">My Info</a></li>
                
                <li>
                	<a href="index.cfm?curdoc=reports/flightInfoMenu">Reports</a>
                	<ul>
                    	<li><a href="index.cfm?curdoc=reports/flightInfoMenu">Flight Information Report</a></li> 
					</ul>                        
                </li>
                
                <li><a href="index.cfm?curdoc=helpdesk/help_desk_list">Support</a></li>
                
                <!--- ISE Store --->
                <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    <li><a href="http://www.iseusa.com/webstore" target="_blank">Store</a></li>            
                <!--- Case Store --->
				<cfelseif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/store/store.cfm" target="_blank">Store</a></li>
                </cfif>
                
            </ul>
        </cfcase>


        <!--- Menu for Int. Branches --->
        <cfcase value="11">
            <ul id="MenuBar1" class="MenuBarHorizontal">
            
                <li>
                    <a href="index.cfm?curdoc=intrep/studentList">Students</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=intrep/studentList&placed=no">Unplaced</a></li>
                        <li><a href="index.cfm?curdoc=intrep/studentList&status=pending">Pending</a></li>
                        <li><a href="index.cfm?curdoc=intrep/studentList&placed=yes">Placed</a></li>
                        <li><a href="index.cfm?curdoc=intrep/studentList&placed=all">All</a></li>
                    </ul>
                </li>
                
                <li>
                    <a href="index.cfm?curdoc=helpdesk/help_desk_list">Tools</a>
                    <ul>
   						<li><a href="index.cfm?curdoc=tools/verification_received">#CLIENT.DSFormName# Verification List</a></li>                        
                        <li><a href="index.cfm?curdoc=intRep/index&action=flightInformationList">Flight Information</a></li>
                    </ul>
                </li>
                
                <li><a href="index.cfm?curdoc=branch/branch_info&branchid=#CLIENT.userID#">My Info</a></li>
                
                <li><a href="index.cfm?curdoc=helpdesk/help_desk_list">Support</a></li>
                
                <!--- ISE Store --->
                <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    <li><a href="http://www.iseusa.com/webstore" target="_blank">Store</a></li>            
                <!--- Case Store --->
				<cfelseif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/store/store.cfm" target="_blank">Store</a></li>
                </cfif>
            
            </ul>
        </cfcase>
    
    
        <!--- Menu for Second Visit Reps --->
        <cfcase value="15">
            <ul id="MenuBar1" class="MenuBarHorizontal">
            
                <li>
                    <a href="index.cfm?curdoc=secondVisit/students">Students</a>
                </li>
                
                <li><a href="index.cfm?curdoc=user_info&userID=#CLIENT.userID#">My Info</a></li>
                
                <!--- ISE Store --->
                <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    <li><a href="http://www.iseusa.com/webstore" target="_blank">Store</a></li>            
                <!--- Case Store --->
				<cfelseif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/store/store.cfm" target="_blank">Store</a></li>
                </cfif>
                
            </ul>
        </cfcase>
    
    
        <!--- Menu for MPD Tours --->
        <cfcase value="25">
            <ul id="MenuBar1" class="MenuBarHorizontal">
            
                <li>
                    <a href="index.cfm?curdoc=tours/mpdtours">Students</a>
              	</li>
                
                <li>
                    <a href="index.cfm?curdoc=tours/student-tours/index">Tours</a>
                </li>
                
              	<li>
                	<a href="index.cfm?curdoc=tours/MPDReports/index">Reports</a>
               	</li>
            
                <li><a href="index.cfm?curdoc=user_info&userID=#CLIENT.userID#">My Info</a></li>
                
                <!--- ISE Store --->
                <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    <li><a href="http://www.iseusa.com/webstore" target="_blank">Store</a></li>            
                <!--- Case Store --->
				<cfelseif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/store/store.cfm" target="_blank">Store</a></li>
                </cfif>
                
            </ul>
        </cfcase>
        
    
        <!--- Menu for Host Leads --->
        <cfcase value="26">
            <ul id="MenuBar1" class="MenuBarHorizontal">

				<!--- Host Leads - ISE Only --->
                <li><a href="index.cfm?curdoc=hostLeads/index">Host Leads</a></li>   
            
                <li><a href="index.cfm?curdoc=user_info&userID=#CLIENT.userID#">My Info</a></li>
                
                <!--- ISE Store --->
                <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    <li><a href="http://www.iseusa.com/webstore" target="_blank">Store</a></li>            
                <!--- Case Store --->
				<cfelseif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/store/store.cfm" target="_blank">Store</a></li>
                </cfif>
                
            </ul>
        </cfcase>
    

        <!--- Menu for DOS Guest User --->
        <cfcase value="27">
            <ul id="MenuBar1" class="MenuBarHorizontal">

                <li>
                    <a href="index.cfm?curdoc=students">Students</a>
                </li>

                <li>
                    <a href="index.cfm?curdoc=users">Users</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=user_info&userID=#CLIENT.userID#">My Information</a></li>
                    </ul>
                </li>
                
            </ul>
        </cfcase>

    
        <!--- Menu for the Field | Managers | Advisors | Area Reps | Student View --->
        <cfcase value="5,6,7,9">
            <ul id="MenuBar1" class="MenuBarHorizontal">
            
                <li><a href="index.cfm?curdoc=students">Students</a></li>
                
                <li>
                	<span class="menuHeader" onclick="clickHeader(this);">Host Families</span>
                	<ul>
                    	<li><a href="index.cfm?curdoc=host_fam">Host Families</a></li>
						<!--- Host Leads - ISE Only --->
                        <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID) AND ListFind("5,6,7", CLIENT.userType)>
                            <li><a href="index.cfm?curdoc=hostLeads/index">Host Family Leads</a></li>           
                        </cfif>
                  	</ul>
                </li>
                
                <li><a href="index.cfm?curdoc=schools">Schools</a></li>
                
                <li>
                	<span class="menuHeader" onclick="clickHeader(this);">Users</span>
                    <ul>
                    	<li><a href="index.cfm?curdoc=users">Users</a></li>
                        <li><a href="index.cfm?curdoc=user_info&userID=#CLIENT.userID#">My Information</a></li>
                    </ul>
                </li>
                
                <li><a href="index.cfm?curdoc=pdf_docs/index">#qGetCompany.companyShort_noColor# Docs</a></li>
                
                <!--- Student View does not have access to reports --->
                <cfif listFind("5,6,7", CLIENT.userType)>
                    <li><a href="index.cfm?curdoc=reports/index">Reports</a></li>
                </cfif>
                
                <!--- Reports For Managers and Advisors --->
				<cfif listFind("5", CLIENT.userType)>
					<li><a href="index.cfm?curdoc=report/index">New Reports</a></li>
				</cfif>
                
                <li><a href="index.cfm?curdoc=support">Support</a></li>
                
                <!--- Webmail | Only Office and Managers have email account --->
                <cfif listFind("1,2,3,4,5", CLIENT.userType)>
                    <cfswitch expression="#CLIENT.companyid#">
                        
                        <cfcase value="1,2,3,4,12">
                            <li><a href="http://webmail.iseusa.org/" target="_blank">Webmail</a></li>
                        </cfcase>
                        
                        <cfcase value="5">
                            <li><a href="http://webmail.student-management.com/" target="_blank">Webmail</a></li>
                        </cfcase>
            
                        <cfcase value="10">
                            <li><a href="http://webmail.case-usa.org/" target="_blank">Webmail</a></li>
                        </cfcase>
            
                    </cfswitch>
                </cfif>
                
                <!--- ISE Store --->
                <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    <li><a href="http://www.iseusa.com/webstore" target="_blank">Store</a></li>            
                <!--- Case Store --->
				<cfelseif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/store/store.cfm" target="_blank">Store</a></li>
                </cfif>
            
            </ul>
        </cfcase>
    
    
        <!--- Menu for Office Users --->	
        <cfcase value="1,2,3,4">
            <ul id="MenuBar1" class="MenuBarHorizontal">
            
                <li>
                    <a href="index.cfm?curdoc=students">Students</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=app_process/apps_received">Received</a></li>
                    </ul>
                </li>
                
                <li>
                	<a href="index.cfm?curdoc=host_fam">Host Families</a>
                    <!--- Host Leads - ISE Only --->
					<cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                        <ul>
                            <li>
                            	<a href="index.cfm?curdoc=hostLeads/index">Host Family Leads</a>
                                <ul>
                                    <li><a href="index.cfm?curdoc=hostLeads/index&action=report">Reports</a></li>
                                </ul>
                            </li>   
                   			<cfif ListFind(allowedUsers, CLIENT.userID)>
                            	<li><a href="index.cfm?curdoc=hostApplication/hostAppIndex">Host Family Apps</a></li>
                       		</cfif>
                        </ul>
					</cfif>
                </li>
                
                <li><a href="index.cfm?curdoc=schools">Schools</a></li>
                
                <li>
                    <a href="index.cfm?curdoc=users">Users</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=user_info&userID=#CLIENT.userID#">My Information</a></li>
                    </ul>
                </li>
                
                <cfif APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="mpdTrips")>
                    <li>
                        <a href="index.cfm?curdoc=tours/mpdtours">MPD Tours</a>
                        <ul>
                            <li><a href="index.cfm?curdoc=tours/mpdtours">Students</a></li>
                            <li><a href="index.cfm?curdoc=tours/student-tours/index">Tours</a></li>
                            <li><a href="index.cfm?curdoc=tours/MPDReports/index">Reports</a></li>
                            <li><a href="index.cfm?curdoc=tours/permissionForm">Permission</a></li>
                        </ul>
                    </li>
                </cfif>
                
                <!--- Invoice Access --->
                <cfif APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID,role="invoiceEdit")>
                    <li>
                        <a href="index.cfm?curdoc=invoice/invoice_index&Requesttimeout=300">Invoicing</a>
                        <ul>
                            <!--- <li><a href="index.cfm?curdoc=invoice/reports/statement">Account Statement</a></li> --->
                            <li><a href="index.cfm?curdoc=invoice/reports/statement_detailed" target="_blank">Detailed Statement</a></li>
                            <li><a href="index.cfm?curdoc=invoice/reports/check_fees_menu" target="_blank">Check Fees Per Intl. Rep</a></li>
                            <!--- <li><a href="index.cfm?curdoc=invoice/int_rep_rates">Intl. Rep. Rates</a></li> --->
                            <li><a href="index.cfm?curdoc=invoice/m_hs_invoiceBatch" target="_blank">HS Invoice Batch</a></li>
                            <li><a href="" onClick="javaScript:win=window.open('invoice/m_payment.cfm', '_blank', 'height=800, width=900,  toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=1, resizable=yes, copyhistory=no'); win.opener=self; return false;">Payments Received</a></li>
                            <li><a href="invoice/m_chargesList.cfm" target="_blank">List of Charges</a></li>
                            <li><a href="invoice/m_wt_prices.cfm" target="_blank">W&T Price List</a></li>
                            <li><a href="invoice/m_financialSummary.cfm" target="_blank">Financial Summary</a></li>
                        </ul>
                    </li>              
                </cfif>
                
                
                	<li><a href="index.cfm?curdoc=pdf_docs/index">#qGetCompany.companyShort_noColor# Docs</a></li>
                
              
                    <li>
                        <a href="index.cfm?curdoc=reports/index">Reports</a>
                        
                    </li>
				
                <li><a href="index.cfm?curdoc=report/index">New Reports</a></li>
                <cfif APPLICATION.CFC.USER.isOfficeUser()>
						<ul>
							<li><a href="index.cfm?curdoc=reports/constantContactMenu">Constant Contact</a></li>
						</ul>
					</cfif>
                <li>
                    <a href="##">Tools</a>                
                    <ul>
                        <!--- Compliance Access --->
                        <cfif APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID,role="runCBC")>   
                            <li><a href="index.cfm?curdoc=cbc/cbc_menu">CBC Batch</a></li>
                        </cfif>
                        
                        <!--- Only allow Global Administrators, Paul Sessions, and Bill Bonomo --->
						<cfif CLIENT.userType EQ 1 OR CLIENT.userID EQ 17438 OR CLIENT.userID EQ 17095>
                            <li>
                            	<a href="">Merge Options</a>					
                                <ul>
                                    <li><a href="index.cfm?curdoc=compliance/combine_hosts">Host Family</a></li>   
                                    <!--- May not be up to date
                                    <li><a href="index.cfm?curdoc=compliance/combine_schools">Schools</a></li>
									--->
                                </ul>
                            </li>
                        </cfif>

                        <li><a href="index.cfm?curdoc=tools/countryMaintenance">Country Maintenance</a></li> 
    
    					<li><a href="index.cfm?curdoc=tools/verification_received">#CLIENT.DSFormName# Verification List</a></li>

    					<li><a href="index.cfm?curdoc=tools/importFLSID">FLS Import Tool</a></li>

						<li><a href="index.cfm?curdoc=tools/intlRepAllocation">International Rep. Allocation</a></li>
                    
                        <li>
                            <a href="index.cfm?curdoc=insurance/index">Insurance Menu</a>
                            <ul>
                                <li><a href="index.cfm?curdoc=insurance/insurance_codes">Policy Codes</a></li>
                            </ul>
                        </li>
                        
                        <li><a href="index.cfm?curdoc=tools/programs">Programs</a></li>
    
                        <li><a href="index.cfm?curdoc=tools/progress_report_questions">PR Questions</a></li>
    					<li><a href="index.cfm?curdoc=tools/receiveHostApp">Receive Apps</a></li>
                        <li><a href="index.cfm?curdoc=tools/regions">Region Maintenance</a></li>
                        
						<li><a href="index.cfm?curdoc=tools/regionAllocation">Region Allocation</a></li>

                        
                        <cfif ListFind("1,2,3", CLIENT.userType)>
                        	<li>
                            	<a href="index.cfm?curdoc=userPayment/index">Representative Payments</a>
                                <ul>
                                    <li><a href="index.cfm?curdoc=userPayment/index&action=bonusReport">Bonus Report</a></li>
                                    <li><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=maintenance">Fee Maintenance</a></li>
                                    <li><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=potentialCredits">Potential Credits</a></li>
                                    <li><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=payReps">Pay Representatives</a></li>
                                    <li><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=checkSummary">Check Summary</a></li>
                                </ul>
                            </li>
                        </cfif>
                        
                        <li><a href="index.cfm?curdoc=sevis/menu">SEVIS Batch</a>					
                            <!--- SEVIS Dev Access --->
                            <cfif CLIENT.usertype EQ 1>
                                <ul>
                                    <li><a href="index.cfm?curdoc=sevis_test/menu">SEVIS Batch Dev</a></li>
                                </ul>
                            </cfif>					
                        </li>
                        
                        <li><a href="index.cfm?curdoc=forms/update_alerts">System Messages</a></li>
    					<li><a href="index.cfm?curdoc=virtualFolder/globalSettings">Virtual Folder Options</a></li>
                        <li><a href="index.cfm?curdoc=tools/smg_welcome_pictures">Welcome Pictures</a></li>
                        <!--- This tool should only be visible to Brian Hause, Tom Policastro, Paul McLaughlin, James Griffiths, and Global Administrators --->
						<cfif ListFind("12313,13538,19422,18602,19159,17427",CLIENT.userID) OR CLIENT.userType EQ 1>
                        	<li><a href="index.cfm?curdoc=tools/incentiveTripPoints">Incentive Trip Points</a></li>
                        </cfif>
                    </ul>
                </li>
                
                <li>
                    <a href="index.cfm?curdoc=helpdesk/help_desk_list">Help Desk</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=helpdesk/hd_list_exits">EXITS</a></li>
                        <li><a href="index.cfm?curdoc=helpdesk/help_desk_sections">Sections</a></li>
                    </ul>
                </li>
                
                <!--- Webmail | Only Office and Managers have email account --->
                <cfif listFind("1,2,3,4,5", CLIENT.userType)>
                    <cfswitch expression="#CLIENT.companyid#">
                        
                        <cfcase value="1,2,3,4,5,12">
                            <li><a href="http://webmail.iseusa.org/" target="_blank">Webmail</a></li>
                        </cfcase>
            
                        <cfcase value="10">
                            <li><a href="http://webmail.case-usa.org/" target="_blank">Webmail</a></li>
                        </cfcase>
            
                    </cfswitch>
				</cfif>
				
                <!--- ISE Store --->
                <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    <li><a href="http://www.iseusa.com/webstore" target="_blank">Store</a>
                    	 <cfif (client.userid eq 314 OR client.userid eq 1 OR client.userid eq 9719)>
                            <ul>
                                <li><a href="http://www.iseusa.com/webstore/admin">Admin</a></li>
                            </ul>        
                    	</cfif>
                    </li>            
                <!--- Case Store --->
				<cfelseif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/store/store.cfm" target="_blank">Store</a></li>
                </cfif>
            
            </ul>
		</cfcase>
        
        
        <!--- Default Menu - Only Webmail and Store --->
        <cfdefaultcase>
            <ul id="MenuBar1" class="MenuBarHorizontal">
                
                <!--- Webmail | Only Office and Managers have email account --->
                <cfif listFind("1,2,3,4,5", CLIENT.userType)>
                    <cfswitch expression="#CLIENT.companyid#">
                        
                        <cfcase value="1,2,3,4,5,12">
                            <li><a href="http://webmail.iseusa.org/" target="_blank">Webmail</a></li>
                        </cfcase>
            
                        <cfcase value="10">
                            <li><a href="http://webmail.case-usa.org/" target="_blank">Webmail</a></li>
                        </cfcase>
            
                    </cfswitch>
				</cfif>
				
                <!--- ISE Store --->
                <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    <li><a href="http://www.iseusa.com/webstore" target="_blank">Store</a></li>            
                <!--- Case Store --->
				<cfelseif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/store/store.cfm" target="_blank">Store</a></li>
                </cfif>
            
			</ul>        
        </cfdefaultcase>
        
    </cfswitch>

<!--- MENU FOR EXITS STAND ALONE APPLICATIONS (WEP - COMPANYID = 11) --->
<cfelse>

    <ul id="MenuBar1" class="MenuBarHorizontal">
    
        <li>
            <a href="index.cfm?curdoc=students">Students</a>
        </li>
        
        <li>
            <a href="index.cfm?curdoc=users">Users</a>
            <ul>
                <li><a href="index.cfm?curdoc=user_info&userID=#CLIENT.userID#">My Information</a></li>
            </ul>
        </li>
        
    </ul>

</cfif>

</cfoutput>

<!--- 
	Hack for Firefox - Grey bar was not displaying correctly unless we add a tag before the 
	<!DOCTYPE> which need to be removed for the jQuery Modal 
--->
<!--- <div style="width:100%; background-color:#EEE; padding: 0.5em 0.75em;">&nbsp;</div> --->

<script type="text/javascript">
<!--
	var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"/SpryAssets/SpryMenuBarDownHover.gif", imgRight:"/SpryAssets/SpryMenuBarRightHover.gif"});
//-->
</script>