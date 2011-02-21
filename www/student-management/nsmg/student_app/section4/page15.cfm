<cfif cgi.http_host is 'jan.case-usa.org' or cgi.http_host is 'www.case-usa.org'>
	<cfset client.org_code = 10>
	<cfset bgcolor ='ffffff'>    
<cfelse>
    <cfset client.org_code = 5>
    <cfset bgcolor ='B5D66E'>  
</cfif>

<cfquery name="org_info" datasource="mysql">
    select *
    from smg_companies
    where companyid = #client.org_code#
</cfquery>

<cftry>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cflocation url="?curdoc=section4/page15print&id=4&p=15" addtoken="no">
</cfif>

<script>
function areYouSure() { 
   if(confirm("You are about to delete your program agreement.  You will need to re-upload this file and you will not be able to recover this information. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

	<cfset doc = 'page15'>
    
    <!--- HEADER OF TABLE --->
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr height="33">
            <td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
            <td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
            <td class="tablecenter"><h2>Page [15] - Program Agreement</h2></td>
            <td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page15print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
            <td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
        </tr>
    </table>
    
    <div class="section"><br>
    
        <!--- Check uploaded file - Upload File Button --->
        <cfinclude template="../check_uploaded_file.cfm">
        
        <cfinclude template="page15text.cfm">

	</div>
        
    <table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
        <tr>
            <td align="center" valign="bottom" class="buttontop">
                <form action="?curdoc=section4/page16&id=4&p=16" method="post">
                <input name="Submit" type="image" src="pics/next_page.gif" border=0 alt="Go to the next page">
                </form>
            </td>
        </tr>
    </table>

<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>