enum CardFlagsEnum{
    visa('visa'),
    mastercard('Mastercard'),
    elo('Elo'),
    aExp('American_Express'), // American Expres)s
    hipercard('Hipercard'),
    others('Others');

    const CardFlagsEnum(String type);

    CardFlagsEnum? parse(String? data){
      CardFlagsEnum? value;
      switch (data){
        case "visa":
          value = CardFlagsEnum.visa;
          break;
        case "Mastercard":
          value = CardFlagsEnum.mastercard;
          break;
        case "Elo":
          value = CardFlagsEnum.elo;
          break;
        case "Hipercard":
          value = CardFlagsEnum.hipercard;
          break;
        case "Others":
          value = CardFlagsEnum.others;
          break;
        default:
          value = null;
      }

      return value;
    }
}