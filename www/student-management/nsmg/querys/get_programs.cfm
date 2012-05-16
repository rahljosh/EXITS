
<cfscript>
    	if ( CLIENT.companyid eq 13 OR client.companyid eq 14){
			get_program = APPCFC.PROGRAM.getPrograms(companyid=client.companyid,isActive=1);
		}
		else
			{
			get_program = APPCFC.PROGRAM.getPrograms(isActive=1);
		}
</cfscript>