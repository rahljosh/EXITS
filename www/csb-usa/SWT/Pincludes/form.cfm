<style type="text/css">
#form table tr .text {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #000;
}
</style><br />
<h2><strong>Apply for Summer Work Travel Program</strong></h2>
<p>When you are ready to apply for the program and begin the application  procedure, please visit our CSB International Partner's office. If you have not found one, please fill in this form and we will recommend you one of our valuable partners in your home country.</p>
<br />
<cfquery name="qCountryList" datasource="MySQL">
       SELECT countryid, countryname
       FROM smg_countrylist
       ORDER BY Countryname
</cfquery>


<cfform action="form_submit.cfm?request=send" method="post" name="form" id="form"> 
              <table width="520" align="center">
                <tr>
                  <td width="41%" class="text"><div align="right">Last Name:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="lastName" type="Text" class="text" id="lastName" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">First Name:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="firstName" type="Text" class="text" id="firstName" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Date of Birth:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="dob" type="Text" class="text" id="dob" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Email:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="email" type="Text" class="text" id="email" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">City:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="city" type="Text" class="text" id="city" size="50" maxlength="50"></td>
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
                  <td class="text"><div align="right">Are you a University Student:&nbsp;</div></td>
                  <td colspan="2" class="text"><input type="radio" name="UniversityStudent" id="yes" value="yes" />
                  <label for="yes">YES</label>&nbsp;<input type="radio" name="UniversityStudent" id="no" value="no" />
                  <label for="no">NO</label></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Years of Study:&nbsp;</div></td>
                  <td colspan="2" align="left" class="text"><select name="yearsStudy" id="yearsStudy">
                      <option selected>0</option>
                      <option>1</option>
                      <option>2</option>
                      <option>3</option>
                      <option>4</option>
                      <option>5</option>
                      <option>6</option>
                    </select>
                  <label for="yearsStudy"></label></td>
                </tr>
                  <tr>
                  <td class="text"><div align="right">Do you have a job offer:&nbsp;</div></td>
                  <td colspan="2" class="text"><input type="radio" name="jobOffer" id="yes" value="yes" />
                  <label for="yes">YES</label>&nbsp;<input type="radio" name="job,Offer" id="no" value="no" />
                  <label for="no">NO</label></td>
                </tr>
                <tr>
                <tr>
                  <td align="center" class="text"><div align="right">If YES, please explain:&nbsp;</div></td>
                  <td colspan="2" align="center" class="text"><label for="Comment"></label>
                  <textarea name="Comment" id="Comment" cols="45" rows="5"></textarea></td>
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