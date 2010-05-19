<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<style type="text/css">
<!--
.style1 {color: #FF0000} <!-- RED -->
.style2 {color: #3333FF} <!-- BLUE -->
.style3 {color: #FF9966} <!-- ORANGE -->
-->
</style>

<cfquery name="get_company" datasource="caseusa">
SELECT *
FROM smg_companies
WHERE companyid = '#client.companyid#'
</cfquery>

<cfoutput>

<cfif not IsDefined("form.filename") or form.filename is ''>
	<br>
	<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="98%">
	<tr><th bgcolor="ededed">HOST FAMILIES UPDATE</th></tr>
	<tr><td>
		<cfform method="post" action="?curdoc=sevis/host_extract" enctype="multipart/form-data">
		File Name &nbsp; : &nbsp; <input type="text" name="filename" size="50">
		<div align="center"><input type="submit" value="Update DS 2019"></div>
		</cfform>
	</td></tr>
	</table>
<cfelse>

	<cffile action="read" file="/var/www/html/student-management/nsmg/sevis/xml/#get_company.companyshort#/host_family/#form.filename#" variable="myxml">
	<cfset mydoc = XmlParse(myxml)>
	
	<cfset batchid =#mydoc.TransactionLog.BatchHeader.BatchID.XmlText#> 
	<cfset filename =#mydoc.TransactionLog.BatchDetail.Upload.FileName.XmlText#> 
	<cfset totalrequest =#mydoc.TransactionLog.BatchDetail.Process.RecordCount.Total.XmlText#> 
	<cfset sucrequest =#mydoc.TransactionLog.BatchDetail.Process.RecordCount.Success.XmlText#> 
	<cfset failure =#mydoc.TransactionLog.BatchDetail.Process.RecordCount.Failure.XmlText#> 
	<cfset numItems = #mydoc.TransactionLog.BatchDetail.Process.RecordCount.Total.XmlText#>
	<cfset numItems2 = (ArrayLen(mydoc.TransactionLog.BatchDetail.Process.XmlChildren) - 1)>
	
	<cfquery name="update_batch_table" datasource="caseusa">
	UPDATE smg_sevis
	SET totalprint = #sucrequest#, received = 'yes', obs = 'automatic'
	WHERE batchid = '#Right(batchid, 4)#'
	</cfquery>
	
	<br>
	<table width="100%" align="center" frame="box">
	<tr><th colspan="3" bgcolor="ededed">HOST FAMILIES UPDATE &nbsp; - &nbsp;BATCH RESULTS</th></tr>
	<tr><td colspan="3" align="center" bgcolor="ededed">File Name &nbsp; : &nbsp; &nbsp; <b>#filename#</b></td></tr>
	<tr><td colspan="3" align="center" bgcolor="ededed">Batch ID &nbsp; : &nbsp; &nbsp; <b>#batchid#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Total Requested in this Batch &nbsp;  : &nbsp; &nbsp; <b>#totalrequest#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Total Failure in this Batch &nbsp; : &nbsp; &nbsp;<b>#failure#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Successful Requested in this Batch &nbsp; : &nbsp; &nbsp;<b>#sucrequest#</b></td></tr>
	<tr><th>Student ID</th><th>SEVIS ID</th><th>Message</th></tr>
	<cfloop index="i" from = "1" to = #numItems#>
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
				<cfquery name="delete_history" datasource="caseusa">
					DELETE 
					FROM smg_sevis_history
					WHERE studentid = '#stuID#' AND batchid = '#Right(batchid, 4)#'
					LIMIT 1
				</cfquery>
		</cfif>
		</tr>
	</cfloop>
	</table><br>
	
	<table width="100%" align="center" frame="box">
	<tr><th colspan="3" bgcolor="ededed">HOST FAMILIES UPDATE &nbsp; - &nbsp; ERRORS SUMMARY</th></tr>
	<tr><td colspan="3" align="center" bgcolor="ededed">File Name &nbsp; : &nbsp; &nbsp; <b>#filename#</b></td></tr>
	<tr><td colspan="3" align="center" bgcolor="ededed">Batch ID &nbsp; : &nbsp; &nbsp; <b>#batchid#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Total Requested in this Batch &nbsp;  : &nbsp; &nbsp; <b>#totalrequest#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Successful Requested in this Batch &nbsp; : &nbsp; &nbsp;<b>#sucrequest#</b></td></tr>
	<tr><th>Student ID</th><th>SEVIS ID</th><th>Message</th></tr>
	<cfloop index="i" from = "1" to = #numItems#>
	<cfset stuID =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].XmlAttributes.requestID#>
	<cfif #mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.XmlAttributes.Status# is 'false'>
		<cfset reason =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorMessage.XmlText#>
		<cfset errorcode =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorCode.XmlText#>  
		<cfif errorcode is not 'S2202'> <!--- HOST FAMILIES already exists or not found --->
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