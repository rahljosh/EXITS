<cfparam name="FORM.update_contact" default="0" />

<cfparam name="FORM.contact_id_1" default="" />
<cfparam name="FORM.contact_title_1" default="" />
<cfparam name="FORM.contact_name_1" default="" />
<cfparam name="FORM.contact_email_1" default="" />
<cfparam name="FORM.contact_phone_1" default="" />
<cfparam name="FORM.contact_showonsaf_1" default="" />

<cfparam name="FORM.contact_id_2" default="" />
<cfparam name="FORM.contact_title_2" default="" />
<cfparam name="FORM.contact_name_2" default="" />
<cfparam name="FORM.contact_email_2" default="" />
<cfparam name="FORM.contact_phone_2" default="" />
<cfparam name="FORM.contact_showonsaf_2" default="" />

<cfparam name="FORM.contact_id_3" default="" />
<cfparam name="FORM.contact_title_3" default="" />
<cfparam name="FORM.contact_name_3" default="" />
<cfparam name="FORM.contact_email_3" default="" />
<cfparam name="FORM.contact_phone_3" default="" />
<cfparam name="FORM.contact_showonsaf_3" default="" />

<script src="linked/js/jquery.validateAccountInfo.js"></script>
<script src="linked/js/jquery.colorbox.js"></script>
	<!----open window details---->
	<script>
        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            $(".iframe").colorbox({width:"60%", height:"60%", iframe:true, 
               onClosed:function(){ location.reload(true); } 
            });

            $("#contact_phone_1").mask("(999) 999-9999");
            $("#contact_phone_2").mask("(999) 999-9999");
            $("#contact_phone_3").mask("(999) 999-9999");
        });


        var contactRemoved = false;

        function showEditContacts() {
            $(".editContacts").show();
            $(".showContacts").hide();
            $("#hideEditContactsBtn").show();
            $("#showEditContactsBtn").hide();

            return false;
        }
        function hideEditContacts() {
            $(".editContacts").hide();
            $(".showContacts").show();
            $("#hideEditContactsBtn").hide();
            $("#showEditContactsBtn").show();

            return false;
        }

        function checkContacts() {

            //if (($("input[name=contact_showonsaf_1]:checked").val() == 0) && ($("input[name=contact_showonsaf_2]:checked").val() == 0) && ($("input[name=contact_showonsaf_3]:checked").val() == 0)) {
            //    alert('Please, select at least one contact to show on School Acceptance Form.');
            //    return false;
            //} else {
                var email_1 = checkEmail($("#contact_email_1").val());
                var email_2 = checkEmail($("#contact_email_2").val());
                var email_3 = checkEmail($("#contact_email_3").val());

                if (($("#contact_email_1").val() != '') && (email_1 == false)) {
                    alert('Invalid Email: ' + $("#contact_email_1").val());
                    $("#contact_email_1").focus();
                    return false;
                } else if (($("#contact_email_2").val() != '') && (email_2 == false)) {
                    alert('Invalid Email: ' + $("#contact_email_2").val());
                    $("#contact_email_2").focus();
                    return false;
                } else if  (($("#contact_email_3").val() != '') && (email_3 == false)) {
                    alert('Invalid Email: ' + $("#contact_email_3").val());
                    $("#contact_email_3").focus();
                    return false;
                } else {
                    return true;
                }
            //}
        }

        function checkEmail(email) {
          var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
          return regex.test(email);
        }

        function deleteContact(contact_id, contact_position) {
            var checkDelete = confirm('Are you sure you want to delete the contact? Click OK to continue.');

            if (checkDelete) {
                $.ajax({
                    url: "extensions/components/school.cfc?method=removeSchoolContact",
                    dataType: "json",
                    data: { 
                        contactID: contact_id
                    },
                    success: function(data) {
                        $("#contact_id_"+ contact_position).val('');
                        $("#contact_title_"+ contact_position).val('');
                        $("#contact_name_"+ contact_position).val('');
                        $("#contact_email_"+ contact_position).val('');
                        $("#contact_phone_"+ contact_position).val('');
                        $("#contact_showonsaf_"+ contact_position+"_0").attr('checked', 'checked');

                        $("#delete_contact_btn_"+ contact_position).hide();

                        contactRemoved = true;

                        //alert('Contact Removed!');
                    }
                })
            }

            return false;
        }

        function checkRefresh() {
            if (contactRemoved){
                window.location.reload();
            } else {
                hideEditContacts();
            }
            return false;
        }
    </script>
<!--- delete school date. --->
<cfif isDefined("url.delete_date")>
    <cfquery datasource="#application.dsn#">
        DELETE FROM smg_school_dates
        WHERE schooldateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.delete_date#">
    </cfquery>
</cfif>

<cfparam name="url.schoolid" default="">
<cfif not isNumeric(url.schoolid)>
    a numeric schoolid is required to view a school.
    <cfabort>
</cfif>

<cfquery name="get_school" datasource="#application.dsn#">
	SELECT *
	FROM smg_schools
	WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.schoolid#">
</cfquery>

<cfquery name="get_school_contact_titles" datasource="#application.dsn#">
    SELECT *
    FROM smg_school_contact_titles
    WHERE active = 1
</cfquery>

<cfif get_school.recordcount EQ 0>
	The school ID you are looking for, <cfoutput>#url.schoolid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the school record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view this host family
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<!--- FORM Submitted to add/update contact --->
<cfif VAL(FORM.update_contact)>

    <cfset newContact = '' />
    <cfset newEmail = '' />

    <!--- Update Contact ID 1 --->
    <cfif VAL(FORM.contact_id_1)>
        <cfquery name="update_contact_1" datasource="#application.dsn#">
            UPDATE smg_school_contacts
            SET title = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_1)#">,
                name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_name_1#">,
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_email_1#">,
                phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_phone_1#">,
                show_on_saf = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.contact_showonsaf_1)#">
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_id_1)#">
        </cfquery>

        <cfif VAL(FORM.contact_title_1)>
            <cfquery name="getTitle" datasource="#application.dsn#">
                SELECT *
                FROM smg_school_contact_titles
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_1)#">
            </cfquery>
        </cfif>

        <cfset newContact = FORM.contact_name_1 />
        <cfif VAL(FORM.contact_title_1) AND getTitle.recordCount GT 0 >
            <cfset newContact = newContact & ', ' & getTitle.name  />
        </cfif>

        <cfif LEN(FORM.contact_email_1) >
            <cfset newEmail = FORM.contact_email_1 />
        </cfif>
    <!--- Add new contact --->
    <cfelseif LEN(FORM.contact_name_1)>
        <cfquery name="add_contact_1" datasource="#application.dsn#">
            INSERT INTO smg_school_contacts (
                school_id,
                title,
                name,
                email,
                phone,
                show_on_saf,
                create_by)
            VALUES(
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.schoolID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_1)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_name_1#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_email_1#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_phone_1#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.contact_showonsaf_1)#">,
                #CLIENT.userID#)
        </cfquery>

        <cfif VAL(FORM.contact_title_1)>
            <cfquery name="getTitle" datasource="#application.dsn#">
                SELECT *
                FROM smg_school_contact_titles
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_1)#">
            </cfquery>
        </cfif>

        <cfset newContact = FORM.contact_name_1 />
        <cfif VAL(FORM.contact_title_1) AND getTitle.recordCount GT 0 >
            <cfset newContact = newContact & ', ' & getTitle.name  />
        </cfif>

        <cfif LEN(FORM.contact_email_1) >
            <cfset newEmail = FORM.contact_email_1 />
        </cfif>
    </cfif>


    <!--- Update Contact ID 2 --->
    <cfif VAL(FORM.contact_id_2)>
        <cfquery name="update_contact_2" datasource="#application.dsn#">
            UPDATE smg_school_contacts
            SET title = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_2)#">,
                name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_name_2#">,
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_email_2#">,
                phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_phone_2#">,
                show_on_saf = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.contact_showonsaf_2)#">
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_id_2)#">
        </cfquery>

        <cfif VAL(FORM.contact_title_2)>
            <cfquery name="getTitle2" datasource="#application.dsn#">
                SELECT *
                FROM smg_school_contact_titles
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_2)#">
            </cfquery>
        </cfif>

        <cfset newContact = newContact & ' / ' & FORM.contact_name_2 />
        <cfif VAL(FORM.contact_title_2) AND getTitle2.recordCount GT 0 >
            <cfset newContact = newContact & ', ' & getTitle2.name  />
        </cfif>

        <cfif NOT LEN(newEmail) AND LEN(FORM.contact_email_2) >
            <cfset newEmail = FORM.contact_email_2 />
        </cfif>
    <!--- Add new contact --->
    <cfelseif LEN(FORM.contact_name_2)>
        <cfquery name="add_contact_2" datasource="#application.dsn#">
            INSERT INTO smg_school_contacts (
                school_id,
                title,
                name,
                email,
                phone,
                show_on_saf,
                create_by)
            VALUES(
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.schoolID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_2)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_name_2#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_email_2#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_phone_2#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.contact_showonsaf_2)#">,
                #CLIENT.userID#) 
        </cfquery>

        <cfif VAL(FORM.contact_title_2)>
            <cfquery name="getTitle2" datasource="#application.dsn#">
                SELECT *
                FROM smg_school_contact_titles
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_2)#">
            </cfquery>
        </cfif>

        <cfset newContact = newContact & ' / ' & FORM.contact_name_2 />
        <cfif VAL(FORM.contact_title_2) AND getTitle2.recordCount GT 0 >
            <cfset newContact = newContact & ', ' & getTitle2.name  />
        </cfif>

        <cfif NOT LEN(newEmail) AND LEN(FORM.contact_email_2) >
            <cfset newEmail = FORM.contact_email_2 />
        </cfif>
    </cfif>

    <!--- Update Contact ID 3 --->
    <cfif VAL(FORM.contact_id_3)>
        <cfquery name="update_contact_3" datasource="#application.dsn#">
            UPDATE smg_school_contacts
            SET title = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_3)#">,
                name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_name_3#">,
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_email_3#">,
                phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_phone_3#">,
                show_on_saf = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.contact_showonsaf_3)#">
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_id_3)#">
        </cfquery>

        <cfif VAL(FORM.contact_title_3)>
            <cfquery name="getTitle3" datasource="#application.dsn#">
                SELECT *
                FROM smg_school_contact_titles
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_3)#">
            </cfquery>
        </cfif>

        <cfset newContact = newContact & ' / ' & FORM.contact_name_3 />
        <cfif VAL(FORM.contact_title_3) AND getTitle3.recordCount GT 0 >
            <cfset newContact = newContact & ', ' & getTitle3.name  />
        </cfif>

        <cfif NOT LEN(newEmail) AND LEN(FORM.contact_email_3) >
            <cfset newEmail = FORM.contact_email_3 />
        </cfif>
    <!--- Add new contact --->
    <cfelseif LEN(FORM.contact_name_3)>
        <cfquery name="add_contact_3" datasource="#application.dsn#">
            INSERT INTO smg_school_contacts (
                school_id,
                title,
                name,
                email,
                phone,
                show_on_saf,
                create_by)
            VALUES(
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.schoolID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_3)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_name_3#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_email_3#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.contact_phone_3#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.contact_showonsaf_3)#">,
                #CLIENT.userID#)
        </cfquery>

        <cfif VAL(FORM.contact_title_3)>
            <cfquery name="getTitle3" datasource="#application.dsn#">
                SELECT *
                FROM smg_school_contact_titles
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.contact_title_3)#">
            </cfquery>
        </cfif>

        <cfset newContact = newContact & ' / ' & FORM.contact_name_3 />
        <cfif VAL(FORM.contact_title_3) AND getTitle3.recordCount GT 0 >
            <cfset newContact = newContact & ', ' & getTitle3.name  />
        </cfif>

        <cfif NOT LEN(newEmail) AND LEN(FORM.contact_email_3) >
            <cfset newEmail = FORM.contact_email_3 />
        </cfif>
    </cfif>


    <cfquery name="update_school_contact" datasource="#application.dsn#">
        UPDATE smg_schools
        SET principal = '#newContact#'
            <cfif LEN(newEmail)>
            , email = '#newEmail#'
            </cfif>
        WHERE schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.schoolID)#">
    </cfquery>

</cfif>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top"><td>

	<cfoutput>
	<!--- HEADER OF TABLE --- School Information --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
			<td background="pics/header_background.gif"><h2>School Information</h2></td>
			<cfif client.usertype LTE '4'>
            	<td background="pics/header_background.gif"><a href="?curdoc=querys/delete_school&schoolid=#get_school.schoolid#" onClick="return confirm('You are about to delete this School. You will not be able to recover this information. Click OK to continue.')"><img src="pics/deletex.gif" border="0" alt="Delete"></a></td>
            </cfif>
			<td background="pics/header_background.gif" width=16>
                <cfif APPLICATION.CFC.USER.isOfficeUser() >
                    <a href="?curdoc=forms/school_form&schoolid=#get_school.schoolid#"><img src="pics/edit.png" border="0" alt="Edit"></a>
                </cfif>
            </td>
            <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<!--- BODY OF A TABLE --->
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td>School Name:</td><td>#get_school.schoolname#</td><td>ID:</td><td>#get_school.schoolid#</td></tr>
		<tr><td>Address:</td><td>#get_school.address#<br />#get_school.address2#</td></tr>
		<tr><td>City:</td><td>#get_school.city#</td></tr>
		<tr><td>State:</td><td>#get_school.state#</td><td>Zip:</td><td>#get_school.zip#</td></tr>
		<!---<tr><td>Contact:</td><td>#get_school.principal#</td><td>Contact Email:</td><td><a href="mailto:#get_school.email#">#get_school.email#</a></td></tr>--->
		<tr><td>Phone:</td><td>#get_school.phone#</td><td>Fax:</td><td>#get_school.fax#</td></tr>
		<tr>
			<td>Web Site:</td>
			<td>
	        	<!--- url validation was recently added to the form, so some values might have http:// and some might not. --->
	            <cfif get_school.url neq ''>
					<cfif left(get_school.url, 7) eq 'http://'>
	                    <a href="#get_school.url#" target="_blank">#get_school.url#</a>
	                <cfelse>
	                    <a href="http://#get_school.url#" target="_blank">http://#get_school.url#</a>
	                </cfif>
	            </cfif>
       	 	</td>
			<td>Number of Students</td>
			<td>#get_school.numberOfStudents#</td>
		</tr>
	</table>
	<!--- BOTTOM OF A TABLE --->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>
    </cfoutput>
    	
</td>
<!--- SEPARATE TABLES --->
<td width="2%"></td>
<td>

    <cfquery name="get_school_dates" datasource="#application.dsn#">
        SELECT schooldateid, enrollment, year_begins, semester_ends, semester_begins, year_ends, fiveStudentAssigned,smg_seasons.season, smg_school_dates.seasonid, orientation_required
        FROM smg_school_dates INNER JOIN smg_seasons ON smg_seasons.seasonid = smg_school_dates.seasonid
        WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_school.schoolid#">
        AND smg_seasons.active = '1'
        ORDER BY smg_seasons.season
    </cfquery>

	<!--- HEADER OF TABLE --- School Dates --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
			<td background="pics/header_background.gif"><h2>School Dates</h2></td>
    	    <td background="pics/header_background.gif" align="right">
                <cfif APPLICATION.CFC.USER.isOfficeUser() >
                    <a href="index.cfm?curdoc=forms/school_date_form&schoolid=<cfoutput>#get_school.schoolid#</cfoutput>">Add School Date</a>
                </cfif>
            </td>
            <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
    <!--- BODY OF TABLE --->
    <table width=100% border=0 cellpadding=2 cellspacing=0 class="section">
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><u>Season</u></td>
            <td><u>Enroll/Orient.</u></td>
            <td><u>Orient. Req.</u></td>
            <td><u>Year Begins</u></td>
            <td><u>1st Sem. Ends</u></td>
            <td><u>2nd Sem. Begins</u></td>
            <td><u>Year Ends</u></td>
            <td><u>5th Student</u></td>
        </tr>
        <cfif get_school_dates.recordcount is 0>
            <tr><td colspan="8" align="center">There are no dates for this school.</td></tr>
        <cfelse>		
            <cfoutput query="get_school_dates">
			   <cfscript>	
                    // Get the letter info
                    qGetSchoolDocs = APPCFC.DOCUMENT.getDocuments(foreignTable='school_info',foreignid=get_school.schoolid,seasonid=get_school_dates.seasonid);
              </cfscript>
            
                <tr <cfif currentRow MOD 2 EQ 0>bgcolor="EAE8E8"</cfif>>
                    <td><a href="index.cfm?curdoc=school_info&delete_date=#schooldateid#&schoolid=#get_school.schoolid#" onClick="return confirm('Are you sure you want to delete this School Date?')"><img src="pics/deletex.gif" border="0" alt="Delete"></a></td>
                    <td><a href="index.cfm?curdoc=forms/school_date_form&schooldateid=#schooldateid#"><img src="pics/edit.png" border="0" alt="Edit"></a></td>
                    <td>#season#</td>
                    <td>#DateFormat(enrollment, 'mm/dd/yyyy')#</td>
                    <td><cfif VAL(orientation_required)>Yes<cfelse>No</cfif></td>
                    <td>#DateFormat(year_begins, 'mm/dd/yyyy')#</td>
                    <td>#DateFormat(semester_ends, 'mm/dd/yyyy')#</td>
                    <td>#DateFormat(semester_begins, 'mm/dd/yyyy')#</td>
                    <td>#DateFormat(year_ends, 'mm/dd/yyyy')#</td>
                    <td <Cfif isDate(fiveStudentAssigned) AND qGetSchoolDocs.recordcount eq 0>bgcolor="##FFFF99"</cfif>>
						<!---If a date is showen, but no file, dispaly upload dialog---->
						<Cfif isDate(fiveStudentAssigned)>
                    		<a class='iframe' href="schoolInfo/fifthStudentLetter.cfm?schoolid=#get_school.schoolid#&season=#seasonid#&seasonLabel=#season#&letterDate=#DateFormat(fiveStudentAssigned, 'mm/dd/yyyy')#">#DateFormat(fiveStudentAssigned, 'mm/dd/yyyy')#</a>
                        </Cfif>
                    </td>
                </tr>
            </cfoutput>
        </cfif>
    </table>
	<!--- BOTTOM OF A TABLE --->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>	




    <cfquery name="get_school_contacts" datasource="#application.dsn#">
        SELECT smg_school_contacts.id, ssct.name AS title, smg_school_contacts.name, email, phone, show_on_saf, smg_school_contacts.title AS title_id
        FROM smg_school_contacts 
        LEFT JOIN smg_school_contact_titles ssct ON (ssct.id = smg_school_contacts.title)
        WHERE school_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_school.schoolid#">
            AND smg_school_contacts.active = '1'
        ORDER BY smg_school_contacts.id ASC
    </cfquery>

    <!--- HEADER OF TABLE --- School Contacts --->
    <table width=100% cellpadding=0 cellspacing=0 border=0 height=24 style="margin-top:10px">
        <tr height=24>
            <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
            <td background="pics/header_background.gif"><h2>Contact Information</h2></td>
            <td background="pics/header_background.gif" align="right">
                <div id="showEditContactsBtn"><a href="#" onclick="return showEditContacts()">Edit</a></div>
            </td>
            <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>
    <!--- BODY OF TABLE --->
    <table width=100% border=0 cellpadding=2 cellspacing=0 class="section" style="padding:0 5px">
        <tr>
            <td></td>
            <td><u>Title</u></td>
            <td><u>Name</u></td>
            <td><u>Email</u></td>
            <td><u>Phone</u></td>
            <td><u>Show on SAF</u></td>
        </tr>  

        <cfset contact_id_1 = '' />
        <cfset contact_title_1 = 0 />
        <cfset contact_name_1 = '' />
        <cfset contact_email_1 = '' />
        <cfset contact_phone_1 = '' />
        <cfset contact_showonsaf_1 = '' />

        <cfset contact_id_2 = '' />
        <cfset contact_title_2 = 0 />
        <cfset contact_name_2 = '' />
        <cfset contact_email_2 = '' />
        <cfset contact_phone_2 = '' />
        <cfset contact_showonsaf_2 = '' />

        <cfset contact_id_3 = '' />
        <cfset contact_title_3 = 0 />
        <cfset contact_name_3 = '' />
        <cfset contact_email_3 = '' />
        <cfset contact_phone_3 = '' />
        <cfset contact_showonsaf_3 = '' />

        <cfset i = 1 />
        <cfloop query="get_school_contacts">
            <cfset "contact_id_#i#" = get_school_contacts.id />
            <cfset "contact_title_#i#" = get_school_contacts.title_id />
            <cfset "contact_title_name_#i#" = get_school_contacts.title />
            <cfset "contact_name_#i#" = get_school_contacts.name />
            <cfset "contact_email_#i#" = get_school_contacts.email />
            <cfset "contact_phone_#i#" = get_school_contacts.phone />
            <cfset "contact_showonsaf_#i#" = get_school_contacts.show_on_saf />
            <cfset i = i + 1 />
        </cfloop>
        
        <cfoutput>
        <tr bgcolor="EAE8E8" class="showContacts">
            <td></td>
            <td>
                <cfif LEN(contact_name_1)>
                    #contact_title_name_1#
                <cfelse>
                    <em style="color:##999">None</em>
                </cfif>
                <input type="hidden" name="contact_id_1" value="#contact_id_1#"></td>
            <td>#contact_name_1#
            </td>
            <td>#contact_email_1#</td>
            <td>#contact_phone_1#</td>
            <td><cfif LEN(contact_name_1) AND VAL(contact_showonsaf_1)>
                    <img src="pics/check_ok.gif" />
                <cfelseif LEN(contact_name_1)>
                    <img src="pics/check_notok.gif" />
                </cfif></td>
        </tr>

        <cfif LEN(contact_name_2)>
        <tr class="showContacts">
            <td></td>
            <td>#contact_title_name_2#
                <input type="hidden" name="contact_id_2" value="#contact_id_2#"></td>
            <td>#contact_name_2#</td>
            <td>#contact_email_2#</td>
            <td>#contact_phone_2#</td>
            <td><cfif VAL(contact_showonsaf_2)>
                    <img src="pics/check_ok.gif" />
                <cfelse>
                    <img src="pics/check_notok.gif" />
                </cfif></td>
        </tr>
        </cfif>

        <cfif LEN(contact_name_3)>
        <tr bgcolor="EAE8E8" class="showContacts">
            <td></td>
            <td>#contact_title_name_3#
                <input type="hidden" name="contact_id_3" value="#contact_id_3#"></td>
            <td>#contact_name_3#</td>
            <td>#contact_email_3#</td>
            <td>#contact_phone_3#</td>
            <td><cfif VAL(contact_showonsaf_3)>
                    <img src="pics/check_ok.gif" />
                <cfelse>
                    <img src="pics/check_notok.gif" />
                </cfif></td>
        </tr>
        </cfif>

        <form name="" method="POST" action="/nsmg/index.cfm?curdoc=school_info&schoolID=#url.schoolid#" onsubmit="return checkContacts();">
            <input type="hidden" name="update_contact" value="1" />
        <tr class="editContacts" style="display: none;">
            <td><cfif VAL(contact_id_1)><a href="" id="delete_contact_btn_1" onclick="return deleteContact(#contact_id_1#, 1)"><img src="pics/deletex.gif" border="0" alt="Delete"></a></cfif></td>
            <td><input type="hidden" name="contact_id_1" id="contact_id_1" value="#contact_id_1#">
                <select name="contact_title_1" id="contact_title_1">
                    <option value="0">Select</option>
                    <cfloop query="get_school_contact_titles">
                        <option value="#get_school_contact_titles.id#" <cfif contact_title_1 EQ get_school_contact_titles.id>selected="selected"</cfif> >#get_school_contact_titles.name#</option>
                    </cfloop>
                </select></td>
            <td><input type="text" name="contact_name_1" id="contact_name_1" value="#contact_name_1#"></td>
            <td><input type="text" name="contact_email_1" id="contact_email_1" value="#contact_email_1#"></td>
            <td><input type="text" name="contact_phone_1" id="contact_phone_1" value="#contact_phone_1#"></td>
            <td><input type="radio" name="contact_showonsaf_1" id="contact_showonsaf_1_1" value="1" <cfif VAL(#contact_showonsaf_1#)> checked</cfif>> Yes &nbsp; 
                <input type="radio" name="contact_showonsaf_1" id="contact_showonsaf_1_0" value="0" <cfif NOT VAL(#contact_showonsaf_1#)> checked</cfif>> No</td>
        </tr>
        <tr class="editContacts" style="display: none;">
            <td><cfif VAL(contact_id_2)><a href="" id="delete_contact_btn_2" onclick="return deleteContact(#contact_id_2#, 2)"><img src="pics/deletex.gif" border="0" alt="Delete"></a></cfif></td>
            <td><input type="hidden" name="contact_id_2" id="contact_id_2" value="#contact_id_2#">
                <select name="contact_title_2" id="contact_title_2">
                    <option value="0">Select</option>
                    <cfloop query="get_school_contact_titles">
                        <option value="#get_school_contact_titles.id#" <cfif contact_title_2 EQ get_school_contact_titles.id>selected="selected"</cfif> >#get_school_contact_titles.name#</option>
                    </cfloop>
                </select></td>
            <td><input type="text" name="contact_name_2" id="contact_name_2" value="#contact_name_2#"></td>
            <td><input type="text" name="contact_email_2" id="contact_email_2" value="#contact_email_2#"></td>
            <td><input type="text" name="contact_phone_2" id="contact_phone_2" value="#contact_phone_2#"></td>
            <td><input type="radio" name="contact_showonsaf_2" id="contact_showonsaf_2_1" value="1" <cfif VAL(#contact_showonsaf_2#)> checked</cfif>> Yes &nbsp; 
                <input type="radio" name="contact_showonsaf_2" id="contact_showonsaf_2_0" value="0" <cfif NOT VAL(#contact_showonsaf_2#)> checked</cfif>> No</td>
        </tr>
        <tr class="editContacts" style="display: none;">
            <td><cfif VAL(contact_id_3)><a href="" id="delete_contact_btn_3" onclick="return deleteContact(#contact_id_3#, 3)"><img src="pics/deletex.gif" border="0" alt="Delete"></a></cfif></td>
            <td><input type="hidden" name="contact_id_3" id="contact_id_3" value="#contact_id_3#">
                <select name="contact_title_3" id="contact_title_3">
                    <option value="0">Select</option>
                    <cfloop query="get_school_contact_titles">
                        <option value="#get_school_contact_titles.id#" <cfif contact_title_3 EQ get_school_contact_titles.id>selected="selected"</cfif> >#get_school_contact_titles.name#</option>
                    </cfloop>
                </select></td>
            <td><input type="text" name="contact_name_3" id="contact_name_3" value="#contact_name_3#"></td>
            <td><input type="text" name="contact_email_3" id="contact_email_3" value="#contact_email_3#"></td>
            <td><input type="text" name="contact_phone_3" id="contact_phone_3" value="#contact_phone_3#"></td>
            <td><input type="radio" name="contact_showonsaf_3" id="contact_showonsaf_3_1" value="1" <cfif VAL(#contact_showonsaf_3#)> checked</cfif>> Yes &nbsp; 
                <input type="radio" name="contact_showonsaf_3" id="contact_showonsaf_3_0" value="0" <cfif NOT VAL(#contact_showonsaf_3#)> checked</cfif>> No</td>
        </tr>
        <tr class="editContacts" style="display: none;">
            <td colspan="6" style="text-align: center">
                <button onclick="return checkRefresh()" id="hideEditContactsBtn" style="display: none" class="buttonRed">Close</button>
                 &nbsp;
                <input type="submit" value="Save" class="buttonBlue">
            </td>
        </tr>
        </form>

        <tr style="<cfif get_school_contacts.recordCount GT 0>;display:table-row<cfelse>;display:none</cfif>">
            <td colspan="6" style="padding:10px 0 5px 0 ">&nbsp; <u>SAF Preview:</u> 
                <cfset hasPreviousContact = false />
                <cfset showsContact = false />
                <cfloop query="get_school_contacts">
                    <cfif VAL(get_school_contacts.show_on_saf)>
                        <cfif hasPreviousContact>/</cfif> 
                        #get_school_contacts.name#<cfif LEN(get_school_contacts.title)>, #get_school_contacts.title#</cfif>
                        <cfset hasPreviousContact = true />
                        <cfset showsContact = true />
                    </cfif>
                </cfloop>
                <br />
                &nbsp; <u>Email:</u> 
                <cfset hasEmail = 0 />
                <cfloop query="get_school_contacts">
                    <cfif VAL(get_school_contacts.show_on_saf) AND LEN(get_school_contacts.email) AND NOT VAL(hasEmail)>
                        #get_school_contacts.email#
                        <cfset hasEmail = 1 />
                    </cfif>
                </cfloop>
                <cfif NOT VAL(hasEmail) AND VAL(showsContact)>
                    <cfloop query="get_school_contacts">
                        <cfif LEN(get_school_contacts.email) AND NOT VAL(hasEmail)>
                            #get_school_contacts.email#
                            <cfset hasEmail = 1 />
                        </cfif>
                    </cfloop>
                </cfif>
            </td>
        </tr>

    </table>
    <table width=100% border=0 cellpadding=2 cellspacing=0 class="section" style="padding:0 5px">
        <tr>
            <td colspan="5"><u>Old Contact Info:</u> #get_school.principal_old# &nbsp; - &nbsp; <u>Old Contact Email:</u> <a href="mailto:#get_school.email#">#get_school.email_old#</a></td>
        </tr>

        </cfoutput>

    </table>
    <!--- BOTTOM OF A TABLE --->
    <table width=100% cellpadding=0 cellspacing=0 border=0>
        <tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
    </table>    

</td></tr>
</table><br>

<cfif client.usertype LTE 7>

    <cfquery name="hosting_students" datasource="#application.dsn#">
        SELECT
        	s.firstname, 
            s.familylastname, 
            s.studentid, 
            s.sex, 
            s.countryresident, 
            s.schoolid, 
            s.programid, 
            s.active,
			u.businessname, 
            c.companyshort, 
            country.countryname, 
            p.programname
        FROM 
        	smg_students s 
        INNER JOIN 
        	smg_users u 
        ON 
        	s.intrep = u.userid
        INNER JOIN 
        	smg_companies c 
        ON
        	c.companyid = s.companyid
        LEFT JOIN 
        	smg_programs p 
        ON 
        	p.programid = s.programid
        LEFT JOIN 
        	smg_countrylist country 
        ON 
        	s.countryresident = country.countryid
        WHERE 
        	s.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_school.schoolid#">
		<cfif CLIENT.companyID EQ 10>
            AND
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelseif CLIENT.companyID EQ 14>
        	AND 
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelse>   
            AND
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
        </cfif>
        and s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        ORDER BY 
        	c.companyshort, 
            p.programname, 
            s.firstname
    </cfquery>
    
    <cfquery name="hosted_students" datasource="#application.dsn#">
        SELECT 
        	s.firstname, 
        	s.familylastname, 
        	s.studentid, 
        	s.sex, 
        	s.countryresident, 
        	s.programid, 
        	s.active,
			u.businessname, 
        	c.companyshort, 
        	country.countryname, 
        	p.programname, 
        	hist.reason
        FROM 
        	smg_students s 
        INNER JOIN 
        	smg_users u 
        ON 
        	s.intrep = u.userid
        INNER JOIN 
        	smg_companies c 
        ON 
        	c.companyid = s.companyid
        INNER JOIN 
        	smg_hosthistory hist 
        ON 
        	hist.studentid = s.studentid
        LEFT JOIN 
        	smg_programs p 
        ON 
       		p.programid = s.programid
        LEFT JOIN 
        	smg_countrylist country 
        ON 
        	s.countryresident = country.countryid
        WHERE 
        	hist.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_school.schoolid#">
        AND 
        	hist.reason != 'Original Placement'
		<cfif CLIENT.companyID EQ 10>
            AND
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelseif CLIENT.companyID EQ 14>
        	AND 
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelse>
            AND
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
        </cfif>	
        and s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        ORDER BY 
        	c.companyshort, 
        	p.programname, 
        	s.firstname
    </cfquery>

	<style type="text/css">
    div.scroll {
        height: 250px;
        width:auto;
        overflow:auto;
        border-left: 2px solid #c6c6c6;
        border-right: 2px solid #c6c6c6;
        left:auto;
    }
    </style>

    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    <tr valign="top"><td>
              
        <!--- HEADER OF TABLE --- STUDENTS --->
        <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
            <tr height=24>
                <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
                <td background="pics/header_background.gif"><h2>Students</h2></td>
                <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
            </tr>
        </table>
        <table width=100% class="section">
            <tr>
                <td></td>
            </tr>
        </table>
        <!--- BODY OF TABLE --->
        <div class="scroll">
        <table width=100% border=0 cellpadding=2 cellspacing=0>
            <tr align="center"><th colspan="8">Current Students</th></tr>
            <tr>
            	<td><u>Program Manager</u></td>
            	<td><u>ID</u></td>
                <td><u>Name</u></td>
                <td><u>Sex</u></td>
                <td><u>Country</u></td>
                <td><u>Intl. Rep.</u></td>
                <td><u>Program</u></td>
                <td><u>Active</u></td>
            </tr>
            <cfif hosting_students.recordcount is 0>
                <tr><td colspan="8" align="center">There are no current students assigned to this school.</td></tr>
            <cfelse>		
                <cfoutput query="hosting_students">
                    <tr <cfif currentRow MOD 2 EQ 0>bgcolor="EAE8E8"</cfif>>
                    	<td>#companyshort#</td>
                    	<td>#studentid#</td>
                        <td><A href="?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</A></td>
                        <td>#sex#</td>
                        <td>#countryname#</td>
                        <td>#businessname#</td>
                        <td>#programname#</td>
                        <td>#yesNoFormat(active)#</td>
                    </tr>
                </cfoutput>
            </cfif>
        </table><br />
        <table width=100% border=0 cellpadding=2 cellspacing=0>
            <tr align="center"><th colspan="8">School History</th></tr>
            <tr>
            	<td><u>Program Manager</u></td>
            	<td><u>ID</u></td>
                <td><u>Name</u></td>
                <td><u>Sex</u></td>
                <td><u>Country</u></td>
                <td><u>Intl. Rep.</u></td>
                <td><u>Program</u></td>
                <td><u>Active</u></td>
            </tr>
            <cfif hosted_students.recordcount is 0>
                <tr><td colspan="8" align="center">There are no history records for this school.</td></tr>
            <cfelse>			
                <cfoutput query="hosted_students">
                    <tr <cfif currentRow MOD 2 EQ 0>bgcolor="EAE8E8"</cfif>>
                    	<td>#companyshort#</td>
                    	<td>#studentid#</td>
                        <td><A href="?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</A></td>
                        <td>#sex#</td>
                        <td>#countryname#</td>
                        <td>#businessname#</td>
                        <td>#programname#</td>
                        <td>#yesNoFormat(active)#</td>
                    </tr>
					<tr <cfif currentRow MOD 2 EQ 0>bgcolor="EAE8E8"</cfif>><td colspan="8">Reason for changing: #reason#</td></tr>	
                </cfoutput>
            </cfif>
        </table>
        </div>			
        <!--- BOTTOM OF A TABLE --- STUDENTS  --->
        <table width=100% cellpadding=0 cellspacing=0 border=0>
            <tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
        </table>

    </td></tr>
    </table>
    
</cfif>