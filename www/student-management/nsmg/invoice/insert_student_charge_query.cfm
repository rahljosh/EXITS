<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cffunction name="insertCharge" access="private" output="no" returntype="void">
	<cfargument name="agentID" required="yes">
    <cfargument name="stuID" required="yes">
    <cfargument name="programID" required="yes">
    <cfargument name="type" required="yes">
    <cfargument name="description" required="yes">
    <cfargument name="amount" required="yes">
    <cfargument name="amount_due" required="no" default="0">
    
    <cfif NOT VAL(ARGUMENTS.amount_due)>
    	<cfset ARGUMENTS.amount_due = ARGUMENTS.amount>
    </cfif>
    
    <cfquery datasource="#APPLICATION.DSN#">
        INSERT INTO smg_charges (
            agentID,
            stuid,
            programID,
            type,
            date,
            amount,
            userinput,
            description,
            companyID,
            amount_due )
        VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.agentID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.stuID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.type#">, 
            <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#ARGUMENTS.amount#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.description#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#ARGUMENTS.amount_due#"> )
    </cfquery>
</cffunction>

<cffunction name="getDepositInvoices" access="private" output="no" returntype="query">
	<cfargument name="agentID" required="yes">
    <cfargument name="stuID" required="yes">
    <cfargument name="programID" required="yes">
    
	<cfquery name="qGetDepositInvoices" datasource="#APPLICATION.DSN#">
        SELECT 
            sch.invoiceid, 
            sch.type, 
            amount_due
        FROM smg_charges sch
        WHERE sch.stuid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.stuID#">
        AND sch.programid = <cfqueryparam cfsqltype="cf_sql_integer" value='#ARGUMENTS.programID#'>
        AND sch.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.agentid#">
        AND sch.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="deposit">
        ORDER BY invoiceid DESC
    </cfquery>
    <cfreturn qGetDepositInvoices>
</cffunction>

<cftransaction action="begin" isolation="serializable">

	<cfloop list="#FORM.studentID#" index="x">
    
    	<cfparam name="FORM.#x#deposit_type" default="">
        <cfparam name="FORM.#x#deposit_description" default="">
        <cfparam name="FORM.#x#deposit_amount" default="0">
        
        <cfparam name="FORM.#x#final_type" default="">
        <cfparam name="FORM.#x#final_description" default="">
        <cfparam name="FORM.#x#final_amount" default="0">
        
        <cfparam name="FORM.#x#insurance_type" default="">
        <cfparam name="FORM.#x#insurance_description" default="">
        <cfparam name="FORM.#x#insurance_amount" default="0">
        
        <cfparam name="FORM.#x#guarantee_type" default="">
        <cfparam name="FORM.#x#guarantee_description" default="">
        <cfparam name="FORM.#x#guarantee_amount" default="0">
        
        <cfparam name="FORM.#x#sevis_type" default="">
        <cfparam name="FORM.#x#sevis_description" default="">
        <cfparam name="FORM.#x#sevis_amount" default="0">
        
        <cfparam name="FORM.#x#direct_placement" default="">
        <cfparam name="FORM.#x#direct_placement_description" default="">
        <cfparam name="FORM.#x#direct_placement_amount" default="0">
        
        <cfparam name="FORM.#x#direct_placement_guarantee_disc" default="">
        <cfparam name="FORM.#x#direct_placement_guarantee_disc_desc" default="">
        <cfparam name="FORM.#x#direct_placement_guarantee_disc_amount" default="0">
    
    	<cfscript>
		
			// Set program ID so it is easier to use
			programID = Evaluate('FORM.' & x & 'programid');
			
			// Deposits
			deposit_type = Evaluate('FORM.' & x & 'deposit_type');
			deposit_description = Evaluate('FORM.' & x & 'deposit_description');
			deposit_amount = Evaluate('FORM.' & x & 'deposit_amount');
			if (VAL(deposit_amount)) {
				insertCharge(
					agentID = FORM.agentID,
					stuID = x,
					programID = programID,
					type = deposit_type,
					description = deposit_description,
					amount = deposit_amount);
			}
			
			// Final Invoices
			final_type = Evaluate('FORM.' & x & 'final_type');
			final_description = Evaluate('FORM.' & x & 'final_description');
			final_amount = Evaluate("FORM." & x & "final_amount");
			if (VAL(final_amount)) {
				amount_deposit = final_amount;
				if (ListFind("13,14,15",CLIENT.companyID)) {
					qFindDepositInvoice = getDepositInvoices(
						agentID = FORM.agentID,
						stuID = x,
						programID = programID);
					if (qFindDepositInvoice.recordCount GT 0) {
						amount_deposit = amount_deposit - qFindDepositInvoice.amount_due;
					}
				} else {
					amount_deposit = amount_deposit - 500;
				}
				insertCharge(
					agentID = FORM.agentID,
					stuID = x,
					programID = programID,
					type = final_type,
					description = final_description,
					amount = final_amount,
					amount_due = amount_deposit);
			}
			
			// Insurance
			insurance_type = Evaluate('FORM.' & x & 'insurance_type');
			insurance_description = Evaluate('FORM.' & x & 'insurance_description');
			insurance_amount = Evaluate('FORM.' & x & 'insurance_amount');
			if (VAL(insurance_amount)) {
				insertCharge(
					agentID = FORM.agentID,
					stuID = x,
					programID = programID,
					type = insurance_type,
					description = insurance_description,
					amount = insurance_amount);
			}
			
			// Guarantee
			guarantee_type = Evaluate('FORM.' & x & 'guarantee_type');
			guarantee_description = Evaluate('FORM.' & x & 'guarantee_description');
			guarantee_amount = REReplace(Evaluate('FORM.' & x & 'guarantee_amount'),',','','all');
			if (VAL(guarantee_amount)) {
				insertCharge(
					agentID = FORM.agentID,
					stuID = x,
					programID = programID,
					type = guarantee_type,
					description = guarantee_description,
					amount = guarantee_amount);
			}
			
			// SEVIS
			sevis_type = Evaluate('FORM.' & x & 'sevis_type');
			sevis_description = Evaluate('FORM.' & x & 'sevis_description');
			sevis_amount = Evaluate('FORM.' & x & 'sevis_amount');
			if (VAL(sevis_amount)) {
				insertCharge(
					agentID = FORM.agentID,
					stuID = x,
					programID = programID,
					type = sevis_type,
					description = sevis_description,
					amount = sevis_amount);
			}
			
			// Direct Placement
			direct_placement = Evaluate('FORM.' & x & 'direct_placement');
			direct_placement_description = Evaluate('FORM.' & x & 'direct_placement_description');
			direct_placement_amount = Evaluate('FORM.' & x & 'direct_placement_amount');
			if (VAL(direct_placement_amount)) {
				insertCharge(
					agentID = FORM.agentID,
					stuID = x,
					programID = programID,
					type = direct_placement,
					description = direct_placement_description,
					amount = direct_placement_amount);
			}
			
			// Direct Placement Guarantee
			direct_placement_guarantee_disc = Evaluate('FORM.' & x & 'direct_placement_guarantee_disc');
			direct_placement_guarantee_disc_desc = Evaluate('FORM.' & x & 'direct_placement_guarantee_disc_desc');
			direct_placement_guarantee_disc_amount = Evaluate('FORM.' & x & 'direct_placement_guarantee_disc_amount');
			if (VAL(direct_placement_guarantee_disc_amount)) {
				insertCharge(
					agentID = FORM.agentID,
					stuID = x,
					programID = programID,
					type = direct_placement_guarantee_disc,
					description = direct_placement_guarantee_disc_desc,
					amount = direct_placement_guarantee_disc_amount);
			}
			
		</cfscript>
	
	</cfloop>
    
</cftransaction>

<cflocation url="add_charge.cfm?userid=#form.agentid#" addtoken="yes">