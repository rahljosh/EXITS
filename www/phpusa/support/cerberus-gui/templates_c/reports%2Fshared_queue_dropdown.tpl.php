<?php /* Smarty version 2.5.0, created on 2007-05-30 06:36:34
         compiled from reports/shared_queue_dropdown.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'html_options', 'reports/shared_queue_dropdown.tpl.php', 7, false),)); ?><table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td valign="top">
			<span class="cer_maintable_heading">Filter by Queue:</span><br>
			<select name="report_queue_id" class="cer_footer_text">
			<option value='-1'>- any queue -
				<?php echo $this->_plugins['function']['html_options'][0](array('options' => $this->_tpl_vars['report']->report_data->queue_data->queue_list,'selected' => $this->_tpl_vars['report']->report_data->queue_data->report_queue_id), $this) ; ?>

			</select>
			</td>
	</tr>
</table>