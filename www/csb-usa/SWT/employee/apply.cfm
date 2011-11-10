<!----Default your form variables for error checking---->
<Cfparam name="form.state" default="">
<style type="text/css">
#form table tr .text {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #000;
}
</style><br />
<h2>How to Apply?</h2>
<p>CSB in excited to hear from you. Please fill-in and submit the form below and someone from our office will contact you as soon as possible. 
<br />
<cfquery name="qCountryList" datasource="MySQL">
       SELECT countryid, countryname
       FROM smg_countrylist
       ORDER BY Countryname
</cfquery>

<cfquery name="states" datasource="mysql">
select statename, state
from smg_states
order by state
</cfquery>
</p>
<cfform action="/SWT/employee/apply_submit.cfm?request=send" method="post" name="form" id="form"> 
              <table width="600px" align="center">
                <tr>
                  <td width="41%" class="text"><div align="right">Company Name:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="companyName" type="Text" class="text" id="companyName" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Industry:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="industry" type="Text" class="text" id="industry" size="50" maxlength="50"></td>
                </tr>
        
                <tr>
                  <td class="text"><div align="right">Mailing Address:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="address" type="Text" class="text" id="address" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">City:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="city" type="Text" class="text" id="city" size="25" maxlength="25"> </td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Zip Code:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="zip" type="Text" class="text" id="zip" size="50" maxlength="50"></td>
                </tr>
                 <tr>
                  <td class="text"><div align="right">Primary Contact:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="primaryContact" type="Text" class="text" id="primaryContact" size="50" maxlength="50"></td>
                </tr>
                  <tr>
                  <td class="text"><div align="right">Phone Number:&nbsp;</div></td>
                  <td class="text"><input name="phoneNumber" type="Text" class="text" id="phoneNumber" size="25" maxlength="25"></td>
                  <td class="text"><select name="phoneType" id="phoneType">
                      <option selected>mobile</option>
                      <option>office</option>
                      <option>other</option>
                    </select>
                  <label for="phoneType"></label></td>
                </tr>
                <td class="text"><div align="right">Fax Number:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="faxNumber" type="Text" class="text" id="faxNumber" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Email:&nbsp;</div></td>
                  <td colspan="2" class="text"><input name="email" type="Text" class="text" id="email" size="50" maxlength="50"></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Hiring Need: &nbsp;</div></td>
                  <td colspan="2" class="text"> Start date:
                    <input name="start" type="Text" class="text" id="start" size="15" maxlength="15"> 
                    End date:
                    <input name="end" type="Text" class="text" id="end" size="15" maxlength="15">
                   
                </tr>
                <tr>
                  <td class="text"><div align="right">How many Summer Work Travel Participants you wish to hire?:&nbsp;</div></td>
                  <td colspan="2" class="text"><select name="hire" id="hire">
                      <option selected>1</option>
                      <option>2</option>
                      <option>3</option>
                      <option>4</option>
                      <option>5+</option>
                    </select>
                  <label for="hire"></label></td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Do you have previous <br />experience with  J-1 Programs?:&nbsp;</div></td>
                  <td colspan="2" class="text"><input type="radio" name="experience" id="yes" value="yes" />
                  <label for="yes"></label>YES&nbsp;&nbsp;<input type="radio" name="experience" id="no" value="no" />
                  <label for="no"></label>NO</td>
                </tr>
            <tr>
                  <td class="text"><div align="right">Would you be able to provide housing?: </div></td>
                  <td colspan="2" class="text"><input type="radio" name="housing" id="yes" value="yes" />
                  <label for="yes"></label>YES&nbsp;&nbsp;<input type="radio" name="housing" id="no" value="no" />
                <label for="no"></label>NO</td>
                </tr>
                <tr>
                  <td height="19" class="text"><div align="right">Would you be able to assist with pick-up?: </div></td>
                  <td colspan="2" class="text"><input type="radio" name="pickup" id="yes" value="yes" />
                  <label for="yes"></label>YES&nbsp;&nbsp;<input type="radio" name="pickup" id="no" value="no" />
                  <label for="no"></label>NO</td>
                </tr>
                <tr>
                  <td class="text"><div align="right">Comments:&nbsp;</div></td>
                  <td colspan="2" class="text"><textarea name="comment" cols="30" rows="5"></textarea></td>
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