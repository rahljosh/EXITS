


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<title>Available Public Profiles</title>
</head>
<body bgcolor=#e7e5df>
<Table align="center" bgcolor="white">
	<tr>
		<td><img src="flags.jpg" width=796></td>
	<tr>
		<Td>
	

		<table>
			<tr>
				<td id="navs">

<cfparam name="loggedin" default="no">
	<cfif isDefined('form.user')>
		<cfif form.user is not ''>
			<cfif form.user is 'gene' and form.pass is 'tipton'>
				<cfset loggedin = 'yes'>
			</cfif>
		</cfif>
	</cfif>
	<cfif isDefined('form.name')>
		<cfif form.user is not ''>
			<cfmail to="josh@pokytrails.com" from="webmaster@sea-usa.org" subject="Contact Info from SEA Website">
			The following information was collected so the user could view students:
			Name: #form.name#
			Email: #form.email#
			Phone: #form.phone#
			
			An email was sent to the showing gene and tipton as the user and pass, and they were allowed to view students.
			</cfmail>
			<cfset loggedin ='yes'>
		</cfif>
	</cfif>
	
<cfif loggedin is 'no'>

<form name="frmEmail" method="post" action="seaindex.cfm">
<h2>SEA would like to thank you for your interest in meeting our students.</h2>
<table width="796">
	<tr>
		<td width=50% valign="top">
		<!----Have Password---->
		<p>If you've already submitted your contact info, please enter the user/pass you received in your email.</p>
						<table>
							<tr>
								<td>Username:</td><Td><input type="text" name="user" size=8/></Td>
							</tr>
							<tr>
								<td>Passphrase:</td><Td><input type="password" name="pass" size=8/></Td>
							</tr>
							<tr>
								<td colspan=2><input type="submit" value="View Students"/></td>
							</tr>
						</table>
		
		</td>
		<td valign="top">
		<p>If you don't have a user/pass, please fill out this form for immediate access.<p>
					
						
					<span id="lblUserMessage"></span>
						
						
						
						<table id="tblEmail">
							<tr>
								<td>Name</td>
								<td><input name="name" type="text" size=25 >

								
								</td>
							</tr>
							<tr>
								<td>Phone: </td>
								<td><input name="phone" type="text" size=25></td>
							</tr>
							<tr>
								<td>Email:</td>

								<td><input name="email" type="text" size=25>
								
															
								</td>
							</tr>
							<tr>
								<td colspan="2"><input type="submit" name="btnSubmit" value="Submit" onclick="if (typeof(Page_ClientValidate) == 'function') Page_ClientValidate(); " language="javascript" id="btnSubmit" class="moveright" /> </td>
							</tr>
						</table>
						
		
		
		</td>
	
	
	
	</tr>
</table>
						</form>		
						<cfelse>
						 
						
																		
	
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
				
				<cfoutput>
				
				Search Results as of #DateFormat(now(), 'mmm d, yyyy')# @ #TimeFormat(now(),'h:mm:ss tt')#<br>
				<cfif get_students.recordcount eq 0>
				Unfortunatly, all students have been placed.  Please check back frequently as more students are always being accepted into programs.
				<cfelse>
				
				<Table width=80% align="Center">
					<tr>
						<td align = "center"><h3>Click on picture for full profile.</h3></td>
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
											<img src="http://www.student-management.com/nsmg/pics/no_stupicture.jpg"></span>	
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
</cfif>
</body>
</html>
