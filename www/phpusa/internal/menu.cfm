<!--- ------------------------------------------------------------------------- ----
	
	File:		menu.cfm
	Author:		Marcus Melo
	Date:		May 13, 2011
	Desc:		Application Top Menu

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfoutput>

<!--- Display Proper Menu Based on UserType --->
<cfswitch expression="#CLIENT.usertype#">

	<!--- Office --->
	<cfcase value="1,2,3,4">
    
        <ul id="MenuBar1" class="MenuBarHorizontal">
        
            <li><a href="index.cfm?curdoc=lists/students">Students</a>
                <ul>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=no&status=active">Unplaced</a></li>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=yes&status=active">Placed</a></li>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=all&status=active">All</a></li>
                </ul>
            </li>
            
            <li><a href="index.cfm?curdoc=lists/hosts">Host Families</a></li>
            
            <li><a href="index.cfm?curdoc=lists/schools">Schools</a></li>
            
            <li><a href="index.cfm?curdoc=lists/users">Users</a>
                <ul>
                    <li><a href="index.cfm?curdoc=users/user_info&userid=#CLIENT.userid#">My Info</a></li>
                    <li><a href="index.cfm?curdoc=lists/users">U.S. Users</a></li>
                    <li><a href="index.cfm?curdoc=lists/users&usertype=intagent">International Partners</a></li>
                    <li><a href="index.cfm?curdoc=users/user_assign_question">Add New User</a></li>
                </ul>
            </li>
            
            <cfif CLIENT.invoice_access EQ 1>
                <li><a href="index.cfm?curdoc=invoice/invoice_index">Invoicing</a></li>
            </cfif>
            
            <li><a href="index.cfm?curdoc=pdf_docs/docs_forms">PDF Docs</a></li>
            
            <li><a href="index.cfm?curdoc=reports/reports_menu">Reports</a>
                <ul>
                    <li><a href="index.cfm?curdoc=reports/flightMenu">Flight Reports</a></li>
                    <li><a href="index.cfm?curdoc=reports/menu_id_cards">ID Cards & Labels and Bulk Letters</a></li>
                    <li><a href="index.cfm?curdoc=reports/constantContactMenu">Constant Contact</a></li>
                </ul>
            </li>
            
            <li><a href="##">Tools</a>
                <ul>
                    <cfif ListFind("1,2,3", CLIENT.usertype)>
                        <li><a href="index.cfm?curdoc=invoice/intl_rep_insurance">Intl. Rep Insurance Policy</a></li>
                    </cfif>
                    <li><a href="index.cfm?curdoc=insurance/menu">Insurance Files</a></li>
                    <li><a href="index.cfm?curdoc=tools/progress_report_questions">PR Questions</a></li>
                    <li><a href="index.cfm?curdoc=tools/programs">Programs</a></li>
                    <cfif ListFind("1,510", CLIENT.userID)>
                        <li><a href="index.cfm?curdoc=forms/supervising_placement_payments">Rep Payments</a></li>
                    </cfif>
                    <li><a href="index.cfm?curdoc=tools/returning_j1_students">Returning Students J1 to F1</a></li>
                    <li><a href="index.cfm?curdoc=forms/update_alerts">System Messages</a></li>
                </ul>
            </li>
            
            <li><a href="index.cfm?curdoc=helpdesk/help_desk_list">Support</a></li>
            
            <li><a href="http://webmail.phpusa.com" target="_blank">Webmail</a></li>
        
        </ul>

    </cfcase>
	
    <!--- Field Users --->
	<cfcase value="5,6,7">
    
        <ul id="MenuBar1" class="MenuBarHorizontal">
        
            <li><a href="index.cfm?curdoc=lists/students">Students</a>
                <ul>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=no&status=active">Unplaced</a></li>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=yes&status=active">Placed</a></li>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=all&status=active">All</a></li>
                </ul>
            </li>
            
            <li><a href="index.cfm?curdoc=lists/hosts">Host Families</a></li>
            
            <li><a href="index.cfm?curdoc=lists/schools">Schools</a></li>
            
            <li><a href="index.cfm?curdoc=pdf_docs/docs_forms">PDF Docs</a></li>
        
        </ul>
    
    </cfcase>

	<!--- International Representative --->
	<cfcase value="8">

        <ul id="MenuBar1" class="MenuBarHorizontal">
        
            <li><a href="index.cfm?curdoc=lists/students">Students</a>
                <ul>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=yes&status=active">Placed with Host</a></li>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=all&status=active">All</a></li>
                </ul>
            </li>
            
            <!--- <li><a href="index.cfm?curdoc=lists/schools">Schools</a></li> --->
            
            <!--- <li><a href="index.cfm?curdoc=users/user_info&userid=#CLIENT.userid#">My Info</a></li> --->
            
            <li><a href="index.cfm?curdoc=student/index&action=flightInformationList">Flight Info List</a></li>
            
            <li><a href="index.cfm?curdoc=pdf_docs/docs_forms">PDF Docs</a></li>
            
        </ul>

    </cfcase>
	
    <!--- Schools --->
	<cfcase value="12">

        <ul id="MenuBar1" class="MenuBarHorizontal">
        
            <li><a href="index.cfm?curdoc=lists/students">Students</a>
                <ul>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=no&status=active">Unplaced</a></li>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=yes&status=active">Placed</a></li>
                    <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=all&status=active">All</a></li>
                </ul>
            </li>
            
            <li><a href="index.cfm?curdoc=lists/hosts">Host Families</a></li>
            
            <li><a href="index.cfm?curdoc=lists/schools">Schools</a></li>
            
            <li><a href="index.cfm?curdoc=pdf_docs/docs_forms">PDF Docs</a></li>
        
        </ul>
	
    </cfcase>
	
    <!--- Default Menu --->
    <cfdefaultcase>

        <ul id="MenuBar1" class="MenuBarHorizontal">
        
            <li><a href="index.cfm?curdoc=lists/students">Students</a></li>
            
            <li><a href="index.cfm?curdoc=pdf_docs/docs_forms">PDF Docs</a></li>
        
        </ul>
    
    </cfdefaultcase>

</cfswitch>

</cfoutput>

<script type="text/javascript">
	<!--
	var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"/internal/SpryAssets/SpryMenuBarDownHover.gif", imgRight:"/internal/SpryAssets/SpryMenuBarRightHover.gif"});
	//-->
</script>
