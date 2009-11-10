<cfsetting requesttimeout="99999">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Invoice <cfoutput>#url.id#</cfoutput></title>
<link rel="stylesheet" href="../profile.css" type="text/css">
<style type="text/css">
<!--

body{
	font-family: Arial, Helvetica, sans-serif;	
}

#page_Area {
	background-color: #ffffff;
	height: 11in;
	width: 570px;
}

#title{
	background-posistion: center;
	color: #FF0000;
	}
	
#titleleft{
	font-size: x-small;	
}
.title_center{
	font-size: 12px;
	font-family: Arial, Helvetica, sans-serif;
	color: #000000;
	font-style: normal;
	font-weight: bold;
	color: #000000;
	
}

.application_section_header{
	border-bottom: 1px dashed Gray;
	text-transform: uppercase;
	letter-spacing: 5px;
	width:100%;
	text-align:center;
	background;
	background: #DCDCDC;
	font-size: small;
}
.application_section_header_bold {
	border-bottom: 1px dashed Gray;
	text-transform: uppercase;
	letter-spacing: 5px;
	width:100%;
	text-align:center;

	background;
	background: #DCDCDC;
	font-size: small;
	font-weight: bold;

	}.acceptance_letter_header {
	border-bottom: 1px dashed Gray;
	text-transform: capitalize;
	letter-spacing: normal;
	width:100%;
	text-align:left;

	background;
	background: #DCDCDC;
	font-size: small;
	font-weight: bold;
}
.profile_section_header {

	border-bottom: 1px dashed Gray;
	text-transform: uppercase;
	letter-spacing: 5px;
	width:100%;
	text-align:center;
	background;
	background: #DCDCDC;
	font-size: x-small;
}

.sub_profile_section_header {

	border-bottom: 1px dashed Gray;
	width:100%;
	text-align:center;
	background;
	background: #DCDCDC;
	font-size: x-small;
}
.invoice_header{
	text-align:center;
	img-aling:center;
}

table,tr,td{
	font-size:12px;
}

#pagecell_reports {
	width:100%;
	background-color: #ffffff;
	font-size:10pt;
	position: absolute;
}
  
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #000000; }

.thin-border{ border: 1px solid #000000;}
.thin-border-right{ border-right: 1px solid #000000;}
.thin-border-left{ border-left: 1px solid #000000;}
.thin-border-right-bottom{ border-right: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-bottom{  border-bottom: 1px solid #000000;}
.thin-border-left-bottom{ border-left: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-right-bottom-top{ border-right: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-top{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-right{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-left-top-right{ border-left: 1px solid #000000; border-top: 1px solid #000000; border-right: 1px solid #000000;}
.style1 {
	color: #FF0000;
	font-weight: bold;
}
.style3 {color: #FF0000; font-weight: bold; font-size: 16px; }
-->
</style>
</head>

<body>

<Cfoutput>
	<cfif client.usertype GT 4>
        <cfquery name="invoice_check" datasource="mysql">
            select distinct agentid from smg_charges
            where invoiceid = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif invoice_check.agentid neq client.userid> 
            <table align="center" width="90%" frame="box">
                <tr>
                    <td valign="top"><img src="http://www.student-management.com/nsmg/pics/error.gif"></td>
                    <td valign="top"><font color="##CC3300">You can only view your invoices. The invoice that you are trying to view is not yours.  <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</td>
                </tr>
            </table>
            <cfabort>
        </cfif>
    </cfif>
    
    <br>
    <br>

<cfquery name="invoice_info" datasource="MySQL">
select s.*, sp.type AS progType, s.companyid, 
		(CASE 
			WHEN sp.type = 7 THEN 8
			WHEN sp.type = 8 THEN 8
			WHEN sp.type = 9 THEN 8
			WHEN sp.type = 11 THEN 8
			WHEN sp.type = 22 THEN 8
			WHEN sp.type = 23 THEN 8
			ELSE s.companyid
			END) AS testCompId
from smg_charges s
LEFT JOIN smg_programs sp ON sp.programid = s.programid
where s.invoiceid = #url.id#
order by s.stuid, s.chargeid
</cfquery>
    
    <table align="center">
    <Tr>
    	<td>
			<cfif invoice_info.type IS 'trainee program'><!--- this cfif is good as long as the trainee invoices are not automated, which they will be in the future. THE CFELSE PART SHOULD IS GOOD AT ALL TIMES --->
            <img src="http://www.student-management.com/nsmg/pics/logos/csb_banner.gif"/>
            
            <cfelse>
                <cfswitch expression="#invoice_info.testCompId#">
                    <cfcase value="8">
                        <img src="http://www.student-management.com/nsmg/pics/logos/csb_banner.gif"/>
                    </cfcase>
                    
                    <cfcase value="10">
						<img src="http://jan.case-usa.org/nsmg/pics/case_banner.jpg" width="665" height="113" align="Center">
                    </cfcase>
                    
                    <cfdefaultcase>
						<img src="http://www.student-management.com/nsmg/pics/smg_banner.jpg" align="Center">
                    </cfdefaultcase>
                </cfswitch>                        
            </cfif>                   
    	</Td>
    </Tr>
    </table>
    <br>
    <br>
        
    <cfif not isdefined('url.id') or url.id is ''> 
        <table align="center" width="90%" frame="box">
        <tr><th colspan="2">No invoice specified, please go back and select an invoice. <br>If you recieved this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
        </table>
        <cfabort>
    </cfif>
    
<cfif invoice_info.recordcount is 0> 
        <table align="center" width="90%" frame="box">
        <tr><th colspan="2">No invoice was found with the id: #url.id# please go back and select a different invoice. <br>If you recieved this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
        </table>
        <cfabort>
    </cfif>
</Cfoutput>

<cfoutput>

<br>
<br>
<cfif not isdefined('url.id') or url.id is ''> 
        <table align="center" width="90%" frame="box">
        <tr><th colspan="2">No invoice specified, please go back and select an invoice. <br>If you recieved this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
        </table>
		<cfabort>
</cfif>

<table width=100% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" > 


<!--- <cfquery name="invoice_info" datasource="MySQL">
select * from smg_charges
where invoiceid = #url.id#
order by stuid
</cfquery>
	<cfif invoice_info.recordcount is 0> 
				<table align="center" width="90%" frame="box">
	<tr><th colspan="2">No invoice was found with the id: #url.id# please go back and select a different invoice. <br>If you recieved this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
	<cfabort>
	</cfif> --->

<cfquery name="company_info" datasource="MySQL">
select * from smg_companies 
where companyid = #client.companyid#
</cfquery>

<cfquery name="agent_info" datasource="MySQL">
select *,  
  smg_countrylist.countryname, 
  billcountry.countryname as billcountryname
 
  from smg_users   
  LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country  
  LEFT JOIN smg_countrylist billcountry ON billcountry.countryid = smg_users.billing_country  
  where userid = #invoice_info.agentid# 
</cfquery>

<!----
<cfquery name="agent_info" datasource="MySQL">
	select businessname, firstname, lastname, address, address2, city, userid, email, phone, fax, zip, billing_company, billing_address, billing_address2, billing_phone, billing_city, billing_zip, billing_fax, billing_country, smg_countrylist.countryname
	from smg_users
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country 
	where userid = #invoice_info.agentid#
</cfquery>
---->
<Tr>
<td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif">Remit To:</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><Td bgcolor="cccccc" class="thin-border" >Bill To:</Td><td rowspan=2>  
		<table border="0" cellspacing="0" cellpadding="2" align="right" class=thin-border>
		
		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom"><b><FONT size="+1">Invoice</FONT></b></td>
			
		  </tr>
		  <tr>
			<td align="center" class="thin-border-bottom" ><B><font size=+1> ## #invoice_info.invoiceid#</b></td>
			
		  </tr>
		  		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom">Date</td>
			
		  </tr>
		  <tr>
			<td  align="center" class="thin-border-bottom">#DateFormat(invoice_info.invoicedate, 'mm/dd/yyyy')#</td>
			
		  </tr>
		  <tr>
			<td bgcolor="CCCCCC" align="center"  class="thin-border-bottom">Terms </td>
			
		  </tr>
		   <tr>
			<td align="center" >Due Upon Receipt</td>
			
		  </tr>
		
		</table>
</td>
</Tr>
	<tr>
	
	
	<td  valign="top" class="thin-border-left-bottom-right">
	<B></B><br>
    	<cfif invoice_info.type IS 'trainee program'><!--- this cfif is good as long as the trainee invoices are not automated, which they will be in the future. THE CFELSE PART SHOULD IS GOOD AT ALL TIMES --->
                <span class="style3">CSB International</span><br>
                JPMorgan Chase<br>
                595 Sunrise Highway<br>
                West Babylon, NY 11704<br>
                ABA/Routing: 021000021<br>
                <span class="style3">Account: 745938175</span><br>
                SWIFT code: CHASUS33<br>
                
                <cfelse>
                    <cfswitch expression="#invoice_info.testCompId#">
                        <cfcase value="8">
                            <span class="style3">CSB International</span><br>
                            JPMorgan Chase<br>
                            595 Sunrise Highway<br>
                            West Babylon, NY 11704<br>
                            ABA/Routing: 021000021<br>
                            <span class="style3">Account: 745938175</span><br>
                            SWIFT code: CHASUS33<br>            
                        </cfcase>
						
                        <cfcase value="10">
                            <span class="style3">Cultural Academic Student Exchange</span><br>
                            Chase Bank<br>
                            Red Bank, NJ 07701<br>
                            <br>
                            ABA/Routing: 021202337<br>
                            <span class="style3">Account: 747523579</span><br>
                            SWIFT## : CHASUS33<br>            
                        </cfcase>
                        
                        <cfdefaultcase>
                            Student Management Group<br>
                            JPMorgan Chase<br>
                            403 N. Little E. Neck Rd.<br>
                            West Babylon, NY 11704<br>
                            ABA/Routing: 021000021<br>
                            Account: 773701750<br>
                            SWIFT code: CHASUS33<br>
                        </cfdefaultcase>
                    </cfswitch>  
        </cfif>
	</td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td valign=top class="thin-border-left-bottom-right">

		#agent_info.billing_company#<br>
		#agent_info.billing_contact#<br>
		#agent_info.billing_address#<br>
		<cfif #agent_info.billing_address2# is ''><cfelse>#agent_info.billing_address2#</cfif>
		#agent_info.billing_city# #agent_info.billcountryname# #agent_info.billing_zip#
		<br>
		E: #agent_info.billing_email#<br>
		P: #agent_info.billing_phone#<br>
		F: #agent_info.billing_fax#<br>
		
		
		
		</td>

</tr>
<cfif #agent_info.billing_address# neq #agent_info.address# or #agent_info.billing_address2# neq #agent_info.address2#
		or #agent_info.billing_city# neq #agent_info.city# or  #agent_info.billing_zip# neq #agent_info.zip#>

<tr>
	<td>&nbsp;</td>
</tr>
<Tr>
	<td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif">Local Contact:</td>
</tr>
<tr></tr>
	<td valign=top class="thin-border-left-bottom-right">
		#agent_info.businessname# (#agent_info.userid#)<br>
		#agent_info.firstname# #agent_info.lastname#<br>
		#agent_info.address#<br>
		<cfif #agent_info.address2# is ''><cfelse>#agent_info.address2#</cfif>
		#agent_info.city#, #agent_info.countryname# #agent_info.zip#<br>
		E: #agent_info.email#<br>
		P: #agent_info.phone#<br>
		F: #agent_info.fax#<br>
		</td>
</Tr>
</cfif>
</table>
<!----<Table width=100%>
<tr><td align="left">


		<td align="right" valign="bottom">
					<table border="0" cellspacing="0" cellpadding="2" class="nav_bar" align="right">
		
		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-right-bottom">Amount Due</td>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom">Amount Enclosed</td>
		  </tr>
		  <tr>
			<td align="center" class="thin-border-right-bottom" >#DateFormat(now(), 'mm/dd/yy')#</td>
			<td align="center" class="thin-border-bottom"><br><Br></td>
		  </tr>
		</td>
		</table>
		</td>
	</tr>
</Table>---->
</td>

</tr>

</table>
</cfoutput>
<br>

<!-----Invoice with Students---->
		<div align="center"><img src="http://www.student-management.com/nsmg/pics/detach.jpg" ></div><br>
		<table width=100% cellspacing=0 cellpadding=2 class=thin-border border=0> 
			<tr bgcolor="CCCCCC" >
				<td class="thin-border-right-bottom">
                Student
                </td>
                <td class="thin-border-right-bottom">
                Description / Type
                </td>
                <td class="thin-border-right-bottom" align="right">
                Charge
                </td>
                <td class="thin-border-bottom" align="right">
                Total
                </td>
			</tr>

			<cfset previous_student = 0>
			<Cfset current_recordcount = 1>
            
		<cfoutput query="invoice_info">

			<cfset current_student = #stuid#>
            
            <!--- select query to view high-school OR work invoice --->
			<cfswitch expression="#progType#">
            	<cfcase value="7,8,9,11,22,23"><!--- work programs --->            
                    <cfquery name="student_name" datasource="mysql">
                    SELECT firstname, lastname AS familylastname
                    FROM extra_candidates
                    WHERE candidateid = #stuid#
                    </cfquery>
                </cfcase>
				<cfdefaultcase>
                    <cfquery name="student_name" datasource="mysql">
                    SELECT firstname, familylastname
                    FROM smg_students
                    WHERE studentid = #stuid#
                    </cfquery>
               	</cfdefaultcase>
			</cfswitch>
            
			<cfquery name="charge_count" datasource="MySQL">
			select chargeid from smg_charges
			where invoiceid = #id# and stuid = #stuid#
			</cfquery>
            
			<cfquery name="total_student" datasource="MySQL">
			select sum(amount) as total_stu_amount
			from smg_charges
			where invoiceid = #id# and stuid = #stuid#
			</cfquery>

	<cfswitch expression="#progType#">
      <cfcase value="7,8,9,11,22,23"><!--- work programs --->
				<tr>
					<td>
					<cfif current_student is not #previous_student#>#student_name.firstname# #student_name.familylastname# (#stuid#)<cfelse></cfif>
                    </td>
                    <td>
                    #description# / #type#
                  </td>
                    <td align="right">
                    #LSCurrencyFormat(amount,'local')#
                  </td>
                    <td align="right">
                    
					<cfif current_student is previous_student>
                    	<cfset current_recordcount = #current_recordcount# +1>
                    	<cfelse>
                    		<cfset current_recordcount = 1>
                    </cfif>
                    <cfset previous_student = #stuid#>
                    
					<cfif #current_recordcount# is #charge_count.recordcount#>#LSCurrencyFormat(total_student.total_stu_amount, 'local')#</cfif>
                    </td>
				</tr>
      
      </cfcase>
      
      <cfdefaultcase>

				<tr>
					<td>
					<cfif current_student is not #previous_student#>#student_name.firstname# #student_name.familylastname# (#stuid#)<cfelse></cfif>
                    </td>
                    <td>
                    #description# / #type#
                  </td>
                    <td align="right">
                    #LSCurrencyFormat(amount,'local')#
                  </td>
                    <td align="right">
					<cfif #current_recordcount# is #charge_count.recordcount#>#LSCurrencyFormat(total_student.total_stu_amount, 'local')#</cfif>
                    </td>
				</tr>
                
                <!--- only show deposit invoice in the FINAL invoice, where there's a program fee charge --->
                <cfquery name="checkProgFee" datasource="MySQL">
                SELECT type
                FROM smg_charges
                WHERE invoiceid = #url.id#
                AND stuid = #stuid#
                AND type = 'Program fee'
                </cfquery>
		
        <cfif checkProgFee.recordCount GT 0>                      	
			<cfif #current_recordcount# is #charge_count.recordcount#>
                <!----Check for invoice with deposit amount on it---->
                <cfquery name="deposit_invoice" datasource="MySQL">
                select invoicedate, invoiceid, amount, description, type
                from smg_charges where stuid = #stuid# and type = 'deposit' and programid = #programid# and invoiceid <> #url.id#
                </cfquery>
                <!----Check for multiple invoices for THIS student.  If multiple invoices are found, only show deposit on invoice# that is lowest.
                in case fees were generated on an invoice after the initial final invoice---->
                <cfquery name="check_multiple_invoices" datasource="MySQL">
                SELECT DISTINCT (s.invoiceid) AS invoiceid, s.type
                FROM smg_charges s
                WHERE s.stuid =#stuid#
                AND programid = #programid#
                AND (TYPE = 'deposit'
                OR TYPE = 'program fee')
                ORDER BY invoiceid
                </cfquery>
                <Cfset show_deposit = 1>
                <cfif check_multiple_invoices.recordcount gt 2>
                    <cfloop query="check_multiple_invoices">
                        <cfif check_multiple_invoices.type IS 'deposit'>
                            <cfset deposit_invoice_id = #invoiceid#>
                        <cfelseif check_multiple_invoices.type IS 'program fee'>
                            <cfset final_invoice_id =#invoiceid#>
                        <cfelse>
                        </cfif>
                    </cfloop>
                    <cfif #url.id# eq #deposit_invoice_id# or #url.id# eq #final_invoice_id#>
                        <cfset show_deposit = 1>
                    <cfelse>
                        <cfset show_deposit = 0>
                    </cfif>
                </cfif>
                <cfif show_deposit is 1>
                    <cfif deposit_invoice.recordcount is 0>
                        <Cfset current_recordcount = 0>
                        <cfelse>
                            <cfif deposit_invoice.recordcount is 0>
                                <cfset deposit_invoice.amount = 0>
                            </cfif>
                        
                            <cfset neg_deposit = #deposit_invoice.amount# * -1>
                        
                        
                        
                            <tr>
                                <td></td><td>#deposit_invoice.description# / #deposit_invoice.type# <font size=-2>- <a href="invoice_view.cfm?id=#deposit_invoice.invoiceid#">invoice ## #deposit_invoice.invoiceid#</a></font></td><td align="right">#LSCurrencyFormat(neg_deposit,'local')#</td><td align="right"><cfset new_line_bal = #total_student.total_stu_amount# + #neg_deposit#>#LSCurrencyFormat(new_line_bal, 'local')#<Cfset current_recordcount = 0></td>
                            </tr>
                    </cfif>
                    <cfelse>
                        <Cfset current_recordcount = 0>
                </cfif>
            </cfif>
        </cfif>
        
		<cfset previous_student = #stuid#>
        
		<cfif current_student is previous_student>
			<cfset current_recordcount = #current_recordcount# +1>
		</cfif>
        
    </cfdefaultcase>
  </cfswitch>
  
</cfoutput>
	
			
		</table>
		<!----Retrieve Total Due from Invoice---->
		<cfquery name="total_Due" datasource="MySQL">
			select sum(amount_due) as total_due 
			from smg_charges
			where invoiceid = #url.id#
			</cfquery>
		<!----Retrieve Total Deposits Accounted for on this invoice---->
		
		
		<table width=100% cellspacing=0 cellpadding=2 border=0 bgcolor="FFFFFF">	
			<cfset charges.datepaid = ''>
			<tr>
				<td  rowspan=3 width=470>
				<cfoutput>
					<cfif invoice_info.type IS 'trainee program'><!--- this cfif is good as long as the trainee invoices are not automated, which they will be in the future. THE CFELSE PART SHOULD IS GOOD AT ALL TIMES --->
       					<img src="http://www.student-management.com/nsmg/pics/logos/csb_logo_small.jpg" height="100"/>
                        
                        <cfelse>
                            <cfswitch expression="#invoice_info.progType#">
                                <cfcase value="7,8,9,11,22,23">
                                    <img src="http://www.student-management.com/nsmg/pics/logos/csb_logo_small.jpg" height="100"/>
                                </cfcase>
                                
                                <cfdefaultcase>
                                    <img src="http://www.student-management.com/nsmg/pics/logos/#invoice_info.companyid#.gif" height="100"/>
                                </cfdefaultcase>
                            </cfswitch>                        
                        
                    </cfif>
                    
				</cfoutput></td>
			  <td rowspan=3<cfif charges.datepaid is ''>><cfelse> background="../pics/paid.jpg" align="center" width=146><cfoutput><font color="b31633" size=+1>#DateFormat(charges.datepaid, 'mm/dd/yyyy')#</cfoutput></cfif></td><td align="left" width=120 class="thin-border-left" ><b>SUB - TOTAL</td><td align="right" class="thin-border-right"><b><cfoutput>#LSCurrencyFormat(total_due.total_due,'local')#</cfoutput></td>
			</tr>
			

			<tr>
			
			
				<td align="left" width=120 bgcolor="#CCCCCC" class="thin-border-left-bottom-top"><b>TOTAL DUE</b></td><td align="right" bgcolor="CCCCCC" class="thin-border-right-bottom-top"><b><cfoutput>#LSCurrencyFormat(total_due.total_due, 'local')#</cfoutput></td>
			</tr>
			<tr>
				<td colspan=5 DIV ALIGN="CENTER"><b></b></td>
			</tr>
		</table>
		
<br>
		<br>
		

		</div>
</body>
</html>