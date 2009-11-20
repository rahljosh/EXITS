    <style type="text/css">
    body {
        font: 11px tahoma;
        background: #ffffff;
        margin: 0;
    }    
    </style>
    <link rel="stylesheet" type="text/css" href="menu.css" />
	
    <script type="text/javascript" src="ie5.js"></script>
    <script type="text/javascript" src="DropDownMenuX.js"></script>

<cfoutput>
<table width=100%  cellpadding=0 cellspacing=0 id="menu1" class="ddmx" bgcolor="##cfcfcf">
	<tr>
		<td height=24 width=13 background="pics/header_leftcap.gif"></td>

        <td>
            <a class="item1" href="?curdoc=lists/students"><font Color="##0078a9">Students</a>
     		<div class="section">
			<a class="item2" href="?curdoc=lists/students">All</a>
			<a class="item2" href="?curdoc=forms/search_students">Search</a>
			</div>
          
        </td>
		
		  <td>
            <a class="item1"  href="?curdoc=lists/schools"><font Color=##0078a9>Schools</a>
			<div class="section">
			
			<a class="item2" href="index.cfm?curdoc=forms/search_schools">Search</a>
			</div>
          </td>
		    <td>
            <a class="item1"  href="?curdoc=lists/hosts"><font Color="##0078a9">Host Families</a>
			
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
			<a class="item1" href="?curdoc=lists/users"><font Color="##0078a9">Users</a>
			<div class="section">
			<a class="item2" href="?curdoc=forms/user_info&id=#client.userid#">My Info</a>
			<a class="item2" href="?curdoc=lists/users">U.S. Users</a>
			<a class="item2" href="?curdoc=lists/users&usertype=intagent">International Partners</a>
			</div>
		</td>
		<td>
            <a class="item1" href="?curdoc=lists/reports"><font Color="##0078a9">Reports</a>
		</td>
		
		<td>
            <a class="item1" href="?curdoc=forms/support"><font Color="##0078a9">Support</a>
		</td>
		<cfif client.usertype eq 1>
		<td>
		            <a class="item1" href=""><font Color="##0078a9">Tools</a>
			<div class="section">
				<a class="item2" href="index.cfm?curdoc=forms/update_alerts">System Messages</a>
			</td>
		</cfif>
		<td>
            <a class="item1" href="https://mail.student-management.com/mail/" target="_blank"><font Color="##0078a9">Webmail</a>
			
    <script type="text/javascript">
    var ddmx = new DropDownMenuX('menu1');
    ddmx.delay.show = 0;
    ddmx.delay.hide = 400;
    ddmx.position.levelX.left = 2;
    ddmx.init();
    </script>
		</td>
		
    </tr>
    </table>


</cfoutput>