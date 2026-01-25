enum ItemOrderEnum {
  // ignore: constant_identifier_names
  DataDecrescente("Data Decrescente"),
  // ignore: constant_identifier_names
  DataAscendente("Data Ascendente"),

  // ignore: constant_identifier_names
  DescricaoDecrescente("Descrição Decrescente"),
  // ignore: constant_identifier_names
  DescricaoAscendente("Descrição Ascendente"),
  
  // ignore: constant_identifier_names
  ValorDecrescente("Valor Decrescente"),
  // ignore: constant_identifier_names
  ValorAscendente("Valor Ascendente");

  const ItemOrderEnum(this.element);

  final String element;
}