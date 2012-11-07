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
    
    <cfscript>
		param name="URL.status" default="active";
	</cfscript>

    <cfquery name="qGetTourList" datasource="MySQL">
        SELECT 
            *
        FROM 	
            smg_tours
       	<cfif URL.status NEQ 'all'>
        	<cfif URL.status EQ 'active'>
            	WHERE
                	tour_status IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="active" list="yes"> )
           	<cfelse>
                WHERE
                    tour_status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.status#">
           	</cfif>
       	</cfif>
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
                <font size=-1><strong>Total Tours: </strong> #qGetTourList.recordcount#</font><br /><br />
                Use the tag <strong>!company!</strong> instead of the company name. It will be changed automatically.<br />
            </td>
            <td align="right">
            	<cfif URL.status NEQ 'all'>
                	<a href="?curdoc=tours/student-tours/index&status=all">[All]</a>
               	<cfelse>
                	All
               	</cfif>
                <cfif URL.status NEQ 'active'>
                	<a href="?curdoc=tours/student-tours/index&status=active">[Active]</a>
               	<cfelse>
					Active
               	</cfif>
                <cfif URL.status NEQ 'inactive'>
                	<a href="?curdoc=tours/student-tours/index&status=inactive">[Inactive]</a>
              	<cfelse>
                	Inactive
              	</cfif>
                <cfif URL.status NEQ 'cancelled'>
                	<a href="?curdoc=tours/student-tours/index&status=cancelled">[Cancelled]</a>
              	<cfelse>
                	Cancelled
              	</cfif>
            </td>
        </tr>
    </table>

	<cfloop query="qGetTourList">
        <table width="100%" align="center" cellpadding="3" cellspacing="2" class="section">
            <tr <cfif qGetTourList.packetfile is ''>bgcolor="##FFCCCC"</cfif>>
                <td width="120">
                	<a href="?curdoc=tours/student-tours/tourDetails&tour_id=#qGetTourList.tour_id#"><img src="../nsmg/uploadedfiles/student-tours/#qGetTourList.tour_img2#.jpg" width="100px" height="100px" /></a>
                </td>
                <td>
                    <strong><u><a href="?curdoc=tours/student-tours/tourDetails&tour_id=#qGetTourList.tour_id#">#qGetTourList.tour_name#</a></u></strong> <br />
                    <strong>Status:</strong> #qGetTourList.tour_status#<br />
                    <strong>Date:</strong> #qGetTourList.tour_date#<br />
                    <strong>Price:</strong> #DollarFormat(qGetTourList.tour_price)#<br />
                    <strong>Charge Type:</strong> #qGetTourList.chargeType#<br />
                    <strong>Packet File:</strong> <cfif LEN(qGetTourList.packetfile)>#qGetTourList.packetfile#<cfelse>NO FILE ON RECORD</cfif>
                </td>
                <td width="10%"><div align="center"><a href="?curdoc=tours/student-tours/tourDetails&tour_id=#qGetTourList.tour_id#"><img src="pics/edit.gif" border="0" /></a></div></td>
            </tr>
        </table>
	</cfloop>

	<table width="100%" align="center" cellpadding="3" cellspacing="2" class="section">        
    	<tr><td align="center"><a href="?curdoc=tours/student-tours/add_tour"><img src="pics/new.gif" border="0"></a></td></tr>
    </table>

	<!--- Table Footer --->    
    <gui:tableFooter />

</cfoutput>