<cfform method="post" action="?curdoc=intrep/payments/payment_step_4">
<cfoutput>



<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
							<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Make a Payment </td><td background="pics/header_background.gif" align="right"><img src="intrep/payments/images/logo_ccVisa.gif"><img src="intrep/payments/images/logo_ccMC.gif"><img src="intrep/payments/images/logo_ccAmex.gif"><img src="intrep/payments/images/logo_ccDiscover.gif"><img src="intrep/payments/images/logo_ccEcheck.gif"><img src="intrep/payments/images/PayPal_mark_37x23.gif"></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					
					
						
					<table width=100% cellpadding=2 cellspacing=0 border=0 class="section">
						<tr>
							<td colspan="5" align="center">
								<img src="intrep/payments/images/billing.gif" align="center">
								<br>
								<br>
							</td>
						</tr>
						<tr>
							<td style="line-height:20px;" valign="top" width=40% align="right">
							
							<table class="box">
								<tr>
									<td bgcolor="##f4992D">Payment Details</td>
								</tr>
								<tr>
									<td>
									Payment Amount: #LSCurrencyFormat(client.payment.amount, 'local')#
									</td>
								</tr>
							</table>
							</td>
							<td width=15 rowspan=2 align="center"><img src="intrep/payments/images/orange.gif" width=1 height=80%>
							</td>
							<td >
							
							<cfquery name="address" datasource="mysql">
							select smg_users.firstname, smg_users.lastname, smg_users.address, smg_users.address2, 
								smg_users.city, smg_users.state, smg_users.country, smg_users.zip,
							       smg_users.businessname,  smg_users.billing_company, smg_users.billing_address, 
								   smg_users.billing_address2,
								   smg_users.billing_city, smg_users.billing_country, smg_users.billing_zip,
								   smg_countrylist.countrycode 
								   
								   
							from smg_users
								LEFT JOIN smg_countrylist ON countryid = smg_users.country
								
							where userid = #client.userid#
							</cfquery>
							<table class="box" >
								<tr>
									<td  bgcolor="##f4992D"><input type="radio" name="use_address" value="personal">Use this Address <font size=-2>(personal address)</font></td>
								</tr>
								<tr>
									<td>
									#address.firstname# #address.lastname# <input type=hidden name="personal_name_f" value='#address.firstname#'><input type=hidden name="personal_name_l" value='#address.lastname#'><br>
									
									#address.address# <input type=hidden name="personal_address" value='#address.address#'><br>
									<cfif address.address2 is not ''>#address.address2#<input type=hidden name="personal_address2" value='#address.address2#'><br></cfif>
									#address.city#<input type=hidden name="personal_city" value='#address.city#'> #address.countrycode#<input type=hidden name="personal_country" value='#address.countrycode#'> #address.zip#<input type=hidden name="personal_zip" value='#address.zip#'><br>
									</td>
								</tr>
							</table>
							
							
							
							</td>
							<td valign="top">
							<table class="box" >
								<tr>
									<td  bgcolor="##f4992D"><input type="radio" name="use_address" value="business">Use this Address <font size=-2>(billing address )</font></td>
								</tr>
								<tr>
									<td>
									#address.billing_company# <input type=hidden name="business_company" value='#address.billing_company#'><br>
							#address.firstname# #address.lastname# <input type=hidden name="business_name_f" value='#address.firstname#'><input type=hidden name="business__name_l" value='#address.lastname#'>
							
							#address.billing_address#<input type=hidden name="business_address" value='#address.billing_address#'><br>
							<cfif address.billing_address2 is not ''>#address.billing_address2# <input type=hidden name="business_address2" value='#address.billing_address2#'><br></cfif>
							#address.billing_city#<input type=hidden name="business_city" value='#address.billing_city#'> #address.billing_country#<input type=hidden name="business_country" value='#address.billing_country#'> #address.billing_zip#<input type=hidden name="business_zip" value='#address.billing_zip#'><br>
							</td>
							</tr>
							</table>
							</td>

						</tr>
						<tr>
							<td colspan=2></td>
							
						<td colspan=2>
							<table class=box>
								<tr>
									<td  bgcolor="##f4992D"><input type="radio" name="use_address" value="other">Use this Address</td>
								</tr>
								<tr>
									<td>
										<table>	
											<tr>
												<td>
													<table>
													<tr>
														<td>First Name: </td><td><input type="text" name="firstname" size=25></td>
													</tr>
													<tr>
														<td>Last Name: </td><td><input type="text" name="lastname" size=25></td>
													</tr>
													<tr>
														<td>Address: </td><td><input type="text" name="address" size=25></td>
													</tr>
													<tr>
														<td></td><td><input type="text" name="address2" size=25></td>
													</tr>
													</table>
													
												</td>
												<Td valign="top">											<table>
											<Tr>
												<td>City: </td><td><input type="text" name="city" size=25></td>
											</Tr>
											<tr>
												<td> Country: </td><td><input type="text" name="country" size=25></td>
											</tr>
											<tr>
												<td> Postal Code: </td><td><input type="text" name="zip" size=25></td>
											</tr>
											
										</table>
									</tr>
									</table>
							</td>
						</table>
						</td>
							
							
						</tr>
						<tr>
							<td colspan=5 align="center"><input type="image" src="pics/next.gif" alt="next"></td>
						</tr>
					</table>
					<!----footer of table---->
								<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>
	</cfoutput>
	</cfform>