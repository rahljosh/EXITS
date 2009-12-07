<cfapplication 
	name="csb_wat" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,10,40,1)#">

	<cfscript>
		/***** Create APPLICATION.EMAIL structure *****/
		APPLICATION.EMAIL = StructNew();		
		APPLICATION.EMAIL.from = 'anca@csb-usa.com';
		APPLICATION.EMAIL.contact = 'anca@csb-usa.com';
		APPLICATION.EMAIL.errors = 'errors@student-management.com';
	</cfscript>