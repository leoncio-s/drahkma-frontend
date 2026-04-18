enum CardFlagEnum{
    // ignore: constant_identifier_names
    Visa('Visa'),
    // ignore: constant_identifier_names
    Mastercard('Mastercard'),
    // ignore: constant_identifier_names
    Elo('Elo'),
    // ignore: constant_identifier_names
    AExp('American_Express'),
    // ignore: constant_identifier_names
    Hipercard('Hipercard'),
    // ignore: constant_identifier_names
    Others('Outros');

    const CardFlagEnum(String type);

    CardFlagEnum? parse(String? data){
      CardFlagEnum? value;
      switch (data){
        case "visa":
          value = CardFlagEnum.Visa;
          break;
        case "Mastercard":
          value = CardFlagEnum.Mastercard;
          break;
        case "Elo":
          value = CardFlagEnum.Elo;
          break;
        case "Hipercard":
          value = CardFlagEnum.Hipercard;
          break;
        case "Others":
          value = CardFlagEnum.Others;
          break;
        default:
          value = null;
      }

      return value;
    }
}