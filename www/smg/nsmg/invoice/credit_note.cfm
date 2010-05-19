<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Credit Note <cfoutput>#url.creditid#</cfoutput></title>
</head>

<body>

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfparam name="linkSSL" default="s">

<cfsetting requesttimeout="300">

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


.style1 {font-size: 10px}

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
-->
</style>

<Cfoutput>

<cfif client.usertype EQ 8>
	<cfquery name="credit_check" datasource="mysql">
		SELECT agentid 
		FROM smg_credit 
		WHERE creditid = <cfqueryparam value="#url.creditid#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif credit_check.agentid NEQ client.userid> 
		<table align="center" width="90%" frame="box">
			<tr>
				<td valign="top"><img src="http#linkSSL#://www.student-management.com/nsmg/pics/error.gif"></td>
				<td valign="top"><font color="##CC3300">You can only view your invoices. The invoice that you are trying to view is not yours.  <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</td></tr>
		</table>
	<cfabort>
	</cfif>
</cfif>

<br><br>

<cfquery name="credit_info" datasource="MySQL">
SELECT sc.creditid, sc.agentid, sc.stuid, sc.invoiceid, sc.description, sc.type, sc.amount, sc.date, sc.companyid, sc.credit_type, s.firstname, s.familylastname, sp.type AS progType,
	(CASE 
			WHEN sp.type = 7 THEN 8
			WHEN sp.type = 8 THEN 8
			WHEN sp.type = 9 THEN 8
			WHEN sp.type = 11 THEN 8
			WHEN sp.type = 22 THEN 8
			WHEN sp.type = 23 THEN 8
			ELSE s.companyid
			END) AS testCompId
FROM smg_credit sc
LEFT JOIN smg_students s ON s.studentid = sc.stuid
LEFT JOIN smg_programs sp ON sc.credit_type = sp.programname
WHERE sc.creditid = #url.creditid#
</cfquery>

<table align="center">
	<Tr>
    	<td>			
			<cfif credit_info.credit_type IS 'Trainee'><!--- this cfif is good as long as the trainee invoices are not automated, which they will be in the future. THE CFELSE PART SHOULD IS GOOD AT ALL TIMES --->
              <img src="http#linkSSL#://www.student-management.com/nsmg/pics/logos/csb_banner.gif"/>
            <cfelse>
                <cfswitch expression="#credit_info.testCompId#">
                    <cfcase value="8">
                          <img src="http#linkSSL#://www.student-management.com/nsmg/pics/logos/csb_banner.gif"/>
                    </cfcase>
					<cfcase value="10">
						<img src="http#linkSSL#://jan.case-usa.org/nsmg/pics/case_banner.jpg" width="665" height="113" align="Center">
                    </cfcase>
                    <cfdefaultcase>
                        <img src="http#linkSSL#://www.student-management.com/nsmg/pics/ise_banner.jpg" align="Center">

                    </cfdefaultcase>
                </cfswitch>                        
            </cfif>
		</Td>
	</Tr>
</table>
<br><br>

<cfquery name="creditSum" datasource="MySQL">
SELECT SUM(amount) AS totalCredit
FROM smg_credit
WHERE creditid = #url.creditid#
</cfquery>

<cfquery name="company_info" datasource="MySQL">
	SELECT * 
	FROM smg_companies 
	WHERE companyid = #client.companyid#
</cfquery>

<cfquery name="agent_info" datasource="MySQL">
	SELECT *,  
		smg_countrylist.countryname, 
		billcountry.countryname as billcountryname
	FROM smg_users   
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country  
	LEFT JOIN smg_countrylist billcountry ON billcountry.countryid = smg_users.billing_country  
	WHERE userid = '#credit_info.agentid#'
</cfquery>	
	
<cfif NOT Isdefined('url.creditid') OR url.creditid EQ ''> 
	<table align="center" width="90%" frame="box">
		<tr><th colspan="2">No credit specified, please go back and select a credit note. <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
<cfabort>
</cfif>
	
<cfif credit_info.recordcount EQ 0> 
	<table align="center" width="90%" frame="box">
		<tr><th colspan="2">No credit was found with the id: #url.creditid# please go back and select a different credit note. <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
	<cfabort>
</cfif>
<br><br>

<table width=100% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF"> 
	<Tr>
		<Td bgcolor="cccccc" class="thin-border" >Bill To:</Td>
		<td rowspan=2 valign="top">  
			<table width="90%" border="0" cellspacing="0" cellpadding="2" align="right" class=thin-border>
				  <tr><td bgcolor="CCCCCC" align="center" class="thin-border-bottom"><b><FONT size="+1">Credit</FONT></b></td></tr>
				  <tr><td align="center" class="thin-border-bottom" ><B><font size=+1>###credit_info.creditid#</font></b></td></tr>
				  <tr><td bgcolor="CCCCCC" align="center" class="thin-border-bottom">Date</td></tr>
				  <tr><td  align="center" class="thin-border-bottom">#DateFormat(credit_info.date, 'mm/dd/yyyy')#</td></tr>
			</table>
		</td>
	</Tr>
	<tr>
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
	<cfif agent_info.billing_address neq agent_info.address or agent_info.billing_address2 neq agent_info.address2
	or agent_info.billing_city neq agent_info.city or  agent_info.billing_zip neq agent_info.zip>
		<tr><td>&nbsp;</td></tr>
		<Tr><td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif">Local Contact:</td></tr>
		<tr>
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
<br>

<div align="center"><img src="http#linkSSL#://www.student-management.com/nsmg/pics/detach.jpg" ></div><br>

</cfoutput>


	<table width=100% cellspacing=0 cellpadding=2 class=thin-border border=0> 	
        <tr bgcolor="CCCCCC" >
			<td class="thin-border-right-bottom">Type</td>
            <td class="thin-border-right-bottom">Invoice</td>
            <td class="thin-border-right-bottom">Student ID</td>
            <td class="thin-border-right-bottom">Description</td>
            <td class="thin-border-right-bottom" align="right">Amount</td>
            <td class="thin-border-bottom" align="right">Total</td>
		</tr>

    <cfquery name="studCred" datasource="MySQL">
    SELECT DISTINCT(stuid) AS studentid
    FROM smg_credit
    WHERE creditid = #url.creditid#
    </cfquery>        

	<cfloop query="studCred">
    
        <cfquery name="credPerStud" datasource="MySQL">
        SELECT creditid, agentid, stuid, invoiceid, description, type, amount, date, smg_credit.companyid,
        s.firstname, s.familylastname
        FROM smg_credit 
        LEFT JOIN smg_students s ON s.studentid = smg_credit.stuid
        WHERE creditid = #url.creditid#
        AND stuid = #studCred.studentid#
        </cfquery>
        
        <cfset lastRec = #credPerStud.recordCount#>
        
        <cfquery name="sumStudCred" datasource="MySQL">
        SELECT SUM(amount) AS amount
        FROM smg_credit
        WHERE creditid = #url.creditid#
        AND stuid = #studCred.studentid#
        </cfquery>
            
        <cfoutput query="credPerStud">		
            <tr>
                <td>#credPerStud.type#</td>
                <td>###credPerStud.invoiceid#</td>
                <td>###credPerStud.stuid#</td>
                <td>#credPerStud.description#</td>
                <td align="right">#LSCurrencyFormat(credPerStud.amount,'local')#</td>
                <td align="right"><cfif credPerStud.currentRow EQ credPerStud.recordCount>#LSCurrencyFormat(sumStudCred.amount, 'local')#</cfif></td>
            </tr>
        </cfoutput> 

	</cfloop>    
       
	</table><br />
<cfoutput>
	<table width=100% cellspacing=0 cellpadding=2 border=0 bgcolor="FFFFFF">	
		<tr>
			<td width="70%"><cfif credit_info.credit_type IS 'Trainee'><!--- this cfif is good as long as the trainee invoices are not automated, which they will be in the future. THE CFELSE PART SHOULD IS GOOD AT ALL TIMES --->
       					<img src="http#linkSSL#://www.student-management.com/nsmg/pics/logos/csb_logo_small.jpg" height="70"/>
                        
                        <cfelse>
                            <cfswitch expression="#credit_info.progType#">
                                <cfcase value="7,8,9,11,22,23">
                                   <img src="http#linkSSL#://www.student-management.com/nsmg/pics/logos/csb_logo_small.jpg" height="70"/>
                                </cfcase>
                                
                                <cfdefaultcase>
                                    <img src="http#linkSSL#://www.student-management.com/nsmg/pics/logos/#client.companyid#.gif" height="70"/>
                                </cfdefaultcase>
                            </cfswitch>
                            </cfif> </td>
			<td width="30%" valign="top" align="right">
				<table width=100% cellspacing=0 cellpadding=2 border=0 bgcolor="FFFFFF">	
					<tr>
						<td bgcolor="CCCCCC" class="thin-border-left-bottom-top" align="right"><b>TOTAL CREDIT/CANCELED</b></td>
						<td bgcolor="CCCCCC" class="thin-border-right-bottom-top" align="right"><b>#LSCurrencyFormat(creditSum.totalCredit, 'local')#</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<br><br>

</cfoutput>

</body>
</html>