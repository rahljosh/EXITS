<?php /* Smarty version 2.5.0, created on 2007-01-15 21:55:27
         compiled from my_cerberus/my_cerberus_navbar.tpl.php */ ?>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td valign="top">&nbsp;</td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr> 
                <?php if ($this->_tpl_vars['urls']['tab_dashboard']): ?>
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_dashboard_bg_css; ?>
" align="center" nowrap>
                	<a href="<?php echo $this->_tpl_vars['urls']['tab_dashboard']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_dashboard_css; ?>
"><?php echo @constant('LANG_MYCERBERUS_HEADERS_DASHBOARD'); ?>
</a>
                </td>
                <td>&nbsp;</td>
                <?php endif; ?>

                <?php if ($this->_tpl_vars['urls']['tab_preferences']): ?>
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_prefs_bg_css; ?>
" align="center" nowrap>
                	<a href="<?php echo $this->_tpl_vars['urls']['tab_preferences']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_prefs_css; ?>
"><?php echo @constant('LANG_MYCERBERUS_HEADERS_PREFERENCES'); ?>
</a>
                </td>
                <td>&nbsp;</td>
                <?php endif; ?>
                
                <?php if ($this->_tpl_vars['urls']['tab_layout']): ?>
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_layout_bg_css; ?>
" align="center" nowrap>
                	<a href="<?php echo $this->_tpl_vars['urls']['tab_layout']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_layout_css; ?>
"><?php echo @constant('LANG_WORD_LAYOUT'); ?>
</a>
                </td>
                <td>&nbsp;</td>
                <?php endif; ?>

                <?php if ($this->_tpl_vars['urls']['tab_notification']): ?>
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_notify_bg_css; ?>
" align="center" nowrap>
                	<a href="<?php echo $this->_tpl_vars['urls']['tab_notification']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_notify_css; ?>
"><?php echo @constant('LANG_MYCERBERUS_HEADERS_NOTIFICATION'); ?>
</a>
                </td>
                <td>&nbsp;</td>
                <?php endif; ?>
                
                <?php if ($this->_tpl_vars['urls']['tab_assign']): ?>
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_assign_bg_css; ?>
" align="center" nowrap>
                	<a href="<?php echo $this->_tpl_vars['urls']['tab_assign']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_assign_css; ?>
">Watcher</a>
                </td>
                <td>&nbsp;</td>
                <?php endif; ?>

                <?php if ($this->_tpl_vars['urls']['tab_tasks']): ?>
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_tasks_bg_css; ?>
" align="center" nowrap>
                	<a href="<?php echo $this->_tpl_vars['urls']['tab_tasks']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_tasks_css; ?>
"><?php echo @constant('LANG_MYCERBERUS_HEADERS_PROJECTS'); ?>
</a>
                </td>
                <td>&nbsp;</td>
                <?php endif; ?>
                
                <?php if ($this->_tpl_vars['urls']['tab_messages']): ?>
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_msgs_bg_css; ?>
" align="center" nowrap>
                	<a href="<?php echo $this->_tpl_vars['urls']['tab_messages']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_msgs_css; ?>
"><?php echo @constant('LANG_MYCERBERUS_HEADERS_PMS'); ?>
</a>
                </td>
                <td>&nbsp;</td>
                <?php endif; ?>

              </tr>
            </table>
          </td>
        </tr>
        <tr bgcolor="#858585"> 
          <td valign="top"><img alt="" src="includes/images/spacer.gif" width="1" height="2"></td>
        </tr>
        <tr> 
          <td valign="top"><img alt="" src="includes/images/spacer.gif" width="1" height="5"></td>
        </tr>
      </table>