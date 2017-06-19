<!--- ------------------------------------------------------------------------- ----
	
	File:		_export.cfm
	Author:		Marcus Melo
	Date:		April 7, 2011
	Desc:		ISEUSA.com Host Family Lead Export Feature

	Updated:	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<cfscript>
		// Param URL Variables
		param name="URL.dateExported" type="string" default='';	

   		// Decode URL
		URL.dateExported = URLDecode(URL.dateExported);
		
		if ( LEN(URL.dateExported) ) {
			
			// Export Leads
			qExportLeads = APPLICATION.CFC.HOST.exportHostLeads(dateExported=URL.dateExported);
			
			// Set Up Export File Name
			if ( IsDate(URL.dateExported) ) {
				fileName = 'HostLeadExport' & DateFormat(URL.dateExported, 'mm-dd-yy') & '-' & TimeFormat(URL.dateExported, 'hh-mm-tt') & '.xls';
			} else {
				fileName = 'HostLeadExport' & DateFormat(now(), 'mm-dd-yy') & '-' & TimeFormat(now(), 'hh-mm-tt') & '.xls';
			}

		}
		
		// Get History
		getHostLeadExportHistory = APPLICATION.CFC.HOST.getHostLeadExportHistory();
	</cfscript>
    
</cfsilent>

<cfoutput>

	<!--- Export To Excel File --->
    <cfif LEN(URL.dateExported)>
    
		<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
        <cfsetting enablecfoutputonly="Yes">
        
        <!--- set content type --->
        <cfcontent type="application/msexcel">
        
        <!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
        <cfheader name="Content-Disposition" value="attachment; filename=#fileName#">
        
        <!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
		The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
        <cfoutput>    

            <table border="1" style="font-family:Verdana, Geneva, sans-serif; font-size:9pt;">
                <tr>
                    <td colspan="3" style="font-size:16pt; font-weight:bold; text-align:center; border:none;">
                        Host Lead Export Tool Sheet         
                    </td>
                </tr>
                <tr>
                    <td style="width:200px; text-align:left; font-weight:bold;">Last Name</td>
                    <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
                    <td style="width:350px; text-align:left; font-weight:bold;">Email</td>
                </tr>
                
                <cfloop query="qExportLeads">
                    <tr>
                        <td>#qExportLeads.lastName#</td>
                        <td>#qExportLeads.firstName#</td>
                        <td>#qExportLeads.email#</td>
                    </tr>                    
                </cfloop>
                
                <cfif NOT qExportLeads.recordCount>
                	<tr>
                    	<td colspan="3" align="center">
                        	There are no leads to be expoted at this time.
                        </td>
					</tr>                        
                </cfif>
                
            </table>            
		
        </cfoutput>
		
		<script language="javascript">
            // Close Window After 1.5 Seconds
            setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
			alert('test');
        </script>
        
        <cfabort>
        
   </cfif>     

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

        <!--- Table Header --->
        <gui:tableHeader
            imageName="current_items.gif"
            tableTitle="Host Family Lead Export Tool"
            width="95%"
            imagePath="../"
        />    
		
		<!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="95%"
            />
        
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="95%"
            />

          <table width="95%" border="0" cellpadding="4" cellspacing="0" class="section" align="center" style="padding-top:10px; padding-bottom:10px;">
              <tr>
                  <td align="center"><a href="index.cfm?action=export&dateExported=new" title="Click Here to Export"><img src="../pics/export.gif" border="0" /></td>
              </tr>
          </table>
  		

          <!--- History --->
          <table width="95%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">                            				
              <tr class="projectHelpTitle">
                  <th colspan="3">Export History</th>
              </tr>
              <tr>
                  <td class="columnTitle">Date</td>
                  <td class="columnTitle">Total Leads</td>
                  <td class="columnTitle">Actions</td>
              </tr>
              <cfloop query="getHostLeadExportHistory">
                  <tr bgcolor="###iif(getHostLeadExportHistory.currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                      <td valign="top">#DateFormat(getHostLeadExportHistory.dateExported, 'mm/dd/yy')# at #TimeFormat(getHostLeadExportHistory.dateExported, 'hh:mm:ss tt')# EST</td>
                      <td valign="top">#getHostLeadExportHistory.totalLeads#</td>
                      <td valign="top"><a href="index.cfm?action=export&dateExported=#URLEncodedFormat(getHostLeadExportHistory.dateExported)#" title="Click Here to Export">[ Download ]</a></td>
                  </tr>
              </cfloop>
          </table>   

            
        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="95%"
			imagePath="../"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfoutput>
