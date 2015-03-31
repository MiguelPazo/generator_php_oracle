<?php

class #{$_modelName}# extends Zend_Db_Table_Abstract
{
    
    protected $_name = '#{$_table}#';
    
    public function __construct () {
        parent::__construct ( array (
            'db' => $GLOBALS[ 'db' ]
        ) );
    }
    
}