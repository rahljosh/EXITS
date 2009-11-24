<html>
<head>
<title>:: CSB International : Partners ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<cfif isDefined('url.redo')>
	<cfloop list="#GetClientVariablesList()#" index="ThisVarName">
		<cfset temp = DeleteClientVariable(ThisVarName)>
	</cfloop>
</cfif>
<cfif isDefined('form.pass')>
	<cfset client.pass = '#form.pass#'>
</cfif>
<cfif isDefined('form.user')>
	<cfset client.user = '#form.user#'>
</cfif>
<table width="871" height="455" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01">
	<tr>
		<td height="131" background="images/top.jpg"><table width="99%" border="0">
		  <tr>
		    <td height="90" colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <a href="../index.cfm"><img src="images/transparent.gif" alt="" width="250" height="83" border="0"></a></td>
	      </tr>
		  <tr>
		    <td width="325">&nbsp;</td>
		    <td><cfinclude template="menu.cfm"></td>
	      </tr>
	    </table></td>
	</tr>
	<tr>
		<td height="272" valign="top" background="images/back-table.png"><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
		    <td width="5%" height="26">&nbsp;</td>
		    <td width="90%" valign="bottom" class="top"><a href="index.cfm" class="LinkItens">Home</a> &gt; Job Listing</td>
		    <td width="5%">&nbsp;</td>
	      </tr>
		  <tr>
		    <td height="17" colspan="3"><hr width="94%" color="#CCCCCC"></td>
	      </tr>
		  <tr>
		    <td colspan="3">&nbsp;</td>
	      </tr>
		  </table>
		  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
		    <td width="5%">&nbsp;</td>
		    <td width="90%" class="text" align="center"><p>Participants on the CSB Summer Work and Travel program have  the opportunity to select from a variety of employment opportunities arranged  specifically for our students by CSB International.&nbsp; Below please find a listing of the available  jobs, categorized by season.
	          </p>
		      <cfif NOT isDefined('client.user')>
              <form action="job-list.cfm?loged=yes" method="post" >
              <table width="220" border="0" align="center" bgcolor="#666666">
	            <tr>
	              <td class="MenuItens">Login:</td>
                </tr>
	            <tr>
	              <td bgcolor="#FFFFFF"><table width="100%" border="0" cellpadding="5" cellspacing="0" class="text">
	                <tr>
	                  <td width="21%"><strong>Username:</strong></td>
	                  <td width="79%"><input name="user" type="text" class="text" id="user" size="30"></td>
                    </tr>
	                <tr>
	                  <td><strong>Password:</strong></td>
	                  <td><input name="pass" type="password" class="text" id="pass" size="30"></td>
                    </tr>
	                <tr>
	                  <td colspan="2" align="center"><input type="submit" name="Submit" class="text" value="Submit"></td>
                    </tr>
                  </table>
                 
                  </td>
                </tr>
              </table>
              </form>
              <cfelse>
	              <cfif client.user EQ 'csbagent' AND client.pass EQ 'csb45'>
							<cfinclude template="view_job_listing.cfm">
                   <cfelseif client.user EQ 'anca' AND client.pass eq 'qaz123'>
                 			  <cfinclude template="admin_job_listing.cfm">
				<cfelse>
	                  Wrong User or password!<br><br>
                      <a href="job-list.cfm?redo">Try again</a>
                  </cfif>
              </cfif></td>
		    <td width="5%">&nbsp;</td>
	      </tr>
      </table>
		  <br></td>
	</tr>
	<tr>
		<td height="52" background="images/bottom.png" align="center"><cfinclude template="bottom.cfm"></td>
	</tr>
</table>
</body>
</html>