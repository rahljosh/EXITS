<!--- ------------------------------------------------------------------------- ----
	
	File:		invoice.cfc
	Author:		Marcel
	Date:		June, 16 2010
	Desc:		This holds the functions needed for the invoice

----- ------------------------------------------------------------------------- --->

<cfcomponent
	displayname="invoice"
    output="false"
    hint="A collection of functions for the company">
    
    <!--- Return the initialized Invoice object --->
	<cffunction name="Init" access="public" returntype="invoice" output="false" hint="Returns the initialized Invoice object">

		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>
    
    
    <cffunction name="totalAgentBalance" access="public" output="no" returntype="query" hint="Returns the total balance due for each agent">
    	<cfargument name="programChoice" required="yes" hint="List of programs chosen by user">
        <cfargument name="balanceType" default="1" hint="Type 1: returns balances greater than zero. Type 0: returns balances less than zero.">
    
        <cfquery name="qGetAgentsReceivable" datasource="MySQL"> 
        SELECT
        	t.agentid, 
            t.businessname, 
            SUM( t.total ) AS totalPerAgent
        FROM 
        
        	<!--- Begin Subquery, 3 unions, Table nickname t --->
            <!--- Union 1: smg_charges --->
        	(SELECT
            	sch.agentid, 
                su.businessname, 
                IFNULL( SUM( sch.amount_due ) , 0 ) AS total
        	FROM 
            	smg_charges sch
        	LEFT JOIN 
            	smg_users su 
            ON 
            	su.userid = sch.agentid
			<cfif ARGUMENTS.programChoice IS NOT 'All'>
                WHERE 
                    sch.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programChoice#" list="yes"> )
            </cfif>
            GROUP BY 
            	agentid
                
            <!--- Union 2: smg_payment_charges --->               
            UNION ALL
            
            SELECT 
            	sch.agentid, 
                su.businessname, 
                IFNULL( SUM( spc.amountapplied ) * -1, 0 ) AS total
            FROM 
            	smg_payment_charges spc
            LEFT JOIN 
            	smg_charges sch 
            ON 
            	sch.chargeid = spc.chargeid
            LEFT JOIN 
            	smg_users su 
            ON 
            	su.userid = sch.agentid
            <cfif ARGUMENTS.programChoice IS NOT 'All'>
                WHERE 
                    sch.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programChoice#" list="yes"> )
            </cfif>
            GROUP BY sch.agentid
            
            <!--- Union 3: smg_credit --->            
            UNION ALL
            
            SELECT 
            	sc.agentid, 
                su.businessname, 
                IFNULL( SUM( sc.amount - sc.amount_applied ) * -1, 0 ) AS total
            FROM 
            	smg_credit sc
            LEFT JOIN 
            	smg_charges sch 
            ON 
            	sch.chargeid = sc.chargeid
            LEFT JOIN 
            	smg_users su 
            ON 
            	su.userid = sc.agentid
            WHERE 
            	sc.active =1
            <cfif ARGUMENTS.programChoice IS NOT 'All'>
                AND
                    (sch.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programChoice#" list="yes"> )
                        <cfif ListFind(ARGUMENTS.programChoice, 0) NEQ 0>
                            OR sch.programID IS NULL
                        </cfif>
                    )
            </cfif>
            GROUP BY 
            	sc.agentid
            ) t
        <!--- End of Subquery: Table t ---> 
        
       	WHERE
        	t.agentid > 0            
        GROUP BY 
        	t.agentid 
        HAVING 
        	<cfif ARGUMENTS.balanceType EQ 0>
        		totalPerAgent < 0	<!--- query returns refunds due --->
            <cfelse>
            	totalPerAgent > 0	<!--- query returns receivables --->
            </cfif>
        ORDER BY 
        	totalPerAgent DESC    
        </cfquery>
    
    	<cfreturn qGetAgentsReceivable>
        
    </cffunction>
    
    
    <cffunction name="programBalance" access="public" output="no" returntype="query" hint="Returns the total balance for each agent per program">
    	<cfargument name="agentId" required="yes" hint="Agent ID">
    	<cfargument name="programChoice" required="yes" hint="List of programs chosen by user">
        <cfargument name="companyId" required="yes" hint="Company ID">
        
        <cfquery name="qGetProgramBalance" datasource="MySQL"> 
        SELECT 
        	t.agentid, 
            t.businessname, 
            SUM(t.total) AS totalPerAgent
        FROM 
        
        	<!--- Begin Subquery, 3 unions, Table nickname t --->
            <!--- Union 1: smg_charges --->
        	(SELECT 
            	sch.agentid, 
                su.businessname, 
                sch.programid, 
                IFNULL(SUM(sch.amount_due),0) AS total, 
                (CASE 
                WHEN sch.companyid = 1 THEN 1
                WHEN sch.companyid = 2 THEN 1
                WHEN sch.companyid = 3 THEN 1
                WHEN sch.companyid = 4 THEN 1
                WHEN sch.companyid = 12 THEN 1
                WHEN sp.type = 7 THEN 7
                WHEN sp.type = 8 THEN 7
                WHEN sp.type = 9 THEN 7
                WHEN sp.type = 11 THEN 8
                ELSE sch.companyid
                END) AS testCompId
            FROM 
            	smg_charges sch
            LEFT JOIN 
            	smg_programs sp 
            ON 
            	sp.programid = sch.programid
            LEFT JOIN 
            	smg_users su 
            ON 
            	su.userid = sch.agentid
            WHERE 
            	sch.agentid = #VAL(ARGUMENTS.agentId)#
            <cfif ARGUMENTS.programChoice IS NOT 'All'>
                AND
                    sch.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programChoice#" list="yes"> )
            </cfif>
            GROUP BY 
            	testCompId 
            HAVING 
            	testCompId = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyId#" list="no">
                
			<!--- Union 2: smg_payment_charges --->                 
            UNION ALL
            
            SELECT 
            	sch.agentid, 
                su.businessname, 
                sch.programid, 
                IFNULL(SUM(spc.amountapplied)*-1,0) AS total,  
                (CASE 
                WHEN sch.companyid = 1 THEN 1
                WHEN sch.companyid = 2 THEN 1
                WHEN sch.companyid = 3 THEN 1
                WHEN sch.companyid = 4 THEN 1
                WHEN sch.companyid = 12 THEN 1
                WHEN sp.type = 7 THEN 7
                WHEN sp.type = 8 THEN 7
                WHEN sp.type = 9 THEN 7
                WHEN sp.type = 11 THEN 8
                ELSE sch.companyid
                END) AS testCompId
            FROM 
            	smg_payment_charges spc
            LEFT JOIN 
            	smg_charges sch 
            ON 
            	sch.chargeid = spc.chargeid
            LEFT JOIN 
            	smg_programs sp 
            ON 
            	sp.programid = sch.programid
            LEFT JOIN 
            	smg_users su 
            ON 
            	su.userid = sch.agentid
            WHERE  
            	sch.agentid = #VAL(ARGUMENTS.agentId)#
            <cfif ARGUMENTS.programChoice IS NOT 'All'>
                AND
                    sch.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programChoice#" list="yes"> )
            </cfif>
            GROUP BY 
            	testCompId 
            HAVING 
            	testCompId = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyId#" list="no">
                
            <!--- Union 3: smg_credit --->                  
            UNION ALL
            
            SELECT 
            	sc.agentid, 
                su.businessname, 
                sch.programid, 
                IFNULL(SUM(sc.amount - sc.amount_applied)* -1,0) AS total, 
                (CASE 
                WHEN sch.companyid = 1 THEN 1
                WHEN sch.companyid = 2 THEN 1
                WHEN sch.companyid = 3 THEN 1
                WHEN sch.companyid = 4 THEN 1
                WHEN sch.companyid = 12 THEN 1
                WHEN sp.type = 7 THEN 7
                WHEN sp.type = 8 THEN 7
                WHEN sp.type = 9 THEN 7
                WHEN sp.type = 11 THEN 8
                ELSE sch.companyid
                END) AS testCompId
            FROM 
            	smg_credit sc
            LEFT JOIN 
            	smg_charges sch 
            ON 
            	sch.chargeid = sc.chargeid
            LEFT JOIN 
            	smg_programs sp
            ON 
            	sp.programid = sch.programid
            LEFT JOIN 
            	smg_users su 
            ON 
            	su.userid = sc.agentid
            WHERE 
            	sc.active =1
            AND 
            	sc.agentid = #VAL(ARGUMENTS.agentId)#
            <cfif ARGUMENTS.programChoice IS NOT 'All'>
                AND
                    (sch.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programChoice#" list="yes"> )
                        <cfif ListFind(ARGUMENTS.programChoice, 0) NEQ 0>
                            OR sch.programID IS NULL
                        </cfif>
                    )
            </cfif>
            GROUP BY 
            	testCompId 
            HAVING 
            	testCompId = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyId#" list="no">
            ) t
			<!--- End of Subquery: Table t --->
            
        WHERE
            t.agentid > 0 
            
        GROUP BY 
        	t.agentid  
        </cfquery>
        
        <cfreturn qGetProgramBalance>
                
	</cffunction>
    
</cfcomponent>