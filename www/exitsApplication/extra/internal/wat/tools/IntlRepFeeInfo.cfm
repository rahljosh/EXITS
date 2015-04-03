<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
	<cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.count" default="0">
    
	<!--- FORM Submitted --->
    <cfif FORM.submitted>
    	
        <cfloop from="1" to="#FORM.count#" index="x">
            <cfquery datasource="#APPLICATION.DSN.Source#">
                 UPDATE 
                 	smg_users 
                 SET 
                 	extra_accepts_sevis_fee = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM[x & '_extra_accepts_sevis_fee']#" null="#NOT LEN(FORM[x & '_extra_accepts_sevis_fee'])#">,
                  	extra_insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM[x & '_extra_insurance_typeID']#">
                 WHERE 
                 	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM[x & '_userid']#">
                 LIMIT 1
            </cfquery>
        </cfloop>
    
    	<cfscript>
			// Set Page Message
			SESSION.pageMessages.Add("Form successfully submitted.");
		</cfscript>
    
    </cfif>

    <cfquery name="qGetIntlReps" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	u.userid, 
            u.businessname, 
            u.extra_accepts_sevis_fee,
            u.extra_insurance_typeID
        FROM 
        	smg_users u
        INNER JOIN 
        	extra_candidates extra ON u.userid = extra.intrep
        WHERE 
        	u.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND 
        	extra.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        GROUP BY 
        	userid
        ORDER BY 
        	businessname	
    </cfquery>

    <cfquery name="qGetInsuranceTypes" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	insutypeid, type
        FROM 
        	smg_insurance_type
        WHERE 
        	insutypeid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,6,14" list="yes"> )
    </cfquery>

</cfsilent>

<cfoutput>

<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data">
	<input type="hidden" name="count" value="#qGetIntlReps.recordcount#">
	<input type="hidden" name="submitted" value="1">

	<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
        <tr>
            <td>
            
                <!----Header Table---->
                <table width="95%" cellpadding="0" cellspacing="0" border="0" align="center" height="25">
                    <tr bgcolor="##E4E4E4">
                        <td class="title1">&nbsp; &nbsp; International Representative Fee Information</td>
                    </tr>
                </table>
                
                <br>
    
                <table width="95%" border="0" cellpadding="3" cellspacing="0" align="center" bordercolor="##C7CFDC">	
                    <tr>
                        <td colspan="6" class="style1">
                            <!--- Page Messages --->
                            <gui:displayPageMessages 
                                pageMessages="#SESSION.pageMessages.GetCollection()#"
                                messageType="section"
                                />
    
                            Ps: Changes on this page will affect all EXTRA systems (H2B, TRAINEE AND W&amp;T)
                        </td>
                    </tr>
                    <tr bgcolor="##4F8EA4">
                        <td class="style2">International Representative</td>
                        <td class="style2">Accepts Sevis Fee</td>
                        <td class="style2">Insurance Policy Type</td>
                        <td class="style2">WAT Full Placement</td>
                        <td class="style2">WAT Self Placement</td>
                        <td class="style2">WAT Walk-In</td>
                    </tr>
                    <cfloop query="qGetIntlReps">
                        <input type="hidden" name="#qGetIntlReps.currentrow#_userid" value="#userid#">                
                        <tr  bgcolor="###iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("FFFFFF") )#">
                            <td class="style1">#qGetIntlReps.businessname#</td>
                            <td class="style1">
                                <select name="#qGetIntlReps.currentrow#_extra_accepts_sevis_fee" class="style1">
                                    <option value=""></option>
                                    <option value="0" <cfif qGetIntlReps.extra_accepts_sevis_fee EQ 0>selected</cfif> >No</option>
                                    <option value="1" <cfif qGetIntlReps.extra_accepts_sevis_fee EQ 1>selected</cfif> >Yes</option>
                                </select>	
                            </td>
                            <td class="style1">
                                <select name="#qGetIntlReps.currentrow#_extra_insurance_typeID" class="style1">
                                    <option value="0"></option>
                                    <cfloop query="qGetInsuranceTypes">
                                        <option value="#insutypeid#" <cfif qGetIntlReps.extra_insurance_typeID EQ qGetInsuranceTypes.insutypeid>selected</cfif>>#type#</option>
                                    </cfloop>
                                </select>	
                            </td>
                            <td class="style1"></td>
                            <td class="style1"></td>
                            <td class="style1"></td>
                        </tr>
                    </cfloop>
                    <tr bgcolor="##4F8EA4">
                        <td colspan="6" align="center"><input type="image" name="next" value=" Update " src="../pics/update.gif" align="middle"></td>
                    </tr>
                </table>
                
                <br>
                
            </td>
        </tr>
    </table>

</form>

</cfoutput>

</body>
</html>