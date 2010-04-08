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
	<font size=-1><b>Add New Tour </b></font></td>
</tr>
</table>


	<cfform name="add_tour" method="post" action="?curdoc=tools/student-tours/add_tour_qr" enctype="multipart/form-data" preloader="no">
	  <table width="100%" align="center" cellpadding="3" cellspacing="2" bgcolor="ffffe6" class="section">
        <tr>
          <td width="10%" valign="top"><div align="right"><b>Name:</b></div></td>
          <td width="90%" valign="top"><cfinput type="text" name="tour_name" size="70" required="yes" message="Please enter a Tour Name"></td>
        </tr>
        <tr>
          <td width="10%" valign="top"><div align="right"><b>Date:</b></div></td>
          <td valign="top"><cfinput type="text" name="tour_date" size="70" required="yes" message="Please enter a Tour Date"></td>
        </tr>
        <tr>
          <td width="10%" valign="top"><div align="right"><b>Price:</b></div></td>
          <td valign="top"><cfinput type="text" name="tour_price" size="70" required="yes" message="Please enter a Tour Price"></td>
        </tr>
        <tr>
          <td valign="top"><div align="right"><b>Description:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_description" cols="70" rows="7"></textarea></td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Flights:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_flights" cols="70" rows="7"></textarea></td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Payment:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_payment" cols="70" rows="7"></textarea></td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Include:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_include" cols="70" rows="7"></textarea></td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b><u>NOT</u> Include:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_notinclude" cols="70" rows="7"></textarea></td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Cancelation Fee:</b> <br />
          </div></td>
          <td valign="top"><textarea name="tour_cancelfee" cols="70" rows="7"></textarea></td>
        </tr>
		<tr>
			<td valign="top"><b>Image 1:</b></td>
			<td valign="top"><cfinput type="file" name="file_upload" size=50 required="yes" enctype="multipart/form-data" message="Please specify a file - Image 1."></td>
		</tr>
		<tr>
			<td colspan="2"><b><font size="1">* Image 1 must be in jpg format. Suggested image size: 300 x 300 pixels.</font></b></td>
		</tr>
		<tr>
			<td valign="top"><b>Image 2:</b></td>
			<td valign="top"><cfinput type="file" name="file_upload2" size=50 required="yes" enctype="multipart/form-data" message="Please specify a file - Image 2."></td>
		</tr>
		<tr>
			<td colspan="2"><b><font size="1">* Image 2 must be in jpg format. Suggested image size: 175 x 175 pixels.</font></b></td>
		</tr>

        <tr>
          <td><b>Status:</b> <br /></td>
          <td><cfselect name="tour_status">
          <option value="Active">Active</option>
          <option value="Inactive">Inactive</option>
		  <option value="Full">Full</option>
		  <option value="Cancelled">Cancelled</option>
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

    <cfinclude template="../../table_footer.cfm">