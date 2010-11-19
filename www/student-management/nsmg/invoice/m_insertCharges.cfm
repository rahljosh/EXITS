<cfquery name="getLastCharge" datasource="MySQL">
SELECT MAX(invoiceid) AS invoiceid
FROM smg_charges
</cfquery>

<cfset invoiceNumber = getLastCharge.invoiceid + 1>

<cfloop index="studentId" list="#form.candidateId#">
	<cfif ISDEFINED('studentId')>
    
  		<cfif #EVALUATE('form.' & '#studentId#' & 'typeProgramFee')# IS NOT '' >    
            <cfquery name="insertProgramFee" datasource="MySQL">
                INSERT INTO smg_charges
                    (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                VALUES
                    (#EVALUATE('form.' & 'agentId' & '#studentId#')#, #studentId#, #variables.invoiceNumber#, #EVALUATE('form.' & 'programId' & '#studentId#')#, '#EVALUATE('form.' & 'programName' & '#studentId#')#', '#EVALUATE('form.' & '#studentId#' & 'typeProgramFee')#', #Now()#, #EVALUATE('form.' & '#studentId#' & 'programFeeAmount')#, #EVALUATE('form.' & '#studentId#' & 'programFeeAmount')#, #client.userid#, #Now()#, #EVALUATE('form.' & 'companyId' & '#studentId#')#)
             </cfquery>
         </cfif>
         
         <cfif #EVALUATE('form.' & '#studentId#' & 'typeInsurance')# IS NOT ''>
             <cfquery name="insertInsurance" datasource="MySQL">
                INSERT INTO smg_charges
                    (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                VALUES
                    (#EVALUATE('form.' & 'agentId' & '#studentId#')#, #studentId#, #variables.invoiceNumber#, #EVALUATE('form.' & 'programId' & '#studentId#')#, '#EVALUATE('form.' & 'programName' & '#studentId#')#', '#EVALUATE('form.' & '#studentId#' & 'typeInsurance')#', #Now()#, #EVALUATE('form.' & '#studentId#' & 'insuranceAmount')#, #EVALUATE('form.' & '#studentId#' & 'insuranceAmount')#, #client.userid#, #Now()#, #EVALUATE('form.' & 'companyId' & '#studentId#')#)
             </cfquery>
         </cfif>
         
         <cfif #EVALUATE('form.' & '#studentId#' & 'typePlacementFee')# IS NOT ''>
             <cfquery name="insertPlacementFee" datasource="MySQL">
                INSERT INTO smg_charges
                    (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                VALUES
                    (#EVALUATE('form.' & 'agentId' & '#studentId#')#, #studentId#, #variables.invoiceNumber#, #EVALUATE('form.' & 'programId' & '#studentId#')#, '#EVALUATE('form.' & 'programName' & '#studentId#')#', '#EVALUATE('form.' & '#studentId#' & 'typePlacementFee')#', #Now()#, #EVALUATE('form.' & '#studentId#' & 'placementFeeAmount')#, #EVALUATE('form.' & '#studentId#' & 'placementFeeAmount')#, #client.userid#, #Now()#, #EVALUATE('form.' & 'companyId' & '#studentId#')#)
             </cfquery>
         </cfif>
         
         <cfif #EVALUATE('form.' & '#studentId#' & 'typeSevisFee')# IS NOT ''>
             <cfquery name="insertSevis" datasource="MySQL">
                INSERT INTO smg_charges
                    (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                VALUES
                    (#EVALUATE('form.' & 'agentId' & '#studentId#')#, #studentId#, #variables.invoiceNumber#, #EVALUATE('form.' & 'programId' & '#studentId#')#, '#EVALUATE('form.' & 'programName' & '#studentId#')#', '#EVALUATE('form.' & '#studentId#' & 'typeSevisFee')#', #Now()#, #EVALUATE('form.' & '#studentId#' & 'sevisAmount')#, #EVALUATE('form.' & '#studentId#' & 'sevisAmount')#, #client.userid#, #Now()#, #EVALUATE('form.' & 'companyId' & '#studentId#')#)
             </cfquery>
         </cfif>
         
		<cfif ISDEFINED('typeSevisFee#studentId#')>
            <cfquery name="insertTraineeSevis" datasource="MySQL">
            INSERT INTO smg_charges
            (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
            VALUES
            (#EVALUATE('form.' & 'agentId' & '#studentId#')#, #studentId#, #variables.invoiceNumber#, #EVALUATE('form.' & 'programId' & '#studentId#')#, '#EVALUATE('form.' & 'programName' & '#studentId#')#', '#EVALUATE('form.' &  'sevisFee' & '#studentId#')#', #Now()#, #EVALUATE('form.' & 'sevisAmount' & '#studentId#')#, #EVALUATE('form.' & 'sevisAmount' & '#studentId#')#, #client.userid#, #Now()#, #EVALUATE('form.' & 'companyId' & '#studentId#')#)
            </cfquery>
        </cfif>
         
    </cfif>
</cfloop>

<script>
	opener.location.reload();
	window.close();
</script>

<!--- code disabled as long as the script above is active --->
<!--- <cfquery name="getLastCharge" datasource="MySQL">
SELECT MAX(chargeid) AS chargeid
FROM smg_charges
</cfquery>

<cfquery name="selectLocation" datasource="MySQL">
SELECT sp.type AS progType
FROM smg_charges s
INNER JOIN smg_programs sp ON sp.programid = s.programid
WHERE chargeid = #getLastCharge.chargeid#
</cfquery>

<cfswitch expression="#selectLocation.progType#">
    <cfcase value="7, 8, 9">
        <cflocation url="m_trainee_addCharge.cfm?userid=#url.userid#" addtoken="yes">
    </cfcase>
    <cfcase value="11">
        <cflocation url="m_w&t_addCharge.cfm?userid=#url.userid#" addtoken="yes">
    </cfcase>
    <cfcase value="22, 23">
        <cflocation url="m_h2b_addCharge.cfm?userid=#url.userid#" addtoken="yes">
    </cfcase>
</cfswitch> --->