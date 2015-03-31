<?php

require 'config/config.php';
require 'controller.php';

class Index_Controller extends Controller
{

    /**
     *
     * @var Zend_Db_Adapter_Abstract
     */
    public $_db;
    protected $_template = 'index.tpl';
    public $_paths = array (
        'root' => 'wwwsite/',
        'modules' => 'wwwsite/modules/default/',
        'model' => 'wwwsite/model/',
        'modelBase' => 'wwwsite/model/base/',
        'templates' => 'wwwsite/templates/',
        'libs' => 'wwwsite/libs',
        'config' => 'wwwsite/config',
        'js' => 'wwwsite/js/',
        'css' => 'wwwsite/css',
        'img' => 'wwwsite/img'
    );

    public function __construct () {
        $this->_db = $GLOBALS[ 'db' ];
    }

    public function indexAction () {
        $this->createFirtDirectories ();

        $sql_t = "SELECT OBJECT_NAME TABLES FROM ALL_OBJECTS WHERE OBJECT_TYPE = 'TABLE' AND OWNER = '" . DB_USER . "'";
        $result = $this->_db->fetchAll ( $sql_t );

        foreach ( $result as $item ) {
            $fields = array ();
            $table = $item[ 'TABLES' ];

            $sql_d = "SELECT COLUMN_NAME Field, DATA_TYPE Type, CHARACTER_SET_NAME Collation, Null,
                    (SELECT 
                    DECODE(CONSTRAINT_TYPE,'P','PRI','') AS PRIMARIA FROM ALL_CONS_COLUMNS ACS
                    INNER JOIN ALL_CONSTRAINTS ACO ON ACS.CONSTRAINT_NAME = ACO.CONSTRAINT_NAME
                    WHERE ACS.OWNER = '" . DB_USER . "' AND ACS.TABLE_NAME = '" . $table . "' AND ACO.CONSTRAINT_TYPE='P' AND ROWNUM = 1
                    AND  ACS.COLUMN_NAME=U.COLUMN_NAME) KEY 
                    FROM USER_TAB_COLUMNS  U WHERE TABLE_NAME='" . $table . "'  ORDER BY KEY, FIELD";

            $result = $this->_db->fetchAll ( $sql_d );
            $primary = null;
            $contentDate = false;

            foreach ( $result as $key => $value ) {
                $field = array ();
                $nameFieldTemp = str_replace ( ' ', '', ucwords ( str_replace ( '_', ' ', strtolower ( $value[ "FIELD" ] ) ) ) );
                $nameField = strtolower ( substr ( $nameFieldTemp, 0, 1 ) ) . substr ( $nameFieldTemp, 1 );

                if ( !$primary ) {
                    $primary = true;
                    $this->getSmarty ()->assign ( "_primary", $value[ "FIELD" ] );
                }

                $field [ "attribute" ] = $nameField;
                $field [ "field" ] = $value[ "FIELD" ];
                $field [ "type" ] = $value[ "TYPE" ];

                $typePhp = null;

                switch ( $value[ "TYPE" ] ) {
                    case 'DATE':
                        $typePhp = 'DateTime';
                        $contentDate = true;
                        break;
                    default:
                        if ( count ( explode ( 'CHAR', $value[ "TYPE" ] ) ) >= 2 ) {
                            $typePhp = 'String';
                        } else {
                            $typePhp = 'Numeric';
                        }
                        break;
                }

                $field [ "typeAttribute" ] = $typePhp;

                $fields[] = $field;
            }

            $this->createModel ( $table, $fields, $contentDate );
            $this->createModelBase ( $table, $fields );
        }

        $this->render ();
    }

    public function createModel ( $table, $fields, $contentDate ) {
        $className = $this->getClassFormatName ( $table );
        $queryDate = '';
        $noDateFields = '';

        if ( $contentDate ) {
            foreach ( $fields as $key => $value ) {
                if ( $value[ 'typeAttribute' ] == 'DateTime' ) {
                    $queryDate .= "\t\t    ->columns ( array ( '{$value[ 'field' ]}' => new Zend_Db_Expr ( \"TO_CHAR({$value[ 'field' ]}, 'DD/MM/YYYY hh24:mi:ss')\" ) ) )\n";
                } else{
                    $noDateFields .= "'{$value[ 'field' ]}', ";
                }
            }
            $queryDate = substr ( $queryDate, 0, -1 );
            $noDateFields = substr ( $noDateFields, 0, -2 );
        }

        $this->getSmarty ()->assign ( "_fields", $fields );
        $this->getSmarty ()->assign ( "_table", $table );
        $this->getSmarty ()->assign ( "_contentDate", $contentDate );
        $this->getSmarty ()->assign ( "_queryDate", $queryDate );
        $this->getSmarty ()->assign ( "_noDateFields", $noDateFields );
        $this->getSmarty ()->assign ( "_modelFileBaseName", 'Base_' . $className );
        $this->getSmarty ()->assign ( "_modelName", 'Model_' . $className );
        $this->getSmarty ()->assign ( "_modelNameExtends", 'Model_Base_' . $className );

        $output = $this->getSmarty ()->fetch ( 'Model.tpl' );

        if ( file_put_contents ( $this->_paths[ 'model' ] . $className . ".php", $output ) )
            echo "Model_$className => Correcto <br/>";
        else
            echo "Model_$className => Error <br/>";
    }

    public function createModelBase ( $table, $fields ) {
        $className = $this->getClassFormatName ( $table );
        $varConstruct = '';
        $varData = '';

        foreach ( $fields as $key => $value ) {
            $varData .= "'{$value[ 'field' ]}' => '' , ";
        }

        $this->getSmarty ()->assign ( "_fields", $fields );
        $this->getSmarty ()->assign ( "_dataArray", substr ( $varData, 0, -2 ) );
        $this->getSmarty ()->assign ( "_table", $table );
        $this->getSmarty ()->assign ( "_modelName", 'Model_' . $className );


        $output = $this->getSmarty ()->fetch ( 'Model_Base.tpl' );

        if ( file_put_contents ( $this->_paths[ 'modelBase' ] . $className . ".php", $output ) )
            echo "Application_Model_Base_$className => Correcto <br/>";
        else
            echo "Application_Model_Base_$className => Error <br/>";
    }

    public function createFirtDirectories () {
        if ( !is_dir ( $this->_paths[ 'modelBase' ] ) )
            mkdir ( $this->_paths[ 'modelBase' ], 777, true );
        
        if ( !is_dir ( $this->_paths[ 'modules' ] ) )
            mkdir ( $this->_paths[ 'modules' ], 777, true );

        if ( !is_dir ( $this->_paths[ 'templates' ] . 'tpl' ) )
            mkdir ( $this->_paths[ 'templates' ] . 'tpl', 777, true );

        if ( !is_dir ( $this->_paths[ 'templates' ] . 'compile' ) )
            mkdir ( $this->_paths[ 'templates' ] . 'compile', 777, true );

        if ( !is_dir ( $this->_paths[ 'templates' ] . 'cache' ) )
            mkdir ( $this->_paths[ 'templates' ] . 'cache', 777, true );

        copy ( 'newIndex.php', $this->_paths[ 'root' ] . 'index.php' );
        copy ( 'newIndexController.php', $this->_paths[ 'modules' ] . 'IndexController.php' );
        copy ( '.htaccess_1', $this->_paths[ 'root' ] . '.htaccess' );
        copy ( 'templates/tpl/newIndex.tpl', $this->_paths[ 'templates' ] . 'tpl/index.tpl' );
        copy ( 'templates/tpl/newPage.tpl', $this->_paths[ 'templates' ] . 'tpl/page.tpl' );
        copy ( 'templates/tpl/newLayout.tpl', $this->_paths[ 'templates' ] . 'tpl/layout.tpl' );

//        $this->fullCopy ( 'libs/', $this->_paths[ 'libs' ] );
        $this->fullCopy ( 'config/', $this->_paths[ 'config' ] );
        $this->fullCopy ( 'css/', $this->_paths[ 'css' ] );
        $this->fullCopy ( 'js/', $this->_paths[ 'js' ] );
        $this->fullCopy ( 'img/', $this->_paths[ 'img' ] );
    }

    public function getClassFormatName ( $table ) {
        return str_replace ( ' ', '', ucwords ( str_replace ( '_', ' ', strtolower ( $table ) ) ) );
    }

    public function fullCopy ( $source, $target ) {
        if ( is_dir ( $source ) ) {
            @mkdir ( $target );
            $d = dir ( $source );
            while ( FALSE !== ( $entry = $d->read () ) ) {
                if ( $entry == '.' || $entry == '..' ) {
                    continue;
                } $Entry = $source . '/' . $entry;
                if ( is_dir ( $Entry ) ) {
                    $this->fullCopy ( $Entry, $target . '/' . $entry );
                    continue;
                } copy ( $Entry, $target . '/' . $entry );
            } $d->close ();
        } else {
            copy ( $source, $target );
        }
    }

}

/* Lectura de Cabecera */
$controller = new Index_Controller();
$controller->_db = $db;
$controller->run ();
