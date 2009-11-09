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
          <td width="90%" valign="top">#tours.tour_name#</td>
        </tr>
        <tr>
          <td width="10%" valign="top"><div align="right"><b>Date:</b></div></td>
          <td valign="top">#tours.tour_date#</td>
        </tr>
        <tr>
          <td width="10%" valign="top"><div align="right"><b>Price:</b></div></td>
          <td valign="top">#tours.tour_price#</td>
        </tr>
        <tr>
          <td valign="top"><div align="right"><b>Description:</b> <br />
          </div></td>
          <td valign="top">#tours.tour_description#</td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Flights:</b> <br />
          </div></td>
          <td valign="top">#tours.tour_flights#</td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Payment:</b> <br />
          </div></td>
          <td valign="top">#tours.tour_payment#</td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Include:</b> <br />
          </div></td>
          <td valign="top">#tours.tour_include#</td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b><u>NOT</u> Include:</b> <br />
          </div></td>
          <td valign="top">#tours.tour_notinclude#</td>
        </tr>
		<tr>
          <td valign="top"><div align="right"><b>Cancelation Fee:</b> <br />
          </div></td>
          <td valign="top">#tours.tour_cancelfee#</td>
        </tr>

        <tr>
          <td><div align="right"><b>Status:</b> <br />
          </div></td>
          <td>#tours.tour_status#</td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" align="center"><a href="?curdoc=tools/student-tours/delete_tour_qr&tour_id=#tour_id#"><img src="pics/delete.gif" border="0" /></a></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
      </table>
	</cfform>
	</cfoutput>

    <cfinclude template="../../table_footer.cfm">