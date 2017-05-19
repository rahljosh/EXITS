<!--- ------------------------------------------------------------------------- ----
	
	File:		host_fam_export.cfm
	Author:		Bruno Lopes
	Date:		May 8, 2017
	Desc:		EXITS Host Family Export Feature

	Updated:	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<cfscript>
		// Param FORM Variables
		param name="FORM.pageNumber" type="numeric" default='1';	
    param name="FORM.regionid" type="numeric" default='0';  
    param name="FORM.keyword" type="string" default='';  
    param name="FORM.active_rep" type="string" default='';  
    param name="FORM.hosting" type="string" default='';  
    param name="FORM.active" type="string" default='';  
    param name="FORM.available_to_host" type="string" default='';  
    param name="FORM.area_rep" type="string" default='';  
    param name="FORM.vHostIDList" type="string" default='';  
    param name="FORM.HFstatus" type="string" default='';  
    param name="FORM.school_id" type="string" default='';  
    param name="FORM.type" type="string" default='';  
    param name="FORM.sortBy" type="string" default='';  
    param name="FORM.sortOrder" type="string" default='';  
    param name="FORM.pageSize" type="numeric" default='10000';  
		
		// Get History
		getHostExport = APPLICATION.CFC.HOST.getHostsRemote(pageNumber = FORM.pageNumber, regionid = FORM.regionid, keyword = FORM.keyword,  active_rep = FORM.active_rep, hosting = FORM.hosting, active = FORM.active,cavailable_to_host = FORM.available_to_host, area_rep = FORM.area_rep, vHostIDList = FORM.vHostIDList, HFstatus = FORM.HFstatus, school_id = FORM.school_id, type = FORM.type,csortBy = FORM.sortBy, sortOrder = FORM.sortOrder, pageSize = FORM.pageSize
      );
	</cfscript>
    
</cfsilent>

<cfoutput>

    
		<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
        <cfsetting enablecfoutputonly="Yes">
        
        <!--- set content type --->
        <cfcontent type="application/msexcel">
        
        <!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
        <cfheader name="Content-Disposition" value="attachment; filename=HostFamilyList.xls">
        
        <!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
		The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
        <cfoutput>    

            <table border="1" style="font-family:Verdana, Geneva, sans-serif; font-size:9pt;">
                <tr>
                    <td colspan="13" style="font-size:16pt; font-weight:bold; text-align:center; border:none;">
                        Host Family Export  
                    </td>
                </tr>
                <tr>
                    <td style="width:50px; text-align:left; font-weight:bold;">ID</td>
                    <td style="width:50px; text-align:left; font-weight:bold;">NX ID</td>
                    <td style="width:75px; text-align:left; font-weight:bold;">Last Name</td>
                    <td style="width:75px; text-align:left; font-weight:bold;">Father</td>
                    <td style="width:75px; text-align:left; font-weight:bold;">Mother</td>
                    <td style="width:150px; text-align:left; font-weight:bold;">Phone</td>
                    <td style="width:250px; text-align:left; font-weight:bold;">Email</td>
                    <td style="width:100px; text-align:left; font-weight:bold;">City</td>
                    <td style="width:50px; text-align:left; font-weight:bold;">State</td>
                    <td style="width:200px; text-align:left; font-weight:bold;">Area Rep</td>
                    <td style="width:75px; text-align:left; font-weight:bold;">Las Hosted</td>
                    <td style="width:150px; text-align:left; font-weight:bold;">Status</td>
                    <td style="width:75px; text-align:left; font-weight:bold;">Status Updated</td>
                </tr>
                
                <cfloop query="getHostExport.QUERY">
                    <tr>
                        <td>#hostid#</td>
                        <td>#nexits_id#</td>
                        <td>#familylastname#</td>
                        <td>#fatherfirstname#</td>
                        <td>#motherfirstname#</td>
                        <td>#phone#</td>
                        <td>#email#</td>
                        <td>#city#</td>
                        <td>#state#</td>
                        <td>#area_rep_firstname# #area_rep_lastname#</td>
                        <td>#programName#</td>
                        <td>
                          <cfif isNotQualifiedToHost EQ 1 >
                              Not qualified to host
                          <cfelseif isHosting EQ 0>
                              Decided not to host
                          <cfelseif call_back EQ 1 >
                              Call Back
                          <cfelseif call_back EQ 2 >
                              Call Back Next SY
                          <cfelse>
                              Available to Host
                          </cfif>

                          
                        </td>
                        <td>#call_back_updated#</td>
                    </tr>                    
                </cfloop>
                
                <cfif NOT getHostExport.QUERY.recordCount>
                  <tr>
                      <td colspan="3" align="center">
                          There are no leads to be expoted at this time.
                        </td>
                   </tr>                        
                </cfif>
                
            </table>            
    
        </cfoutput>
        
        <cfabort>
          

</cfoutput>
