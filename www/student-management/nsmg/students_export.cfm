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
<cfheader name="Content-Disposition" value="attachment;filename=StudentsList.xls">
<!--- set content type --->
<cfcontent type="application/msexcel"  reset="true">

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
        searchStudentID = FORM.searchStudentID);
	</cfscript>
    
</cfsilent>
<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>    

    <table border="1" style="font-family:Verdana, Geneva, sans-serif; font-size:9pt;">
        <tr>
            <td colspan="13" style="font-size:16pt; font-weight:bold; text-align:center; border:none;">
                Students Export  
            </td>
        </tr>
        <tr>
            <td style="width:50px; text-align:left; font-weight:bold;">ID</td>
            <td style="width:75px; text-align:left; font-weight:bold;">Last Name</td>
            <td style="width:75px; text-align:left; font-weight:bold;">First Name</td>
            <td style="width:75px; text-align:left; font-weight:bold;">Sex</td>
            <td style="width:150px; text-align:left; font-weight:bold;">Country</td>
            <td style="width:150px; text-align:left; font-weight:bold;">Email</td>
            <td style="width:250px; text-align:left; font-weight:bold;">Requests</td>
            <td style="width:100px; text-align:left; font-weight:bold;">Status</td>
            <td style="width:100px; text-align:left; font-weight:bold;">Hold Date</td>
            <td style="width:100px; text-align:left; font-weight:bold;">Region</td>
            <td style="width:100px; text-align:left; font-weight:bold;">Program</td>
            <td style="width:100px; text-align:left; font-weight:bold;">Placement Date</td>
            <td style="width:170px; text-align:left; font-weight:bold;">Int. Agent</td>
        </tr>
        
        <cfloop query="getStudentsExport.QUERY">
            <tr>
                <td>#getStudentsExport.QUERY.studentid#</td>
                <td>#getStudentsExport.QUERY.familylastname#</td>
                <td>#getStudentsExport.QUERY.firstname#</td>
                <td>#getStudentsExport.QUERY.sex#</td>
                <td>#getStudentsExport.QUERY.countryname#</td>
                <td>#getStudentsExport.QUERY.email#</td>
                <td>
                    <cfset hasState = 0 />
                    <cfif (getStudentsExport.QUERY.state1name NEQ '') >
                        <strong>State:</strong> #getStudentsExport.QUERY.state1name#
                        <cfset hasState = 1 />
                    </cfif>
                    <cfif (getStudentsExport.QUERY.state2name NEQ '') >
                        , #getStudentsExport.QUERY.state2name#
                        <cfset hasState = 1 />
                    </cfif>
                    <cfif (getStudentsExport.QUERY.state3name NEQ '') >
                        , #getStudentsExport.QUERY.state3name#
                        <cfset hasState = 1 />
                    </cfif>

                    <cfset hasRegion = 0 />
                    <cfif  (getStudentsExport.QUERY.app_region_guarantee EQ 6) >
                        <cfif (hasState EQ 1) > ;</cfif>
                        <strong>Region:</strong> West Region 
                        <cfset hasRegion = 1 />
                    </cfif>
                    <cfif (getStudentsExport.QUERY.app_region_guarantee EQ 7) >
                        <cfif (hasState EQ 1) > ;</cfif>
                        <strong>Region:</strong> Central Region 
                        <cfset hasRegion = 1 />
                    </cfif>
                    <cfif (getStudentsExport.QUERY.app_region_guarantee EQ 8) >
                        <cfif (hasState EQ 1) > ;</cfif>
                        <strong>Region:</strong> South Region 
                        <cfset hasRegion = 1 />
                    </cfif>
                    <cfif  (getStudentsExport.QUERY.app_region_guarantee EQ 9) >
                        <cfif (hasState EQ 1) > ;</cfif>
                        <strong>Region:</strong> East Region 
                        <cfset hasRegion = 1 />
                    </cfif>

                    <cfif ((getStudentsExport.QUERY.add_program NEQ '') && (getStudentsExport.QUERY.add_program NEQ 'None')) >
                        <cfif ((hasState EQ 1) || (hasRegion EQ 1)) > ;</cfif>
                        <cfif (getStudentsExport.QUERY.add_program EQ 'New York Orientation') >
                            <strong>NY Orientation</strong>
                        <cfelseif (getStudentsExport.QUERY.add_program EQ 'Pre-AYP English') >
                            <strong>Pre-AYP</strong>
                        <cfelse >
                            #getStudentsExport.QUERY.add_program#;
                        </cfif>
                    </cfif>
                </td>
                <td>#stu_status#</td>
                <td>#hold_create_date#</td>
                <td>
                    #regionname#
                    <cfif (state_guarantee NEQ '') >
                        <span style="color:##CC0000; font-weight:bold">* #state_guarantee#</span>
                    </cfif>
                    <cfif (r_guarantee NEQ '') >
                        <span style="color:##CC0000; font-weight:bold">* #r_guarantee#</span>
                    </cfif>
                </td>
                <td>#programname#</td>
                <td>#DateFormat(dateplaced, 'mm/dd/yyyy')#</td>
                <td>#businessname# (###intrepID#)
                    <cfif VAL(branchID)>
                        <br /><strong>Branch:</strong> #branchName#
                    </cfif>
                </td>
            </tr>                    
        </cfloop>
        
        <cfif NOT getStudentsExport.QUERY.recordCount>
          <tr>
              <td colspan="13" align="center">
                  There are no students to be expoted at this time.
                </td>
           </tr>                        
        </cfif>
        
    </table>            

</cfoutput>