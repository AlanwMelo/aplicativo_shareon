import  'package: aplicativo_shareon / layout_listas / lista_meus_produtos_builder.dart' ;
import  'pacote: flutter / cupertino.dart' ;
import  'pacote: flutter / material.dart' ;

classe  MeusProdutos  estende  StatefulWidget {
@sobrepor
_MeusProdutosState  createState () = >  _MeusProdutosState ();
}

classe  _MeusProdutosState  estende o  estado < MeusProdutos > {
@sobrepor
Widget  de construção ( BuildContext contexto) {
  voltar para  homeMeusProdutos ();
}
}

homeMeusProdutos () {
  andaime de retorno (
    body :  Container (
      filho :  coluna (
        filhos :  < Widget > [
          Container (
            padding :  EdgeInsets . tudo ( 10 )
            altura :  50 ,
            cor :  Cores. índigo,
            filho :  Row (
              mainAxisAlignment :  MainAxisAlignment .spaceEvenly,
              filhos :  < Widget > [
                Container (
                  filho :  expandido (
                    filho :  coluna (
                      mainAxisAlignment :  MainAxisAlignment .center,
                      crossAxisAlignment :  CrossAxisAlignment .start,
                      filhos :  < Widget > [
                        _icPesquisa (),
                      ],
                    ),
                  ),
                ),
                Container (
                  filho :  coluna (
                    mainAxisAlignment :  MainAxisAlignment .center,
                    filhos :  < Widget > [
                      _text ( "Adicionar" ),
                    ],
                  ),
                ),
                Container (
                  filho :  expandido (
                    filho :  coluna (
                      mainAxisAlignment :  MainAxisAlignment .center,
                      crossAxisAlignment :  CrossAxisAlignment .end,
                      filhos :  < Widget > [
                        _icFiltros (),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expandido (
            filho :  lista_meus_produtos_builder (),
          ),
        ],
      ),
    ),
  );
}

_icFiltros () {
  Ícone de retorno (
  Ícones .filter_list,
  cor :  cores .branco,
  tamanho :  30.0 ,
  );
}

_icPesquisa () {
  Ícone de retorno (
  Icons .search,
  cor :  cores .branco,
  tamanho :  30.0 ,
  semanticLabel :  'Definir local' ,
  );
}

_text ( String x) {
  retornar  texto (
      x,
      estilo :  TextStyle (
      cor :  cores .branco,
      fontSize :  20 ,
      fontWeight :  FontWeight .bold,
  ),
  );
}