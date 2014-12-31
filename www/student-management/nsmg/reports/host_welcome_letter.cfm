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
	<cfquery name="qGetStudent" datasource="#APPLICATION.DSN#">
        SELECT s.studentID, s.familyLastName AS lastName, s.firstName,
            host.familyLastName, host.address, host.address2, host.city, host.state, host.zip, host.regionID AS regionAssigned,
            h.areaRepID, h.datePlaced,
            c.countryName
        FROM smg_hosthistory h
        INNER JOIN smg_hosts host ON host.hostID = h.hostID
        INNER JOIN smg_students s ON s.studentID = h.studentID
        INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
        WHERE historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.historyID#">
    </cfquery>
<cfelse>
	<cfquery name="qGetStudent" datasource="#APPLICATION.DSN#">
        SELECT s.studentid, s.hostid, s.familylastname as lastname, s.firstname, s.arearepid, s.regionassigned, s.dateplaced,
            h.familylastname, h.address, h.address2, h.city, h.state, h.zip, 
            c.countryname
        FROM smg_students s
        LEFT JOIN smg_hosts h ON h.hostid = s.hostid
        INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
        WHERE s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.studentid#">
    </cfquery>
</cfif>

<cfquery name="program_info" datasource="MySQL">
	select programname, startdate, enddate
	from smg_programs 
	left join smg_students on smg_programs.programid = smg_students.programid 
	where smg_students.studentid = '#client.studentid#'
</cfquery>

<cfsavecontent variable="letter">

	<cfoutput>

        <table width=650 align="center" border=0 bgcolor="FFFFFF">
            <tr>
            <td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="left"></td>	
            <td valign="top" align="right"> 
                <div align="right"><span id="titleleft">
                #companyshort.companyname#<br>
                #companyshort.address#<br>
                #companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
                <cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
                <cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
                <cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
            </td></tr>		
        </table>
        
        <br>
        <table width=650 align="center" border=0 bgcolor="FFFFFF">
        <tr><td><hr width=90% align="center"></td></tr>
        </table>
        <br>
        
        <table width=650 align="center" border=0 bgcolor="FFFFFF">
            <tr>
                <td align="left">The #qGetStudent.familylastname# Family<br>
                    #qGetStudent.address#<br>
                    <Cfif qGetStudent.address2 is ''><cfelse>#qGetStudent.address2#<br></Cfif>
                    #qGetStudent.city#, #qGetStudent.state# #qGetStudent.zip#
                </td>
                <td align="right">
                    Program: #program_info.programname#<br>
                    From: #DateFormat(program_info.startdate,'mmm. d, yyyy')# thru #DateFormat(program_info.enddate,'mmm. d, yyyy')#<br><br>
                </td>
            </tr>
        <tr><td align="right" colspan="2">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td></tr>
        </table>
        <br>
        
        <table width=650 align="center" border=0 bgcolor="FFFFFF">
        <tr><td><div align="justify">
        Dear #qGetStudent.familylastname# Family,
        
        <p>On behalf of everyone at #companyshort.companyshort_nocolor#, we would like to thank you for opening up your heart and
        home for #qGetStudent.firstname# #qGetStudent.lastname# from #qGetStudent.countryname#.</p>
        
        <p>We know that this experience will be a wonderful one for you and your family. By sharing
        your life with a young international student, you are giving your student the opportunity of a
        lifetime. Many students dream about living with an American family. It is only through
        families such as yours that this dream can become a reality.</p>
    
        <Cfquery name="rep_info" datasource='mysql'>
        SELECT userid, firstname, lastname, phone
        FROM smg_users WHERE userid = '#qGetStudent.arearepid#'
        </cfquery>
        
        <cfquery name="rd" datasource="MySQL">
        SELECT smg_users.userid, firstname, lastname, phone
        FROM smg_users
        INNER JOIN user_access_rights ON smg_users.userid = user_access_rights.userid
        WHERE user_access_rights.regionid = '#qGetStudent.regionassigned#' and user_access_rights.usertype = '5'
        </cfquery>
        
        <p>
        #companyshort.companyshort_nocolor# provides you with full support throughout #qGetStudent.firstname#'<cfif #right(qGetStudent.firstname, 1)# is 's'><cfelse>s</cfif> stay. 
        Your supervising Area Representative is #rep_info.firstname# #rep_info.lastname#, Phone Number: #rep_info.phone#.
        The Regional Director is #rd.firstname# #rd.lastname#, Phone Number: #rd.phone#.
        </p>
        
        <p>
        #qGetStudent.firstname# has already received the insurance information package containing an Insurance ID Card, 
        claim forms and instructions on how to use them. At any time you can also contact #rep_info.firstname# #rep_info.lastname#
        for information regarding the student's insurance, in case the student needs any assistance.
        </p>
        
        <p>
        #rep_info.firstname# #rep_info.lastname# will make monthly contact with #qGetStudent.firstname# and is always available to you should
        you have any concerns during the program. Enclosed is a host family handbook, student and HF evaluation packets and information 
        regarding the student's insurance. Please be sure to read and review all the information contained in the
        handbook. Please also encourage #qGetStudent.firstname# to read and understand the guidelines in the student
        handbook. Sometime before #qGetStudent.firstname#'<cfif #right(qGetStudent.firstname, 1)# is 's'><cfelse>s</cfif>  
        arrival, you will be contacted by your Area Representative for an
        orientation. At this meeting your Area Representative will review the
        handbook with you and will answer any questions you and your family might have.
        </p>
        
        <p>
        Again, we thank you for sharing in our mission of making the world a little smaller, one
        student at a time.
        </p>
        
        <p>
        Very truly yours,<br><br>
        #companyshort.lettersig#<br>
        #companyshort.companyname#<br>
        </p></div></td></tr>
        </table>
        
    </cfoutput>

</cfsavecontent>

<cfif VAL(URL.pdf)>
	<cfoutput>
    	<cfset fileName="HostWelcome#CLIENT.studentID#_#DateFormat(NOW(),'mm-dd-yyyy')#-#TimeFormat(NOW(),'hh-mm')#.pdf">
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