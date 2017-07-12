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
            p.no_semesters
    FROM smg_students s
    LEFT JOIN smg_countrylist c ON (c.countryID = s.countryresident)
    LEFT JOIN smg_hosts h ON (h.hostID = s.hostID)
    LEFT JOIN smg_hosthistory hh ON (hh.studentid = s.studentid AND hh.hostid = s.hostid AND hh.isActive = 1)
    LEFT JOIN smg_users u ON (hh.areaRepID = u.userid)
    LEFT JOIN smg_schools sc ON (sc.schoolID = hh.schoolID)
    LEFT JOIN smg_school_dates scd ON (scd.schoolID = s.schoolID AND seasonID = #qCurrentSeason.SeasonID#)
    LEFT JOIN smg_programs p ON (s.programID = p.programID)
    WHERE s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentID#">
    LIMIT 1
</cfquery>

<cfcontent type="application/pdf">
<cfheader name="Content-Disposition" value="attachment;filename=SAF_#get_form_data.student_lastname#(#URL.studentID#)_#DATEFORMAT(NOW(), 'MMDDYYYY')#.pdf">

<cfquery name="get_school_contacts" datasource="#application.dsn#">
    SELECT smg_school_contacts.id, ssct.name AS title, smg_school_contacts.name, email, phone, show_on_saf, smg_school_contacts.title AS title_id
        FROM smg_school_contacts 
        LEFT JOIN smg_school_contact_titles ssct ON (ssct.id = smg_school_contacts.title)
        WHERE school_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_form_data.schoolid#">
            AND smg_school_contacts.active = '1'
            AND smg_school_contacts.show_on_saf = 1
        ORDER BY smg_school_contacts.id ASC
</cfquery>

<cfdocument format="pdf" pagetype="letter" marginbottom="0" margintop="0" marginleft="0" marginright="0">
    <style>
        h1 {
            font-family: Arial;
            font-size: 54pt;
            text-align: center;
            float:left;
            width: 50%;
            margin-top:50pt;
        }
        .titles {
            color: #235c92;
            font-size: 28pt;
            text-align: center;
            font-family: Arial;
            font-weight: bold;
        }        }
        p, table, tr, td {
            font-family: Arial;
            font-size: 26pt;
            line-height: 38pt;
        }
        .filled_data {
            font-family: Verdana;
            font-size: 26pt;
            border-bottom: 1px solid #333;
            width: 100%
        }
    </style>


    <div style="margin:50pt">
        <img src="http://ise.exitsdev.com/nsmg/pics/school_acceptance_form/ISE-logo.png" style="float:left; margin:30pt 0 0 30pt" />
        <h1>School Acceptance Form</h1>
        <p style="float:right; width:20%;">36 Park Ave<br />
            Bay Shore, NY 11706<br />
            Ph: 800-766-4656<br />
            Fax: 631-635-1095</p>
    </div>

    <br clear="all" />

    <img src="http://ise.exitsdev.com/nsmg/pics/school_acceptance_form/color-line.png" />

    <div style="color:#999; float:right; font-size:20pt; margin:15px 25px 0 0">
        A-1
    </div>

    <br clear="all" />

    <cfoutput>
        <div style="margin:0pt 75pt 0pt 75pt">
            <img src="http://ise.exitsdev.com/nsmg/pics/school_acceptance_form/CSIET.png" style="float:left" />    

            <div style="float:right; width: 75%">
                <p style="text-align: justify;">Dear School Administrator:</p>
                <p style="text-align: justify;">As an Area Representative, I am seeking your permission for the student described belot to attend your high school in a full course of study. It is our policy to obtain written school acceptance prior to the student's arrival from a school taht is duly recognized as an accredited educational institution and declared as such by the appropriate authority of the state in which such institution is located. Our organization is granted full listing by the CSIET and we are empowered to issue a DS-02019 to secure a J-1 Exchange Visitor Visa for this student. We thank you for your willingness to accept out international student and hope you have an enjoyable year.
                </p>
            </div>

            <br clear="all" />


            <div style="background-image: url(http://ise.exitsdev.com/nsmg/pics/school_acceptance_form/header_bg.png); width: 100%; text-align: center; margin-top: 35pt; height: 15pt;">
                <span style="background-color: ##fff" class="titles">&nbsp; &nbsp; AREA REPRESENTATIVE &nbsp; &nbsp;</span>
            </div>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="200">Name: </td>
                    <td colspan="3">
                        <div class="filled_data">
                                #TRIM(get_form_data.firstname)# #TRIM(get_form_data.lastname)# &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Address: </td>
                    <td colspan="3">
                        <div class="filled_data">
                            <cfif LEN(get_form_data.address)>#TRIM(get_form_data.address)#</cfif><cfif LEN(get_form_data.address2)> #TRIM(get_form_data.address2)#</cfif><cfif LEN(get_form_data.city)>, #TRIM(get_form_data.city)#</cfif><cfif LEN(get_form_data.state)>, #TRIM(get_form_data.state)#</cfif><cfif LEN(get_form_data.zip)>, #TRIM(get_form_data.zip)#</cfif>
                            &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        Telephone: 
                    </td>
                    <td><div class="filled_data">
                        <cfif LEN(get_form_data.phone)>
                            #TRIM(get_form_data.phone)#
                        <cfelse>
                            #TRIM(get_form_data.cell_phone)#
                        </cfif>
                        &nbsp;
                        </div>
                    </td>
                    <td width="150" style="text-align: right">
                        Email:
                    </td>
                    <td width="900"><div class="filled_data">
                        #TRIM(get_form_data.email)# &nbsp;
                        </div>
                    </td>
                </tr>
            </table>


            <div style="background-image: url(http://ise.exitsdev.com/nsmg/pics/school_acceptance_form/header_bg.png); width: 100%; text-align: center; margin-top: 35pt; height: 15pt;">
                <span style="background-color: ##fff" class="titles">&nbsp; &nbsp; STUDENT &nbsp; &nbsp;</span>
            </div>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="200">
                        Name: 
                    </td>
                    <td>
                        <div class="filled_data">
                            #TRIM(get_form_data.student_firstname)# #TRIM(get_form_data.student_lastname)# &nbsp;
                        </div>
                    </td>
                    <td width="250" style="text-align: right;">
                        Student ID ##: 
                    </td>
                    <td width="400">
                        <div class="filled_data">
                            #get_form_data.studentID#
                            &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        Country: 
                    </td>
                    <td colspan="3">
                        <div class="filled_data">#TRIM(get_form_data.student_country)# &nbsp;</div>
                    </td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="900">
                        Last Grade Completed in Home Country Upon Arrival: 
                    </td>
                    <td>
                        <div class="filled_data">
                            #get_form_data.grades# &nbsp;
                        </div>
                    </td>
                    <td width="250" style="text-align:right">
                        Birth Date: 
                    </td>
                    <td width="400">
                        <div class="filled_data">
                            #DATEFORMAT(get_form_data.student_dob, 'mm/dd/yyyy')# &nbsp;
                        </div>
                    </td>
                </tr>
            </table>


            <div style="background-image: url(http://ise.exitsdev.com/nsmg/pics/school_acceptance_form/header_bg.png); width: 100%; text-align: center; margin-top: 35pt; height: 15pt;">
                <span style="background-color: ##fff" class="titles">&nbsp; &nbsp; HOST FAMILY &nbsp; &nbsp;</span>
            </div>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="200">
                        Name:
                    </td>
                    <td colspan="3">
                        <div class="filled_data">
                            <cfif get_form_data.primaryHostParent EQ 'father'>
                                #TRIM(get_form_data.host_fatherfirstname)# #TRIM(get_form_data.host_fatherlastname)#
                                <cfif LEN(get_form_data.host_motherfirstname) OR LEN(get_form_data.host_motherlastname)>
                                     and 
                                </cfif>
                            <cfelse>
                                #TRIM(get_form_data.host_motherfirstname)# #TRIM(get_form_data.host_motherlastname)#
                                <cfif LEN(get_form_data.host_fatherfirstname) OR LEN(get_form_data.host_fatherlastname)>
                                     and 
                                </cfif>
                            </cfif>
                            
                            <cfif get_form_data.primaryHostParent EQ 'father'>
                                #TRIM(get_form_data.host_motherfirstname)# #TRIM(get_form_data.host_motherlastname)#
                            <cfelse>
                                #TRIM(get_form_data.host_fatherfirstname)# #TRIM(get_form_data.host_fatherlastname)#
                            </cfif>
                            &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        Address: 
                    </td>
                    <td colspan="3">
                        <div class="filled_data">
                            <cfif LEN(get_form_data.host_address)>#TRIM(get_form_data.host_address)#</cfif><cfif LEN(get_form_data.host_address2)> #TRIM(get_form_data.host_address2)#</cfif><cfif LEN(get_form_data.host_city)>, #TRIM(get_form_data.host_city)#</cfif><cfif LEN(get_form_data.host_state)>, #TRIM(get_form_data.host_state)#</cfif><cfif LEN(get_form_data.host_zip)>, #TRIM(get_form_data.host_zip)#</cfif>
                            &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        Telephone: 
                    </td>
                    <td>
                        <div class="filled_data">
                            #TRIM(get_form_data.host_phone)# &nbsp;
                        </div>
                    </td>
                    <td width="150" style="text-align: right">
                        Email: 
                    </td>
                    <td width="900">
                        <div class="filled_data">
                            #TRIM(get_form_data.host_email)# &nbsp;
                        </div>
                    </td>
                </tr>
            </table>

            <div style="background-image: url(http://ise.exitsdev.com/nsmg/pics/school_acceptance_form/header_bg.png); width: 100%; text-align: center; margin-top: 35pt; height: 15pt;">
                <span style="background-color: ##fff" class="titles">&nbsp; &nbsp; HIGH SCHOOL &nbsp; &nbsp;</span>
            </div>

            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="200">Name: </td>
                    <td colspan="3">
                        <div class="filled_data">
                            #TRIM(get_form_data.schoolname)# &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Address: </td>
                    <td colspan="3">
                        <div class="filled_data">
                            <cfif LEN(get_form_data.school_address)>#TRIM(get_form_data.school_address)#</cfif><cfif LEN(get_form_data.school_address2)> #TRIM(get_form_data.school_address2)#</cfif><cfif LEN(get_form_data.school_city)>, #TRIM(get_form_data.school_city)#</cfif><cfif LEN(get_form_data.school_state)>, #TRIM(get_form_data.school_state)#</cfif><cfif LEN(get_form_data.school_zip)>, #TRIM(get_form_data.school_zip)#</cfif>
                            &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Telephone:</td>
                    <td>
                        <div class="filled_data">
                            #TRIM(get_form_data.school_phone)# &nbsp;
                        </div>
                    </td>
                    <td width="150" style="text-align: right">Fax: </td>
                    <td width="900">
                        <div class="filled_data">
                            #TRIM(get_form_data.school_fax)# &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Contact(s):</td>
                    <td colspan="3">
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
                    <td colspan="3">
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
            <table cellpadding="0" cellspacing="4" width="100%" >
                <tr>
                    <td width="730">Number of semesters our student will attend: </td>
                    <td ><div class="filled_data"><cfif VAL(get_form_data.no_semesters)>#get_form_data.no_semesters#</cfif>&nbsp;</div></td>
                    <td width="660" style="text-align: right">Eligible for graduation/receive diploma? </td>
                    <td width="600">
                        <div style="width:20pt; height: 20pt; border:1px solid ##000;float:left; line-height: 26pt; text-align: center; margin-left:10pt">&nbsp;</div> 
                        <span style="float:left;">Yes &nbsp; </span>
                        <div style="width:20pt; height: 20pt; border:1px solid ##000;float:left; line-height: 26pt; text-align: center">&nbsp;</div> 
                        <span style="float:left">No</span>
                    </td>
                </tr>
            </table>

            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="350">School Year Begins: </td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.year_begins, 'mm/dd/yyyy')# &nbsp;</div></td>
                    <td width="350" style="text-align: right">First Semester Ends: </td>
                    <td width="600"><div class="filled_data">#DATEFORMAT(get_form_data.semester_ends, 'mm/dd/yyyy')# &nbsp;</div></td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="450">Second Semester Begins: </td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.semester_begins, 'mm/dd/yyyy')# &nbsp;</div></td>
                    <td width="350" style="text-align: right">Year Ends: </td>
                    <td width="600"><div class="filled_data">#DATEFORMAT(get_form_data.year_ends, 'mm/dd/yyyy')# &nbsp;</div></td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="4" width="100%">
                <tr>
                    <td width="450">School Orientation Date:</td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.enrollment, 'mm/dd/yyyy')# &nbsp;</div></td>
                    <td width="350" style="text-align: right">Required: </td>
                    <td width="600">
                        <div style="width:20pt; height: 20pt; border:1px solid ##000;float:left; line-height: 26pt; text-align: center; margin-left:10pt">
                            <cfif get_form_data.orientation_required EQ 1>
                                X
                            <cfelse>
                                &nbsp;
                            </cfif>
                        </div> 
                        <span style="float:left;">Yes &nbsp; </span>
                        <div style="width:20pt; height: 20pt; border:1px solid ##000;float:left; line-height: 26pt; text-align: center">
                            <cfif get_form_data.orientation_required EQ 0>
                                X
                            <cfelse>
                                &nbsp;
                            </cfif>
                        </div> 
                        <span style="float:left">No</span>
                    </td>
                </tr>
            </table>

            <p style="text-align: center; margin-top:45pt"><strong>By signing below, I confirm that the above named student will be enrolled in a full course of study.</strong></p>

            <cfif get_school_contacts.recordCount GT 2>
                <div style="padding-top:80pt">
            <cfelse>
            <div style="padding-top:120pt">
            </cfif>
                <div style="border-top: 1px solid ##000; width:65%; float:left; text-align: center;font-size: 25pt; font-family: Arial; padding-top: 5pt">
                    Signature of School Administrator &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  Title
                </div>

                <div style="border-top: 1px solid ##000; width:30%; float:right; text-align: center;font-size: 25pt; font-family: Arial; padding-top: 5pt">
                    Date (mm/dd/yyyy)
                </div>
            </div>

        </div>

        <br clear="all"/>

        <div style="background-color: ##235c92; padding:10pt; text-align:center; color:##fff; font-size: 28pt; font-family: Arial; bottom:0; position:absolute; width: 100%">
            iseusa.org
        </div>
    </cfoutput>
</cfdocument>