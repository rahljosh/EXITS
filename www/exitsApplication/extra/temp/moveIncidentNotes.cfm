<cfscript>
	qGetIncidents = APPLICATION.CFC.CANDIDATE.getIncidentReport();
</cfscript>

<cfquery name="qGetReportsWithNotes" datasource="#APPLICATION.DSN.Source#">
    SELECT DISTINCT reportID
    FROM extra_incident_report_notes
</cfquery>

<cfset reportIDs=ValueList(qGetReportsWIthNotes.reportID)>

<cfset failed=ArrayNew(1)>
<cfset x = 1>

<cfoutput query="qGetIncidents">
	<cfif NOT ListFind(reportIDs,id)>
		<cftry>
			<cfscript>
                allNotes = ArrayNew(2);
                notesFromNote = qGetIncidents.notes;
                i = 1;
                while(FIND("<p>",notesFromNote)) {
                    temp = #MID(notesFromNote,1,FIND("</p>",notesFromNote)-2)#;
                    note = ArrayNew(1);
                    note[1] = #MID(temp,1,FIND("</strong>",temp)-1)#;
                    note[1] = #MID(note[1],FIND("<strong>",note[1])+8,LEN(note[1]))#;
                    note[2] = #MID(temp,FIND("<br / >",temp)+7,LEN(temp))#;
                    if (FIND("Anca",note[2])) {
                        note[3] = 7935;
                    } else if (FIND("Elena",note[2])) {
                        note[3] = 12038;
                    } else if (FIND("Ryan",note[2])) {
                        note[3] = 19658;
                    } else {
                        note[3] = 0;	
                    }
                    date = #MID(note[2],FIND("on ",note[2])+3,LEN(note[2]))#;
                    date = #MID(date,1,FIND(" at",date)-1)#;
                    note[4] = date;
                    time = #MID(note[2],FIND("at ",note[2])+3,LEN(note[2]))#;
                    if (FIND("AM",note[2])) {
                        time = #MID(time,1,FIND(" AM",time)-1)#;
                    } else {
                        time = #MID(time,1,FIND(" PM",time)-1)#;
                    }
                    note[5] = time;
                    datetime = date & " " & time & ":00";
                    datetime = Replace(datetime,"/","-");
                    datetime = Replace(datetime,"/","-");
                    note[6] = ParseDateTime(datetime,"MM-dd-yyyy HH:mm:ss");
                    if (FIND("PM",note[2])) {
                        note[6] = DateAdd("h",12,note[6]);	
                    }
                    allNotes[i] = note;
                    notesFromNote = #MID(notesFromNote,FIND("</p>",notesFromNote)+2,LEN(notesFromNote))#;
                    i = i + 1;
                }
            </cfscript>
            <cfloop array="#allNotes#" index="i">
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO extra_incident_report_notes (
                        reportID,
                        addedBy,
                        date,
                        note )
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#LSParseNumber(i[3])#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#i[6]#">,
                        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#i[1]#"> )
                </cfquery>
            </cfloop>
      	<cfcatch type="any">
        	<cfset failed[x] = id>
            <cfset x = x + 1>
        </cfcatch>
        </cftry>
    </cfif>
</cfoutput>

<cfoutput>
	Failed:<br/>
    <cfloop array="#failed#" index="j">
    	#j#<br/>
    </cfloop>
</cfoutput>