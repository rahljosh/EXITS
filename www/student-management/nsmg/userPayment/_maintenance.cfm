<!--- ------------------------------------------------------------------------- ----
	
	File:		_initial.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Intial Page - User Payments
				
				index.cfm?curdoc=userPayment/index&action=searchRepresentative
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.companyID" default="0">
    <cfparam name="FORM.count" default="0">
    
    <!--- FORM Submitted --->
    <cfif FORM.submitted>
    
        <cfloop From = "1" To = "#form.count#" Index = "x">
         
            <cfquery name="update_amount" datasource="mySQL">
            	UPDATE 
                	smg_payment_amount
                SET 
                	amount = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Evaluate("form." & x & "_amount")#">
                WHERE 
                	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.companyID#">
                AND 
                	paymentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate("form." & x & "_paymentid")#">
            </cfquery>
            
        </cfloop> 	
    
    	<cfscript>
			// Set Page Message
			SESSION.pageMessages.Add("Form successfully submitted.");
		</cfscript>
    
    </cfif>
    
    <cfquery name="qGetPaymentInformation" datasource="MySql">
        SELECT 
        	companyshort, 
            type, 
            amount, 
            paymentid
        FROM 
	        smg_payment_amount spa
        INNER JOIN 
        	smg_companies ON smg_companies.companyID = spa.companyID
        LEFT OUTER JOIN 
        	smg_payment_types ON smg_payment_types.id = spa.paymentid
        WHERE 
        	spa.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyID#">
        ORDER BY 
        	spa.companyID
    </cfquery>
    
    <cfinclude template="../querys/get_company_short.cfm">

</cfsilent>

<cfoutput>

    <!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="divOnly"
        width="100%"
        />
    
    <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=maintenance">
        <input type="hidden" name="submitted" value="1">
        <input type="hidden" name="companyID" value="#client.companyID#">
        <input type="hidden" name="count" value="#qGetPaymentInformation.recordcount#">

        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:10px;"> 
            <tr>
                <td colspan="3" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">#companyshort.companyshort# - Payment Representative Maintenance</td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="20%">Company</td>
                <td width="20%">Type</td>
                <td width="60%">Amount</td>
            </tr>
            <cfloop query="qGetPaymentInformation">
                <tr bgcolor="###iif(qGetPaymentInformation.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td>#companyshort#</td>
                    <td>#type# <input type="hidden" name="#qGetPaymentInformation.currentrow#_paymentid" value="#qGetPaymentInformation.paymentid#"></td>
                    <td><input type="text" name="#qGetPaymentInformation.currentrow#_amount" size="6"  maxlength="6" value="#amount#"></td>
                </tr>
            </cfloop>
            <tr style="background-color:##E2EFC7;">
                <td colspan="3" align="center">
                	<a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index"><img src="pics/back.gif" border="0" align="bottom"></a>
                    &nbsp; &nbsp;
                    <input name="submit" type="image" src="pics/update.gif" border="0" alt="  Update  ">
                </td>
            </tr>
        </table>
    </form>

</cfoutput>
