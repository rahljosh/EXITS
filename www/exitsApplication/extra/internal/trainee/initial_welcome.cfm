<!--- ------------------------------------------------------------------------- ----
	
	File:		initial_welcome.cfm
	Author:		Marcus Melo
	Date:		August 24, 2010
	Desc:		Initial Welcome page that includes news, students and host companies.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfquery name="qNewsMessages" datasource="mysql">
        SELECT
        	*
        FROM
       		smg_news_messages
        WHERE
        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="news">
        AND
        	expires > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        AND
        	startdate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        AND 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
    </cfquery>

    <cfquery name="qNewCandidates" datasource="mysql">
        SELECT 
        	ec.firstname, 
            ec.lastname, 
            ec.residence_country, 
            ec.uniqueid,
        	cl.countryname
        FROM 
        	extra_candidates ec
        LEFT JOIN 
        	smg_countrylist cl ON cl.countryid = ec.residence_country 
        WHERE 
        	ec.entrydate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CLIENT.lastlogin#">
        AND  
        	ec.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        <cfif VAL(CLIENT.usertype) LTE 4>
            AND
                ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
        <cfelseif CLIENT.userType EQ 8>
            AND
                ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
        <cfelseif CLIENT.userType EQ 11>
            AND
                ec.branchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
		</cfif>
    </cfquery>
   
    <cfquery name="qNewHostCompanies" datasource="mysql">
        SELECT 
        	ehc.hostcompanyid, 
            ehc.name, 
            ehc.city, 
            ehc.state, 
            ehc.homepage, 
            s.statename
        FROM 
        	extra_hostcompany ehc
        LEFT JOIN 
        	smg_states s ON s.id = ehc.state 
        WHERE 
        	ehc.entrydate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CLIENT.lastlogin#">
    </cfquery>
    
</cfsilent>

<cfoutput>

<table  bgcolor="##FFFFFF" bordercolor="##CCCCCC" border="1" height="100%" width="100%">
    <tr bordercolor="##FFFFFF">
        <td>
        
            <table cellSpacing="0" cellPadding="0" align="center" class="regContainer" width="700">
                <tr>
                    <td width="10">&nbsp;</td>
                    <td>
            
                        <!-- Error Message / Validation Summary -->
						<cfif VAL(qUpdateMessages.recordcount)>
    	                    <div id="divInvalidFormMsg" style="DISPLAY: inline">
            
                                <!-- Error Message -->
                                <table cellSpacing="0" cellPadding="0" width="100%" border="0" class="style1">
                                    <tr>
                                        <td width="6"><img height="6" src="../pics/table-borders/red-err-lefttopcorner.gif" width="6"></td>
                                        <td bgColor="##bb0000" height="6"><img height="6" src="spacer.gif" width="1"></td>
                                        <td width="6"><img height="6" src="../pics/table-borders/red-err-righttopcorner.gif" width="6"></td>
                                    </tr>
                                    <tr>
                                        <td class="errMessageGradientStyle" bgColor="##bb0000"><img height=45 src="spacer.gif" width="1"></td>
                                   		<td class="errMessageGradientStyle" bgColor="##bb0000">
            
                                            <table cellSpacing="0" cellPadding="10" width="100%" border="0">
                                                <tr>
                                                    <td vAlign="middle" align="center"><img src="../pics/error-exclamate.gif" ></td>
                                                    <td vAlign="middle" align="left">
                                                    	<font color="white"><strong><span class=upper>ALERT!&nbsp;&nbsp; ALARM!&nbsp;&nbsp;  Alarma!&nbsp;&nbsp;  Alerte!&nbsp;&nbsp;  Allarme!&nbsp;&nbsp;  Alerta!</span> </strong><br>
                                                        <cfloop query="qAlertMessages">
                                                            <strong><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#qAlertMessages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="##ffffff">#message#</font></a></strong><br>
                                                        </cfloop></font><br>
                                                    </td>
                                                </tr>
                                            </table>
            
                                        </td>
							            <td class="errMessageGradientStyle" bgColor="##bb0000"><img height=45 src="spacer.gif" width="1" ></td>
						            </tr>
                                    <tr>
                                        <td><img height="6" src="../pics/table-borders/red-err-leftbottcorner.gif" width="6"></td>
                                        <td bgColor="##bb0000"><img height="6" src="spacer.gif" width="1" ></td>
                                        <td><img height="6" src="../pics/table-borders/red-err-rightbottomcorner.gif" width="6"></td>
                                    </tr>
                                </table>
							
                            </div>
                            
						</cfif>
                        <!-- End error message end -->						
            
                    </td>
                    <td width="10">&nbsp;</td>
                </tr>
                <tr borderColor="##d3d3d3">
                    <td width="10">&nbsp;</td>
                    <td>
            
						<!---- Outer Table (outline and title ---->
                        <table cellspacing="0" cellpadding="3" width="100%" border="0" class="style1">
                            <tr>
                                <td class="groupTopLeft">&nbsp;</td>
                                <td class="groupCaption" nowrap="true"><strong>News & Announcements</strong></td>
                                <td class="groupTop" width="95%">&nbsp;</td><td class="groupTopRight">&nbsp;</td>
                            </tr>
                            <tr>					
                                <td class="groupLeft">&nbsp;</td>
                                <td colspan="2">
                        
                                    <table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%" class="style1">
                                        <tr>
                                            <td>
                        
												<!----Table with Info in It---->
                                                <table cellSpacing="0" cellPadding="0" width="100%" border="0" class="style1">
                                                    <tbody>
                                                        <tr>
                                                            <td valign="center">
            
																<!----News & Announcements---->
                                                                <table border=0 width="1"00%>
                                                                    <tr>
                                                                        <td valign="top" class="style1">
																			<cfif NOT VAL(qNewsMessages.recordcount)>
                                                                                <strong>#DateFormat(now(), 'mmm. d, yyyy')#</strong><br>
                                                                                There are currently no announcements or news items.
                                                                            <cfelse>
                                                                                <cfloop query="qNewsMessages">
                                                                                    <strong>#message#</strong><br>
                                                                                    #DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#
                                                                                </cfloop>
                                                                            </cfif>
                                                                        </td>
                                                                        <td align="right">
                                                                            <div align="right"><img src="../pics/tower.gif" width="31" height="51"></div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
            
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
            
                                            </td>
                                        </tr>
                                    </table>
            
                                </td>
                                <td class="groupRight">&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="groupBottomLeft"><img height=5 src='spacer.gif' width="1" ></td>
                                <td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width="1" ></td>
                                <td class="groupBottomRight"><img height=1 src='spacer.gif' width="1" ></td>
                            </tr>
                            
            				<tr>
                                <td>&nbsp;</td>
                           </tr>
                        </table> 
            
						<!---- Outer Table (outline and title ---->
                        <table cellspacing="0" cellpadding="3" width="100%" border="0" class="style1">
                            <tr>
                                <td class="groupTopLeft">&nbsp;</td>
                                <td class="groupCaption" nowrap="true"><strong>New Students</strong></td>
                                <td class="groupTop" width="95%">&nbsp;</td>
                                <td class="groupTopRight">&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="groupLeft">&nbsp;</td>
                                <td colspan="2">
                                
                                    <table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
                                        <tr>
                                            <td>
            
												<!----Table with Info in It---->
                                                <table cellSpacing="0" cellPadding="0" width="100%" border="0" class="style1">
                                                    <tbody>
                                                        <tr>
                                                            <td valign="center">
																<!----New Students---->
                                                                
                                                                <cfif NOT VAL(qNewCandidates.recordcount)>
                                                                    No new students have been added.
                                                                <cfelse>
                                                                    <Cfloop query="qNewCandidates">
                                                                        <a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#">#firstname# #lastname#</a> of #countryname#<br>
                                                                    </Cfloop>
                                                                </cfif>
                                                            
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
            
                                            </td>
                                        </tr>
                                    </table>
            
                                </td>
                                <td class="groupRight">&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="groupBottomLeft"><img height=5 src='spacer.gif' width="1" ></td>
                                <td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width="1" ></td>
                                <td class="groupBottomRight"><img height=1 src='spacer.gif' width="1" ></td>
                            </tr>
                            
                            <tr>
                                <td colspan="4">
            
                                    <br />
                                    
                                    <!---- Outer Table (outline and title ---->
                                    <table cellspacing="0" cellpadding="3" width="100%" border="0" class="style1">
                                        <tr>
                                            <td class="groupTopLeft">&nbsp;</td>
                                            <td class="groupCaption" nowrap="true"><strong>New Host Companies</strong></td>
                                            <td class="groupTop" width="95%">&nbsp;</td>
                                            <td class="groupTopRight">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="groupLeft">&nbsp;</td>
                                            <td colspan="2">
                                                
                                                <table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
                                                    <tr>
                                                        <td>
                                                
															<!----Table with Info in It---->
                                                            <table cellSpacing="0" cellPadding="0" width="100%" border="0" class="style1">
                                                                <tbody>
                                                                    <tr>
                                                                        <td valign="center">
                                                                        
																			<!----New HOST COMPANIES ---->
																			<cfif NOT VAL(qNewHostCompanies.recordcount)>
                                                                                No new host companies have been added.
                                                                            <cfelse>
                                                                                <Cfloop query="qNewHostCompanies">
                                                                                    <A href="?curdoc=hostcompany/hostCompanyInfo&hostcompanyid=#hostcompanyid#">#name# in  #city#, #statename#</A> <cfif homepage is not ''>:: <a href="#homepage#">homepage</a></cfif><br>
                                                                                </Cfloop>
                                                                            </cfif>
                                                                        
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
            
                                                        </td>
                                                    </tr>
                                                </table>
            
                                            </td>
                                            <td class="groupRight">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="groupBottomLeft"><img height=5 src='spacer.gif' width="1" ></td>
                                            <td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width="1" ></td>
                                            <td class="groupBottomRight"><img height=1 src='spacer.gif' width="1" ></td>
                                        </tr>
                                    </table> 
            
                                </td>
                            </tr>
                       </table>
            
			            <br />
            
		            </td>
        	    </tr>
            </table>
            
            <!------******************************************************---->
            
            <cfif VAL(qUpdateMessages.recordcount)>
            
                <table width=93% border="1" align="center" cellpadding="4" cellspacing="4" bgcolor="##009966" class="style1">
                    <tr>
                        <td bordercolor="##009966">
                        	<strong><u><font color="##ffffff">System Updates:</u></font></strong><br>
                            <cfloop query="qUpdateMessages">
                                <strong><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#qUpdateMessages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="##ffffff">#message#</font></strong><br>
                            </cfloop>
                        </td>
                    </tr>
                </table>
            
            </cfif>
            
            <cfif VAL(qAlertMessages.recordcount)>
            
                <table width=93% border="1" align="center" cellpadding="4" cellspacing="4" bgcolor="##CC3300" class="style1">
                    <tr>
                        <td bordercolor="##CC3300">
                            <strong><u><font color="##ffffff">Alerts:</u></font></strong><br>
                            <cfloop query="qAlertMessages">
                                <strong><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#qAlertMessages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="##ffffff">#message#</font></a></strong><br>
                            </cfloop>
                        </td>
                    </tr>
                </table>
            
            </cfif>
        
        </td>
    </tr>
</table>

</cfoutput>