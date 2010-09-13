<cfquery name="tours" datasource="MySQL">
	SELECT *
	FROM smg_tours
	WHERE tour_id = '#url.tour_id#'
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><!--- <img src="pics/helpdesk.gif"> ---></td>
		<td background="pics/header_background.gif"><h2>Student's Tours </h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=2 width=100% class="section">
<tr>
  <td>
	<font size=-1><b>Edit Tour </b></font></td>
</tr>
</table>

<cfoutput>
	<cfform name="add_tour" method="post" action="?curdoc=tools/student-tours/edit_tour_qr&tour_id=#url.tour_id#" enctype="multipart/form-data" preloader="no">
	  <table width="100%" align="center" cellpadding="3" cellspacing="2" bgcolor="ffffe6" class="section">
        <tr>
          <td width="10%" valign="top"><div align="right"><b>Name:</b></div></td>
          <td width="90%" valign="top"><cfinput type="text" value="#tours.tour_name#" name="tour_name" size="70" required="yes" message="Please enter a Tour Name"></td>
        </tr>
        <tr>
          <td width="10%" valign="top"><div align="right"><b>Date:</b></div></td>
          <td valign="top"><cfinput type="text" name="tour_date" value="#tours.tour_date#" size="70" required="yes" message="Please enter a Tour Date"></td>
        </tr>
        
        <tr>
          <td width="10%" valign="top"><div align="right"><b>Price:</b></div></td>
          <td valign="top"><cfinput type="text" name="tour_price" value="#tours.tour_price#" size="70" required="yes" message="Please enter a Tour Price"></td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Flight Arrival Details: (for travel agent use)</b> <br />Please airport and  arrival/departure time window at final destination. 
          </div></td>
          <td valign="top"><textarea name="tour_flightdetails" cols="70" rows="7">#tours.tour_flightdetails#</textarea></td>
        </tr>
        <tr>
          <td valign="top"><div align="right"><b>Description:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_description" cols="70" rows="7">#tours.tour_description#</textarea></td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Flights:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_flights" cols="70" rows="7">#tours.tour_flights#</textarea></td>
        </tr>

		<tr>
          <td valign="top"><div align="right"><b>Payment:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_payment" cols="70" rows="7">#tours.tour_payment#</textarea></td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Include:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_include" cols="70" rows="7">#tours.tour_include#</textarea></td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b><u>NOT</u> Include:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_notinclude" cols="70" rows="7">#tours.tour_notinclude#</textarea></td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Cancelation Fee:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_cancelfee" cols="70" rows="7">#tours.tour_cancelfee#</textarea></td>
        </tr>

        <tr>
          <td><div align="right"><b>Status:</b> <br />
          </div></td>
          <td><cfselect name="tour_status">
          <option value="Active" <cfif tours.tour_status EQ 'Active'>selected="selected"</cfif>>Active</option>
          <option value="Inactive"<cfif tours.tour_status EQ 'Inactive'>selected="selected"</cfif>>Inactive</option>
		  <option value="Full"<cfif tours.tour_status EQ 'Full'>selected="selected"</cfif>>Full</option>
		  <option value="Male Full"<cfif tours.tour_status EQ 'Male Full'>selected="selected"</cfif>>Male Full</option>
		  <option value="Female Full"<cfif tours.tour_status EQ 'Female Full'>selected="selected"</cfif>>Female Full</option>
		  <option value="Cancelled"<cfif tours.tour_status EQ 'Cancelled'>selected="selected"</cfif>>Cancelled</option>
          </cfselect></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" align="center"><cfinput name="Submit" type="image" src="pics/update.gif" border=0></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
      </table>
	</cfform>
	</cfoutput>

    <cfinclude template="../../table_footer.cfm">