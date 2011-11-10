<style type="text/css">
#form table tr .text {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #000;
}
</style><br />
<h2>Online Application</h2>
<p>If you are interested in learning more about CSB Summer Work Travel Program and becoming an international partner please fill in and submit the form below and someone from our office will contact you as soon as possible. <strong>Thank you.</strong></p><br />
<cfquery name="qCountryList" datasource="MySQL">
       SELECT countryid, countryname
       FROM smg_countrylist
       ORDER BY Countryname
</cfquery>


<cfform action="online_submit.cfm?request=send" method="post" name="form" id="form"> 
              <table width="600px" align="center">
                <tr>
                  <td width="41%" class="text"><div align="right">Company Name:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="companyName" type="Text" class="text" id="companyName" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Primary Contact:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="primaryContact" type="Text" class="text" id="primaryContact" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Title:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="title" type="Text" class="text" id="title" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Email:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="email" type="Text" class="text" id="email" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Phone Number:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="phoneNumber" type="Text" class="text" id="phoneNumber" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Mailing Address:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="mailingAddress" type="Text" class="text" id="phone3" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Country:&nbsp;</div></td>
                  <td colspan="2" class="text">
                  <cfoutput>
                      <cfselect name="country">
                        <option value="0"></option>
                            <cfloop query="qCountryList">
                                <option value="#countryid#">#countryname#</option>
                            </cfloop>
                        </cfselect>
                    </cfoutput>
					</td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Number of Years in Business:&nbsp;</div></td>
                  <td colspan="2" class="text">
                    <select name="yearInBusiness" id="yearInBusiness">
                      <option selected>years</option>
                      <option>1</option>
                      <option>2</option>
                      <option>3</option>
                      <option>4</option>
                      <option>5</option>
                      <option>6</option>
                      <option>7</option>
                      <option>8</option>
                      <option>9</option>
                      <option>10</option>
                      <option>11</option>
                      <option>12</option>
                      <option>13</option>
                      <option>14</option>
                      <option>15</option>
                      <option>16</option>
                      <option>17</option>
                      <option>18</option>
                      <option>19</option>
                      <option>20</option>
                      <option>20+</option>
                      
                    </select>
                  <label for="yearInBusiness"></label></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Number of Offices:&nbsp;</div></td>
                  <td colspan="2" class="text"><select name="numberOffices" id="numberOffices">
                      <option selected>offices</option>
                      <option>1-5</option>
                      <option>5-10</option>
                      <option>10-15</option>
                      <option>20+</option>
                    </select>
                  <label for="numberOffices"></label></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Number Summer Work Travel Participants per Year:&nbsp;</div></td>
                  <td colspan="2" class="text"><select name="numberParticipants" id="numberParticipants">
                      <option selected>participants</option>
                      <option>1-5</option>
                      <option>5-10</option>
                      <option>10-15</option>
                      <option>20-25</option>
                      <option>25-30</option>
                      <option>30+</option>
                    </select>
                  <label for="numberParticipants"></label></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Visa Denial Rate (Percentage):&nbsp;</div></td>
                  <td colspan="2" class="text"><select name="visaDenial" id="visaDenial">
                    <option selected>Rate</option>
                    <option>1%-5%</option>
                     <option>5%-10%</option>
                     <option>15%-20%</option>
                    <option>20%-25%</option>
                      <option>25%-30%</option>
                      <option>30%-35%</option>
                      <option>35%-40%</option>
                      <option>40%-55%</option>
                      <option>55%-60%</option>
                      <option>60%-65%</option>
                      <option>65%-70%</option>
                      <option>70%-75%</option>
                      <option>75%-80%</option>
                      <option>80%-85%</option>
                      <option>85%-90%</option>
                      <option>90%-95%</option>
                      <option>95%-100%</option>
                    </select>
                  <label for="visaDenial"></label></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Previous Sponsors You Have Worked With:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="sponsorWorked" type="Text" class="text" id="phone7" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Target Number of Students to be Enrolled with CSB:&nbsp;</div></td>
                  <td colspan="2" class="text"><select name="studentsEnrolled" id="studentsEnrolled">
                      <option selected>students</option>
                      <option>1-5</option>
                      <option>5-10</option>
                      <option>10-15</option>
                      <option>20-25</option>
                      <option>25-30</option>
                      <option>30+</option>
                    </select>
                  <label for="studentsEnrolled"></label></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Number of Participants That Would Require <br>
                  Placement Assistance (Percentage):&nbsp;</div></td>
                  <td colspan="2" class="text"><select name="numberAssistance" id="numberAssistance">
                  <option selected>Percent</option>
                  <option>1%-5%</option>
                      <option>5%-10%</option>
                      <option>15%-20%</option>
                      <option>20%-25%</option>
                      <option>25%-30%</option>
                      <option>30%-35%</option>
                      <option>35%-40%</option>
                      <option>40%-55%</option>
                      <option>55%-60%</option>
                      <option>60%-65%</option>
                      <option>65%-70%</option>
                      <option>70%-75%</option>
                      <option>75%-80%</option>
                      <option>80%-85%</option>
                      <option>85%-90%</option>
                      <option>90%-95%</option>
                      <option>95%-100%</option>
                    </select>
                  <label for="numberAssistance"></label></td>
                </tr>
                <tr>
                  <td colspan="3" class="text"><hr /></td>
                </tr>
                <tr>
                  <td align="center" class="text"></td>
                  <td width="31%" align="center" class="text"><div align="right">
                    <input name="submit" type="Submit" class="text" value="Submit">
                  </div></td>
                  <td width="28%" align="center" class="text">&nbsp;</td>
                </tr>
              </table>
</cfform>
              
              <h2>&nbsp;</h2>