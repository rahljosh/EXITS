<!--- ------------------------------------------------------------------------- ----
	
	File:		page23.cfm
	Author:		James Griffiths
	Date:		October 23, 2013
	Desc:		Double Placement Authorization

----- ------------------------------------------------------------------------- --->
<cfparam name="URL.display" default="web"><!---web,print--->
<cfparam name="URL.printBlank" default="0">
<cfparam name="FORM.submitted" default="0">
<cfparam name="FORM.authorizeDoublePlacement" default="0">

<cfscript>
	if (CGI.HTTP_HOST IS "jan.case-usa.org" OR CGI.HTTP_HOST IS "www.case-usa.org") {
		CLIENT.org_code = 10;
		bgcolor = "FFFFFF";
	} else {
		CLIENT.org_code = 5;
		bgcolor = "B5D66E";
	}
	
	path = "";
	if (URL.display EQ "print") {
		path = "../";
		param name="vStudentAppRelativePath" default="../";
		param name="vUploadedFilesRelativePath" default="../../";
	}
	
	qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.org_code);
	qGetStudent = APPLICATION.CFC.STUDENT.getStudentByID(studentID=CLIENT.studentID);
	
	doc = 'page23';
</cfscript>

<script type="text/javascript">
	function changeAuthorization() {
		$('#authorizeDoublePlacement').val( ($('#authorizeDoublePlacement').val()*(-1))+1 );
		$('#authorizationForm').submit();
	}
</script>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<cftry>
	<cfoutput>
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
                <link rel="stylesheet" type="text/css" href="#path#app.css">
            </head>
            <body>
            
				<cfif URL.display EQ "print" AND NOT VAL(URL.printBlank)>
                    <cfinclude template="../print_include_file.cfm">
                <cfelse>
                    <cfset printpage = 'yes'>	
                </cfif>
                
                <cfif printpage EQ "yes">
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr height="33">
                            <td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
                            <td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
                            <td class="tablecenter"><h2>Page [22] - Double Placement Authorization</h2></td>
                            <td align="right" class="tablecenter">
                                <cfif URL.display EQ "web">
                                    <a href="" onClick="javascript: win=window.open('section4/page23.cfm?display=print', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;">
                                        <img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img>
                                    </a>
                                    &nbsp; &nbsp;
                                </cfif>
                            </td>
                            <td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
                        </tr>
                    </table>
                    
                    <div class="section">
                        <br/>
                        <cfif URL.display EQ "web">
                            <cfinclude template="../check_uploaded_file.cfm">
                        </cfif>
                        <br/>
                        
                        <table width="670px" cellpadding=3 cellspacing=0 align="center">
                            <tr>
                                <td colspan="7">
                                    In compliance with 22 CFR 62.25 i5 - I, #qGetStudent.firstName# #qGetStudent.familyLastName#, and we, as Parents of the Undersigned Student, do hereby authorize the exchange organization to place #qGetStudent.firstName# #qGetStudent.familyLastName# in a home with one additional exchange student.
                                </td>
                            </tr>
                            <tr><td colspan="7">&nbsp;</td></tr>
                            <tr>
                                <td width="210" style="padding-left:10px;"><br><img src="../pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
                                <td width="5"></td>
                                <td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="../pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>		
                                <td width="40"></td>
                                <td width="210"><br><img src="../pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
                                <td width="5"></td>
                                <td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="../pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>
                            </tr>
                            <tr>
                                <td style="padding-left:10px;">Signature of Parent</td>
                                <td></td>
                                <td>Date</td>
                                <td></td>
                                <td>Signature of Student</td>
                                <td></td>
                                <td>Date</td>	
                            </tr>
                        </table>
                    </div>
                    <cfif URL.display EQ "web">
                        <table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
                            <tr>
                                <td align="center" valign="bottom" class="buttontop">
                                    <form action="?curdoc=section4/page24&id=4&p=24" method="post">
                                        <input name="Submit" type="image" src="pics/next_page.gif" border=0 alt="Go to the next page">
                                    </form>
                                </td>
                            </tr>
                        </table>
                    </cfif>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr height="8">
                            <td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
                            <td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
                            <td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
                        </tr>
                    </table>
                </cfif>
            </body>
        </html>
	</cfoutput>
    
    <cfcatch type="any">
        <cfinclude template="../error_message.cfm">
    </cfcatch>

</cftry>