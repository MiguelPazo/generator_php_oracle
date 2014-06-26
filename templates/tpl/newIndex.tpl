<div class="wrap">
    <div id="contenido">
        <form id="formLogin" method="post">
            <div class="wrap-login">
                <div class="align-login">
                    <p>USUARIO</p>
                    <input name="user" size="8" class="input-login withoutFiltro" id="user"/>
                    <p>CONTRASEÑA</p>
                    <input name="pass" type="password" size="8" class="input-login withoutFiltro" id="pass"/>
                </div>
            </div>
            <div style="clear:both"></div>
            <div style="float: none !important; margin: 0 auto; text-align: center; width: 315px;">
            </div>
            <div style="clear:both"></div>
            <div class="wrap-center">
                <div class="center-btn">
                    <input type="hidden" value="login" name="funct" />
                    <input type="submit" class="button btn_ingresar" value="Ingresar" />
                </div>
            </div>

            <div id="msjError" class="wrap-login login_error">
                <div class="align-login">
                    Contraseña o usuario incorrecto
                </div>
            </div>

        </form>
    </div>
</div>

<script type="text/javascript" src="js/index.js"></script>