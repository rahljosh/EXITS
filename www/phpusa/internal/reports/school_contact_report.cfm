<!--- ------------------------------------------------------------------------- ----
	
	File:		school_contact_report.cfm
	Author:		James Griffiths
	Date:		September 14, 2012
	Desc:		List of schools with their contact and AR information.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Form Variables ---->
    <cfparam name="FORM.schoolID" default="0">
    
    <!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">
    
    <!--- get the information from the schools --->
    <cfquery name="qGetSchools" datasource="MySql">
        SELECT
        	s.schoolID,
            s.schoolName,
            s.contact
        FROM
            php_schools s
        <cfif VAL(FORM.schoolID)>
            WHERE
                s.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.schoolID)#">
        </cfif>
    </cfquery>
    
</cfsilent>

<style type="text/css">
	.application_section_header{
		border-bottom: 1px dashed Gray;
		text-transform: uppercase;
		letter-spacing: 5px;
		width:100%;
		text-align:center;
		font:Arial, Helvetica, sans-serif;
		font-size:18px;
		font-weight: bold;
		text-decoration:underline;
		background: #C2D1EF;
	}
</style>

<cfoutput>

    <table width="100%" cellpadding="4" cellspacing="0" align="center">
    	<tr>
        	<th><span class="application_section_header">#companyshort.companyshort# - School Contact Report</span></th>
        </tr>
    </table>
    
    <br>
    
    <table width="95%" cellpadding="0" cellspacing="0" align="center" frame="below">
    
    	<tr>
            <td width="25%"><b>School</b></td>
            <td width="25%"><b>Contact</b></td>
            <td width="25%"><b>Area Rep.</b></td>
            <td width="25%"><b>Area Rep. Email</b></td>
        </tr>
        
        <cfloop query="qGetSchools">
        	<cfquery name="qGetReps" datasource="MySql">
            	SELECT
                	c.userID,
                    u.firstName,
                    u.lastName,
                    u.email
             	FROM
                	php_school_contacts c
              	INNER JOIN
                	smg_users u ON u.userID = c.userID
              	WHERE
                	c.schoolID = #schoolID#
              	GROUP BY
                	c.userID
            </cfquery>
            <tr bgcolor="#iif(qGetSchools.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
                <td valign="top" class="style1">#schoolName# (###schoolID#)</td>
                <td valign="top" class="style1">#contact#</td>
                <td valign="top" class="style1" colspan="2">
                	<table width="100%">
                    	<cfloop query="qGetReps">
                        	<tr>
                            	<td valign="top" class="style1" width="50%"><cfif VAL(qGetReps.recordCount)>#qGetReps.firstName# #qGetReps.lastName# (###qGetReps.userID#)</cfif></td>
                				<td valign="top" class="style1" width="50%">#qGetReps.email#</td>
                            </tr>
                        </cfloop>
                    </table>
                </td>
            </tr>
		</cfloop>
        
 	</table>
    
</cfoutput>