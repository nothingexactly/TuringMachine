char[] tape;
int len = 0;
int charWidth = 15;
int n = 200;
int head = 0;
int phead = 0;            // perhaps use this
char config = 'b';
PVector loc;
boolean paused = false;

void setup() {
  size(1300,500);
  tape = new char[n];
  len = head;
  loc = new PVector(-20,-20);
  for (int i = 0 ; i < n ; i++) {
   tape[i] = ' '; 
  }
}

void draw() {
  background(255);
  fill(0);
  
  if (frameCount%60 == 0 && !paused) {
     update(); 
  }
  
  fill(0);
  textAlign(CENTER,CENTER);
  text("m-configuration: "+config,width/2,50);
  displayTape(tape,len,15,20);
}

void update() {
  
  if (config == 'b') {
    // initialize the machine
     tape[0] = 'e';
     tape[1] = 'e';
     tape[2] = '0';
     tape[4] = '0';
     head = 2;
     config = 'o';
     
  } else if (config == 'o') {     
     if (tape[head] == '1') {
       head++;
       headCheck();
       
       tape[head] = 'x';
       head -= 3;
       config = 'o';
     } else if (tape[head] == '0') {
       config = 'q';
     }
     
  } else if (config == 'q') {
    
    if (tape[head] == '0' || tape[head] == '1') {
      head += 2;
      headCheck();

      config = 'q';
    } else if (tape[head] == ' ') {
      tape[head] = '1';
      head--; 
      config = 'p';
    }
    
  } else if (config == 'p') {
    
    if (tape[head] == 'x') {
       tape[head] = ' ';
       head++;
       headCheck();

       config = 'q';
    } else if (tape[head] == 'e') {
      head++;
      headCheck();

      config = 'f';
    } else if (tape[head] == ' ') {
      head -= 2;
      headCheck();

      config = 'p';
    }
    
  } else {  // config == 'f'
    
    if (tape[head] != ' ') {
     head += 2;
     headCheck();

     config = 'f'; 
    } else {
     tape[head] = '0';
     head -= 2;
     config = 'o'; 
    }
    
  }
  
  if (head > len) {
     len = head; 
  }
  
}

void displayTape(char[] t, int l, int cw, int pad) {
  if (l < round((width-(2*pad))/cw)) {
    textAlign(CENTER, LEFT);
    for (int i = 0 ; i < l ; i++) {
      
      if (i == head) {
       loc = new PVector(pad+(i*cw),-5+height/4);
      }
      
      if (t[i] == '1') {
       fill(0,0,255); 
      } else {
       fill(0);
      }
      text(t[i],pad+(i*cw),height/4);
    }
  } else {
    int set = floor((width-(2*pad))/cw)+1;
    int start = l-set;
    
    for (int i = start ; i < l ; i++) {
      if (i < 0) {  // why does this happen occasionally?
       i = 0; 
      }
      
      if (i == head) {
       loc = new PVector(pad+(i*cw),-5+height/4);
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
         noFill();
         rectMode(CENTER);
         rect(loc.x,loc.y,cw+3,cw+3);

}

void headCheck() {
 if (head >= n) {
  paused = true;
  head = 0;
 } 
}

void keyPressed() {
   if (key == 'p' && head < n) {
      paused = !paused;
   } 
}
