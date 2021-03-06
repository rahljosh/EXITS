<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<style type="text/css">
<!--
.style1 {color: #FF0000} <!-- RED -->
.style2 {color: #3333FF} <!-- BLUE -->
.style3 {color: #FF9966} <!-- ORANGE -->
-->
</style>

<cfquery name="get_company" datasource="MySQL">
    SELECT 
        companyID,
        companyName,
        companyshort,
        companyshort_nocolor,
        sevis_userid,
        iap_auth,
        team_id
    FROM 
        smg_companies
    WHERE 
        companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
</cfquery>


<cfset non_site_activity_errors = '0'>
<cfset site_activity_errors = '0'>

<cfoutput>
<Cfif isDefined('url.batch')>
	<cfset form.filename = #url.batch#>
</Cfif>
<cfif not IsDefined("form.filename") or form.filename is ''>
	<br>
	<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="98%">
	<tr><th bgcolor="ededed">SITE OF ACTIVITY UPDATE</th></tr>
	<tr><td>
		<cfform method="post" action="?curdoc=sevis/school_extract" enctype="multipart/form-data">
		File Name &nbsp; : &nbsp; <input type="text" name="filename" size="50">
		<div align="center"><input type="submit" value="Update #CLIENT.DSFormName#"></div>
		</cfform>
	</td></tr>
	</table>
<cfelse>

	<cffile action="read" file="#AppPath.sevis##get_company.companyshort_nocolor#/school/#form.filename#" variable="myxml">
	<cfset mydoc = XmlParse(myxml)>
	
	<cfset batchid =#mydoc.TransactionLog.BatchHeader.BatchID.XmlText#> 
	<cfset filename =#mydoc.TransactionLog.BatchDetail.Upload.FileName.XmlText#> 
	<cfset totalrequest =#mydoc.TransactionLog.BatchDetail.Process.RecordCount.Total.XmlText#> 
	<cfset sucrequest =#mydoc.TransactionLog.BatchDetail.Process.RecordCount.Success.XmlText#> 
	<cfset failure =#mydoc.TransactionLog.BatchDetail.Process.RecordCount.Failure.XmlText#> 
	<cfset numItems = #mydoc.TransactionLog.BatchDetail.Process.RecordCount.Total.XmlText#>
	<cfset numItems2 = (ArrayLen(mydoc.TransactionLog.BatchDetail.Process.XmlChildren) - 1)>
	
	<cfquery name="update_batch_table" datasource="MySql">
	UPDATE smg_sevis
	SET totalprint = #sucrequest#, received = 'yes', obs = 'automatic'
	WHERE batchid = '#Right(batchid, 4)#'
	</cfquery>
	
	<br>
	<table width="100%" align="center" frame="box">
	<tr><th colspan="3" bgcolor="ededed">SITE OF ACTIVITY UPDATE &nbsp; - &nbsp;BATCH RESULTS</th></tr>
	<tr><td colspan="3" align="center" bgcolor="ededed">File Name &nbsp; : &nbsp; &nbsp; <b>#filename#</b></td></tr>
	<tr><td colspan="3" align="center" bgcolor="ededed">Batch ID &nbsp; : &nbsp; &nbsp; <b>#batchid#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Total Requested in this Batch &nbsp;  : &nbsp; &nbsp; <b>#totalrequest#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Total Failure in this Batch &nbsp; : &nbsp; &nbsp;<b>#failure#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Successful Requested in this Batch &nbsp; : &nbsp; &nbsp;<b>#sucrequest#</b></td></tr>
	<tr><th>Student ID</th><th>SEVIS ID</th><th>Message</th></tr>
	<cfloop index="i" from = "1" to="#numItems#">
		<tr>
		<cfset stuID =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].XmlAttributes.requestID#>
		<cfif #mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.XmlAttributes.Status# is 'true'>
			<cfset SevisID =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].XmlAttributes.sevisID#> 	
			<td align="center" class="style2">#stuID#</td><td align="center" class="style2">#SevisID#</td><td class="style2">&nbsp; OK &nbsp; - &nbsp; System Updated!</td>
		<!--- ERROR --->
		<cfelse> 
			<cfset reason =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorMessage.XmlText#>
			<cfset errorcode =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorCode.XmlText#>  
			<td class="style1" align="center">#stuID#</td><td class="style1" align="center">Error Code: #errorcode#</td><td class="style1">&nbsp; #reason#</td>
				<cfquery name="delete_history" datasource="MySql">
					DELETE FROM smg_sevis_history
					WHERE batchid = '#Right(batchid, 4)#' AND studentid = '#stuID#'
				</cfquery>
				<cfif errorcode NEQ 'S2202' AND errorcode NEQ 'S2129'> <!--- site of activity already exists --->
					<cfset site_activity_errors = site_activity_errors + '1'>
				<cfelse>
					<cfset non_site_activity_errors =  non_site_activity_errors + '1'>
				</cfif>				
		</cfif>
		</tr>
	</cfloop>
	</table><br>
	
	<table width="100%" align="center" frame="box">
	<tr><th colspan="3" bgcolor="ededed">SITE OF ACTIVITY UPDATE</th></tr>
	<tr><td colspan="3" align="center" bgcolor="ededed">File Name: &nbsp;<b>#filename#</b></td></tr>
	<tr><td colspan="3" align="center" bgcolor="ededed">Batch ID: &nbsp;<b>#batchid#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Total Requested in this Batch: &nbsp;<b>#totalrequest#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Successful Requested in this Batch: &nbsp;<b>#sucrequest#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Site of activity already exists - Error: &nbsp;<b>#site_activity_errors#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Number of Errors: &nbsp;<b>#non_site_activity_errors#</b></td></tr>

	<tr><th>Student ID</th><th>SEVIS ID</th><th>Message</th></tr>
	<cfloop index="i" from = "1" to = #numItems#>
	<cfset stuID =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].XmlAttributes.requestID#>
	<cfif #mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.XmlAttributes.Status# is 'false'>
		<cfset reason =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorMessage.XmlText#>
		<cfset errorcode =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorCode.XmlText#>  
		
		<cfif errorcode is not 'S2202'> <!--- site of activity already exists --->
			<tr><td class="style1" align="center">#stuID#</td><td class="style1" align="center">Error Code: #errorcode#</td><td class="style1">&nbsp; #reason#</td></tr>
		</cfif>
		
	</cfif>
	</cfloop>
	</table>
</cfif><br>

<div align="center">
		<!--- <A HREF="index.cfm?curdoc=sevis/menu"><img border="0" src="pics/back.gif"></A> --->
		<input type="image" value="back" src="pics/back.gif" onClick="javascript:history.back()">
</div><br>
</cfoutput>