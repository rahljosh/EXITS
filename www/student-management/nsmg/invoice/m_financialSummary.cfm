
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Financial Summary</title>

<style type="text/css">

	table.frame 
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFE1;
	padding:2px;
	}
	
	td.right
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
	color:#FFFFFF;
	font-weight:bold;
	border-right-style:solid;
	border-right-width:thin;
	border-right-color:#004080;
	border-right-collapse:collapse;
	padding:4px;
	}
	
	td.two
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
	border-right-style:solid;
	border-right-width:thin;
	border-right-color:#004080;
	border-right-collapse:collapse;
	padding:10px;
	}
	
	.box
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFFF;
	}
	
	tr.darkBlue
	{
	background-color:#0052A4;
	}

.style1 {color: #FF0000}
</style>

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfsetting requesttimeout="9999">

<cfparam name="sumCharges" default="0">
<cfparam name="sumCancellations" default="0">
<cfparam name="counter" default="0">

<!--- ALL INTERNATIONAL REPS --->
<cfinclude template="../querys/get_all_intl_rep.cfm">

<cfquery name="getPrograms" datasource="MySQL">
SELECT 
	*
FROM 
	smg_programs
WHERE
	<cfif CLIENT.companyid EQ 14>
    	companyID = 14
    <cfelse>
		companyID IN (1,7,8,9,10,12,13,14)
    </cfif>
AND
	type NOT IN (6,10,14,15,16,17,18,19,20,21)
ORDER BY 
	companyid, 
	startdate DESC
</cfquery>

<cfquery name="getChargeTypes" datasource="MySQL">
select distinct(type) AS chargeType
from smg_charges
where chargeid >= 50512 <!--- chargeids < 50512 cannot be directly linked to cancellations --->
order by chargeType
</cfquery>

<cfif NOT ISDEFINED('form.submitted')>
<div align="center" style="padding-top:10px;">
    <cfform>
        
        <cfinput type="hidden" name="submitted">
    	
        <strong><small>Choose International Agent</small></strong>
        
        </br>
        </br>

        <select name="intrep" size="20" multiple="multiple">
        	<option value="All" selected="selected">Select All</option>
            <cfoutput query="get_all_intl_rep">
                <option value="#userid#">#businessname#</option>
            </cfoutput>
        </select>
		
        </br>
        </br>
        
        <strong><small>Choose Programs</small></strong>

        </br>
        </br>

        <select name="selectPrograms" multiple="multiple" size="15">
            <option value="All" selected="selected">Select All</option>
            <option value="0">Charges not related to a program</option>
            <cfoutput query="getPrograms">
                <cfswitch expression="#companyid#">
                    <cfcase value="1"><cfset compId = 'ISE'></cfcase>
                    <cfcase value="7"><cfset compId = 'TRAINEE'></cfcase>
                    <cfcase value="8"><cfset compId = 'W&T'></cfcase>
                    <cfcase value="9"><cfset compId = 'H2B'></cfcase>
                    <cfcase value="10"><cfset compId = 'CASE'></cfcase>
                    <cfcase value="13"><cfset compId = 'SMG Canada'></cfcase>
                    <cfcase value="14"><cfset compId = 'ESI'></cfcase>
                </cfswitch>
                <option value="#programid#">#variables.compId# - #getPrograms.programname#</option>
            </cfoutput>
        </select>
        
		</br>
        
        </br>
        </br>
        
        <strong><small>Choose Charge Types</small></strong>
        
        </br>
        </br>

        <select name="selectCharges" multiple="multiple" size="15">
            <option value="All" selected="selected">Select All</option>
            <option value="Old">Old Charges (Before Mid April 2008)</option>
            <cfoutput query="getChargeTypes">
                <option value="#getChargeTypes.chargeType#">#getChargeTypes.chargeType#</option>
            </cfoutput>
        </select>
        
		</br>
        </br>
        
        <input type="image" src="../pics/submit.gif" name="submit">
    
    </cfform>

	<cfif NOT ISDEFINED('form.submitted')>
        <cfabort>
    </cfif>

</div>
</cfif>

<cfoutput>
<div align="center"><h4 style="color:##000099">Financial Summary as of #DateFormat(now(), 'mm-dd-yyyy')# at #TimeFormat(now(),'h:mm:ss tt')#<br></h2></div>
</cfoutput>

<strong><small>Programs Selected:</small></strong></br>

<cfloop list="#form.selectPrograms#" index="programsSelected">

    <cfif programsSelected IS "All">
    
        <small>All programs were selected</small><br/>
        
        <cfelseif programsSelected EQ 0>
        
            <small>Charges not related to a program</small><br/>
        
            <cfelse>
            
                <cfquery name="getProgramsSelected" datasource="MySQL">
                SELECT *
                FROM smg_programs sp
				WHERE sp.programid = #programsSelected#
                ORDER BY companyid ASC, startdate DESC
                </cfquery>
                
                <cfoutput query="getProgramsSelected">
                
                <cfswitch expression="#getProgramsSelected.companyid#">
                    <cfcase value="1"><cfset compId = 'High School'></cfcase>
                    <cfcase value="7"><cfset compId = 'Trainee'></cfcase>
                    <cfcase value="8"><cfset compId = 'W&T'></cfcase>
                    <cfcase value="9"><cfset compId = 'H2B'></cfcase>
					<cfcase value="10"><cfset compId = 'CASE'></cfcase>
                    <cfcase value="13"><cfset compId = 'SMG Canada'></cfcase>
                    <cfcase value="14"><cfset compId = 'ESI'></cfcase>
                </cfswitch>
                
                <small>#variables.compId# - #getProgramsSelected.programname# (###getProgramsSelected.programid#)</small> <br/>
                
                </cfoutput>
        
    </cfif>
    
</cfloop>

</br></br></br>

<strong><small>Agents Selected:</small></strong></br>
<cfloop list="#form.intrep#" index="agentsSelected">

	<cfoutput>
    	
        <cfif form.intrep IS NOT "All">
        
			<cfif ListLen(form.intrep) GT 1>
                <cfif ListContains(form.intrep, "All")>
                    <cfset form.intrep = #ListDeleteAt(form.intrep, 1)#>
                </cfif>
            </cfif>
        
            <cfquery name="get_all_intl_rep" datasource="MYSQL">
                SELECT	*
                FROM smg_users
                WHERE USERID = #agentsSelected#
            </cfquery>
            
            <small>#get_all_intl_rep.businessname# (#get_all_intl_rep.userid#)</small> <br/>
        
        </cfif>
        
        <cfif form.intrep IS "All">
        	<small>All Agents were selected</small>
        </cfif>
        
    </cfoutput>

</cfloop>


</br></br></br>

<table class="frame">

	<!--- table header --->
    <tr class="darkBlue">
    	<td class="right">
        	<strong><small>Charge Type</small></strong>
        </td>
    	<td class="right">
        	<strong><small>Total Charges</small></strong>
        </td>
    	<td class="right">
        	<strong><small>Total Canceled</small></strong>
        </td>
    	<td class="right">
        	<strong><small>Net Charges</small></strong>
        </td>
    </tr>
        
    <!--- table data rows --->
    
    <cfif form.selectCharges EQ "All">
    
    	<cfoutput query="getChargeTypes">
        
            <!--- total charged --->
            <cfquery name="getTotalCharged" datasource="MySQL">
            SELECT SUM(amount_due) as totalCharged
            FROM smg_charges
            WHERE 1 = 1
            <cfif form.intrep IS NOT "ALL">
            	AND agentid IN (#form.intrep#)
            </cfif>
            <cfif form.selectPrograms IS NOT "ALL">
            	AND programID IN (#form.selectPrograms#)
            </cfif>
            AND type = "#getChargeTypes.chargeType#"
            AND chargeid >= 50512 <!--- chargeids < 50512 cannot be directly linked to cancellations --->
            AND agentid > 0
			</cfquery>
            
            <!--- total canceled --->
            <cfquery name="getTotalCanceled" datasource="MySQL">
            SELECT 
            	sc.chargeid as "creditCharge", 
                IFNULL(sch.chargeid, 0) as "invoiceCharge", 
                IFNULL(sch.type, 0) as chargetype, 
                IFNULL(sum(sc.amount)*-1, 0) as totalCanceled,
                sch.programid
            FROM 
            	smg_credit sc
            LEFT JOIN 
            	smg_charges sch
            ON
            	sch.chargeid = sc.chargeid
            WHERE 1 = 1
            <cfif form.intrep IS NOT "ALL">
            	AND sc.agentid IN (#form.intrep#)
            </cfif>
            <cfif form.selectPrograms IS NOT "ALL">
            	AND sch.programID IN (#form.selectPrograms#)
            </cfif>
            AND sc.chargeid > 0 <!--- chargeids = 0 cannot be directly linked to cancellations --->
            AND sc.agentid > 0
            GROUP BY
            	chargetype
            HAVING
            	chargetype = "#getChargeTypes.chargeType#"
         	</cfquery>
            
            <cfif getTotalCanceled.recordCount NEQ 0>
            	<cfset vTotalCanceled = #getTotalCanceled.totalCanceled#>
            <cfelse>
            	<cfset vTotalCanceled = 0>
            </cfif>
 
            <cfif VAL(getTotalCharged.totalCharged) GT 0>

            	<cfset counter = #counter# + 1>

                <tr <cfif counter MOD 2>bgcolor="##FFFFFF"</cfif>>
                    <td class="two">
                        <small>#getChargeTypes.chargeType#</small>
                    </td>
                    <td class="two">
                    	<cfif getTotalCharged.totalCharged LT 0>
                        	<small><font color="##FF0000">#LSCurrencyFormat(getTotalCharged.totalCharged, "local")#</font></small>
                        <cfelse>
                        	<small>#LSCurrencyFormat(getTotalCharged.totalCharged, "local")#</small>
                        </cfif>
                    </td>
                    <td class="two">
                    	<cfif vTotalCanceled LT 0>
                        	<small><font color="##FF0000">#LSCurrencyFormat(vTotalCanceled, "local")#</font></small> 
                        <cfelse>
                        	<small>#LSCurrencyFormat(vTotalCanceled, "local")#</small>
                        </cfif>                      
                    </td>
                    <td class="two">
						<cfset netCharges = #getTotalCharged.totalCharged# + #vTotalCanceled#>
                        <cfif netCharges LT 0>
                            <small><font color="##FF0000">#LSCurrencyFormat(netCharges, "local")#</font></small>
                        <cfelse>
                            <small>#LSCurrencyFormat(netCharges, "local")#</small>
                        </cfif>
                    </td>
                </tr>
                
                <cfset sumCharges = #sumCharges# + #getTotalCharged.totalCharged#>
                <cfset sumCancellations = #sumCancellations# + #vTotalCanceled#>
                
             </cfif>
             
        </cfoutput>
        
        <!--- START: CHARGES AND CREDITS THAT CANNOT BE LINKED --->
        
		<!--- total old charges from before mid april 2008: cannot be directly linked to cancellations --->
        <cfquery name="getOldCharges" datasource="MySQL">
        SELECT SUM(amount_due) as totalOldCharges
        FROM smg_charges
        WHERE 1 = 1
        <cfif form.intrep IS NOT "ALL">
            AND agentid IN (#form.intrep#)
        </cfif>
        <cfif form.selectPrograms IS NOT "ALL">
            AND programID IN (#form.selectPrograms#)
        </cfif>
        AND chargeid < 50512 <!--- chargeids < 50512 cannot be directly linked to cancellations --->
        AND agentid > 0
        </cfquery>
        
		<!--- total canceled for old charges from before mid april 2008: cannot be directly linked to cancellations --->
        <cfquery name="getOldCancellations" datasource="MySQL">
        SELECT 
            sc.chargeid, 
            IFNULL(sum(sc.amount)*-1, 0) as totalOldCanceled
        FROM 
            smg_credit sc
        LEFT JOIN 
            smg_charges sch
        ON
            sch.chargeid = sc.chargeid
        WHERE
        	sc.chargeid = 0 <!--- chargeids = 0 cannot be directly linked to cancellations --->
        AND
        	sc.agentid > 0
        <cfif form.intrep IS NOT "ALL">
            AND sc.agentid IN (#form.intrep#)
        </cfif>
        <cfif form.selectPrograms IS NOT "ALL">
            AND sch.programID IN (#form.selectPrograms#)
        </cfif>
        </cfquery>
        
        <cfset getOldCharges.totalOldCharges = #VAL(getOldCharges.totalOldCharges)#>
        <cfset getOldCancellations.totalOldCanceled = #VAL(getOldCancellations.totalOldCanceled)#>
      
        <cfoutput>
        <tr>
            <td class="two">
                <small>Old Charges (Before Mid April 2008)</small>
            </td>
            <td class="two">
                <cfif getOldCharges.totalOldCharges LT 0>
                    <small><font color="##FF0000">#LSCurrencyFormat(getOldCharges.totalOldCharges, "local")#</font></small>
                <cfelse>
                    <small>#LSCurrencyFormat(getOldCharges.totalOldCharges, "local")#</small>
                </cfif>
            </td>
            <td class="two">
                <cfif getOldCancellations.totalOldCanceled LT 0>
                    <small><font color="##FF0000">#LSCurrencyFormat(getOldCancellations.totalOldCanceled, "local")#</font></small> 
                <cfelse>
                    <small>#LSCurrencyFormat(getOldCancellations.totalOldCanceled, "local")#</small>
                </cfif>                      
            </td>
            <td class="two">
                <cfset netCharges = #getOldCharges.totalOldCharges# + #getOldCancellations.totalOldCanceled#>
                <cfif netCharges LT 0>
                    <small><font color="##FF0000">#LSCurrencyFormat(netCharges, "local")#</font></small>
                <cfelse>
                    <small>#LSCurrencyFormat(netCharges, "local")#</small>
                </cfif>
            </td>
        </tr>
        </cfoutput>
        
		<cfset sumCharges = #sumCharges# + #getOldCharges.totalOldCharges#>
        <cfset sumCancellations = #sumCancellations# + #getOldCancellations.totalOldCanceled#>
        
        <!--- END: CHARGES AND CREDITS THAT CANNOT BE LINKED --->
    
    <cfelse><!--- START: IF USER SELECTS MULTPLE CHARGES --->
    	
        <!--- if user selects multiple charges instead of "All" --->
        
        <cfif ListLen(form.intrep) GT 1>
			<cfif ListContains(form.intrep, "All")>
                <cfset form.intrep = #ListDeleteAt(form.intrep, 1)#>
            </cfif>
        </cfif>
        
        <cfif ListLen(form.selectPrograms) GT 1>
			<cfif ListContains(form.selectPrograms, "All")>
                <cfset form.selectPrograms = #ListDeleteAt(form.selectPrograms, 1)#>
            </cfif>
        </cfif>
        
		<cfif ListContains(form.selectCharges, "All")>
            <cfset form.selectCharges = #ListDeleteAt(form.selectCharges, 1)#>
        </cfif>
		
        <cfloop list="#form.selectCharges#" index="chargeType">
        	
            <!--- total charged --->
            <cfquery name="getTotalCharged" datasource="MySQL">
            SELECT SUM(amount_due) as totalCharged
            FROM smg_charges
            WHERE 1 = 1
            <cfif form.intrep IS NOT "ALL">
            	AND agentid IN (#form.intrep#)
            </cfif>
            AND agentid > 0
            <cfif form.selectPrograms IS NOT "ALL">
            	AND programID IN (#form.selectPrograms#)
            </cfif>
            <cfif chargetype IS "Old"><!--- chargeids < 50512 cannot be directly linked to cancellations --->
            	AND chargeid < 50512
            <cfelse>
                AND type = "#chargeType#"
                AND chargeid >= 50512 <!--- chargeids < 50512 cannot be directly linked to cancellations --->
            </cfif>
         	</cfquery>
            
            <!--- total canceled --->
            <cfquery name="getTotalCanceled" datasource="MySQL">
            SELECT 
            	IFNULL(sc.chargeid, 0) as "creditCharge", 
                IFNULL(sch.chargeid, 0) as "invoiceCharge", 
                IFNULL(sch.type, 0) as chargetype, 
                IFNULL(sum(sc.amount)*-1, 0) as totalCanceled,
                IFNULL(sch.programid, 0)
            FROM 
            	smg_credit sc
            LEFT JOIN 
            	smg_charges sch
            ON
            	sch.chargeid = sc.chargeid
            WHERE 1 = 1
            <cfif form.intrep IS NOT "ALL">
            	AND sc.agentid IN (#form.intrep#)
            </cfif>
            AND sc.agentid > 0
            <cfif form.selectPrograms IS NOT "ALL" AND chargetype IS NOT "Old">
            	AND sch.programID IN (#form.selectPrograms#)
            </cfif>
            <cfif chargetype IS "Old"><!--- chargeids = 0 cannot be directly linked to cancellations --->
            	AND sc.chargeid = 0
            <cfelse>    
                AND sc.chargeid > 0 <!--- chargeids > 0 CAN be directly linked to cancellations --->
            GROUP BY
            	chargetype
			HAVING
            	chargetype = "#chargeType#"
            </cfif>
            </cfquery>
            
            <cfif getTotalCanceled.recordCount GT 0>
            	<cfset vTotalCanceled = #getTotalCanceled.totalCanceled#>
            <cfelse>
            	<cfset vTotalCanceled = 0>
            </cfif>

            <cfif VAL(getTotalCharged.totalCharged) NEQ 0>
            
            	<cfset counter = #counter# + 1>
            
				<cfoutput>
                
                    <tr <cfif counter MOD 2>bgcolor="##FFFFFF"</cfif>>
                        <td class="two">
                            <small>
                            	<cfif chargeType IS "Old">
                                	Old Charges (Before Mid April 2008)
                                <cfelse>
                                	#chargetype# 
                                </cfif>
                            </small>
                        </td>
                        <td class="two">
                        	<cfif getTotalCharged.totalCharged LT 0>
                            	<small><font color="##FF0000">#LSCurrencyFormat(getTotalCharged.totalCharged,"local")#</font></small>
                            <cfelse>
                            	<small>#LSCurrencyFormat(getTotalCharged.totalCharged,"local")#</small>
                            </cfif>
                        </td>
                        <td class="two">
                        	<cfif vTotalCanceled LT 0>
                            	<small><font color="##FF0000">#LSCurrencyFormat(vTotalCanceled, "local")#</font></small> 
                            <cfelse>
                            	<small>#LSCurrencyFormat(vTotalCanceled, "local")#</small> 
                            </cfif>
                        </td>
                        <td class="two">
							<cfset netCharges = #getTotalCharged.totalCharged# + #vTotalCanceled#>
                            <cfif netCharges LT 0>
                                <small><font color="##FF0000">#LSCurrencyFormat(netCharges, "local")#</font></small>
                            <cfelse>
                                <small>#LSCurrencyFormat(netCharges, "local")#</small>
                            </cfif>
                        </td>
                    </tr>
                
                </cfoutput>
            
            <cfset sumCharges = #sumCharges# + #getTotalCharged.totalCharged#>
            <cfset sumCancellations = #sumCancellations# + #vTotalCanceled#>
            
            </cfif>
            
        </cfloop>
    
    </cfif><!--- END: IF USER SELECTS MULTPLE CHARGES --->
    
    <!--- table totals --->
	<tr class="darkBlue">
    	<td class="right">
        	<strong><small>Totals:</small></strong>
        </td>
        
        <cfoutput>
        
            <td class="right">
            	<strong><small>#LSCurrencyFormat(sumCharges, "local")#</small></strong>
            </td>
            <td class="right">
            	<strong><small>#LSCurrencyFormat(sumCancellations, "local")#</small></strong>
            </td>
            <td class="right">
            	<cfset totalNetCharges = #sumCharges# + #sumCancellations#>
                <strong><small>#LSCurrencyFormat(totalNetCharges, "local")#</small></strong>
            </td>
        
        </cfoutput>
    </tr>
    
</table>
