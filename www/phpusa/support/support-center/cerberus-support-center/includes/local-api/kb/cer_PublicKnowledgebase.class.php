<?php

require_once (FILESYSTEM_PATH . "cerberus-api/utility/sort/cer_PointerSort.class.php");

class cer_PublicKnowledgebaseCategory {
	var $category_id = 0;
	var $category_name = null;
	var $parent_id = null;
	var $total_articles = 0;
	var $sorted_children = array();
	var $children = array();
	
	function cer_PublicKnowledgebaseCategory($id,$parent_id=-1,$name="") {
		$this->category_id = $id;
		$this->parent_id = $parent_id;
		$this->category_name = $name;
	}
	
	function addChild(&$child_ptr) {
		$this->children[] = &$child_ptr;
	}
};

class cer_PublicKnowledgebaseTree {
	var $db = null;
	var $categories = array();
	var $topic_totals = array();
		
	function cer_PublicKnowledgebaseTree($sc_root_id = 0) {
		$this->db = Cer_Database::getInstance();
		$this->categories[0] = new cer_PublicKnowledgebaseCategory(0,-1,"Top");
		$cat_include_list = $this->recurse_tree_get_children($sc_root_id);
		
		$sql = "SELECT kbc.kb_category_id, kbc.kb_category_name, kbc.kb_category_parent_id, count(k.kb_id) as num_articles ".
			"FROM knowledgebase_categories kbc ".
			"LEFT JOIN knowledgebase k ON (k.kb_category_id = kbc.kb_category_id AND k.kb_public = 1) ".
			"WHERE kbc.kb_category_id IN ( %s ) ".
			"GROUP BY kbc.kb_category_id ".
			"ORDER BY kbc.kb_category_id ASC";
		$res = $this->db->query(sprintf($sql, implode(',', $cat_include_list)));
		
		if($this->db->num_rows($res)) {
			while($row = $this->db->fetch_row($res)) {
				$parent_id = $row["kb_category_parent_id"];
				$cat_id = $row["kb_category_id"];
				$cat_name = stripslashes($row["kb_category_name"]);
				if($cat_id == $sc_root_id) {
					$parent_id = 0;
				}
				$num_articles = $row["num_articles"];
				
				if(!isset($this->categories[$cat_id])) {
					$this->categories[$cat_id] = new cer_PublicKnowledgebaseCategory($cat_id,$parent_id,$cat_name);
				}
				else {
					$this->categories[$cat_id]->category_name = $cat_name;
					$this->categories[$cat_id]->parent_id = $parent_id;
				}
				
				$this->topic_totals[$cat_id] = $num_articles;
				
				if(!isset($this->categories[$parent_id])) {
					$this->categories[$parent_id] = new cer_PublicKnowledgebaseCategory($parent_id);
				}
				
				$this->categories[$parent_id]->addChild($this->categories[$cat_id]);
			}
		}
		
		$this->_fillArticleCounts();
		$this->_clearEmptyCategories();
		$this->_sortChildren();
	}
	
	// [JAS]: After all children are loaded up we should sort them
	function _sortChildren() {
		foreach($this->categories as $idx => $c) {
			$this->categories[$idx]->sorted_children = 
				cer_PointerSort::pointerSortCollection($this->categories[$idx]->children,"category_name");
		}
	}
	
	function _fillArticleCounts() {
		$this->recurse_category(0);
		
		foreach($this->topic_totals as $i => $tot) {
			$this->categories[$i]->total_articles = $tot;
		}
	}
	
	function _clearEmptyCategories() {
		if(!empty($this->categories))
		foreach($this->categories as $i => $c) {
			
			if(!empty($c->children))
			foreach($c->children as $ii => $cc) {
				if(empty($this->categories[$i]->children[$ii]->total_articles)) {
					$this->categories[$i]->children[$ii] = null;
					unset($this->categories[$i]->children[$ii]);
				}
			}
		}
	}
	
	//! Add up the topics under a category and then recurse through its children
	/*!
	This function is used by calculate_topic_totals()
	
	\param $cat_id the category id to calculate totals for and then recurse
	\note This function is called by calculate_topic_totals() and should not be called directly.
	\return The total topics under \a $cat_id as an \c integer.
	*/
	function recurse_category($cat_id)
	{
		$add_these = 0;
		$total = (isset($this->topic_totals[$cat_id])) ? $this->topic_totals[$cat_id] : 0;
		
		if(isset($this->categories[$cat_id]->children)) {
			foreach($this->categories[$cat_id]->children as $child) {
				$add_these += $this->recurse_category($child->category_id);
			}
		}
		
		if(isset($this->topic_totals[$cat_id]))
			 $this->topic_totals[$cat_id] += $add_these;
		
		return $total + $add_these;
	}

	// This function is used to get an array of all the children of the given category root (includes itself).
	// This is useful to do a search of all categories and limit it to articles which are in the given root or it's children.
	function recurse_tree_get_children($root)
	{
		if(isset($this->category_id_list) && is_array($this->category_id_list) && count($this->category_id_list) > 0) {
			return $this->category_id_list;
		}
		else {
			$this->category_id_list = array($root);
			$check_list = array($root);
			$loop_count = 0;
			$sql = "SELECT kb_category_id FROM knowledgebase_categories WHERE kb_category_parent_id = '%d'";
			while(NULL !== $cat_id = array_shift($check_list)) {
				$res = $this->db->query(sprintf($sql, $cat_id));
				if($this->db->num_rows($res)) {
					while($row = $this->db->fetch_row($res)) {
						$this->category_id_list[] = $row["kb_category_id"];
						$check_list[] = $row["kb_category_id"];
					}
				}
				$loop_count++;
			}
			$this->category_id_list = array_unique($this->category_id_list);
			return $this->category_id_list;
		}
	}
	

	// [JAS]: \todo When this moves to the API we should change it to return an assoc array of (cat id => cat name)
	// 		rather than HTML links.  Let the caller format the HTML in Smarty or directly.
	function printTrail($root) {
		$stack = array();
		$at = $root;
		
		if(!isset($this->categories[$at])) {
			return '';
		}		
		while($at != -1) {
			$stack[] = sprintf("<a href='%s' class='%s'>%s</a>",
					BASE_URL . "&mod_id=" . $_REQUEST["mod_id"] . "&root=" . @$this->categories[$at]->category_id,
					"kb_category",
					@$this->categories[$at]->category_name
				);
			$at = @$this->categories[$at]->parent_id;
		} 
		
		$stack = array_reverse($stack);
		
		return implode(" : ", $stack);
	}
	
};

?>
