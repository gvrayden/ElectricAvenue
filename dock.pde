class Dock{

float dockWidth;
float dockHeight;
float dockStartX;
float dockStartY;
float dockRowCount;
float dockColumnCount;
float cellWidth;
float cellHeight;
ArrayList<Plotter> plotterArray;
Stack<Integer> dockColorStack;
  
Dock(float x, float y,float w, float h,ArrayList<Plotter> plotterArray){
    this.dockWidth = w;
    this.dockHeight = h;
    this.dockStartX = x;
    this.dockStartY = y;
    this.dockColumnCount = 4;
    this.dockRowCount = 3;
    this.cellWidth = dockWidth/dockColumnCount;
    this.cellHeight = dockHeight/dockRowCount;
    this.plotterArray = plotterArray;
  }
void drawDock(){
  stroke(24);
  fill(24);
  rect(dockStartX,dockStartY,dockStartX+dockWidth,dockStartY+dockHeight);
  stroke(0);
  initColorBoxes();
  drawColorLegends();
}

void initColorBoxes(){
  dockColorStack = new Stack<Integer>();
  
  //retreive keys from hashmap and push it to stack.
  Set st = selectedColumns.keySet();
  Iterator ir = st.iterator(); 
  while(ir.hasNext()){ 
    Integer c = (Integer)ir.next();
    dockColorStack.push(c);
  }  
}

void drawColorLegends(){
  float startX = dockStartX;
  float startY = dockStartY;
  for(int k=0;k<dockRowCount;k++){
    float currX1=0;
    float currY1;
    float currX2=0;
    float currY2;
    for(int i=0;i<dockColumnCount;i++){
      if(i<4)
      {
        currX1 = startX+(i*(cellWidth));
        currY1 = startY;
        currX2 = startX+(i*(cellWidth))+cellWidth;
        currY2 = startY+cellHeight;
        drawCell(currX1,currY1,currX2,currY2);
      }
    }
    startY = startY + cellHeight;
  }
}

void drawCell(float x1,float y1,float x2,float y2){
  float colorBoxW = (x2-x1)*0.1;
  float colorBoxH = y2-y1;
  float colorBoxX1 = x1;
  float colorBoxY1 = y1;
  float colorBoxX2 = x1+colorBoxW;
  float colorBoxY2 = y1+colorBoxH;
  noStroke();
  if(!dockColorStack.isEmpty()){
    Integer col = dockColorStack.pop();
    //fill(selectedColumns.get(col));
    //rect(colorBoxX1,colorBoxY1,colorBoxX2,colorBoxY2);
    
    fill(#ffffff);
    textAlign(CENTER,CENTER);
    //text("X",colorBoxX1+(colorBoxW/2),colorBoxY1+(colorBoxH/2));
    textAlign(LEFT,CENTER);
    if(!selectedColumns.isEmpty()){
      if(selectedColumns.containsKey(col))
      {
        if(cp5.getController(col+"_Legend")==null){
         Button b = cp5.addButton(col+"_Legend")
         .setPosition(colorBoxX1,colorBoxY1)
         .setSize(ceil(colorBoxW),ceil(colorBoxH))
         .setColorActive(selectedColumns.get(col))
         .setColorBackground(selectedColumns.get(col))
         .setColorForeground(selectedColumns.get(col))
         ;
         b.setLabelVisible(false);
        }
        else{
         Button b = (Button)cp5.getController(col+"_Legend");
            b
            .setPosition(colorBoxX1,colorBoxY1)
            .setSize(ceil(colorBoxW),ceil(colorBoxH))
            .setColorActive(selectedColumns.get(col))
            .setColorBackground(selectedColumns.get(col))
            .setColorForeground(selectedColumns.get(col))
            ;
         b.setLabelVisible(false);
        }
      }
      else{
        println(col+"does not exist");
      }
      text(plotArray.get(0).data.getColumnName(col),colorBoxX2,(colorBoxY2-(colorBoxH)/2));
    }
  }  
}
}
