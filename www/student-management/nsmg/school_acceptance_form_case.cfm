<cfscript>
    qCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason();
</cfscript>

<cfquery name="get_form_data" datasource="#application.dsn#">
    SELECT s.studentID, u.firstname, u.lastname, u.address, u.address2, u.city, u.state, u.zip, u.phone, u.cell_phone, u.email,
            s.firstname AS student_firstname, s.familylastname AS student_lastname, c.countryname AS student_country, s.phone AS student_phone, 
            s.email AS student_email, h.fatherlastname AS host_fatherlastname, h.fatherfirstname AS host_fatherfirstname, 
            h.motherlastname AS host_motherlastname, h.motherfirstname AS host_motherfirstname, h.primaryHostParent, h.address AS host_address, 
            h.address2 AS host_address2, h.city AS host_city, h.state AS host_state, h.zip AS host_zip, h.phone AS host_phone, h.email AS host_email,
            sc.schoolname, sc.address AS school_address, sc.address2 AS school_address2, sc.city AS school_city, sc.state AS school_state, 
            sc.zip AS school_zip, sc.phone AS school_phone, sc.fax AS school_fax, sc.url AS school_website, scd.year_begins, scd.semester_ends, scd.semester_begins, 
            scd.year_ends, scd.enrollment, scd.orientation_required, s.schoolID, s.grades, s.dob AS student_dob
    FROM smg_students s
    LEFT JOIN smg_countrylist c ON (c.countryID = s.countryresident)
    LEFT JOIN smg_hosts h ON (h.hostID = s.hostID)
    LEFT JOIN smg_hosthistory hh ON (hh.studentid = s.studentid AND hh.hostid = s.hostid AND hh.isActive = 1)
    LEFT JOIN smg_users u ON (hh.areaRepID = u.userid)
    LEFT JOIN smg_schools sc ON (sc.schoolID = hh.schoolID)
    LEFT JOIN smg_school_dates scd ON (scd.schoolID = s.schoolID AND seasonID = #qCurrentSeason.SeasonID#)
    WHERE s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentID#">
    LIMIT 1
</cfquery>

<cfcontent type="application/pdf">
<cfheader name="Content-Disposition" value="attachment;filename=SAF_#get_form_data.student_lastname#(#URL.studentID#)_#DATEFORMAT(NOW(), 'MMDDYYYY')#.pdf">

<cfquery name="get_school_contacts" datasource="#application.dsn#">
    SELECT name, title, email, phone
    FROM smg_school_contacts
    WHERE school_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_form_data.schoolID#">
        AND active = 1
        AND show_on_saf = 1
</cfquery>

<cfdocument format="pdf" pagetype="letter" marginbottom="0.3" margintop="0.3" marginleft="0.3" marginright="0.3">
    <style>
        h1 {
            font-family: Arial;
            font-size: 18pt;
            text-align: center;
            margin:0pt;
            color:#06093f;
        }
        h2 {
            font-family: Arial;
            font-size: 15pt;
            text-align: center;
            margin:0pt;
            color: #a6a6a6;
        }
        .titles {
            color: #fff;
            font-size: 11pt;
            text-align: center;
            font-family: Arial;
            font-weight: bold;
        }        }
        p, table, tr, td {
            font-family: Arial;
            font-size: 7.5pt;
            line-height: 12pt;
        }
        .filled_data {
            font-family: Verdana;
            font-size: 8pt;
            border-bottom: 1px solid #333;
            width: 95%;
            float:left;
        }
    </style>


    <div style="margin:0pt">
        <div style="width:100%; height:6pt; background-color:#a6a6a6; float:left; line-height:6pt; text-align:center">
            &nbsp;
        </div>

        <img src="http://ise.exitsdev.com/nsmg/pics/school_acceptance_form/CASE-logo.png" style="float:left; margin:0pt; width:80pt" />

        <p style="float:right; width:20%; color: #a6a6a6; text-align: right; font-size: 8pt; line-height: 9pt; margin-top:15pt">211 Bellevue Ave., Suite 204<br />
            Montclair, NJ 07043<br />
            TF: 800.458.8336<br />
            P: 973.655.0193<br />
            F: 973.655.0194<br />
            www.case-usa.org</p>

        <div style="width:60%; float:right; text-align: center; margin-top:20pt">
            <h2>Cultural Academic Student Exchange</h2>
            <h1>HIGH SCHOOL ACCEPTANCE FORM</h1>
        </div>

    </div>

    <br clear="all" />

    <div style="width:100%; height:12pt; background-color:#06093f; float:left; line-height:12pt; text-align:center">
        &nbsp;
    </div>

    <div style="color:#999; float:right; font-size:5pt; margin:3px 5px 0 0">
        A-1
    </div>

    <br clear="all" />

    <cfoutput>
        <div style="margin:0pt;">  

            <div style="float:right; width: 49%; float:left">
                <p style="text-align: justify;">Dear School Administrator:</p>
                <p style="text-align: justify;">As an area representative, I am seeking your permission for the student listed to the right, to attend your high school in a full course of study. It is our policy to obtain written school acceptance prior to the student's arrival from a school that is duly recognized as an accredited institution and declared such by the appropriate authority of the state in which such institution is located. Our organization is granted full listing by the CSIET and is designated by the Department of State to issue a DS-2019 to secure a J-1 Exchange Visitor Visa for this student. We thank you for your willingness to accept our international student and hope you have an enjoyable year.
                </p>
            </div>

            <div style="float:right; width: 49%; float:right; border: 1px solid ##666; padding: 0">
                <div style="background-color:##06093f ;width: 100%; text-align: center; padding: 2pt; margin: 0">
                    <span class="titles">&nbsp; &nbsp; CASE STUDENT &nbsp; &nbsp;</span>
                </div>
                <table cellpadding="2" cellspacing="0" width="100%" style="margin:7pt 5pt 0 5pt">
                    <tr>
                        <td width="70">
                            Name: 
                        </td>
                        <td>
                            <div class="filled_data">
                                #TRIM(get_form_data.student_firstname)# #TRIM(get_form_data.student_lastname)# &nbsp;
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Student ID ##: 
                        </td>
                        <td>
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
                        <td >
                            <div class="filled_data">#TRIM(get_form_data.student_country)# &nbsp;</div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Birth Date: 
                        </td>
                        <td >
                            <div class="filled_data">
                                #DATEFORMAT(get_form_data.student_dob, 'mm/dd/yyyy')# &nbsp;
                            </div>
                        </td>
                    </tr>
                </table>
                <table cellpadding="2" cellspacing="0" width="100%" style="margin:0 5pt 7pt 5pt">
                    <tr>
                        <td width="270">
                            Last Grade Completed in Home Country Upon Arrival: 
                        </td>
                        <td>
                            <div class="filled_data" style="width:88% !important">
                                #get_form_data.grades# &nbsp;
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Number of Semesters student will attend in High School: 
                        </td>
                        <td>
                            <div class="filled_data" style="width:88% !important">
                                &nbsp;
                            </div>
                        </td>
                        
                    </tr>
                </table>

            </div>

            <br clear="all" />
            <br />

            <div style="float:right; width: 49%; float:left; border: 1px solid ##666; padding: 0">
                <div style="background-color:##06093f ;width: 100%; text-align: center; padding: 2pt; margin: 0">
                    <span class="titles">&nbsp; &nbsp; CASE AREA REPRESENTATIVE &nbsp; &nbsp;</span>
                </div>

                <table cellpadding="2" cellspacing="0" width="100%" style="margin:7pt 5pt 7pt 5pt">
                    <tr>
                        <td width="40">Name: </td>
                        <td>
                            <div class="filled_data">
                                    #TRIM(get_form_data.firstname)# #TRIM(get_form_data.lastname)# &nbsp;
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">Address: </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="filled_data" style="width: 96%">
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
                    </tr>
                    <tr>
                        <td>
                            Email:
                        </td>
                        <td><div class="filled_data">
                            #TRIM(get_form_data.email)# &nbsp;
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            

            <div style="float:right; width: 49%; float:right; border: 1px solid ##666; padding: 0">
                <div style="background-color:##06093f ;width: 100%; text-align: center; padding: 2pt; margin: 0">
                    <span class="titles">&nbsp; &nbsp; HOST FAMILY INFORMATION &nbsp; &nbsp;</span>
                </div>

                <table cellpadding="2" cellspacing="0" width="100%" style="margin:7pt 5pt 7pt 5pt">
                    <tr>
                        <td width="40">
                            Name:
                        </td>
                        <td>
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
                        <td colspan="2">
                            Address: 
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="filled_data" style="width: 96%">
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
                    </tr>
                    <tr>
                        <td >
                            Email: 
                        </td>
                        <td>
                            <div class="filled_data">
                                #TRIM(get_form_data.host_email)# &nbsp;
                            </div>
                        </td>
                    </tr>
                </table>
            </div>

            <br clear="all" />
            <br />

            <div style="background-color:##06093f ;width: 100%; text-align: center; padding: 2pt;">
                <span class="titles">&nbsp; &nbsp; HIGH SCHOOL INFORMATION &nbsp; &nbsp;</span>
            </div>

            <table cellpadding="2" cellspacing="0" width="100%" style="margin-top:7pt">
                <tr>
                    <td width="50">Name: </td>
                    <td colspan="3">
                        <div class="filled_data" style="width: 99%">
                            #TRIM(get_form_data.schoolname)# &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Address: </td>
                    <td colspan="3">
                        <div class="filled_data" style="width: 99%">
                            <cfif LEN(get_form_data.school_address)>#TRIM(get_form_data.school_address)#</cfif><cfif LEN(get_form_data.school_address2)> #TRIM(get_form_data.school_address2)#</cfif><cfif LEN(get_form_data.school_city)>, #TRIM(get_form_data.school_city)#</cfif><cfif LEN(get_form_data.school_state)>, #TRIM(get_form_data.school_state)#</cfif><cfif LEN(get_form_data.school_zip)>, #TRIM(get_form_data.school_zip)#</cfif>
                            &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Telephone:</td>
                    <td>
                        <div class="filled_data" style="width: 99%">
                            #TRIM(get_form_data.school_phone)# &nbsp;
                        </div>
                    </td>
                    <td width="60" style="text-align: right">Fax: </td>
                    <td>
                        <div class="filled_data" style="width: 99%">
                            #TRIM(get_form_data.school_fax)# &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Website:</td>
                    <td colspan="3">
                        <div class="filled_data" style="width: 99%">
                            #TRIM(get_form_data.school_website)# &nbsp;
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Contact(s):</td>
                    <td colspan="3">
                        <div class="filled_data" style="width: 99%">
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
                        <div class="filled_data" style="width: 99%">
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

            <table cellpadding="2" cellspacing="0" width="100%" >
                <tr>
                    <td width="300">Is the student eligible for graduation or to receive diploma? </td>
                    <td >
                        <div style="width:8pt; height: 8pt; border:1px solid ##000;float:left; line-height: 8pt; text-align: center">&nbsp;</div> 
                        <span style="float:left;"> Yes &nbsp; </span>
                        <div style="width:8pt; height: 8pt; border:1px solid ##000;float:left; line-height: 8pt; text-align: center">&nbsp;</div> 
                        <span style="float:left"> No</span>
                    </td>
                </tr>
            </table>
            
            <table cellpadding="2" cellspacing="0" width="100%">
                <tr>
                    <td width="160">Date School Orientation Begins: </td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.year_begins, 'mm/dd/yyyy')# &nbsp;</div></td>
                    <td width="100">Date School Starts: </td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.year_begins, 'mm/dd/yyyy')# &nbsp;</div></td>
                </tr>
                <tr>
                    <td >First Semester Ends: </td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.semester_ends, 'mm/dd/yyyy')# &nbsp;</div></td>
                    <td >Date Second Semester Begins: </td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.semester_begins, 'mm/dd/yyyy')# &nbsp;</div></td>
                </tr>
                <tr>
                    <td>Date School Year Ends: </td>
                    <td><div class="filled_data">#DATEFORMAT(get_form_data.year_ends, 'mm/dd/yyyy')# &nbsp;</div></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>

            <table cellpadding="2" cellspacing="0" width="100%">
                <tr>
                    <td width="280">If applicable, has tuition been fully waived?</td>
                    <td>
                        <div style="width:8pt; height: 8pt; border:1px solid ##000;float:left; line-height: 8pt; text-align: center">&nbsp;</div> 
                        <span style="float:left;"> Yes &nbsp; </span>
                        <div style="width:8pt; height: 8pt; border:1px solid ##000;float:left; line-height: 8pt; text-align: center">&nbsp;</div> 
                        <span style="float:left"> No</span>
                    </td>
                </tr>
                <tr>
                    <td >If no, have details regarding tuition been fully disclosed?</td>
                    <td>
                        <div style="width:8pt; height: 8pt; border:1px solid ##000;float:left; line-height: 8pt; text-align: center">&nbsp;</div> 
                        <span style="float:left;"> Yes &nbsp; </span>
                        <div style="width:8pt; height: 8pt; border:1px solid ##000;float:left; line-height: 8pt; text-align: center">&nbsp;</div> 
                        <span style="float:left"> No</span>
                    </td>
                </tr>
            </table>

            <p style="text-align: left; margin-top:20pt">Please sign below to confirm that this accredited institution will accept the above named student and will be enrolled in a full course of study upon arrival.</p>

            <div style="padding-top:50pt">
                <div style="border-top: 1px solid ##000; width:65%; float:left; text-align: center;font-size: 7pt; font-family: Arial; padding-top: 5pt">
                    Signature of School Administrator/Title
                </div>

                <div style="border-top: 1px solid ##000; width:30%; float:right; text-align: center;font-size: 7pt; font-family: Arial; padding-top: 5pt">
                    Date (mm/dd/yyyy)
                </div>
            </div>

        </div>

        <br clear="all"/>
    </cfoutput>
</cfdocument>