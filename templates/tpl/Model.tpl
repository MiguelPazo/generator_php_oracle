<?php

require_once 'base/#{$_modelFileBaseName}#.php';

class #{$_modelName}# extends Zend_Db_Table_Abstract
{
    
    protected $_name = '#{$_table}#';
    /**
     *
     * @var App_Utilities
     */
    private $_utilities;
    
    //<editor-fold defaultstate="collapsed" desc="Funciones base, NO MODIFICAR!" >    
    public function __construct () {
        parent::__construct ( array (
            'db' => $GLOBALS[ 'db' ]
        ) );
        
        $this->_utilities = $GLOBALS['utilities'];
    }
    
    private function convertToMyObject ( $objectQuery ) {
        $object = new #{$_modelNameExtends}#();
    
#{foreach key=key item=item from=$_fields}#
#{if $item['typeAttribute'] eq 'DateTime'}#
        $object->set#{$item['attribute']|ucfirst}#( $this->_utilities->stringToDateTime( $objectQuery[ '#{$item['field']}#' ] ) );
#{else if $item['typeAttribute'] eq 'Numeric'}#
        $object->set#{$item['attribute']|ucfirst}#( (int) $objectQuery[ '#{$item['field']}#' ] );
#{else}#
        $object->set#{$item['attribute']|ucfirst}#( $objectQuery[ '#{$item['field']}#' ] );
#{/if}#
#{/foreach}#

        return $object;
    }
    
    public function fetchAllObjects ( $where = null, $order = null, $count = null, $offset = null ) {
        try {
            $resultObj = null;
        
#{if $_contentDate}#
            $select = $this->select ()
                ->from ( $this->_name )
#{$_queryDate}#;

            if ( $where ) {
                $select->where ( $where );
            }

            $result = parent::fetchAll ( $select, $order, $count, $offset );
#{else}#
            $result = parent::fetchAll ( $where, $order, $count, $offset );
#{/if}#

            if ( $result ) {
                $resultObj = array ();

                foreach ( $result as $key => $value ) {
                    $resultObj[] = $this->convertToMyObject ( $value );
                }
            }

            return $resultObj;            
        } catch ( Exception $ex ) {
            throw $ex;
        }
    }
    
    public function fetchRowObject ( $where = null, $order = null, $offset = null ) {
        try {
            $resultObj = null;
        
#{if $_contentDate}#
            $select = $this->select ()
                ->from ( $this->_name, array( #{$_noDateFields}# ) )
#{$_queryDate}#;

            if ( $where ) {
                $select->where ( $where );
            }
        
            $result = parent::fetchRow ( $select, $order, $offset );
#{else}#
            $result = parent::fetchRow ( $where, $order, $offset );
#{/if}#
        
            if ( $result ) {
                $resultObj = $this->convertToMyObject($result);
            }

            return $resultObj;
        } catch ( Exception $ex ) {
            throw $ex;
        }
    }
    //</editor-fold>
    
}