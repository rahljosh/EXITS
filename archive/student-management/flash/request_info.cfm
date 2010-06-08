<link href="style.css" rel="stylesheet" type="text/css">
<table width="770" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="images/contact.gif" width="770" height="43"></td>
  </tr>
  <tr>
    <td background="images/about_02.gif"><table width="78%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><cfif url.request is 'host'><form action="submit_request.cfm?request=host" method="post">
            <span class="style1">
            <cfelseif url.request is 'student'>
            </span>
          </form><form action="submit_request.cfm?request=student" method="post">
            <span class="style1">
            <cfelseif url.request is 'agent'>
            </span>
          </form>
          <span class="style1">
          <form action="submit_request.cfm?request=agent" method="post">
          </span>
          </cfif>
            <span class="style1">Fill out the following form to recieve more information on being a 
            <cfif url.request is "host">
              host family 
                <cfelseif url.request is "student">
                exchange student 
                <cfelseif url.request is "agent">
                Area Representative 
            </cfif>
            and <cfif url.request is "host">
              a representative
                <cfelseif url.request is "student">
                an agent
                <cfelseif url.request is "agent">
                a manager
            </cfif> from your 
            <cfif url.request is "Student">
              home country 
                <cfelse>
                region 
            </cfif>
            will contact you shortly.</span><br>
<table align="center">
  <tr class="style1">
    <td><font face="Tahoma, Arial"><span class ="style13">First Name</span></font> </td>
    <td><input type="Text" name="Fname" size="30" maxlength="30"></td>
  </tr>
  <tr class="style1">
    <td><font face="Tahoma, Arial"><span class ="style13">Last Name</span></font> </td>
    <td><input type="Text" name="Lname" size="30" maxlength="30"></td>
  </tr>
  <tr class="style1">
    <td><font face="Tahoma, Arial"><span class ="style13">Email Address</span></font> </td>
    <td><input type="Text" name="email" size="30" maxlength="30"></td>
  </tr>
  <tr class="style1">
    <td><font face="Tahoma, Arial"><span class ="style13">Street Address</span></font> </td>
    <td><input type="Text" name="address" size="30" maxlength="30"></td>
  </tr>
  <tr class="style1">
    <td><font face="Tahoma, Arial"><span class ="style13">City</span></font> </td>
    <td><input type="Text" name="city" size="30" maxlength="30"></td>
  </tr>
  <cfif url.request is "student">
    <tr class="style1">
      <td><font face="Tahoma, Arial"><span class ="style13">Country of residence</span></font> </td>
      <td><input type="Text" name="country" size="30" maxlength="30">
          <cfelse>
    <tr class="style1">
      <td><font face="Tahoma, Arial"><span class ="style13">State of residence</span></font> </td>
      <td><select name="state" size="1">
          <option value="">
          <option value="AL"> Alabama
                    <option value="AK"> Alaska
                    <option value="AZ"> Arizona
                    <option value="AR"> Arkansas
                    <option value="CA"> California
                    <option value="CO"> Colorado
                    <option value="CT"> Connecticut
                    <option value="DE"> Delaware
                    <option value="DC"> District of Columbia
                    <option value="FL"> Florida
                    <option value="GA"> Georgia
                    <option value="HI"> Hawaii
                    <option value="ID"> Idaho
                    <option value="IL"> Illinois
                    <option value="IN"> Indiana
                    <option value="IA"> Iowa
                    <option value="KS"> Kansas
                    <option value="KY"> Kentucky
                    <option value="LA"> Louisiana
                    <option value="ME"> Maine
                    <option value="MD"> Maryland
                    <option value="MA"> Massachusetts
                    <option value="MI"> Michigan
                    <option value="MN"> Minnesota
                    <option value="MS"> Mississippi
                    <option value="MO"> Missouri
                    <option value="MT"> Montana
                    <option value="NE"> Nebraska
                    <option value="NV"> Nevada
                    <option value="NH"> New Hampshire
                    <option value="NJ"> New Jersey
                    <option value="NM"> New Mexico
                    <option value="NY"> New York
                    <option value="NC"> North Carolina
                    <option value="ND"> North Dakota
                    <option value="OH"> Ohio
                    <option value="OK"> Oklahoma
                    <option value="OR"> Oregon
                    <option value="PA"> Pennsylvania
                    <option value="RI"> Rhode Island
                    <option value="SC"> South Carolina
                    <option value="SD"> South Dakota
                    <option value="TN"> Tennessee
                    <option value="TX"> Texas
                    <option value="UT"> Utah
                    <option value="VT"> Vermont
                    <option value="VA"> Virginia
                    <option value="WA"> Washington
                    <option value="WV"> West Virginia
                    <option value="WI"> Wisconsin
                    <option value="WY"> Wyoming
                  </select>
      </td>
    </tr>
  </cfif>
  <tr class="style1">
    <td><font face="Tahoma, Arial"><span class ="style13">Zip Code</span></font> </td>
    <td><input type="Text" name="zip" size="5" maxlength="5"></td>
  </tr>
  <tr class="style1">
    <td><font face="Tahoma, Arial"><span class ="style13">Daytime phone number</span></font> </td>
    <td><input type="Text" name="Dphone" size="20" maxlength="20"></td>
  </tr>
  <tr class="style1">
    <td><font face="Tahoma, Arial"><span class ="style13">Evening phone number</span></font> </td>
    <td><input type="Text" name="Nphone" size="20" maxlength="20"></td>
  </tr>
  <tr class="style1">
    <td><font face="Tahoma, Arial"><span class ="style13">Additional Comments</span></font> </td>
    <td><textarea name="comment" cols="30" rows="4" wrap="VIRTUAL"></textarea></td>
  </tr>
  <tr class="style1">
    <td colspan="2" align="center"><input type="Submit" name="" value="Submit"></td>
  </tr>
</table></td>
        </tr>
    </table></td>
  </tr>
  <tr>
    <td><img src="images/about_04.gif" width="770" height="79"></td>
  </tr>
</table>
