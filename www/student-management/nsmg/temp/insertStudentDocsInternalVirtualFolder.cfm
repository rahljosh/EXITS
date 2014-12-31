<!--- This file may need to be run several times, javascript will only open a selection of popups at a time. --->

<cfsetting requestTimeOut = "9999">

<cfoutput>

        <cfquery name="qGetActivePlacedStudents" datasource="#APPLICATION.DSN#">
            SELECT s.studentID, s.uniqueID, MAX(hist.historyID) AS historyID
            FROM smg_students s
            INNER JOIN smg_hosthistory hist ON hist.studentID = s.studentID
            WHERE s.hostID != 0
            AND s.active = 1
            AND s.studentID IN (SELECT studentID FROM smg_flight_info)
            AND s.programID IN (SELECT programID FROM smg_programs WHERE active = 1)
            GROUP BY s.studentID
        </cfquery>
    
        Total Number of students to update: #qGetActivePlacedStudents.recordCount#
        
        <br />
        <br />
        
        <cfset num = 0>
        
        <cfset students = "">
        
        <cfloop query="qGetActivePlacedStudents">
            
            <cfif NOT DirectoryExists(ExpandPath('../uploadedFiles/internalVirtualFolder/#studentID#/#historyID#/flightInformation'))>
                <cfset num = num+1>
                <cfset students = students & "<br />" & studentID>
                <script type="text/javascript">
					window.open("../student/_flightInformation.cfm?uniqueID=#uniqueID#&subAction=update").close();
                </script>
           	<cfelse>
            	<cfdirectory name="files" directory="#ExpandPath('../uploadedFiles/internalVirtualFolder/')##studentID#/#historyID#/flightInformation" action="list">
                <cfif files.recordCount EQ 0>
                	<cfset num = num+1>
                    <cfset students = students & "<br />" & studentID>
					<script type="text/javascript">
                        window.open("../student/_flightInformation.cfm?uniqueID=#uniqueID#&subAction=update").close();
                    </script>
                </cfif>
            </cfif>
            
        </cfloop>
        
        <cfif num GT 0>
            Percent of students up to date before this run: #DecimalFormat( ((qGetActivePlacedStudents.recordCount - num) / qGetActivePlacedStudents.recordCount)*100 )#%
            <br />
            Number of students who were run this time: #num# (Run again)
        <cfelse>
            There are no more records to run.
        </cfif>
        
        <br />
        <br />
        
        #students#
        
        <cfif num NEQ 0>
        	<script type="text/javascript">
				window.location.reload();
			</script>
        </cfif>
    
</cfoutput>