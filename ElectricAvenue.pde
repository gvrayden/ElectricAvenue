import controlP5.*;

//import libraries
import controlP5.*;
import processing.net.*;
import omicronAPI.*;
import java.util.Stack;

//setting plot sizes.
float totalPlotWidth;
float totalPlotHeight;
int plotRowCount = 2;
int plotColumnCount = 2;
float plotStartXWidth;
float plotStartYHeight;
int yOffset;
int xOffset;
color backgroundColor = color(#000000);
ArrayList<Plotter> plotArray = new ArrayList<Plotter>();
ArrayList<Plotter> plotArray2 = new ArrayList<Plotter>();
;
int[] colorArray;
static Stack<Integer> colorStack;
static HashMap<Integer, Integer> selectedColumns;
static ArrayList<Integer> selectedColumnsForDisplay;
static int yZoomFactor = 0;
static int scaleFactor=1;
static ControlP5 cp5;
static ListBox countryList;
ArrayList<Integer> countryListMapper = new ArrayList<Integer>();
ArrayList<Integer> selectedColumnList = new ArrayList<Integer>();
boolean isTableView = false;
int currentPage=0;
boolean showPerCapita = false;
ArrayList<FloatTable> datasets;
static Range range;
boolean showHelp;

//dock size
Dock colorDock;

//sidebar
Sidebar sideBar;

static PFont plotFont;
static int defaultFontSize = 12*scaleFactor;
//Vars related to datasets
String[] dataSetNameArray = {
  "TPEP", "TPEC", "TCDE", "TREP", "TPECPC", "PCCDE",
};

int currentColumn=0;
int columnCount;
///////////////////////////////////Start of Omicron Setup/////////////////////////////////////////
OmicronAPI omicronManager;
TouchListener touchListener;

// Link to this Processing applet - used for touchDown() callback example
PApplet applet;

// Override of PApplet init() which is called before setup()
public void init() {
  super.init();

  // Creates the OmicronAPI object. This is placed in init() since we want to use fullscreen
  omicronManager = new OmicronAPI(this);

  // Removes the title bar for full screen mode (present mode will not work on Cyber-commons wall)
  omicronManager.setFullscreen(true);
}
///////////////////////////////////End of Omicron Setup////////////////////////////////////////////

//////////////////////////////////////Starting setup///////////////////////////////////////////////
void setup() {
  size(1366, 768);
  initOmicron();
  cp5 =  new ControlP5(this);
  plotFont = createFont("DroidSans-Bold.ttf", 12*scaleFactor);
  setupPlot();
  loadDataSets();
  loadColors();

  smooth();
}

//Initialize Omicron
void initOmicron() {
  //size( 8160, 2304, P3D ); // Cyber-Commons wall

  // Make the connection to the tracker machine
  //TODO - //
  //omicronManager.ConnectToTracker(7001, 7340, "131.193.77.104");

  // Create a listener to get events
  touchListener = new TouchListener();

  // Register listener with OmicronAPI
  omicronManager.setTouchListener(touchListener);

  // Sets applet to this sketch
  applet = this;
}

//Setup the size of plots
void setupPlot() {
  yOffset = 20*scaleFactor;
  xOffset = 20*scaleFactor;
  totalPlotWidth = 0.8*width;
  totalPlotHeight = 0.8*height;
  plotStartXWidth = totalPlotWidth/plotColumnCount;
  plotStartYHeight = totalPlotHeight/plotRowCount;
  background(150, 180, 255);
  float plotStartX = 20;
  float plotStartY = 50;
  for (int k=0;k<plotRowCount;k++) {
    float currX1=0;
    float currY1;
    float currX2=0;
    float currY2;
    for (int i=0;i<plotColumnCount;i++) {
      Plotter newPlot = null;
      Plotter newPlot2 = null;
      if (i<3)
      {
        currX1 = plotStartX+(i*(plotStartXWidth+xOffset));
        currY1 = plotStartY;
        currX2 = plotStartX+(i*(plotStartXWidth+xOffset))+plotStartXWidth;
        currY2 = plotStartY+plotStartYHeight;
        newPlot = new Plotter(currX1, currY1, currX2, currY2);
        newPlot2 = new Plotter(currX1, currY1, currX2, currY2);
      }
      plotArray.add(newPlot);
      plotArray2.add(newPlot2);
    }
    plotStartY = plotStartY + plotStartYHeight + yOffset;
  }
  //start setup for the dock
  setCP5Properties();
  setupDock();
  setupSideBar();
}

void setupDock() {
  float dockWidth = 0.6*width;
  float dockHeight = 0.1*height;
  float dockStartX = width-0.85*width;
  float dockStartY = height-dockHeight;
  colorDock = new Dock(dockStartX, dockStartY, dockWidth, dockHeight, plotArray);
}

void setupSideBar() {
  float sideBarWidth = 0.15*width;
  float sideBarHeight = height;
  float sideBarEndX = width;
  float sideBarEndY = height;
  sideBar = new Sidebar(sideBarEndX, sideBarEndY, sideBarWidth, sideBarHeight, plotArray);
}

void setCP5Properties() {
  cp5.setColorForeground(#407ADB);
  cp5.setColorBackground(#ffffff);
  cp5.setColorLabel(#000000);
  cp5.setColorActive(#407ADB);
  cp5.setFont(new ControlFont(plotFont, defaultFontSize));
  //cp5.getPointer().enable();
  //font = new ControlFont(plotFont,12);
}

//Loads all the datasets and assigns it to plots
void loadDataSets() {
  datasets = new ArrayList<FloatTable>();
  for (int i=0;i<6;i++) {      
    String filename = dataSetNameArray[i];
    FloatTable energyData = new FloatTable(filename+".csv");
    if (i<4) {
      plotArray.get(i).assignDataSet(energyData, filename);
      plotArray.get(i).setupPlot();
    }
    datasets.add(energyData);
  }
  plotArray2.get(0).assignDataSet(datasets.get(0), dataSetNameArray[0]);
  plotArray2.get(0).setupPlot();

  plotArray2.get(1).assignDataSet(datasets.get(4), dataSetNameArray[4]);
  plotArray2.get(1).setupPlot();

  plotArray2.get(2).assignDataSet(datasets.get(5), dataSetNameArray[5]);
  plotArray2.get(2).setupPlot();

  plotArray2.get(3).assignDataSet(datasets.get(3), dataSetNameArray[3]);
  plotArray2.get(3).setupPlot();

  //initialize to set default column and color
  selectedColumns = new HashMap<Integer, Integer>();
  selectedColumnList = new ArrayList<Integer>();
}

void loadColors() {
  colorStack = new Stack();
  colorArray = new int[150];

  colorArray[0] = 0xFFA053D4;//FF80B1D3;
  colorArray[1] = 0xFFD453B4;//FFBC80BD;
  colorArray[2] =0xFF5386D4;//FFBEBADA;
  colorArray[3] = 0xFF08C880;//FF9508C8;//FFFB8072;
  colorArray[4] = 0xFFAD0E0E;//FFC72727;//FFFF3232;//0xFFFFF232;//FFB3DE69;
  colorArray[5] = 0xFFFF8E2A;//FFFF522A;//FFFFED6F;

  colorArray[6] = 0xFFFA9987;//0xFFFA684C;//FFFFFFFF;
  colorArray[7] = 0xFF79B71E;//0xFF4F95AD; //0xFF359128;//0xFF332891;//0xFFA3FA2F;//FFFFFFFF;
  colorArray[8] = 0xFF2F83FA;//FFFFFFFF;
  colorArray[9] = 0xFF480DBC;//0xFF732FFA;//FFFFFFFF;
  colorArray[10] = 0xFFFA2F2F;//FFFFFFFF;
  colorArray[11] = 0xFF2F8A37;//FFFFFFFF;
  colorArray[12] = 0xFF2F8A88;//FFFFFFFF;
  colorArray[13] = 0xFF322F8A;//FFFFFFFF;
  colorArray[14] = 0xFF79288A;//0xFF7A2F8A;//FFFFFFFF;
  colorArray[15] = 0xFF8A2F4B;//FFFFFFFF;
  colorArray[16] = 0xFF075B0F;//0xFF0A8115;//0xFF0EAD1C;//FFFFB432;//FFFFFFFF;
  colorArray[17] = 0xFFFF6232;//FF531E;//FF6232;//FFFFFFFF;
  for (int i=0;i<18;i++) {
    colorStack.push(colorArray[i]);
  }
  selectedColumns.put(0, colorStack.pop());
}

///////////////////////////////////////End of Setup//////////////////////////////////////////////////

//Starting Draw Functions
void draw() {
  background(backgroundColor);
  //background(#ffffff);
  fill(255, 255, 255);
  setDefaultFontParams();
  drawPlotArray();
  colorDock.drawDock();
  sideBar.drawSideBar();
  //Call to Omicron process
  if (showHelp) {
    drawHelp();
  }
  omicronManager.process();
}

//Method to draw the 6 plot rectangles.
void drawPlotArray() {
  stroke(0);
  strokeWeight(2);
  int count = 4; // display only main 4 plots

  for (int i=0;i<4;i++) {
    fill(255);
    rectMode(CORNERS); 
    if (!showPerCapita) {
      rect(plotArray.get(i).plotX1, plotArray.get(i).plotY1, plotArray.get(i).plotX2, plotArray.get(i).plotY2);
      plotArray.get(i).drawPlot();
    }
    else {
      rect(plotArray2.get(i).plotX1, plotArray2.get(i).plotY1, plotArray2.get(i).plotX2, plotArray2.get(i).plotY2);
      plotArray2.get(i).drawPlot();
    }
  }
}

void setDefaultFontParams() {
  fill(#33B5E5);
  textSize(defaultFontSize);
}

void drawHelp() {

  float helpx = width-(width*0.5);
  float helpy = height-(height*0.5);
  float helpw = width-(width*0.15);
  float helph = height;
  rect(helpx, helpy, helpw, helph);
  String infotext = 
    "==========================================\n"+
    "              Info                        \n"+
    "==========================================\n"+
    "Author : Venkateswaran Ganesan            \n"+
    "Help and Credits\n There are many options available in this tool.\n"+ 
    "1. Select the Scale UP or Scale DOWN buttons to scale the Y-axis of the graph.\n"+
    "2. Use the zoom slider to set the range of years.\n"+
    "3. There are four plot options that can be selected:\n"+
    "  - Totals switches the graph to showing totals.\n"+
    "  - Percentages shows the graph in percentages.\n"+
    "  - Per capita shows per capita graphs for CO2 Emissions and PE Consumption.\n"+
    "  - Table option can switch to Table view of the data. \nIt can show totals as well as percentage data\n."+
    "  The U and D buttons on Table, allow you to scroll through the data in the table.\n"+
    "4. Search Group is an option to search for countries/Regions.\n Click on the 'Search Group' box.\n"+
    " you will see a List of countries, you can select countries\n from the list and the graph is automatically\n"+
    " populated. The search box below provides a method to enter data,\n the country list is automatically filtered.\n"+

    "1. The data is obtained from http://www.eia.gov/cfapps/ipdbproject/IEDIndex3.cfm \n"+
    "2. ControlP5 is used for major part of the GUI design.";
  textAlign(CENTER, CENTER);
  fill(0);
  text(infotext, (helpx+helpw)/2, (helpy+helph)/2);
}

////////////////////////////////////////Start of Omicron Touch Events/////////////////////////////
// See TouchListener on how to use this function call
// In this example TouchListener draws a solid ellipse
// Ths functions here draws a ring around the solid ellipse

// NOTE: Mouse pressed, dragged, and released events will also trigger these
//       using an ID of -1 and an xWidth and yWidth value of 10.
void touchDown(int ID, float xPos, float yPos, float xWidth, float yWidth) {
  noFill();
  stroke(255, 0, 0);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
  cp5.getPointer().set(int(xPos), int(yPos));
  cp5.getPointer().pressed();
}// touchDown

void touchMove(int ID, float xPos, float yPos, float xWidth, float yWidth) {
  noFill();
  stroke(0, 255, 0);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
  cp5.getPointer().set(int(xPos), int(yPos));
}// touchMove

void touchUp(int ID, float xPos, float yPos, float xWidth, float yWidth) {
  noFill();
  stroke(0, 0, 255);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
   cp5.getPointer().released();
}// touchUp
////////////////////////////////////////End of Omicron Touch Events///////////////////////////////////////

void keyPressed() {
  columnCount = plotArray.get(1).columnCount;
  if (key == '[') {
    currentColumn--;
    if (currentColumn < 0) {
      currentColumn = columnCount - 1;
    }
  } 
  else if (key == ']') {
    currentColumn++;
    if (currentColumn == columnCount) {
      currentColumn = 0;
    }
  }
  else if (key == 'p') {
    for (int i=0;i<4;i++) { //TODO
      if (plotArray.get(i).selectedDataFormat == null)
        plotArray.get(i).selectedDataFormat = "percentages";
      else
        plotArray.get(i).selectedDataFormat = null;
    }
  }
  else if (key == '+') {
    for (int i=0;i<4;i++)
    {
      yZoomFactor++;
      plotArray.get(i).zoomFactor = yZoomFactor;
    }
  }
  else if (key=='-') {
    for (int i=0;i<4;i++)
    {
      if (yZoomFactor!=0)
        yZoomFactor--;
      plotArray.get(i).zoomFactor = yZoomFactor;
    }
  }
}


//Touch Actions
public void controlEvent(ControlEvent theEvent) 
{
  if(theEvent.isGroup() && theEvent.name().equals("Search Group")){
    
  }
  else if (theEvent.isGroup() && theEvent.name().equals("CountryList")) {
    println("CL");
    int test = (int)theEvent.group().value();
    println("col number clicked : "+test);
    //if(!selectedColumns.containsKey(test))
    if (!countryListMapper.isEmpty())
    {
      if (!selectedColumns.containsKey(countryListMapper.get(test))) {
        selectedColumns.put(countryListMapper.get(test), null);
      }
      //selectedColumns.put(test,null);
      //currentColumn = countryListMapper.get(test);
      //selectedColumnList.add(countryListMapper.get(test));
    }
    else
    {
      if (!selectedColumns.containsKey(test)) {
        selectedColumns.put(test, null);
      }
    }
  }

  //handling zoom
  else if (theEvent.isFrom("zoom")) {
    println("zoom");
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    float m = int(theEvent.getController().getArrayValue(0));
    float mx = int(theEvent.getController().getArrayValue(1));
    for (int i=0;i<4;i++) {
      plotArray.get(i).yearMin = int(m);
      plotArray.get(i).yearMax = int(mx);

      plotArray2.get(i).yearMin = int(m);
      plotArray2.get(i).yearMax = int(mx);
    }
  }
  
  else if (theEvent.getController().getName().equals("Table/Graph")) 
  {
    println(theEvent.getController().getValue());
    if (theEvent.getController().getValue()==1.0) {
      isTableView= true;
    }
    else {
      isTableView = false;
    }
  }
  else if (theEvent.getController().getName().equals("Reset")) {
    cp5.get(Textfield.class, "searchBox").setText("");
    redrawCountryList("");
  }
  //Handling legends
  else if (theEvent.getController().getName().contains("Legend")) {
    Integer col = new Integer(theEvent.getController().getName().split("_")[0]);
    println("deleting col:"+col);
    Integer ncolor = selectedColumns.get(col);
    colorStack.push(ncolor);
    selectedColumns.remove(col);
    theEvent.getController().remove();
    println("selectedColumns:"+selectedColumns);
  }
  else if (theEvent.getController().getName()=="Help") {
    if (showHelp)
      showHelp = false;
    else
      showHelp = true;
  }
  else if (!selectedColumns.isEmpty()) {
    //Handling Scale UP and DOWN
    if (theEvent.getController().getName()=="UP") {
      for (int i=0;i<4;i++)
      {
        yZoomFactor++;
        plotArray.get(i).zoomFactor = yZoomFactor;
        plotArray2.get(i).zoomFactor = yZoomFactor;
      }
    }
    else if (theEvent.getController().getName()=="DOWN") {
      for (int i=0;i<4;i++)
      {
        if (yZoomFactor!=0)
          yZoomFactor--;
        plotArray.get(i).zoomFactor = yZoomFactor;
        plotArray2.get(i).zoomFactor = yZoomFactor;
      }
    }

    //Handling Zoom IN and OUT

    else if (theEvent.getController().getName()=="D") {
      if (currentPage>=1 && currentPage <3)
        currentPage--;
    }
    else if (theEvent.getController().getName()=="U") {
      if (currentPage>=0 && currentPage <2)
        currentPage++;
    }
    //Handling Totals
    else if (theEvent.getController().getName()=="Totals") {
      showPerCapita = false;
      isTableView = false;
      for (int i=0;i<4;i++) {
        plotArray.get(i).selectedDataFormat = null;
      }
    }

    //Handling Percapita
    else if (theEvent.getController().getName()=="Per Capita") {
      isTableView = false;
      showPerCapita = true;
      for (int i=0;i<4;i++) { //TODO
        if (plotArray.get(i).selectedDataFormat == "percentages")
          plotArray.get(i).selectedDataFormat = null;
        plotArray2.get(i).selectedDataFormat = null;
      }
    }

    //Handling Decade
    else  if (theEvent.getController().getName()=="Table") {
      isTableView = true;
    }

    //Handling Percentages button
    else  if (theEvent.getController().getName()=="Percentages") {
      for (int i=0;i<4;i++) { //TODO
        if (plotArray.get(i).selectedDataFormat == null)
          plotArray.get(i).selectedDataFormat = "percentages";
        plotArray2.get(i).selectedDataFormat = "percentages";
      }
      isTableView = false;
    }

    //Printing selected characters to search box
    else if (theEvent.getController().getName().contains("_KEY")) {
      for (int i=0;i<26;i++) {
        String keypressed = theEvent.getController().getName().split("_")[0];
        char[] cs = Character.toChars('A'+i);
        String str = cs[0]+"";
        if (keypressed.equals(str)) {
          cp5.get(Textfield.class, "searchBox").setColorBackground(#000000);
          String existingText = cp5.get(Textfield.class, "searchBox").getText();
          cp5.get(Textfield.class, "searchBox").setText(existingText+str);
          redrawCountryList(existingText+str);
          //cp5.get(Textfield.class,"searchBox").getStringValue();
        }
      }
    }
  }

  //Handling searches for country


  //Printing selected characters to search box
  else if (theEvent.getController().getName().contains("_KEY")) {
    for (int i=0;i<26;i++) {
      String keypressed = theEvent.getController().getName().split("_")[0];
      char[] cs = Character.toChars('A'+i);
      String str = cs[0]+"";
      if (keypressed.equals(str)) {
        cp5.get(Textfield.class, "searchBox").setColorBackground(#000000);
        String existingText = cp5.get(Textfield.class, "searchBox").getText();
        cp5.get(Textfield.class, "searchBox").setText(existingText+str);
        redrawCountryList(existingText+str);
        //cp5.get(Textfield.class,"searchBox").getStringValue();
      }
    }
  }
}

void redrawCountryList(String txt) {
  println("kkk");
  int count=0;
  countryList.clear();
  //recreating
  countryList.captionLabel().toUpperCase(false);
  countryList.captionLabel().set("CountryList");
  //countryList.captionLabel().setColor(#ffffff);
  countryList.captionLabel().style().marginTop = 3;
  countryList.valueLabel().style().marginTop = 3;
  if (txt=="") {
    countryListMapper.clear();
    for (int i=0;i< plotArray.get(0).data.columnNames.length;i++) {
      String columnName = plotArray.get(0).data.columnNames[i]; 
      ListBoxItem lbi = countryList.addItem(columnName, count);
      //lbi.setColorBackground(color(0));
      count++;
    }
  }
  else {
    int originalColumnNumber=0;
    if (!countryListMapper.isEmpty()) { 
      countryListMapper.clear();
    }  
    for (int i=0;i< plotArray.get(0).data.columnNames.length;i++) { 
      String columnName = plotArray.get(0).data.columnNames[i]; 
      String curcol = new String(columnName);
      columnName = columnName.toLowerCase();
      txt = txt.toLowerCase();
      if (columnName.contains(txt)) {
        ListBoxItem lbi = countryList.addItem(curcol, count);
        //lbi.setColorBackground(color(0));
        countryListMapper.add(originalColumnNumber);
        count++;
      }
      originalColumnNumber++;
    }
  }
}

