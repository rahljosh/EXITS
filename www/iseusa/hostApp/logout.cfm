<!--- ------------------------------------------------------------------------- ----
	
	File:		logout.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Host Family App - Index

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <cfloop list="#GetClientVariablesList()#" index="ThisVarName">
        <cfset temp = DeleteClientVariable(ThisVarName)>
    </cfloop>
    
    <cflocation url="http://#cgi.http_host#/" addtoken="no">
    
</cfsilent>