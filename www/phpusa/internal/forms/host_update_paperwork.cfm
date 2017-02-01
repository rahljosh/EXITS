<!--- ------------------------------------------------------------------------- ----
	
	File:		host_update_paperwork.cfc
	Author:		James Griffiths
	Date:		January 22, 2013
	Desc:		This shows and allows the update of host paperwork records.
	
----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfparam name="FORM.submitted" default="0">
    
    <cfinclude template="../querys/family_info.cfm">
    
    <!--- Form submitted --->
    <cfif VAL(FORM.submitted)>
    	<!--- Update paperwork --->
        <cfquery datasource="#APPLICATION.DSN#">
        	UPDATE smg_hosts
            SET php_orientationSignOff = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.orientationSignOff#">,
            father_W9 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.father_W9#">,
            mother_W9 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.mother_W9#">
            where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostid#">
        </cfquery>
        
        <!--- redirect back to the overview page --->
        <cflocation url="/internal/index.cfm?curdoc=host_fam_info&hostID=#family_info.hostID#" addtoken="no">
    </cfif>
    
</cfsilent>

<cfoutput>
	<form id="paperworkForm" action="#cgi.script_name#?#cgi.query_string#" method="post">
    	<input type="hidden" name="submitted" value="1"/>
        <input type ="hidden" name="hostid" value="#family_info.hostid#" />
    	<h2>
        	&nbsp;&nbsp;&nbsp;&nbsp;P a p e r w o r k
            <font size=-2>[<a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a>]</font>
      	</h2>
        <table width="40%" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C2D1EF" bgcolor="##FFFFFF" class="section">
        	<tr>
            	<!--- HOST FAMILY PAPERWORK --->
                <td width="100%" align="right" valign="top" class="box">
                    <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" bgcolor="##DFDFDF">
                        <tr valign=middle bgcolor="##C2D1EF" height=24>
                            <td><b><font size="+1">&nbsp; Paperwork</font></b></td>
                        </tr>
                    </table>
                    <table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##ffffff">
                        <tr>
                            <td align="left">Orientation Sign-off</td>
                            <td align="right"><input name="orientationSignOff" type="text" class="datePicker" value="#DateFormat(family_info.php_orientationSignOff,'mm/dd/yyyy')#" /></td>
                        </tr>
                      
                        <tr>
                            <td align="left">Father W-9</td>
                            <td align="right"><input name="father_W9" type="text" class="datePicker" value="#DateFormat(family_info.father_W9,'mm/dd/yyyy')#" /></td>
                        </tr>
                     
                        <tr>
                            <td align="left">Mother W-9</td>
                            <td align="right"><input name="mother_W9" type="text" class="datePicker" value="#DateFormat(family_info.mother_W9,'mm/dd/yyyy')#" /></td>
                        </tr>
                        <tr>
                            <td colspan="5" align="center"><input type="submit" value="Submit" /></td>
                        </tr>
                    </table>
                </td>
           	</tr>
        </table>
    </form>
</cfoutput>

<br />