<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<link rel="stylesheet" href="../smg.css" type="text/css">

	<cfform method="post" action="record_refund.cfm?userid=#url.userid#">
	
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="../pics/header_background.gif"><img src="../pics/$.gif"><img src="../pics/$.gif"><img src="../pics/$.gif"></td>
							<td background="../pics/header_background.gif"><h2>&nbsp;&nbsp;Issue a Refund</td><td background="../pics/header_background.gif" width=16></a></td>
							<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					<cfoutput>
					<table width=100% class="section" cellpadding=0 cellspacing=0 align="center" border=0> 
						<tr>
							<td><h2>Refund Credits on Account:</td>
						</tr>
						<tr>
							
							<td valign="top">	
							<cfquery name="available_credits" datasource="caseusa">
							select *
							from smg_credit
							where companyid = #client.companyid# 
							and agentid = #url.userid#
							and active = 1
							</cfquery>
						<cfif available_credits.recordcount eq 0>
							<br>
							There are no available credits to refund.
						<Cfelse>
							
							<table width=100%>
								<tr>
									<td></td><td>ID</td><td>Amount</td><td>Description</td>
								</tr>
							
							<cfloop query=available_credits>
							<tr>
								<td><input type="checkbox" name="credit_to_refund" value="#creditid#"></td>
								<td>#creditid#</td>
								<td><cfset bal_amount = #amount# - #amount_applied#>#LSCurrencyFormat(bal_amount,'local')#</td>
								<td>#description#</td>
							
							</tr>
							
							</cfloop>
							</table>
							<input name="back" type="image" src="../pics/next.gif" border=0>
							
						</cfif>
							
							
							</td>
						</tr>
						
					</table>
					</cfoutput>
					
					
					
					<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
										<td width=100% background="../pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
									</tr>
								</table>
								</cfform>