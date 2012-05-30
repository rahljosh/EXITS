<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>AR Paperwork</title>
<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	


<SCRIPT LANGUAGE="JavaScript">
function displayAddPaperwork() {
		if($("#AddPaperwork").css("display") == "none"){
			$("#AddPaperwork").slideDown("slow");
		} else {
			$("#AddPaperwork").slideUp("slow");	
		}
	}		
	displayAddPaperwork
//  End -->
</script>
<style type="text/css">
.thinBlueBorder {
	border: thin solid #efefef;
}
</style>
<cfoutput>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
function CheckDates(ckname, frname) {
	if (document.form.elements[ckname].checked) {
		document.form.elements[frname].value = "#DateFormat(now(), 'mm/dd/yyyy')#";
		}
	else { 
		document.form.elements[frname].value = '';  
	}
}
</script>

<script type="text/javascript">
		function zp(n){
		return n<10?("0"+n):n;
		}
		function insertDate(t,format){
		var now=new Date();
		var DD=zp(now.getDate());
		var MM=zp(now.getMonth()+1);
		var YYYY=now.getFullYear();
		var YY=zp(now.getFullYear()%100);
		format=format.replace(/DD/,DD);
		format=format.replace(/MM/,MM);
		format=format.replace(/YYYY/,YYYY);
		format=format.replace(/YY/,YY);
		t.value=format;
		}
		</script>
</cfoutput>
<script src="../linked/js/jquery.placeholder.js"></script>
</head>

<body>



<cfif NOT IsDefined('url.userid')>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
			<td background="pics/header_background.gif"><h2>Area Representative Paperwork</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table border=0 cellpadding=4 cellspacing=0 width="100%" class="section">
		<tr><td align="center">An error has occurred. Please try again.</td></tr>
		<tr><td align="center"><a href=""><img src="pics/back.gif" border="0"></a></td></tr>			
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>


<!--- CHECK RIGHTS --->
<cfinclude template="../check_rights.cfm">

<cfquery name="get_rep" datasource="MySQL">
	SELECT userid, firstname, lastname, active, accountCreationVerified
	FROM smg_users
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer" maxlength="6">
</cfquery>

		<Cfscript>
            //Check if paperwork is complete for season
			get_paperwork = APPLICATION.CFC.udf.allpaperworkCompleted(userid=url.userid);
			// Get User CBC
		qGetCBCUser = APPCFC.CBC.getCBCUserByID(userID=url.userid,cbcType='user');
		</cfscript>
 <cfquery name="currentSeasonStatus" dbtype="query">
 select *
 from get_paperwork 
 where seasonid = 9
 </cfquery>

<cfquery name="used_seasons" datasource="MySQL">
	SELECT p.seasonid
	FROM smg_users_paperwork p
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer" maxlength="6">
    <cfif client.companyid eq 10>
    and fk_companyid = 10
    </cfif>
	GROUP BY p.seasonid
</cfquery>
<cfset season_list = ValueList(used_seasons.seasonid)>

<cfquery name="get_seasons" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
	WHERE active = '1'
	<!--- REMAINING SEASONS --->
	<cfif get_paperwork.recordcount>		
		AND ( <cfloop list="#season_list#" index="season">
			 seasonid != '#season#'
			 <cfif season NEQ #ListLast(season_list)#>AND</cfif>
		  </cfloop> )
	</cfif>
	ORDER BY season
</cfquery>

    <cfquery name="user_compliance" datasource="#application.dsn#">
        SELECT 
        	userid, 
            compliance
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    </cfquery>

<Cfquery name="region_company_access" datasource="MySQL">
	SELECT uar.companyid, uar.regionid, uar.usertype, uar.id, uar.advisorid,
		   r.regionname,
		   c.companyshort,
		   ut.usertype as usertypename, ut.usertypeid,
		   adv.firstname, adv.lastname
	FROM user_access_rights uar
	INNER JOIN smg_regions r ON r.regionid = uar.regionid
	INNER JOIN smg_companies c ON c.companyid = uar.companyid
	INNER JOIN smg_usertype ut ON ut.usertypeid = uar.usertype
	LEFT JOIN smg_users adv ON adv.userid = uar.advisorid
	WHERE uar.userid = '#url.userid#'
	ORDER BY r.regionname
</Cfquery>
<cfoutput>
 <!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />
 
 <div class="rdholder"> 
				<div class="rdtop"> 
                <span class="rdtitle">Paperwork & Account Access</span> 
            </div> <!-- end top --> 
             <div class="rdbox">

<!----Header Format Table---->


<div class="thinBlueBorder">
<table border=0 cellpadding=8 cellspacing=0 width="100%" >

	<tr>
		<td valign="top"><h2>User</h2>#get_rep.firstname# #get_rep.lastname# (###get_rep.userid#)</td>
        <td valign="top"><h2>Current Paperwork Status</h2>
        Area Rep: <cfif currentSeasonStatus.arearepok eq 1>Looks good<cfelse>Something is missing</cfif><br />
        2nd Visit: <cfif currentSeasonStatus.secondVisitRepOK eq 1>Looks good<cfelse>Something is missing</cfif>
         </td>
        <td valign="top"><h2>Current Account Status</h2>
        Active: <cfif get_rep.active eq 1>Yes<cfelse>No</cfif><br />
        Fully Enabled: <cfif val(get_rep.accountCreationVerified)>Yes<cfelse>No</cfif>
         
        </td>
        <td width=150><a href="index.cfm?curdoc=user_info&userid=#url.userid#"><img src="pics/buttons/userProfile.png" border="0" height=40></a></td> 
        <Td width=90>
       
          <cfif get_seasons.recordcount gt 0 and client.usertype lte 4>
        		<div align="Center"><strong><a href="javascript:displayAddPaperwork();"><img src="pics/buttons/season.png" border="0" height=40></a></strong></div>
   			</cfif>
            
        </Td>
    </tr>
    <tr>
	</tr>
</table>
</div>
<br /><br />
    <!----Records---->
            <!--- NEW SEASON PAPERWORK --->
        <cfif client.usertype LTE 4>
 
        <div id="AddPaperwork"  style="display:none;"  >
   
<cfform name="form" action="?curdoc=forms/user_paperwork_qr"method="post">
<cfinput type="hidden" name="userid" value="#userid#">
<cfinput type="hidden" name="count" value="#get_paperwork.recordcount#">
<cfinput type="hidden" name="submittedUserType" value="#region_company_access.usertype#">
<cfinput type="hidden" name="addNewSeason">  

    <table cellpadding="0" cellspacing=0 border="0" width="100%" >
    <tr>
        <td></td>
        <td colspan=4 bgcolor="##fef3b9" align="Center">Area Rep Only</td>
        <Td colspan=3 bgcolor="##c1cfea" align="Center">Area Rep & 2nd Visit</Td>
        <td></td>
        
        
    </tr>		
    <tr bgcolor="000000" >
            <td align="left"><font color="FFFFFF">Season</td>
            
            <td align="center"><font color="FFFFFF">Agreement</td>
            <td align="center"><font color="FFFFFF">Ref. Questionnaire ##1</td>
            <td align="center"><font color="FFFFFF">Ref. Questionnaire ##2</td>
            <td align="center"><font color="FFFFFF">AR Training </td>
            <td align="center"><font color="FFFFFF">CBC Authorization </td>
            <td align="center"><font color="FFFFFF">CBC Approved</td>
            <td align="center"><font color="FFFFFF">Info Sheet</td>
            <Td></Td>
            
    </tr>
    	 <tr>
            <td>
                <cfselect name="seasonid" required="yes" message="You must select a season">
                    <option value="0">Contract AYP</option>
                    <cfloop query="get_seasons">
                    <option value="#seasonid#">#season#</option>
                    </cfloop>
                </cfselect>				
            </td>
           
            <td align="Center">
                <cfinput type="Text" name="ar_agreement" value="" placeholder="Required" class="datePicker" onfocus="insertDate(this,'MM/DD/YYYY')" validate="date" maxlength="10">
           </td>
            <td align="Center">
                <cfinput type="Text" name="ar_ref_quest1" value=""  placeholder="Required" class="datePicker" onfocus="insertDate(this,'MM/DD/YYYY')" validate="date" maxlength="10">
            </td>
            <td align="Center">
                <cfinput type="Text" name="ar_ref_quest2" value=""  placeholder="Required" class="datePicker" onfocus="insertDate(this,'MM/DD/YYYY')" validate="date" maxlength="10">
            </td>
            <td align="Center">
                <cfinput type="Text" name="ar_training" value="" class="datePicker" onfocus="insertDate(this,'MM/DD/YYYY')" validate="date" maxlength="10">
            </td>
            <td align="Center">
                <cfinput type="Text" name="ar_cbc_auth_form" value="" placeholder="Required" class="datePicker" onfocus="insertDate(this,'MM/DD/YYYY')" validate="date" maxlength="10">			
            </td>
            <td align="Center">
           			 <!----this is approved on the CBC screen---->
           			 Not Applicable
                <!----<cfinput type="Text" name="ar_cbcAuthReview" value="" placeholder="Required" class="datePicker" onfocus="insertDate(this,'MM/DD/YYYY')" validate="date" maxlength="10">---->	
            </td>
             <td align="Center">
                <cfinput type="Text" name="ar_info_sheet" value="" placeholder="Required" class="datePicker" onfocus="insertDate(this,'MM/DD/YYYY')" validate="date" maxlength="10">
            </td>
            <Td align="Center">
            	<input type="image" src="pics/buttons/update_44.png" />
            </Td>
        </tr>		
            
      
        </table>
        </cfform>
          </cfif>
        <br /><br />
          </div>
<cfform name="form" action="?curdoc=forms/user_paperwork_qr"method="post">
<cfinput type="hidden" name="userid" value="#userid#">
<cfinput type="hidden" name="count" value="#get_paperwork.recordcount#">
<cfinput type="hidden" name="submittedUserType" value="#region_company_access.usertype#">
<cfinput type="hidden" name="updatePaperwork">
	<table cellpadding="0" cellspacing=0 border="0" width="100%" >
    <tr>
        <td></td>
        <td colspan=4 bgcolor="##fef3b9" align="Center">Area Rep Only</td>
         <Td colspan=3  align="Center" bgcolor="##c1cfea">Area Rep & 2nd Visit</Td>
         <td></td>
        
        
    </tr>		
    <tr bgcolor="000000" >
            <td align="center"><font color="FFFFFF">Season</td>
            
            <td align="center"><font color="FFFFFF">Agreement</td>
            <td align="center"><font color="FFFFFF">Ref. Questionnaire ##1</td>
            <td align="center"><font color="FFFFFF">Ref. Questionnaire ##2</td>
            <td align="center"><font color="FFFFFF">AR Training </td>
            <td align="center"><font color="FFFFFF">CBC Authorization </td>
            <td align="center"><font color="FFFFFF">CBC Approved</td>
            <td align="center"><font color="FFFFFF">Info Sheet</td>
            <td></td>
            <td></td>
            
            
    </tr>
    
        <cfif get_paperwork.recordcount eq 0>
        <tr>
            <td colspan=9 align="center">No paperwork has been recorded.</td>
        </tr>
    <Cfelse>
    	
    	<cfloop query="get_paperwork">
       
        <!----Get the CBC link for each season---->
        <cfquery dbtype="query" name="currentSeasonCBCInfo">
        select userID, cbcID, batchID, flagCBC, denied
        from qGetCBCUser
        where seasonid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#seasonID#">
        </cfquery>
         
        <cfinput type="hidden" name="paperworkid_#currentrow#" value="#paperworkid#">
        <tr <Cfif currentrow mod 2> bgcolor="##eae8e8"</cfif>>
        	<td><strong>#season#</strong></td>
 			
            <td align="Center">
            <Cfif usertype lte 4>
                <input type="Text" name="ar_agreement_#currentrow#" placeholder="Required" value="#DateFormat(ar_agreement, 'mm/dd/yyyy')#" class="datePicker" <cfif ar_agreement is ''>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif>>
            <cfelse>
            #DateFormat(ar_agreement, 'mm/dd/yyyy')#
            </Cfif>
           </td>
            <td align="Center">
            <Cfif usertype lte 4>
                <input type="Text" name="ar_ref_quest1_#currentrow#" placeholder="Required" value="#DateFormat(ar_ref_quest1, 'mm/dd/yyyy')#" class="datePicker" <cfif ar_ref_quest1 is ''>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif>>
            <cfelse>
            #DateFormat(ar_ref_quest1, 'mm/dd/yyyy')#
            </Cfif>
            </td>
            <td align="Center">
            <Cfif usertype lte 4>
                <input type="Text" name="ar_ref_quest2_#currentrow#" placeholder="Required" value="#DateFormat(ar_ref_quest2, 'mm/dd/yyyy')#" class="datePicker" <cfif ar_ref_quest2 is ''>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif>>
             <cfelse>
             #DateFormat(ar_ref_quest2, 'mm/dd/yyyy')#
             </Cfif>
            </td>
            <td align="Center">
            <Cfif usertype lte 4>
                <input type="Text" name="ar_training_#currentrow#"  value="#DateFormat(ar_training, 'mm/dd/yyyy')#" class="datePicker" <cfif ar_training is ''>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif>>
            <cfelse>
            #DateFormat(ar_training, 'mm/dd/yyyy')#
            </Cfif>
            </td>
            <td align="Center">
            <Cfif usertype lte 4>
                <input type="Text" name="ar_cbc_auth_form_#currentrow#" placeholder="Required" value="#DateFormat(ar_cbc_auth_form, 'mm/dd/yyyy')#" class="datePicker" <cfif ar_cbc_auth_form is ''>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif>>		
            <cfelse>
            #DateFormat(ar_cbc_auth_form, 'mm/dd/yyyy')#
            </Cfif>	
            </td>
            <td align="Center">
            
                
                    <Cfif currentSeasonCBCInfo.cbcID is''>
                    	<cfif client.usertype lte 4>
                        	<a href="index.cfm?curdoc=cbc/users_cbc&userid=#url.userid#&return=paperwork"></cfif>CBC hasn't run
                        <cfelse>
                    	<cfif client.usertype lte 4>
                        	<a href="javascript:openPopUp('cbc/displayCBC.cfm?view=approve&userID=#currentSeasonCBCInfo.userID#&cbcID=#currentSeasonCBCInfo.cbcID#&file=batch_#currentSeasonCBCInfo.batchID#_user_#currentSeasonCBCInfo.userID#_rec.xml', 750, 775);"></cfif>
						
                         <cfif currentSeasonCBCInfo.flagcbc eq 1>
                         	<img src="pics/buttons/warning.png" height=15 width=15 /> Flagged
                         <cfelseif currentSeasonCBCInfo.denied is not ''>
                         	<img src="pics/buttons/denied.png" height=15 width=15 /> Denied &nbsp;
                         <cfelseif get_paperwork.ar_cbcAuthReview is not '' >
                         	#DateFormat(get_paperwork.ar_cbcAuthReview, 'mm/dd/yyyy')#
                         <cfelse>
                            Required
                         </cfif>
                      <cfif client.usertype lte 4></a></cfif>
                      </cfif>
            </td>
           <td align="Center">
           <Cfif client.usertype lte 3>
                <input type="Text" name="ar_info_sheet_#currentrow#" placeholder="Required" value="#DateFormat(ar_info_sheet, 'mm/dd/yyyy')#" class="datePicker" <cfif ar_info_sheet is ''>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif>>
           <cfelse>
           #DateFormat(ar_info_sheet, 'mm/dd/yyyy')#
           </Cfif>
            </td>
            <td><cfif client.usertype lte 4><input type="image" src="pics/x.png" height=10 name="deleteSeason" value="#seasonid#"></cfif></td>
        </tr>
        </cfloop>
        <cfif client.usertype lte 4>
        <tr>
        	<td colspan=9 align="Center"><input type="image" src="pics/buttons/update_44.png" /></td>
    	</tr>
        </cfif>
    </cfif>
    </table>
    

  </cfform>
  </cfoutput>

     <!----footer of table---->
    
    </div>
     <div class="rdbottom"></div> <!-- end bottom --> 
    
     </div>
         
</body>
</html>
