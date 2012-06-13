<cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
            SELECT DISTINCT 
            	u.userid
              
            FROM 
            	user_access_rights uar
            INNER JOIN 
            	smg_users u ON u.userid = uar.userid
            LEFT OUTER JOIN 
            	smg_countrylist cl ON u.country = cl.countryid
            WHERE 
            	uar.regionid = 1068
			
			<!--- manager / DO NOT SHOW STUDENT VIEW --->
            AND 
            	uar.userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )
            AND 
            	u.active = 1
            AND
                
                u.userid NOT IN (
              
                      SELECT DISTINCT 
                        u.userid
                       
                    FROM 
                        user_access_rights uar
                    INNER JOIN 
                        smg_users u ON u.userid = uar.userid
              
                    WHERE 
                        uar.regionid = 1472
                    
                    <!--- manager / DO NOT SHOW STUDENT VIEW --->
                    AND 
                        uar.userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )
                    AND 
                        u.active = 1
                        )
           
</cfquery>
<cfloop query="qGetResults">


	<cfquery datasource="#application.dsn#">
    	insert into user_access_rights (userid, companyid, regionid, usertype, advisorid)
        						 values (#qGetResults.userid#, 3, 1472, 7, 7203)
    </cfquery>
</cfloop>
