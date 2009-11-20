<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:13
         compiled from display/tabs/display_custom_fields.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'short_escape', 'display/tabs/display_custom_fields.tpl.php', 24, false),
array('modifier', 'cer_dateformat', 'display/tabs/display_custom_fields.tpl.php', 34, false),
array('function', 'html_options', 'display/tabs/display_custom_fields.tpl.php', 48, false),)); ?>
	<?php if (isset($this->_foreach['group'])) unset($this->_foreach['group']);
$this->_foreach['group']['name'] = 'group';
$this->_foreach['group']['total'] = count((array)$this->_tpl_vars['field_handler']->group_instances);
$this->_foreach['group']['show'] = $this->_foreach['group']['total'] > 0;
if ($this->_foreach['group']['show']):
$this->_foreach['group']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['field_handler']->group_instances as $this->_tpl_vars['group']):
        $this->_foreach['group']['iteration']++;
        $this->_foreach['group']['first'] = ($this->_foreach['group']['iteration'] == 1);
        $this->_foreach['group']['last']  = ($this->_foreach['group']['iteration'] == $this->_foreach['group']['total']);
?>
        
	  	<tr>
          <td colspan="2">
          	<table cellspacing="0" cellpadding="0" border="0" width="100%">
          		<tr >
          			<td align="left"><b><?php echo $this->_tpl_vars['group']->group_name; ?>
 (bound to <?php echo $this->_tpl_vars['group']->entity_name; ?>
)</b></td>
          			<td align="right">
          				Delete:
          				<input type="checkbox" name="instance_ids[]" value="<?php echo $this->_tpl_vars['group']->group_instance_id; ?>
">
          			</td>
          		</tr>
          	</table>
          </td>
        </tr>
        
        <?php if (count ( $this->_tpl_vars['group']->fields )): ?>
          
            
            <?php if (isset($this->_foreach['field'])) unset($this->_foreach['field']);
$this->_foreach['field']['name'] = 'field';
$this->_foreach['field']['total'] = count((array)$this->_tpl_vars['group']->fields);
$this->_foreach['field']['show'] = $this->_foreach['field']['total'] > 0;
if ($this->_foreach['field']['show']):
$this->_foreach['field']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['group']->fields as $this->_tpl_vars['field']):
        $this->_foreach['field']['iteration']++;
        $this->_foreach['field']['first'] = ($this->_foreach['field']['iteration'] == 1);
        $this->_foreach['field']['last']  = ($this->_foreach['field']['iteration'] == $this->_foreach['field']['total']);
?>
                <input type="hidden" name="g_<?php echo $this->_tpl_vars['group']->group_instance_id; ?>
_field_ids[]" value="<?php echo $this->_tpl_vars['field']->field_id; ?>
">
                <tr> 
                  <td width="10%"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['field']->field_name); ?>
:</td>
                  
                  <td width="80%">
                  <?php if ($this->_tpl_vars['o_ticket']->writeable !== false): ?>
                  
                  	<?php if ($this->_tpl_vars['field']->field_type == 'S'): ?>
                    	<input type="text" name="g_<?php echo $this->_tpl_vars['group']->group_instance_id; ?>
_field_<?php echo $this->_tpl_vars['field']->field_id; ?>
" size="65" value="<?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['field']->field_value); ?>
" >
                    <?php endif; ?>

                  	<?php if ($this->_tpl_vars['field']->field_type == 'E'): ?>
						<input type="text" name="g_<?php echo $this->_tpl_vars['group']->group_instance_id; ?>
_field_<?php echo $this->_tpl_vars['field']->field_id; ?>
" size="20" value="<?php echo $this->_run_mod_handler('cer_dateformat', true, $this->_tpl_vars['field']->field_value); ?>
">
			          	<span class="cer_footer_text" >
							Dates can be entered relatively (e.g. "-1 day", "+1 week", "now")	or absolutely (e.g. "12/31/06 08:00:00")
			          	</span>
                    <?php endif; ?>

                  	<?php if ($this->_tpl_vars['field']->field_type == 'T'): ?>
                    	<textarea cols="65" rows="3" name="g_<?php echo $this->_tpl_vars['group']->group_instance_id; ?>
_field_<?php echo $this->_tpl_vars['field']->field_id; ?>
" wrap="virtual" ><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['field']->field_value); ?>
</textarea><br>
                    	<span >(maximum 255 characters)</span>
                    <?php endif; ?>
                    
                  	<?php if ($this->_tpl_vars['field']->field_type == 'D'): ?>
                    	<select name="g_<?php echo $this->_tpl_vars['group']->group_instance_id; ?>
_field_<?php echo $this->_tpl_vars['field']->field_id; ?>
" >
	                      <option value="">
	                      <?php echo $this->_plugins['function']['html_options'][0](array('options' => $this->_tpl_vars['field']->field_options,'selected' => $this->_tpl_vars['field']->field_value), $this) ; ?>

                        </select>
                    <?php endif; ?>
                    
                  <?php endif; ?>
                  </td>
                </tr>
            <?php endforeach; endif; ?>
            
            <input type="hidden" name="group_instances[]" value="<?php echo $this->_tpl_vars['group']->group_instance_id; ?>
">
            <input type="hidden" name="entity_codes[]" value="<?php echo $this->_tpl_vars['group']->entity_code; ?>
">
            <input type="hidden" name="entity_indexes[]" value="<?php echo $this->_tpl_vars['group']->entity_index; ?>
">
        <?php endif; ?>
          
	  <tr> 
	  	<td colspan="2"><img src="images/spacer.gif" width="1" height="4" alt=""></td>
	  </tr>
          
	  <tr> 
	  	<td colspan="2"><img src="images/spacer.gif" width="1" height="2" alt=""></td>
	  </tr>
          
  <?php endforeach; endif; ?>
