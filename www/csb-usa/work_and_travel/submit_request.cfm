<!--- Kill extra output --->
<cfsilent>
    <cfparam name="idnumber" default="Not filled in the request form">
	<cfparam name="sevis" default="Not filled in the request form">
	<cfparam name="lastname" default="Not filled in the request form">
	<cfparam name="firstname" default="Not filled in the request form">
	<cfparam name="middlename" default="Not filled in the request form">
	<cfparam name="street" default="Not filled in the request form">
	<cfparam name="city" default="Not filled in the request form">
	<cfparam name="state" default="Not filled in the request form">
	<cfparam name="zip" default="Not filled in the request form">
	<cfparam name="email" default="Not filled in the request form">
	<cfparam name="phone" default="Not filled in the request form">
	<cfparam name="comment" default="Not filled in the request form">
    <cfparam name="upload" default="Not filled in the request form">
</cfsilent>

<html>
<head>
<title>:: CSB International : Emplyers ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../style.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<cfoutput>

<!--- Check In --->
<cfif url.request is 'checkin'>

	<cfsavecontent variable="checkInForm">
        Student ID Number: #FORM.idnumber#<br>
        SEVIS Number: #FORM.sevis#<br>
        Last Name: #FORM.lastname#<br>
        First Name: #FORM.firstname#<br>
        Middle Name: #FORM.middlename#<br>
        E-Mail Address: #FORM.email#<br><br>
        
        ------------------------------------------<br>
        Employer Information<br>
        ------------------------------------------<br>
        
        Company name: #FORM.companyName#<br>
        Street Address: #FORM.companyStreet#<br>
        City: #FORM.CompanyCity#<br>
        State: #FORM.companyState#<br>
        Zip: #FORM.companyZip#<br>
        Primary Contact/Supervisor: #FORM.companyContact#<br>
        Phone Number: #FORM.companyPhone#<br><br>
    
        ------------------------------------------<br>
        Housing Information<br>
        ------------------------------------------<br>
        
        Street address in US: #FORM.street#<br>
        City: #FORM.city#<br>
        State: #FORM.state#<br>
        ZIP code: #FORM.zip#<br>
        Phone number: #FORM.phone#<br><br>
    
        Comments: #FORM.comment#    
	</cfsavecontent>    

    <cfmail from="#APPLICATION.EMAIL.CSB.from#" to="#APPLICATION.EMAIL.CSB.contact#" subject="#FORM.lastname#, #FORM.firstname# - Validation" type="html">

        SUMMER WORK & TRAVEL - CHECK-IN / VALIDATION from the CSB web site on #dateformat(Now())# #TimeFormat(now())#. 
      	
        <br><br>
        #checkInForm#
      	<br><br>
        --
    </cfmail>
    
    <table width="871px" height="435px" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01">
        <tr>
            <td height="131" background="images/top.jpg">
                <table width="99%" border="0">
                    <tr>
                        <td height="90" colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <a href="../index.cfm"><img src="images/transparent.gif" alt="" width="250" height="83" border="0"></a></td>
                    </tr>
                    <tr>
                        <td width="325">&nbsp;</td>
                        <td><cfinclude template="menu.cfm"></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td height="252" valign="top" background="images/back-table.png">
        	
                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="5%" height="26">&nbsp;</td>
                        <td width="90%" valign="bottom" class="top"><p><a href="index.cfm" class="LinkItens">Home</a> &gt; Check In</p></td>
                        <td width="5%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td height="17" colspan="3"><hr width="94%" color="##CCCCCC"></td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                </table>
                
                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="5%">&nbsp;</td>
                        <td width="90%" class="text">
                            <strong>The following information has been succesfully submitted to CSB.</strong><br>
                            <table width="90%" align="center">
                                <tr>
                                    <td class="text">
										#checkInForm#
                                      </td>
                                  </tr>
                            </table>
                            <div align="center"><br>
								<strong>Thank you!</strong></div>
                            </div> <br>
                        </td>
                        <td width="5%">&nbsp;</td>
                    </tr>
                </table>
        	</td>
		</tr>
        <tr>
            <td height="52" background="images/bottom.png" align="center"><cfinclude template="bottom.cfm"></td>
        </tr>
    </table>

<!--- Address Change --->    
<cfelse>
    
    <cfsavecontent variable="changeAddressForm">
        Student ID Number: #FORM.idnumber2#<br>
        Last Name: #FORM.lastname2#<br>
        First Name: #FORM.firstname2#<br>
        Middle Name: #FORM.middlename2#<br>
        Email Address: #FORM.email2#<br><br>
        
        ----------------------------------------<br>
        New employer information<br>
        ----------------------------------------<br>
        Company name: #FORM.company#<br>
        Street address: #FORM.compaddress#<br>
        City: #FORM.compcity#<br>
        State: #FORM.compstate#<br>
        ZIP code: #FORM.compzip#<br>
        Primary Contact: #FORM.compcontact#<br>
        Phone Number: #FORM.comphone#<br>
        Email Address: #FORM.compemail#<br>
        
        <cfif LEN(FORM.UploadFile)>        
	    Attached File: #FileName#<br><br>
        <cfelse>
        <br>    
    	</cfif> 
           
        ----------------------------------------<br>
        New housing information<br>
        ----------------------------------------<br>
        Street address in US: #FORM.housingaddress#<br>
        City: #FORM.housingcity#<br>
        State: #FORM.housingstate#<br>
        ZIP code: #FORM.housingzip#<br>
        Phone Number: #FORM.housingphone#<br>
    </cfsavecontent>
    
    <cfmail from="#APPLICATION.EMAIL.CSB.from#" to="#APPLICATION.EMAIL.CSB.contact#" subject="#FORM.lastname2#, #FORM.firstname2#  - Validation" type="html">

        <cfif LEN(FORM.UploadFile)>
            <cffile action="upload" fileField="UploadFile" destination="/var/www/html/intoedventures/uploaded/job-offers/" nameConflict="overwrite" mode="777">
            <cfmailparam file="#CFFILE.ServerDirectory#/#CFFILE.ServerFile#">
            <cfset FileName = file.ServerFileName>
        <cfelse>
            <cfset FileName = "No File Attached!">
        </cfif>
        
        SUMMER WORK & TRAVEL - CHANGE OF EMPLOYER/ADDRESS from the CSB web site on #dateformat(Now())# #TimeFormat(now())#.
      
      	<br><br>            
        #changeAddressForm#
        <br><br>            
        --
    </cfmail>

    <table width="871px" height="435px" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01">
        <tr>
            <td height="131" background="images/top.jpg">
                <table width="99%" border="0">
                    <tr>
                        <td height="90" colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <a href="../index.cfm"><img src="images/transparent.gif" alt="" width="250" height="83" border="0"></a></td>
                    </tr>
                    <tr>
                        <td width="325">&nbsp;</td>
                        <td><cfinclude template="menu.cfm"></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
	    	<td height="252" valign="top" background="images/back-table.png">
                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="5%" height="26">&nbsp;</td>
                        <td width="90%" valign="bottom" class="top"><p><a href="index.cfm" class="LinkItens">Home</a> &gt; Check In</p></td>
                        <td width="5%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td height="17" colspan="3"><hr width="94%" color="##CCCCCC"></td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                </table>
    
                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="5%">&nbsp;</td>
                        <td width="90%" class="text">
                            <strong>The following information has been succesfully submitted to CSB.</strong></div><br>
                            <table width="90%" align="center">
                                <tr>
                                    <td class="text">
										#changeAddressForm#
                                    </td>
                                </tr>
                            </table>
                            <div align="center"><br>
                              <strong>Thank you!</strong></div>
                            </div> <br>
                        </td>
                        <td width="5%">&nbsp;</td>
                    </tr>
                </table>
        	</td>
		</tr>
        <tr>
            <td height="52" background="images/bottom.png" align="center"><cfinclude template="bottom.cfm"></td>
        </tr>
    </table>
    </cfif>

</cfoutput>

</body>
</html>