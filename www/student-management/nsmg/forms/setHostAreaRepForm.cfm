<!--- ------------------------------------------------------------------------- ----
	
	File:		setHostAreaRepForm.cfm
	Author:		James Griffiths
	Date:		February 15, 2013
	Desc:		Form to update the host family area rep to a valid area rep in the region.

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfparam name="URL.hostID" default="0">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.areaRep" default="0">

	<cfscript>
		qGetHostInfo = APPLICATION.CFC.HOST.getHosts(
			hostID = URL.hostID												
		);
        qGetValidAreaReps = APPLICATION.CFC.USER.getUsers(
            userType = 7,
            isActive = 1,
            companyID = qGetHostInfo.companyID,
            regionID = qGetHostInfo.regionID
        );
    </cfscript>
    
    <!--- Process Form Submission --->
	<cfif VAL(FORM.submitted)>
    
    	<cfquery datasource="#APPLICATION.DSN#">
        	UPDATE smg_hosts
            SET areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.areaRep)#">
            WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
        </cfquery>
    
    	<cflocation url="index.cfm?curdoc=host_fam_info&hostid=#URL.hostid#" addtoken="No">
        
    </cfif>
    
</cfsilent>

<cfoutput>
	<!--- this table is so the form is not 100% width. --->
    <table align="center">
        <tr>
            <td>
        
                <!--- header of the table --->
                <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                    <tr valign=middle height=24>
                        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                        <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Host Area Representative</h2></td>
                        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                
                <cfform action="?curdoc=forms/setHostAreaRepForm&hostID=#URL.hostID#" method="post">
                    <input type="hidden" name="submitted" value="1" />
                    <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
                        <tr>
                            <td width="20%" align="right">
                            	<select name="areaRep">
                                	<cfloop query="qGetValidAreaReps">
                                    	<option value="#userID#" <cfif userID EQ qGetHostInfo.areaRepID>selected="selected"</cfif>>#firstName# #lastName# (###userID#)</option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td align="center"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
                        </tr>
                    </table>
                </cfform>
                
                <table width=100% cellpadding=0 cellspacing=0 border=0>
                    <tr valign=bottom >
                        <td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
                        <td width=100% background="pics/header_background_footer.gif"></td>
                        <td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
                    </tr>
                </table>
        
            </td>
        </tr>
    </table>
</cfoutput>