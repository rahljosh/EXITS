<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>W&T Price Table</title>

<style type="text/css">

table {
	border-collapse:collapse;
	width: 100%;
}
table, th, td {
	border: 1px solid #CCCCCC;
	font-size:small;
}
th {
	height: 50px;
}
td {
	text-align: left;
	height: 20px;
	vertical-align: middle;
	padding: 10px;
}
.tHeader {
	color: #FFFFFF;
	background-color:#004080;
	
}
.submit {
	text-align: center;
	vertical-align: middle;
}
.defaultPrices {
	width: 50%;
}
.defaultInsurance {
	width: 50%;
}
div {
	margin-top: 50px;
	margin-bottom: 20px;
}
</style>

</head>

<cfparam name="form.submitInsurance" default="0">
<cfparam name="form.submitPrice" default="0">
<cfparam name="form.submitted" default="0">
<cfparam name="form.submitDefaultPrice" default="0">

<!--- update wt monthly insurance price --->
<cfif form.submitInsurance IS "submit">
	<cfquery name="updateInsurance" datasource="MySQL">
    UPDATE
    	smg_insurance_type
    SET
    	wt = #form.insurancePrice#
    WHERE
    	insutypeID = 14
    </cfquery>
</cfif>

<!--- update or insert prices and fees --->
<cfif form.submitPrice IS "submit">
	
    <cfloop list="#form.IntlRepID#" index="IntlRepID">
    	
        <!--- check if intl rep is already in the table --->
        <cfquery name="qCheckRep" datasource="MySQL">
        SELECT
        	userID
        FROM
        	extra_wt_prices
        WHERE
        	userID = #IntlRepID#
        </cfquery>

        <!--- if intl rep is not in the table, insert it --->
        <cfif qCheckRep.recordCount EQ 0>
        
            <cfquery name="qInsertRep" datasource="MySQL">
            INSERT INTO
                extra_wt_prices (
                	userID, 
                    priceCsbPlacement, 
                    priceSelfPlacement,
                    premiumProcessing, 
                    placementFee,
                    sevis,
                    includeSevis
                    )
            VALUES (
            	#IntlRepID#,
                #EVALUATE("form.priceCsbPlacement" & "#IntlRepID#")#,
                #EVALUATE("form.priceSelfPlacement" & "#IntlRepID#")#,
                #EVALUATE("form.premiumProcessing" & "#IntlRepID#")#,
                #EVALUATE("form.placementFee" & "#IntlRepID#")#,
                #EVALUATE("form.sevis" & "#IntlRepID#")#,
                #EVALUATE("form.includeSevis" & "#IntlRepID#")#
                )
            </cfquery>
            
        <cfelse><!--- if intl rep is already in the table, just update it --->
            
            <cfquery name="updatePrices" datasource="MySQL">
            UPDATE
                extra_wt_prices
            SET
                priceCsbPlacement = #EVALUATE("form.priceCsbPlacement" & "#IntlRepID#")#,
                priceSelfPlacement = #EVALUATE("form.priceSelfPlacement" & "#IntlRepID#")#,
                placementFee = #EVALUATE("form.placementFee" & "#IntlRepID#")#,
                sevis = #EVALUATE("form.sevis" & "#IntlRepID#")#,
                premiumProcessing = #EVALUATE("form.premiumProcessing" & "#IntlRepID#")#,
                includeSevis = #EVALUATE("form.includeSevis" & "#IntlRepID#")#
            WHERE
                userID = #IntlRepID#
            </cfquery>
            
        </cfif>
        
    </cfloop>

</cfif>

<!--- set default prices and fees --->
<cfif form.submitDefaultPrice IS "submit">
entrou
	<cfquery name="qDefaultPrices" datasource="MySQL">
    UPDATE
    	extra_wt_prices
    SET
    	<cfswitch expression="#form.choosenDefault#">
        	<cfcase value="defaultCsbPlacement">
            	priceCsbPlacement = #form.defaultFee#
            </cfcase>
            <cfcase value="defaultSelfPlacement">
            	priceSelfPlacement = #form.defaultFee#
            </cfcase>
            <cfcase value="defaultPlacementFee">
            	placementFee = #form.defaultFee#
            </cfcase>
            <cfcase value="defaultPremium">
            	premiumProcessing =  #form.defaultFee# 
            </cfcase>
            <cfcase value="defaultSevis">
            	sevis =  #form.defaultFee# 
            </cfcase>
        <cfcase value="zeroAll">
        	priceCsbPlacement = 0,
            priceSelfPlacement = 0,
            placementFee = 0,
            sevis = 0,
            premiumProcessing =  0
        </cfcase>
        </cfswitch>
	</cfquery>
    
    <!--- reset form.submitted to zero --->
    <cfset form.submitted = 0>
    
</cfif>

<!--- get wt monthly insurance price --->
<cfquery name="qInsurance" datasource="MySQL">
SELECT
	wt
FROM
	smg_insurance_type
WHERE
	insutypeID = 14
</cfquery>

<!--- get all wt agents --->
<cfquery name="qIntlReps" datasource="MySQL">
SELECT
      su.businessname, 
      su.userID, 
      su.extra_accepts_sevis_fee, 
      ewp.priceCsbPlacement, 
      ewp.priceSelfPlacement,
      ewp.premiumProcessing,
      ewp.placementFee, 
      ewp.sevis,
      ewp.includeSevis
FROM
    smg_users su  
LEFT JOIN
	extra_wt_prices ewp
ON
	ewp.userID = su.userID
WHERE
     usertype = 8
AND
   companyID LIKE "%8%"
ORDER BY
	su.businessname
</cfquery>

<body>

<cfoutput>

<div align="center" >
	<h4><b><font face="Verdana, Arial, Helvetica, sans-serif"><small>Work and Travel Prices and Insurance</small></font></b></h4>
</div>

<table align="center">
	<tr>
    	<td class="tHeader"><b>International Representative</b></td>
        <td class="tHeader"><b>Price CSB Placement</b></td>
        <td class="tHeader"><b>Price Self-Placement</b></td>
        <td class="tHeader"><b>Placement Fee</b></td>
        <td class="tHeader"><b>Premium Processing Fee</b></td>
        <td class="tHeader"><b>Sevis Fee</b></td>
        <td class="tHeader"><b>Include Sevis?</b></td>
    </tr>
    
    <form name="prices" method="post" action="m_wt_prices.cfm">
		<cfloop query="qIntlReps">
        	<cfset row = qIntlReps.currentRow + 1>
            <tr>
                <td <cfif row MOD 2>bgcolor="##F9F9F9"</cfif>>
                	#qIntlReps.businessname# (#qIntlReps.userID#) <input type="hidden" name="IntlRepID" value="#qIntlReps.userID#"  />
                </td>
                <td <cfif row MOD 2>bgcolor="##F9F9F9"</cfif>>
					<cfif qIntlReps.priceCsbPlacement IS "">
                        <cfset valueCsbPlacement = 0.00>
                    <cfelse>
                        <cfset valueCsbPlacement = qIntlReps.priceCsbPlacement>
                    </cfif>
                    <input type="text" name="priceCsbPlacement#qIntlReps.userID#" value="#valueCsbPlacement#"  />
                </td>
                <td <cfif row MOD 2>bgcolor="##F9F9F9"</cfif>>
					<cfif qIntlReps.priceSelfPlacement IS "">
                    	<cfset valueSelfPlacement = 0.00>
                    <cfelse>
                    	<cfset valueSelfPlacement = qIntlReps.priceSelfPlacement>
                    </cfif>
                	<input type="text" name="priceSelfPlacement#qIntlReps.userID#" value="#valueSelfPlacement#"  />
                </td>
                <td <cfif row MOD 2>bgcolor="##F9F9F9"</cfif>>
					<cfif qIntlReps.placementFee IS "">
                    	<cfset valueplacementFee = 0.00>
                    <cfelse>
                    	<cfset valueplacementFee = qIntlReps.placementFee>
                    </cfif>
                	<input type="text" name="placementFee#qIntlReps.userID#" value="#valueplacementFee#"  />
                </td>
                <td <cfif row MOD 2>bgcolor="##F9F9F9"</cfif>>
					<cfif qIntlReps.premiumProcessing IS "">
                    	<cfset valuepremiumProcessing = 0.00>
                    <cfelse>
                    	<cfset valuepremiumProcessing = qIntlReps.premiumProcessing>
                    </cfif>                	
                	<input type="text" name="premiumProcessing#qIntlReps.userID#" value="#valuepremiumProcessing#"  />
                </td>
                <td <cfif row MOD 2>bgcolor="##F9F9F9"</cfif>>
					<cfif qIntlReps.sevis IS "">
                    	<cfset valuesevis = 0.00>
                    <cfelse>
                    	<cfset valuesevis = qIntlReps.sevis>
                    </cfif>                	
                	<input type="text" name="sevis#qIntlReps.userID#" value="#valuesevis#"  />
                </td>
                <td <cfif row MOD 2>bgcolor="##F9F9F9"</cfif>>
                	<select name="includeSevis#qIntlReps.userID#">
                    	<option value="0" <cfif qIntlReps.includeSevis EQ 0>selected="selected"</cfif>>No</option>
                    	<option value="1" <cfif qIntlReps.includeSevis EQ 1>selected="selected"</cfif>>Yes</option>
                    </select>
				</td>
            </tr>
        </cfloop>
        
        <tr>
        	<td colspan="7" align="center" class="submit">
            	<input type="hidden" name="submitPrice" value="submit" />
            	<input type="image" src="../pics/buttons/submit.png" />
            </td>
        </tr>
         
    </form>
</table>

<div align="left" >
	<h8><b><font face="Verdana, Arial, Helvetica, sans-serif"><small>Set Default Prices</small></font></b></h8>
</div>
<table align="left" class="defaultPrices">
	<form name="defaultPrice" id="defaultPrice" method="post" action="m_wt_prices.cfm">
    	<tr>
        	<td class="tHeader">
            	<b>Select Price</b>
            </td>
            <td class="tHeader">
            	<b>Enter the default Price</b>
            </td>
        </tr> 
    	<tr>
        	<td>
            	<select name="choosenDefault">
                	<option value="defaultCsbPlacement">Default Price for CSB Placement</option>
                    <option value="defaultSelfPlacement">Default Price for Self Placement</option>
                    <option value="defaultPlacementFee">Default Placement Fee</option>
                    <option value="defaultPremium">Default Premium Processing Fee</option>
                    <option value="defaultSevis">Default Sevis Fee</option>
                    <option value="zeroAll">Make all zero</option>
                </select>
            </td>
            <td>
            	<input type="text" name="defaultFee" value="0" />
            </td>
        </tr> 
        	<td colspan="2" align="center" class="submit">
           		 <input type="hidden" name="submitDefaultPrice" id="submitDefaultPrice" value="submit" onclick="confirm_defaultPrice();" />
            	<input type="image" src="../pics/buttons/submit.png" />
            </td>
        </tr>
</table>
<br /><br /><br /><br /><br />
<div align="left" >
	<h8><b><font face="Verdana, Arial, Helvetica, sans-serif"><small>Set Default Insurance</small></font></b></h8>
</div>
<table align="left" class="defaultInsurance">
	<form name="insurance" method="post" action="m_wt_prices.cfm">
        <tr>
            <td class="tHeader">
                <b>Monthly Insurance Price</b>
            </td>
            <td>
                <input type="text" name="insurancePrice" value="#qInsurance.wt#"  />
            </td>
        </tr>
        <tr>
            <td colspan="2" class="submit">  
            	<input type="hidden" name="submitInsurance" value="submit" />
                <input type="image" src="../pics/buttons/submit.png" />
            </td>
        </tr>
    </form>
</table>

</cfoutput>

</body>

</html>
