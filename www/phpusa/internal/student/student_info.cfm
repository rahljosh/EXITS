<!--- ------------------------------------------------------------------------- ----
	
	File:		_flightInfo.cfm
	Author:		Marcus Melo
	Date:		May 13, 2011
	Desc:		Inserts/Updates Students flight information

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param URL Variables --->
    <cfparam name="URL.unqID" default="">
    <cfparam name="edit" default="no">
    
	<cfif NOT LEN(url.unqid)>
        <cfinclude template="../error_message.cfm">
        <cfabort>
    </cfif>
    
    <cfscript>
		// Get Training Options
		qGetReturnOptions = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='PHPReturnOptions');
	</cfscript>
    
    <!--- Get Student Info by uniqueID --->
    <cfinclude template="../querys/get_student_unqid.cfm">
    
    <cfinclude template="../querys/get_programs.cfm">
    
    <cfinclude template="../querys/get_intl_reps.cfm">
    
    <cfif isDefined('form.edit') AND ListFind("1,2,3,4", CLIENT.usertype)> 
		<cfset edit = form.edit> 
	</cfif>

    <cfdirectory directory="#APPLICATION.PATH.onlineApp.picture#" name="dStudentPicture" filter="#get_student_unqid.studentID#.*">
    
    <!----International Rep---->
    <cfquery name="int_Agent" datasource="mysql">
        SELECT 
        	u.businessname, 
            u.firstname, 
            u.lastname, 
            u.userid, 
            u.php_insurance_typeid, 
            insu.type
        FROM 
        	smg_users u
        LEFT JOIN 
        	smg_insurance_type insu ON insu.insutypeid = u.php_insurance_typeid
        WHERE 
        	u.userid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.intrep#">
    </cfquery>
    
    <!--- CHECK IF STUDENT IS ASSIGNED TO MORE THAN ON PROGRAM --->
    <cfquery name="get_programs_assigned" datasource="MySql">
        SELECT 
        	ps.assignedid, 
            ps.programid,
            ps.active, 
            ps.canceldate, 
            ps.cancelreason, 
            ps.datecreated,
            p.programname
        FROM 
        	php_students_in_program ps
        LEFT JOIN 
        	smg_programs p ON p.programid = ps.programid
        WHERE 
        	ps.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentid#">
        ORDER BY 
        	ps.assignedid DESC
    </cfquery>
    
	<!--- INVOICES ARE BASED ON PROGRAMS - CHECK IF AN INVOICE HAS BEEN CREATED FOR THIS PROGRAM --->
    <cfquery name="check_invoice" datasource="MySql">
        SELECT 
        	chargeid
        FROM 
        	egom_charges	
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentid#">
        AND 
        	programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.programid#">							
    </cfquery>
    
    <!--- GET PROGRAM NAME --->
    <cfquery name="get_program" datasource="MySql">
        SELECT 
        	programid,
            programname, 
            enddate
        FROM 
        	smg_programs
        WHERE 
        	programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.programid#">
    </cfquery>
    
    <cfquery name="qInsuranceInfo" datasource="mysql">
        SELECT
            startDate,
            endDate
        FROM 
            php_insurance_batch
        WHERE
            studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentID#">
        AND	
            assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.assignedID#">
        AND
            type = <cfqueryparam cfsqltype="cf_sql_varchar" value="N">    
    </cfquery>
    
</cfsilent>

<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {
				
		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false 
		});		

	});

	<!--// 
	// open online application 
	function openWindow(vUrl, vWindowName, vHeight, vWidth) {
		var MyWindow = window.open ('', vWindowName, "height=" + vHeight + ", width=" + vWidth + " , location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes");
		MyWindow.location.href = vUrl;		
	}
	
	var currentTime = new Date()
	var month = currentTime.getMonth() + 1
	var day = currentTime.getDate()
	var year = currentTime.getFullYear()
	if (day < 10) 
		day = "0"+day;
	if (month < 10) 
		month = "0"+month;
	
	function CheckDates(ckname, frname) {
		if (document.StudentInfo.elements[ckname].checked) {
			document.StudentInfo.elements[frname].value = (month + "/" + day + "/" + year);
		} else { 
			document.StudentInfo.elements[frname].value = '';  
		}
	}	
	
	function formHandler2(){
		var URL = document.StudentInfo.sele_program.options[document.StudentInfo.sele_program.selectedIndex].value;
		window.location.href = URL;
	}
	//-->
</script>

<!--- student does not exist --->
<cfif get_student_unqid.recordcount EQ 0>
	The student ID you are looking for, <cfoutput>#get_student_unqid.studentid#</cfoutput>, was not found. This could be for a number of reasons.<br /><br />
	<ul>
		<li>the student record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view the student
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<!---- Header Table ---->
<h2>&nbsp;&nbsp;&nbsp;&nbsp;S t u d e n t &nbsp;&nbsp;&nbsp;  I n f o r m a t i o n</h2>

<cfoutput query="get_student_unqid">

<form name="StudentInfo" method="post" action="?curdoc=student/qr_student_info">
<input type="hidden" name="studentid" value="#get_student_unqid.studentid#">
<input type="hidden" name="assignedid" value="#get_student_unqid.assignedid#">

<div class="section">

	<cfif get_programs_assigned.recordcount GT 1>
        <table width="770" border=1 align="center" bordercolor="##C7CFDC" bgcolor="##ffffff">	
            <tr><td align="center">
                This student is assigned to more than one program. Currently showing 
                <select name="sele_program" onChange="javascript:formHandler2()">
                <cfloop query="get_programs_assigned">
                    <option value="?curdoc=student/student_info&unqid=#url.unqid#&assignedid=#assignedid#" <cfif get_student_unqid.programid EQ programid>selected</cfif>>#programname#</option>
                </cfloop>
                </select> program.
            </td>
            </tr>
        </table>
    </cfif>

    <table width="770" border=1 align="center" cellpadding="5" cellspacing=8 bordercolor="##C7CFDC" bgcolor="##ffffff">	
        <tr>
            <td valign="top" width="570" class="box">
                <cfif hostid EQ 0 and canceldate is ''>
                    <table background="pics/unplaced.jpg" cellpadding="2" width="100%"> 
                <cfelseif hostid EQ 0 and canceldate is not ''>
                    <table background="pics/canceled.jpg" cellpadding="2" width="100%"> 
                <cfelse>
                    <table width=100% align="Center" cellpadding="2">				
                </cfif>
                <tr>
                <td width="135">
                    <table width="100%" cellpadding="2">
                        <tr><td width="135" valign="top">
                            <cfif dStudentPicture.recordcount>
                                <img src="#APPLICATION.PATH.SmgURL#uploadedfiles/web-students/#dStudentPicture.name#" width="135" height="200">
                            <cfelse>
                                <img src="pics/no_stupicture.jpg" width="135">
                            </cfif>
                        </td></tr>
                    </table>
                </td>
                <td valign="top">
                    <table width="100%" cellpadding="2">
                        <tr><td align="center" colspan="2"><h2>#firstname# #middlename# #familylastname# (#studentid#)</h2></td></tr>
                        <tr><td align="center" colspan="2"><font size=-1><span class="edit_link">[ <cfif ListFind("1,2,3,4", CLIENT.usertype)><a href="index.cfm?curdoc=student/student_form1&unqid=#uniqueID#">edit</a> &middot; </cfif> <a href='student/student_profile.cfm?unqid=#get_student_unqid.uniqueID#'>profile</a> ]</span></font></td></tr>
                        <tr><td align="center" colspan="2"><cfif dob EQ ''>n/a<cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old #sex# </cfif></td></tr> 
                        <cfif listFind("1,2,3,4", CLIENT.userType)>
                            <tr>
                                <td width="15%" align="right">Intl. Rep. : </td>
                                <td width="85%">
                                    <select name="intrep" <cfif edit EQ 'no'>disabled</cfif> >
                                        <option value="0"></option>		
                                        <cfloop query="get_intl_reps">
                                            <option value="#userid#" <cfif userid EQ get_student_unqid.intrep> selected </cfif>><cfif #len(businessname)# gt 45>#Left(businessname, 42)#...<cfelse>#businessname#</cfif></option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                        </cfif>
                        <tr>
                            <td colspan="2">
                                <table width="50%" cellpadding="2" align="left">
                                    <tr><td align="right">Date of Entry : </td><td>#DateFormat(dateapplication, 'mm/dd/yyyy')#</td></tr>
                                    <tr>
                                        <td align="right">				
                                            <input type="checkbox" name="active" <cfif active is 1>checked="Yes"</cfif> <cfif edit EQ 'no'>disabled</cfif>>
                                        </td>
                                        <td>Student is Active</td>
                                    </tr>
                                    <tr>
                                        <td align="right">Ret/Ext/Trans:</td>
                                        <td>
                                            <select name="return_student" <cfif edit EQ 'no'>disabled</cfif>>
                                                <option value="0" <cfif return_student eq 0>selected</cfif>>n/a</option>
                                                <cfloop query="qGetReturnOptions">
                                                	<option value="#qGetReturnOptions.fieldID#" <cfif get_student_unqid.return_student EQ qGetReturnOptions.fieldID>selected</cfif>>#qGetReturnOptions.name#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                    </tr>	
                                    <tr><td align="right"><input type="checkbox" name="php_wishes_graduate" <cfif php_wishes_graduate EQ 'yes'>checked="Yes"</cfif> disabled></td><td>Wishes to Graduate</td></tr>												
                                </table>
                                <!--- EXITS ONLINE APPLICATION --->
                                <table width="50%" cellpadding="2" align="center">
                                    <cfif app_current_status NEQ 0>
                                        <tr>
                                            <td align="center">
                                                <cfif ListFind("1,2,3,4", CLIENT.usertype)>
                                                    <a href="javascript:openWindow('#APPLICATION.PATH.SmgURL#student_app/index.cfm?curdoc=section1&unqid=#uniqueID#&id=1', 'exitsApplication', '600', '800');"><img src="pics/exits.jpg" border="0"></a>
                                                <cfelse>
                                                    <a href="javascript:openWindow('#APPLICATION.PATH.SmgURL#student_app/print_application.cfm?unqid=#uniqueID#', 'exitsApplication', '600', '800');"><img src="pics/exits.jpg" border="0"></a>
                                                </cfif>
                                                <br />
                                                <a href="javascript:openWindow('#APPLICATION.PATH.SmgURL#student_app/section4/page22print.cfm?unqid=#uniqueID#', 'exitsAttachedFiles', '500', '600');"><img src="pics/attached-files.gif" border="0"></a>
                                                <br />
                                                <a href="javascript:openWindow('#APPLICATION.PATH.SmgURL#student_app/email_form.cfm?userid=#CLIENT.userid#&unqid=#uniqueID#&companyShort=php', 'exitsEmailApplication', '400', '500');"><img src="pics/send-email.gif" border="0"></a>
                                            </td>
                                        </tr>
                                    <cfelse>
                                    	<tr><td align="right">&nbsp;</td></tr>
                                    </cfif>		
                                </table>
                        	</td>
                    	</tr>
                	</table>								
                </td>
            </tr>
          </table>
            </td>
            <td align="right" valign="top" width="200"  class="box">
                <div id="subMenuNav"> 
                    <div id="subMenuLinks">  
                        <!----
                        <a href="javascript: win=window.open('forms/received_progress_reports.cfm?stuid=#CLIENT.studentid#', 'Reports', 'height=450, width=610, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Progress Reports</A>  
                        ---->
                        <a href="student/placementMgmt/index.cfm?uniqueID=#get_student_unqid.uniqueID#&assignedID=#get_student_unqid.assignedID#" class="jQueryModal">Placement Management</a>
                        <a href="" onClick="javascript: win=window.open('student/evaluations.cfm?unqid=#get_student_unqid.uniqueID#&assignedid=#get_student_unqid.assignedid#', 'Settings', 'height=320, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Evaluations / Grades</a> 
                        <a href="" onClick="javascript: win=window.open('forms/received_progress_reports.cfm?unqid=#get_student_unqid.uniqueID#', 'Reports', 'height=450, width=610, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Progress Reports</A>  
                        <a href="" onClick="javascript: win=window.open('http://www.student-management.com/nsmg/virtualfolder/list_vfolder.cfm?unqid=#get_student_unqid.uniqueID#', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Virtual Folder</a>						
                        <!--- Flight Information --->
                        <a href="student/index.cfm?action=flightInformation&uniqueID=#get_student_unqid.uniqueID#&programID=#get_student_unqid.programID#" class="jQueryModal">Flight Information</a>
                        <a href="" onClick="javascript: win=window.open('student/missing_documents.cfm?unqid=#get_student_unqid.uniqueID#', 'Settings', 'height=450, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Missing Documents</A>
                        <a href="" onClick="javascript: win=window.open('forms/notes.cfm?unqid=#get_student_unqid.uniqueID#', 'Settings', 'height=420, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Notes</a> 				
                    </div>
                </div>
            </td>
        </tr>
    </table><br />
    
    <!--- PROGRAM / REGION --->
    <table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
        <tr>
            <td width="49%" valign="top">
                <table cellpadding="5"  align="center" width="100%" bgcolor=##ffffff class=box>
                    <tr bgcolor="##C2D1EF">
                        <td colspan="2">
                            <span class="get_attention"><b>:: </b>Program 
                            <cfif ListFind("1,2,3,4", CLIENT.usertype)> &nbsp; &nbsp;
                                [ <font size="-3"> <a href="javascript:openWindow('student/program_management.cfm?unqid=#uniqueID#', 'programHistory', '300', '500');">Program Management</a> ]</font>
                            </cfif>
                            </span>
                        </td>
                    </tr>
                    <!--- IF THERE IS AN INVOICE PROGRAM SHOULD NOT BE CHANGED - INVOICES ARE BASED ON PROGRAMS. --->
                    <cfif get_student_unqid.programid NEQ 0 AND check_invoice.recordcount>
                        <tr>
                            <td width="50%">Program :</td>
                            <td align="left">* #get_program.programname#<input type="hidden" name="program" value="#get_student_unqid.programid#"></td>
                        </tr>
                        <tr><td colspan="2"><font size="-3">* Program Invoiced. You can not change this program.</font></td></tr>		
                    <!--- PROGRAM EXPIRED - PROGRAM SHOULD NOT BE CHANGED --->
                    <cfelseif get_student_unqid.programid NEQ 0 AND get_program.enddate LT now()>
                        <tr>
                            <td width="50%">Program :</td>
                            <td align="left">* #get_program.programname#<input type="hidden" name="program" value="#get_student_unqid.programid#"></td>
                        </tr>	
                        <tr><td colspan="2"><font size="-3">*Program expired. You can not change this program.</font></td></tr>
                    <!--- PROGRAM ACTIVE AND NO INVOICE --->
                    <cfelse>
                        <tr>
                            <td width="50%">Program :</td>
                            <td align="left">											
                                <select name="program" <cfif edit EQ 'no'>disabled</cfif>>
                                <option value="0">Unassigned</option>
                                <cfloop query="get_programs"><option value="#programid#" <cfif get_student_unqid.programid EQ programid>selected</cfif>>#programname#</option></cfloop>
                                </select>
                            </td>
                        </tr>
                    </cfif>
                    <tr>	
                        <td>Previous / Upcoming Programs :</td>
                        <td align="left">
                            <cfif get_programs_assigned.recordcount GT 1>
                                <cfloop query="get_programs_assigned">
                                    #programname# <cfif active>&nbsp;(active)</cfif><br />
                                </cfloop>
                            <cfelse>
                                n/a
                            </cfif>	
                        </td>
                    </tr>
                    <!--- reason for changing programs --->
                    <tr id="program_history" bgcolor="FFBD9D">
                        <td>Reason for changing:</td>
                        <td><input type="text" size="20" name="program_reason" <cfif edit EQ 'no'>disabled</cfif>></td>
                    </tr>
                </table>
            </td>
            <td width="2%" valign="top">&nbsp;</td>
            <td width="49%" valign="top">
            <!----School Info---->
                <table cellpadding="2" width="100%" bgcolor=##ffffff class=box>
                    <tr bgcolor="##C2D1EF"><td colspan="3"><span class="get_attention"><b>:: </b>High School</span></td></tr>
                    <cfif schoolid eq 0>
                        <tr><td colspan=2 align="center">School is not assigned. Please go to the placement management to place this student.<br /><br /><br /><br /></td></tr>
                    <cfelse>
                        <cfquery name="school_info" datasource="mysql">
                            SELECT schools.schoolid, schools.schoolname, schools.address, schools.city,  schools.zip, schools.phone, schools.email, schools.website,
                            states.statename
                            FROM php_schools schools
                            LEFT JOIN smg_states states ON states.id = schools.state 
                            WHERE schoolid = '#schoolid#'
                        </cfquery>
                        <tr><td><a href="index.cfm?curdoc=forms/view_school&sc=#school_info.schoolid#" target="_blank">#school_info.schoolname# (###school_info.schoolid#)</a><br />#school_info.address#<br />#school_info.city# #school_info.statename#, #school_info.zip#</td></tr>
                        <tr><td>Website: <cfif school_info.website is not ''><a href="http://#school_info.website#" target="blank">#school_info.website#</a><cfelse>n/a</cfif></td></tr>
                        <tr>
                            <td colspan="2">
                                <table width="100%">
                                    <tr>
                                        <td><cfif school_acceptance EQ ''><input type="checkbox" name="school_acceptance_box" disabled> <cfelse> <input type="checkbox" name="school_acceptance_box" checked disabled> </cfif></td>
                                        <td>School Acceptance &nbsp; &nbsp; Date: &nbsp; #DateFormat(school_acceptance, 'mm/dd/yyyy')#</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </cfif>
                </table>	
            </td>	
        </tr>
    </table><br />
    
    <table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
        <tr>
            <td width="49%" valign="top">
            <!----Insurance---->
                <table cellpadding="2" width="100%" bgcolor="##ffffff" class="box">
                    <tr bgcolor="##C2D1EF"><td colspan="3"><span class="get_attention"><b>:: </b>Insurance &nbsp; &nbsp; </span></td></tr>
                    <tr>
                        <td width="10"><cfif int_Agent.php_insurance_typeid LTE 1><input type="checkbox" name="insurance_check" disabled><cfelse><input type="checkbox" name="insurance_check" checked disabled></cfif></td>
                        <td align="left" colspan="2"><cfif int_Agent.php_insurance_typeid EQ 0> <font color="FF0000">Insurance Information is missing</font>
                            <cfelseif int_Agent.php_insurance_typeid EQ 1> Does not take Insurance Provided by #CLIENT.companyshort#
                            <cfelse> Takes Insurance Provided by PHP</cfif>
                        </td>
                    </tr>
                    <tr>
                        <td><cfif int_Agent.php_insurance_typeid LTE 1><input type="checkbox" name="insurance_check" disabled><cfelse><input type="checkbox" name="insurance_check" checked disabled></cfif></td>
                        <td>Policy Type :</td>
                        <td><cfif int_Agent.php_insurance_typeid EQ 0>
                                <font color="FF0000">Missing Policy Type</font>
                            <cfelseif int_Agent.php_insurance_typeid EQ 1> n/a
                            <cfelse> #int_Agent.type#	</cfif>		
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" name="insured_date" disabled <Cfif qInsuranceInfo.recordcount> checked </cfif> ></td>
                        <td>Insured Date :</td>
                        <td>
                            <cfif int_Agent.php_insurance_typeid EQ 1> 
                                n/a
                            <cfelse>
                                <cfif qInsuranceInfo.recordcount>
                                    From #DateFormat(qInsuranceInfo.startDate, 'mm/dd/yyyy')# To #DateFormat(qInsuranceInfo.endDate, 'mm/dd/yyyy')#
                                <cfelse>
                                    not insured yet.
                                </cfif>
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td><Cfif insurancecanceldate is ''><input type="checkbox" name="insurance_Cancel" disabled><Cfelse><input type="checkbox" name="insurance_Cancel" checked disabled></cfif></td>
                        <td>Canceled on :</td>
                        <td><a href="javascript:OpenLetter('insurance/insurance_history.cfm?studentid=#studentid#');">#DateFormat(insurancecanceldate, 'mm/dd/yyyy')#</a></td></tr>
                    </tr>
                </table>
            </td>
            <td width="2%" valign="top">&nbsp;</td>
            <td width="49%" valign="top">
                <!----Host Family---->
                <table cellpadding="2" width="100%" bgcolor=##ffffff class=box>
                    <tr bgcolor="##C2D1EF"><td colspan="3"><span class="get_attention"><b>:: </b>Host Family</span></td></tr>
                    <Cfif get_student_unqid.hostid EQ 0>
                        <tr><td>Host Family is not assigned. Please go to the placement management to place this student.<br /><br /><br /><br /></td></tr>
                    <cfelse>
                        <cfquery name="host_info" datasource="mysql">
                            SELECT hostid, familylastname, fatherfirstname, motherfirstname, address, address2, city, state,zip
                            FROM smg_hosts
                            WHERE hostid = '#get_student_unqid.hostid#'
                        </cfquery>
                        <tr><td><a href="index.cfm?curdoc=host_fam_info&hostid=#host_info.hostid#" target="_blank">#host_info.fatherfirstname# <cfif host_info.fatherfirstname is not ''>&</cfif> #host_info.motherfirstname# #host_info.familylastname# (###host_info.hostid#)</a><br />
                                #host_info.address#<br />
                                <cfif address2 is not ''>#host_info.address2#<br /></cfif>
                                #host_info.city# #host_info.state#, #host_info.zip#
                        </td></tr>
                    </Cfif>
                </table>
            </td>
        </tr>
    </table><br />

    <table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
        <tr>
            <td width="49%" valign="top">
                <!--- Cancelation --->
                <table cellpadding="2" width="100%" bgcolor=##ffffff class=box>
                    <tr bgcolor="##C2D1EF"><td colspan="3"><span class="get_attention"><b>:: </b>Cancelation</span></td></tr>
                    <tr>
                        <td width="10"><Cfif canceldate is ''> <input type="checkbox" name="student_cancel" OnClick="CheckDates('student_cancel', 'date_canceled');" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="student_cancel" OnClick="CheckDates('student_cancel', 'date_canceled');" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif></td>
                        <td colspan="2">Program Cancelled  &nbsp; &nbsp; &nbsp; &nbsp; Date: &nbsp; <input type="text" name="date_canceled" size=8 value="#DateFormat(canceldate, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>Reason:</td>
                        <td><input type="text" name="Reason_canceled" size="30" value="#cancelreason#" <cfif edit EQ 'no'>readonly</cfif>></td>
                    </tr>
                </table>	
                <br />
                <!---Letters--->
                <table cellpadding="2" width="100%" bgcolor=##ffffff class=box>
                    <tr bgcolor="##C2D1EF"><td colspan="2"><span class="get_attention"><b>:: </b>Letters &nbsp; &nbsp; [  <font size=-3>printing tips</font> ]</span></td></tr>
                    <tr>
                        <td width="50%">: : <a href="reports/letter_app_cover.cfm?unqid=#get_student_unqid.uniqueID#&assignedid=#get_student_unqid.assignedid#" target="_blank">Application Cover Letter</a></td>
                        <td width="50%">: : <a href="reports/letter_acceptance.cfm?unqid=#get_student_unqid.uniqueID#&assignedid=#get_student_unqid.assignedid#" target="_blank">Acceptance</a></td>
                    </tr>
                    <tr>
                        <td width="50%">
                            <cfif VAL(get_student_unqid.hostID)>
                                : : <a href="student/index.cfm?action=placementInfoSheetDay&uniqueID=#get_student_unqid.uniqueID#&assignedID=#get_student_unqid.assignedID#" class="jQueryModal">Placement Day</a>
                            <cfelse>
                                : : <a href="student/index.cfm?action=placementInfoSheetBoard&uniqueID=#get_student_unqid.uniqueID#&assignedID=#get_student_unqid.assignedID#" class="jQueryModal">Placement Board</a>
                            </cfif>
                        </td>
                        <td width="50%">: : <a href="student/index.cfm?action=printFlightInformation&uniqueID=#get_student_unqid.uniqueID#&programID=#get_student_unqid.programID#">Flight Information</a></td>
                    </tr>
                    <tr>
                        <td width="50%">: : <a href="reports/letter_hf_welcome.cfm?unqid=#get_student_unqid.uniqueID#&assignedid=#get_student_unqid.assignedid#" target="_blank">Host Family Welcome Letter</a></td>
                        <td width="50%">: : <a href="reports/letter_student_arrival.cfm?unqid=#get_student_unqid.uniqueID#&assignedid=#get_student_unqid.assignedid#" target="_blank">Student Arrival Letter</a></td>
                    </tr>
                    <tr>
                    	<cfif #get_student_unqid.return_student# EQ 1 AND #get_student_unqid.active# EQ 1 AND #get_student_unqid.canceledBy# EQ 0>
                        <td width="50%">: : <a href="reports/returning_student_letter.cfm?studentid=#get_student_unqid.studentid#&programid=#get_student_unqid.programid#" target="_blank">Return Student Letter</a></td>
                        </cfif>
                    </tr>
                </table>
            </td>
            <td width="2%" valign="top">&nbsp;</td>
            <td width="49%" valign="top">
                <!----I20 Form---->
                <table cellpadding="2" width="100%" bgcolor=##ffffff class=box>
                    <tr bgcolor="##C2D1EF"><td colspan="3"><span class="get_attention"><b>:: </b>Form I-20</span></td></tr>				
                    <tr>	
                        <td>
                            <Cfif i20received EQ ''>
                                <input type="checkbox" name="i20received_box" onClick="CheckDates('i20received_box', 'i20received')" <cfif edit EQ 'no'>disabled</cfif>> 
                            <cfelse> 
                                <input type="checkbox" name="i20received_box" onClick="CheckDates('i20received_box', 'i20received')" checked <cfif edit EQ 'no'>disabled</cfif>> 
                            </cfif>
                        </td>
                        <td>I-20 Received &nbsp; &nbsp; Date: &nbsp; <input type="text" name="i20received" size=8 value="#DateFormat(i20received, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
                    </tr>
                    <tr>	
                        <td>
                            <Cfif i20sent EQ ''>
                                <input type="checkbox" name="i20sent_box" onClick="CheckDates('i20sent_box', 'i20sent')" <cfif edit EQ 'no'>disabled</cfif>> 
                            <cfelse> 
                                <input type="checkbox" name="i20sent_box" onClick="CheckDates('i20sent_box', 'i20sent')" checked <cfif edit EQ 'no'>disabled</cfif>> 
                            </cfif>
                        </td>
                        <td>I-20 Sent &nbsp; &nbsp; Date: &nbsp;  <input type="text" name="i20sent" size=8 value="#DateFormat(i20sent, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
                    </tr>
                    <tr><td>&nbsp;</td>	
                        <td>I-20 no.: &nbsp;<input type="text" name="i20no" size=12 value="#i20no#" maxlength="12" <cfif edit EQ 'no'>readonly</cfif>></td>
                    </tr>
                    <tr>
                        <Td valign="top">Notes:</Td><td> <textarea cols="20" rows="3" name="i20note" <cfif edit EQ 'no'>readonly</cfif>>#i20note#</textarea></Td>
                </table>
                <br />
            <!----Flight Info Form---->
                <table cellpadding="2" width="100%" bgcolor=##ffffff class=box>
                    <tr bgcolor="##C2D1EF"><td colspan="3"><span class="get_attention"><b>:: </b>Flight Info</span></td></tr>				
                    <tr>	
                        <td>
                            <Cfif flightinfo_sent EQ ''>
                                <input type="checkbox" name="flightinfo_sent_box" onClick="CheckDates('flighinfo_sent_box', 'flightinfo_sent')" <cfif edit EQ 'no'>disabled</cfif>> 
                            <cfelse> 
                                <input type="checkbox" name="flightinfo_sent_box" onClick="CheckDates('flightinfo_sent_box', 'flightinfo_sent')" checked <cfif edit EQ 'no'>disabled</cfif>> 
                            </cfif>
                        </td>
                        <td>Flight Info Sent &nbsp; &nbsp; Date: &nbsp; <input type="text" name="flightinfo_sent" size=8 value="#DateFormat(flightinfo_sent, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
                    </tr>
                    <tr>	
                        <td>
                            <Cfif flightinfo_received EQ ''>
                                <input type="checkbox" name="flightinfo_received_box" onClick="CheckDates('flightinfo_received_box', 'flightinfo_received')" <cfif edit EQ 'no'>disabled</cfif>> 
                            <cfelse> 
                                <input type="checkbox" name="flightinfo_received_box" onClick="CheckDates('flightinfo_received_box', 'flightinfo_received')" checked <cfif edit EQ 'no'>disabled</cfif>> 
                            </cfif>
                        </td>
                        <td>Flight Info AR &nbsp; &nbsp; Date: &nbsp;  <input type="text" name="flightinfo_received" size=8 value="#DateFormat(flightinfo_received, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
                    </tr>
                    <tr><td>&nbsp;</td>	
                        <td>Flight##: &nbsp;<input type="text" name="flightinfo_no" size=12 value="#flightinfo_no#" maxlength="12" <cfif edit EQ 'no'>readonly</cfif>></td>
                    </tr>
                    <tr>
                        <Td valign="top">Notes:</Td><td> <textarea cols="20" rows="3" name="flighinfo_note" <cfif edit EQ 'no'>readonly</cfif>>#flightinfo_note#</textarea></Td>
                </table>
            </td>	
        </tr>
    </table><br />
    
    <table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
        <tr>
            <td width="49%" valign="top"></td>
            <td width="2%" valign="top">&nbsp;</td>
            <td width="49%" valign="top"></td>	
        </tr>
    </table><br />
</div>

<!--- UPDATE BUTTON --->
<cfif edit NEQ 'no'>
    <table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
        <tr>
            <td align="center"><input name="Submit" type="image" src="pics/update.gif" alt="Update Profile"  border=0></td>
        </tr>
    </table>
</cfif>

</form>
		
<!---- EDIT BUTTON - OFFICE USERS ---->
<cfif ListFind("1,2,3,4", CLIENT.usertype) AND edit EQ 'no'>
    <table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
    <tr><td align="center">
        <form action="?curdoc=student/student_info&unqid=#get_student_unqid.uniqueID#&assignedid=#get_student_unqid.assignedid#" method="post">&nbsp;
            <input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0>
        </form>
    </td></tr>
    </table>
</cfif> 

<script>
	// hide field reason (changing program)
	document.getElementById('program_history').style.display = 'none';
</script>

</cfoutput>