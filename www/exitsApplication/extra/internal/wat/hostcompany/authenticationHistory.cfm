<!--- ------------------------------------------------------------------------- ----
	
	File:		authenticationHistory.cfm
	Author:		James Griffiths
	Date:		November 30, 2012
	Desc:		Shows the history of uploaded authentication files

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <cfparam name="URL.hostID" default="0">
    
    <cfquery name="qGetHost" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostcompany
        WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
    </cfquery>
    
    <cfquery name="qGetSecretaryOfState" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostauthenticationfiles
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="secretaryOfState">
        ORDER BY dateAdded ASC
    </cfquery>
    
    <cfquery name="qGetDepartmentOfLabor" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostauthenticationfiles
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departmentOfLabor">
        ORDER BY dateAdded ASC
    </cfquery>
    
    <cfquery name="qGetGoogleEarth" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostauthenticationfiles
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="googleEarth">
        ORDER BY dateAdded ASC
    </cfquery>
    
    <cfquery name="qGetIncorporationFile" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostauthenticationfiles
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="incorporation">
        ORDER BY dateAdded ASC
    </cfquery>
    
    <cfquery name="qGetCertificateOfExistenceFile" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostauthenticationfiles
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="certificateOfExistence">
        ORDER BY dateAdded ASC
    </cfquery>
    
    <cfquery name="qGetCertificateOfReinstatementFile" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostauthenticationfiles
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="certificateOfReinstatement">
        ORDER BY dateAdded ASC
    </cfquery>
    
    <cfquery name="qGetDepartmentOfStateFile" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostauthenticationfiles
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
        AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departmentOfState">
        ORDER BY dateAdded ASC
    </cfquery>
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../../style.css">
	<title>Host Company Authentication File History</title>
    <script type="text/javascript">
		var printAuthenticationFile = function(id) {
			var printURL = document.URL;
			printURL = printURL.substring(0, printURL.indexOf("/authenticationHistory.cfm"));
			printURL += "/imageUploadPrint.cfm?option=print&fileID="+id;
			window.open(printURL, "File", "width=800, height=600").print();
		}
		var deleteAuthenticationFile = function(id) {
			if (confirm("Are you sure you want to delete this file?")) {
				var deleteURL = document.URL;
				deleteURL = deleteURL.substring(0, deleteURL.indexOf("/authenticationHistory.cfm"));
				deleteURL += "/imageUploadPrint.cfm?option=delete&fileID="+id;
				var deleteWindow = window.open(deleteURL, id, "width=10, height=10");
				deleteWindow.onunload = function() {
					window.opener.location.reload();
					window.location.reload();
				}
			}
		}
	</script>
</head>
<body>

<cfoutput>

    <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="C7CFDC" bgcolor="FFFFFF">
    	<tr>
        	<td bordercolor="FFFFFF">
            	
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                	<tr valign="middle" height="24">
                    	<td align="right" class="title1">Host Company Authentication File History for #qGetHost.name# (###qGetHost.hostCompanyID#)</td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                </table>
                
                <table width="100%">
                	<tr>
                    	<!--- Secretary of State --->
                    	<td width="32%" valign="top" style="border:thin solid black">
                        	<table width="100%" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td class="style2" bgcolor="8FB6C9" align="center" colspan="4"><u>Business License</u></td>
                                </tr>
                                <tr>
                                	<td class="style2" bgcolor="8FB6C9">Date Added</td>
                                    <td class="style2" bgcolor="8FB6C9">Date Expired</td>
                                    <td class="style2" bgcolor="8FB6C9">View</td>
                                    <td class="style2" bgcolor="8FB6C9">Delete</td>
                                </tr>
                                <cfif qGetSecretaryOfState.recordcount EQ 0>
                                    <tr><td colspan="4" align="center" class="style1">There are no uploaded files.</td></tr>
                                <cfelse>
                                	<cfloop query="qGetSecretaryOfState">
                                    	<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                                        	<td>#DateFormat(dateAdded,'mm/dd/yyyy')#</td>
                                            <td>#DateFormat(dateExpires,'mm/dd/yyyy')#</td>
                                            <td><img src="../../pics/view.gif" alt="view" onClick="printAuthenticationFile('#id#')"/></td>
                                            <td><img src="../../pics/deletex.gif" alt="delete" onClick="deleteAuthenticationFile('#id#')"/></td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                            </table>
                        </td>
                        <!--- End Secretary of State --->
                        <td width="2%"></td>
                        <!--- Department of Labor --->
                        <td width="32%" valign="top" style="border:thin solid black">
                        	<table width="100%" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td class="style2" bgcolor="8FB6C9" align="center" colspan="4"><u>Department of Labor</u></td>
                                </tr>
                                <tr>
                                	<td class="style2" bgcolor="8FB6C9">Date Added</td>
                                    <td class="style2" bgcolor="8FB6C9">Date Expired</td>
                                    <td class="style2" bgcolor="8FB6C9">View</td>
                                    <td class="style2" bgcolor="8FB6C9">Delete</td>
                                </tr>
                                <cfif qGetDepartmentOfLabor.recordcount EQ 0>
                                    <tr><td colspan="4" align="center" class="style1">There are no uploaded files.</td></tr>
                                <cfelse>
                                	<cfloop query="qGetDepartmentOfLabor">
                                    	<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                                        	<td>#DateFormat(dateAdded,'mm/dd/yyyy')#</td>
                                            <td>#DateFormat(dateExpires,'mm/dd/yyyy')#</td>
                                            <td><img src="../../pics/view.gif" alt="view" onClick="printAuthenticationFile('#id#')"/></td>
                                            <td><img src="../../pics/deletex.gif" alt="delete" onClick="deleteAuthenticationFile('#id#')"/></td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                            </table>
                        </td>
                        <!--- End Department of Labor --->
                        <td width="2%"></td>
                        <!--- Google Earth --->
                        <td width="32%" valign="top" style="border:thin solid black">
                        	<table width="100%" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td class="style2" bgcolor="8FB6C9" align="center" colspan="4"><u>Google Earth</u></td>
                                </tr>
                                <tr>
                                	<td class="style2" bgcolor="8FB6C9">Date Added</td>
                                    <td class="style2" bgcolor="8FB6C9">Date Expired</td>
                                    <td class="style2" bgcolor="8FB6C9">View</td>
                                    <td class="style2" bgcolor="8FB6C9">Delete</td>
                                </tr>
                                <cfif qGetGoogleEarth.recordcount EQ 0>
                                    <tr><td colspan="4" align="center" class="style1">There are no uploaded files.</td></tr>
                                <cfelse>
                                	<cfloop query="qGetGoogleEarth">
                                    	<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                                        	<td>#DateFormat(dateAdded,'mm/dd/yyyy')#</td>
                                            <td>#DateFormat(dateExpires,'mm/dd/yyyy')#</td>
                                            <td><img src="../../pics/view.gif" alt="view" onClick="printAuthenticationFile('#id#')"/></td>
                                            <td><img src="../../pics/deletex.gif" alt="delete" onClick="deleteAuthenticationFile('#id#')"/></td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                            </table>
                        </td>
                        <!--- End Google Earth --->
                    </tr>
                    <tr><td colspan="6">&nbsp;</td></tr>
                    <tr>
                    	<!--- Incorporation --->
                    	<td width="32%" valign="top" style="border:thin solid black">
                        	<table width="100%" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td class="style2" bgcolor="8FB6C9" align="center" colspan="4"><u>Incorporation</u></td>
                                </tr>
                                <tr>
                                	<td class="style2" bgcolor="8FB6C9">Date Added</td>
                                    <td class="style2" bgcolor="8FB6C9">Date Expired</td>
                                    <td class="style2" bgcolor="8FB6C9">View</td>
                                    <td class="style2" bgcolor="8FB6C9">Delete</td>
                                </tr>
                                <cfif qGetIncorporationFile.recordcount EQ 0>
                                    <tr><td colspan="4" align="center" class="style1">There are no uploaded files.</td></tr>
                                <cfelse>
                                	<cfloop query="qGetIncorporationFile">
                                    	<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                                        	<td>#DateFormat(dateAdded,'mm/dd/yyyy')#</td>
                                            <td>#DateFormat(dateExpires,'mm/dd/yyyy')#</td>
                                            <td><img src="../../pics/view.gif" alt="view" onClick="printAuthenticationFile('#id#')"/></td>
                                            <td><img src="../../pics/deletex.gif" alt="delete" onClick="deleteAuthenticationFile('#id#')"/></td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                            </table>
                        </td>
                        <!--- End Incorporation --->
                        <td width="2%"></td>
                        <!--- Certificate of Existence --->
                        <td width="32%" valign="top" style="border:thin solid black">
                        	<table width="100%" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td class="style2" bgcolor="8FB6C9" align="center" colspan="4"><u>Certificate of Existence</u></td>
                                </tr>
                                <tr>
                                	<td class="style2" bgcolor="8FB6C9">Date Added</td>
                                    <td class="style2" bgcolor="8FB6C9">Date Expired</td>
                                    <td class="style2" bgcolor="8FB6C9">View</td>
                                    <td class="style2" bgcolor="8FB6C9">Delete</td>
                                </tr>
                                <cfif qGetCertificateOfExistenceFile.recordcount EQ 0>
                                    <tr><td colspan="4" align="center" class="style1">There are no uploaded files.</td></tr>
                                <cfelse>
                                	<cfloop query="qGetCertificateOfExistenceFile">
                                    	<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                                        	<td>#DateFormat(dateAdded,'mm/dd/yyyy')#</td>
                                            <td>#DateFormat(dateExpires,'mm/dd/yyyy')#</td>
                                            <td><img src="../../pics/view.gif" alt="view" onClick="printAuthenticationFile('#id#')"/></td>
                                            <td><img src="../../pics/deletex.gif" alt="delete" onClick="deleteAuthenticationFile('#id#')"/></td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                            </table>
                        </td>
                        <!--- End Certificate of Existence --->
                        <td width="2%"></td>
                        <!--- Certificate of Reinstatement --->
                        <td width="32%" valign="top" style="border:thin solid black">
                        	<table width="100%" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td class="style2" bgcolor="8FB6C9" align="center" colspan="4"><u>Certificate of Reinstatement</u></td>
                                </tr>
                                <tr>
                                	<td class="style2" bgcolor="8FB6C9">Date Added</td>
                                    <td class="style2" bgcolor="8FB6C9">Date Expired</td>
                                    <td class="style2" bgcolor="8FB6C9">View</td>
                                    <td class="style2" bgcolor="8FB6C9">Delete</td>
                                </tr>
                                <cfif qGetCertificateOfReinstatementFile.recordcount EQ 0>
                                    <tr><td colspan="4" align="center" class="style1">There are no uploaded files.</td></tr>
                                <cfelse>
                                	<cfloop query="qGetCertificateOfReinstatementFile">
                                    	<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                                        	<td>#DateFormat(dateAdded,'mm/dd/yyyy')#</td>
                                            <td>#DateFormat(dateExpires,'mm/dd/yyyy')#</td>
                                            <td><img src="../../pics/view.gif" alt="view" onClick="printAuthenticationFile('#id#')"/></td>
                                            <td><img src="../../pics/deletex.gif" alt="delete" onClick="deleteAuthenticationFile('#id#')"/></td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                            </table>
                        </td>
                        <!--- End Certificate of Reinstatement --->
                    </tr>
                    <tr><td colspan="6">&nbsp;</td></tr>
                    <tr>
                    	<!--- Department of State --->
                        <td width="32%" valign="top" style="border:thin solid black">
                        	<table width="100%" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td class="style2" bgcolor="8FB6C9" align="center" colspan="4"><u>Department of State</u></td>
                                </tr>
                                <tr>
                                	<td class="style2" bgcolor="8FB6C9">Date Added</td>
                                    <td class="style2" bgcolor="8FB6C9">Date Expired</td>
                                    <td class="style2" bgcolor="8FB6C9">View</td>
                                    <td class="style2" bgcolor="8FB6C9">Delete</td>
                                </tr>
                                <cfif qGetDepartmentOfStateFile.recordcount EQ 0>
                                    <tr><td colspan="4" align="center" class="style1">There are no uploaded files.</td></tr>
                                <cfelse>
                                	<cfloop query="qGetDepartmentOfStateFile">
                                    	<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                                        	<td>#DateFormat(dateAdded,'mm/dd/yyyy')#</td>
                                            <td>#DateFormat(dateExpires,'mm/dd/yyyy')#</td>
                                            <td><img src="../../pics/view.gif" alt="view" onClick="printAuthenticationFile('#id#')"/></td>
                                            <td><img src="../../pics/deletex.gif" alt="delete" onClick="deleteAuthenticationFile('#id#')"/></td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                            </table>
                        </td>
                        <!--- End Department of State --->
                        <td colspan="4">
                        </td>
                    </tr>
                </table>
                
            </td>
        </tr>
    </table>
    
</cfoutput>

</body>
</html>
