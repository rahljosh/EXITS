<!--- ------------------------------------------------------------------------- ----
	
	File:		page26.cfm
	Author:		James Griffiths
	Date:		October 23, 2013
	Desc:		Birth Certificate

----- ------------------------------------------------------------------------- --->

<cfscript>
	if (CGI.HTTP_HOST IS "jan.case-usa.org" OR CGI.HTTP_HOST IS "www.case-usa.org") {
		CLIENT.org_code = 10;
		bgcolor = "FFFFFF";
	} else {
		CLIENT.org_code = 5;
		bgcolor = "B5D66E";
	}
	
	qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.org_code);
</cfscript>

<cftry>
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr height="33">
            <td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
            <td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
            <td class="tablecenter"><h2>Page [26] - Birth Certificate</h2></td>
            <td align="right" class="tablecenter"></td>
            <td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
        </tr>
    </table>
    <cfset doc = 'page26'>
    <div class="section">
        <br/>
        <cfinclude template="../check_uploaded_file.cfm">
        <table width="670px" cellpadding=3 cellspacing=0 align="center"></table>
    </div>
    <table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
        <tr>
            <td align="center" valign="bottom" class="buttontop">
            	<form action="?curdoc=section4/page27&id=4&p=27" method="post">
                    <input name="Submit" type="image" src="pics/next_page.gif" border=0 alt="Go to the next page">
                </form>
            </td>
        </tr>
    </table>
    
    <cfinclude template="../footer_table.cfm">
    
    <cfcatch type="any">
        <cfinclude template="../error_message.cfm">
    </cfcatch>

</cftry>