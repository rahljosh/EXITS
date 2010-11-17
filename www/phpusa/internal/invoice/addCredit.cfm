<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Add Creidt</title>
<body onLoad="opener.location.reload()"> 
</head>

<body>
<cfoutput>
<cfif isDefined('form.insert')>
  <cfquery name="credit_Details" datasource="#application.dsn#">
            INSERT INTO egom_payments 
                (date_received, date_applied, transaction, paymenttypeid, userid, intrepid, total_amount, description, companyid)
            VALUES 
                (#CreateODBCDate(form.date_received)#, #CreateODBCDateTime(now())#, '#form.ref#', '#form.payment_method#', #client.userid#, #url.intrep#, '#form.payment_amount#', 'Credit Applied to Account via Add Credit Link', #client.companyid#)
        </cfquery>
        <cfquery name="paymentid" datasource="#application.dsn#">
        select max(paymentid) as paymentid_current
        from egom_payments
        </cfquery>
        <cfquery datasource="#application.dsn#">
        insert into egom_credits (date, amount, intrep, originalPayRef, origPayId)
        				values (#CreateODBCDate(form.date_received)#, '#form.payment_amount#', #url.intrep#, '#form.ref#', #paymentid.paymentid_current#)
        </cfquery>
<h2>Credit has been added to account and is now available.</h2>
If this window doesn't close automatically, you can close it. 
<Cfelse>
<cfform method="post" action="addCredit.cfm?intrep=#url.intrep#">
<input type="hidden" name="insert" />
    <table border="0" cellpadding="3" cellspacing="0" width="100%">
        <tr><th colspan="8" bgcolor="##C2D1EF">Credit	 Details</th></tr>
        <tr>
             
            <td>Payment Method:</td>
            <td>
                <cfquery name="payment_methods" datasource="mysql">
                    SELECT *
                    FROM egom_payment_type
                    ORDER BY 
                        paymentType DESC			
                </cfquery>
                <select name="payment_method">
                <option value="0"></option>
                <cfloop query="payment_methods">
                <option value="#paymenttypeid#">#paymenttype#</option>
                </cfloop>
                </select>
            </td>
           
            <td>Reference:</td>
            <td><cfinput type="text" name="ref" message="You must suplly a reference number. Please use check or wire transfer confermation number." validateat="onSubmit" required="yes" size=10></td>
            <td>Amount:</td>
            <td><cfinput type="text" name="payment_amount" size=10 value=""></td>
            
        </tr>
        <tr>
            <td>Date Received:</td><td><cfinput type="text" name="date_received" value="" class="date-pick"/></td>
            <td>Date Applied:</td><td>#DateFormat(now(),'mm/dd/yy')# </td>
        </tr>
        <Tr>
            <Td colspan=4><input type="image" src="../pics/submit.gif"  />
        </Tr>
    </table>
</cfform>
</cfif>
                            </cfoutput>
</body>
</html>