import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Termos extends StatefulWidget {
  @override
  _TermosState createState() => _TermosState();
}

class _TermosState extends State<Termos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Termos e condições de uso'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: homeTermos(),
    );
  }
}

homeTermos() {
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
                          _textTermos(
                              "",
                              "Olá! Que bom que você chegou até aqui. É muito importante para nós que os usuários da Share On conheçam os Termos e Condições Gerais de Uso, pois trazemos informações necessárias para que usuários do aplicativo, sejam locatários, locadores ou anunciantes, tenham uma boa experiência ao utilizar a plataforma da Share On. Usar o Aplicativo implica na compreensão, aceitação e vinculação automática a este Termos e Condições Gerais de Uso. Se Você não concordar com quaisquer condições previstas neste Termos e Condições Gerais de Uso, poderá deixar de utilizar o Aplicativo."
                                  "\n\nLembre-se que além deste Termos e Condições Gerais de Uso, algumas questões específicas devem seguir Termos e Condições específicos, chamados nesse documento de “Condições Particulares”. Consulte em caso de qualquer dúvida, elas são parte das nossas regras:"),
                          _textTermos(
                              "",
                              "(I) Produtos e Serviços Proibidos na Share On;\n"
                                  "(II) Regras para Anúncios;\n"
                                  "(III) Planos Profissionais;\n"
                                  "(IV) Política de Privacidade;\n"
                                  "(V) [Outros Termos e Condições Gerais de Uso]"),
                          _textTermos("",
                              "Você vai encontrar nos itens abaixo, de forma bastante objetiva e clara, as principais informações para que possa utilizar corretamente as nossas funcionalidades, não deixe de usar nosso índice para ir direto a qualquer assunto abordado nesse T&C."),
                          _textTermos(
                              "",
                              "1.       Quem é a Share On\n"
                                  "2.       Como o Aplicativo Funciona\n"
                                  "3.       Aplicabilidade deste Termo e Condições Gerais de Uso\n"
                                  "4.       Vedações de Uso\n"
                                  "5.       Sua Conta\n"
                                  "6.       Anunciando\n"
                                  "7.       Disponibilidade do Aplicativo\n"
                                  "8.       Relações com Terceiros\n"
                                  "9.       Propriedade Intelectual\n"
                                  "10.     Alterações nas Ferramentas e Funcionalidades\n"
                                  "11.     Conflitos\n"),
                          _textTermos("1. Quem é a Share On",
                              "Ao utilizar o Aplicativo, você está acessando uma funcionalidade da Aplicativos Share On. Se tiver qualquer dúvida quanto a este Termos e Condições Gerais de Uso ou dificuldade no uso da nossa plataforma, você poderá entrar em contato conosco através do e-mail aplicativosshareon@gmail.com."),
                          _textTermos(
                              "2. Como Funciona o Aplicativo Funciona",
                              "Este aplicativo de aluguel, oferece espaço online livre para aproximar as pessoas que queiram alugar produtos novos e usados. A Share On oferece filtros para aproximar vendedores e compradores de uma mesma região, facilitando assim o encontro entre as partes."
                                  "\n\nA Share On não presta serviços de consultoria ou intermediação, e nem é proprietária dos produtos e serviços oferecidos nos anúncios, não guarda posse e não intervém na definição dos preços. Qualquer compra e venda ou contratação de serviços se dá entre os usuários, sem envolvimento da Share On. Se algo der errado em sua transação, qualquer indenização deverá ser reclamada com o outro usuário com quem você negociou."
                                  "\n\nA responsabilidade da Share On fica então restrita à disponibilização do espaço e das ferramentas que buscamos sempre aprimorar para permitir um ambiente de negócios saudável e favorável. Sendo assim, a responsabilidade pela realização de anúncios e seu conteúdo, sobre os produtos e serviços oferecidos e sobre a realização e sucesso da transação caberá sempre e exclusivamente aos usuários, portanto recomendamos que Você leia nossas dicas e procure sempre a nossa Central de Ajuda caso enfrente qualquer dificuldade ou tenha dúvidas sobre como proceder e fazer negócios."),
                          _textTermos(
                              "3. Aplicabilidade deste Termo e Condições Gerais de Uso",
                              "Este Termo e Condições Gerais de Uso é exclusivo para a utilização que Você fizer da plataforma Share On, e será atualizado de tempos em tempos para refletir mudanças da lei ou nas nossas ferramentas. Estas alterações entrarão em vigor imediatamente após inserirmos os Termos e Condições Gerais de Uso no Aplicativo, portanto cabe a Você verificar as condições vigentes no momento do uso do Aplicativo."
                                  "\n\nComo mencionamos na introdução, algumas questões específicas, além de seguir deste Termo e Condições Gerais de Uso, devem também seguir as Condições Particulares"),
                          _textTermos(
                              "4. Vedações de Uso",
                              "Você não deve inserir, transmitir, difundir ou disponibilizar a terceiros por meio do Aplicativo qualquer tipo de material ou informação que sejam contrários à legislação vigente, à moral, à ordem pública, a este Termos e Condições Gerais de Uso, às políticas da Share On e às Condições Particulares aplicáveis. Dentre outros, não é permitido "
                                  "\n(I) \"spam\", \"e-mail de correntes\", \"marketing piramidal\" e publicidade fora das áreas concebidas para tal uso; "
                                  "\n(II) conteúdo falso, ambíguo, inexato, ou que possam induzir a erro eventuais receptores de referida informação; "
                                  "\n(III) conteúdo que implique em violação ao sigilo das comunicações e à privacidade; "
                                  "\n(IV) senhas de acesso às distintas utilidades e/ou conteúdo do Aplicativo que sejam de titularidade de outros usuários."),
                          _textTermos("5. Sua Conta",
                              "Sua conta é um cadastro único para uso do Aplicativo e obrigatória para inserir anúncios. A utilização do aplicativo é restrita a pessoas maiores de 18 anos idade completos."),
                          _textTermos("5.1. Criando a Conta. ",
                              "Ao criar uma conta no Aplicativo, Você declara que todas as informações fornecidas (“Informações da Conta”) são verdadeiras e assume a responsabilidade de mantê-las atualizadas. Para proteção de sua conta, sua senha deve ser mantida em sigilo e não deve ser compartilhada, pois as atividades realizadas no Aplicativo com o uso de sua conta serão sempre de sua responsabilidade. "),
                          _textTermos(
                              "5.2. Dados de Contato. ",
                              "As Informações da Conta servem para contato de potenciais "
                                  "Locatários e também da Share On, que poderá enviar ainda divulgações sobre promoções, pacotes, novidades ou outras informações sobre a Share On e/ou sobre empresas do mesmo grupo. Os e-mails enviados para seu endereço cadastrado serão considerados como entregues a Você. As informações relacionadas às utilidades e ferramentas do Aplicativo ou outras informações adicionais que a lei exigir poderão ser enviadas por e-mail ao endereço especificado nas Informações da Conta, pelos demais meios eletrônicos disponíveis, como notificações via push ou por meio físico por escrito, por correios ao endereço indicado nas Informações da Conta. Você tem o direito de optar por deixar de receber tais e-mails, mas caso o cancelamento impossibilite a prestação dos serviços, a Share On reserva-se o direito de cancelar sua Conta."),
                          _textTermos("5.3. Suspensão e Exclusão da Conta. ",
                              "Use sua conta com consciência, pois tanto ela como seus anúncios poderão ser suspensos ou excluídos pela Share On e Você poderá ser inabilitado, sem aviso prévio, em caso de falsidade nas Informações da Conta, mau uso, violação da legislação, da moral, da ordem pública, destes Termos e Condições Gerais de Uso e das Condições Particulares que sejam aplicáveis, bem como utilização do Aplicativo para atividades ilícitas ou imorais, pela falta de pagamento, ou qualquer atividades que, a critério da Share On, não esteja de acordo com suas políticas internas. Esta análise da Share On não acarreta compromisso, garantia, obrigação ou responsabilidade da Share On quanto à veracidade das informações e conteúdo inseridos pelos usuários."),
                          _textTermos("6. Anunciando", ""),
                          _textTermos("6.1. Antes de Anunciar. ",
                              "Antes de publicar o seu anúncio, confira as dicas para que seu anúncio tenha boa qualidade e relevância para os Locatários interessados. Estas regras são uma das Condições Particulares e são atualizadas de tempos em tempos. Para que Você tenha a melhor experiência com o Aplicativo, consulte-as sempre antes de publicar."),
                          _textTermos("6.2. Anunciando. ",
                              "Para realizar o anúncio, Você deverá preencher as informações do seu produto ou serviço, estado de conservação e demais informações solicitadas. Estas informações devem ser atualizadas sempre que ocorrerem situações que mudem as condições da oferta que possam interferir na negociação. Quanto mais completo o seu anúncio, melhores as chances de fechar negócio."),
                          _textTermos(
                              "6.3. O que não pode estar no seu anúncio. ",
                              "Lembramos do seu compromisso com a licitude, exatidão das informações e reprodução fidedigna do produto ou serviço. É proibido veicular propagandas com conteúdo potencialmente ofensivo, obsceno, pornográfico, que promova o terrorismo, qualquer espécie de discriminação, ou que atente a quaisquer direitos individuais ou coletivos de terceiros. Você também não deverá inserir, transmitir, difundir ou colocar à disposição de terceiros, qualquer conteúdo que constitua publicidade ilícita ou desleal; que possa provocar danos aos sistemas informáticos do provedor de acesso, que infrinja direitos de propriedade intelectual e/ou industrial da Share On ou de terceiros."),
                          _textTermos("6.4. O que pode ser anunciado. ",
                              "Somente poderão ser veiculados no Aplicativo anúncios de produtos e/ou serviços permitidos por este Termos e Condições Gerais de Uso e respectivas regras aplicáveis, assim como pela lei vigente. Antes de veicular o seu anúncio, é sua responsabilidade se assegurar que ele está em conformidade com as condições que você encontra aqui. Você deverá obrigatoriamente ter a posse e propriedade dos produtos e disponibilidade para prestar os serviços, conforme anunciado. Você deverá informar, de forma clara e completa, condições da entrega e eventuais restrições geográficas."),
                          _textTermos("6.5. Responsabilidade. ",
                              "Cabe exclusivamente a Você a responsabilidade pelo anúncio, pelas informações veiculadas, pelas características e condições do produto ou serviço anunciado, pela sua conduta como usuário, pela entrega dos produtos e serviços (ou não entrega) e pelos tributos que possam incidir na transação."),
                          _textTermos("6.6. Prazo do Anúncio.",
                              "O seu anúncio ficará disponível por um período indeterminado. "),
                          _textTermos("6.7. Gratuidade. ",
                              "Em geral a publicação de anúncios será gratuita. A Share On não cobra comissão sobre as transações eventualmente concretizadas entre anunciantes e locatários no Aplicativo."),
                          _textTermos("7. Disponibilidade do Aplicativo",
                              "A Share On não garante a disponibilidade, acesso e continuidade do funcionamento do APLICATIVO ou de suas funcionalidades, atuais ou futuras, não sendo responsável por nenhum dano ou prejuízo causado a Você em caso de indisponibilidade."),
                          _textTermos("8. Relações com Terceiros",
                              "A responsabilidade por terceiros que oferecem conteúdos e serviços no Aplicativo, que disponibilizam ferramentas de buscas que permitem aos usuários acesso a websites externos, dos serviços e do conteúdo dos websites de terceiros acessados por links do Site será exclusiva destes terceiros. Correrá por sua conta, risco e responsabilidade as relações com estes terceiros, isentando a Share On de qualquer responsabilidade. Se você não concordar, pode optar por não utilizar os conteúdos e serviços de terceiros."),
                          _textTermos("9. Propriedade Intelectual", ""),
                          _textTermos("9.1. Proteção à Propriedade Intelectual",
                              "Sendo um Aplicativo de Aluguel e Empréstimo online, o Aplicativo não é responsável por infrações aos direitos de propriedade intelectual, direitos de imagem ou à honra dos Usuários em decorrência dos conteúdos postados pelos usuários anunciantes, mas removerá qualquer anúncio que viole direitos desta natureza."),
                          _textTermos(
                              "9.2. Propriedade Intelectual da Share On e Terceiros. ",
                              "Os elementos, conteúdo, estruturas, seleções, ordenações, apresentações do conteúdo e os programas operacionais utilizados pelo Aplicativo estão protegidos por direitos de propriedade intelectual da Share On ou de terceiros. Sem autorização prévia e expressa dos titulares, Você não poderá realizar web crawling no Aplicativo, reproduzir, exibir, copiar, transformar, modificar, desmontar, realizar engenharia reversa, distribuir, alugar, fornecer, colocar à disposição do público, através de qualquer modalidade de comunicação pública, qualquer dos elementos protegidos. É proibida a utilização de textos, imagens, anúncios e qualquer outro elemento incluído ou disponível no Aplicativo para sua posterior inclusão em quaisquer veículos alheios ao Aplicativo sem a autorização prévia e por escrito da Share On. Você não poderá remover sinais que identifiquem direitos (de propriedade intelectual, de imagem ou qualquer outro) da Share On ou de terceiros que figurem no Aplicativo e em cada uma das diversas utilidades oferecidas por ele. Você não poderá manipular quaisquer dispositivos técnicos estabelecidos pela Share On ou por terceiros para proteção de seus direitos, quer seja no Aplicativo ou em qualquer dos materiais, elementos ou informação obtida através do Aplicativo."),
                          _textTermos(
                              "9.3. Propriedade Intelectual do Conteúdo Inserido pelo Usuário. ",
                              "Você se declara titular das imagens, vídeos, áudios, textos e qualquer outro conteúdo que inserir no APLICATIVO, autorizando a Share On a reproduzir, distribuir e comunicar publicamente este conteúdo, inclusive em outros Aplicativos da Share On."),
                          _textTermos(
                              "10. Alterações nas Ferramentas e Funcionalidades",
                              "A Share On está sempre trabalhando para aprimorar as ferramentas e funcionalidades do Aplicativo, que por isso poderão ser alteradas, suspensas e descontinuadas sem aviso prévio. Se formos descontinuar ou alterar alguma funcionalidade paga, você será comunicado com pelo menos 5 dias de antecedência, lembrando que a disponibilidade dos anúncios não tem prazo específico para expirar."),
                          _textTermos("11. Conflitos",
                              "A Share On se orgulha de ser parceira dos usuários e trabalhamos para que o ambiente de negócios do Aplicativo seja sempre positivo. Se Você tiver qualquer divergência, pedimos que entre em contato nos nossos canais de atendimento, observados este Termo e Condições Gerais de Uso, as Condições Particulares e a legislação, buscaremos a solução consensual. Caso Você entenda por demandar a Share On na justiça, a demanda deverá ocorrer no Foro da Comarca de Campinas, SP ou do seu domicílio."),
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

_textTermos(String titulo, String resposta) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      titulo == ""
          ? Container()
          : Container(
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
      resposta == ""
          ? Container()
          : Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                resposta,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
    ],
  );
}
