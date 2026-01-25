enum CardFlagEnum{
    visa('visa'),
    mastercard('Mastercard'),
    elo('Elo'),
    aExp('American_Express'), // American Expres)s
    hipercard('Hipercard'),
    others('Others');

    const CardFlagEnum(String type);

    CardFlagEnum? parse(String? data){
      CardFlagEnum? value;
      switch (data){
        case "visa":
          value = CardFlagEnum.visa;
          break;
        case "Mastercard":
          value = CardFlagEnum.mastercard;
          break;
        case "Elo":
          value = CardFlagEnum.elo;
          break;
        case "Hipercard":
          value = CardFlagEnum.hipercard;
          break;
        case "Others":
          value = CardFlagEnum.others;
          break;
        default:
          value = null;
      }

      return value;
    }
}