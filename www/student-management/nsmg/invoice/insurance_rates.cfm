<!--- ------------------------------------------------------------------------- ----
	
	File:		insurance_rates.cfc
	Author:		James Griffiths
	Date:		September 19, 2014
	Desc:		Form for updating insurance costs

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfparam name="FORM.submitted" default="0">
    <cfparam name="URL.message" default="">

	<cfquery name="qGetInsuranceRates" datasource="#APPLICATION.DSN#">
    	SELECT *
        FROM smg_insurance_type
        WHERE active = 1
        AND insutypeid != 1
    </cfquery>
    
    <!--- Form has been submitted --->
    <cfif VAL(FORM.submitted)>
    
    	<cfloop query="qGetInsuranceRates">
        	<cfquery datasource="#APPLICATION.DSN#">
            	UPDATE smg_insurance_type
                SET 
                	ayp5 = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM['ayp5_'&insutypeid]#">,
                    ayp10 = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM['ayp10_'&insutypeid]#">,
                    ayp12 = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM['ayp12_'&insutypeid]#">
                WHERE insutypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(insutypeid)#">
            </cfquery>
        </cfloop>
        
        <cflocation url="#CGI.SCRIPT_NAME#?curdoc=invoice/insurance_rates&message=Prices%20Updated%20successfully!!">
    
    </cfif>

</cfsilent>

<cfoutput>

	<cfif LEN(URL.message)><div align="center" class="get_attention">#url.message#</div><br></cfif>

	<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
    	<input type="hidden" name="submitted" value="1"/>
    	
		<table div align="center" cellpadding="4" cellspacing="0" width="90%">
        	<tr bgcolor="##00003C">
            	<td><font color="white">Insurance Type</font></td>
                <td><font color="white">5 Month Price</font></td>
                <td><font color="white">10 Month Price</font></td>
                <td><font color="white">12 Month Price</font></td>
            </tr>
        	<cfloop query="qGetInsuranceRates">
            	<tr bgcolor="#iif(qGetInsuranceRates.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
                	<td>#type#</td>
                    <td><input type="text" name="ayp5_#insutypeid#" value="#DecimalFormat(ayp5)#"/></td>
                    <td><input type="text" name="ayp10_#insutypeid#" value="#DecimalFormat(ayp10)#"/></td>
                    <td><input type="text" name="ayp12_#insutypeid#" value="#DecimalFormat(ayp12)#"/></td>
                </tr>
            </cfloop>
            <tr>
            	<td colspan="4" align="center"><input type="submit" value="Save"/></td>
            </tr>
        </table>
        
    </form>

</cfoutput>