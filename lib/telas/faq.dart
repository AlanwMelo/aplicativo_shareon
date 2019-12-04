import 'package:aplicativo_shareon/telas/termos_condicoes.dart';
import 'package:aplicativo_shareon/utils/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TelaFAQ extends StatefulWidget {
  @override
  _TelaFAQState createState() => _TelaFAQState();
}

class _TelaFAQState extends State<TelaFAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeFAQ(context),
    );
  }
}

homeFAQ(BuildContext context) {
  return Scaffold(
    body: SizedBox.expand(
      child: Container(
        color: Colors.grey[300],
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 730,
            ),
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  topLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: textTitulo("FAQ"),
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _textFAQS(
                              "Como denunciar um anuncio na Share On?",
                              "Aqui na Share On, nós conectamos pessoas para que elas possam Alugar e locar de forma fácil e rápida, mas não participamos ou interferimos de qualquer forma nas negociações. A responsabilidade pelo teor do anúncio é do anunciante."
                                  "Os anúncios que infringem as nossas regras ou dicas de negociação são removidos. Você pode fazer uma denúncia nos enviando um e-mail. Lembrando que as denúncias são sempre anônimas!"),
                          _textFAQS(
                              "Está pensando em alugar algum produto?",
                              "•	Não deposite ou realize transferências fora dos meios fornecidos pelo aplicativo;"
                                  "\n\n•	Sempre que possível, teste o produto antes da locação e em locais que permitam a verificação de todas as funcionalidades do aparelho. Caso não seja possível, faça videoconferências;"
                                  "\n\n•	Nunca efetue entrega de produtos ou realize pagamentos a uma pessoa que se diz \"representante da Share On\". Não participamos, em hipótese alguma, das trocas e entregas de produtos ou serviços que ocorrem entre Locador e Locatário;"
                                  "\n\n•	Prefira fechar negócio em um lugar público e movimentado. Sempre que possível, vá acompanhado;"
                                  "\n\n•	Desconfie de contatos feitos por e-mails de provedores de outros países, como @yahoo.fr, @yahoo.co.uk, @ymail.co.uk, @yandex.com, @live.com etc.;"),
                          _textFAQS(
                              "Está pensando em fazer uma Locação?",
                              "• Antes de se encontrar com o locatário, busque informações sobre ele. Pergunte o nome com sobrenome, lugar onde mora ou trabalha, telefone para contato ou e-mail, entre outras informações que possam ajudar a identificá-lo;"
                                  "\n\n• Com os dados sobre o Locatário, faça uma pesquisa nas mídias sociais;"
                                  "\n\n• Sempre que possível, vá acompanhado;"
                                  "\n\n • Atenção às conversas que demonstram ser (mal) traduzidas, normalmente não possuem coerência ou estão em outro idioma;"
                                  "\n\n• Nunca efetue entrega de produtos ou realize pagamentos a uma pessoa que se diz \"representante da Share On\". Não participamos, em hipótese alguma, das trocas e entregas de produtos ou serviços que ocorrem entre locatário e locador;"),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: textTitulo("Como fazer um bom anuncio?"),
                          ),
                          _textFAQS(
                              "Imagens ",
                              "Elas são essenciais em um anúncio, pois demonstram o estado do produto que você está oferecendo."
                                  " Anúncios com fotos são vistos até 7 vezes mais, além de atraírem a atenção dos locadores."
                                  " Atenção: Não é permitido utilizar imagens que contenham links ou e-mails."),
                          _textFAQS(
                              "Título ",
                              "Procure ser objetivo. O título deve ser a parte do anúncio que descreve o produto/serviço oferecido em poucas palavras. "
                                  " Lembre-se: O título não pode conter palavras ou símbolos que não tenham relação com o que está sendo anunciado. Exemplo: “vendo”, “compro”, “oportunidade”, @#\$%*, entre outros.                              "),
                          _textFAQS("Contato ",
                              "Crie a sua conta usando o seu próprio e-mail e telefone. Ter contatos verídicos evita denúncias de outros usuários."),
                          _textFAQS(
                              "Preço ",
                              "O preço é um ponto muito importante no anúncio. Por isso, sempre coloque o valor total no campo “Preço”. Exemplo: Se você está alugando um carro por R\$ 30.00, coloque este valor no campo."
                                  "Lembre-se: O “Preço” definido no campo produto refere-se ao custo por hora do aluguel."),
                          _textFAQS(
                              "Descrição ",
                              "Descreva bem seu produto, com todas as informações que você ainda não havia detalhado nos campos anteriores. Mostre para os usuários os motivos para "
                                  "alugar o seu produto ou contratar o seu serviço. "
                                  "Lembre-se: Não são permitidos anúncios que contenham palavras que não estão diretamente relacionadas ao produto/serviço anunciado. Links e e-mails também não são permitidos."),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext context) {
                                          return Termos();
                                        }));
                                      },
                                      child: Text(
                                        "Termos e condições de uso",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontFamily: 'RobotoMono',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

_textFAQS(String titulo, String resposta) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          titulo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black45,
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 8),
        child: Text(
          resposta,
          style: TextStyle(
            color: Colors.black45,
          ),
        ),
      ),
    ],
  );
}
