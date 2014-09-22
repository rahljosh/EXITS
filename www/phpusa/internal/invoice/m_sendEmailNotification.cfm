<cfparam name="missingEmail" default="0">

<cfif form.selectPrograms EQ "ALL">

	<!--- GET ALL AGENTS THAT HAVE AT LEAST ONE UNPAID STUDENT EVEN IF THERE OVERALL BALANCE = (EQUAL) ZERO.
    THEN REPOPULATE VARIABLE #FORM.AGENTID# BECAUSE IT HAS ONLY AGENTS WHOSE BALANCE IS GREATER THAN ZERO.
    THIS WILL HAPPEN ONLY IF "ALL PROGRAMS WERE SELECTED" IN THE REPORT.
    OTHERWISE THE VARIABLE #FORM.AGENTID# WILL CONTAIN ONLY THE AGENT IDS OF THOSE AGENTS CHECK MARKED --->
    <cfquery name="getAllRepIds" datasource="MySQL"> 
    SELECT ttt.intrepid, SUM(ttt.amount) AS amount     
    FROM (        
    
        SELECT t.intrepid, t.studentid, t.programid, SUM(t.amount) AS amount            
        FROM (
            SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, ei.intrepid, CONCAT(ss.firstname, " ", ss.familylastname, " ", "(", ec.studentid, ")") AS student_name, ec.studentid, CONCAT(sp.programname, " (", ec.programid, ")") AS program, ec.programid, SUM(ec.amount) AS amount, psp.active
            FROM egom_charges ec  
            INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid          
            INNER JOIN smg_users su on su.userid = ei.intrepid
            LEFT OUTER JOIN php_students_in_program psp on psp.studentid = ec.studentid 
            AND psp.programid = ec.programid
            INNER JOIN smg_students ss on ss.studentid = psp.studentid
            LEFT OUTER JOIN smg_programs sp on sp.programid = ec.programid
            WHERE ec.studentid != 0       
            AND sp.startdate >= '2009-08-01'
            GROUP BY  ec.studentid, ec.programid
        
            UNION ALL
        
            SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, ei.intrepid, CONCAT(ss.firstname, " ", ss.familylastname, " ", "(", ec.studentid, ")") AS student_name, ec.studentid, CONCAT(sp.programname, " (", ec.programid, ")") AS program, ec.programid, IFNULL(SUM(epc.amount_paid), 0) * -1 AS amount, psp.active
            FROM egom_payment_charges epc  
            RIGHT JOIN egom_charges ec on ec.chargeid = epc.chargeid              
            INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid
            INNER JOIN smg_users su on su.userid = ei.intrepid
            LEFT OUTER JOIN php_students_in_program psp on psp.studentid = ec.studentid AND psp.programid = ec.programid
            INNER JOIN smg_students ss on ss.studentid = psp.studentid
            LEFT OUTER JOIN smg_programs sp on sp.programid = ec.programid
            WHERE ec.studentid != 0      
            AND sp.startdate >= '2009-08-01'
            GROUP BY  ec.studentid, ec.programid
            
        ) t
        GROUP BY t.studentid, t.programid HAVING amount > 0 
        
    UNION ALL    
    
        SELECT tt.intrepid, tt.invoiceid, tt.programid, SUM(tt.amount) AS amount            
        FROM (
            SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, ei.intrepid, 'Invoice Number', CONCAT('Invoice Number ',ec.invoiceid), ec.invoiceid, ec.programid, SUM(ec.amount) AS amount, 'Miscellaneous Charge Unpaid'
            FROM egom_charges ec  
            INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid          
            INNER JOIN smg_users su on su.userid = ei.intrepid 
            WHERE ec.studentid = 0    
            AND ec.date >= '2009-12-01'   
            GROUP BY  ec.invoiceid             
    
        UNION ALL            
                                
            SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, ei.intrepid, 'Invoice Number', CONCAT('Invoice Number ',ec.invoiceid), ec.invoiceid, ec.programid, IFNULL(SUM(epc.amount_paid), 0) * -1 AS amount, 'Miscellaneous Charge Unpaid'
            FROM egom_payment_charges epc  
            RIGHT JOIN egom_charges ec on ec.chargeid = epc.chargeid              
            INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid
            INNER JOIN smg_users su on su.userid = ei.intrepid
            WHERE ec.studentid = 0
            AND ec.date >= '2009-12-01'   
            GROUP BY  ec.invoiceid            
            
        ) tt
        GROUP BY tt.invoiceid HAVING amount > 0            
    
    ) ttt        
    
    GROUP BY ttt.intrepid 
    </cfquery>
    
    <cfset form.agentid = 0>
	<cfset form.agentid = valueList(getAllRepIds.intrepid)>

</cfif>

<cfloop list="#form.agentId#" index="indexAgentId">
	
    <cfif ISDEFINED('form.email#indexAgentId#') OR form.selectPrograms EQ "ALL">
    
        <cfquery name="getStudentAmounts" datasource="MySQL">
            SELECT t.intl_rep, t.student_name, t.studentid, t.program, SUM(t.amount) AS amount, t.active
            
            FROM (
            
                SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, CONCAT(ss.firstname, " ", ss.familylastname, " ", "(", ec.studentid, ")") AS student_name, ec.studentid, CONCAT(sp.programname, " (", ec.programid, ")") AS program, ec.programid, SUM(ec.amount) AS amount, psp.active
                FROM egom_charges ec  
                INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid          
                INNER JOIN smg_users su on su.userid = ei.intrepid
                LEFT OUTER JOIN php_students_in_program psp on psp.studentid = ec.studentid 
                AND psp.programid = ec.programid
                INNER JOIN smg_students ss on ss.studentid = psp.studentid
                LEFT OUTER JOIN smg_programs sp on sp.programid = ec.programid
                WHERE ec.studentid != 0       
                AND ei.intrepid = #indexAgentId#
                AND sp.startdate >= '2009-08-01'
                GROUP BY ec.studentid, ec.programid
            
                UNION ALL
            
                SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, CONCAT(ss.firstname, " ", ss.familylastname, " ", "(", ec.studentid, ")") AS student_name, ec.studentid, CONCAT(sp.programname, " (", ec.programid, ")") AS program, ec.programid, IFNULL(SUM(epc.amount_paid), 0) * -1 AS amount, psp.active
                FROM egom_payment_charges epc  
                RIGHT JOIN egom_charges ec on ec.chargeid = epc.chargeid              
                INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid
                INNER JOIN smg_users su on su.userid = ei.intrepid
                LEFT OUTER JOIN php_students_in_program psp on psp.studentid = ec.studentid AND psp.programid = ec.programid
                INNER JOIN smg_students ss on ss.studentid = psp.studentid
                LEFT OUTER JOIN smg_programs sp on sp.programid = ec.programid
                WHERE ec.studentid != 0
                AND ei.intrepid = #indexAgentId#       
                AND sp.startdate >= '2009-08-01'
                GROUP BY ec.studentid, ec.programid                    

            UNION ALL
            
                SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, CONCAT('Invoice Number ',ec.invoiceid), ec.invoiceid, ec.description, ec.invoiceid, SUM(ec.amount) AS amount, 1
                FROM egom_charges ec  
                INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid          
                INNER JOIN smg_users su on su.userid = ei.intrepid 
                WHERE ec.studentid = 0    
                AND ec.date >= '2009-12-01'  
                AND ei.intrepid = #indexAgentId# 

                GROUP BY ec.invoiceid              

            UNION ALL            
                                    
                SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, CONCAT('Invoice Number ',ec.invoiceid), ec.invoiceid, ec.description, ec.invoiceid, IFNULL(SUM(epc.amount_paid), 0) * -1 AS amount, 1
                FROM egom_payment_charges epc  
                RIGHT JOIN egom_charges ec on ec.chargeid = epc.chargeid              
                INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid
                INNER JOIN smg_users su on su.userid = ei.intrepid
                WHERE ec.studentid = 0
                AND ec.date >= '2009-12-01'
                AND ei.intrepid = #indexAgentId#      

                GROUP BY ec.invoiceid

            ) t
            
            GROUP BY 
                t.studentid, 
                t.programid HAVING amount > 0
            ORDER BY 
                t.intl_rep, 
                t.studentid, 
                t.programid
        </cfquery>

		<cfquery name="getTotalBalancePerAgent" datasource="MySQL"> 
        SELECT ttt.intrepid, SUM(ttt.amount) AS amount     
        FROM (        

            SELECT t.intrepid, t.studentid, t.programid, SUM(t.amount) AS amount            
            FROM (
                SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, ei.intrepid, CONCAT(ss.firstname, " ", ss.familylastname, " ", "(", ec.studentid, ")") AS student_name, ec.studentid, CONCAT(sp.programname, " (", ec.programid, ")") AS program, ec.programid, SUM(ec.amount) AS amount, psp.active
                FROM egom_charges ec  
                INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid          
                INNER JOIN smg_users su on su.userid = ei.intrepid
                LEFT OUTER JOIN php_students_in_program psp on psp.studentid = ec.studentid 
                AND psp.programid = ec.programid
                INNER JOIN smg_students ss on ss.studentid = psp.studentid
                LEFT OUTER JOIN smg_programs sp on sp.programid = ec.programid
                WHERE ec.studentid != 0       
                AND ei.intrepid = #indexAgentId# 
                AND sp.startdate >= '2009-08-01'
                GROUP BY  ec.studentid, ec.programid
            
                UNION ALL
            
                SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, ei.intrepid, CONCAT(ss.firstname, " ", ss.familylastname, " ", "(", ec.studentid, ")") AS student_name, ec.studentid, CONCAT(sp.programname, " (", ec.programid, ")") AS program, ec.programid, IFNULL(SUM(epc.amount_paid), 0) * -1 AS amount, psp.active
                FROM egom_payment_charges epc  
                RIGHT JOIN egom_charges ec on ec.chargeid = epc.chargeid              
                INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid
                INNER JOIN smg_users su on su.userid = ei.intrepid
                LEFT OUTER JOIN php_students_in_program psp on psp.studentid = ec.studentid AND psp.programid = ec.programid
                INNER JOIN smg_students ss on ss.studentid = psp.studentid
                LEFT OUTER JOIN smg_programs sp on sp.programid = ec.programid
                WHERE ec.studentid != 0
                AND ei.intrepid = #indexAgentId#       
                AND sp.startdate >= '2009-08-01'
                GROUP BY  ec.studentid, ec.programid
                
            ) t
            GROUP BY t.studentid, t.programid HAVING amount > 0 
            
    UNION ALL    

            SELECT tt.intrepid, tt.invoiceid, tt.programid, SUM(tt.amount) AS amount            
            FROM (
                SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, ei.intrepid, 'Invoice Number', CONCAT('Invoice Number ',ec.invoiceid), ec.invoiceid, ec.programid, SUM(ec.amount) AS amount, 'Miscellaneous Charge Unpaid'
                FROM egom_charges ec  
                INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid          
                INNER JOIN smg_users su on su.userid = ei.intrepid 
                WHERE ec.studentid = 0    
                AND ec.date >= '2009-12-01'  
                AND ei.intrepid = #indexAgentId# 
                GROUP BY  ec.invoiceid             

            UNION ALL            
                                    
                SELECT CONCAT(su.businessname, " (", ei.intrepid, ")") AS intl_rep, ei.intrepid, 'Invoice Number', CONCAT('Invoice Number ',ec.invoiceid), ec.invoiceid, ec.programid, IFNULL(SUM(epc.amount_paid), 0) * -1 AS amount, 'Miscellaneous Charge Unpaid'
                FROM egom_payment_charges epc  
                RIGHT JOIN egom_charges ec on ec.chargeid = epc.chargeid              
                INNER JOIN egom_invoice ei on ei.invoiceid = ec.invoiceid
                INNER JOIN smg_users su on su.userid = ei.intrepid
                WHERE ec.studentid = 0
                AND ec.date >= '2009-12-01'
                AND ei.intrepid = #indexAgentId#    
                GROUP BY  ec.invoiceid            
                
            ) tt
            GROUP BY tt.invoiceid HAVING amount > 0            
      
        ) ttt        

        GROUP BY ttt.intrepid 
        </cfquery>
		
            <cfquery name="getAgentInfo" datasource="MySQL">
            SELECT *
            FROM smg_users su
            WHERE su.userid = #indexAgentId#
            </cfquery>
            
            <cfif getAgentInfo.php_billing_email IS "" AND getAgentInfo.php_contact_email IS "">
                <cfset missingEmail = 1>
            </cfif>
            
            <cfif getAgentInfo.php_contact_email IS NOT "" AND getAgentInfo.php_billing_email IS "">
                <cfquery name="getAgentInfoSecRun" datasource="MySQL">
                UPDATE smg_users su
                SET su.php_billing_email = su.php_contact_email
                WHERE userid = #indexAgentId#
                </cfquery>
                
                <cfquery name="getAgentInfo" datasource="MySQL">
                SELECT *
                FROM smg_users su
                WHERE su.userid = #indexAgentId#
                </cfquery>
            </cfif>
            
            <cfif variables.missingEmail NEQ 1 AND getTotalBalancePerAgent.recordCount NEQ 0>
            													
                <cfmail from="bmccready@iseusa.org" to="#getAgentInfo.php_billing_email#" bcc="bmccready@iseusa.org" subject="#getAgentInfo.businessname# (#getAgentInfo.userid#) - PHP PROGRAM - Balance Due" type="html">
                
                    <style type="text/css">
        
                        table.frame 
                        {
                        border-style:solid;
                        border-width:thin;
                        border-color:##004080;
                        border-collapse:collapse;
                        background-color:##FFFFE1;
                        padding:2px;
                        }
                        
                        td.right
                        {
                        font:Arial, Helvetica, sans-serif;
                        font-style:normal;
                        font-size:medium;
                        color:##FFFFFF;
                        font-weight:bold;
                        border-right-style:solid;
                        border-right-width:thin;
                        border-right-color:##004080;
                        border-right-collapse:collapse;
                        padding:4px;
                        }
                        
                        .two
                        {
                        font:Arial, Helvetica, sans-serif;
                        font-style:normal;
                        font-size:medium;
                        border-right-style:solid;
                        border-right-width:thin;
                        border-right-color:##004080;
                        border-right-collapse:collapse;
                        padding:4px;
                        }
                        
                        tr.darkBlue
                        {
                        background-color:##0052A4;
                        }
                    
                        .style2 {color: ##FF0000}
                    
                    </style>
                
                    Dear Partner<br/><br/>
                    
                    Could you please remit the payment of your total PHP balance amount<strong>#LsCurrencyFormat(getTotalBalancePerAgent.amount)#</strong> as soon as possible?<br/><br/>
                    
                    This total amount is due for the following students:<br/><br/>
                
                    <table class="frame">
                                
                        <tr class="darkBlue">
                            <td class="right">
                                <strong><small>Student Name</small></strong>
                            </td>
                            <td class="right">
                                <strong><small>Program</small></strong>
                            </td>
                            <td class="right">
                                <strong><small>Amount</small></strong></td>
                            <td class="right">
                                <strong><small>Status</small></strong>
                            </td>
                        </tr>
                    
                        <cfloop query="getStudentAmounts">
                
                            <tr <cfif getStudentAmounts.currentRow MOD 2>bgcolor="##FFFFFF"</cfif>>
                                <td class="two">
                                    <small>#toString(getStudentAmounts.student_name)#</small>
                                </td>
                                <td class="two">
                                    <small>#toString(getStudentAmounts.program)#</small>
                                </td>
                                <td class="two">
                                    <small>#LsCurrencyFormat(getStudentAmounts.amount)#</small>
                                </td>
                                <td class="two">
                                    <small>
                                       <cfif getStudentAmounts.active EQ 1>
                                            active
                                            <cfelse>
                                                inactive
                                        </cfif>
                                    </small>
                                </td>
    
                            </tr>
                        </cfloop>
            
                        <tr style="background-color:##0052A4;">
                            <td class="right"></td>
                            <td class="right"><strong><small>Total</small></strong></td>
                            <td class="right">
                                #LsCurrencyFormat(getTotalBalancePerAgent.amount)#
                            </td>
                            <td class="right"></td>
                        </tr>
                                
                    </table><br/>
            
                    We are waiting for your confirmation. Please get back to us as soon as possible.<br/><br/>
                    
                    Best regards,<br/>
                    Bryan
        
                </cfmail>
                
                <cfelse>
                    Missing Email:	
                    <cfoutput>
                        <a href="http://www.student-management.com/nsmg/index.cfm?curdoc=forms/edit_user&userid=#indexAgentId#" 
                        target="_blank">#getAgentInfo.businessname#</a>
                    </cfoutput><br/>
                
            </cfif>
	
	</cfif>
    
</cfloop>

<cfif variables.missingEmail NEQ 1>
	<script>
        window.close();
    </script>
</cfif>