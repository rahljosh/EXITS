<style type="text/css">
<!--
.program {
	font-size: 13px;
	font-weight: bold;
	background-color: #eeeeee;
	line-height: 25px;
}
-->
</style>

 <cfquery name="getResults" datasource="#application.dsn#">
        SELECT smg_students.studentid, smg_students.firstname, smg_students.familylastname, smg_students.programid,
        	smg_students.canceldate, smg_students.cancelreason, smg_regions.regionname, c.countryname, smg_programs.programname
        FROM smg_students
        INNER JOIN smg_regions ON smg_students.regionassigned = smg_regions.regionid
        INNER JOIN smg_programs ON smg_students.programid = smg_programs.programid
        LEFT JOIN smg_countrylist c ON smg_students.countryresident = c.countryid
        
       where smg_students.canceldate != 'NULL' 
       <cfif programid is not ''>
		AND	smg_students.programid IN (#programid#)
       </cfif> 
        <cfif date_from NEQ ''>
            AND DATE(smg_students.canceldate) >= <cfqueryparam cfsqltype="cf_sql_date" value="#date_from#">
        </cfif>
        <cfif date_to NEQ ''>
            AND DATE(smg_students.canceldate) <= <cfqueryparam cfsqltype="cf_sql_date" value="#date_to#">
        </cfif>
   		<cfif (#listLast(company_region)# neq #client.companyid#)>
        AND  smg_students.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(company_region)#">
        </cfif>
	     <!---- include the programid because we're grouping by that in the output, just in case two have the same programname. --->
        ORDER BY smg_students.programid, smg_students.familylastname
    </cfquery>
<h1 align="center">Cancelled Students</h1>

 <table width=100% class="section">
			<cfset myCurrentRow = 0>
            <cfset current_programid = ''>
             <cfoutput>
           
            <cfloop query="getResults">
                <cfif programid NEQ current_programid>
                    <cfset myCurrentRow = 0>
                    <cfset current_programid = programid>
                    <tr>
                        <td colspan=6 height="25">&nbsp;</td>
                    </tr>
                    <tr align="center" class="program">
                        <td colspan="6">Program: #programname#</td>
                    </tr>
                    <tr align="left">
                        <th>Student</th>
                        <th>Date Cancelled</th>
                        
                        <th>Country</th>
                        <th>Region</th>
                        <th>Reason</th>
                    </tr>
                </cfif>
                <cfset myCurrentRow = myCurrentRow + 1>                
                <tr bgcolor="#iif(currentRow MOD 2 ,DE("F0F0F0") ,DE("white") )#">
                    <td>#firstname# #familylastname# (#studentid#)</td>
                    <td>#DateFormat(canceldate, 'mm/dd/yyyy')#</td>
                    
                    <td>#countryname#</td>
                    <td>#regionname#</td>
                    <td>#cancelreason#</td>
                </tr>
            </cfloop>
            
 </cfoutput>
        </table>
               
       
