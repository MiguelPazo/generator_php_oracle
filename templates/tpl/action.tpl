<?php
#Autor: Fernando Zapata
#Fecha: 24/05/2008
#Basado en FAZframe : Publicador v1.0

include("../dao/#{$_TABLA}#.class.php");

class action#{$_TABLA|ucfirst}# extends core{
#Funciones agregadas
		
#Funciones basicas	
	#nuevo
	public function nuevo#{$_TABLA|ucfirst}#($_POST){
		#mostramos el formulario
		if($_POST["mode"]=="show"){
		#logica
		
		#fin logica
			$this->getSmarty()->display("#{$_TABLA}#_nuevo.tpl");
		#grabamos la data	
		}else{		
			$obj_#{$_TABLA}# = new #{$_TABLA}#($this->getDb(),$this->getSmarty());
#{foreach key=key item=item from=$_ITEMS}# 
			#{if $item.4 neq 'PRI'}#$obj_#{$_TABLA}#->set#{$item[0]|ucfirst}#($_POST["#{$item[0]}#"]);#{/if}#
#{/foreach}#            
			$id = $obj_#{$_TABLA}#->save();
			unset($_POST);
			#opciones de mensaje
			if($id!=''){
				$this->getSmarty()->assign("__MENSAJE",_EXITO_);
				$this->getSmarty()->assign("__ID",$id);
				$this->getSmarty()->assign("__NUEVO","getPage('','action#{$_TABLA|ucfirst}#','nuevo#{$_TABLA|ucfirst}#','popup','&mode=show');");
				$this->getSmarty()->assign("__EDITAR","getPage('','action#{$_TABLA|ucfirst}#','editar#{$_TABLA|ucfirst}#','popup','&mode=show&sel_row=".$id."');");
				$this->getSmarty()->assign("__ELIMINAR","getPage('','action#{$_TABLA|ucfirst}#','eliminar#{$_TABLA|ucfirst}#','popup','&sel_row=".$id."');");				
			}else{
				$this->getSmarty()->assign("__MENSAJE",_ERROR_);
			}			
			$this->getSmarty()->display("mensaje_popup.tpl");
			#liberamos el objeto		
			unset($obj_#{$_TABLA}#);	
		}	
	}
	
	#editar
	public function editar#{$_TABLA|ucfirst}#($_POST){
		#mostramos el formulario
		if($_POST["mode"]=="show"){
			$obj_#{$_TABLA}# = new #{$_TABLA}#($this->getDb(),$this->getSmarty());
			$obj_#{$_TABLA}#->load#{$_TABLA|ucfirst}#ById($_POST["sel_row"]);
			#logica
			
			#fin logica			
#{foreach key=key item=item from=$_ITEMS}#
			$this->getSmarty()->assign("#{$item[0]}#",$obj_#{$_TABLA}#->get#{$item[0]|ucfirst}#());
#{/foreach}# 
			$this->getSmarty()->display("#{$_TABLA}#_editar.tpl");
			#grabamos la data
		}else{
			$obj_#{$_TABLA}# = new #{$_TABLA}#($this->getDb(),$this->getSmarty());
			$obj_#{$_TABLA}#->load#{$_TABLA|ucfirst}#ById($_POST["#{$_ITEMS[0][0]}#"]);
#{foreach key=key item=item from=$_ITEMS}# 
			#{if $item.4 neq 'PRI'}#$obj_#{$_TABLA}#->set#{$item[0]|ucfirst}#($_POST["#{$item[0]}#"]);#{/if}#
#{/foreach}# 
			$id = $obj_#{$_TABLA}#->save();
			unset($_POST);
			#opciones de mensaje
			if($id!=''){
				$this->getSmarty()->assign("__MENSAJE",_EXITO_);
				$this->getSmarty()->assign("__ID",$id);
				$this->getSmarty()->assign("__NUEVO","getPage('','action#{$_TABLA|ucfirst}#','nuevo#{$_TABLA|ucfirst}#','popup','&mode=show');");
				$this->getSmarty()->assign("__EDITAR","getPage('','action#{$_TABLA|ucfirst}#','editar#{$_TABLA|ucfirst}#','popup','&mode=show&sel_row=".$id."');");
				$this->getSmarty()->assign("__ELIMINAR","getPage('','action#{$_TABLA|ucfirst}#','eliminar#{$_TABLA|ucfirst}#','popup','&sel_row=".$id."');");				
			}else{
				$this->getSmarty()->assign("__MENSAJE",_ERROR_);
			}			
			$this->getSmarty()->display("mensaje_popup.tpl");
			#liberamos el objeto
			unset($obj_#{$_TABLA}#);	
		}	
	}
	
	#eliminar
	public function eliminar#{$_TABLA|ucfirst}#($_POST){
		$obj_#{$_TABLA}# = new #{$_TABLA}#($this->getDb(),$this->getSmarty());
		$obj_#{$_TABLA}#->load#{$_TABLA|ucfirst}#ById($_POST["sel_row"]);
		$obj_#{$_TABLA}#->delete();
		$this->getSmarty()->assign("__MENSAJE",_EXITO_);
		$this->getSmarty()->display("mensaje_popup.tpl");
	}		

	#eliminar Multiple
	public function eliminar#{$_TABLA|ucfirst}#M($_POST){
		$obj_#{$_TABLA}# = new #{$_TABLA}#($this->getDb(),$this->getSmarty());
		if(is_array($_POST["sel_rowm"])){
			foreach($_POST["sel_rowm"] as $item){
				$obj_#{$_TABLA}#->load#{$_TABLA|ucfirst}#ById($item);
				$obj_#{$_TABLA}#->delete();
			}
		}
		$this->listar#{$_TABLA|ucfirst}#($_POST);
		unset($obj_#{$_TABLA}#);
		unset($_POST);
	}
	
	#listar
	public function listar#{$_TABLA|ucfirst}#($_POST){
		$obj_#{$_TABLA}# = new #{$_TABLA}#($this->getDb(),$this->getSmarty());
#{foreach key=key item=item from=$_ITEMS}#
		$obj_#{$_TABLA}#->set#{$item[0]|ucfirst}#($_POST["#{$item[0]}#"]);
#{/foreach}#
		$obj_#{$_TABLA}#->setExtra($_POST);   
		$_POST["page"] = ($_POST["page"]=='')?1:$_POST["page"];
		#cargamos los campos necesarios al listado
		$_array_#{$_TABLA}#s = $obj_#{$_TABLA}#->listar($_POST["page"]);
		$_registros = $_array_#{$_TABLA}#s[1];

		$this->getSmarty()->assign('_PAGNUM_',$_POST["page"]."/".ceil($_registros/_sysb_records));
		$this->getSmarty()->assign('_REGNUM_',$_registros);
		#usamos los assign
#{foreach key=key item=item from=$_ITEMS}#
		$this->getSmarty()->assign("#{$item[0]}#",$_POST["#{$item[0]}#"]);
#{/foreach}#
		$this->getSmarty()->assign('_RESULT_',$_array_#{$_TABLA}#s[0]);
		#paginamos
		$this->getSmarty()->assign('_PAGINAS_',$this->getPaginas(get_class($this),'listar#{$_TABLA|ucfirst}#','contenido',$_POST,$_registros)); 
		$this->getSmarty()->display('#{$_TABLA}#_listar.tpl');
	}
}
?>