<!--- ------------------------------------------------------------------------- ----
	
	File:		representativeRates.cfm
	Author:		James Griffiths
	Date:		July 16, 2012
	Desc:		List of representative rates

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfscript>
		param name="URL.order" default="lastName,firstName";
		param name="FORM.submitted" default=0;
	</cfscript>
	
    <cfquery name="qGetReps" datasource="MySql">
    	SELECT
        	u.*
		FROM 
        	smg_users u
		LEFT JOIN 
        	user_access_rights uar ON u.userid = uar.userid
		WHERE 
        	uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="7"> 
    	AND 
        	uar.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
		AND
        	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		GROUP BY
        	u.userid
		ORDER BY
        	#URL.order#
    </cfquery>
    
    <cfif VAL(FORM.submitted)>
        <cfloop query="qGetReps">
            <cfset value=FORM["val_#userID#"]>
            <cfset payment=FORM["pay_#userID#"]>
            <cfquery name="qUpdateRates" datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_users
                SET
                	<cfif payment EQ 1>
                		php_repRate = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(value,'9.99')#">,
                   	<cfelse>
                    	php_repRate = <cfqueryparam cfsqltype="cf_sql_float" value="0.00">,
                    </cfif>
                    php_payRep = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(payment)#">
                WHERE
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#">
            </cfquery>
       </cfloop>
       <cflocation url="?curdoc=tools/representativeRates&order=#URL.order#">
 	</cfif>
    
</cfsilent>

<script type="text/javascript">

	var displayRate = function(elem) {
		var number = $(elem).attr('id').substring(4);
		var visible = '#visible_' + number;
		var inputBox = '#Xval_' + number;
		var hiddenInputBox = '#val_' + number;
		if ($(elem).val() == 0) {
			$(visible).attr('style','display:none');
			$(inputBox).val('0.00');
			$(hiddenInputBox).val('0.00');
		} else {
			$(visible).removeAttr('style');
		}
	}
	
	var updateHidden = function(elem) {
		var number = $(elem).attr('id').substring(5);
		$("#val_"+number).val($(elem).val());
	}

</script>

<cfif (CLIENT.userType EQ 1) OR (ListFind("7630,17427",CLIENT.userID)) OR (APPLICATION.isServerLocal AND CLIENT.userID EQ 17306)>

	<cfoutput>
    
        <form name="representativeRates" id="representativeRates" method="post">
            <input type="hidden" name="submitted" id="submitted" value="1" />
            
            <table width="98%" align="center" cellpadding="2" bgcolor="##e9ecf1" border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <th>&nbsp;</th>
                </tr>
                <tr>
                    <th width="25%"></th>
                    <th width="50%" style="font-size:14px;">Representative Rates<span style="font-size:12px;"> - #qGetReps.recordCount# Representatives</span></th>
                    <th width="25%" align="center"><input type="image" src="pics/submit.gif" onClick="storeRates(); return false;" /></th>
                </tr>
                <tr>
                    <th>&nbsp;</th>
                </tr>
            </table>
        
            <table width="98%" align="center" cellpadding="1" bgcolor="##e9ecf1" border=0 cellpadding=0 cellspacing=0>
                    
                <tr>
                    <th background="images/back_menu2.gif" align="left" width="5%"><a href="?curdoc=tools/representativeRates&order=userID">ID</a></th>
                    <th background="images/back_menu2.gif" align="left" width="15%"><a href="?curdoc=tools/representativeRates&order=lastName,firstName">Name</a></th>
                    <th background="images/back_menu2.gif" align="left" width="20%"><a href="?curdoc=tools/representativeRates&order=address">Address</a></th>
                    <th background="images/back_menu2.gif" align="left" width="15%"><a href="?curdoc=tools/representativeRates&order=city">City</a></th>
                    <th background="images/back_menu2.gif" align="left" width="15%"><a href="?curdoc=tools/representativeRates&order=state">State</a></th>
                    <th background="images/back_menu2.gif" align="center" width="20%">Monthly Rate</th>
                    <th background="images/back_menu2.gif" align="center" width="10%">Does PHP Pay</th>
                </tr>
           
                <cfloop query="qGetReps">
                
                    <tr bgcolor="#iif(qGetReps.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
                        <td class="style1"><a href="?curdoc=users/user_info&userid=#userID#">#userID#</a></td>
                        <td class="style1"><a href="?curdoc=users/user_info&userid=#userID#">#firstName# #lastName#</a></td>
                        <td class="style1">#address#</td>
                        <td class="style1">#city#</td>
                        <td class="style1">#state#</td>
                        <td class="style1" align="center">
                            <input type="hidden" name="val_#userID#" id="val_#userID#" class="value" value="#php_repRate#" />
                            <span id="visible_#userID#" <cfif NOT VAL(qGetReps.php_payRep)>style="display:none;"</cfif>>
                                <input type="text" name="Xval_#userID#" id="Xval_#userID#" class="value" value="#php_repRate#" style="height:15px; width:100px; text-align:right;" onchange="updateHidden(this);" />
                            </span>
                        </td>
                        <td class="style1" align="center">
                            <select name="pay_#userID#" id="pay_#userID#" class="pay" onchange="displayRate(this);">
                                <option value="0"<cfif NOT VAL(qGetReps.php_payRep)>selected="selected"</cfif>>No</option>
                                <option value="1"<cfif VAL(qGetReps.php_payRep)>selected="selected"</cfif>>Yes</option>
                            </select>
                        </td
                    ></tr>
                
                </cfloop>
                
            </table>
        
        </form>
        
    </cfoutput>
	
</cfif>