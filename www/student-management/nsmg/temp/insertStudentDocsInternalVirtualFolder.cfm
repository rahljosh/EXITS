<!--- This file may need to be run several times, javascript will only open a selection of popups at a time. --->

<cfsetting requestTimeOut = "9999">

<cfoutput>

        <cfquery name="qGetActivePlacedStudents" datasource="#APPLICATION.DSN#">
            SELECT studentID, uniqueID
            FROM smg_students
            WHERE hostID != 0
            AND active = 1
            AND studentID IN (SELECT studentID FROM smg_flight_info)
            AND programID IN (SELECT programID FROM smg_programs WHERE active = 1)
        </cfquery>
    
        Total Number of students to update: #qGetActivePlacedStudents.recordCount#
        
        <br />
        <br />
        
        <cfset num = 0>
        
        <cfloop query="qGetActivePlacedStudents">
            
            <cfif NOT DirectoryExists(ExpandPath('../uploadedFiles/internalVirtualFolder/#studentID#/'))>
                <cfset num = num+1>
                <script type="text/javascript">
					window.open("../student/_flightInformation.cfm?uniqueID=#uniqueID#&subAction=update").close();
                </script>
            </cfif>
            
        </cfloop>
        
        <cfif num GT 0>
            Percent of students updated before this run: #DecimalFormat( ((qGetActivePlacedStudents.recordCount - num) / qGetActivePlacedStudents.recordCount)*100 )#%
            <br />
            Number of students who were run this time: #num# (Run again)
        <cfelse>
            There are no more records to run.
        </cfif>
        
        <br />
        <br />
        <cfloop query="qGetActivePlacedStudents">
        	#studentID#<br />
        </cfloop>
    
</cfoutput>