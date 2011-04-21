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
         
            <Cfquery name="update_amount" datasource="mySQL">
            	UPDATE 
                	smg_payment_amount
                SET 
                	amount = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Evaluate("form." & x & "_amount")#">
                WHERE 
                	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.companyid#">
                AND 
                	paymentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate("form." & x & "_paymentid")#">
            </Cfquery>
            
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
        	smg_companies ON smg_companies.companyid = spa.companyid
        LEFT OUTER JOIN 
        	smg_payment_types ON smg_payment_types.id = spa.paymentid
        WHERE 
        	spa.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        ORDER BY 
        	spa.companyid
    </cfquery>
    
    <cfinclude template="../querys/get_company_short.cfm">

</cfsilent>

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="helpdesk.gif"
        tableTitle="#companyshort.companyshort# - Payment Rep Maintenance"
        width="100%"
    />    
    
    <!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />
    
    <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=maintenance">
        <input type="hidden" name="submitted" value="1">
        <input type="hidden" name="companyid" value="#client.companyid#">
        <input type="hidden" name="count" value="#qGetPaymentInformation.recordcount#">
        
        <table border="0" cellpadding=4 cellspacing=0 class="section" width=100%>
        <tr>
            <td align="center">
                <table cellpadding=2 cellspacing=0 width="50%" border="1" bordercolor="CCCCCC">
                    <tr>	
                        <th>Company</th>
                        <th>Type</th>
                        <th>Amount</th>
                    </tr>
                    <cfloop query="qGetPaymentInformation">
                    <tr>
                        <td>#companyshort#</td>
                        <td>#type# <input type="hidden" name="#qGetPaymentInformation.currentrow#_paymentid" value="#qGetPaymentInformation.paymentid#"></td>
                        <td><input type="text" name="#qGetPaymentInformation.currentrow#_amount" size="6"  maxlength="6" value="#amount#"></td>
                    </tr>
                    </cfloop>
                </table>
            </td>
        </tr>
        <tr>
            <td align="center">
                <a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index"><img src="pics/back.gif" border="0" align="bottom"></a> &nbsp; &nbsp; 
                <input name="Submit" type="image" src="pics/update.gif" border="0" alt="  Update  " submitOnce>
            </td>
        </tr>	
        </table>
    </form>

	<!--- Table Footer --->
    <gui:tableFooter />

</cfoutput>
