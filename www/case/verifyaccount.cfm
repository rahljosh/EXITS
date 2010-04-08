<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" >
<html>
<head>
<title>Verification</title>
<link rel="stylesheet" href="login.css" type="text/css">

</head>
<br><Br><div align="Center"><strong>Welcome</strong><br><br><br> Please wait while we gather your information.<br>
<img src="pics/ticky_ticky.gif"></div>


<cfquery name="get_rep_info" datasource="caseusa">
	select * 
	from smg_users 
	where userid = #client.userid#
</cfquery>
<cfif not isDefined('client.usertype')>
	<cfset client.usertype = 7>
</cfif>

<cfflush>

<Cfif get_rep_info.changepass eq 1>
<!----
	<cflocation url="change_pass.cfm?u=#client.usertype#" addtoken="no">
	---->
	<cfoutput>
	<META http-equiv="refresh" content="1;URL=http://www.student-management.com/nsmg/change_pass.cfm?u=#client.userid#">
	</cfoutput>
	<cfabort>
<cfelse>
	<cfflush>
	<Cfset client.regions = ''>
	<cfloop list="#get_rep_info.regions#" index=i >
		<cfquery name="region_company" datasource="caseusa">
			select regionid from smg_regions
			where regionid = #i# and company=#client.companyid#
		</cfquery>
			
		<cfif region_company.recordcount is not 0>
			<Cfoutput>
				<Cfset client.regions = #ListAppend(client.regions, region_company.regionid)#>
			</Cfoutput>
		</cfif>		
	</cfloop>
			
	<cfif #Left(get_rep_info.password, 4)# is 'temp'>
					
		<cfquery name="original_company_info" datasource="caseusa">
			select *
			from smg_companies
			where companyid = #client.companyid#
		</cfquery>
		<div id="login">
		<div class="pagecell"><br>
					
					<CFFORM name="login" action="verify.cfm?u=#get_rep_info.usertype#" method="post">
						
							<table width=100% align="center">
								<TR>
								<TD align="left"><Cfoutput><img src="pics/logos/#original_company_info.companyshort#_logo.gif" alt="" border="0"></td><td align="right"><h3>#original_company_info.companyname#<Br>Account Access<br>Verification</h3></TD></Cfoutput></TR>
								
							</table>
							<div class="grey_box"><br>
						Since this is your first time loging in, you will need to verify your account and change your password.<br>
						<br>
						<div align="center"><StronG>Verification information</StronG></div><br>
								<table align="center">
									<Tr>
									<td align="right"><font size=-2>Postal Code:</td><td><cfinput type="text" size=5 name="zip"></td>
									</Tr>
									<cfif get_rep_info.usertype neq 8 OR get_rep_info.usertype neq 11>
									<tr>
										<td align="right"><font size=-2>Home Phone (last four):</td><td><cfinput type="text" size=5 name=phone></td></tr>
									</cfif>	
										</table>
								 
								 <div align="right"><img src="pics/lock4.gif" width="18" height="17"> <input type="image" name="Submit" src="pics/submit.gif" border=0></span></div>
								</div>
						</CFFORM>	
					   <div id="siteInfo" align="center"> 
						<a href="#">About Us</a> | <a href="#">Site
						Map</a> | <a href="#">Privacy Policy</a> | <a href="#">Contact Us</a> <br> &copy;2009
						CASE 
					
					  </div> 
					  </div>
					
					<cfelse>
					
					<cfinclude template="set_rights.cfm">
					</cfif>
					</BODY>
</cfif>