<input type="hidden" name="cmd" value="{$cmd}">
<input type="hidden" name="criteria" value="{$criteria}">
<label><input name="crit_status" type="radio" value="0" checked>Any Status</label><br>
<label><input name="crit_status" type="radio" value="1">Any Active Status</label><br>
<label><input name="crit_status" type="radio" value="2">Open</label><br>
<label><input name="crit_status" type="radio" value="3">Closed</label><br>
<label><input name="crit_status" type="radio" value="4">Deleted</label><br>
<div align="right"><input type="button" value="Add &gt;&gt;" onclick="doSearchCriteriaSet('{$label}');"></div>