<?php

require 'config/config.php';
require 'Controller.php';
require 'Zend/Db/Table/Abstract.php';

require 'model/Detalle.php';

class Index_Controller extends Controller
{

    protected $_template = 'index.tpl';

    public function indexAction () {
        $this->testFetchRow ();

        $this->render ();
    }

    public function testFetchRow () {
        $oDet = new Model_Detalle();
        $detalle = $oDet->fetchRowObject ("N_DETALLE_PK = 42");
        
        Zend_Debug::dump($detalle);
        
    }

    public function testFetchAll () {
        $oDet = new Model_Detalle();
        $detalles = $oDet->fetchAllObjects ();

        foreach ( $detalles as $key => $value ) {
            $value->setNEdad ( 20 );
            $value->save ();
        }

        Zend_Debug::dump ( $detalles );
        exit;
    }

    public function testModelBase () {
        $detalle = new Model_Base_Detalle();

        $detalle->setNDetallePk ( 'hola' );
    }

    public function directUpdate () {
        $detalle = new Model_Base_Detalle();
        $date = new DateTime ( date ( 'Y-m-d H:i:s' ) );

        $detalle->setNDetallePk ( 1 );
        $detalle->setDFechaNacimiento ( $date );
        $detalle->setDFechaUpdate ( $date );
        $detalle->save ();
    }

    public function testUpdate () {
        $detalleObj = new Model_Detalle();
        $detalles = $detalleObj->fetchRowObject ();

        Zend_Debug::dump ( $detalles->getNDetallePk () );
        $date = new DateTime ( date ( 'Y-m-d H:i:s' ) );

        $detalles->setNEdad ( 10 );
        $detalles->setNUsuarioPk ( 1 );
        $detalles->setDFechaNacimiento ( $date );

        $detalles->save ();
        exit;
    }

    public function extra () {
        Zend_Debug::dump ( $objectQuery );
        exit;

        $select = $this->select ()
                ->from ( $this->_name )
                ->columns ( array ( 'D_FECHA_NACIMIENTO' => new Zend_Db_Expr ( "TO_CHAR(D_FECHA_NACIMIENTO, 'YYYY-MM-DD hh24:mi:ss')" ) ) );

        $result = parent::fetchAll ( $select, $order, $offset );
        Zend_Debug::dump ( $result );
        EXIT;
    }

}

/* Lectura de Cabecera */
$controller = new Index_Controller();
$controller->run ();
