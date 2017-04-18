<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		August 18, 2010
	Desc:		Login Page

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfquery name="get_user_uniqueid" datasource="MySql">
        SELECT 
        	userid, 
            uniqueid
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    </cfquery>
    
</cfsilent>

<link rel="stylesheet" type="text/css" href="../menu.css" />
<script type="text/javascript" src="ie5.js"></script>
<script type="text/javascript" src="DropDownMenuX.js"></script>

<cfoutput>
	
<!--- Menu for Office Users --->
<cfif ListFind("1,2,3,4", CLIENT.userType)>

    <table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">
        <tr bgcolor="##cfcfcf">
            <td bgcolor="##8FB6C9">
                <a class="item1" href="?curdoc=candidate/candidates">Candidates</a>
                <div class="section">
                <a class="item2" href="?curdoc=candidate/candidates&status=1">List</a>
                <a class="item2" href="?curdoc=candidate/new_candidate">Add</a>				
                <a class="item2" href="?curdoc=candidate/search&search=0&status=All">Search</a>
                </div>
            </td>
            <td bgcolor="##8FB6C9"><a class="item1" href="?curdoc=hostcompany/hostcompanies&order=name">Host Companies</a></td>
            <td bgcolor="##8FB6C9">
                <a class="item1" href="?curdoc=user/users">Users</a>
                <div class="section">
                <a class="item2" href="?curdoc=user/user_info&uniqueid=#get_user_uniqueid.uniqueid#">My Info</a>
                </div>
            </td>
            <td bgcolor="##8FB6C9"><a class="item1" href="?curdoc=intrep/intreps">International Representatives</a></td>
            <td bgcolor="##8FB6C9"><a class="item1" href="?curdoc=pdf_docs/docs_forms">PDF Docs</a></td>
            <td bgcolor="##8FB6C9"><a class="item1" href="?curdoc=reports/all_reports">Reports</a></td>
            <td bgcolor="##8FB6C9">
                <a class="item1" href="">Tools</a>
                <div class="section">
                    <a class="item2" href="?curdoc=candidate/candidate_profile_batch">Batch Candidate Profile</a>
                    <a class="item2" href="?curdoc=candidate/batchSupportLetter">Batch Support Letter</a>   
                    <a class="item2" href="?curdoc=tools/checkInList">Check-In List</a>
                    <a class="item2" href="?curdoc=tools/visaInterview">Visa Interview</a>            
                    <a class="item2" href="?curdoc=tools/ds2019Verification">DS-2019 Verification</a>
                    <a class="item2" href="?curdoc=tools/englishAssessment">English Assessment</a>
                    <a class="item2" href="?curdoc=reports/idcards_menu">ID Cards</a>
                    <a class="item2" href="?curdoc=insurance/insurance_menu">Insurance</a>
                        <div class="section">
                            <a class="item2" href="?curdoc=insurance/insurance_policies">Insurance Policies</a>
                        </div>
					<a class="item2" href="?curdoc=tools/intlRepFeeInfo">Intl. Rep. Fee Information</a>  
                    <a class="item2" href="?curdoc=tools/labels_select_pro">Labels</a>
                    <a class="item2" href="?curdoc=tools/monthlyEvaluations">Monthly Evaluation Tool</a>
                    <a class="item2" href="?curdoc=tools/programs">Programs</a>
                    <a class="item2" href="index.cfm?curdoc=sevis/menu">SEVIS Batch</a>					
                            <!--- SEVIS Dev Access --->
                            <cfif CLIENT.usertype EQ 1>
                              
                                    <li><a class="item2" href="index.cfm?curdoc=sevis_test/menu">SEVIS Batch Dev</a></li>
                                
                            </cfif>					
                        
                </div>
            </td>
            <td bgcolor="##8FB6C9">
                <a class="item1" href="?curdoc=helpdesk/helpdesk_menu" target="_top">Help Desk</a>
                <cfif client.usertype EQ 1>
                    <div class="section">
                        <a class="item2" href="?curdoc=helpdesk/sections">HD Sections</a>
                    </div>
                </cfif>
            </td>
            <td bgcolor="##8FB6C9"><a class="item1" href="http://webmail.csb-usa.com" target="_blank">Webmail</a></td>
        </tr>
    </table>

<!--- Menu for Intl. Reps --->
<cfelse>

    <table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">
        <tr bgcolor="##cfcfcf">
            <td bgcolor="##8FB6C9" width="15%">
                <a class="item1" href="?curdoc=candidate/candidates">Candidates</a>
                <div class="section">
                    <a class="item2" href="?curdoc=candidate/candidates&status=1">List</a>
                    <a class="item2" href="?curdoc=candidate/search&search=0&status=All">Search</a>
                </div>
            </td>
            <td bgcolor="##8FB6C9" width="15%"><a class="item1" href="?curdoc=user/user_info&uniqueid=#get_user_uniqueid.uniqueid#">My Info</a></td>
            <td bgcolor="##8FB6C9" width="15%"><a class="item1" href="?curdoc=reports/all_reports">Reports</a></td>

            <cfif CLIENT.userType NEQ 28>
            <td bgcolor="##8FB6C9" width="15%">
            	<a class="item1" href="">Tools</a>
                <div class="section">
                    <a class="item2" href="?curdoc=tools/visaInterview">Visa Interview</a> 
                    <a class="item2" href="?curdoc=tools/batch_flight_info">Batch Flight Information</a> 
                </div>
            </td>
            </cfif>
            
        	<td bgcolor="##8FB6C9" width="40%">&nbsp;</td>
        </tr>
    </table>

</cfif>

</cfoutput>
