enum ItemsOrderEnum {
  DataDecrescente("Data Decrescente"),
  DataAscendente("Data Ascendente"),

  DescricaoDecrescente("Descrição Decrescente"),
  DescricaoAscendente("Data Ascendente"),
  
  ValorDecrescente("Valor Decrescente"),
  ValorAscendente("Valor Ascendente");

  const ItemsOrderEnum(this.element);

  final String element;
}