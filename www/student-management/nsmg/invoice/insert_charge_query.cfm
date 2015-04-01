<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfparam name="FORM.type" default="">
<cfparam name="FORM.description" default="">
<cfparam name="FORM.amount" default="0.00">

<cfoutput>

	<cfif LEN(FORM.type) AND VAL(FORM.amount) AND VAL(FORM.agentID)>
        <cfquery name="insert_charge" datasource="#APPLICATION.DSN#">
            INSERT INTO smg_charges (
                type,
                description,
                amount,
                amount_due,
                agentID,
                date,
                userinput,
                companyID )
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.type#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.description#">,
                <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.amount#">,
                <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.amount#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.agentID#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> )
        </cfquery>
        <script type="text/javascript">
			function load(file,target) {
				if (target != '')
					target.window.location.href = '?curdoc=invoice/invoice_index?userid=#FORM.agentID#';
				else
					window.location.href = '?curdoc=invoice/invoice_index';
			}
		</script>
    <cfelse>
        <script type="text/javascript">
            alert("Please enter a type and amount for the charge");
        </script>
    </cfif>
    
    <script type="text/javascript">
		window.location.href = "add_charge.cfm?userid=#FORM.agentid#";
	</script>

</cfoutput>