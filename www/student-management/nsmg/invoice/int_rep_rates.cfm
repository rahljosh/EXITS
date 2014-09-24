<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param Variables --->
    <cfparam name="FORM.count" default="0">
    <cfparam name="URL.message" default="">
    
    <cfif VAL(FORM.count)>
    	
        <cfloop from="1" to="#FORM.count#" index="i">
    
            <cfquery datasource="#APPLICATION.DSN#">
                 UPDATE 
                    smg_users 
                 SET
                    12_month_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM[i & '_12_month_price']#">,
                    10_month_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM[i & '_10_month_price']#">,
                    5_month_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM[i & '_5_month_price']#">,
                    insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM[i & '_insu_typeid']#">,
                    accepts_sevis_fee = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM[i & '_accepts_sevis_fee']#">	
                WHERE 
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM[i & '_userID']#">
                LIMIT 1
            </cfquery>
    		
        </cfloop>
        
        <cfset URL.message = 'Prices Updated Successfully!!'>
    
    </cfif>
    
    <cfquery name="qIntRepRates" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT
        	u.userID, 
            u.businessname, 
            IFNULL(u.12_month_price, 0.00) AS 12_month_price, 
            IFNULL(u.10_month_price, 0.00) AS 10_month_price, 
            IFNULL(u.5_month_price, 0.00) AS 5_month_price,
            IFNULL(i.ayp5, 0.00) AS 5_month_ins,
            IFNULL(i.ayp10, 0.00) AS 10_month_ins,
            IFNULL(i.ayp12, 0.00) AS 12_month_ins,
            u.accepts_sevis_fee, 
            u.insurance_typeid 
        FROM smg_users u
		INNER JOIN user_access_rights uar ON uar.userID = u.userID
        LEFT OUTER JOIN smg_insurance_type i ON i.insutypeid = u.insurance_typeid            
        WHERE u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		AND uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        ORDER BY u.businessname	
    </cfquery>

    <cfquery name="qGetInsuranceType" datasource="#APPLICATION.DSN#">
        SELECT *
        FROM smg_insurance_type
        WHERE active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>

</cfsilent>

<script type="text/javascript">

	function updatePrices(type,row) {
		$('#'+row+'_12_month_ins').val($('#'+type+'_12').val())
		$('#'+row+'_view_12_month_ins').val($('#'+type+'_12').val())
		
		$('#'+row+'_10_month_ins').val($('#'+type+'_10').val())
		$('#'+row+'_view_10_month_ins').val($('#'+type+'_10').val())
		
		$('#'+row+'_5_month_ins').val($('#'+type+'_5').val())
		$('#'+row+'_view_5_month_ins').val($('#'+type+'_5').val())
	}

</script>

<cfoutput>

	<cfif LEN(URL.message)><div align="center" class="get_attention">#url.message#</div><br></cfif>
    
    <div align="center">To use Default insurance rates, leave rate for Insurance at 0.00</div>
    
    <cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <input type="hidden" name="count" value="#qIntRepRates.recordcount#">
        
        <cfloop query="qGetInsuranceType">
        	<input type="hidden" id="#insutypeid#_5" value="#ayp5#" />
            <input type="hidden" id="#insutypeid#_10" value="#ayp10#" />
            <input type="hidden" id="#insutypeid#_12" value="#ayp12#" />
        </cfloop>
    
        <table div align="center" cellpadding="4" cellspacing=0 width="90%">
            <tr bgcolor="##00003C">
                <td colspan="2"></td>
                <td colspan=2 align="center"><font color="white">12 Months</font></td>
                <td colspan=2 align="center"><font color="white">10 Months</font></td>
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
                        <select name="#currentrow#_insu_typeid" onchange="updatePrices(this.value,#currentrow#)">
                            <option value="0"></option>
                            <cfloop query="qGetInsuranceType">
                                <option value="#qGetInsuranceType.insutypeid#" <cfif qIntRepRates.insurance_typeid EQ qGetInsuranceType.insutypeid>selected</cfif> >#qGetInsuranceType.type#</option>
                            </cfloop>
                        </select>	
                    </Td>
                    <td><input type="text" name="#currentrow#_12_month_price" value="#qIntRepRates.12_month_price#" size="5" class="price"></td>
                    <td>
                    	<input type="hidden" id="#currentrow#_12_month_ins" name="#currentrow#_12_month_ins" value="#qIntRepRates.12_month_ins#">
                        <input type="text" id="#currentrow#_view_12_month_ins" value="#qIntRepRates.12_month_ins#" disabled="disabled" size="5" />
                  	</td>
                    <td><input type="text" name="#currentrow#_10_month_price" value="#qIntRepRates.10_month_price#" size="5" class="price"></td>
                    <td>
                    	<input type="hidden" id="#currentrow#_10_month_ins" name="#currentrow#_10_month_ins" value="#qIntRepRates.10_month_ins#">
                        <input type="text" id="#currentrow#_view_10_month_ins" value="#qIntRepRates.10_month_ins#" disabled="disabled" size="5" />
                  	</td>
                    <td><input type="text" name="#currentrow#_5_month_price" value="#qIntRepRates.5_month_price#" size="5" class="price"></td>
                    <td>
                    	<input type="hidden" id="#currentrow#_5_month_ins" name="#currentrow#_5_month_ins" value="#qIntRepRates.5_month_ins#">
                        <input type="text" id="#currentrow#_view_5_month_ins" value="#qIntRepRates.5_month_ins#" disabled="disabled" size="5" />
                  	</td>
                    <td align="center">
                        <select name="#currentrow#_accepts_sevis_fee">
                            <option value=""></option>
                            <option value="0" <cfif qIntRepRates.accepts_sevis_fee EQ 0>selected</cfif> >No</option>
                            <option value="1" <cfif qIntRepRates.accepts_sevis_fee EQ 1>selected</cfif> >Yes</option>
                        </select>	
                    </td>
                </tr>
            </cfloop>
            <tr>
            	<td colspan="9" align="center">
                	<input type="button" value="Clear Prices" onclick="$('.price').val('0.00');" />
                    <input type="submit" value="Save" />
               	</td>
         	</tr>
        </table>
        
    </cfform>

</cfoutput>