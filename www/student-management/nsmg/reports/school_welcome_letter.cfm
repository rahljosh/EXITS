<!--- If set to save will save this report to the internal virtual folder --->
<cfparam name="URL.save" default="">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Determine if this should be served as a pdf or displayed (default is 0/no) --->
<cfparam name="URL.pdf" default="0">

<!--- Get the historyID from the URL --->
<cfparam name="URL.historyID" default="0">

<!--- Get this history record, if none was sent in get the current information --->
<cfif URL.historyID NEQ 0>        
	<cfquery name="get_letter_info" datasource="#APPLICATION.DSN#">
		SELECT s.studentID, s.familyLastName AS lastName, s.firstName, s.countryresident, s.sex, s.grades,
			h.areaRepID, h.hostID, h.schoolID, h.datePlaced,
			host.regionID AS regionAssigned, host.familyLastName, host.address, host.address2, host.city, host.state, host.zip, host.phone,
			sc.schoolid, sc.schoolname, sc.principal, sc.address AS sc_address, sc.address2 AS sc_address2, sc.city AS sc_city, sc.state AS sc_state, sc.zip AS sc_zip, sc.phone AS sc_phone,
			ar.userid, ar.lastname AS ar_lastname, ar.firstname AS ar_firstname, ar.address AS ar_address, ar.address2 AS ar_address2, ar.city AS ar_city, ar.state AS ar_state, ar.zip AS ar_zip,
			ar.phone AS ar_phone, ar.email AS ar_email,
			r.regionname,
			c.countryname
		FROM smg_hosthistory h
		INNER JOIN smg_hosts host On host.hostID = h.hostID
		INNER JOIN smg_students s ON s.studentID = h.studentID
		INNER JOIN smg_schools sc ON sc.schoolID = h.schoolID
		INNER JOIN smg_regions r ON r.regionID = host.regionID
		INNER JOIN smg_users ar ON ar.userID = h.areaRepID
		INNER JOIN smg_countrylist c ON c.countryID = s.countryresident
		WHERE h.historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.historyID#">
	</cfquery>
<cfelse>
	<cfquery name="get_letter_info" datasource="mysql">
		SELECT stu.studentid, stu.familylastname AS lastName, stu.firstname, stu.arearepid, stu.regionassigned, stu.hostid, 
			stu.schoolid, stu.grades, stu.countryresident, stu.sex, stu.dateplaced, stu.regionassigned,
			h.hostid, h.familylastname, h.address, h.address2, h.city, h.state, h.zip, h.phone,
			sc.schoolid, sc.schoolname, sc.principal, sc.address AS sc_address, sc.address2 AS sc_address2, sc.city AS sc_city, sc.state AS sc_state, sc.zip AS sc_zip, sc.phone AS sc_phone,
			ar.userid, ar.lastname AS ar_lastname, ar.firstname AS ar_firstname, ar.address AS ar_address, ar.address2 AS ar_address2, ar.city AS ar_city, 
			ar.state AS ar_state, ar.zip AS ar_zip, ar.phone AS ar_phone, ar.email AS ar_email, r.regionname,
			c.countryname
		FROM smg_students stu
		INNER JOIN smg_regions r on stu.regionassigned = r.regionid
		INNER JOIN smg_hosts h ON stu.hostid = h.hostid
		INNER JOIN smg_schools sc ON stu.schoolid = sc.schoolid
		INNER JOIN smg_users ar ON stu.arearepid = ar.userid
		INNER JOIN smg_countrylist c ON c.countryid = stu.countryresident
		WHERE stu.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.studentid#">
	</cfquery>
</cfif>
    
<cfquery name="program_info" datasource="MySQL">
	SELECT programname, startdate, enddate
	FROM smg_programs LEFT JOIN smg_students on smg_programs.programid = smg_students.programid 
	WHERE smg_students.studentid = #client.studentid#
</cfquery>



<cfsavecontent variable="letter">

	<cfoutput>
    <!--- letter header --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
        <tr>
            <td>
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="left" height=110></td>
                    </tr>
                    <tr>
                        <td><font size=-1> #DateFormat(now(), 'mmmm dd, yyyy')#</font></td>
                    </tr>
                </table>
            </td>	
        	<td valign="top" align="right"> 
                <font size=-1>
                	<div align="right">
                		<span id="titleleft">
                			#companyshort.companyname#<br>
                			#companyshort.address#<br>
                			#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
                			<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
                			<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
                			<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif>
                			<cfif companyshort.generalContactEmail is ''><cfelse> Email: #companyshort.generalContactEmail#<br></cfif>
                      	</span>
                  	</div>
                </font>
        	</td>
     	</tr>		
    </table>
    
    <!--- line --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
    	<tr>
        	<td><hr width=90% align="center"></td>
      	</tr>
    </table>
    
    <!--- School info --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
        <tr>
            <td align="left">
                #get_letter_info.principal#<br>
                #get_letter_info.schoolname#<br>
                #get_letter_info.sc_address#<br>
                <Cfif get_letter_info.sc_address2 is ''><cfelse>#get_letter_info.sc_address2#<br></cfif>
                #get_letter_info.sc_city#, #get_letter_info.sc_state# #get_letter_info.sc_zip#<br>
            </td>
            <td align="right" valign="top">
                Program: #program_info.programname#<br>
                From: #DateFormat(program_info.startdate, 'mmm dd, yyyy')# to #DateFormat(program_info.enddate, 'mmm dd, yyyy')#	
            </td>
        </tr>
        <tr>
        	<td align="right" colspan="2"></td>
     	</tr>
    </table>
    
    <!--- student info --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
    	<tr>
        	<td><b>Student: #get_letter_info.firstname# #get_letter_info.lastName# from #get_letter_info.countryname#</b></td>
      	</tr>
    </table>
    <br>
    <!--- host family + Area Rep --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
        <tr>
            <td align="left" valign="top">
                <b>Host Family:</b><br>
                #get_letter_info.familyLastName# Family<br>
                #get_letter_info.address#<br>
                <Cfif get_letter_info.address2 is ''><cfelse>#get_letter_info.address2#<br></Cfif>
                #get_letter_info.city#, #get_letter_info.state# #get_letter_info.zip#<br>
                <Cfif get_letter_info.phone is ''><cfelse>Phone: &nbsp; #get_letter_info.phone#<br></Cfif>
            </td>
            <td align="left"><div align="justify">
                <b>Area Representative:</b><br>
                #get_letter_info.ar_firstname# #get_letter_info.ar_lastname#<br>
                #get_letter_info.ar_address#<br>
                <Cfif get_letter_info.ar_address2 is ''><cfelse>#get_letter_info.ar_address2#<br></Cfif>
                #get_letter_info.ar_city#, #get_letter_info.ar_state# #get_letter_info.ar_zip#
             </div>
            </td>
            <td>
            <b>Rep. Contact Information:</b><br>
                <Cfif get_letter_info.regionname is not ''>Region: #get_letter_info.regionname#<br></Cfif>
                <Cfif get_letter_info.ar_phone is ''><cfelse>Phone: &nbsp; #get_letter_info.ar_phone#<br></Cfif>
                <Cfif get_letter_info.ar_email is ''><cfelse>Email: &nbsp; #get_letter_info.ar_email#<br></Cfif>
            </div></td>
        </tr>
    </table>
    <br />
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
    <tr>
    	<td>
        	<div align="justify">
                <p>
                #companyshort.companyname# would like to thank you for allowing #get_letter_info.firstname# #get_letter_info.lastName#
                to attend your school. <cfif client.companyid NEQ 14>#companyshort.companyshort_nocolor# has issued a #CLIENT.DSFormName# for #get_letter_info.firstname# and 
                #get_letter_info.firstname# is now in the process of securing a J1 visa. Upon arrival #get_letter_info.firstname# will have 
                received a visa from the US consulate.</cfif>
                </p>
    
                <p>
                We have asked the #get_letter_info.familylastname# family to help #get_letter_info.firstname# in enrolling and registering
                in your school.
                </p>
    
                <p>
                We wish to let you know that #get_letter_info.firstname# is being supervised by #get_letter_info.ar_firstname# 
                #get_letter_info.ar_lastname#, an #companyshort.companyshort_nocolor# Area Representative. 
                #companyshort.companyshort_nocolor# Area Representatives act as a counselor to assist the student, school and host family should there be any
                concerns during #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> stay in the US.
                </p>
                
                <p>
                Please feel free to contact #get_letter_info.ar_firstname# #get_letter_info.ar_lastname# anytime you feel it would be appropriate.
                In addition, the #companyshort.companyshort_nocolor# Student Services Department, at #companyshort.toll_free#, is available to your school,
                host family and student should there ever be a serious concern with the host family, student or area representative.
                </p>
    
				<!--- GRADUATE STUDENTS - COUNTRY 49 = COLOMBIA / COUNTRY 237 = VENEZUELA --->
                <cfif get_letter_info.grades EQ 12 OR (get_letter_info.grades EQ 11 AND (get_letter_info.countryresident EQ '49' OR get_letter_info.countryresident EQ '237'))>
                <p>
                We hope that #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> school experience will 
                help to increase global understanding and friendship in your school and community. We would like to note that #get_letter_info.firstname#
                will have completed secondary school in <cfif get_letter_info.sex EQ 'male'>his<cfelse>her</cfif> native country upon arrival. Please let us know if we can assist you at 
                any time during #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> enrollment in your school.
                </p>
                <cfelse>
                <p>
                We hope that #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> school experience will 
                help to increase global understanding and friendship in your school and community. Please let us know if we can assist you at 
                any time during #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> enrollment in your school.
                </p>
                </cfif>
    
    
                <p>
                Very truly yours,<br><br>
                #companyshort.lettersig#<br>
                #companyshort.companyname#<br>
    			</p></div>
          	</td>
      	</tr>
    </table>
    <Cfif client.companyid NEQ 14>
    <!--- line --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
    	<tr><td><hr width=90% align="center"></td></tr>
    </table>
    <table width=100%>
        <tr>
            <td align="center"><font color="##999999"><font size=-2>U.S. Department of State &middot; 2200 C St. NW &middot; Washington D.C. 20037 &middot; 866.283.9090 &middot; jvisas@state.gov</font></font></td>
        </tr>
    </table>
    </Cfif>
    </cfoutput>
    
</cfsavecontent>

<cfif VAL(URL.pdf)>
	<cfoutput>
    	<cfset fileName="SchoolWelcome#CLIENT.studentID#_#DateFormat(NOW(),'mm-dd-yyyy')#-#TimeFormat(NOW(),'hh-mm')#.pdf">
    	<cfdocument format="pdf" filename="#fileName#" overwrite="yes" orientation="portrait" name="uploadFile">
        	#letter#
   		</cfdocument>
        <cfheader name="Content-Disposition" value="attachment; filename=#fileName#">
		<cfcontent type="application/pdf" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#" deletefile="yes">
  	</cfoutput>
<cfelse>
	<cfoutput>
    	#letter#
    </cfoutput>
</cfif>