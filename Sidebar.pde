import controlP5.*;
Textfield search;
class Sidebar
{
float sideBarWidth;
float sideBarHeight;
float sideBarEndX;
float sideBarEndY;
float sideBarRowCount;
float sideBarColumnCount;
ArrayList<Plotter> plotterArray;
Accordion accordion;
Group g1;

  Sidebar(float x, float y,float w, float h,ArrayList<Plotter> plotterArray){
    this.sideBarWidth = w;
    this.sideBarHeight = h;
    this.sideBarEndX = x;
    this.sideBarEndY = y;
    this.sideBarColumnCount = 4;
    this.sideBarRowCount = 3;
    this.plotterArray = plotterArray;

  }
  
  
  
  void drawSideBar(){
    stroke(24);
    fill(24);
    rect(sideBarEndX-sideBarWidth,sideBarEndY-sideBarHeight,sideBarEndX,sideBarEndY);
    
    //drawing menu title
    float menuTitleStartX = sideBarEndX-sideBarWidth;
    float menuTitleStartY = sideBarEndY-sideBarHeight;
    float menuTitleWidth = sideBarWidth;
    float menuTitleHeight = 0.1*sideBarHeight;
    stroke(255);
    strokeWeight(2);
    drawMenuTitle(menuTitleStartX,menuTitleStartY,menuTitleWidth,menuTitleHeight);
    
    float scaleX = menuTitleStartX;
    float scaleY = menuTitleStartY + menuTitleHeight;
    float scaleW = sideBarWidth;
    float scaleH = 0.1*sideBarHeight;
    drawScaleUp(scaleX,scaleY,scaleW,scaleH);
    
    float zoomX = menuTitleStartX;
    float zoomY = scaleY + menuTitleHeight;
    float zoomW = sideBarWidth;
    float zoomH = 0.1*sideBarHeight;
    drawZoom(zoomX,zoomY,zoomW,zoomH);
    
    float optionsX = menuTitleStartX;
    float optionsY = zoomY + menuTitleHeight;
    float optionsW = sideBarWidth;
    float optionsH = 0.2*sideBarHeight;
    drawPlotOptions(optionsX,optionsY,optionsW,optionsH);
    
    float countryListX = menuTitleStartX;
    float countryListY = optionsY + optionsH;
    float countryListW = sideBarWidth;
    float countryListH = 0.28*sideBarHeight;
        
    float sbX = menuTitleStartX;
    float sbY = countryListY + countryListH;
    float sbW = sideBarWidth;
    float sbH = 0.35*sideBarHeight;
    
        
    drawSearchAccordion(countryListX, countryListY, countryListW+sbW, countryListH+sbH );
    drawCountryList(0,0,countryListW,countryListH);
    drawSearchBox(0,countryListH,sbW,sbH);  
    
       
    stroke(0);
  }
  
  void drawMenuTitle(float x,float y,float w,float h){
   line(x,y,x+w,y);
    textAlign(CENTER,CENTER);
    fill(#ffffff);
    text("Menu",x+(w/2),y+(h/4));
    drawButton("Help",x+(w/4),y+(h/2),w*0.5,h*0.3);
    line(x,y+h,x+w,y+h);
  }
  
  void drawScaleUp(float x, float y, float w, float h){
    //textAlign(LEFT,LEFT);
    fill(#ffffff);
    float padding = 0.1*w;
    text("Scale",x+padding,y+(h/2));
    
    //UP
    float upX = x+padding*2;
    float upY = y+(h/4);
    float upW = 0.2*w;
    float upH = h;
    //stroke(24);
    //rect(upX,upY,upX+upW,upY+(upH/2));
    //fill(#000000);
    //textAlign(CENTER,CENTER);
    //text("UP",upX+(upW/2),upY+(upH/4));
    drawButton("UP",upX,upY,upW,upH/2);
    
    //DOWN
    float downX = upX+upW;
    float downY = y+(h/4);
    float downW = 0.2*w;
    float downH = h;
    //fill(#ffffff);
    //stroke(24);
    //rect(downX,downY,downX+downW,downY+(downH/2));
    //fill(#000000);
    //textAlign(CENTER,CENTER);
    //text("DOWN",downX+(downW/2),downY+(downH/4));
    //stroke(#ffffff);
    //textAlign(CENTER,CENTER);
    drawButton("DOWN",downX,downY,downW,downH/2);
    line(x,y+h,x+w,y+h);
  }
  
  void drawZoom(float x, float y, float w, float h){
    
    
    //textAlign(CENTER,CENTER);
    fill(#ffffff);
    float padding = 0.2*h;
    text("Zoom",x+w/2,y+padding);
    
    if(cp5.getController("zoom")==null){
    range = cp5.addRange("zoom")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(x,y+h*0.3)
             .setSize(int(w),int(h*0.6))
             .setHandleSize(20)
             .setRange(1980,2010)
             .setRangeValues(1985,1990)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40))  
             ;
             range.setDecimalPrecision(0);
    }
    stroke(#ffffff);
    line(x,y+h,x+w,y+h);
   
  }
  
  void drawSearchBox(float x, float y, float w, float h){
    fill(#ffffff);
    float sbW = w*0.8;
    float sbH = h*0.1; 
    //float nx = sideBarEndX - sideBarWidth;
    float ny = sideBarEndY - sideBarHeight;
    float sbX = x+(w/2)-(sbW/2);
    float sbY = y+ny*0.05;
    if(cp5.getController("searchBox")==null)
    {
      search = cp5.addTextfield("searchBox")
       .setPosition(sbX,sbY)
       .setSize(ceil(sbW*0.7),ceil(sbH))
       .setAutoClear(false)
       .setFont(new ControlFont(plotFont,defaultFontSize))
       .moveTo(g1);
       ;
      Label l = search.getCaptionLabel();
      l.setVisible(false);
      l.align(CENTER,CENTER);
    }
    
    if(cp5.getController("Reset")==null)
    {
      cp5.addButton("Reset")
       .setPosition(sbX+sbW*0.7,sbY)
       .setSize(ceil(sbW*0.3),ceil(sbH))
       .moveTo(g1);
       ;
      Label l = search.getCaptionLabel();
      l.setVisible(false);
    }
    
    float keybW = w;
    float keybH = h*0.8;
    float keybX = 0;
    float keybY = sbY+sbH;
    
    //drawing keys
    String[] row1 = {"Q","W","E","R","T","Y","U","I","O","P"};
    String[] row2 = {"A","S","D","F","G","H","J","K","L"};
    String[] row3 = {"Z","X","C","V","B","N","M"};
    float keysH = keybH/9;
    float padding = keybH/12;
    //float paddingLeft = w*0.;
    float nx = sideBarEndX - sideBarWidth;
    printRow(row1,int(keybX),int(keybY+padding),keybW,keysH);
    printRow(row2,int(keybX+nx*0.012),int(keybY+padding+(keysH)),keybW,keysH);
    printRow(row3,int(keybX+nx*0.03),int(keybY+padding+2*(keysH)),keybW,keysH);

    
  }
  
  void printRow(String[] row, int keyStartX, int keyStartY,float w, float h){
    int padding = int(h/4);
    int keyW = 20*scaleFactor;
    for(int i=0;i<row.length;i++)
    {
      if(cp5.getController(row[i]+"_KEY")==null)
      {
        controlP5.Button b = cp5.addButton(row[i]+"_KEY")
           .setPosition(keyStartX,keyStartY)
           .setSize(keyW,keyW)
           .setCaptionLabel(row[i])
           .moveTo(g1)
           //.setColorBackground(color(255))
           ;
         b.captionLabel()
          //.setValueLabel(row[i])
          .setFont(new ControlFont(plotFont,defaultFontSize))
          ;
         keyStartX+=keyW;
       }   
      }
  }
  
  void drawPlotOptions(float x, float y, float w, float h){
    textAlign(CENTER,CENTER);
    fill(#ffffff);
    float padding = 0.05*w;
    text("Plot Options",x+w/2,y+(y/20));
    
    //UP
    float upX = x+padding*2;
    float upY = y+(h/4);
    float upW = 0.4*w;
    float upH = h;
    /*stroke(24);
    rect(upX,upY,upX+upW,upY+(upH/4));
    fill(#000000);
    textAlign(CENTER,CENTER);
    text("Totals",upX+upW/2,upY+(upH/8));*/
    drawButton("Totals",upX,upY,upW,upH/4);
    
    //DOWN
    float downX = upX+upW;
    float downY = y+(h/4);
    float downW = 0.4*w;
    float downH = h;
    fill(#ffffff);
    /*stroke(24);
    rect(downX,downY,downX+downW,downY+(downH/4));
    fill(#000000);
    textAlign(CENTER,CENTER);
    text("Percentages",downX+downW/2,downY+(downH/8));*/
    drawButton("Percentages",downX,downY,downW,downH/4);
    stroke(#ffffff);
    line(x,y+h,x+w,y+h);
    
    //Per Capita
    float pcX = x+padding*2;
    float pcY = y+(h/2);
    float pcW = 0.4*w;
    float pcH = h;
    /*stroke(24);
    fill(#ffffff);
    stroke(24);
    rect(pcX,pcY,pcX+pcW,pcY+(pcH/4));
    fill(#000000);
    textAlign(CENTER,CENTER);
    text("Per Capita",pcX+pcW/2,pcY+(pcH/8));*/
    drawButton("Per Capita",pcX,pcY,pcW,pcH/4);
    
    //decade
    float decadeX = pcX+pcW;
    float decadeY = y+(h/2);
    float decadeW = 0.4*w;
    float decadeH = h;
    /*fill(#ffffff);
    stroke(24);
    rect(decadeX,decadeY,decadeX+decadeW,decadeY+(decadeH/4));
    fill(#000000);
    textAlign(CENTER,CENTER);
    text("Decade",decadeX+decadeW/2,decadeY+(decadeH/8));*/
    
    drawButton("Table",decadeX,decadeY,decadeW*0.8,decadeH/4);
    drawButton("U",decadeX+(decadeW*0.8),decadeY,decadeW*0.2,(decadeH/4)*0.5);
    drawButton("D",decadeX+(decadeW*0.8),decadeY+((decadeH/4)*0.5),decadeW*0.2,(decadeH/4)*0.5);
    stroke(#ffffff);
    line(x,y+h,x+w,y+h);
  
  }
  
  void drawButton(String name,float x,float y,float w,float h){
    if(cp5.getController(name)==null)
    {
      Button b = cp5.addButton(name)
     // Bang b = cp5.addButton(name)
       .setPosition(x,y)
       .setSize(ceil(w),ceil(h))
       ;
      Label l = b.getCaptionLabel();
      l.toUpperCase(false);
      /*println("name="+name);
      println(l.getAlign());*/
      int[] a = l.getAlign();
      a[0] = CENTER;
      a[1] = CENTER;
      l.align(a);
    }
  }
  
  void drawCountryList(float x, float y, float w, float h){
    if(countryList==null)
    {
      float nx = sideBarEndX - sideBarWidth;
      float ny = sideBarEndY - sideBarHeight;
       countryList = cp5.addListBox("CountryList")
                        .setPosition(floor(x+nx*0.002),ceil(y+ny*0.02))
                        .setSize(floor(w), floor(h))
                        .setItemHeight(ceil(h/8))
                        .setBarHeight(ceil(h/8))
                        //.setColorBackground(color(255))
                        //.setColorActive(color(#FFFFFF))
                        .toUpperCase(false)
                        //.setScrollbarWidth(ceil(w/10))
                        .moveTo(g1);
                        ;
        countryList.captionLabel().toUpperCase(false);
        countryList.captionLabel().set("Country List");
        countryList.captionLabel().style().marginTop = 3;
        countryList.valueLabel().style().marginTop = 3;
        //countryList.valueLabel().style().;
        countryList.hideBar();
        
        for (int i=0;i<plotterArray.get(0).data.columnCount;i++) {
          ListBoxItem lbi = countryList.addItem(plotterArray.get(0).data.getColumnName(i), i);
          //lbi.setColorBackground(color(0));
        }
    }
  }
  
  void drawSearchAccordion(float x, float y, float w, float h){
    if(g1==null)
    {
      g1 = cp5.addGroup("Search Group")
                  .setBackgroundColor(24)
                  .setBackgroundHeight(int(h))
                  .setBarHeight(int(h*0.05));
                  ;
      accordion = cp5.addAccordion("acc")
                   .setPosition(floor(x),floor(y))
                   .setWidth(int(w))
                   .addItem(g1)
                   .setColorBackground(#ffffff)
                   .disableCollapse();
                   ;  
      accordion.setColorActive(#ffffff);                   
      //accordion.disableCollapse();
      accordion.open(0);
    }    
  }
  
  
  
}
