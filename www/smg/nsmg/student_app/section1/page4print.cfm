<cftry>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelseif IsDefined('url.exits_app')>
	<cfset path = "nsmg/student_app/">
<cfelse>
	<cfset path = "../">
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [04] - Family Photo Album</title>
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfoutput query="get_student_info">

<cfdirectory action="list" name="fam_pics" directory="#AppPath.onlineApp.familyAlbum##get_student_info.studentid#">

<cfif not IsDefined('url.curdoc')>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0> 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [04] - Family Photo Album</h2></td>
		<cfif IsDefined('url.curdoc')>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page4print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<!--- no picture have been uploaded --->
<cfif fam_pics.recordcount EQ 0> 
	<div class="section"><br>
	<table width="660" border="0" cellpadding="0" cellspacing="0" align="center">	
		<tr>
			<td width="150"><em>Student's Name</em></td>
			<td width="520">#get_student_info.firstname# #get_student_info.familylastname#<br><img src="#path#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
		</tr>
	</table>
	<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
		<tr><td height="330" valign="middle" align="center"><img src="#path#pics/familyphoto.jpg" border="0" align="absmiddle"></td></tr>
		<tr><td><em>Describe this Picture</em></td></tr>
		<tr><td height="50" valign="top"><br><img src="#path#pics/line.gif" width="660" height="1" border="0" align="absmiddle"></div></td></tr>
	</table><br>
	<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
		<tr><td height="330" valign="middle" align="center"><img src="#path#pics/familyphoto.jpg" border="0" align="absmiddle"></td></tr>
		<tr><td><em>Describe this Picture</em></td></tr>
		<tr><td height="50" valign="top"><br><img src="#path#pics/line.gif" width="660" height="1" border="0" align="absmiddle"></div></td></tr>
	</table><br>
	</div>	
<cfelse>
	<div class="section"><br>
	<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
		<tr>
			<td width="150"><em>Student's Name</em></td>
			<td width="520">#get_student_info.firstname# #get_student_info.familylastname#<br><img src="#path#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
		</tr>
	</table><br>
	<!--- pictures have been uploaded --->
	<cfloop query="fam_pics">
		<cfquery name="pic_description" datasource="MySQL">
			SELECT description 
			FROM smg_student_app_family_album
			WHERE studentid = <cfqueryparam value="#get_student_info.studentid#" cfsqltype="cf_sql_integer"> 
				  AND filename = '#name#'
		</cfquery>
		<table width="660" border="0" cellpadding="0" cellspacing="0" align="center" height="350">	
			<tr><td align="center" valign="top" width="2%" height="320">
					<img src="#path#../uploadedfiles/online_app/picture_album/#client.studentid#/#name#" width="500" height="360" border="0">
				</td>
			</tr>
			<tr><td><em>Describe this Picture</em></td></tr>
			<tr><td valign="top" align="center">#Left(pic_description.description, 200)#<br><img src="#path#pics/line.gif" width="660" height="1" border="0" align="absmiddle"></td></tr>
		</table><br>
		<cfif fam_pics.currentrow MOD 2 EQ 0>
			<cfif fam_pics.currentrow NEQ fam_pics.recordcount>
			</div>
			<!--- FOOTER OF TABLE --->
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr height="8">
					<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
					<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
					<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
				</tr>
			</table>			
			<div style="page-break-after:always;"></div>
			<!--- HEADER OF TABLE --->
			<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
				<tr height="33">
					<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
					<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
					<td class="tablecenter"><h2>[04] - Family Photo Album</h2></td>
					<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
				</tr>
			</table>
			<div class="section"><br>
			<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
				<tr>
					<td width="150"><em>Student's Name</em></td>
					<td width="520">#get_student_info.firstname# #get_student_info.familylastname#<br><img src="#path#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
				</tr>
			</table><br>
			</cfif>
		</cfif>
	</cfloop>
	</div>
</cfif>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif not IsDefined('url.curdoc')>
</td></tr>
</table>
</cfif>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>