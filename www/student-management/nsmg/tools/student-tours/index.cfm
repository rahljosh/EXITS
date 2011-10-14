<!--- ------------------------------------------------------------------------- ----
	
	File:		tourDetails.cfm
	Author:		Marcus Melo
	Date:		October 13, 2011
	Desc:		

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	

    <cfquery name="qGetTourList" datasource="MySQL">
        SELECT 
            *
        FROM 	
            smg_tours
        ORDER BY 
            tour_name
    </cfquery>

</cfsilent>

<cfoutput>

	<!--- Table Header --->    
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="Student's Tours"
    />
    
    <table width="100%" align="center" cellpadding="3" cellspacing="2" class="section">
        <tr>
            <td>
                <font size=-1><b>Total Tours: </b> #qGetTourList.recordcount#</font><br /><br />
                Use the tag <b>!company!</b> instead of the company name. It will be changed automatically.<br />
            </td>
        </tr>
    </table>

	<cfloop query="qGetTourList">
        <table width="100%" align="center" cellpadding="3" cellspacing="2" class="section">
            <tr <cfif qGetTourList.packetfile is ''>bgcolor="##FFCCCC"</cfif>>
                <td width="120"><img src="#CLIENT.exits_url#/nsmg/uploadedfiles/student-tours/#tour_img2#.jpg" width="100px" height="100px" /></td>
                <td>
                    <b><u>#qGetTourList.tour_name#</u></b> <br />
                    <b>Status:</b> #qGetTourList.tour_status#<br />
                    <b>Date:</b> #qGetTourList.tour_date#<br />
                    <b>Packet File:</b> <Cfif qGetTourList.packetfile is ''>NO FILE ON RECORD<cfelse>#packetfile#</Cfif>
                </td>
                <td width="10%"><div align="center"><a href="?curdoc=tools/student-tours/tourDetails&tour_id=#qGetTourList.tour_id#"><img src="pics/edit.gif" border="0" /></a></div></td>
                <td width="10%"><div align="center"><a href="?curdoc=tools/student-tours/delete_tour&tour_id=#qGetTourList.tour_id#"><img src="pics/delete.gif" border="0" /></a></div></td>
            </tr>
        </table>
	</cfloop>

	<table width="100%" align="center" cellpadding="3" cellspacing="2" class="section">        
    	<tr><td align="center"><a href="?curdoc=tools/student-tours/add_tour"><img src="pics/new.gif" border="0"></a></td></tr>
    </table>

	<!--- Table Footer --->    
    <gui:tableFooter />

</cfoutput>