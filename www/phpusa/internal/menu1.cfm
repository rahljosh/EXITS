<link rel="stylesheet" type="text/css" href="menu.css" />
<script type="text/javascript" src="ie5.js"></script>
<script type="text/javascript" src="DropDownMenuX.js"></script>

<cfoutput>

<cfif client.usertype EQ 0>
	<table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">
		<tr bgcolor="##cfcfcf">
			<th>You currently have no privileges on this website. Please contact luke@phpusa.com</th>
		</tr>
	</table>
	<cfabort>
</cfif>

<!--- INTERNATIONAL REPS --->
<cfif client.usertype EQ 8>
<table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">
	<tr bgcolor="##cfcfcf">
        <td>
            <a class="item1" href="?curdoc=lists/students&RequestTimeout=300">Students</a>
		    <div class="section">
				<a class="item2" href="?curdoc=lists/students&order=studentid&placed=yes&status=active&RequestTimeout=300">Placed with Host</a>
				<a class="item2" href="?curdoc=lists/students&order=studentid&placed=all&status=active&RequestTimeout=300">All</a>
				<a class="item2" href="?curdoc=student/search">Search</a>
            </div>
        </td>
		<!--- <td><a class="item1"  href="?curdoc=lists/hosts">Host Families</a></td> --->
		<td><a class="item1"  href="?curdoc=lists/schools">Schools</a></td>
		<td>
           <a href="" class="item1">Users</a>
            <div class="section">
				<a class="item2" href="?curdoc=users/user_info&userid=#client.userid#">My Info</a>
			</div>
        </td>
		<td><a class="item1" href="?curdoc=pdf_docs/docs_forms">PDF Docs</a></td>
		<td><a class="item1" href="http://www.phpusa.com/support/support-center/" target="_top">Support</a></td>
    </tr>
</table>

<!--- SCHOOL ACCESS --->
<cfelseif client.usertype EQ 12>
	<table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">
		<tr bgcolor="##cfcfcf">
			<td>
				<a class="item1" href="?curdoc=lists/students">Students</a>
				<div class="section">
					<a class="item2" href="?curdoc=lists/students&order=studentid&placed=no&status=active">Unplaced</a>
					<a class="item2" href="?curdoc=lists/students&order=studentid&placed=yes&status=active">Placed</a>
					<a class="item2" href="?curdoc=lists/students&order=studentid&placed=all&status=active">All</a>
					<a class="item2" href="?curdoc=student/search">Search</a>
				</div>
			</td>
			<td><a class="item1"  href="?curdoc=lists/hosts">Host Families</a></td>
			<td><a class="item1"  href="?curdoc=lists/schools">Schools</a></td>
			<td><a class="item1" href="?curdoc=pdf_docs/docs_forms">PDF Docs</a></td>
		</tr>
    </table>
	
<!--- AREA REPS --->
<cfelseif client.usertype GTE 5 AND client.usertype LTE 11>
	<table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">
		<tr bgcolor="##cfcfcf">
			<td>
				<a class="item1" href="?curdoc=lists/students">Students</a>
				<div class="section">
					<a class="item2" href="?curdoc=lists/students&order=studentid&placed=no&status=active">Unplaced</a>
					<a class="item2" href="?curdoc=lists/students&order=studentid&placed=yes&status=active">Placed</a>
					<a class="item2" href="?curdoc=lists/students&order=studentid&placed=all&status=active">All</a>
					<a class="item2" href="?curdoc=student/search">Search</a>
				</div>
			</td>
			<td><a class="item1"  href="?curdoc=lists/hosts">Host Families</a></td>
					<td>
           <a href="" class="item1">Users</a>
            <div class="section">
				<a class="item2" href="?curdoc=users/user_info&userid=#client.userid#">My Info</a>
			</div>
        </td>
			<td><a class="item1"  href="?curdoc=lists/schools">Schools</a></td>
			<td><a class="item1" href="?curdoc=pdf_docs/docs_forms">PDF Docs</a></td>
		</tr>
	</table>

<!--- OFFICE USER ---->	
<cfelseif client.usertype GTE 1 AND client.usertype LTE 4>
<table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx">
	<tr bgcolor="##cfcfcf">
        <td>
            <a class="item1" href="?curdoc=lists/students">Students</a>
           
		    <div class="section">
				<a class="item2" href="?curdoc=lists/students&order=studentid&placed=no&status=active">Unplaced</a>
				<a class="item2" href="?curdoc=lists/students&order=studentid&placed=yes&status=active">Placed</a>
				<a class="item2" href="?curdoc=lists/students&order=studentid&placed=all&status=active">All</a>
				<a class="item2" href="?curdoc=student/search">Search</a>
            </div>
        </td>
		<td>
			<a class="item1"  href="?curdoc=lists/hosts">Host Families</a>
		</td>
		<td>
			<a class="item1"  href="?curdoc=lists/schools">Schools</a>
		</td>
		<td>
           <a class="item1" href="?curdoc=lists/users">Users</a>
            <div class="section">
				<a class="item2" href="?curdoc=users/user_info&userid=#client.userid#">My Info</a>
				<a class="item2" href="?curdoc=lists/users">U.S. Users</a>
				<a class="item2" href="?curdoc=lists/users&usertype=intagent">International Partners</a>
				<a class="item2" href="index.cfm?curdoc=users/user_assign_question">Add New User</a>
			</div>
        </td>
 			<cfquery name="invoice_check" datasource="mysql">
				SELECT invoice_Access 
				FROM smg_users
				WHERE userid = '#client.userid#'
			</cfquery>
			<cfif invoice_check.invoice_Access is 1>
				<td><a class="item1" href="?curdoc=invoice/invoice_index">Invoicing</a></td>
			<cfelse>
				<td><a class="item1" href="?curdoc=invoice/intl_rep_insurance">Intl. Rep. Insurance</a></td>
			</cfif>
		<td><a class="item1" href="?curdoc=pdf_docs/docs_forms">PDF Docs</a></td>
		<td>
			<a class="item1" href="?curdoc=reports/reports_menu">Reports</a>
            <div class="section">
				<a class="item2" href="?curdoc=reports/menu_id_cards">ID Cards & Labels</a>
			</div>
		</td>
		<td>
            <a class="item1" href="">Tools</a>
            <div class="section">
				<a class="item2" href="?curdoc=tools/returning_j1_students">Returning Students J1 to F1</a>
				<a class="item2" href="?curdoc=insurance/caremed_menu">Caremed Insurance</a>
				<a class="item2" href="?curdoc=tools/progress_report_questions">PR Questions</a>
				<a class="item2" href="?curdoc=insurance/vsc_menu">VSC Insurance</a>
				<a class="item2" href="?curdoc=tools/programs">Programs</a>
			</div>
		</td>
		<td><a class="item1" href="?curdoc=helpdesk/help_desk_list">Support</a></td>
		<cfquery name="webmail" datasource="mysql">
			select email, password
			from smg_users
			where userid = #client.userid#
		</cfquery>
		<td><a class="item1" href="http://webmail.phpusa.com/mail/login.html?username=#webmail.email#&password=#webmail.password#" target="_blank">Webmail</a></td>
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