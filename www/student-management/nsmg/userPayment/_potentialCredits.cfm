<!--- ------------------------------------------------------------------------- ----
	
	File:		_potentialCredits.cfm
	Author:		James Griffiths
	Date:		March 28, 2014
	Desc:		Shows a list of potential credits
				
----- ------------------------------------------------------------------------- --->

<cfquery name="qGetPotentialCredits" datasource="#APPLICATION.DSN#">
	SELECT 
    	p.*,
        t.type,
        CASE 
            WHEN s.middleName != "" THEN CONCAT(s.firstName, " ", s.middleName, " ", s.familyLastName, " (##", CAST(p.studentID AS CHAR(10)), ")")
            WHEN p.studentID != 0 THEN CONCAT(s.firstName, " ", s.familyLastName, " (##", CAST(p.studentID AS CHAR(10)), ")")
            END AS studentName,
     	CASE
            WHEN u.middleName != "" THEN CONCAT(u.firstName, " ", u.middleName, " ", u.lastName, " (##", CAST(p.agentID AS CHAR(10)), ")")
            ELSE CONCAT(u.firstName, " ", u.lastName, " (##", CAST(p.agentID AS CHAR(10)), ")")
            END AS agentName,
     	CASE
        	WHEN h.fatherFirstName != "" AND h.motherFirstName != "" THEN CONCAT(h.fatherFirstName, " and ", h.motherFirstName, " ", h.familyLastName, " (##", CAST(p.hostID AS CHAR(10)), ")")
        	WHEN p.hostID != 0 THEN CONCAT(h.fatherFirstName, h.motherFirstName, " ", h.familyLastName, " (##", CAST(p.hostID AS CHAR(10)), ")")
        	END AS hostName
    FROM smg_users_payments p
    LEFT JOIN smg_users_payments_type t ON t.ID = p.paymentType
    LEFT JOIN smg_students s ON s.studentID = p.studentID
    LEFT JOIN smg_users u ON u.userID = p.agentID
    LEFT JOIN smg_hosts h ON h.hostID = p.hostID
    WHERE p.studentID IN (
        SELECT studentID 
        FROM smg_users_payments 
        WHERE ID != p.ID
        AND transtype = p.transtype
        AND paymenttype = p.paymenttype
        AND creditStatus = 0
        AND isDeleted = 0
        AND agentID != 0
        AND date >= "2014-04-04"
        AND (paymentType != 36 OR hostID = p.hostID)
        <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif> )      
    AND p.creditStatus = 0
    AND p.isDeleted = 0
    AND p.agentID != 0
    AND p.date >= "2014-04-04"
    <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
        AND p.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
    <cfelse>
        AND p.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
    </cfif>
    ORDER BY
    	p.studentID,
        p.transtype,
        p.paymenttype
</cfquery>

<cfoutput>
	<table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
        <tr>
            <td colspan="6" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Potential Credits</td>
            <td style="background-color:##010066; color:##FFFFFF; font-weight:bold; text-align:right; padding-right:10px;">
                Total of #qGetPotentialCredits.recordCount# record(s)
            </td>
        </tr>
        <tr style="background-color:##E2EFC7; font-weight:bold;">
            <td>Student</td>
            <td>Agent</td>
            <td>Host</td>
            <td>Payment Type</td>
            <td>Payment Amount</td>
            <td>Payment Date</td>
            <td>Comments</td>
        </tr>
    
        <cfloop query="qGetPotentialCredits">
            <tr bgcolor="###iif(qGetPotentialCredits.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                <td>#studentName#</td>
                <td>#agentName#</td>
                <td>#hostName#</td>
                <td>#type#</td>
                <td>#LSCurrencyFormat(amount, 'local')#</td>
                <td>
                	<cfif VAL(isPaid)>
                    	#DateFormat(date,'mm/dd/yyyy')#
                    <cfelse>
                    	Pending
                    </cfif>
                </td>
                <td>#comment#</td>
            </tr>
        </cfloop>
    
    </table>
</cfoutput>