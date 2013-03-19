<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage3.cfm
	Author:		Marcus Melo
	Date:		03/17/2013
	Desc:		Page 3 Print Version
				This page gets the already created PDF files and merge them on the fly

	Updated:	
	
	Test URL:	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage3&hostID=37739

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>
		// Get Parents CBC
		qGetParentsAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",																		   
			foreignID=FORM.hostID, 
			documentTypeIDList="16,17", 
			seasonID=APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID // This needs to be replaced to get the assigned season for this app as a host family might apply to different seasons
		);
		
		// Get Host Family Members at Home
		qGetCBCQualifiedMembers = APPLICATION.CFC.HOST.getHostMemberByID(hostID=FORM.hostID,getCBCQualifiedMembers=1);	

		vCBCQualifiedMembersList = ValueList(qGetCBCQualifiedMembers.childID);
		
		qGetFamilyMembersAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_host_children",																		   
			foreignIDList=vCBCQualifiedMembersList, 
			documentTypeID="18", 
			seasonID=APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID // This needs to be replaced to get the assigned season for this app as a host family might apply to different seasons
		);
	</cfscript>
    
</cfsilent>  

<cfoutput>	
    
    <cfpdf name="cbcAuthorization" action="merge" overwrite="yes">
        
        <cfloop query="qGetParentsAuthorization">
            <cfpdfparam source="#qGetParentsAuthorization.filePath#">
        </cfloop>
        
        <cfloop query="qGetFamilyMembersAuthorization">
            <cfpdfparam source="#qGetFamilyMembersAuthorization.filePath#">
        </cfloop>
        
    </cfpdf>

	<!--- Set up the header info --->
    <cfheader 
        name="content-disposition" 
        value="attachment; filename=cbcAurhorization.pdf"/>


    <!--- Set up the content type --->        
    <cfcontent 
        type="application/pdf" 
        variable="#toBinary(cbcAuthorization)#">
    
	<!---
    <table class="profileTable" align="center">
        <tr>
            <td style="padding-bottom:20px;">
            
				<!--- Host Header --->
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800" style="line-height:20px;">
                    <tr>
                        <td colspan="3"><img src="../pics/hostAppBanners/Pdf_Headers_02.jpg"></td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <span class="title">Region:</span> #qGetHostInfo.regionName#<br />
                            <span class="title">Area Representative:</span> #qGetHostInfo.areaRepresentative#
                        </td>
                        <td align="center" valign="top">
                            <span class="title" style="font-size:18px;">#qGetHostInfo.familyLastName# (###qGetHostInfo.hostid#) <br /> Host Family Application</span>
                        </td>
                        <td align="right" valign="top">
                            <span class="title">Started:</span> #DateFormat(qGetHostInfo.applicationStarted, 'mmm, d, yyyy')#<br />
                            <span class="title">Page 3</span>
                        </td>
                    </tr>
                </table>


                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_backgroundchecks.jpg"/></td>
                	</tr>
                    <tr>
                    	<td>
                        	
						
                        </td>
					</tr>                                                
				</table>
                
            </td>
		</tr>
	</table>                    
	--->
                         
</cfoutput>