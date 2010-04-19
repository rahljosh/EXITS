/*
 * Ext JS Library 1.1.1
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://www.extjs.com/license
 */

Ext.Toolbar=function(A,C,B){if(A instanceof Array){C=A;B=C;A=null}Ext.apply(this,B);this.buttons=C;if(A){this.render(A)}};Ext.Toolbar.prototype={render:function(B){this.el=Ext.get(B);if(this.cls){this.el.addClass(this.cls)}this.el.update("<div class=\"x-toolbar x-small-editor\"><table cellspacing=\"0\"><tr></tr></table></div>");this.tr=this.el.child("tr",true);var A=0;this.items=new Ext.util.MixedCollection(false,function(C){return C.id||("item"+(++A))});if(this.buttons){this.add.apply(this,this.buttons);delete this.buttons}},add:function(){var B=arguments,A=B.length;for(var C=0;C<A;C++){var D=B[C];if(D.applyTo){this.addField(D)}else{if(D.render){this.addItem(D)}else{if(typeof D=="string"){if(D=="separator"||D=="-"){this.addSeparator()}else{if(D==" "){this.addSpacer()}else{if(D=="->"){this.addFill()}else{this.addText(D)}}}}else{if(D.tagName){this.addElement(D)}else{if(typeof D=="object"){this.addButton(D)}}}}}}},getEl:function(){return this.el},addSeparator:function(){return this.addItem(new Ext.Toolbar.Separator())},addSpacer:function(){return this.addItem(new Ext.Toolbar.Spacer())},addFill:function(){return this.addItem(new Ext.Toolbar.Fill())},addElement:function(A){return this.addItem(new Ext.Toolbar.Item(A))},addItem:function(A){var B=this.nextBlock();A.render(B);this.items.add(A);return A},addButton:function(C){if(C instanceof Array){var E=[];for(var D=0,B=C.length;D<B;D++){E.push(this.addButton(C[D]))}return E}var A=C;if(!(C instanceof Ext.Toolbar.Button)){A=C.split?new Ext.Toolbar.SplitButton(C):new Ext.Toolbar.Button(C)}var F=this.nextBlock();A.render(F);this.items.add(A);return A},addText:function(A){return this.addItem(new Ext.Toolbar.TextItem(A))},insertButton:function(B,E){if(E instanceof Array){var D=[];for(var C=0,A=E.length;C<A;C++){D.push(this.insertButton(B+C,E[C]))}return D}if(!(E instanceof Ext.Toolbar.Button)){E=new Ext.Toolbar.Button(E)}var F=document.createElement("td");this.tr.insertBefore(F,this.tr.childNodes[B]);E.render(F);this.items.insert(B,E);return E},addDom:function(B,A){var D=this.nextBlock();Ext.DomHelper.overwrite(D,B);var C=new Ext.Toolbar.Item(D.firstChild);C.render(D);this.items.add(C);return C},addField:function(B){var C=this.nextBlock();B.render(C);var A=new Ext.Toolbar.Item(C.firstChild);A.render(C);this.items.add(A);return A},nextBlock:function(){var A=document.createElement("td");this.tr.appendChild(A);return A},destroy:function(){if(this.items){Ext.destroy.apply(Ext,this.items.items)}Ext.Element.uncache(this.el,this.tr)}};Ext.Toolbar.Item=function(A){this.el=Ext.getDom(A);this.id=Ext.id(this.el);this.hidden=false};Ext.Toolbar.Item.prototype={getEl:function(){return this.el},render:function(A){this.td=A;A.appendChild(this.el)},destroy:function(){this.td.parentNode.removeChild(this.td)},show:function(){this.hidden=false;this.td.style.display=""},hide:function(){this.hidden=true;this.td.style.display="none"},setVisible:function(A){if(A){this.show()}else{this.hide()}},focus:function(){Ext.fly(this.el).focus()},disable:function(){Ext.fly(this.td).addClass("x-item-disabled");this.disabled=true;this.el.disabled=true},enable:function(){Ext.fly(this.td).removeClass("x-item-disabled");this.disabled=false;this.el.disabled=false}};Ext.Toolbar.Separator=function(){var A=document.createElement("span");A.className="ytb-sep";Ext.Toolbar.Separator.superclass.constructor.call(this,A)};Ext.extend(Ext.Toolbar.Separator,Ext.Toolbar.Item,{enable:Ext.emptyFn,disable:Ext.emptyFn,focus:Ext.emptyFn});Ext.Toolbar.Spacer=function(){var A=document.createElement("div");A.className="ytb-spacer";Ext.Toolbar.Spacer.superclass.constructor.call(this,A)};Ext.extend(Ext.Toolbar.Spacer,Ext.Toolbar.Item,{enable:Ext.emptyFn,disable:Ext.emptyFn,focus:Ext.emptyFn});Ext.Toolbar.Fill=Ext.extend(Ext.Toolbar.Spacer,{render:function(A){A.style.width="100%";Ext.Toolbar.Fill.superclass.render.call(this,A)}});Ext.Toolbar.TextItem=function(B){var A=document.createElement("span");A.className="ytb-text";A.innerHTML=B;Ext.Toolbar.TextItem.superclass.constructor.call(this,A)};Ext.extend(Ext.Toolbar.TextItem,Ext.Toolbar.Item,{enable:Ext.emptyFn,disable:Ext.emptyFn,focus:Ext.emptyFn});Ext.Toolbar.Button=function(A){Ext.Toolbar.Button.superclass.constructor.call(this,null,A)};Ext.extend(Ext.Toolbar.Button,Ext.Button,{render:function(A){this.td=A;Ext.Toolbar.Button.superclass.render.call(this,A)},destroy:function(){Ext.Toolbar.Button.superclass.destroy.call(this);this.td.parentNode.removeChild(this.td)},show:function(){this.hidden=false;this.td.style.display=""},hide:function(){this.hidden=true;this.td.style.display="none"},disable:function(){Ext.fly(this.td).addClass("x-item-disabled");this.disabled=true},enable:function(){Ext.fly(this.td).removeClass("x-item-disabled");this.disabled=false}});Ext.ToolbarButton=Ext.Toolbar.Button;Ext.Toolbar.SplitButton=function(A){Ext.Toolbar.SplitButton.superclass.constructor.call(this,null,A)};Ext.extend(Ext.Toolbar.SplitButton,Ext.SplitButton,{render:function(A){this.td=A;Ext.Toolbar.SplitButton.superclass.render.call(this,A)},destroy:function(){Ext.Toolbar.SplitButton.superclass.destroy.call(this);this.td.parentNode.removeChild(this.td)},show:function(){this.hidden=false;this.td.style.display=""},hide:function(){this.hidden=true;this.td.style.display="none"}});Ext.Toolbar.MenuButton=Ext.Toolbar.SplitButton;
Ext.PagingToolbar=function(B,C,A){Ext.PagingToolbar.superclass.constructor.call(this,B,null,A);this.ds=C;this.cursor=0;this.renderButtons(this.el);this.bind(C)};Ext.extend(Ext.PagingToolbar,Ext.Toolbar,{pageSize:20,displayMsg:"Displaying {0} - {1} of {2}",emptyMsg:"No data to display",beforePageText:"Page",afterPageText:"of {0}",firstText:"First Page",prevText:"Previous Page",nextText:"Next Page",lastText:"Last Page",refreshText:"Refresh",renderButtons:function(A){Ext.PagingToolbar.superclass.render.call(this,A);this.first=this.addButton({tooltip:this.firstText,cls:"x-btn-icon x-grid-page-first",disabled:true,handler:this.onClick.createDelegate(this,["first"])});this.prev=this.addButton({tooltip:this.prevText,cls:"x-btn-icon x-grid-page-prev",disabled:true,handler:this.onClick.createDelegate(this,["prev"])});this.addSeparator();this.add(this.beforePageText);this.field=Ext.get(this.addDom({tag:"input",type:"text",size:"3",value:"1",cls:"x-grid-page-number"}).el);this.field.on("keydown",this.onPagingKeydown,this);this.field.on("focus",function(){this.dom.select()});this.afterTextEl=this.addText(String.format(this.afterPageText,1));this.field.setHeight(18);this.addSeparator();this.next=this.addButton({tooltip:this.nextText,cls:"x-btn-icon x-grid-page-next",disabled:true,handler:this.onClick.createDelegate(this,["next"])});this.last=this.addButton({tooltip:this.lastText,cls:"x-btn-icon x-grid-page-last",disabled:true,handler:this.onClick.createDelegate(this,["last"])});this.addSeparator();this.loading=this.addButton({tooltip:this.refreshText,cls:"x-btn-icon x-grid-loading",handler:this.onClick.createDelegate(this,["refresh"])});if(this.displayInfo){this.displayEl=Ext.fly(this.el.dom.firstChild).createChild({cls:"x-paging-info"})}},updateInfo:function(){if(this.displayEl){var A=this.ds.getCount();var B=A==0?this.emptyMsg:String.format(this.displayMsg,this.cursor+1,this.cursor+A,this.ds.getTotalCount());this.displayEl.update(B)}},onLoad:function(C,B,F){this.cursor=F.params?F.params.start:0;var E=this.getPageData(),A=E.activePage,D=E.pages;this.afterTextEl.el.innerHTML=String.format(this.afterPageText,E.pages);this.field.dom.value=A;this.first.setDisabled(A==1);this.prev.setDisabled(A==1);this.next.setDisabled(A==D);this.last.setDisabled(A==D);this.loading.enable();this.updateInfo()},getPageData:function(){var A=this.ds.getTotalCount();return{total:A,activePage:Math.ceil((this.cursor+this.pageSize)/this.pageSize),pages:A<this.pageSize?1:Math.ceil(A/this.pageSize)}},onLoadError:function(){this.loading.enable()},onPagingKeydown:function(E){var C=E.getKey();var F=this.getPageData();if(C==E.RETURN){var B=this.field.dom.value,D;if(!B||isNaN(D=parseInt(B,10))){this.field.dom.value=F.activePage;return }D=Math.min(Math.max(1,D),F.pages)-1;this.ds.load({params:{start:D*this.pageSize,limit:this.pageSize}});E.stopEvent()}else{if(C==E.HOME||(C==E.UP&&E.ctrlKey)||(C==E.PAGEUP&&E.ctrlKey)||(C==E.RIGHT&&E.ctrlKey)||C==E.END||(C==E.DOWN&&E.ctrlKey)||(C==E.LEFT&&E.ctrlKey)||(C==E.PAGEDOWN&&E.ctrlKey)){var D=(C==E.HOME||(C==E.DOWN&&E.ctrlKey)||(C==E.LEFT&&E.ctrlKey)||(C==E.PAGEDOWN&&E.ctrlKey))?1:F.pages;this.field.dom.value=D;this.ds.load({params:{start:(D-1)*this.pageSize,limit:this.pageSize}});E.stopEvent()}else{if(C==E.UP||C==E.RIGHT||C==E.PAGEUP||C==E.DOWN||C==E.LEFT||C==E.PAGEDOWN){var B=this.field.dom.value,D;var A=(E.shiftKey)?10:1;if(C==E.DOWN||C==E.LEFT||C==E.PAGEDOWN){A*=-1}if(!B||isNaN(D=parseInt(B,10))){this.field.dom.value=F.activePage;return }else{if(parseInt(B,10)+A>=1&parseInt(B,10)+A<=F.pages){this.field.dom.value=parseInt(B,10)+A;D=Math.min(Math.max(1,D+A),F.pages)-1;this.ds.load({params:{start:D*this.pageSize,limit:this.pageSize}})}}E.stopEvent()}}}},beforeLoad:function(){if(this.loading){this.loading.disable()}},onClick:function(E){var D=this.ds;switch(E){case"first":D.load({params:{start:0,limit:this.pageSize}});break;case"prev":D.load({params:{start:Math.max(0,this.cursor-this.pageSize),limit:this.pageSize}});break;case"next":D.load({params:{start:this.cursor+this.pageSize,limit:this.pageSize}});break;case"last":var C=D.getTotalCount();var A=C%this.pageSize;var B=A?(C-A):C-this.pageSize;D.load({params:{start:B,limit:this.pageSize}});break;case"refresh":D.load({params:{start:this.cursor,limit:this.pageSize}});break}},unbind:function(A){A.un("beforeload",this.beforeLoad,this);A.un("load",this.onLoad,this);A.un("loadexception",this.onLoadError,this);this.ds=undefined},bind:function(A){A.on("beforeload",this.beforeLoad,this);A.on("load",this.onLoad,this);A.on("loadexception",this.onLoadError,this);this.ds=A}});
