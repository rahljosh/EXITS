<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<title>Available Public Profiles</title>

<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
-->
</style>

</head>
<body>

<Cfquery name="get_students" datasource="mysql">
	SELECT     	studentid, uniqueid, dob, interests_other, smg_countrylist.countryname, smg_religions.religionname
	FROM       	smg_students
	INNER JOIN 	smg_countrylist ON smg_countrylist.countryid = smg_students.countryresident
	LEFT JOIN 	smg_religions ON smg_religions.religionid = smg_students.religiousaffiliation
	WHERE 	   	active = '1'
			 	AND hostid = '0'
				AND direct_placement = '0'
	<!---	and	(regionassigned =1307 or regionassigned =1246 or regionassigned = 1245 or regionassigned = 1232) --->
	ORDER BY rand()
	LIMIT 50
</Cfquery>

<Table align="center" cellpadding="0" cellspacing="0" border="0" width="480">
	<tr>
		<Td>
		<table>
			<tr><td id="navs" align="left" class="style1">
				<cfoutput>
					Search Results as of #DateFormat(now(), 'mmm d, yyyy')# @ #TimeFormat(now(),'h:mm:ss tt')#
				<cfif get_students.recordcount eq 0>
					<br /> <br />Unfortunatly, all students have been placed.  Please check back frequently as more students are always being accepted into programs.
				<cfelse>
				</td>
			</tr>
			<tr><td>
				<Table align="Center">
					<cfloop query="get_students">
					<CFSET image_path="c:\websites\student-management\nsmg\uploadedfiles\web-students\#get_students.studentid#.jpg">
					<tr>
						<td>
							<table>
								<tr>
									<td width="133" valign="top" class="style1">
										<CFIF FileExists(image_path)>
											<span class="style1"><a href="public_profile.cfm?id=#uniqueid#" target="_blank"><img src="http://www.student-management.com/nsmg/uploadedfiles/web-students/#get_students.studentid#.jpg" border=0 width="133"></a> 
											<CFELSE>
											<A href="public_profile.cfm?id=#uniqueid#" target="_blank"><img src="http://www.student-management.com/nsmg/pics/no_stupicture.jpg" border=0></A></span>	
										</CFIF></td>
									<td class="style1" align="justify" class="style1"><b>Age:</b> #DateDiff('yyyy', get_students.dob, now())# <br>
										<b>From:</b> #get_students.countryname#<br>
										<b>Religion:</b> #get_students.religionname#<br><br />
										#get_students.interests_other#</td>
								</tr>
							</table>
							<span class="style1"><br> 
							</span></td>
					</tr>
					</cfloop>
				</TABLE>
				</td>
				</tr>
							</table></td>
						  </tr>
						</table></TD>
						<TD width="17" background="images/blank_04.gif">&nbsp;			</TD>
					</TR>
					
				</TABLE>
				</cfif>
				</cfoutput>
				
								</td>
							</tr>
						</table>
				</div>
				<table>
					
				</table>

</td>
</tr>
</table>
</body>
</html>