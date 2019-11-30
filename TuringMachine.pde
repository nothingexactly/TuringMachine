// A small problem with the way the head
// bounces off far right of screen

// String methods:
// String s = "h2";
// s.length() == 2
// s.substring(0,1) == "h"
// s.substring(1,2) == "2"
// char b = s.charAt(0); b == 'h'

char[] tape;
int len = 0;      // furthest visited position by r/w head
int n = 200;      // length of the "infinite" tape
int head = 0;     // r/w head position
int cw = 15;      // character width
int pad = 40;     // padding

String[] rw;      // read/write instructions array for the selected m-configuration

// "h0" means "head to index (position) 0 of the tape"
// "p1" means "print a '1' at this head position"
// "p " means "erase tape at this head position"
// "co" means "set the configuration to 'o'"

int lastEntry;    // length for this operation
int instruction = 0;  // instruction to be executed for this configuration
float shiftVel = 1;   // rate at which the r/w head moves in px/frame

boolean operating = false;  // indicates when all the instructions in the array
                            // have been executed and a new set of instructions
                            // must be loaded
                            
char config = 'b'; // the machine-configuration (m-configuration)
PVector loc = new PVector(pad,-5+height/4);  // location of the r/w head
PVector headAdjust = new PVector(0,0);
PVector target = new PVector(0,0);           // target location for the r/w head

PFont style;

void setup() {
  size(800,500);
  tape = new char[n];
  
  rw = new String[10];  // read/write head instructions
  lastEntry = 0;        // the final instruction in the array
  
  len = head;
  loc = new PVector(-5,-5+height/4);
  style = createFont("Monaco",16);
  textFont(style);
  
  // initialize the tape to empty char's
  for (int i = 0 ; i < n ; i++) {
   tape[i] = ' '; 
  }
}

void draw() {
  background(255);
  fill(0);
  
  if (!operating) {
    update();       // build the next array of instructions
    instruction = 0;
  } else {
    execute();      // execute each instruction in the array
  }
  
  fill(0);
  
  textAlign(CENTER,CENTER);
  text("m-configuration: "+config,width/2,50);
  text("Instruction: ",width/2-30,70);
  
  if (operating) {
    text(rw[instruction],width/2+40,70);
  }
  
  fill(0);
  displayTape(tape,len);
}

//--------------- ANIMATE -------------------
//----- Execute present instruction set -----
//-------------------------------------------

void execute() {
  String ins = rw[instruction];         // the present instruction in the array
  
  // move, print, change configuration
  String type = ins.substring(0,1);
  
  // 'x',' ','1','0','e'
  String value = ins.substring(1,ins.length());
  
  if (type.charAt(0) == 'h') {          // move the head
  
     int headIndex = Integer.parseInt(value);
         target = new PVector(pad+(headIndex*cw),-5+height/4);
     
     PVector sep = PVector.sub(target,loc);
     
      if (sep.mag() <= shiftVel) {
           loc = new PVector(target.x,target.y);
           head = headIndex;
           instruction++;
      } else {
           int temp = (headIndex-head);
           int dir = 1;
           
           if (temp != 0) {
             dir = (headIndex-head)/abs(headIndex-head);
           }
           
           loc.x += (shiftVel*dir);
      }
  
  } else if (type.charAt(0) == 'p') {   // edit tape
    tape[head] = ins.charAt(1);
    instruction++;    
  } else if (type.charAt(0) == 'c') {   // edit m-configuration    
    config = ins.charAt(1);
    instruction++;
  }
  
  if (len < head) {
    len = head;
  }
  
  if (instruction > lastEntry) {  // then draw() should call update()
     operating = false;
     instruction = -1;
  }
}

//-------------- GENERATE -----------------
//----- Generate next instruction set -----
//-----------------------------------------

void update() {

  rw = new String[10];
  lastEntry = 0;
  
  float headAdjust = 0;
  
  if (config == 'b') {
    // initialize the machine
     
     rw[0] = "h0";
     rw[1] = "pe";
     rw[2] = "h1";
     rw[3] = "pe";
     rw[4] = "h2";
     rw[5] = "p0";
     rw[6] = "h4";
     rw[7] = "p0";
     rw[8] = "h2";
     rw[9] = "co";
     lastEntry = 9;
     operating = true;
     
  } else if (config == 'o') {
    
     if (tape[head] == '1') {    // two shifts
       
       rw[0] = "h"+(head+1);
       rw[1] = "px";
       rw[2] = "h"+(head+(1-3)); // careful here
       rw[3] = "co";
       lastEntry = 3;
       operating = true;
       
     } else if (tape[head] == '0') {
       config = 'q';
     }
     
  } else if (config == 'q') {
    
    if (tape[head] == '0' || tape[head] == '1') {  // one shift
      
      rw[0] = "h"+(head+2);
      rw[1] = "cq";
      lastEntry = 1;
      operating = true;
      
    } else if (tape[head] == ' ') {
    
      rw[0] = "p1";
      rw[1] = "h"+(head-1); 
      rw[2] = "cp";
      lastEntry = 2;
      operating = true;      
      
    }
    
  } else if (config == 'p') {
    
    if (tape[head] == 'x') {
    
       rw[0] = "p ";
       rw[1] = "h"+(head+1);
       rw[2] = "cq";
       lastEntry = 2;
       operating = true;
       
    } else if (tape[head] == 'e') {

      rw[0] = "h"+(head+1);
      rw[1] = "cf";
      lastEntry = 1;
      operating = true;
      
    } else if (tape[head] == ' ') {

      rw[0] = "h"+(head-2); 
      rw[1] = "cp";
      lastEntry = 1;
      operating = true;
      
    }
    
  } else {  // config == 'f'
    
    if (tape[head] != ' ') {

     rw[0] = "h"+(head+2);
     rw[1] = "cf";
     lastEntry = 1;
     operating = true;
     
    } else {

     rw[0] = "p0";
     rw[1] = "h"+(head-2);
     rw[2] = "co";
     lastEntry = 2;
     operating = true;
     
    }
    
  }
  
  if (head > len) {
     len = head; 
  }
  
}

// --------- DISPLAY ---------

void displayTape(char[] t, int l) {
  
  // if length of the tape is less than
  // width of the viewport
  
  if (l < round((width-(2*pad))/cw)) {
    textAlign(CENTER, LEFT);
    for (int i = 0 ; i <= l ; i++) {
      
      if (t[i] == '1') {
       fill(0,0,255); 
      } else {
       fill(0);
      }
      text(t[i],pad+(i*cw),height/4);
    }
  } else {
  
  // display the end section of the tape
  // such that it fills the viewport
    
    int set = floor((width-(2*pad))/cw)+1;  // number of consecutive tape squares to display
    int start = l-set;                      // how far into the tape to start
    
    headAdjust.x = -(start*cw);             // the amount by which the head's position (determined
                                            // by the head index * cw and stored in loc) is to be
                                            // adjusted to due to horizontal scrolling
                                            
    for (int i = start ; i < l; i++) {    
      if (i < 0) {  // why does this happen occasionally?
       i = 0; 
      }
      
      if (t[i] == '1') {
       fill(0,0,255); 
      } else {
       fill(0);
      }
      
      textAlign(CENTER,LEFT);
      text(t[i],pad+((i-start)*cw),height/4);
    }
  }
         
       // show the read/write head
           noFill();
           rectMode(CENTER);
           rect(loc.x+headAdjust.x,loc.y+headAdjust.y-1,cw+5,cw+5);
}
