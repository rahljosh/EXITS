<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requestTimeOut="9999">

    <!--- Get Program --->
    <cfquery name="qGetProgram" datasource="MYSQL">
        SELECT DISTINCT 
            p.programid, 
            p.programname, 
            c.companyshort
        FROM 	
        	smg_programs p
        INNER JOIN 
        	smg_companies c ON c.companyid = p.companyid
        WHERE 		
            programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
    </cfquery>
       
     <!--- Get Regions --->
    <cfquery name="qGetRegion" datasource="MYSQL">
        SELECT DISTINCT 
           r.regionname
        FROM 	
        	smg_regions r
       
        WHERE 		
            regionid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#" list="yes"> )
    </cfquery>
    


<cfquery name="qMissingSecond" datasource="#application.dsn#">
SELECT s.studentid, s.firstname, r.regionname, s.familylastname, h.familylastname as hostfamily, u.firstname as arearep_first, u.lastname as arearep_last, u.userid as repid,
u2.lastname as placelast, u2.firstname as placefirst, u2.userid as placeid
FROM smg_students s
LEFT JOIN smg_users as u on s.arearepid = u.userid
LEFT JOIN smg_users as u2 on s.placerepid = u2.userid
LEFT JOIN smg_hosts h on h.hostid = s.hostid
LEFT JOIN smg_regions r on r.regionid = s.regionassigned
WHERE s.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
  <cfif CLIENT.companyID EQ 5>
                AND
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )        
            <cfelse>
                AND
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
            </cfif>        
            
            <!--- active --->
            <cfif FORM.active EQ 1> 
                AND 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.active#">
            <!--- inactive --->
			<cfelseif FORM.active EQ 0> 
                AND 
                    canceldate IS NULL
			<!--- canceled --->                    
            <cfelseif FORM.active EQ 2> 
                AND canceldate IS NOT NULL
            </cfif>  
            
			<cfif VAL(FORM.regionid)>
                AND
                    s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">
            </cfif>
            
			<cfif FORM.status is 1>
                AND 
                    s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                AND 
                    s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4"> <!--- placed --->
            <cfelseif FORM.status EQ 2>
                AND 
                    s.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> <!--- unplaced --->
            </cfif>
            

            
        ORDER BY 
        	s.regionassigned,
            arearep_last,
            s.firstname, 
            s.familylastname
    </cfquery>  

</cfsilent>

<Cfoutput>
<table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;">
    <tr>
    	<td align="center">
            <p style="font-weight:bold;">#CLIENT.companyshort# -  Students Missing Second Visit Rep</p>
            Region(s) Included in this Report: <br />
            <Cfif form.regionid is 0>
            <strong>All Regions</strong><Br>
            
            <cfelse>
                <cfloop query="qGetProgram">
                    <strong>#qGetRegion.regionname# &nbsp; </strong><br />
                </cfloop>
           </Cfif>
            <br>
            Program(s) Included in this Report: <br />
            <cfloop query="qGetProgram">
            	<strong>#qGetProgram.programname# &nbsp; (#qGetProgram.ProgramID#)</strong><br />
            </cfloop>
            
            <p>
            	Total of #qMissingSecond.recordcount# 
				<cfif FORM.active EQ 1>
                	active
				<cfelseif FORM.active EQ 0>
                	inactive
				<cfelseif FORM.active EQ 2>
                	canceled
				</cfif> students
                
				<cfif FORM.status is 1>
                	<strong>placed</strong>
				<cfelseif FORM.status is 2>
                	<strong>unplaced</strong>
				</cfif> in report: &nbsp; 
			</p> 
    	</td>
	</tr>
</table><br />
</Cfoutput>
    <table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;">
        <tr>
       		<th width="25%"></th>
            <th width="50%">Supervising / Placing Representative </th>
            <th width="25%">Total</th>
        </tr>
    </table><br />

	<cfoutput query="qMissingSecond" group="arearep_last">
   
        <cfquery name="qGetTotal" dbtype="query">
            SELECT 
                studentid
            FROM 
                qMissingSecond
            WHERE 	
      	<cfif val(#qMissingSecond.repid#)>
                repid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qMissingSecond.repid#">
        <Cfelse>
        		repid < 1
        </cfif>
         </cfquery>

         
    <table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;">	
			<tr>
            	<td width="25%" align="center">#qMissingSecond.regionname#</td>
                <Cfif val(qMissingSecond.repid)>
            		<th width="50%">#arearep_first# #arearep_last# (#repid#) / #placefirst# #placelast# (#placeid#)</th>
                <Cfelse>
                	<th width="50%">No Area Rep Assigned</th>
               	</Cfif>
				<td width="25%" align="center">#qGetTotal.recordcount#</td>
            </tr>
		</table>
            
		<table width="98%" frame="below" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;">
            <tr>
                <td width="6%" align="center"><strong>ID</strong></th>
                <td width="18%"><strong>Student</strong></td>
              <cfif FORM.status EQ 1>
	                <td width="12%"><strong>Family</strong></td>
                </cfif>
	            
            </tr>
           <Cfoutput>
            <tr bgcolor="###iif(qMissingSecond.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
                    <td align="center">#studentid#</td>
                    <td>#firstname# #familylastname#</td>
                   <cfif FORM.status is 1>
                    <td>#hostfamily#</td>	
                     </cfif>	
                    
                                     
				</tr>	
            </Cfoutput>
            </table>
        </cfoutput>


</body>
</html>