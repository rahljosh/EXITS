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
        // Get Company Info
        qGetCompany = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
    </cfscript>

</cfsilent>

<script src="/nsmg/SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
<link href="/nsmg/SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />

<cfoutput>

<!--- Menu for ISE and Case --->
<cfif ListFind("1,2,3,4,5,10,12,13", CLIENT.companyID)>

    <cfswitch expression="#CLIENT.userType#">
    
        <!--- Menu for Int. Agents --->
        <cfcase value="8">
            <ul id="MenuBar1" class="MenuBarHorizontal">
            
                <li>
                    <a href="index.cfm?curdoc=intrep/int_students">Students</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=intrep/int_students&status=unplaced">Unplaced</a></li>
                        <li><a href="index.cfm?curdoc=intrep/int_students&status=placed">Placed</a></li>
                        <li><a href="index.cfm?curdoc=intrep/int_students&status=all">All</a></li>
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
                        <li><a href="index.cfm?curdoc=intrep/students_missing_flight_info">Flight Information</a></li>
                        <li><a href="index.cfm?curdoc=intrep/email_welcome">Email Messages</a></li>
                        <li><a href="index.cfm?curdoc=intrep/update_alerts">News Messages</a></li>
                        <li><a href="index.cfm?curdoc=intrep/reports/labels_select_pro">Generate ID Cards</a></li>
                    </ul>
                </li>
            
                <li><a href="index.cfm?curdoc=user_info&userid=#CLIENT.userid#">My Info</a></li>
                
                <li><a href="index.cfm?curdoc=helpdesk/help_desk_list">Support</a></li>
                
                <!--- Case Store --->
                <cfif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/Store/store.cfm" target="_blank">Store</a></li>
                <!--- ISE Store --->
                <cfelse>
                    <li><a href="http://www.iseusa.com/webstore.cfm" target="_blank">Store</a></li>            
                </cfif>
                
            </ul>
        </cfcase>
    
    
        <!--- Menu for Int. Branches --->
        <cfcase value="11">
    
            <ul id="MenuBar1" class="MenuBarHorizontal">
            
                <li>
                    <a href="index.cfm?curdoc=intrep/int_students">Students</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=intrep/int_students&placed=no">Unplaced</a></li>
                        <li><a href="index.cfm?curdoc=intrep/int_students&placed=yes">Placed</a></li>
                        <li><a href="index.cfm?curdoc=intrep/int_students&placed=all">All</a></li>
                    </ul>
                </li>
                
                <li>
                    <a href="index.cfm?curdoc=helpdesk/help_desk_list">Tools</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=intrep/int_flight_info">Flight Information</a></li>
                    </ul>
                </li>
                
                <li><a href="index.cfm?curdoc=branch/branch_info&branchid=#CLIENT.userid#">My Info</a></li>
                
                <li><a href="index.cfm?curdoc=helpdesk/help_desk_list">Support</a></li>
                
                <!--- Case Store --->
                <cfif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/Store/store.cfm" target="_blank">Store</a></li>
                <!--- ISE Store --->
                <cfelse>
                    <li><a href="http://www.iseusa.com/webstore.cfm" target="_blank">Store</a></li>            
                </cfif>
            
            </ul>
        
        </cfcase>
    
    
        <!--- Menu for the Field | Managers / Advisors / Area Reps / Student View --->
        <cfcase value="5,6,7,9">
    
            <ul id="MenuBar1" class="MenuBarHorizontal">
            
                <li>
                    <a href="index.cfm?curdoc=students">Students</a>
                </li>
                
                <li><a href="index.cfm?curdoc=host_fam">Host Families</a></li>
                
                <li><a href="index.cfm?curdoc=schools">Schools</a></li>
                
                <li>
                    <a href="index.cfm?curdoc=users">Users</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=user_info&userid=#CLIENT.userid#">My Information</a></li>
                    </ul>
                </li>
                
                <li><a href="index.cfm?curdoc=pdf_docs/index">#qGetCompany.companyShort_noColor# Docs</a></li>
                
                <!--- Not Student View --->
                <cfif CLIENT.usertype NEQ 9>
                    <li><a href="index.cfm?curdoc=reports/index">Reports</a></li>
                </cfif>
    
                <li><a href="index.cfm?curdoc=support">Support</a></li>
                
                <!--- Webmail | Only Office and Managers have email account --->
                <cfif CLIENT.userType LTE 5>
                    <cfswitch expression="#CLIENT.companyid#">
                        
                        <cfcase value="1,2,3,4,12">
                            <li><a href="http://webmail.iseusa.com/" target="_blank">Webmail</a></li>
                        </cfcase>
                        
                        <cfcase value="5">
                            <li><a href="http://webmail.student-management.com/" target="_blank">Webmail</a></li>
                        </cfcase>
            
                        <cfcase value="10">
                            <li><a href="http://webmail.case-usa.org/" target="_blank">Webmail</a></li>
                        </cfcase>
            
                    </cfswitch>
                </cfif>
                
                <!--- Case Store --->
                <cfif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/Store/store.cfm" target="_blank">Store</a></li>
                <!--- ISE Store --->
                <cfelse>
                    <li><a href="http://www.iseusa.com/webstore.cfm" target="_blank">Store</a></li>            
                </cfif>
            
            </ul>
        
        </cfcase>
    
    
        <!--- Menu for Office Users --->	
        <cfdefaultcase>
        
            <ul id="MenuBar1" class="MenuBarHorizontal">
            
                <li>
                    <a href="index.cfm?curdoc=students">Students</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=app_process/apps_received">Received</a></li>
                    </ul>
                </li>
                
                <li><a href="index.cfm?curdoc=host_fam">Host Families</a></li>
                
                <li><a href="index.cfm?curdoc=schools">Schools</a></li>
                
                <li>
                    <a href="index.cfm?curdoc=users">Users</a>
                    <ul>
                        <li><a href="index.cfm?curdoc=user_info&userid=#CLIENT.userid#">My Information</a></li>
                    </ul>
                </li>
                
                <!--- Invoice Access --->
                <cfif CLIENT.invoice_Access EQ 1>
                    <li>
                        <a href="index.cfm?curdoc=invoice/invoice_index&Requesttimeout=300">Invoicing</a>
                        <ul>
                            <!--- <li><a href="index.cfm?curdoc=invoice/reports/statement">Account Statement</a></li> --->
                            <li><a href="index.cfm?curdoc=invoice/reports/statement_detailed" target="_blank">Detailed Statement</a></li>
                            <li><a href="index.cfm?curdoc=invoice/reports/check_fees_menu" target="_blank">Check Fees Per Intl. Rep</a></li>
                            <!--- <li><a href="index.cfm?curdoc=invoice/int_rep_rates">Intl. Rep. Rates</a></li> --->
                            <li><a href="index.cfm?curdoc=invoice/m_hs_invoiceBatch" target="_blank">HS Invoice Batch</a></li>
                            <li><a href="" onClick="javaScript:win=window.open('invoice/m_payment.cfm', '_blank', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=800, height=800'); win.opener=self; return false;">Payments Received</a></li>
                        </ul>
                    </li>              
                </cfif>
                
                <li><a href="index.cfm?curdoc=pdf_docs/index">#qGetCompany.companyShort_noColor# Docs</a></li>
                
                <li><a href="index.cfm?curdoc=reports/index">Reports</a></li>
                
                <li>
                    <a href="##">Tools</a>                
                    <ul>
                        <!--- CBC Access --->
                        <cfif CLIENT.usertype LTE 2 OR CLIENT.compliance EQ 1>    
                            <li>
                                <a href="index.cfm?curdoc=cbc/cbc_menu">CBC Batch</a>
                            </li>
    
                            <li><a href="index.cfm?curdoc=cbc/combine_hosts">Combining Hosts</a></li>   
                            
                            <li><a href="index.cfm?curdoc=compliance/combine_schools">Combining Schools</a></li>
                        </cfif>
    
                        <li><a href="index.cfm?curdoc=tools/countries">Countries</a></li>
                    
                    	<cfif ListFind(APPLICATION.AllowedIDs.hostLeads, CLIENT.userID) OR CLIENT.userType EQ 1>
                            <li><a href="index.cfm?curdoc=tools/hostLeads">Host Family Leads</a></li>
                        </cfif>
                    
                        <li>
                            <a href="index.cfm?curdoc=insurance/insurance_menu">Insurance Menu</a>
                            <ul>
                                <li><a href="index.cfm?curdoc=insurance/insurance_codes">Policy Codes</a></li>
                            </ul>
                        </li>
                        
                        <li><a href="index.cfm?curdoc=tools/programs">Programs</a></li>
    
                        <li><a href="index.cfm?curdoc=tools/progress_report_questions">PR Questions</a></li>
    
                        <li><a href="index.cfm?curdoc=tools/regions">Regions</a></li>
    
                        <li><a href="index.cfm?curdoc=forms/supervising_placement_payments">Rep Payments</a></li>
        
                        <li><a href="index.cfm?curdoc=sevis/menu">SEVIS Batch</a>					
                            <!--- SEVIS Dev Access --->
                            <cfif CLIENT.usertype EQ 1>
                                <ul>
                                    <li><a href="index.cfm?curdoc=sevis_test/menu">SEVIS Batch Dev</a></li>
                                </ul>
                            </cfif>					
                        </li>
                        
                        <li><a href="index.cfm?curdoc=forms/update_alerts">System Messages</a></li>
    
                        <li><a href="index.cfm?curdoc=tools/student-tours/index">Student Tours</a></li>
    
    					<li><a href="index.cfm?curdoc=tools/verification_received">Verification Received List</a></li>
    
                        <li><a href="index.cfm?curdoc=tools/smg_welcome_pictures">Welcome Pictures</a></li>
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
                <cfif CLIENT.userType LTE 5>
                    <cfswitch expression="#CLIENT.companyid#">
                        
                        <cfcase value="1,2,3,4,12">
                            <li><a href="http://webmail.iseusa.com/" target="_blank">Webmail</a></li>
                        </cfcase>
                        
                        <cfcase value="5">
                            <li><a href="http://webmail.student-management.com/" target="_blank">Webmail</a></li>
                        </cfcase>
            
                        <cfcase value="10">
                            <li><a href="http://webmail.case-usa.org/" target="_blank">Webmail</a></li>
                        </cfcase>
            
                    </cfswitch>
				</cfif>
                                
                <!--- Case Store --->
                <cfif CLIENT.companyID EQ 10>
                     <li><a href="http://www.case-usa.org/Store/store.cfm" target="_blank">Store</a></li>
                <!--- ISE Store --->
                <cfelse>
                    <li><a href="http://www.iseusa.com/webstore.cfm" target="_blank">Store</a></li>            
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
                <li><a href="index.cfm?curdoc=user_info&userid=#CLIENT.userid#">My Information</a></li>
            </ul>
        </li>
        
    </ul>

</cfif>

</cfoutput>

<script type="text/javascript">
<!--
	var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"/exits/SpryAssets/SpryMenuBarDownHover.gif", imgRight:"/exits/SpryAssets/SpryMenuBarRightHover.gif"});
//-->
</script>