<html>
<head>
<title>:: CSB International : Partners ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="871" height="455" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01">
	<tr>
		<td height="131" background="images/top.jpg"><table width="99%" border="0">
		  <tr>
		    <td height="90" colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <a href="index.cfm"><img src="images/transparent.gif" alt="" width="250" height="83" border="0"></a></td>
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
		      <cfif NOT isDefined('loged')>
              <form action="job-list.cfm?loged=yes" method="post" >
              <table width="220" border="0" align="center" bgcolor="#666666">
	            <tr>
	              <td class="MenuItens">Login:</td>
                </tr>
	            <tr>
	              <td bgcolor="#FFFFFF"><table width="100%" border="0" cellpadding="5" cellspacing="0" class="text">
	                <tr>
	                  <td width="21%"><strong>user:</strong></td>
	                  <td width="79%"><input name="user" type="text" class="text" id="user" size="30"></td>
                    </tr>
	                <tr>
	                  <td><strong>pass:</strong></td>
	                  <td><input name="pass" type="text" class="text" id="pass" size="30"></td>
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
	              <cfif FORM.user EQ 'intoagent' AND FORM.pass EQ 'into47'>
                    <br>
					<br>
					<p>- <span class="style1"><strong><a href="job-description/summer2008/index.cfm" target="_blank">Summer 2008</a></strong></span></p>
                    <p>- <a href="job-description/winter2008-09/index.cfm" class="style1 target="_blank""><strong>Winter 2008-2009</strong></a></p>
                    <p>- <a href="job-description/spring2009/index.cfm" class="style1" target="_blank"><strong>Spring 2009</strong></a></p>
                    <p>- <a href="job-description/summer2009/index.cfm" target="_blank"><strong>Summer 2009</a></strong></span></p>
				<cfelse>
	                  Wrong User or password!
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