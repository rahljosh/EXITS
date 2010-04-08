    <cfif isDefined('form.password')>
    	<cfquery name="check_password" datasource="caseusa">
        select userid
        from smg_users
        where username = 'incomingstudents@case-usa.org'
        and password = '#form.password#'
        </cfquery>
        <cfif check_password.userid eq 12894>
        <cfset cookie.viewstudents=1>
       	<cflocation url="../viewStudents.cfm">
   		<cfelse>
   		<cflocation url="viewStudentslogin.cfm">
        </cfif>
     <cfelse>
     	<cflocation url="viewStudentsLogin.cfm?m=1">
    </cfif>