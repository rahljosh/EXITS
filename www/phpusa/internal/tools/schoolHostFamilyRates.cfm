<!--- ------------------------------------------------------------------------- ----
	
	File:		schoolHostFamilyRates.cfm
	Author:		James Griffiths
	Date:		July 9, 2012
	Desc:		List schools and the rates that are paid to host families associated with that school

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfajaxproxy cfc="internal.extensions.components.school" jsclassname="SCHOOL">

	<cfscript>
		// The value to order the list by.
		param name="URL.order" default="schoolName";
		param name="FORM.submitted" default=0;
		
		// Gets all schools that are active and orders them based on what was selected on the page (the default is by schoolName).
		qGetSchools = APPLICATION.CFC.School.getSchools(order=URL.order,active=1);
	</cfscript>
    
    <cfif VAL(FORM.submitted)>
        <cfloop query="qGetSchools">
            <cfset value=FORM["val_#schoolID#"]>
            <cfquery name="qUpdateRates" datasource="#APPLICATION.DSN#">
                UPDATE
                    php_schools
                SET
                    hostFamilyRate = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(value,'9.99')#">
                WHERE
                    schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#schoolID#">
            </cfquery>
       </cfloop>
       <cflocation url="?curdoc=tools/schoolHostFamilyRates&order=#URL.order#">
 	</cfif>
    
</cfsilent>

<script type="text/javascript">
	
	/*var storeRates = function() {
		
		var s = new SCHOOL();
		var inputs = $(".value").get();
		var schoolID = "";
		var amount = "";
		
		$(".value").each(function(i) {
			schoolID = $(this).attr("id").substring(4);
			amount = $(this).val();
			s.updateHostFamilyRates(schoolID, amount);
		});
		
		window.location.reload();
	}*/
	
</script>

<cfoutput>

	<form name="schoolHostFamilyRates" id="schoolHostFamilyRates" method="post">
    	<input type="hidden" name="submitted" value="1" />

        <table width="98%" align="center" cellpadding="2" bgcolor="##e9ecf1" border=0 cellpadding=0 cellspacing=0>
            <tr>
                <th>&nbsp;</th>
            </tr>
            <tr>
                <th width="25%"></th>
                <th width="50%" style="font-size:14px;">School Host Family Rates<span style="font-size:12px;"> - #qGetSchools.recordCount# Schools</span></th>
                <th width="25%" align="center"><input type="image" src="pics/submit.gif" onClick="storeRates(); return false;" /></th>
            </tr>
            <tr>
                <th>&nbsp;</th>
            </tr>
        </table>
        
        <table width="98%" align="center" cellpadding="2" bgcolor="##e9ecf1" border=0 cellpadding=0 cellspacing=0>
                    
            <tr>
                <th background="images/back_menu2.gif" align="left" width="5%"><a href="?curdoc=tools/schoolHostFamilyRates&order=schoolID">ID</a></th>
                <th background="images/back_menu2.gif" align="left" width="20%"><a href="?curdoc=tools/schoolHostFamilyRates&order=schoolName">School Name</a></th>
                <th background="images/back_menu2.gif" align="left" width="15%"><a href="?curdoc=tools/schoolHostFamilyRates&order=address">Address</a></th>
                <th background="images/back_menu2.gif" align="left" width="10%"><a href="?curdoc=tools/schoolHostFamilyRates&order=city">City</a></th>
                <th background="images/back_menu2.gif" align="left" width="25%"><a href="?curdoc=tools/schoolHostFamilyRates&order=stateName">State</a></th>
                <th background="images/back_menu2.gif" align="center" width="25%">Monthly Rate</th>
            </tr>
            
            <cfloop query="qGetSchools">
            
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
                    <td class="style1"><a href="?curdoc=forms/view_school&sc=#schoolID#">#schoolID#</a></td>
                    <td class="style1"><a href="?curdoc=forms/view_school&sc=#schoolID#">#schoolName#</a></td>
                    <td class="style1">#address#</td>
                    <td class="style1">#city#</td>
                    <td class="style1">#stateName#</td>
                    <td class="style1" align="center"><input type="text" name="val_#schoolID#" id="val_#schoolID#" class="value" value="#hostFamilyRate#" style="height:15px; width:100px; text-align:right" /></td>
                </tr>
            
            </cfloop>
            
            <cfset lastRow = #qGetSchools.recordCount# + 1>
            
            <tr bgcolor="#iif(lastRow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
                <td class="style1" colspan="5"></td>
                <td class="style1" align="center"><input type="image" src="pics/submit.gif" onClick="storeRates(); return false;"/></td>
            </tr>
            
        </table>
        
  	</form>
    
</cfoutput>