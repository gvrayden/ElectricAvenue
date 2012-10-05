class Plotter{
float plotX1,plotY1,plotX2,plotY2;//for holding co-ords
float plotOffsetX,plotOffsetY;
float plotX1Original,plotY1Original,plotX2Original,plotY2Original;
float dataMin, dataMax, tempDataMax;
int headingFontSize;
int axisLabelFontSize,axisLabelTextLeading;
int yearVolumeLabelSize;
String dataSetName;
int yearMin, yearMax;
int rowCount,columnCount;
int[] years;
int yearInterval = 4;
int zoomFactor=0;
FloatTable data;

float tableWidth;
float tableHeight;
float cellWidth;
float cellHeight;
  
//color defaultColor = color(#33B5E5);
color defaultColor = color(#ffffff);
String selectedDataFormat;

HashMap<String,String> titleNames = new HashMap<String,String>();
HashMap<String,String> labelArray = new HashMap<String,String>();
HashMap<String,Float> intervalMap = new HashMap<String,Float>();

  Plotter(float X1,float Y1,float X2,float Y2){
    this.plotX1 = X1;
    this.plotY1 = Y1;
    this.plotX2 = X2;
    this.plotY2 = Y2;
    //saving actual values
    this.plotX1Original=X1;
    this.plotY1Original=Y1;
    this.plotX2Original=X2;
    this.plotY2Original=Y2;
    
    this.plotOffsetX = calcDistance(X1,X2)*0.2;
    this.plotOffsetY = calcDistance(Y1,Y2)*0.2;
    //resetting plot values to accomodate Labels
    
    this.plotX1 = this.plotX1 + this.plotOffsetX;
    this.plotY2 = this.plotY2 - this.plotOffsetY;
    
    this.headingFontSize = 16*scaleFactor;
    this.axisLabelFontSize = 13*scaleFactor;
    this.axisLabelTextLeading = 15*scaleFactor;
    this.yearVolumeLabelSize = 10*scaleFactor;
    
     this.tableWidth = this.plotX2Original - this.plotX1Original;
     this.tableHeight = this.plotY2Original - this.plotY1Original;
     this.cellWidth = this.tableWidth/5;
     this.cellHeight = this.tableHeight/16;
  }
  void assignDataSet(FloatTable data, String name)
  {
    this.data = data;
    this.dataSetName = name;
  }
  void setupPlot(){
    years = int(data.getRowNames()); 
    yearMin = years[0]; 
    yearMax = years[years.length - 1]; 
    
    dataMin = 0; 
    dataMax = data.getTableMax();
   
    rowCount = data.getRowCount();
    columnCount = data.getColumnCount();
   
    searchTitle();
    searchAxisLabels();
    searchVolumeInterval();
    selectedDataFormat = null; 
    
  }
  
  void drawPlot(){
    //noFill();
    fill(0);
    rect(plotX1Original,plotY1Original,plotX2Original,plotY2Original);
    drawTitle();
    if(!isTableView){
      drawAxisLabels();
      drawYearLabels();
      drawVolumeLabels();
      //stroke();
      
      Set st = selectedColumns.keySet();
      Iterator ir = st.iterator(); 
      while(ir.hasNext()){ 
        int c = (Integer)ir.next();
        drawDataLines(c);
      }
    }
    else{
        drawTableView();
      }    
  }
  
  void drawDataLines(int col){
    
    Integer selcolor = getColorForColumn(new Integer(col));
    selectedColumns.put(col,selcolor);
    stroke(selcolor);
    //println(strokeColor);
    tempDataMax = dataMax;
    updateDataMax();
    beginShape();
    for (int row = 0; row < rowCount; row++) {
      if(selectedDataFormat == null){
        if (data.isValid(row, col)) {
          float value = data.getFloat(row, col);
          float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
          float y = map(value, dataMin, tempDataMax, plotY2, plotY1); 
          if(isBoundedByPlot(x,y))//draw only if the plot allows it.
          {
            vertex(x, y);
            strokeWeight(4);
            point(x,y);
            strokeWeight(2);
          }
          else{
            zoomFactor = zoomFactor-1;
          }
          //println(x+","+y);
        }
      }
      else if(selectedDataFormat=="percentages"){
          float value = data.percentageData[row][col];
          float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
          float y = map(value, 0, 100.0, plotY2, plotY1);  
          if(isBoundedByPlot(x,y)){    
            vertex(x, y);
          }
          //println(x+","+y);
      }
    }
    endShape();
    stroke(0);
  }
  
  void printCoords(){
    println(dataSetName+"("+plotX1+","+plotY1+","+plotX2+","+plotY2+")");
  }
  float calcDistance(float x, float y){
    return y - x;
  }
  void printDataDefaults(){
    println("==="+dataSetName+"===");
    println(dataMin);
    println(dataMax);
    println(yearMin);
    println(yearMax);
  }
  
  //Methods related to drawing title
  void drawTitle(){
    fill(defaultColor);
    textSize(headingFontSize);
    textAlign(LEFT);
    String title = getTitle();
    text(title, plotX1, plotY1-10);
    noFill();
  }
  void searchTitle(){
    titleNames.put("TPEP","PE Production ");
    titleNames.put("TPEC","PE Consumption");
    titleNames.put("TCDE","CO2 Emissions");
    titleNames.put("TREP","Renewable Electricity Production");
    titleNames.put("PCCDE","Percapita CO2 Emissions");
    titleNames.put("TPECPC","Percapita PrimaryEnergy Consumption");
  }
  String getTitle(){
    return titleNames.get(dataSetName);
  }
  
  //Methods related to drawing AxisLabels
  void drawAxisLabels(){
    fill(defaultColor);
    textSize(axisLabelFontSize);
    textLeading(axisLabelTextLeading);
    textAlign(CENTER,CENTER);
    text(getAxisLabel(),((plotX1Original+plotX1)/2)-20,((plotY1Original+plotY2Original)/2)-20);
    textAlign(CENTER);
    text("Year",(plotX1+plotX2)/2,plotY2+(plotY2*0.5));
    noFill();
  }
  void searchAxisLabels(){
      labelArray.put("TPEP","PE\nProd\nin\n Quadrillion\n Btu");
      labelArray.put("TPEC","PE\nConsumption\nin\n Quadrillion\n Btu");
      labelArray.put("TCDE","CO2\nEmissions\nin\n Million\n Metric\n Tons");
      labelArray.put("TREP","Renewable\nElect.\nin\n Billion\n KWH");
      labelArray.put("PCCDE","CO2\nEmissions\nin\n Metric\n Ton\n/Person");
      labelArray.put("TPECPC","PE\nProd\nin\n Million\n Btu\n/Person");
  }
  String getAxisLabel(){
    if(selectedDataFormat==null)
      return labelArray.get(dataSetName);
    else
      return "Percentage";
  }
  
  //methods to draw yearlables
  void drawYearLabels(){
    fill(defaultColor);
    textSize(yearVolumeLabelSize);
    textAlign(CENTER);
    
    //thin gray line to draw grid
    stroke(224);
    strokeWeight(1);
    
    for (int row = 0; row < rowCount; row++) {
      if(row==0){
        textAlign(LEFT);
      }
      else
        textAlign(CENTER);
      if (years[row] % getYearInterval() == 0) {
        float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
        if(isBoundedByPlot(x,plotY1) && isBoundedByPlot(x,plotY2)){
          text(years[row], x, plotY2 + textAscent() + 10);
          line(x, plotY1, x, plotY2);
        }
      }
    }
    stroke(#ffffff);
    line(plotX1,plotY2,plotX2,plotY2);    
    noFill();
    stroke(0);
    strokeWeight(2);
  }
  void searchVolumeInterval(){
    intervalMap.put("TPEP",50.0);
    intervalMap.put("TPEC",50.0);
    intervalMap.put("TCDE",2500.0);
    intervalMap.put("TREP",5.0);
    intervalMap.put("PCCDE",20.0);
    intervalMap.put("TPECPC",200.0);
  }
  float getVolumeInterval(){
    return intervalMap.get(dataSetName);
  }
  int getYearInterval(){
    return yearInterval;
  }
  void drawVolumeLabels(){
    fill(defaultColor);
    textSize(yearVolumeLabelSize);
    textAlign(RIGHT);
    
    stroke(224);
    strokeWeight(1);
    if(selectedDataFormat==null){ // check for percentages/total graph
      float volumeInterval = getVolumeInterval();
      //println(zoomFactor);
      tempDataMax = dataMax;
      updateDataMax();
      //println(zoomFactor);
      float volumeIntervalMinor = volumeInterval/2;
        for (float v = dataMin; v <= tempDataMax; v += volumeIntervalMinor) {
           if (v % volumeIntervalMinor == 0) {     // If a tick mark
            float y = map(v, dataMin, tempDataMax, plotY2, plotY1);  
            if (v % volumeInterval == 0) {        // If a major tick mark
              float textOffset = textAscent()/2;  // Center vertically
              if (v == dataMin) {
                textOffset = 0;                   // Align by the bottom
              } else if (v == tempDataMax) {
                textOffset = textAscent();        // Align by the top
              }
              text(floor(v), plotX1 - 10, y + textOffset);
              line(plotX1 - 4, y, plotX1, y);     // Draw major tick
            } else {
              //line(plotX1 - 2, y, plotX1, y);   // Draw minor tick
              }
           }
        }
    }
    else{
      float volumeInterval = 10;
      float volumeIntervalMinor = 5;
      
      for (float v = 0; v <= 100; v += volumeIntervalMinor) {
         if (v % volumeIntervalMinor == 0) {     // If a tick mark
          float y = map(v, 0, 100, plotY2, plotY1);  
          if (v % volumeInterval == 0) {        // If a major tick mark
            float textOffset = textAscent()/2;  // Center vertically
            if (v == dataMin) {
              textOffset = 0;                   // Align by the bottom
            } else if (v == dataMax) {
              textOffset = textAscent();        // Align by the top
            }
            text(floor(v), plotX1 - 10, y + textOffset);
            line(plotX1 - 4, y, plotX1, y);     // Draw major tick
          } else {
            //line(plotX1 - 2, y, plotX1, y);   // Draw minor tick
            }
         }
      }
    
    
    }
    
    noFill();
    stroke(0);
    strokeWeight(2);
  }
  
  void updateDataMax(){

    if (zoomFactor>0){
      tempDataMax = dataMax - (getVolumeInterval()*zoomFactor);
    }
  }
  
  Integer getColorForColumn(Integer col)
  {
    if((selectedColumns.containsKey(col)) && (selectedColumns.get(col)!=null))
    {
      return selectedColumns.get(col);
    }
    else
      {
        Integer selectedColor = colorStack.pop();
        selectedColumns.put(col,selectedColor);
        return selectedColor;
      }
  }
  
  //check if the line stays within the plot.
  boolean isBoundedByPlot(float x, float y){
    if((x>=plotX1) && (x <= plotX2) && (y <= plotY2) && (y>= plotY1))
      return true;
    else
      return false;
  }
  
  void drawTableView(){
    textSize(defaultFontSize);
    strokeWeight(1);
    float startRectX = plotX1Original;
    float startRectY = plotY1Original;
    int numberOfColumns = 4;
    int numberOfRows = 14;
    int rowPerPage = floor(rowCount/numberOfRows);
    int lastRowNumber = floor(currentPage*numberOfRows) + numberOfRows;
    if(lastRowNumber > rowCount)
     lastRowNumber = rowCount; 
    //println("starting row:"+currentPage*numberOfRows);
    //println("ending row:"+lastRowNumber);
    Set st1 = selectedColumns.keySet();
    Iterator ir1 = st1.iterator(); 
    startRectX += cellWidth; // skipping to print first cell.
    for(int currentColumn=1;ir1.hasNext();currentColumn++){ 
            int c = (Integer)ir1.next();      
            float rectnewX1 = startRectX+(currentColumn*cellWidth);
            float rectnewX2 = startRectX+(currentColumn*cellWidth)+cellWidth;
            float rectnewY1 = startRectY;
            float rectnewY2 = startRectY+cellHeight;
            
            stroke(0);
            strokeWeight(1);
            fill(#E3DEDE);
            rect(rectnewX1,rectnewY1,rectnewX2,rectnewY2);
            writeCell(rectnewX1,rectnewY1,data.getColumnName(c));
    }
    //startRectY += cellHeight;
    int c1 =1;
    for(int currentRow = currentPage*numberOfRows;currentRow<lastRowNumber;currentRow++){
            float rectnewX1 = startRectX;
            float rectnewX2 = startRectX+cellWidth;
            float rectnewY1 = startRectY+(c1*cellHeight);
            float rectnewY2 = startRectY+(c1*cellHeight)+cellHeight;
            stroke(0);
            strokeWeight(1);
            fill(#E3DEDE);
            rect(rectnewX1,rectnewY1,rectnewX2,rectnewY2);
            writeCell(rectnewX1,rectnewY1,data.getRowName(currentRow));
            c1++;
    }
    
    startRectX += cellWidth;
    Set st = selectedColumns.keySet();
        Iterator ir = st.iterator(); 
        while(ir.hasNext()){ 
          int c = (Integer)ir.next();
          Integer selcolor = getColorForColumn(new Integer(c));
          selectedColumns.put(c,selcolor);
          c1=1;
          for(int currentRow = currentPage*numberOfRows;currentRow<lastRowNumber;currentRow++){
            float rectnewX1 = startRectX;
            float rectnewX2 = startRectX+cellWidth;
            float rectnewY1 = startRectY+(c1*cellHeight);
            float rectnewY2 = startRectY+(c1*cellHeight)+cellHeight;
            c1++;
            stroke(0);
            strokeWeight(1);
            fill(#ffffff);
            rect(rectnewX1,rectnewY1,rectnewX2,rectnewY2);
            if(selectedDataFormat=="percentages"){
                writeCell(rectnewX1,rectnewY1,data.percentageData[currentRow][c]);
            }
            else{
                writeCell(rectnewX1,rectnewY1,data.getFloat(currentRow, c));
            }
          }
        startRectX = startRectX+cellWidth;
      }
      noStroke();
  }
  
  void writeCell(float x,float y,float text){
    fill(0);
    int x1 = int(x);
    int y1 = int(y);
    int x2 = ceil(x+cellWidth);
    int y2 = ceil(y+cellHeight);
    int xc = x1+((x2-x1)/2);
    int yc = y1-((y1-y2)/2);
    textAlign(CENTER);
    NumberFormat nf = NumberFormat.getInstance();
    nf.setMaximumFractionDigits(3);
    nf.setMinimumFractionDigits(3);
    String txt = String.valueOf(nf.format(text).toString());
    text(txt,xc,yc+5);
  }
void writeCell(float x,float y,String txt){
    fill(0);
    int x1 = int(x);
    int y1 = int(y);
    int x2 = ceil(x+cellWidth);
    int y2 = ceil(y+cellHeight);
    int xc = x1+((x2-x1)/2);
    int yc = y1-((y1-y2)/2);
    textAlign(CENTER);
    text(txt,xc,yc+5);
  }
}

