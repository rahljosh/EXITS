


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<title>Available Public Profiles</title>
</head>
<body bgcolor=#e7e5df>

<Cfquery name="get_students" datasource="mysql">
	SELECT     	studentid, uniqueid, dob, interests_other, smg_countrylist.countryname, smg_religions.religionname
	FROM       	smg_students
	INNER JOIN 	smg_countrylist ON smg_countrylist.countryid = smg_students.countryresident
	LEFT JOIN 	smg_religions ON smg_religions.religionid = smg_students.religiousaffiliation
	WHERE 	   	active = '1'
			 	AND hostid = '0'
				AND direct_placement = '0'
		and	(regionassigned =1307 or regionassigned =1246 or regionassigned = 1245 or regionassigned = 1232)
	ORDER BY rand()
	LIMIT 50
</Cfquery>

<Table align="center" bgcolor="white" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td><img src="flags.jpg" width=796></td>
	<tr>
		<Td>
		<table>
			<tr>
				<td id="navs">
				<cfoutput>
				Search Results as of #DateFormat(now(), 'mmm d, yyyy')# @ #TimeFormat(now(),'h:mm:ss tt')#<br>
				<cfif get_students.recordcount eq 0>
				Unfortunatly, all students have been placed.  Please check back frequently as more students are always being accepted into programs.
				<cfelse>
				
				<Table width=796 align="Center">
					<tr>
						<td align="center"><h2>This is a sample of available students. 
							If you are interested in any students please click on the students photo for 
							more detail information about the students.</h2></td>
					</tr>
					<cfloop query="get_students">
					<CFSET image_path="D:\websites\nsmg\uploadedfiles\web-students\#get_students.studentid#.jpg">
					<tr>
						<td>
							<table>
								<tr>
									<td width="133">
										<CFIF FileExists(image_path)>
											<span class="style1"><a href="public_profile.cfm?id=#uniqueid#"><img src="http://www.student-management.com/nsmg/uploadedfiles/web-students/#get_students.studentid#.jpg" border=0 width="133"></a> 
											<CFELSE>
											<A href="public_profile.cfm?id=#uniqueid#"><img src="http://www.student-management.com/nsmg/pics/no_stupicture.jpg" border=0></A></span>	
										</CFIF></td>
									<td class="style1">Age: #DateDiff('yyyy', get_students.dob, now())# <br>
										From: #get_students.countryname#<br>
										Religion: #get_students.religionname#<br>
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
