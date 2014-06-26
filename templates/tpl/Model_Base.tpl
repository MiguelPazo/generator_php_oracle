<?php

/*
  Fields:
#{foreach key=key item=item from=$_fields}#
  #{$item['field']}# => #{$item['type']}#
#{/foreach}#
*/

class #{$_modelName}#
{

    private $_name = '#{$_table}#';
#{foreach key=key item=item from=$_fields}#
    protected $_#{$item['attribute']}#;
#{/foreach}#
    private $_data = array ( #{$_dataArray}# );
	
    public function __construct () {
    
    }

    /**
     *
     * @param  $pushInsert Default = FALSE, if is TRUE it force a insert
     */
    public function save ( $pushInsert = false ) {
        try {
            $db = $GLOBALS[ 'db' ];

            if ( $pushInsert ) {
                return $db->insert ( $this->_name, $this->_data );
            } else if ( $this->_data[ '#{$_primary}#' ] ) {
                return $db->update ( $this->_name, $this->_data, array( '#{$_primary}#=?' => $this->_data[ '#{$_primary}#' ] ) );
            } else {
                return $db->insert ( $this->_name, $this->_data );
            }
        } catch ( Exception $ex ) {
            throw $ex;
        }
    }
    
#{foreach key=key item=item from=$_fields}#
    /**
     *
     * @param  #{$item['typeAttribute']}# $#{$item['attribute']}#
     */
    public function set#{$item['attribute']|ucfirst}# ( $#{$item['attribute']}# ) {
        if ( $#{$item['attribute']}# ) {
#{if $item['typeAttribute'] eq 'DateTime'}#
            if ( $#{$item['attribute']}# instanceof DateTime ) {
                $this->_#{$item['attribute']}# = $#{$item['attribute']}#;

                $dateTemp = $#{$item['attribute']}#->format ( 'Y/m/d H:i:s' );
                $date = new Zend_Db_Expr ( "to_date('$dateTemp', 'YYYY-MM-DD hh24:mi:ss')" );

                $this->_data[ '#{$item['field']}#' ] = $date;
            } else {
                throw new Exception ( 'The input parameter for function "set#{$item['attribute']|ucfirst}#"  must be DateTime' );
            }
#{else if $item['typeAttribute'] eq 'Numeric'}#
            if ( is_numeric ( $#{$item['attribute']}# ) ) {
                $this->_#{$item['attribute']}# = $#{$item['attribute']}#;
                $this->_data[ '#{$item['field']}#' ] = $#{$item['attribute']}#;
            } else {
                throw new Exception ( 'The input parameter for function "set#{$item['attribute']|ucfirst}#" must be Numeric' );
            }
#{else}#
            if ( is_string ( $#{$item['attribute']}# ) ) {
                $this->_#{$item['attribute']}# = $#{$item['attribute']}#;
                $this->_data[ '#{$item['field']}#' ] = $#{$item['attribute']}#;
            } else {
                throw new Exception ( 'The input parameter for function "set#{$item['attribute']|ucfirst}#" must be String' );
            }
#{/if}#
        }
    }
    
#{/foreach}#
#{foreach key=key item=item from=$_fields}#
    /**
     *
     * @return  #{$item['typeAttribute']}#
     */
    public function get#{$item['attribute']|ucfirst}# () {
        return $this->_#{$item['attribute']}#;
    }
    
#{/foreach}#
}