 class ProductValidator{

  String validarImagens(List imagens){
    if (imagens.isEmpty) return "Adicione imagens do produto!";
    return null;
  }


  //Validar campo titulo, caso esteja vazio

  String validarIitulo (String text){
    if(text.isEmpty) return "Preencha o titulo do produto!";
    return null;
  }

  // Validar campo descrição caso esteja vazio
  String validarDescricao(String text){
    if(text.isEmpty) return "Preencha a descrição do produto!";
    return null;
  }

  //Validar campo preco caso nao seja numero valido
  String validarPreco(String text){
    double preco = double.tryParse(text);
    if(preco != null){
      if(!text.contains(".") || text.split(".")[1].length != 2) // se nao conter . ou a segunda parte do numero tiver mais que duas casas.
        return "Utilize 2 casas decimais!";
    } else {
      return "Preço inválido!";
    }
    return null;
  }

 }