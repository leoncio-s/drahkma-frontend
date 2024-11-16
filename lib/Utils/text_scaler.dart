double principalCardScaller(double widthSize,{double maxscaller=2.0}){
  double scaller = 1.0;
  if(widthSize < 200){
    scaller = 1.0;
  }else{
    scaller = widthSize * 0.10;
  }
  if(scaller > maxscaller){
    return maxscaller;
  }
  return scaller;
}