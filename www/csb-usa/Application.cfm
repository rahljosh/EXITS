<cfapplication 
	name="csb-usa" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,1,0,0)#">

	<cfparam name="APPLICATION.WAT.isLoggedIn" default="0">

	<cfscript>
		/***** Create APPLICATION.EMAIL structure *****/
		APPLICATION.EMAIL = StructNew();		

		// Create CSB Email Structure
		APPLICATION.EMAIL.CSB = StructNew();
		APPLICATION.EMAIL.CSB.from = 'info@csb-usa.com';
		APPLICATION.EMAIL.CSB.contact = 'anca@csb-usa.com';
		APPLICATION.EMAIL.CSB.errors = 'errors@student-management.com';
		APPLICATION.EMAIL.CSB.info = 'info@csb-usa.com';

		// Create Trainee Email Structure
		APPLICATION.EMAIL.TRAINEE = StructNew();
		APPLICATION.EMAIL.TRAINEE.from = 'info@csb-usa.com';
		APPLICATION.EMAIL.TRAINEE.contact = 'sergei@iseusa.com';
		APPLICATION.EMAIL.TRAINEE.errors = 'errors@student-management.com';
		APPLICATION.EMAIL.TRAINEE.info = 'info@csb-usa.com';
		
		APPLICATION.WAT.username = 'participant';
		APPLICATION.WAT.password = 'csbpart';
	</cfscript>
