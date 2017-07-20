<!--- ------------------------------------------------------------------------- ----
	
	File:		host_fam_export.cfm
	Author:		Bruno Lopes
	Date:		May 8, 2017
	Desc:		EXITS Host Family Export Feature

	Updated:	
				
----- ------------------------------------------------------------------------- --->
<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">
<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
<!--- <cfheader name="Content-Disposition" value="attachment;filename=HostFamilyList.xls"> --->
<!--- set content type --->
<!--- <cfcontent type="application/msexcel"  reset="true"> --->

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
    param name="FORM.stateID" type="string" default='';  
    param name="FORM.sortBy" type="string" default='';  
    param name="FORM.sortOrder" type="string" default='';  
    param name="FORM.pageSize" type="numeric" default='10000';  
		
	// Get History
	getHostExport = APPLICATION.CFC.HOST.getHostsRemote(pageNumber = FORM.pageNumber, regionid = FORM.regionid, keyword = FORM.keyword,  active_rep = FORM.active_rep, hosting = FORM.hosting, active = FORM.active,cavailable_to_host = FORM.available_to_host, area_rep = FORM.area_rep, vHostIDList = FORM.vHostIDList, HFstatus = FORM.HFstatus, school_id = FORM.school_id, type = FORM.type, stateID = FORM.stateID, sortBy = FORM.sortBy, sortOrder = FORM.sortOrder, pageSize = FORM.pageSize
    );
	</cfscript>
    
</cfsilent>


<cfset tempPath  =   APPLICATION.PATH.temp & "HostFamilyList.xls">

<cfset SpreadsheetObj = spreadsheetNew("Hosts")>

<cfset poiSheet = SpreadsheetObj.getWorkBook().getSheet("Hosts")>
<cfset ps = poiSheet.getPrintSetup()>
<cfset ps.setLandscape(true)>
<cfset ps.setFitWidth(1)>
<cfset poiSheet.setFitToPage(true)>
<cfset poiSheet.setMargin( poiSheet.LeftMargin, 0.25)>
<cfset poiSheet.setMargin( poiSheet.RightMargin, 0.25)>
<cfset poiSheet.setMargin( poiSheet.TopMargin, 0.25)>
<cfset poiSheet.setMargin( poiSheet.BottomMargin, 0.25)>
            

<cfset spreadsheetAddRow(SpreadsheetObj, "Host ID, Last Name, Father, Father's Cellphone, Mother, Mother's Cellphone, Phone, Email, Address, Address 2, City, State, Zip, Region, Area Rep, Last Hosted, Status, Status Updated")> 
<cfloop query="getHostExport.QUERY" >

    <cfset spreadsheetAddRow(SpreadsheetObj, "#getHostExport.QUERY.hostid#, #replace(getHostExport.QUERY.familylastname,",","","all")#, #replace(getHostExport.QUERY.fatherfirstname,",","","all")#, #replace(getHostExport.QUERY.father_cell,",","","all")#, #getHostExport.QUERY.motherfirstname#, #replace(getHostExport.QUERY.mother_cell,",","","all")#, #getHostExport.QUERY.phone#, #getHostExport.QUERY.email#, #replace(getHostExport.QUERY.address,",","","all")#, #replace(getHostExport.QUERY.address2,",","","all")#, #replace(getHostExport.QUERY.city,",","","all")#, #getHostExport.QUERY.state#, #getHostExport.QUERY.zip#, #getHostExport.QUERY.regionname#, #replace(getHostExport.QUERY.area_rep_firstname,",","","all")# #getHostExport.QUERY.area_rep_lastname#, #getHostExport.QUERY.programName#, #getHostExport.QUERY.HFstatus#, #getHostExport.QUERY.call_back_updated#")> 
</cfloop>

<cfset SpreadsheetformatRow(SpreadsheetObj, {bold=true,alignment='center'},1)> 


<cfspreadsheet action="write" name="SpreadsheetObj" filename="#tempPath#" overwrite="true">

<cfheader name="Content-Disposition" value="inline; filename=HostFamilyList.xls" >
<cfcontent type="application/vnd.ms-excel" file="#tempPath#" deletefile="yes" >