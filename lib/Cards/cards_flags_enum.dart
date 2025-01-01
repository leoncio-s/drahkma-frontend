enum CardFlagsEnum{
    Visa('Visa'),
    Mastercard('Mastercard'),
    Elo('Elo'),
    AExp('American_Express'), // American Expres)s
    Hipercard('Hipercard'),
    Others('Others');

    const CardFlagsEnum(String type);

    parse(String? data){
      CardFlagsEnum? value;
      switch (data){
        case "Visa":
          value = CardFlagsEnum.Visa;
          break;
        case "Mastercard":
          value = CardFlagsEnum.Mastercard;
          break;
        case "Elo":
          value = CardFlagsEnum.Elo;
          break;
        case "Hipercard":
          value = CardFlagsEnum.Hipercard;
          break;
        case "Others":
          value = CardFlagsEnum.Others;
          break;
        default:
          value = null;
      }

      return value;
    }
}