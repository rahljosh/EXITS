<!--- HIGH SCHOOL FEES --->
<cfif client.companyID NEQ 8><!--- if not in w&t --->

	<span class="application_section_header">Program Fees</span> <br>
	<p>Assign program fees per program for this International Rep.  Changing information here will only affect students that have NOT been invoiced. <br><br>
    If there is difference from the base price, just leave blank, don't put in zero's, N/A, etc.<br>
    If you need to remove an amount, set it to 0 (zero).</p>

    <cfquery name="get_prices" datasource="#APPLICATION.DSN#">
        SELECT 
            u.userID,
            u.businessname, 
            u.12_month_price, 
            u.10_month_price, 
            u.5_month_price,
            u.accepts_sevis_fee,
            u.insurance_typeid,
            i.ayp5,
            i.ayp10,
            i.ayp12
        FROM smg_users u
        INNER JOIN smg_insurance_type i ON i.insutypeid = u.insurance_typeid
        WHERE u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.userid)#">
    </cfquery>

    <cfquery name="get_insutypes" datasource="#APPLICATION.DSN#">
        SELECT *
        FROM smg_insurance_type
    </cfquery>

	<cfoutput>
		
        <form method="post" action="../nsmg/querys/add_discount.cfm?userid=#url.userid#">
    		<input type="hidden" name="userid" value="#url.userid#">
			
            <table align="center">
				<tr><td align="center">#get_prices.businessname#</td></tr>
			</table>

			<table div align="center" cellpadding= 4 cellspacing=0>
				<tr bgcolor="##00003C">
					<td colspan=2 align="center"><font color="white">12 Months</font></td>
					<td colspan=2 align="center"><font color="white">10 Months</font></td>
                    <td colspan=2 align="center"><font color="white">5 months</font></td>
				</tr>
				<tr bgcolor="##00003C">
					<td align="center"><font color="white">Price</font></td>
                    <td align="center"><font color="white">Insurance</font></td>
                    <td align="center"><font color="white">Price</font></td>
                    <td align="center"><font color="white">Insurance</font></td>
                    <td align="center"><font color="white">Price</font></td>
                    <td align="center"><font color="white">Insurance</font></td>
				</tr>
				<cfloop query="get_prices">
					<tr>
    					<td><input name="12_month_price" type="text" value="#get_prices.12_month_price#" size=5></td>
                        <td>#ayp12#</td>
						<td><input name="10_month_price" type="text" value="#get_prices.10_month_price#" size=5></td>
                        <td>#ayp10#</td>
                        <td><input name="5_month_price" type="text" value="#get_prices.5_month_price#" size=5></td>
                        <td>#ayp5#</td>
					</tr>
					<tr bgcolor="00003C"><td colspan=6><font color="white">Insurance Policy Type</font></td></tr>
					<tr>
						<td colspan=2>											
                            <select name="insurance_typeid">
                                <option value="0"></option>
                                <cfloop query="get_insutypes">
                                	<option value="#insutypeid#" <cfif get_prices.insurance_typeid EQ insutypeid>selected</cfif> >#type#</option>
                                </cfloop>
                            </select>
						</td>
					</tr>
					<tr bgcolor="00003C"><td colspan=6><font color="white">Accepts SEVIS FEE</font></td></tr>
					<tr>
						<td colspan="2"> 								
                            <select name="accepts_sevis_fee">
                                <option value=""></option>
                                <option value="0" <cfif get_prices.accepts_sevis_fee EQ '0'>selected</cfif> >No</option>
                                <option value="1" <cfif get_prices.accepts_sevis_fee EQ '1'>selected</cfif> >Yes</option>
                            </select>	
						</td>
					</tr>
					<tr><td colspan=4 align="right"><input name="Submit" type="image" src="pics/next.gif" border=0></td></tr>
               	</cfloop>
         	</table>
            
       	</form>

	</cfoutput>

	<cfif isDefined('url.message')>
        <p><span class="get_attention" align="center">Program charges were updated / added Successfully!!</span><br><br></p>
    </cfif>

</cfif><!--- end of: if not in w&t --->


<!--- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --->


<!--- W&T FEES --->
<cfparam name="form.submitted" default="0">

<cfif client.companyID EQ 8><!--- if in w&t --->

<span class="application_section_header">Program Fees</span> <br />

<p>Assign program fees per program for this International Rep.  Changing information here will only affect students that have NOT been invoiced. <br /><br />
If there is difference from the base price, just leave blank, don't put in zero's, N/A, etc.<br />
If you need to remove an amount, set it to 0 (zero).</p>

<!--- update prices and fees --->
<cfif form.submitted IS "yes">

	<!--- check if intl rep is already in the table --->
    <cfquery name="qCheckRep" datasource="MySQL">
    SELECT
        userID
    FROM
        extra_wt_prices
    WHERE
        userID = #url.userID#
    </cfquery>

    <!--- if intl rep is not in the table, insert it --->
    <cfif qCheckRep.recordCount EQ 0>
    	
        <cfquery name="qInsertRep" datasource="MySQL">
        INSERT INTO
            extra_wt_prices (
                userID, 
                priceCsbPlacement, 
                priceSelfPlacement, 
                placementFee,
                sevis,
                premiumProcessing,
                includeSevis)
        VALUES (
            #url.userid#,
            #form.priceCsbPlacement#,
            #form.priceSelfPlacement#,
            #form.placementFee#,
            #form.sevis#,
            #form.premiumProcessing#,
            #form.includeSevis#)
        </cfquery>

    <cfelse><!--- if intl rep is already in the table, just update it --->
    
        <cfquery name="updatePrices" datasource="MySQL">
        UPDATE
            extra_wt_prices
        SET
            priceCsbPlacement = #form.priceCsbPlacement#,
            priceSelfPlacement = #form.priceSelfPlacement#,
            placementFee = #form.placementFee#,
            sevis = #form.sevis#,
            premiumProcessing = #form.premiumProcessing#,
            includeSevis = #form.includeSevis#
        WHERE
            userID = #url.userid#
        </cfquery>
        
		<!--- update companyID: w&t companyID is 8 --->
        <cfquery name="qCompID" datasource="MySQL">
        SELECT companyID
        FROM smg_users
        WHERE userID = #url.userid#
        </cfquery>
    
    </cfif>
    
	<!--- if companyID 8 is not included in companyID, include it --->
    <cfif LISTFIND(qCompID.companyID, 8) EQ 0>
        <cfset qCompID.companyID = LISTAPPEND(qCompID.companyID,8)>
        <cfset qCompID.companyID = LISTSORT(qCompID.companyID, "numeric")>
        <cfquery name="qUpdateCompID" datasource="MySQL">
        UPDATE smg_users
        SET companyID = "#qCompID.companyID#"
        WHERE userID = #url.userid#
        </cfquery>
    </cfif>
    
    <cfquery name="updateInsuranceCost" datasource="MySQL">
    UPDATE
    	smg_insurance_type
    SET
    	wt = #form.insurance#
    WHERE
    	insutypeID = 14
    </cfquery>
    
    <cfquery name="updateUsersTable" datasource="MySQL">
    UPDATE
    	smg_users
    SET
    	extra_insurance_typeid = #form.insuranceID#,
        extra_accepts_sevis_fee = #form.includeSevis#
    WHERE
    	userID = #url.userid#
    </cfquery>
	
    <p align="center"><span class="get_attention"><font color="##FF0000"><b> charges were updated / added Successfully!! </b></font></span><br /><br /></p>
    
</cfif>

<cfquery name="get_prices" datasource="mysql">
	SELECT 
        su.businessname, 
        su.userID, 
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
    	su.userID = #url.userid#
</cfquery>

<!--- get insurance type AND insurance cost --->
<cfquery name="get_insutypes" datasource="MySql">
	SELECT insutypeID, type, wt
	FROM smg_insurance_type
    WHERE insutypeID = 14
</cfquery>

<Cfoutput>
<form method="post" action="">

<input type="hidden" name="submitted" value="yes" />
<input type="hidden" name="userid" value="#url.userid#">

<table align="center">
    <tr>
        <td align="center">
        	#get_prices.businessname#
        </td>
    </tr>
</table>
</Cfoutput>

<table div align="center" cellpadding= 4 cellspacing=0>
	<tr bgcolor="#00003C">
		<td align="center">
        	<font color="white">Price CSB Placement</font>
        </td>
        <td align="center">
        	<font color="white">Price Self-Placement</font>
        </td><td align="center">
        	<font color="white">Placement Fee</font>
        </td>
        <td align="center">
        	<font color="white">Premium Processing</font>
        </td>
        <td align="center">
        	<font color="white">Sevis Fee</font>
        </td>
        <td align="center">
        	<font color="white">Insurance</font>
        </td>
	</tr>
	<cfoutput query="get_prices">
        <tr>
            <td>
            	<cfparam name="form.priceCsbPlacement" default="0">
            	<cfif get_prices.priceCsbPlacement IS "">
                	<cfset valueCsbPlacement = 0>
                <cfelse>
                	<cfset valueCsbPlacement = get_prices.priceCsbPlacement>
                </cfif>
                <input name="priceCsbPlacement" type="text" value="#valueCsbPlacement#" size=5>
            </td>
            <td>
            	<cfparam name="form.priceSelfPlacement" default="0">
            	<cfif get_prices.priceSelfPlacement IS "">
                	<cfset valueSelfPlacement = 0>
                <cfelse>
                	<cfset valueSelfPlacement = get_prices.priceSelfPlacement>
                </cfif>
                <input name="priceSelfPlacement" type="text" value="#valueSelfPlacement#" size=5>
            </td>
            <td>
            	<cfparam name="form.placementFee" default="0">
            	<cfif get_prices.placementFee IS "">
                	<cfset valueplacementFee = 0>
                <cfelse>
                	<cfset valueplacementFee = get_prices.placementFee>
                </cfif>
                <input name="placementFee" type="text" value="#valueplacementFee#" size=5>
            </td>
            <td>
            	<cfparam name="form.premiumProcessing" default="0">
            	<cfif get_prices.premiumProcessing IS "">
                	<cfset valuepremiumProcessing = 0>
                <cfelse>
                	<cfset valuepremiumProcessing = get_prices.premiumProcessing>
                </cfif>
                <input name="premiumProcessing" type="text" value="#valuepremiumProcessing#" size=5>
            </td>
            <td>
            	<cfparam name="form.sevis" default="0">
            	<cfif get_prices.sevis IS "">
                	<cfset valuesevis = 0>
                <cfelse>
                	<cfset valuesevis = get_prices.sevis>
                </cfif>
                <input name="sevis" type="text" value="#valuesevis#" size=5>
            </td>
            <td>
            	<cfparam name="form.insurance" default="0">
            	<cfif get_insutypes.wt IS "">
                	<cfset valueinsurance = 0>
                <cfelse>
                	<cfset valueinsurance = get_insutypes.wt>
                </cfif>
                <input name="insurance" type="text" value="#valueinsurance#" size=5>
            </td>
        </tr>
        <tr bgcolor="00003C">
            <td colspan=6>
                <font color="white">Insurance Policy Type</font>
            </td>
        </tr>
        <tr>
            <td colspan=2>											
                <input name="insuranceType" type="text" value="#get_insutypes.type#" size="30" disabled="disabled">
                <input type="hidden" name="insuranceID" value="#get_insutypes.insutypeID#">
            </td>
        </tr>
        <tr bgcolor="00003C">
            <td colspan=6>
                <font color="white">Accepts SEVIS FEE</font>
            </td>
        </tr>
        <tr>
            <td colspan="2"> 								
                <select name="includeSevis">
                    <option value="0" <cfif get_prices.includeSevis EQ '0'>selected="selected"</cfif> >No</option>
                    <option value="1" <cfif get_prices.includeSevis EQ '1'>selected="selected"</cfif> >Yes</option>
                </select>	
            </td>
        </tr>
        <tr>
            <td colspan=4 align="right">
                <input name="Submit" type="image" src="pics/next.gif" border=0>
            </td>
        </tr>
    </cfoutput>		
</table>

</form>
<br />

</cfif><!--- end of: if in w&t --->