<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<style type="text/css">
<!--
.style1 {color: #FF0000}
.style2 {color: #3333FF}
-->
</style>

<cfquery name="get_company" datasource="caseusa">
	SELECT *
	FROM smg_companies
	WHERE companyid = '#client.companyid#'
</cfquery>

<cfif not IsDefined("form.filename") or form.filename is ''>
	<br>
	<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="98%">
	<tr><th bgcolor="#ededed">Update DS 2019 Numbers</th></tr>
	<tr><td>
		<cfform method="post" action="?curdoc=sevis/extract_from_sevis" enctype="multipart/form-data">
		File Name &nbsp; : &nbsp; <input type="text" name="filename" size="50">
		<div align="center"><input type="submit" value="Update DS 2019"></div>
		</cfform>
	</td></tr>
	</table>
<cfelse>

	<cffile action="read" file="/var/www/html/student-management/nsmg/sevis/xml/#get_company.companyshort#/new_forms/#form.filename#" variable="myxml">
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
	<tr><th colspan="3" bgcolor="#ededed">SEVIS BATCH SYSTEM &nbsp; - &nbsp;BATCH RESULTS</th></tr>
	<cfoutput>
	<tr><td colspan="3" align="center" bgcolor="ededed">File Name &nbsp; : &nbsp; &nbsp; <b>#filename#</b></td></tr>
	<tr><td colspan="3" align="center" bgcolor="ededed">Batch ID &nbsp; : &nbsp; &nbsp; <b>#batchid#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Total Requested in this Batch &nbsp;  : &nbsp; &nbsp; <b>#totalrequest#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Total Failure in this Batch &nbsp; : &nbsp; &nbsp;<b>#failure#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Successful Requested in this Batch &nbsp; : &nbsp; &nbsp;<b>#sucrequest#</b></td></tr>
	</cfoutput>
	<tr><th>Student ID</th><th>SEVIS ID</th><th>Message</th></tr>
	<cfloop index="i" from = "1" to = #numItems#>
		<tr>
		<cfset stuID =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].XmlAttributes.requestID#>
		<cfif #mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.XmlAttributes.Status# is 'true'>
			<cfset SevisID =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].XmlAttributes.sevisID#> 	
			<cfoutput>
			<td align="center" class="style2">#stuID#</td><td align="center" class="style2">#SevisID#</td><td class="style2">&nbsp; OK &nbsp; - &nbsp; System Updated!</td>
			</cfoutput>
 			<cfquery name="update_ds2019" datasource="caseusa">
				UPDATE smg_students
				SET ds2019_no = '#SevisID#', sevis_batchid ='#Right(batchid, 4)#'
				WHERE studentid = '#stuID#'
			</cfquery>
		<!--- ERROR - DS 2019 WAS NOT CREATED --->	
		<cfelse> 
			<cfoutput>
			<cfset reason =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorMessage.XmlText#>
			<cfset errorcode =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorCode.XmlText#>  
			<td class="style1" align="center">#stuID#</td><td class="style1" align="center">Error Code: #errorcode#</td><td class="style1">&nbsp; #reason#</td>
			</cfoutput>
 			<cfquery name="update_ds2019" datasource="caseusa"> <!--- UPDATE SEVIS BATCH ID TO 0 STUDENT WILL COME BACK TO THE XML NEXT TIME --->
				UPDATE smg_students
				SET sevis_batchid ='0'
				WHERE studentid = '#stuID#'
			</cfquery>
			<cfquery name="delete_history" datasource="caseusa">
				DELETE 
				FROM smg_sevis_history
				WHERE studentid = '#stuID#' AND batchid = '#Right(batchid, 4)#'
				LIMIT 1
			</cfquery>
		</cfif>
		</tr>
	</cfloop>
	</table>
	<br>
	<table width="100%" align="center" frame="box">
	<tr><th colspan="3" bgcolor="#ededed">SEVIS BATCH SYSTEM &nbsp; - &nbsp; ERRORS</th></tr>
	<cfoutput>
	<tr><td colspan="3" align="center" bgcolor="ededed">File Name &nbsp; : &nbsp; &nbsp; <b>#filename#</b></td></tr>
	<tr><td colspan="3" align="center" bgcolor="ededed">Batch ID &nbsp; : &nbsp; &nbsp; <b>#batchid#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Total Requested in this Batch &nbsp;  : &nbsp; &nbsp; <b>#totalrequest#</b></td></tr>
	<tr><td colspan="3"> &nbsp; Successful Requested in this Batch &nbsp; : &nbsp; &nbsp;<b>#sucrequest#</b></td></tr>
	</cfoutput>
	<tr><th>Student ID</th><th>SEVIS ID</th><th>Message</th></tr>
	<cfloop index="i" from = "1" to = #numItems#>
	<cfset stuID =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].XmlAttributes.requestID#>
	<cfif #mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.XmlAttributes.Status# is 'false'>
	<tr>
		<cfoutput>
		<cfset reason =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorMessage.XmlText#>
		<cfset errorcode =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorCode.XmlText#>  
		<td class="style1" align="center">#stuID#</td><td class="style1" align="center">Error Code: #errorcode#</td><td class="style1">&nbsp; #reason#</td>
		</cfoutput>
	</tr>
	</cfif>
	</cfloop>
	</table>
</cfif><br>

<div align="center">
		<!--- <A HREF="index.cfm?curdoc=sevis/menu"><img border="0" src="pics/back.gif"></A> --->
		<input type="image" value="back" src="pics/back.gif" onClick="javascript:history.back()">
</div><br>