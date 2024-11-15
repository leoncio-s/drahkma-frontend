double principalCardScaller(double widthSize,{double maxscaller=2.0}){
  double scaller = 1.0;
  if(widthSize < 200){
    scaller = widthSize * 0.8;
  }else if(widthSize > 1200){
    scaller = widthSize * 1.2;
  }
  return scaller;
}