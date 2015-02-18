<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<style type="text/css">
<!--
.style1 {color: #FF0000}
.style2 {color: #3333FF}
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

<Cfif isDefined('url.batch')>
	<cfset form.filename = #url.batch#>
</Cfif>
<cfif not IsDefined("form.filename") or form.filename is ''>
	<br>
	<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="98%">
	<tr><th bgcolor="#ededed">Update #CLIENT.DSFormName# Numbers</th></tr>
	<tr><td>
		<cfform method="post" action="?curdoc=sevis/extract_from_sevis" enctype="multipart/form-data">
		File Name &nbsp; : &nbsp; <input type="text" name="filename" size="50">
		<div align="center"><input type="submit" value="Update #CLIENT.DSFormName#"></div>
		</cfform>
	</td></tr>
	</table>
<cfelse>

	<cffile action="read" file="#APPLICATION.PATH.sevis##get_company.companyshort_nocolor#/new_forms/#form.filename#" variable="myxml">

	<cfset mydoc = XmlParse(myxml)>	
	<cfset batchid = mydoc.TransactionLog.BatchHeader.BatchID.XmlText> 
	<cfset filename = mydoc.TransactionLog.BatchDetail.Upload.FileName.XmlText> 
	<cfset totalrequest = mydoc.TransactionLog.BatchDetail.Process.RecordCount.Total.XmlText> 
	<cfset sucrequest = mydoc.TransactionLog.BatchDetail.Process.RecordCount.Success.XmlText> 
	<cfset failure = mydoc.TransactionLog.BatchDetail.Process.RecordCount.Failure.XmlText> 
	<cfset numItems =  mydoc.TransactionLog.BatchDetail.Process.RecordCount.Total.XmlText>
	<cfset numItems2 = (ArrayLen(mydoc.TransactionLog.BatchDetail.Process.XmlChildren) - 1)>
	
	<cfquery name="update_batch_table" datasource="MySql">
		UPDATE smg_sevis
		SET 
            totalprint = <cfqueryparam cfsqltype="cf_sql_integer" value="#sucrequest#">, 
            received = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">, 
            obs = <cfqueryparam cfsqltype="cf_sql_varchar" value="automatic">
		WHERE 
        	batchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Right(batchid, 4)#">
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
	<cfloop from="1" to="#numItems#" index="i">
		<tr>
        <cfset stuID = mydoc.TransactionLog.BatchDetail.Process.RECORD[i].UserDefinedA.XmlText>
		
		<cfif mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.XmlAttributes.Status is 'true'>
			<cfset SevisID = mydoc.TransactionLog.BatchDetail.Process.RECORD[i].XmlAttributes.sevisID> 	
			<cfoutput>
			<td align="center" class="style2">#stuID#</td><td align="center" class="style2">#SevisID#</td><td class="style2">&nbsp; OK &nbsp; - &nbsp; System Updated!</td>
			</cfoutput>
 			<cfquery name="update_ds2019" datasource="MySql">
				UPDATE extra_candidates
				SET 
                	ds2019 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SevisID#">, 
                    sevis_batchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Right(batchid, 4)#">
				WHERE
                	candidateid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stuID#"> <!--- Right(stuID, 5) --->
			</cfquery>
		<!--- ERROR - DS 2019 WAS NOT CREATED --->	
		<cfelse> 
			<cfoutput>
			<cfset reason =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorMessage.XmlText#>
			<cfset errorcode =#mydoc.TransactionLog.BatchDetail.Process.RECORD[i].Result.ErrorCode.XmlText#>  
			<td class="style1" align="center">#stuID#</td><td class="style1" align="center">Error Code: #errorcode#</td><td class="style1">&nbsp; #reason#</td>
			</cfoutput>
 			<cfquery name="update_ds2019" datasource="MySql"> <!--- UPDATE SEVIS BATCH ID TO 0 STUDENT WILL COME BACK TO THE XML NEXT TIME --->
				UPDATE extra_candidates
				SET sevis_batchid ='0'
				WHERE candidateid = '#stuID#'
			</cfquery>
			<cfquery name="delete_history" datasource="MySql">
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