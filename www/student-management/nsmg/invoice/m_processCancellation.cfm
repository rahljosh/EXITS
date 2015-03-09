 
<!--- code called from m_misc_addCharge (charges NOT tied to a student); look for "END" comment --->
<cfif ISDEFINED('form.amount') AND form.amount IS NOT 'amount'>    	
	<cfquery name="insert_charge" datasource="MySQL">
	INSERT INTO smg_charges (type, description, amount, amount_due, agentid, date, userinput, companyid)
	VALUES ('miscellaneous','#form.description#', #form.amount#, #form.amount#, #form.agentid#,#now()#, #client.userid#, #client.companyid#)
	</cfquery>   
</cfif>
<!--- END of code called from m_misc_addCharge--->

<cfif ISDEFINED('form.stuid')>
    <cfloop index="studentid" list="#form.stuid#">
    
        <cfloop index="x" from="0" to="4" step="1"><!--- code called from m_misc_addCharge (charges TIED to a student); look for "END" comment --->
            
            <cfif ISDEFINED('form.charge#x##studentid#')>
                <cfquery name="insertMiscCharges" datasource="MySQL">
                INSERT INTO smg_charges (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                VALUES (#EVALUATE('form.agentid' & '#studentid#')#, #studentid#, 0, #EVALUATE('form.programid' & '#studentid#')#, '#EVALUATE('form.type' & '#x#' & '#studentid#')#', 'miscellaneous', #Now()#, #EVALUATE('form.amount' & '#x#'  & '#studentid#')#, #EVALUATE('form.amount' & '#x#'  & '#studentid#')#, #client.userid#, #Now()#, #EVALUATE('form.companyid' & '#studentid#')#)
                </cfquery>        
            </cfif>
        
        </cfloop><!--- END of code called from m_misc_addCharge--->
        
    
        <cfif ISDEFINED('form.cancelFee#studentid#')> 
            <cfquery name="insertCancelFee" datasource="MySQL">
            INSERT INTO smg_charges (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
            VALUES (#EVALUATE('form.agentid' & '#studentid#')#, #studentid#, 0, #EVALUATE('form.programid' & '#studentid#')#, '#EVALUATE('form.programname' & '#studentid#')#', '#EVALUATE('form.cancelType' & '#studentid#')#', #Now()#, #EVALUATE('form.cancelAmount' & '#studentid#')#, #EVALUATE('form.cancelAmount' & '#studentid#')#, #client.userid#, #Now()#, #EVALUATE('form.companyid' & '#studentid#')#)
            </cfquery>
        </cfif>
        
        <cfif ISDEFINED('form.sevis#studentid#')>  
            <cfquery name="insertCancellSevisFee" datasource="MySQL">
            INSERT INTO smg_charges (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
            VALUES (#EVALUATE('form.agentid' & '#studentid#')#, #studentid#, 0, #EVALUATE('form.programid' & '#studentid#')#, '#EVALUATE('form.programname' & '#studentid#')#', '#EVALUATE('form.sevisType' & '#studentid#')#', #Now()#, #EVALUATE('form.sevisAmount' & '#studentid#')#, #EVALUATE('form.sevisAmount' & '#studentid#')#, #client.userid#, #Now()#, #EVALUATE('form.companyid' & '#studentid#')#)
            </cfquery>
        </cfif>
    
        <cfif ISDEFINED('form.cred#studentid#')>
            <cfquery name="insertCredit" datasource="MySQL">
            INSERT INTO smg_credit (creditid, agentid, stuid, invoiceid, description, type, amount, date, companyid, chargeid, credit_type, programID)
            VALUES (0, #EVALUATE('form.agentid' & '#studentid#')#, #studentid#, 0, '#EVALUATE('form.credDescrip' & '#studentid#')#', '#EVALUATE('form.credChoose' & '#studentid#')#', #EVALUATE('form.credAmount' & '#studentid#')#, #Now()#, #EVALUATE('form.companyid' & '#studentid#')#, 0, '#EVALUATE('form.programname' & '#studentid#')#'), #EVALUATE('form.programid' & '#studentid#')#
            </cfquery>
        </cfif>
    
    </cfloop>
    
    <cfquery name="getLastInvoice" datasource="MySQL">
    SELECT MAX(invoiceid) AS invoiceid
    FROM smg_charges
    </cfquery>   
    
    <cfset lastInvoice = getLastInvoice.invoiceid>
    <cfset invoiceNumb = variables.lastInvoice + 1>    

    <cfquery name="invNumber" datasource="MySQL">
    UPDATE smg_charges
    SET invoiceid = #variables.invoiceNumb#,
    	invoice_sent = 1
    WHERE agentid = #url.userid#
    AND invoiceid = 0
    </cfquery>  
    
    <cfif ISDEFINED('form.chargeId')>   
    
        <cfloop index="chargeId" list="#form.chargeId#">
            
            <cfquery name="chargeProg" datasource="MySQL">
            SELECT s.programid, s.stuid
            FROM smg_charges s
            WHERE s.chargeid = #chargeid#
            </cfquery>
            
            <cfloop query="chargeProg">
                <cfquery name="getCancFeeInv" datasource="MySQL">
                SELECT IFNULL( MAX( s.invoiceid ) , 0 ) AS invoiceid
                FROM smg_charges s
                WHERE s.stuid = #chargeProg.stuid#
                AND s.programid = #chargeProg.programid#
                AND (s.type =  'Cancellation fee'
                OR s.type = 'Sevis fee')
                </cfquery>
            </cfloop>
            
            <cfif getCancFeeInv.invoiceid NEQ 0>
                <cfset cancFeeInv = "Canc Fee Inv ##" & #getCancFeeInv.invoiceid# & ".">
                <cfelse>
                    <cfset cancFeeInv = "No cancellation fee applies.">
            </cfif>
            
            <cfif ISDEFINED('form.chargeid#chargeId#')>
            
                <cfquery name="insertCancellation" datasource="MySQL">
                INSERT INTO smg_credit (creditid, agentid, stuid, invoiceid, description, type, amount, date, companyid, chargeid, credit_type, programID)
                VALUES (0, #EVALUATE('form.agentid' & '#chargeid#')#, #EVALUATE('stuid' & '#chargeid#')#, #EVALUATE('form.invoiceid' & '#chargeid#')#, '#EVALUATE('form.creditDescription' & '#chargeId#')# #variables.cancFeeInv#', 'cancellation', #EVALUATE('form.creditAmount' & '#chargeId#')#, #Now()#, #EVALUATE('form.companyid' & '#chargeid#')#, #chargeId#, '#EVALUATE("form.programname" & "#chargeid#")#', #EVALUATE('form.programid' & '#chargeId#')#)
                </cfquery>
                
                <cfquery name="getTotalCredit" datasource="MySQL">
                SELECT SUM(amount) AS total_charge_credited
                FROM smg_credit
                WHERE chargeid = #chargeId#
                </cfquery>
                
                <cfif getTotalCredit.total_charge_credited EQ #EVALUATE('form.amount_due' & '#chargeId#')#>
                    <cfquery name="inactivateCharge" datasource="MySQL">
                    UPDATE smg_charges
                    SET active = 0
                    WHERE chargeid = #chargeId#
                    </cfquery>
                </cfif>
                
            </cfif>
            
        </cfloop>
    
    </cfif>
    
    <cfquery name="compId" datasource="MySQL">
    SELECT DISTINCT(companyid) AS companyid
    FROM smg_credit
    WHERE creditid = 0
    AND agentid = #url.userid#
    </cfquery>
    
    <cfquery name="getLastCredit" datasource="MySQL">
    SELECT MAX(creditid) AS creditid
    FROM smg_credit
    </cfquery>
    
    <cfset lastCredit = getLastCredit.creditid>
    <cfset creditNumb = variables.lastCredit + 1>
    
    <cfloop query="compId">
        
        <cfquery name="credNumber" datasource="MySQL">
        UPDATE smg_credit
        SET creditid = #variables.creditNumb#
        WHERE agentid = #url.userid#
        AND creditid = 0
        AND companyid = #compId.companyid#
        </cfquery>
    
    </cfloop>
    
</cfif>

<cfif ISDEFINED('form.amount')>
	<script>
    opener.location.reload();
    </script>
	<cflocation url="m_misc_addCharge.cfm?userid=#url.userid#" addtoken="yes">
    <cfelse>
    	<script>
			opener.location.reload();
			window.close();
		</script>
</cfif>