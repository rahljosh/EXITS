<cfparam name="URL.bulkID" default="">

<cfif NOT VAL(URL.bulkid)>
	<table align="center" width="90%" frame="box">
		<tr><th colspan="2">It was not possible to print out your report. One error has ocurred. Please go back and re-submit it.</th></tr>
	</table>
	<cfabort>
</cfif>

<!-- get company info -->
<cfquery name="qGetCompanyInfo" datasource="MySql">
	SELECT 
    	f.companyid, 
        c.companyshort, 
        c.companyshort_nocolor, 
        datecreated
	FROM 
    	smg_sevisfee f
	INNER JOIN 
    	smg_companies c ON f.companyid = c.companyid
	WHERE 
    	f.bulkid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.bulkid#">
</cfquery>

<!--- Query the database and get students --->
<cfquery name="qGetStudentList" datasource="MySql"> 
	SELECT 	
    	s.studentid, 
        s.sevis_batchid, 
        s.firstname, 
        s.familylastname, 
        s.middlename, 
        s.dob, 
        s.ds2019_no,
		p.programname, 
        p.programid,
		c.companyname, 
        c.usbank_iap_aut,
		u.accepts_sevis_fee, 
        u.businessname
	FROM 
    	smg_students s 
	INNER JOIN 
    	smg_programs p ON s.programid = p.programid
	INNER JOIN 
    	smg_companies c ON s.companyid = c.companyid
	INNER JOIN 
    	smg_users u ON s.intrep = u.userid
	WHERE 
    	sevis_bulkid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.bulkid#">
	ORDER BY 
    	s.sevis_batchid, 
        u.businessname, 
        s.firstname
</cfquery>
 
<cfoutput> 

<table align="center" width="95%" frame="box">
    <tr>
    	<th colspan="5">#qGetCompanyInfo.companyshort_nocolor# &nbsp; - &nbsp; S E V I S &nbsp; F E E &nbsp; - &nbsp; Bulk ID &nbsp; 0#URL.bulkid# &nbsp; - &nbsp; Sent on: #DateFormat(qGetCompanyInfo.datecreated, 'mm/dd/yyyy')#</th>
	</tr>
    <tr>
    	<th colspan="5">Total of students: #qGetStudentList.recordcount#</th>
	</tr>	
    <tr style="font-weight:bold;">
        <td>Intl. Representative</td>
        <td>Student</td>
        <td>DOB</td>
        <td>#CLIENT.DSFormName# Number</td>
        <td align="center">Batch ID</td>
    </tr>
	<cfloop query="qGetStudentList">
		<tr bgcolor="###iif(qGetStudentList.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
			<td>#businessname#</td>
            <td>#firstname# #familylastname# &nbsp; (###studentid#)</td>
            <td>#DateFormat(dob, 'mm/dd/yyyy')#</td>
			<td>#ds2019_no#</td>
			<td align="center">#sevis_batchid#</td>
		</tr>
	</cfloop>
</table>

</cfoutput>

<div align="center" style="margin:10px 0px 10px 0px">
	<input type="image" value="back" src="../pics/close.gif" onClick="javascript:window.close()">
</div>