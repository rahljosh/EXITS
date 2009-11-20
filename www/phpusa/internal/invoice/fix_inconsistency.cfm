    <!--- Fix invoices inconsistency. Charges applied to an IntRep then student changed intrep --->

    <!--- FIX INVOICES/CHARGES --->
    <cfquery name="qGetInvoices" datasource="MySql"> 
        SELECT	
            ei.invoiceID,
            ei.intRepID
        FROM	
            egom_invoice ei
	</cfquery>    

	<cfloop query="qGetInvoices">
    
		<!--- FIX INVOICES/CHARGES --->
        <cfquery name="qGetCharges" datasource="MySql"> 
            SELECT	
                ec.invoiceID,
                ec.studentID,
                s.intRep
            FROM	
                egom_charges ec
            INNER JOIN
            	smg_students s ON s.studentID = ec.studentID
            WHERE
            	ec.invoiceID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoices.invoiceID#">
            GROUP BY
				s.intRep            	
        </cfquery>    
    
    	<!--- Only one Intl. Rep in this invoice --->        
    	<cfif qGetCharges.recordCount EQ 1 AND qGetInvoices.intRepID NEQ qGetCharges.intRep>
        
            <cfquery name="qUpdateIntRep" datasource="MySql"> 
                UPDATE
                	egom_invoice
                SET
                    intRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCharges.intRep#">
               	WHERE     	
                    invoiceID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoices.invoiceID#">
            </cfquery>    
        
        </cfif>
    
    </cfloop>

    
    <!--- FIX PAYMENTS --->
    <cfquery name="qGetPayments" datasource="MySql"> 
        SELECT	
            ep.paymentID,
            ep.intRepID,
            epc.chargeID
        FROM	
            egom_payments ep
        INNER JOIN	
            egom_payment_charges epc ON epc.paymentID = ep.paymentID
        ORDER BY
              ep.paymentID
	</cfquery>    
    
    <cfloop query="qGetPayments">
    	
        <cfquery name="qGetChargeIntRepID" datasource="MySql"> 
            SELECT
                i.invoiceID,
                i.intRepID
            FROM
                egom_invoice i 
            INNER JOIN 
                egom_charges ec ON ec.invoiceID = i.invoiceID
            WHERE
            	ec.chargeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPayments.chargeID#">
        </cfquery>    
    
    	<cfif VAL(qGetChargeIntRepID.recordCount) AND qGetPayments.intRepID NEQ qGetChargeIntRepID.intRepID>
        
        	<cfquery datasource="MySql"> 
        		UPDATE
                	egom_payments
                SET
                	intRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetChargeIntRepID.intRepID#">
        		WHERE
                	paymentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPayments.paymentID#"> 
            </cfquery>
        
        </cfif>
    
    </cfloop>
	<!--- END OF FIX INVOICES --->
