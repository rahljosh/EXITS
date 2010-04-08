

    <style type="text/css">
    body {
        font: 11px tahoma;
        background: #ffffff;
        margin: 0;
    }    
    </style>
    <link rel="stylesheet" type="text/css" href="menu.css" />
   <!---- <script type="text/javascript" src="ie5.js"></script>---->
    <script type="text/javascript" src="DropDownMenuX.js"></script>
	<!----
<cfif cgi.remote_addr is '24.87.232.214'>
<cfset rel_abs="https://web">
<cfset local_abs="https://web">
<cfelse>
<cfset rel_abs="https://mail.student-management.com">
<cfset local_abs="https://web">
</cfif>
<cfif cgi.remote_host is '24.87.232.214'>
<cfset  rel_abs= "https://web">
<cfset local_abs="https://web">
<cfelse>
<cfset rel_abs= "https://mail.student-management.com">
<cfset local_abs="https://web">
</cfif>
	---->
<cfoutput>

<cfquery name="user_compliance" datasource="caseusa">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<!----Menu for Int. Agents---->
<cfif client.usertype EQ 8>
<table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">

	<tr bgcolor=##D1E0EF>
	
		<td height=24 width=13 background="pics/header_leftcap.gif"></td>
        <td>
            <a class="item1" href="?curdoc=intrep/int_students">Students</a>
            <div class="section">
                <a class="item2 arrow" href="?curdoc=intrep/int_students&status=unplaced">Unplaced</a>
				<a class="item2" href="?curdoc=intrep/int_students&status=placed">Placed</a>
                <a class="item2 arrow" href="?curdoc=intrep/int_students&status=all">All</a>
				<a class="item2 arrow" href="?curdoc=intrep/advanced_search">Advanced Search</a>
				<a class="item2 arrow" href="?curdoc=intrep/int_php_students">Private High School</a>
                </div>
            </div>
        </td>
		<td>
            <a class="item1" href="?curdoc=branch/branches">Branches</a>
            <div class="section">
                <a class="item2" href="?curdoc=branch/add_branch">Add Branch</a>
                <a class="item2" href="?curdoc=branch/branches">View Branches</a>
            </div>			
        </td>
				<td>
			<a class="item1" href="">Tools</a>
			<div class="section">
			<a class="item2" href="index.cfm?curdoc=intrep/students_missing_flight_info">Flight Information</a>
			<a class="item2" href="index.cfm?curdoc=intrep/email_welcome">Email Messages</a>
			<a class="item2" href="index.cfm?curdoc=intrep/update_alerts">News Messages</a>
            <a class="item2" href="index.cfm?curdoc=intrep/reports/labels_select_pro">Generate ID Cards</a>
			</div>
			
		</td>
		<td>
        	<a class="item1"  href="?curdoc=user_info&userid=#client.userid#">My Information</a>
        </td>
		<!----
        <td>
            <a class="item1" href="">Account Options</a>
                   <div class="section">
				<a class="item2" href="">Make Payment</a>
				<a class="item2" href="">View Current Invoices</a>
				<a class="item2" href="">View Past Invoices</a>
				<a class="item2" href="">View Payment History</a>
				<a class="item2" href="">Edit Payment Details</a>
				<a class="item2" href="?curdoc=user_info&userid=#client.userid#">Edit Contact Information</a>
			</div>
        </td>
		---->
		<td>
			<a class="item1" href="?curdoc=helpdesk/help_desk_list">Support</a>
			<div class="section">
			<a class="item2" href="?curdoc=helpdesk/help_desk_list">New Ticket</a>
			
			</div>
		</td>

		<td height=24 width=13 background="pics/header_rightcap.gif">
    </tr>
</table>

<!--- INTL BRANCHES --->
<cfelseif client.usertype EQ '11'>	
<table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">

	<tr bgcolor=##D1E0EF>
	
		<td height=24 width=13 background="pics/header_leftcap.gif"></td>
        <td>
            <a class="item1" href="?curdoc=intrep/int_students">Students</a>
            <div class="section">
				<a class="item2 arrow" href="?curdoc=intrep/int_students&placed=no">Unplaced</a>
                <a class="item2 arrow" href="?curdoc=intrep/int_students&placed=yes">Placed</a>
                <a class="item2 arrow" href="?curdoc=intrep/int_students&placed=all">All</a>
				<!--- <a class="item2 arrow" href="?curdoc=advanced_search">Search</a> --->
                </div>
            </div>
        </td>
				<td>
			<a class="item1" href="">Tools</a>
			<div class="section">
			<a class="item2" href="index.cfm?curdoc=intrep/int_flight_info">Flight Information</a>
			</div>
			<div class="section">
			<a class="item2" href="">Email Messages</a>
			</div>
			<div class="section">
			<a class="item2" href="">News Messages</a>
			</div>
		</td>
		<td>
        	<a class="item1"  href="?curdoc=branch/branch_info&branchid=#client.userid#">My Information</a>
        </td>
		<td>
			<a class="item1" href="?curdoc=helpdesk/help_desk_list">Support</a>
			<div class="section">
			<a class="item2" href="index.cfm?curdoc=helpdesk/help_desk_list">New Ticket</a>
			</div>
		</td>

		<td height=24 width=13 background="pics/header_rightcap.gif">
    </tr>
</table>

<!--- Menu for all other USERS --->	
<cfelseif client.usertype LTE '7' OR client.usertype EQ '9'>
<table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">

	<tr bgcolor=##D1E0EF>
	

		<td height=24 width=13 background="pics/header_leftcap.gif"></td>
        <td>
            <a class="item1" href="?curdoc=students">Students</a>
            <div class="section">
			<cfif client.usertype lte 4>
                <a class="item2" href="?curdoc=app_process/apps_received&student_placed=received&regionid=All">Received</a>
			</cfif>
				<a class="item2 arrow" href="?curdoc=students&student_placed=no">Unplaced</a>
				
				<cfif client.usertype NEQ '9'>
				<a class="item2" href="?curdoc=students&student_placed=yes">Placed</a>
                <a class="item2 arrow" href="?curdoc=students&student_placed=all">All</a>
				<a class="item2 arrow" href="?curdoc=advanced_search">Search</a>
				</cfif>
               <!----
			    <div class="section">
                    <a class="item2" href="example1.html">Overview</a>
                    <a class="item2 arrow" href="javascript:void(0)">Live Demo<img src="images/arrow1.gif" width="10" height="12" alt="" /></a>
                </div>---->
            </div>
        </td>
		<td>
			<a class="item1" href="?curdoc=host_fam">Host Families</a>
		</td>
		<td>
			<a class="item1" href="?curdoc=schools">Schools</a>
		</td>
		<td>
            <a class="item1" href="?curdoc=users">Users</a>
			<div class="section">
				<cfif client.usertype LTE 4>
					<a class="item2" href="?curdoc=users&user_type=8">Intl. Reps.</a>
					<a class="item2" href="?curdoc=users&user_type=office">Office</a>
				</cfif>
                <a class="item2" href="?curdoc=user_info&userid=#client.userid#">My Information</a>
            </div>
        </td>
		<Cfif client.usertype LTE 4>
 			<cfquery name="invoice_check" datasource="caseusa">
				select invoice_access 
				from smg_users
				where userid = #client.userid#
			</cfquery>
			
			<cfif invoice_check.invoice_Access is 1>
			<td>
				<a class="item1" href="?curdoc=invoice/invoice_index&Requesttimeout=300">Invoicing</a>
				<div class="section">
					<a class="item2" href="?curdoc=invoice/reports/statement">Account Statement</a>
					<a class="item2" href="?curdoc=invoice/reports/statement_detailed">CASE Detailed Statement</a>
					<a class="item2" href="?curdoc=invoice/reports/check_fees_menu">Check Fees Per Intl. Rep</a>
					<a class="item2" href="?curdoc=invoice/int_rep_rates">Intl. Rep. Rates</a>
				</div>
			</td>
			</cfif>
		</Cfif>
        <td>
            <a class="item1" href="?curdoc=pdf_docs/docs_forms">PDF Docs</a>
        </td>
        <td>
            <cfif client.usertype NEQ '9'>
			<a class="item1" href="?curdoc=reports/index">Reports</a>
            </cfif>
			<cfif client.usertype LTE 4>
			 <div class="section">
				<a class="item2" href="?curdoc=reports/sele_program">Program Statistics</a>
				<a class="item2" href="?curdoc=reports/graphics_menu">Statistical Graphics</a>
			</div>
			</cfif> 
        </td>
		<td>
		<cfif client.usertype LTE 4>
            <a class="item1" href="javascript:void(0)">Tools</a>
			<div class="section">
            <a class="item2" href="index.cfm?curdoc=web_contacts">Web Contacts</a>
				<cfif client.usertype LTE 2 OR user_compliance.compliance EQ '1'> <!--- #COMPLIANCE --->
				<a class="item2" href="index.cfm?curdoc=tools/frm_transfer_files">Transfer Files</a>
				<a class="item2" href="index.cfm?curdoc=cbc/cbc_menu">CBC Batch</a>
				<div class="section">
					<a class="item2" href="index.cfm?curdoc=cbc/re_run_menu">Re-Run CBCs</a>	
				</div>				
				<a class="item2" href="index.cfm?curdoc=cbc/combine_hosts">Combining Hosts</a>
				</cfif>
				<a class="item2" href="index.cfm?curdoc=compliance/combine_schools">Combining Schools</a>
				<a class="item2" href="index.cfm?curdoc=insurance/insurance_menu">Caremed Insurance Files</a>
				<div class="section">
					<a class="item2" href="index.cfm?curdoc=insurance/insurance_codes">Caremed Policy Codes</a>	
				</div>
				<a class="item2" href="index.cfm?curdoc=insurance/vsc_menu">VSC Insurance Files</a>
				<a class="item2" href="index.cfm?curdoc=forms/supervising_placement_payments">Rep Payments</a>
				<a class="item2" href="index.cfm?curdoc=tools/countries">Countries</a>
				<!---
				<a class="item2" href="anonftp/" target="_top">FTP/Uploaded Files</a>
				<div class="section">
					<a class="item2" href="anonftp/upi">UPI Files</a>
				</div>
				---->
				<a class="item2" href="index.cfm?curdoc=tools/programs">Programs</a>
				<a class="item2" href="index.cfm?curdoc=tools/regions">Regions</a>
				<a class="item2" href="index.cfm?curdoc=tools/progress_report_questions">PR Questions</a>
				<a class="item2" href="index.cfm?curdoc=poll/poll_results">Poll Results</a>
				<a class="item2" href="index.cfm?curdoc=sevis/menu">SEVIS Batch</a>
				<div class="section">
					<a class="item2" href="index.cfm?curdoc=sevis_test/menu">SEVIS Batch Test</a>	
				</div>
				<cfif client.usertype lte 4>
                	<a class="item2" href="?curdoc=tools/student-tours/index">Student Tours</a>
				</cfif>
				<a class="item2" href="index.cfm?curdoc=forms/update_alerts">System Messages</a>
				<a class="item2" href="index.cfm?curdoc=tools/smg_welcome_pictures">Welcome Pictures</a>
			</cfif>	
			</div>
		</td>
		<cfif client.usertype GTE '5'>
		<td>
            <a class="item1" href="?curdoc=support">Support</a>
		</td>
		<cfelse>
		<!----
		<td>
			<a class="item1" href="?curdoc=helpdesk/help_desk_list">Help Desk</a>
			<div class="section">
			<a class="item2" href="index.cfm?curdoc=helpdesk/help_desk_list">New Ticket</a>
		
			<a class="item2" href="index.cfm?curdoc=helpdesk/help_desk_sections">Sections</a>
			<a class="item2" href="">Search</a>
			</div>
		</td>
		---->
		</cfif>
		<cfquery name="webmail" datasource="mysql">
		select email, password
		from smg_users
		where userid = #client.userid#
		</cfquery>
		<td>
		
			<a class="item1" href="http://webmail.case-usa.org/" target="_blank">Webmail</a>
	
		</td>

		<td height=24 width=13 background="pics/header_rightcap.gif">
    </tr>
    </table>
	</cfif>
  </cfoutput>
    <script type="text/javascript">
    var ddmx = new DropDownMenuX('menu1');
    ddmx.delay.show = 0;
    ddmx.delay.hide = 400;
    ddmx.position.levelX.left = 2;
    ddmx.init();
    </script>
</body>
</html>