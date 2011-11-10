<html>
<head>
<title>:: CSB International ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<cfif isDefined('form.pass')>
	<cfset client.pass = '#form.pass#'>
</cfif>
<table width="871" height="600" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01">
	<tr>
		<td height="131" background="images/index_01.jpg">&nbsp;</td>
	</tr>
	<tr>
		<td height="417" background="images/index_02.jpg"><table width="90%" border="0" align="center" cellpadding="10">
		  <tr>
		    <td height="99" colspan="2">
           
                 <cfif not isDefined('client.pass')>
                    <cfset client.pass = "josh">
                 </cfif>

                <cfif client.pass is 'qaz123'>
                    <cfinclude template="admin_job_listing.cfm">
                <cfelseif client.pass neq "csbjobs">
                <form method="post" action="job_listing.cfm">
                <div align="center">
                Please enter the job listing password below to view available jobs.<br>
                <Table>
                    <tr>
                        <td>Password</td><td><input type="text" size=20 name="pass"></td>
                    </tr>
                    <Tr>
                        <td colspan=2 align="Center"><input type="submit" value="Submit"></td>
                    </Tr>
                </Table>
                </div>
                </form>
                <cfelse>
            		<cfinclude template="view_job_listing.cfm">
				</cfif>
           
            </td>
          </tr>
          <tr valign="bottom">
            <td height="15" class="style1"><div align="center"><img src="images/back.gif" width="730" height="10"></div></td>
        </tr>
        </table>			
  </td>
	</tr>
	<tr>
		<td height="52" background="images/index_04.jpg" align="center"><cfinclude template="bottom.cfm"></td>
	</tr>
</table>
</body>

