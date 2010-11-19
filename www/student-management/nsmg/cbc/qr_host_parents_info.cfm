<cfoutput>
	
	<cfset fatherEncryptSSN = ''>
	<cfif IsDefined('form.fatherssn') AND form.fatherssn NEQ ''>
		<cfset fatherEncryptSSN = encrypt("#form.fatherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
	<cfelse>
		<cfset fatherEncryptSSN = ''>
	</cfif>
	
	<cfset motherEncryptSSN = ''>
	<cfif IsDefined('form.motherssn') AND form.motherssn NEQ ''>
		<cfset motherEncryptSSN = encrypt("#form.motherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
	<cfelse>
		<cfset motherEncryptSSN = ''>
	</cfif>
	
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
	<cfquery name="update_host_family" datasource="mysql">
		UPDATE smg_hosts
		SET fatherfirstname = '#form.fatherfirstname#',
			fathermiddlename = '#form.fathermiddlename#',
			fatherlastname = '#form.fatherlastname#',
			<cfif IsDefined('form.fatherssn')>fatherssn = '#fatherEncryptSSN#',</cfif>
			fatherdob = <cfif form.fatherdob EQ ''>null<cfelse>#CreateODBCDate(form.fatherdob)#</cfif>,
			motherfirstname = '#form.motherfirstname#',
			mothermiddlename = '#form.mothermiddlename#',
			motherlastname = '#form.motherlastname#',
			<cfif IsDefined('form.motherssn')>motherssn = '#motherEncryptSSN#',</cfif>
			motherdob = <cfif form.motherdob EQ ''>null<cfelse>#CreateODBCDate(form.motherdob)#</cfif>
		WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.hostid#">
		LIMIT 1							
	</cfquery>
	</cftransaction>

	<script language="JavaScript">
    <!--
      window.opener.location.href = window.opener.location.href;
      if (window.opener.progressWindow) {
        window.opener.progressWindow.close()
      }
      window.close();
    //-->
    </script>

</cfoutput>
