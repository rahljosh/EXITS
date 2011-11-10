<!----Default your form variables for error checking---->
<Cfparam name="form.state" default="">

<style type="text/css">
#form table tr .text {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #000;
}
</style>
<h2>Become a Partner</h2>
<p>Thank you for your interest in our programs. As CSB is currently expanding its network, we would like to know more about your organization. Please fill in and submit the below form and someone from our office will contact you as soon as possible.</p>
<p>&nbsp; </p>

<cfquery name="qCountryList" datasource="MySQL">
       SELECT countryid, countryname
       FROM smg_countrylist
       ORDER BY Countryname
</cfquery>


<cfform action="/SWT/intl/become_submit.cfm?request=send" method="post" name="form" id="form"> 
<table width="600px" align="center">
                <tr>
                  <td width="37%" class="text"><div align="right">Company Name:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="companyName" type="Text" class="text" id="companyName" size="50" maxlength="50"></td>
                </tr>
                <tr bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Primary Contact:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="primaryContact" type="Text" class="text" id="primaryContact" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Title:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="title" type="Text" class="text" id="title" size="50" maxlength="50"></td>
                </tr>
                <tr bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Name of Owner:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="owner" type="Text" class="text" id="owner" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Name of Director:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="director" type="Text" class="text" id="director" size="50" maxlength="50"></td>
                </tr>
                <tr bgcolor="#E6E6E6">
                  <td bgcolor="#E6E6E6" class="text"><div align="right">Primary Contact Email:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="email" type="Text" class="text" id="email" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Phone Number:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="phoneNumber" type="Text" class="text" id="phoneNumber" size="50" maxlength="50"></td>
                </tr>
                <tr bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Mailing Address:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="mailingAddress" type="Text" class="text" id="phone3" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">City:</div></td>
                  <td colspan="2" class="text"><input name="city" type="Text" class="text" id="city" size="30" maxlength="30">&nbsp;&nbsp;Zip Code: &nbsp;<input name="zip" type="Text" class="text" id="zip" size="10" maxlength="10"></td>
                </tr>
        
                <tr bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Country:&nbsp;</div></td>
                  <td colspan="2" class="text">
                  <cfoutput>
                      <cfselect name="country">
                        <option value="0"></option>
                            <cfloop query="qCountryList">
                                <option value="#countryname#">#countryname#</option>
                            </cfloop>
                        </cfselect>
                    </cfoutput>
					</td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Website:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="website" type="Text" class="text" id="website" size="50" maxlength="50"></td>
                </tr>
                <tr bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Date Business was Founded:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="founded" type="Text" class="text" id="founded" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Business License Number:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="license" type="Text" class="text" id="license" size="25" maxlength="25"></td>
                </tr>
                  <tr bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Issuing Authority:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="authority" type="Text" class="text" id="authority" size="25" maxlength="25"></td>
                </tr>
         
                <tr>
                  <td class="text"><div align="right">Number of Offices:&nbsp;</div></td>
                  <td colspan="2" class="text"><select name="numberOffices" id="numberOffices">
                      <option selected>1</option>
                      <option>2</option>
                      <option>3</option>
                      <option>4</option>
                      <option>5</option>
                      <option>6</option>
                      <option>7</option>
                      <option>8</option>
                      <option>9</option>
                      <option>10</option>
                      <option>10+</option>
                    </select>
                  <label for="numberOffices"></label></td>
                </tr>
                <tr bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Number of Years of Previous Summer Work Travel Experience:&nbsp;</div></td>
                  <td colspan="2" class="text">
                    <select name="yearExperience" id="yearExperience">
                      <option selected>1</option>
                      <option>2</option>
                      <option>3</option>
                      <option>4</option>
                      <option>5</option>
                      <option>6</option>
                      <option>7</option>
                      <option>8</option>
                      <option>9</option>
                      <option>10</option>
                      <option>10+</option>
                    </select>
                  <label for="yearInBusiness"></label></td>
                </tr>
               <tr>
                  <td class="text"><div align="right">Do you have a registration to operate cultural exchange programs?:&nbsp;</div></td>
                  <td colspan="2" class="text"><input type="radio" name="registration" id="yes" value="yes" />
                  <label for="yes"></label>YES&nbsp;&nbsp;<input type="radio" name="registration" id="no" value="no" />
                  <label for="no"></label>NO<input type="radio" name="registration" id="na" value="na" />
                  <label for="no"></label>Not Applicable</td>
                </tr>
                 <tr bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Number of Registration (if applicable):&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="numberRegistration" type="Text" class="text" id="numberRegistration" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Number of Summer Work Travel Participants per Year:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="numberParticipants" type="Text" class="text" id="numberParticipants" size="50" maxlength="50"></td>
                </tr>
                <tr  bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Visa Denial Rate (Percentage):&nbsp;</div></td>
                  <td colspan="2" class="text"><select name="visaDenial" id="visaDenial">
                    <option selected>0%</option>
                    <option>5%</option>
                     <option>10%</option>
                     <option>15%</option>
                    <option>20%</option>
                      <option>25%</option>
                      <option>30%</option>
                      <option>35%</option>
                      <option>40%</option>
                      <option>45%</option>
                      <option>50%</option>
                      <option>55%</option>
                      <option>60%</option>
                      <option>65%</option>
                      <option>70%</option>
                      <option>75%</option>
                      <option>80%</option>
                      <option>85%</option>
                      <option>90%</option>
                      <option>95%</option>
                      <option>100%</option>
                    </select>
                  <label for="visaDenial"></label></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Previous Sponsors You Have Worked With:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="sponsorWorked" type="Text" class="text" id="sponsorWorked" size="50" maxlength="50"></td>
                </tr>
                <tr  bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Target Number of Students to be Enrolled with CSB:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="studentsEnrolled" type="Text" class="text" id="studentsEnrolled" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Number of Participants That Would Require <br>
                  Placement Assistance (Percentage):&nbsp;</div></td>
                  <td colspan="2" class="text"><select name="numberAssistance" id="numberAssistance">
                   <option selected>0%</option>
                    <option>5%</option>
                     <option>10%</option>
                     <option>15%</option>
                    <option>20%</option>
                      <option>25%</option>
                      <option>30%</option>
                      <option>35%</option>
                      <option>40%</option>
                      <option>45%</option>
                      <option>50%</option>
                      <option>55%</option>
                      <option>60%</option>
                      <option>65%</option>
                      <option>70%</option>
                      <option>75%</option>
                      <option>80%</option>
                      <option>85%</option>
                      <option>90%</option>
                      <option>95%</option>
                      <option>100%</option>
                    </select>
                  <label for="numberAssistance"></label></td>
                </tr>
                 <tr  bgcolor="#E6E6E6">
                  <td class="text"><div align="right">Official Summer Vacation Dates of Participants (average): &nbsp;</div></td>
                  <td colspan="2" class="text"> From:
                    <input name="vacFrom" type="Text" class="text" id="vacFrom" size="15" maxlength="15"> 
                    To:
                    <input name="vacTo" type="Text" class="text" id="vacTo" size="15" maxlength="15">
                   
                </tr>
                <tr>
                  <td colspan="3" class="text"><hr /></td>
                </tr>
                <tr>
                  <td align="center" class="text"></td>
                  <td width="22%" align="center" class="text"><div align="right">
                    <input name="submit" type="Submit" class="text" value="Submit">
                  </div></td>
                  <td width="41%" align="center" class="text">&nbsp;</td>
                </tr>
              </table>
</cfform>
<h2>&nbsp; </h2>
  