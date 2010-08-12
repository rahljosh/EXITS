<script src="/internal/SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
<link href="/internal/SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />

<!--- INTERNATIONAL REPS --->
<cfif CLIENT.usertype EQ 8>

    <ul id="MenuBar1" class="MenuBarHorizontal">
    
      <li><a href="index.cfm?curdoc=lists/students">Students</a>
        <ul>
          <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=yes&status=active">Placed with Host</a></li>
          <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=all&status=active">All</a></li>
        </ul>
      </li>
      
      <li><a href="index.cfm?curdoc=lists/schools">Schools</a></li>
    
      <li><a href="index.cfm?curdoc=users/user_info&userid=<cfoutput>#CLIENT.userid#</cfoutput>">My&nbsp;Info</a></li>
    
      <li><a href="index.cfm?curdoc=intrep/students_missing_flight_info">Flight&nbsp;Info</a></li>
	<!---- if this is added back, a Tools menu should be added with this and flight info as dropdown items
	<a href="index.cfm?curdoc=intrep/reports/labels_select_pro">Generate ID Cards</a>---->
    
      <li><a href="index.cfm?curdoc=pdf_docs/docs_forms">PDF&nbsp;Docs</a></li>
           
    </ul>

<cfelseif CLIENT.usertype GTE 5 AND CLIENT.usertype LTE 12>

    <ul id="MenuBar1" class="MenuBarHorizontal">
    
      <li><a href="index.cfm?curdoc=lists/students">Students</a>
        <ul>
          <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=no&status=active">Unplaced</a></li>
          <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=yes&status=active">Placed</a></li>
          <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=all&status=active">All</a></li>
        </ul>
      </li>
      
      <li><a href="index.cfm?curdoc=lists/hosts">Host&nbsp;Families</a></li>
      
      <cfif CLIENT.usertype NEQ 12>
      	<li><a href="index.cfm?curdoc=users/user_info&userid=<cfoutput>#CLIENT.userid#</cfoutput>">My&nbsp;Info</a></li>
      </cfif>
    
      <li><a href="index.cfm?curdoc=lists/schools">Schools</a></li>
    
      <li><a href="index.cfm?curdoc=pdf_docs/docs_forms">PDF&nbsp;Docs</a></li>
           
    </ul>

<!--- OFFICE USER ---->	
<cfelseif CLIENT.usertype LTE 4>

    <ul id="MenuBar1" class="MenuBarHorizontal">
    
      <li><a href="index.cfm?curdoc=lists/students">Students</a>
        <ul>
          <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=no&status=active">Unplaced</a></li>
          <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=yes&status=active">Placed</a></li>
          <li><a href="index.cfm?curdoc=lists/students&order=studentid&placed=all&status=active">All</a></li>
        </ul>
      </li>
      
      <li><a href="index.cfm?curdoc=lists/hosts">Host&nbsp;Families</a></li>

      <li><a href="index.cfm?curdoc=lists/schools">Schools</a></li>
      
      <li><a href="index.cfm?curdoc=lists/users">Users</a>
        <ul>
          <li><a href="index.cfm?curdoc=users/user_info&userid=<cfoutput>#CLIENT.userid#</cfoutput>">My Info</a></li>
          <li><a href="index.cfm?curdoc=lists/users">U.S. Users</a></li>
          <li><a href="index.cfm?curdoc=lists/users&usertype=intagent">International Partners</a></li>
          <li><a href="index.cfm?curdoc=users/user_assign_question">Add New User</a></li>
        </ul>
      </li>

	<cfif CLIENT.invoice_access EQ 1>
      <li><a href="index.cfm?curdoc=invoice/invoice_index">Invoicing</a></li>
    </cfif>

      <li><a href="index.cfm?curdoc=pdf_docs/docs_forms">PDF&nbsp;Docs</a></li>

      <li><a href="index.cfm?curdoc=reports/reports_menu">Reports</a>
        <ul>
          <li><a href="index.cfm?curdoc=reports/menu_id_cards">ID Cards & Labels</a></li>
        </ul>
      </li>

      <li><a href="#">Tools</a>
        <ul>
        	<li><a href="index.cfm?curdoc=reports/manager_reports">Flight Reports</a></li>
		  <cfif CLIENT.usertype LTE 3>
              <li><a href="index.cfm?curdoc=invoice/intl_rep_insurance">Intl. Rep Insurance Policy</a></li>
          </cfif>
		  <li><a href="index.cfm?curdoc=insurance/menu">Insurance Files</a></li>
          <!--- 
		  Removed - Marcus Melo 10/22/2009
          <li><a href="index.cfm?curdoc=insurance/caremed_menu">Caremed Insurance</a></li>
          <li><a href="index.cfm?curdoc=insurance/vsc_menu">VSC Insurance</a></li>
		  --->
          <li><a href="index.cfm?curdoc=tools/progress_report_questions">PR Questions</a></li>
          <li><a href="index.cfm?curdoc=tools/programs">Programs</a></li>
          <cfif client.userid eq 1>
           <li><a href="index.cfm?curdoc=forms/supervising_placement_payments">Rep Payments</a></li>
          </cfif>
          <li><a href="index.cfm?curdoc=tools/returning_j1_students">Returning Students J1 to F1</a></li>
          <li><a href="index.cfm?curdoc=forms/update_alerts">System Messages</a></li>
          <li><a href="index.cfm?curdoc=reports/select_batch">Welcome Letter Batch</a></li>
        </ul>
      </li>

      <li><a href="index.cfm?curdoc=helpdesk/help_desk_list">Support</a></li>

      <li><a href="http://webmail.phpusa.com" target="_blank">Webmail</a></li>
           
    </ul>

</cfif>

<script type="text/javascript">
<!--
var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"/internal/SpryAssets/SpryMenuBarDownHover.gif", imgRight:"/internal/SpryAssets/SpryMenuBarRightHover.gif"});
//-->
</script>
