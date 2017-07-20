<cfscript>
    qCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason();
</cfscript>

<cfquery name="get_form_data" datasource="#application.dsn#">
    SELECT s.studentID, u.firstname, u.lastname, u.address, u.address2, u.city, u.state, u.zip, u.phone, u.cell_phone, 
            u.email, s.firstname AS student_firstname, s.familylastname AS student_lastname, 
            c.countryname AS student_country, s.phone AS student_phone, 
            s.email AS student_email, h.fatherlastname AS host_fatherlastname, h.fatherfirstname AS host_fatherfirstname, 
            h.motherlastname AS host_motherlastname, h.motherfirstname AS host_motherfirstname, h.primaryHostParent, 
            h.address AS host_address, h.address2 AS host_address2, h.city AS host_city, h.state AS host_state, 
            h.zip AS host_zip, h.phone AS host_phone, h.email AS host_email, sc.schoolname, sc.address AS school_address, 
            sc.address2 AS school_address2, sc.city AS school_city, sc.state AS school_state, sc.zip AS school_zip, 
            sc.phone AS school_phone, sc.fax AS school_fax, scd.year_begins, scd.semester_ends, scd.semester_begins, 
            scd.year_ends, scd.enrollment, scd.orientation_required, s.schoolID, s.grades, s.dob AS student_dob,
            p.no_semesters, s.hostID, sc.url, sc.tuition
    FROM smg_students s
    LEFT JOIN smg_countrylist c ON (c.countryID = s.countryresident)
    LEFT JOIN smg_hosts h ON (h.hostID = s.hostID)
    LEFT JOIN smg_hosthistory hh ON (hh.studentid = s.studentid AND hh.hostid = s.hostid AND hh.isActive = 1)
    LEFT JOIN smg_users u ON (hh.areaRepID = u.userid)
    LEFT JOIN smg_schools sc ON (sc.schoolID = hh.schoolID)
    LEFT JOIN smg_programs p ON (s.programID = p.programID)
    LEFT JOIN smg_school_dates scd ON (scd.schoolID = s.schoolID AND scd.seasonID = p.SeasonID)
    WHERE s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentID#">
    LIMIT 1
</cfquery>

<cfif NOT VAL(get_form_data.hostID)>
    <cfquery name="get_form_data" datasource="#application.dsn#">
        SELECT s.studentID, u.firstname, u.lastname, u.address, u.address2, u.city, u.state, u.zip, u.phone, u.cell_phone, 
                u.email, s.firstname AS student_firstname, s.familylastname AS student_lastname, 
                c.countryname AS student_country, s.phone AS student_phone, 
                s.email AS student_email, h.fatherlastname AS host_fatherlastname, h.fatherfirstname AS host_fatherfirstname, 
                h.motherlastname AS host_motherlastname, h.motherfirstname AS host_motherfirstname, h.primaryHostParent, 
                h.address AS host_address, h.address2 AS host_address2, h.city AS host_city, h.state AS host_state, 
                h.zip AS host_zip, h.phone AS host_phone, h.email AS host_email, sc.schoolname, sc.address AS school_address, 
                sc.address2 AS school_address2, sc.city AS school_city, sc.state AS school_state, sc.zip AS school_zip, 
                sc.phone AS school_phone, sc.fax AS school_fax, scd.year_begins, scd.semester_ends, scd.semester_begins, 
                scd.year_ends, scd.enrollment, scd.orientation_required, sc.schoolID, s.grades, s.dob AS student_dob,
                p.no_semesters, sc.url, sc.tuition
        FROM smg_students s
        LEFT JOIN smg_student_hold_status shs ON (s.studentID = shs.student_id)
        LEFT JOIN smg_hosts h ON (h.hostID = shs.host_family_id)
        LEFT JOIN smg_countrylist c ON (c.countryID = s.countryresident)
        LEFT JOIN smg_users u ON (u.userid = shs.area_rep_id)
        LEFT JOIN smg_schools sc ON (sc.schoolID = shs.school_id)
        LEFT JOIN smg_programs p ON (s.programID = p.programID)
        LEFT JOIN smg_school_dates scd ON (scd.schoolID = shs.school_id AND scd.seasonID = p.SeasonID)
        WHERE s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentID#">
        ORDER BY id DESC
        LIMIT 1
    </cfquery>
</cfif>

<cfcontent type="application/pdf">
<cfheader name="Content-Disposition" value="attachment;filename=SAF_#get_form_data.student_lastname#(#URL.studentID#)_#DATEFORMAT(NOW(), 'MMDDYYYY')#.pdf">

<cfquery name="get_school_contacts" datasource="#application.dsn#">
    SELECT smg_school_contacts.id, ssct.name AS title, smg_school_contacts.name, email, phone, show_on_saf, smg_school_contacts.title AS title_id
        FROM smg_school_contacts 
        LEFT JOIN smg_school_contact_titles ssct ON (ssct.id = smg_school_contacts.title)
        WHERE school_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_form_data.schoolid)#">
            AND smg_school_contacts.active = '1'
            AND smg_school_contacts.show_on_saf = 1
        ORDER BY smg_school_contacts.id ASC
</cfquery>

<cfdocument format="pdf" pagetype="letter" marginbottom="0" margintop="0" marginleft="0" marginright="0">
    <style>
        h1 {
            font-family: Arial;
            font-size: 18pt;
            text-align: center;
            float:right;
            width: 70%;
            margin-top:30pt;
        }
        .titles {
            color: #000;
            font-size: 12pt;
            text-align: left;
            font-family: Arial;
            font-weight: bold;
        }        }
        p, table, tr, td {
            font-family: Arial;
            font-size: 9pt;
            line-height: 15pt;
        }
        .filled_data {
            font-family: Verdana;
            font-size: 10pt;
            border-bottom: 1px solid #333;
            width: 100%
        }
    </style>


    <div style="margin:0 20pt">
        <img src="http://ise.exitsdev.com/nsmg/pics/school_acceptance_form/DASH-logo.png" style="float:left; margin:5pt 0 0 5pt; width: 100pt" />
        <div style="color:#999; float:right; font-size:9pt; margin:5px 10px 0 0">
            A-1
        </div>
        <h1>DASH PROGRAM<br />SCHOOL ACCEPTANCE FORM</h1>
    </div>

    <br clear="all" />

    <cfoutput>
        <div style="margin:30pt 20pt 0pt 20pt">   

            <div class="titles" style="margin:10px 0">STUDENT INFORMATIOM</div>

            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="50">
                        Name: 
                    </td>
                    <td colspan="3">
                        <div class="filled_data">
                            #TRIM(get_form_data.student_firstname)# #TRIM(get_form_data.student_lastname)# &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        Country: 
                    </td>
                    <td>
                        <div class="filled_data">#TRIM(get_form_data.student_country)# &nbsp;</div>
                    </td>
                    <td width="90" style="text-align: right;">
                        Student ID ##: 
                    </td>
                    <td width="150">
                        <div class="filled_data">
                            #get_form_data.studentID#
                            &nbsp;
                        </div>
                    </td>
                </tr>
                
            </table>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="130">
                        Last Grade Completed: 
                    </td>
                    <td>
                        <div class="filled_data">
                            #get_form_data.grades# &nbsp;
                        </div>
                    </td>
                    <td width="100" style="text-align:right">
                        Entering Grade: 
                    </td>
                    <td >
                        <div class="filled_data">
                             &nbsp;
                        </div>
                    </td>
                    <td width="70" style="text-align:right">
                        Birth Date: 
                    </td>
                    <td width="150">
                        <div class="filled_data">
                            #DATEFORMAT(get_form_data.student_dob, 'mm/dd/yyyy')# &nbsp;
                        </div>
                    </td>
                </tr>
            </table>

            <div style="background-color: ##000; height:10px; width: 100%; line-height: 10px;; margin-top:20px">&nbsp;</div>

            <br clear="all" />

            
            <div style="background-color: ##fff; margin:30px 0 10px 0" class="titles">SCHOOL INFORMATION</div>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="70">Name: </td>
                    <td colspan="5">
                        <div class="filled_data">
                            #TRIM(get_form_data.schoolname)# &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Address: </td>
                    <td colspan="5">
                        <div class="filled_data">
                            <cfif LEN(get_form_data.school_address)>#TRIM(get_form_data.school_address)#</cfif><cfif LEN(get_form_data.school_address2)> #TRIM(get_form_data.school_address2)#</cfif><cfif LEN(get_form_data.school_city)>, #TRIM(get_form_data.school_city)#</cfif><cfif LEN(get_form_data.school_state)>, #TRIM(get_form_data.school_state)#</cfif><cfif LEN(get_form_data.school_zip)>, #TRIM(get_form_data.school_zip)#</cfif>
                            &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Telephone:</td>
                    <td width="120">
                        <div class="filled_data">
                            #TRIM(get_form_data.school_phone)# &nbsp;
                        </div>
                    </td>
                    <td width="70" style="text-align: right">Fax: </td>
                    <td width="120">
                        <div class="filled_data">
                            #TRIM(get_form_data.school_fax)# &nbsp;
                        </div>
                    </td>
                    <td width="70" style="text-align: right">Website: </td>
                    <td >
                        <div class="filled_data">
                            #TRIM(get_form_data.url)# &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Contact(s):</td>
                    <td colspan="5">
                        <div class="filled_data">
                            <cfset i = 0/>
                            <cfloop query="get_school_contacts" >
                                <cfif i GT 0> /</cfif> #get_school_contacts.name#<cfif LEN(get_school_contacts.title)>, #get_school_contacts.title#</cfif> 
                                <cfset i = i+1 />
                            </cfloop>
                            &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td colspan="5">
                        <div class="filled_data">
                            <cfset emailShown = false />
                            <cfloop query="get_school_contacts" >
                                <cfif NOT emailShown>
                                    <cfif LEN(get_school_contacts.email)>#get_school_contacts.email#</cfif>
                                    <cfset emailShown = true />
                                </cfif>
                            </cfloop>
                            &nbsp;
                        </div>
                    </td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="100">School Tuitions:</td>
                    <td >
                        <div class="filled_data">
                            <cfif VAL(get_form_data.tuition)>
                                #get_form_data.tuition# 
                            </cfif>
                            &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Additional Fees:</td>
                    <td>
                        <div class="filled_data">
                            &nbsp;
                        </div>
                    </td>
                </tr>
            </table>

            <br clear="all" />


            <div style="background-color: ##fff; font-family: Arial; font-size:12pt; margin:20px 0 10px 0" ><u>School Dates</u></div>

            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="120">Student Orientation:</td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.enrollment, 'mm/dd/yyyy')# &nbsp;</div></td>
                    <td width="150" style="text-align: right">Student should arrive on: </td>
                    <td width="170"><div class="filled_data">#DATEFORMAT(get_form_data.enrollment, 'mm/dd/yyyy')# &nbsp;</div></td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="120">School Begins: </td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.year_begins, 'mm/dd/yyyy')# &nbsp;</div></td>
                    <td width="150" style="text-align: right">1st Semester Ends: </td>
                    <td width="170"><div class="filled_data">#DATEFORMAT(get_form_data.semester_ends, 'mm/dd/yyyy')# &nbsp;</div></td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="120">2nd Semester Begins: </td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.semester_begins, 'mm/dd/yyyy')# &nbsp;</div></td>
                    <td width="150" style="text-align: right">Year Ends: </td>
                    <td width="170"><div class="filled_data">#DATEFORMAT(get_form_data.year_ends, 'mm/dd/yyyy')# &nbsp;</div></td>
                </tr>
            </table>
            



            <p style="text-align: justify; margin-top:25pt">The School agrees all Visa documents and tuition invoices for the above mentioned student will be forwarded in a timely manner to: DASH National Office, 36 Park Avenue, Bay Shore NY 11706, and Attn: Diana DeClemente</p>

            <p style="text-align: justify; ">The School also agrees that any student wishing to stay for multiple years will be required to return through the DASH Program.</p>

            <p style="text-align: justify; ">Unless otherwise noted, tuition payment will be made prior to the school start date as per the invoice provided by the school. By signing this, I agree I have received the full application and am accepting through our review process.</p>

            <div style="padding-top:60pt">

                <div style="border-top: 1px solid ##000; width:65%; float:left; text-align: center;font-size: 10pt; font-family: Arial; padding-top: 5pt">
                    Signature of School Official
                </div>

                <div style="border-top: 1px solid ##000; width:30%; float:right; text-align: center;font-size: 10pt; font-family: Arial; padding-top: 5pt">
                    Date (mm/dd/yyyy)
                </div>
            </div>

        </div>

    </cfoutput>
</cfdocument>