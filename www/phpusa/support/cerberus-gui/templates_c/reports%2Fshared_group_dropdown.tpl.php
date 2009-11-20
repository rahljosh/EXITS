<?php /* Smarty version 2.5.0, created on 2007-05-30 06:36:20
         compiled from reports/shared_group_dropdown.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'html_options', 'reports/shared_group_dropdown.tpl.php', 7, false),)); ?><table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td valign="top">
			<span class="cer_maintable_heading">Filter by Team:</span><br>
			<select name="report_team_id" class="cer_footer_text">
			<option value='-1'>- any team -
				<?php echo $this->_plugins['function']['html_options'][0](array('options' => $this->_tpl_vars['report']->report_data->team_data->team_list,'selected' => $this->_tpl_vars['report']->report_data->team_data->report_team_id), $this) ; ?>

			</select>
			</td>
	</tr>
</table>