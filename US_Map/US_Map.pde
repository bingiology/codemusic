import beads.*;
import org.jaudiolibs.beads.*;

float beatLength;
int x,y,w,h;
int bpm;
Clock clock;
int beatsPerMeasure;
int currentMeasure;
int currentBeat;
float howFarInMeasure;
int stateDataLength = 3;


AudioContext ac;

PShape usa;
PShape state;

boolean onOff = true;
String[] states = {"HI", "NY"};
//String[] states = new String[stateDataLength];
float[]values = new float[stateDataLength];
int clickedState = -1;

void setup() {
  
  size(displayWidth, displayHeight);  
  usa = loadShape("US_Map.svg");
  drawUniqueStates();
  drawDataStates();
  
  ac = new AudioContext();
  bpm = 120;
  beatsPerMeasure = 16;
  beatLength = 60000.0/bpm;
  clock = new Clock(ac, beatLength);
  clock.setClick(true);
  clock.addMessageListener(
    new Bead(){
      public void messageReceived(Bead message){
        Clock c = (Clock)message;
        onClock(c);
      }
    }
    );
    
    ac.out.addDependent(clock);
    ac.start();
  
}

void draw() {
  
  background(255);
  PImage states = loadImage("states.png");
  image(states,200,90);
  

 



  
  float playheadPos = map((float)howFarInMeasure, 0,1,0,displayWidth);
  line(playheadPos,0,playheadPos,displayHeight);
  
}


void onClock(Clock c){
  currentBeat = c.getBeatCount()%beatsPerMeasure;
  currentMeasure = c.getBeatCount()/beatsPerMeasure;
  
  float ticksPerMeasure = beatsPerMeasure*c.getTicksPerBeat();
  
  howFarInMeasure = (c.getCount()%ticksPerMeasure)/ticksPerMeasure;
}




void mousePressed(){
  
  background(255);
  PImage uniqueStates = loadImage("uniqueStates.png");
  image(uniqueStates,200,90);
  color cp = get(mouseX,mouseY);
  color redVal = int(red(cp));
  for (int i=0; i<states.length; i++){
    if(int(redVal) == i+1){
      println("Clicked on: "+states[i]);
      if(clickedState!= i){
        clickedState = i;
      }
      else{
        clickedState = -1;
      }
      println("clickedState is now: " +clickedState);
    } 
  }
  image(loadImage("states.png"), 200, 90);
  onOff =! onOff;
}
 
void drawUniqueStates(){
    background(255);
    for(int i=0; i<states.length;i++){
    
      smooth();
      println(states[i]);
      PShape state = usa.getChild(states[i]);
      state.disableStyle();
      state.scale(width/1200.0);
      color c = color(i+1, i+1, i+1);
      fill(c);
      stroke(states.length+2);
      shape(state,200,90);
    }
    saveFrame("uniqueStates.png");
}

void drawDataStates(){
  background(255);
  float highest = sort(values)[values.length-1];
  float lowest = sort(values)[0]*0.85;
  float range = highest - lowest;
  int highFactor = int(255/range);
  for(int i=0; i<states.length;i++){
    smooth();
    PShape state = usa.getChild(states[i]);
    color c = color(255-(values[i] - lowest)*highFactor, 255-((values[i]-lowest)*(highFactor/4)), 255-((values[i]-lowest)*highFactor));
    fill(c);
    stroke(states.length+2);
    shape(state,200,90);
  }
    saveFrame("states.png");
}  


