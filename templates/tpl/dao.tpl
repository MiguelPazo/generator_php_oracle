<?php
#Autor: Fernando Zapata
#Fecha: #{$_date}#
#Basado en FAZframe : Publicador v1.0

class #{$_modelName}# extends core{
	
#{foreach key=key item=item from=$_fields}#
	private $_#{$item['field']}#;
#{/foreach}# 
	private $extra;
	
	#constructor
	public function __construct( $db, $#{foreach key=key item=item from=$_fields}#$#{$item['field']}#='',#{/foreach}#$extra='') {
#{foreach key=key item=item from=$_fields}#
		$this->set#{$item['field']|ucfirst}#($#{$item['field']}#);    
#{/foreach}# 
		$this->setDb($db);
		$this->setSmarty($smarty);
		$this->setExtra($extra);
	}
	
	#save
	public function save(){
		if($this->get#{$_fields[0][0]|ucfirst}#()==''){
			$rs = $this->getDb()->Execute("insert into #{$_table}# (
#{foreach key=key item=item from=$_fields}#
    #{assign var="tmp" value = $key+1 }#
    #{if $item.4 neq 'PRI'}##{$item['field']}##{if $_fields[$tmp] neq ''}#,
    #{/if}#
    #{/if}#
#{/foreach}# 
			)values(
#{foreach key=key item=item from=$_fields}#
	#{assign var="tmp" value = $key+1 }#
	#{if $item.4 neq 'PRI'}#'".$this->get#{$item['field']|ucfirst}#()."'#{if $_fields[$tmp] neq ''}#,
    #{/if}#
    #{/if}#
#{/foreach}#
)");
			return $this->getDb()->Insert_ID();	
		}else{
			$rs = $this->getDb()->Execute("update #{$_table}# set 
#{foreach key=key item=item from=$_fields}#
    #{assign var="tmp" value = $key+1 }#
    #{if $item.4 neq 'PRI'}##{$item['field']}#='".$this->get#{$item['field']|ucfirst}#()."'#{if $_fields[$tmp] neq ''}#,
    #{/if}#
    #{/if}#
#{/foreach}# 
			where #{$_fields[0][0]}# = '".$this->get#{$_fields[0][0]|ucfirst}#()."'");
			return $this->get#{$_fields[0][0]|ucfirst}#();
		}
	}
	
	#elimina
	public function delete(){
		$rs = $this->getDb()->Execute("delete from #{$_table}# where #{$_fields[0][0]}# = '".$this->get#{$_fields[0][0]|ucfirst}#()."' ");
		unset($this);
	}
	
	
	#obtine un #{$_table}# por su Id
	public function load#{$_table|ucfirst}#ById($#{$_fields[0][0]}#){
		$rs = $this->getDb()->Execute("select * from #{$_table}# where #{$_fields[0][0]}# = '".$#{$_fields[0][0]}#."' ");
		if(!$rs->EOF){
#{foreach key=key item=item from=$_fields}#
            $this->set#{$item['field']|ucfirst}#($rs->fields["#{$item['field']}#"]);   
#{/foreach}#         
		}	
	}
	
	#obtine listado de los #{$_table}#
	public function listar($page){
		#aplica filtros
			$_filtros_="";
			$_array_extra = $this->getExtra();
#{foreach key=key item=item from=$_fields}#
			$_filtros_.= ($this->get#{$item['field']|ucfirst}#()!="")?" and #{$item['field']}# = '".$this->get#{$item['field']|ucfirst}#()."' ":" ";
#{/foreach}#         
		#ejecuta el count
		$sql = "select * from #{$_table}# where 1=1 ".$_filtros_." ";
		
		$rs = $this->getDb()->Execute("select count(*) as total from (".$sql.") as t1 ");
		if(!$rs->EOF){
			$_return[1] = $rs->fields["total"];
		}else{
			$_return[1] = 0;
		}
		#validamos la pagina
		if($page<=0)$page = 1;
		if($page>(ceil($_return[1]/_sysb_records)))$page = 1;										
		#traemos los campos de la pagina solicitada	
		if($_return[1]>0){
				$rs = $this->getDb()->SelectLimit($sql,_sysb_records,($page-1)*_sysb_records);
			while(!$rs->EOF){
				$_result[] = $rs->fields; 
				$rs->MoveNext();
			}
			$_return[0] = $_result;
		}else{
			$_return[0] = '';
		}
		return $_return;
		#fin listado
	}

	#set
#{foreach key=key item=item from=$_fields}#
	public function set#{$item['field']|ucfirst}#($#{$item['field']}#){$this->_#{$item['field']}#=$#{$item['field']}#;}
#{/foreach}#
	public function setExtra($extra){$this->extra=$extra;}
	
	#get
#{foreach key=key item=item from=$_fields}#
	public function get#{$item['field']|ucfirst}#(){return $this->_#{$item['field']}#;}
#{/foreach}#
	public function getExtra(){return $this->extra;}
}