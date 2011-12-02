<link rel="stylesheet" type="text/css" href="../menu.css" />
<script type="text/javascript" src="ie5.js"></script>
<script type="text/javascript" src="DropDownMenuX.js"></script>

<cfoutput>

<cfquery name="get_user_uniqueid" datasource="MySql">
	SELECT userid, uniqueid
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<cfquery name="webmail" datasource="mysql">
	SELECT email, password
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>		
	
<!--- Menu for all other USERS --->
<table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">
	<tr bgcolor=##cfcfcf>
			<td bgcolor="##8FB6C9">
			<a class="item1" href="?curdoc=candidate/candidates">Candidates</a>
			<div class="section" bgcolor="8FB6C9">
			<a class="item2" href="?curdoc=candidate/candidates&status=1">List &nbsp; &nbsp;&nbsp;&nbsp;</a>
			<a class="item2" href="?curdoc=candidate/new_candidate">Add &nbsp;&nbsp;&nbsp;&nbsp;</a>				
			<a class="item2" href="?curdoc=candidate/search&search=0">Search</a>
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
	    <td bgcolor="##8FB6C9">
			<a class="item1" href="?curdoc=reports/index">Reports</a>
			<div class="section">
				<a class="item2" href="?curdoc=reports/students_per_company">Students hired per company</a>	
				<a class="item2" href="?curdoc=reports/ds2019_list_select_pro">DS2019/Verification Reports</a>	 
				<a class="item2" href="?curdoc=reports/active_students_email">Active Trainee Emails</a>	 
			</div>
		</td>
		<td bgcolor="##8FB6C9">
            <a class="item1" href="">Tools</a>
            <div class="section">
				<a class="item2" href="?curdoc=tools/idcards_select">ID Cards</a>
                <a class="item2" href="?curdoc=insurance/insurance_menu">Insurance</a>
					<div class="section">
						<a class="item2" href="?curdoc=insurance/intl_rep_insurance">Intl. Rep Insurance Type</a>
						<a class="item2" href="?curdoc=insurance/insurance_policies">Insurance Policies</a>
					</div>
				<a class="item2" href="?curdoc=tools/labels_select_pro">Labels</a>
				<a class="item2" href="?curdoc=tools/programs">Programs &nbsp;</a>
                <a class="item2" href="?curdoc=tools/quaterlyReports">Quaterly Reports</a>
            	<a class="item2" href="?curdoc=tools/traineeEvaluations">Trainee Evaluations</a>
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
		<td bgcolor="##8FB6C9"><a class="item1" href="https://mail.student-management.com/mail/login.html??username=#webmail.email#&password=#webmail.password#" target="_blank">Webmail</a></td>
	</tr>
</table>

</cfoutput>