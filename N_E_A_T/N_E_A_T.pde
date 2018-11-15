//This is my first attempt at producing a neuro evolution of augmenting topologies program. The program doesn't use 
//a whole population generation, instead whenever an agent dies, it runs a genetic algorithm on the remaining agents 
//based on their current scores, and chooses one for it to be based on.
int in = 5, hl = 5, out = 4, l = 2, pop = 20, plantpop = 50; 
boolean toggleclosest = true, showtext = true, showui = true, showcontrols = true;
//Adjustable variables (for agent mass decay, low mass death, highest possible mass
//, respawn mass, mass gain from plants, mass gain from agents)
float decay = 0.15; //Multiplies the decay rate (lower the number the slower the agents mass decays).
float lowmass = 8;
float highmass = 200;
float respmass = 30;
int highscore = 1000;
float massgainplant = 5;
float massgainagent = 0.25; //This value multiplies the mass of the other agents mass before adding it to the current agents mass.
int scoregainplant = 1;
int scoregainagent = 2;
float agentspeed = 2;
//
agent[] agents = new agent[pop];
plant[] plants = new plant[plantpop];

//---------------------------------------------------------------------------------------------------------------------------------

void setup(){
  size(1000,1000,P2D);
  noStroke();
  for(int i = 0; i < pop; i++){
    agents[i] = new agent();
  }
  for(int i = 0; i < plantpop; i++){
    plants[i] = new plant();
  }
}

//---------------------------------------------------------------------------------------------------------------------------------

void mousePressed(){
  if(mouseButton == LEFT){
    frameRate(map(mouseX,0,width,10,1000));
    println(frameRate," ",map(mouseX,0,width,10,1000));
  }else{
    if(toggleclosest == true){
      toggleclosest = false;
    }else{
      toggleclosest = true; 
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------

void keyPressed(){
  if(key == 't'){
    if(showtext){
      showtext = false;
    }else{
      showtext = true;
    }
  }else if(key == 'u'){
    if(showui){
      showui = false;
    }else{
      showui = true;
    }
  }else if(key == 'c'){
    if(showcontrols){
      showcontrols = false;
    }else{
      showcontrols = true;
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------

void draw(){
  background(0);
  for(int i = 0; i < plantpop; i++){
    plants[i].collision();
    plants[i].display();
  }
  for(int i = 0; i < pop; i++){
    agents[i].run();
    agents[i].display();
  }
  if(showui){
    ui();
  }
  if(showcontrols){
    controls();
  }
}

//---------------------------------------------------------------------------------------------------------------------------------

void ui(){
  int ts = 0, tg = 0, tr = 0, tgr = 0, tb = 0;
  for(int i = 0; i < pop; i++){
    ts+=agents[i].score;
    tg+=agents[i].gen;
    tr+=red(agents[i].c);
    tgr+=green(agents[i].c);
    tb+=blue(agents[i].c);
  }
  ts/=pop;
  tg/=pop;
  tr/=pop;
  tgr/=pop;
  tb/=pop;
  fill(tr,tgr,tb,180);
  stroke(tr-50,tgr-50,tb-50,190);
  strokeWeight(5);
  rect(5,3,250,55);
  noStroke();
  strokeWeight(2);
  fill(255,180);
  textSize(20);
  text("Average score: " + str(ts),10,20);
  text("Average generation: " + str(tg),10,50);
  textSize(10);
}

//---------------------------------------------------------------------------------------------------------------------------------

void controls(){
  fill(150,180);
  stroke(100,190);
  strokeWeight(5);
  rect(width-455,3,450,152);
  noStroke();
  strokeWeight(2);
  fill(255,180);
  textSize(20);
  text("To toggle targeting press: Right mouse button",width-450,20);
  text("To toggle individual text press: t",width-450,40);
  text("To toggle averages press: u",width-450,60);
  text("To toggle controls press: c",width-450,80);
  text("Framerate is mapped from mouseX press left mouse button to set the framerate",width-450,100,440,100);
  textSize(10);
}