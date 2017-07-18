<!--- ------------------------------------------------------------------------- ----
	
	File:		students_export.cfm
	Author:		Bruno Lopes
	Date:		June 23, 2017
	Desc:		EXITS Students Export Feature

	Updated:	
				
----- ------------------------------------------------------------------------- --->
<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
<!--- <cfheader name="Content-Disposition" value="attachment;filename=StudentsList.xls"> --->
<!--- set content type --->
<!--- <cfcontent type="application/msexcel"  reset="true"> --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />

    <!--- Param Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionID" default="#CLIENT.regionID#">
    <cfparam name="FORM.keyword" default="">
    <cfparam name="FORM.sortBy" default="">
    <cfparam name="FORM.sortOrder" default="">
    <cfparam name="FORM.pageSize" default="10000">
    <cfparam name="FORM.pageNumber" default="1">

    <cfif CLIENT.usertype GT 4>
        <!--- Field --->
        <cfparam name="FORM.cancelled" default="0">
        <cfparam name="FORM.hold_status_id" default="0">
        <cfparam name="FORM.active" default="1">    
    <cfelse>
        <!--- Office USERS --->
        <cfparam name="FORM.cancelled" default="">
        <cfparam name="FORM.hold_status_id" default="">
        <cfparam name="FORM.active" default="">
    </cfif>

    <cfparam name="FORM.placement_status" default="">
    <cfparam name="FORM.priority_student" default="">
    <cfparam name="FORM.double_placement" default="">
    
    <!--- advanced search items. --->
    <cfparam name="FORM.placed" default="">
    <cfparam name="FORM.searchStudentID" default="">
    <cfparam name="FORM.adv_search" default="0">
    <cfparam name="FORM.familyLastName" default="">
    <cfparam name="FORM.firstName" default="">
    <cfparam name="FORM.preayp" default="">
    <cfparam name="FORM.direct" default="">
    <cfparam name="FORM.age" default="">
    <cfparam name="FORM.sex" default="">
    <cfparam name="FORM.grade" default="">
    <cfparam name="FORM.graduate" default="">
    <cfparam name="FORM.religionid" default="">
    <cfparam name="FORM.interestid" default="">
    <cfparam name="FORM.sports" default="">
    <cfparam name="FORM.interests_other" default="">
    <cfparam name="FORM.countryID" default="">
    <cfparam name="FORM.intrep" default="">
    <cfparam name="FORM.stateid" default="">
    <cfparam name="FORM.state_placed_id" default="">
    <cfparam name="FORM.programID" default="[]">
    <cfparam name="FORM.privateschool" default="">
    <cfparam name="FORM.placementStatus" default="">
    <cfparam name="FORM.seasonID" default="">	

	<cfscript>
    getStudentsExport = APPLICATION.CFC.student.getStudentsRemote(pageNumber = FORM.pageNumber,
        regionID = FORM.regionID,
        keyword = FORM.keyword,
        placed = FORM.placed,
        placement_status = FORM.placement_status,
        priority_student = FORM.priority_student,
        double_placement = FORM.double_placement,
        hold_status_id = FORM.hold_status_id,
        cancelled = FORM.cancelled,
        active = FORM.active,
        seasonID = FORM.seasonID,
        sortBy = FORM.sortBy,
        sortOrder = FORM.sortOrder,
        pageSize = FORM.pageSize,
        adv_search = FORM.pageSize,
        familyLastName = FORM.familyLastName,
        firstName = FORM.firstName,
        age = FORM.age,
        sex = FORM.sex,
        preayp = FORM.preayp,
        direct = FORM.direct,
        privateschool = FORM.privateschool,
        grade = FORM.grade,
        graduate = FORM.graduate,
        religionid = FORM.religionid,
        interestid = FORM.interestid,
        sports = FORM.sports,
        interests_other = FORM.interests_other,
        placementStatus = FORM.placementStatus,
        countryID = FORM.countryID,
        intrep = FORM.intrep,
        stateid = FORM.stateid,
        state_placed_id = FORM.state_placed_id,
        programID = FORM.programID,
        searchStudentID = FORM.searchStudentID,
        isExport = 1);
	</cfscript>
    
</cfsilent>

<cfset tempPath  =   APPLICATION.PATH.temp & "StudentsList.xls">

<cfset SpreadsheetObj = spreadsheetNew("Students")>

<cfset poiSheet = SpreadsheetObj.getWorkBook().getSheet("Students")>
<cfset ps = poiSheet.getPrintSetup()>
<cfset ps.setLandscape(true)>
<cfset ps.setFitWidth(1)>
<cfset poiSheet.setFitToPage(true)>
<cfset poiSheet.setMargin( poiSheet.LeftMargin, 0.25)>
<cfset poiSheet.setMargin( poiSheet.RightMargin, 0.25)>
<cfset poiSheet.setMargin( poiSheet.TopMargin, 0.25)>
<cfset poiSheet.setMargin( poiSheet.BottomMargin, 0.25)>

<cfset spreadsheetAddRow(SpreadsheetObj, "StudentID, Last Name, First Name, Sex, Country, Email, Requests, Status, Since, Region, Program, Placement Date, Int. Agent")> 
<cfloop query="getStudentsExport.QUERY" >

    <cfset student_request = '' />
    <cfset hasState = 0 />
    <cfif (getStudentsExport.QUERY.state1name NEQ '') >
        <cfset student_request = student_request & "State: #getStudentsExport.QUERY.state1name#" />
        <cfset hasState = 1 />
    </cfif>
    <cfif (getStudentsExport.QUERY.state2name NEQ '') >
        <cfset student_request = student_request & " #getStudentsExport.QUERY.state2name#" />
        <cfset hasState = 1 />
    </cfif>
    <cfif (getStudentsExport.QUERY.state3name NEQ '') >
        <cfset student_request = student_request & " #getStudentsExport.QUERY.state3name#" />
        <cfset hasState = 1 />
    </cfif>

    <cfset hasRegion = 0 />
    <cfif  (getStudentsExport.QUERY.app_region_guarantee EQ 6) >
        <cfif (hasState EQ 1) ><cfset student_request = student_request & "; " /></cfif>
        <cfset student_request = student_request & "Region: West Region " />
        <cfset hasRegion = 1 />
    </cfif>
    <cfif (getStudentsExport.QUERY.app_region_guarantee EQ 7) >
        <cfif (hasState EQ 1) ><cfset student_request = student_request & "; " /></cfif>
        <cfset student_request = student_request & "Region: Central Region " />
        <cfset hasRegion = 1 />
    </cfif>
    <cfif (getStudentsExport.QUERY.app_region_guarantee EQ 8) >
        <cfif (hasState EQ 1) ><cfset student_request = student_request & "; " /></cfif>
        <cfset student_request = student_request & "Region: South Region " />
        <cfset hasRegion = 1 />
    </cfif>
    <cfif  (getStudentsExport.QUERY.app_region_guarantee EQ 9) >
        <cfif (hasState EQ 1) ><cfset student_request = student_request & "; " /></cfif>
        <cfset student_request = student_request & "Region: East Region " />
        <cfset hasRegion = 1 />
    </cfif>

    <cfif ((getStudentsExport.QUERY.add_program NEQ '') && (getStudentsExport.QUERY.add_program NEQ 'None')) >
        <cfif ((hasState EQ 1) || (hasRegion EQ 1)) > <cfset student_request = student_request & "; " /></cfif>
        <cfif (getStudentsExport.QUERY.add_program EQ 'New York Orientation') >
            <cfset student_request = student_request & "NY Orientation" />            
        <cfelseif (getStudentsExport.QUERY.add_program EQ 'Pre-AYP English') >
            <cfset student_request = student_request & " Pre-AYP" />
        <cfelse >
            <cfset student_request = student_request & " #getStudentsExport.QUERY.add_program#" />
        </cfif>
    </cfif>


    <cfset student_region = regionname />
    <cfif (state_guarantee NEQ '') >
        <cfset student_region = regionname & " *#state_guarantee#" />
    </cfif>
    <cfif (r_guarantee NEQ '') >
        <cfset student_region = regionname & " *#r_guarantee#" />
    </cfif>

    <cfset student_programname = programname />
    <cfif (aypenglish NEQ '') >
        <cfset student_programname = student_programname & ' *Pre-Ayp English' />
    </cfif>
    <cfif (ayporientation NEQ '') >
        <cfset student_programname = student_programname & ' *NY Orient' />
    </cfif>


    <cfset student_intRep = "#businessname# (###intrepID#)" />
    <cfif VAL(branchID)>
        <cfset student_intRep = student_intRep & " Branch: #branchName#" />
    </cfif>

    <cfset spreadsheetAddRow(SpreadsheetObj, "#getStudentsExport.QUERY.studentid#, #replace(getStudentsExport.QUERY.familylastname,",","","all")#, #replace(getStudentsExport.QUERY.firstname,",","","all")#, #getStudentsExport.QUERY.sex#, #getStudentsExport.QUERY.countryname#, #getStudentsExport.QUERY.email#, #student_request#, #getStudentsExport.QUERY.stu_status#, #getStudentsExport.QUERY.status_date#, #student_region#, #student_programname#, #DateFormat(dateplaced, 'mm/dd/yyyy')#, #replace(student_intRep,",","","all")#")> 
</cfloop>

<cfset SpreadsheetformatRow(SpreadsheetObj, {bold=true,alignment='center'},1)> 


<cfspreadsheet action="write" name="SpreadsheetObj" filename="#tempPath#" overwrite="true">

<cfheader name="Content-Disposition" value="inline; filename=StudentsList.xls" >
<cfcontent type="application/vnd.ms-excel" file="#tempPath#" deletefile="yes" >

<cfabort />