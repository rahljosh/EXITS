<script src="/nsmg/SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
<link href="/nsmg/SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />

<!--- Menu for Int. Agents --->
<cfif client.usertype EQ 8>

    <ul id="MenuBar1" class="MenuBarHorizontal">
    
      <li><a href="index.cfm?curdoc=intrep/int_students">Students</a>
        <ul>
          <li><a href="index.cfm?curdoc=intrep/int_students&placed=no">Unplaced</a></li>
          <li><a href="index.cfm?curdoc=intrep/int_students&placed=yes">Placed</a></li>
          <li><a href="index.cfm?curdoc=intrep/int_students&placed=all">All</a></li>
          <li><a href="index.cfm?curdoc=intrep/advanced_search">Advanced Search</a></li>
          <li><a href="index.cfm?curdoc=intrep/int_php_students">Private High School</a></li>
        </ul>
      </li>

      <li><a href="index.cfm?curdoc=branch/branches">Branches</a>
        <ul>
          <li><a href="index.cfm?curdoc=branch/add_branch">Add Branch</a></li>
          <li><a href="index.cfm?curdoc=branch/branches">View Branches</a></li>
        </ul>
      </li>

      <li><a href="#">Tools</a>
        <ul>
          <li><a href="index.cfm?curdoc=intrep/students_missing_flight_info">Flight Information</a></li>
          <li><a href="index.cfm?curdoc=intrep/email_welcome">Email Messages</a></li>
          <li><a href="index.cfm?curdoc=intrep/update_alerts">News Messages</a></li>
          <li><a href="index.cfm?curdoc=intrep/reports/labels_select_pro">Generate ID Cards</a></li>
        </ul>
      </li>

      <li><a href="index.cfm?curdoc=user_info&userid=<cfoutput>#client.userid#</cfoutput>">My Info</a></li>

      <li><a href="index.cfm?curdoc=helpdesk/help_desk_list">Support</a></li>

      <li><a href="/smgstore/index.htm" target="_blank">Store</a></li>

    </ul>

<!--- INTL BRANCHES --->
<cfelseif client.usertype EQ 11>	

    <ul id="MenuBar1" class="MenuBarHorizontal">
    
      <li><a href="index.cfm?curdoc=intrep/int_students">Students</a>
        <ul>
          <li><a href="index.cfm?curdoc=intrep/int_students&placed=no">Unplaced</a></li>
          <li><a href="index.cfm?curdoc=intrep/int_students&placed=yes">Placed</a></li>
          <li><a href="index.cfm?curdoc=intrep/int_students&placed=all">All</a></li>
        </ul>
      </li>

      <li><a href="index.cfm?curdoc=helpdesk/help_desk_list">Tools</a>
        <ul>
          <li><a href="index.cfm?curdoc=intrep/int_flight_info">Flight Information</a></li>
        </ul>
      </li>

      <li><a href="index.cfm?curdoc=branch/branch_info&branchid=<cfoutput>#client.userid#</cfoutput>">My Info</a></li>

      <li><a href="index.cfm?curdoc=helpdesk/help_desk_list">Support</a></li>

      <li><a href="/smgstore/index.htm" target="_blank">Store</a></li>

    </ul>

<!--- Menu for all other USERS --->	
<cfelse>

    <ul id="MenuBar1" class="MenuBarHorizontal">
    
      <li><a href="index.cfm?curdoc=students">Students</a>
    <cfif client.usertype LTE 4>
        <ul>
          <li><a href="index.cfm?curdoc=app_process/apps_received">Received</a></li>
        </ul>
    </cfif>
      </li>
      
      <li><a href="index.cfm?curdoc=host_fam">Host Families</a></li>
      
      <li><a href="index.cfm?curdoc=schools">Schools</a></li>
      
      <li><a href="index.cfm?curdoc=users">Users</a>
        <ul>
          <li><a href="index.cfm?curdoc=user_info&userid=<cfoutput>#client.userid#</cfoutput>">My Information</a></li>
        </ul>
      </li>
    
    <cfif client.invoice_Access EQ 1>
      <li><a href="index.cfm?curdoc=invoice/invoice_index&Requesttimeout=300">Invoicing</a>
        <ul>
          <!--- <li><a href="index.cfm?curdoc=invoice/reports/statement">Account Statement</a></li> --->
          <li><a href="index.cfm?curdoc=invoice/reports/statement_detailed" target="_blank">SMG Detailed Statement</a></li>
          <li><a href="index.cfm?curdoc=invoice/reports/check_fees_menu" target="_blank">Check Fees Per Intl. Rep</a></li>
          <!--- <li><a href="index.cfm?curdoc=invoice/int_rep_rates">Intl. Rep. Rates</a></li> --->
          <li><a href="index.cfm?curdoc=invoice/m_hs_invoiceBatch" target="_blank">HS Invoice Batch</a></li>
		  <li><a href="" onClick="javaScript:win=window.open('invoice/m_payment.cfm', '_blank', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=800, height=800'); win.opener=self; return false;">Payments Received</a></li>
        </ul>
    </cfif>
    
      <li><a href="index.cfm?curdoc=pdf_docs/docs_forms">PDF Docs</a></li>
    
    <cfif client.usertype NEQ 9>
      <li><a href="index.cfm?curdoc=reports/index">Reports</a></li>
    </cfif>

    <!---<cfif client.usertype NEQ 9>
      <li><a href="index.cfm?curdoc=reports/index">Reports</a>
      <cfif client.usertype LTE 4>
        <ul>
          <li><a href="index.cfm?curdoc=reports/sele_program">Program Statistics</a></li>
          <li><a href="index.cfm?curdoc=reports/graphics_menu">Statistical Graphics</a></li>
        </ul>
      </cfif>
      </li>
    </cfif>--->
			  

    
    <cfif client.usertype LTE 4>
      <li><a href="#">Tools</a>
        <ul>
      <cfif client.usertype LTE 2 OR client.compliance EQ 1>
          <li><a href="index.cfm?curdoc=cbc/cbc_menu">CBC Batch</a>
            <ul>
              <li><a href="index.cfm?curdoc=cbc/re_run_menu">Re-Run CBCs</a></li>
            </ul>
          </li>
          <li><a href="index.cfm?curdoc=cbc/combine_hosts">Combining Hosts</a></li>
      </cfif>
          <li><a href="index.cfm?curdoc=compliance/combine_schools">Combining Schools</a></li>
          <li><a href="index.cfm?curdoc=insurance/insurance_menu">Caremed Insurance Files</a>
            <ul>
              <li><a href="index.cfm?curdoc=insurance/insurance_codes">Caremed Policy Codes</a></li>
            </ul>
          </li>
          <li><a href="index.cfm?curdoc=insurance/vsc_menu">VSC Insurance Files</a></li>
          <li><a href="index.cfm?curdoc=forms/supervising_placement_payments">Rep Payments</a></li>
          <li><a href="index.cfm?curdoc=tools/countries">Countries</a></li>
          <li><a href="index.cfm?curdoc=tools/programs">Programs</a></li>
          <li><a href="index.cfm?curdoc=tools/regions">Regions</a></li>
          <li><a href="index.cfm?curdoc=tools/reports/index">Reports</a></li>
          <li><a href="index.cfm?curdoc=tools/progress_report_questions">PR Questions</a></li>
          <li><a href="index.cfm?curdoc=poll/poll_results">Poll Results</a></li>
          <li><a href="index.cfm?curdoc=sevis/menu">SEVIS Batch</a>
            <ul>
              <li><a href="index.cfm?curdoc=sevis_test/menu">SEVIS Batch Test</a></li>
            </ul>
          </li>
          <li><a href="index.cfm?curdoc=forms/update_alerts">System Messages</a></li>
          <li><a href="index.cfm?curdoc=tools/student-tours/index">Student Tours</a></li>
          <li><a href="index.cfm?curdoc=tools/smg_welcome_pictures">Welcome Pictures</a></li>
        </ul>
      </li>
    </cfif>
    
    <cfif client.usertype LTE 4>
      <li><a href="index.cfm?curdoc=helpdesk/help_desk_list">Help Desk</a>
        <ul>
          <li><a href="index.cfm?curdoc=helpdesk/hd_list_exits">EXITS</a></li>
          <li><a href="index.cfm?curdoc=helpdesk/help_desk_sections">Sections</a></li>
        </ul>
      </li>
    <cfelse>
      <li><a href="index.cfm?curdoc=support">Support</a></li>
    </cfif>
    
    <cfswitch expression="#client.companyid#">
    <cfcase value="1">
      <li><a href="http://webmail.iseusa.com/" target="_blank">Webmail</a></li>
    </cfcase>
    <cfcase value="2">
      <li><a href="http://webmail.intoedventures.org/" target="_blank">Webmail</a></li>
    </cfcase>
    <cfcase value="3">
      <li><a href="http://webmail.asainternational.com/" target="_blank">Webmail</a></li>
    </cfcase>
    <cfcase value="4">
      <li><a href="http://webmail.dmdusa.com/" target="_blank">Webmail</a></li>
    </cfcase>
    <cfcase value="5">
      <li><a href="http://webmail.student-management.com/" target="_blank">Webmail</a></li>
    </cfcase>
    </cfswitch>
    
      <li><a href="/smgstore/index.htm" target="_blank">Store</a></li>
      
    </ul>

</cfif>

<script type="text/javascript">
<!--
var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"/nsmg/SpryAssets/SpryMenuBarDownHover.gif", imgRight:"/nsmg/SpryAssets/SpryMenuBarRightHover.gif"});
//-->
</script>