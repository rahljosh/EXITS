<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param Variables --->
    <cfparam name="FORM.count" default="0">
    <cfparam name="URL.message" default="">
    
    <cfif VAL(FORM.count)>
    	
        <cfloop from="1" to="#FORM.count#" index="i">
    
            <cfquery datasource="mySQL" result="test">
                 UPDATE 
                    smg_users 
                 SET
                    12_month_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM[i & '_12_month_price']#">,
                    12_month_ins = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM[i & '_12_month_ins']#">,
                    10_month_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM[i & '_10_month_price']#">,
                    10_month_ins = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM[i & '_10_month_ins']#">,
                    5_month_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM[i & '_5_month_price']#">,
                    5_month_ins = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM[i & '_5_month_ins']#">,
                    insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM[i & '_insu_typeid']#">,
                    accepts_sevis_fee = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM[i & '_accepts_sevis_fee']#">	
                WHERE 
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM[i & '_userID']#">
                LIMIT 1
            </cfquery>
    		
        </cfloop>
        
        <cfset URL.message = 'Prices Updated Successfully!!'>
    
    </cfif>
    
    <cfquery name="qIntRepRates" datasource="mysql">
        SELECT DISTINCT
        	u.userID, 
            u.businessname, 
            IFNULL(u.12_month_price, 0.00) AS 12_month_price, 
            IFNULL(u.10_month_price, 0.00) AS 10_month_price, 
            IFNULL(u.5_month_price, 0.00) AS 5_month_price, 
            IFNULL(u.12_month_ins, 0.00) AS 12_month_ins, 
            IFNULL(u.10_month_ins, 0.00) AS 10_month_ins, 
            IFNULL(u.5_month_ins, 0.00) AS 5_month_ins, 
            u.accepts_sevis_fee, 
            u.insurance_typeid 
        FROM
        	smg_users u
		INNER JOIN
        	user_access_rights uar ON uar.userID = u.userID            
        WHERE 
        	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		AND            
            uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        ORDER BY 
        	u.businessname	
    </cfquery>

    <cfquery name="qGetInsuranceType" datasource="MySql">
        SELECT 
        	insutypeid, type
        FROM 
        	smg_insurance_type
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>

</cfsilent>

<cfoutput>

<cfif LEN(URL.message)><div align="center" class="get_attention">#url.message#</div><br></cfif>

<div align="center">To use Default insurance rates, leave rate for Insurance at 0.00</div>

<cfFORM action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
    <input type="hidden" name="count" value="#qIntRepRates.recordcount#">

    <table div align="center" cellpadding="4" cellspacing=0 width="90%">
        <tr bgcolor="##00003C">
            <td colspan="2"></td>
            <td colspan=2 align="center"><font color="white">12 Months</font></Td>
            <td colspan=2 align="center"><font color="white">10 Months</font></Td>
            <td colspan=2 align="center"><font color="white">5 months</font></td>
            <td></td>
        </tr>
        <tr bgcolor="##00003C">
            <td valign="bottom"><font color="white"><b>Business</b></font></td>
            <td><font color="white"><b>Policy Type</b></font></td>
            <td align="center"><font color="white"><b>Price</b></font></td>
            <td align="center"><font color="white"><b>Insurance</b></font></td>
            <td align="center"><font color="white"><b>Price</b></font></td>
            <td align="center"><font color="white"><b>Insurance</b></font></td>
            <td align="center"><font color="white"><b>Price</b></font></td>
            <td align="center"><font color="white"><b>Insurance</b></font></td>
            <td align="center"><font color="white"><b>Accepts SEVIS Fee</b></font></td>
        </tr>
        <cfloop query="qIntRepRates">
        	<input type="hidden" name="#currentrow#_userid" value="#userid#">
            <tr bgcolor="#iif(qIntRepRates.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
                <td>#businessname# (###userid#)</td>
                <Td align="right">
                    <select name="#currentrow#_insu_typeid">
                        <option value="0"></option>
                        <cfloop query="qGetInsuranceType">
                        	<option value="#qGetInsuranceType.insutypeid#" <cfif qIntRepRates.insurance_typeid EQ qGetInsuranceType.insutypeid>selected</cfif> >#qGetInsuranceType.type#</option>
                        </cfloop>
                    </select>	
                </Td>
                <td><input type="text" name="#currentrow#_12_month_price" value="#qIntRepRates.12_month_price#" size="5"></td>
                <td><input type="text" name="#currentrow#_12_month_ins" value="#qIntRepRates.12_month_ins#" size="5"></td>
                <td><input type="text" name="#currentrow#_10_month_price" value="#qIntRepRates.10_month_price#" size="5"></td>
                <td><input type="text" name="#currentrow#_10_month_ins" value="#qIntRepRates.10_month_ins#" size="5"></td>
                <td><input type="text" name="#currentrow#_5_month_price" value="#qIntRepRates.5_month_price#" size="5"></td>
                <td><input type="text" name="#currentrow#_5_month_ins" value="#qIntRepRates.5_month_ins#" size="5"></td>
                <td align="center">
                    <select name="#currentrow#_accepts_sevis_fee">
                        <option value=""></option>
                        <option value="0" <cfif qIntRepRates.accepts_sevis_fee EQ 0>selected</cfif> >No</option>
                        <option value="1" <cfif qIntRepRates.accepts_sevis_fee EQ 1>selected</cfif> >Yes</option>
                    </select>	
                </td>
            </tr>
        </cfloop>
        <tr><td colspan="6" align="center"><div class="button"><cfinput name="Submit" type="image" src="pics/next.gif" border=0></div></td></tr>
    </Table>
    
</cfFORM>

</cfoutput>