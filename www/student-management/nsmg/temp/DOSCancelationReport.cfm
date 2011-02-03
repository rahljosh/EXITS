<!--- ------------------------------------------------------------------------- ----
	
	File:		DOSCancelationReport.cfm
	Author:		Marcus Melo
	Date:		February 3, 2011
	Desc:		DOS requested a list of canceled/withdraw/termination students
				for 05/06 programs to 09/10 excluding private programs
	
	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<cfscript>
    
        /***
        05/06 -> 74,75,86,91,
        Aug 05 - Jan 06 -> 89,90,92,95,
        Jan 06 - Jun 06 -> 105,106,135,137,
        Jan 06 - Dec 06 -> 133,134,136,138
        ***/
        
        set05List = "74,75,86,91,89,90,92,95,105,106,135,137,133,134,136,138";
    
        /***
        06/07 -> 107,132,148,150,
        Aug 06 - Jan 07 -> 140,141,142,143,
        Jan 07 - Jun 07 -> 162,164,165,169,
        Jan 07 - Dec 07 -> 168,170,171,174
        ***/
        
        set06List = "107,132,148,150,140,141,142,143,162,164,165,169,168,170,171,174";
    
        /***
        07/08 -> 166,167,172,175,
        Aug 07 - Jan 08 -> 176,177,179,180,
        Jan 08 - Jun 08 -> 187,192,200,204,
        Jan 08 - Dec 08 -> 201,205,206,212
        ***/
    
        set07List = "166,167,172,175,176,177,179,180,187,192,200,204,201,205,206,212";
    
        /***
        08/09 -> 191,215,219,222,
        Aug 08 - Jan 09 -> 203,216,220,221,
        Jan 09 - Jun 09 -> 234,235,242,243,246,
        Jan 09 - Dec 09 -> 241,244,247,249,250
        ***/
    
        set08List = "191,215,219,222,203,216,220,221,234,235,242,243,246,241,244,247,249,250";
    
        /***
        09/10 -> 251,252,253,254,
        Aug 09 - Jan 10 -> 263,266,267,269,
        Jan 10 - Jun 10 -> 277,278,280,295,
        Jan 10 - Dec 10 -> 289,290,293,296
        ***/
    
        set09List = "251,252,253,254,263,266,267,269,277,278,280,295,289,290,293,296";
    
	
		// Set XLS File Name
		XLSFileName = 'DOSListOfStudents.xls';
    </cfscript>


    <cfquery name="qGetStudents" datasource="mysql">
        SELECT
            s.studentID,
            s.firstName,
            s.familyLastName,
            s.cancelDate,
            s.termination_date,
            s.cancelReason,
            p.programName
        FROM
            smg_students s
        INNER JOIN
            smg_programs p ON p.programID = s.programID           		
        WHERE
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#set09List#" list="yes"> )    
        AND
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND        
            s.cancelDate IS NOT NULL    
    </cfquery>

</cfsilent>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=#XLSFileName#">

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>

    <table border="1" style="font-family:Verdana, Geneva, sans-serif; font-size:9pt;">
        <tr>
        	<td style="text-align:center; font-weight:bold;" colspan="7">
            	09/10 Programs
            </td>
		</tr>            
        <tr>
            <td style="width:100px; text-align:left; font-weight:bold;">Student ID</td>
            <td style="width:200px; text-align:left; font-weight:bold;">Last Name</td>
            <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
            <td style="width:200px; text-align:left; font-weight:bold;">Program</td>
            <td style="width:100px; text-align:center; font-weight:bold;">Date</td>
            <td style="width:500px; text-align:center; font-weight:bold;">Reason</td>
            <td style="width:200px; text-align:center; font-weight:bold;">Classification</td>
        </tr>
        
        <cfloop query="qGetStudents">
      		
            <tr>
                <td>#qGetStudents.studentID#</td>
                <td>#qGetStudents.familyLastName#</td>
                <td>#qGetStudents.firstName#</td>
                <td>#qGetStudents.programName#</td>
                <td>#DateFormat(qGetStudents.cancelDate, 'dd/mmm/yyyy')#</td>
                <td>#qGetStudents.cancelReason#</td>
                <td></td>
            </tr>
        
      </cfloop>
</table>

</cfoutput> 
