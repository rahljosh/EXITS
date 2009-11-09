<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>
<body>
<script type="text/javascript">
<!--
function changeDiv(the_div,the_change)
{
  var the_style = getStyleObject(the_div);
  if (the_style != false)
  {
	the_style.display = the_change;
  }
}
function hideAll()
{
  changeDiv("1","none");
  changeDiv("2","none");

}
function getStyleObject(objectId) {
  if (document.getElementById && document.getElementById(objectId)) {
	return document.getElementById(objectId).style;
  } else if (document.all && document.all(objectId)) {
	return document.all(objectId).style;
  } else {
	return false;
  }
}
// -->
</script>

<cfif isDefined('url.redirect')>
	<cfif url.userid NEQ client.userid>
		You are trying to edit a profile other then your own.  This is not allowed.  If you got this error and you do not know why, please contat
		support@student-management.com<br><br>
		Continue and view your own account:<cfoutput><a href="index.cfm?curdoc=intrep/int_user_info&userid=#client.userid#&redirect=initial_welcome">Account Info</a></cfoutput>
	<cfabort>	
	</cfif>
</cfif>

<!----Rep Info---->
<cfquery name="rep_info" datasource="MySQL">
	SELECT *
	FROM smg_users
	LEFT JOIN smg_countrylist ON countryid = smg_users.country
	WHERE userid = #url.userid#
</cfquery>

<!----Regional Information---->
<Cfquery name="region_company_access" datasource="MySQL">
	SELECT uar.companyid, uar.regionid, uar.usertype, uar.id, uar.advisorid,
		   r.regionname,
		   c.companyshort,
		   ut.usertype as usertypename, ut.usertypeid,
		   adv.firstname, adv.lastname
	FROM user_access_rights uar
	INNER JOIN smg_regions r ON r.regionid = uar.regionid
	INNER JOIN smg_companies c ON c.companyid = uar.companyid
	INNER JOIN smg_usertype ut ON ut.usertypeid = uar.usertype
	LEFT JOIN smg_users adv ON adv.userid = uar.advisorid
	WHERE uar.userid = '#url.userid#'
	ORDER BY r.regionname
</Cfquery>

<style type="text/css">
<!--
.smlink         		{font-size: 11px;}
.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #Ffffe6;}
.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionSubHead			{font-size:11px;font-weight:bold;}
-->
</style>

<cfoutput query="rep_info">
<cfform action="?curdoc=forms/edit_user" method="post">
<cfset temp = "temp">
<cfset temp_password = "#temp##RandRange(100000, 999999)#">
<input type="hidden" name=temp_password value=#temp_password#>
<!----Personal Information---->
<!----header of table---->

<!--- SIZING TABLE --->
<table border=0 width=100%>
<tr>
	<td width=55%>
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 >
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/user.gif"></td>
				<td background="pics/header_background.gif"><h2>Personal Information 
				</td><td background="pics/header_background.gif" width=16><a href="?curdoc=forms/edit_user&userid=#url.userid#"><img src="pics/edit.png" border=0 alt="Edit"></a></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
			</tr>
		</table>
		<!----Right side news item---->
		<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
			<tr>
				<td style="line-height:20px;" valign="top">
					<div style="float:left;">
						<table width=245 cellpadding=0 cellspacing=0 border=0 bgcolor=##ffffff align="left">
							<tr valign=top>
								<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="pics/address_topleft.gif" height=6 width=6></td>
								<td width=201 style="line-height:1px; font-size:2px; border-top: 1px solid ##557aa7;">&nbsp;</td>
								<td width=6><img src="pics/address_topright.gif" height=6 width=6></td>
							</tr>
							<cfif region_company_access.usertype EQ 8 OR rep_info.usertype EQ 8>
							<cfform>
							<cfinput type="radio" name="usertype" 	onClick="hideAll(); changeDiv('1','block');" checked value="personal">Personal <cfinput type="radio" name="usertype" 	onClick="hideAll(); changeDiv('2','block');" value="billing">Billing &nbsp;&nbsp;
							<tr>
								<td width=6 style="border-left: 1px solid ##557aa7;">&nbsp;</td>
								<td width=226 style="padding:5px;">
									<div id="1" STYLE="display:block">
										<cfif region_company_access.usertype EQ 8 OR rep_info.usertype EQ 8>
										#businessname#<br>
										</cfif>
										#firstname# #lastname# - #userid#<br>
										#address#<br>
										<cfif #address2# is ''><cfelse>#address2#<Br></cfif>
										#city# <cfif #usertype# is 8>#countryname#<cfelse>#state#</cfif>, #zip#<Br>
										P: #phone#<br>
										F: #fax#<br>
										E: <a href="mailto:#email#">#email#</a><br>	
										</div>
										<div id="2" STYLE="display:none">
										#billing_company#<br>
										#billing_contact#<br>
										#billing_address#<br>
										<cfif #billing_address2# is ''><cfelse>#billing_address2#<Br></cfif>
										#billing_city# #countryname#, #billing_zip#<Br>
										P: #billing_phone#<br>
										F: #billing_fax#<br>
										E: <a href="mailto:#billing_email#">#billing_email#</a><br>	
									</div>
								</td>
								<td width=6 style="border-right: 1px solid ##557aa7;">&nbsp;</td>
							</tr>
							</cfform>
							<cfelse>
							<tr>
								<td width=6 style="border-left: 1px solid ##557aa7;">&nbsp;</td>
								<td width=226 style="padding:5px;">
										<cfif region_company_access.usertype EQ 8 OR rep_info.usertype EQ 8>
										#businessname#
										</cfif>
										#firstname# #lastname# - #userid#<br>
										#address#<br>
										<cfif #address2# is ''><cfelse>#address2#<Br></cfif>
										#city# <cfif #usertype# is 8>#countryname#<cfelse>#state#</cfif>, #zip#<Br>
										P: #phone#<br>
										F: #fax#<br>
										E: <a href="mailto:#email#">#email#</a><br>	
								</td>
								<td width=6 style="border-right: 1px solid ##557aa7;">&nbsp;</td>
							</tr>
							</cfif>
							<tr valign="bottom">
								<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="pics/address_bottomleft.gif" height=6 width=6></td>
								<td width=201 style="line-height:1px; font-size:2px; border-bottom: 1px solid ##557aa7;">&nbsp;</td>
								<td width=6><img src="pics/address_bottomright.gif" height=6 width=6></td>
							</tr>
						</table>
					<div style="padding-left:5px; float:inherit"  >
				 		<strong>Last Login: </strong>#DateFormat(lastlogin, 'mm/dd/yyyy')#<br>
					 	<strong>User Entered:</strong> #DateFormat(datecreated, 'mm/dd/yyyy')# <br>
						<cfif client.usertype is 1 or client.usertype lt #rep_info.usertype# or client.userid eq rep_info.userid>
							<strong>Username:</strong>&nbsp;&nbsp;&nbsp;<cfif rep_info.userid eq 9401>****<cfelse>#username#</cfif><br>
							<strong>Password:</strong>&nbsp;&nbsp;&nbsp;<cfif rep_info.userid eq 9401>****<cfelse>#password#</cfif><br>
						</cfif>
						<font size=-2><a href="resendlogin.cfm?userid=#userid#"><img src="pics/email.gif" border=0 align="left"> Resend Login Info Email</A><cfif isDefined('url.es')><font color="red"> - Sent</font></cfif></font>
					</div>
					</div>
				</td>
			</tr>
		</table>
		<!----footer of personal info table---->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign=bottom >
				<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
				<td width=100% background="pics/header_background_footer.gif"></td>
				<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
			</tr>
		</table>
	</td>
	<td valign="top">
		<div style="width:100%; float:right;text-align:center;">
			<cfif isDefined('url.redirect')> 
				<div style="font-size:16px;font-weight:bold;border: 1px dashed CC0000;">
				<cfset client.firstlogin = 'yes'> 
				Please verify that your account information is correct, if not, please click on edit (<img src="pics/edit.png">) and update your information.<br>
				<a href="querys/continue.cfm"><img src="pics/verify_account_info.jpg" width="144" height="112" border=0></a>
			<cfelse>
				<div style="font-size:16px;font-weight:bold;">
					Please verify that your account information is correct.  Inaccurate information could result in 
					delayed communication, missed emails, inaccurate records and inefficient communication.  To update your information, click on please click on the edit icon (<img src="pics/edit.png">). If information is incorrect and you update your information, please notify SMG immediatly of any such updates.  
			</cfif>
		</div>
	</td>
</tr>
</table><br>


<!--- SIZING TABLE --->
<table width=100% border=0 >
<tr>
	<td width=460 valign="top" rowspan=2>
	<!----Footer of Insurance Information---->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
				<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Payment Activity </td><td background="pics/header_background.gif" width=16></a></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
			</tr>
		</table>
		<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
			<tr>
				<td style="line-height:20px;" valign="top">
					<cfif rep_info.usertype is 8>
						<!----querys to calculate amount due---->
						<Cfquery name="total_Due" datasource="MySQL">
							select sum(amount_due) as amount_due
							from smg_charges
							where agentid = #url.userid# 
						</Cfquery>
						<cfif total_due.amount_due is ''>
							<cfset total_due.amount_due = 0>
						</cfif>
						
						<cfquery name="total_received" datasource="mysql">
							select sum(totalreceived) as total_received
							from smg_payment_received
							where agentid = #url.userid# 			
						</cfquery>
						<cfif total_received.total_received is ''>
							<cfset total_received.total_received = 0>
						</cfif>
			
						<cfquery name="total_Credit" datasource="MySQL">
							select sum(amount) as credit_amount
							from smg_credit
							where agentid = #url.userid#
							and active = 1
						</cfquery>
						<cfif total_credit.credit_amount is ''>
							<cfset total_credit.credit_amount = 0>
						</cfif>
			
						<cfquery name="overpayment_credit" datasource="MySQL">
						select sum(amount) as overpayment_amount
						from smg_credit
						where agentid = #url.userid# and payref <> '' and active = 0
						</cfquery>
						<cfif overpayment_credit.overpayment_amount is ''>
							<cfset overpayment_credit.overpayment_amount = 0>
						</cfif>
				
						<cfset balance_due = #total_due.amount_due# - #total_credit.credit_Amount#- #total_received.total_received# + #overpayment_credit.overpayment_amount#>
				
						<!----Last Payment Details---->
						<Cfquery name="recent_date" datasource="MySQL">
							select max(date) as recent_pay
							from smg_payment_received
							where agentid = #url.userid#
							group by date
						</Cfquery>
						<cfif recent_Date.recent_pay is ''>
							<cfset last_payment.totalreceived = 0>
						<cfelse>
							<cfquery name="last_payment" datasource="MySQL">
							select totalreceived from smg_payment_received
							where agentid = #url.userid# and date = #recent_date.recent_pay#
							</cfquery>
						</cfif>
		
						<!----last Invoice Sent---->
						<cfquery name="last_invoice_sent" datasource="MySQL">
							select max(invoiceid) as invoiceid
							from smg_charges where agentid = #url.userid#
						</cfquery>
						<cfif last_invoice_sent.invoiceid is ''>
							<cfset last_invoice_sent.invoiceid = 0>
							<cfset last_invoice_date.date = 0>
						<cfelse>
							<cfquery name="last_invoice_date" datasource="mysql">
								select *
								from smg_charges
								where invoiceid = #last_invoice_sent.invoiceid#
							</cfquery>
						</cfif>
				
						<!----Current Balance:#LSCurrencyFormat(balance_due, 'local')#<br>
						Last Payment Amount:#LSCurrencyFormat(last_payment.totalreceived, 'local')# <br>
						<!----Last Payment Method:#recent_date.paymenttype# <Br>---->
						Last Payment Received:<cfif last_payment.totalreceived is not 0> #DateFormat(recent_date.recent_pay, 'MMMM D, YYYY')#</font></cfif><br><br>
						---->
						Most Recent Invoice Sent:
						<cfif last_invoice_date.date eq 0>
							No invoice has been sent
						<cfelse>
							#DateFormat(last_invoice_date.date, 'MMMM D, YYYY')#&nbsp;&nbsp;&nbsp;<a href="invoice/invoice_view.cfm?id=#last_invoice_date.invoiceid#" class="smlink" target="_top">View  Invoice</a><br>
						</cfif>
						<!----
						<strong>Current Balance:</strong><br>
						<strong>Last Statement Sent:</strong> 07/21/05&nbsp;&nbsp;&nbsp;<a href="" class="smlink">View  Activity</a><br>
						<strong>Last Payment Method:</strong> MasterCard&nbsp;&nbsp;&nbsp;<a href="" class="smlink">Change</a><Br>
						<strong>Last Payment Amount:</strong><br>
						<strong>Last Payment Received:</strong>
						---->
					</cfif>
				</td>
			</tr>
		</table>
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign=bottom >
				<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
				<td width=100% background="pics/header_background_footer.gif"></td>
				<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
			</tr>
		</table>
	</td>
	<td>&nbsp;</td>
	<td valign="top"
	</td>
</tr>
</table><br>

<!--- SIZING TABLE --->
<Table width=100% border=0>
<tr>
		<td width=30%></td>
		
		<td width=5></td>
		
		<td width=30% valign="top">
			<!----Employment Info---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/clock.gif"></td>
					<td background="pics/header_background.gif"><h2>Insurance and SEVIS Info</td><td background="pics/header_background.gif" width=16><!--- <a href="edit_regional_access"><img src="pics/edit.png" border=0 alt="Edit"></a> ---></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<cfif rep_info.insurance_policy_type is ''><font color="FF0000">Missing insurance type for this Agent</font>
							<cfelseif rep_info.insurance_policy_type is 'none'>Does not take insurance provided by SMG
							<cfelse>Takes #rep_info.insurance_policy_type# insurance provided by SMG
						</cfif><br>
						<cfif rep_info.accepts_sevis_fee is ''>Missing SEVIS fee information
							<cfelseif rep_info.accepts_sevis_fee is '0'>Does not accept SEVIS fee
							<cfelse>Accepts SEVIS fee.
						</cfif><br>
					</td>
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
		</td>
		<!----sizing table cell end---->
		<td width=5></td>
		<td width=50% valign="top" rowspan=2>
		</td>
	<!----End of Sizing Table Row---->
	</td>
</tr>
</table><br>

<!--- SIZING TABLE --->
<Table width=100% border=0>	
<tr>
	<td width=50% valign="top">
		<!----Misc Notes Info---->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/notes.gif"></td>
				<td background="pics/header_background.gif"><h2>Notes </td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
			</tr>
		</table>
		<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
			<tr>
				<td style="line-height:20px;" valign="top">
					<Cfif #comments# is ''>No additional information available.<cfelse>#comments#</cfif><br><br>
				</td>
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
	</td>
	<td width="5" valign="top"></td>
</tr>
</table>
</cfform>
</cfoutput>

</body>
</html>