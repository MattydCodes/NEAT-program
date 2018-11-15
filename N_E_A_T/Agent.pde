class agent{
  network net = new network(in,hl,out,l);
  color c = color(random(255),random(255),random(255));
  PVector pos = new PVector(random(width),random(height));
  float mass = respmass;
  int score = 1;
  int gen = 0;
  void display(){
    fill(c);
    ellipse(pos.x,pos.y,mass,mass);
    if(showtext){
      fill(255);
      text(this.gen,this.pos.x-4,this.pos.y);
      text(this.score,this.pos.x-4,this.pos.y+10);
    }
  }
  
//---------------------------------------------------------------------------------------------------------------------------------

  void run(){
    float d = dist(plants[0].pos.x,plants[0].pos.y,this.pos.x,this.pos.y);
    int index = 0;
    for(int i = 1; i < plantpop; i++){
      float d2 = dist(plants[i].pos.x,plants[i].pos.y,this.pos.x,this.pos.y);
      if(d2 < d){
        d = d2;
        index = i;
      }
    }
    net.inputs[0] = activate(plants[index].pos.x-this.pos.x);
    net.inputs[1] = activate(plants[index].pos.y-this.pos.y);
    stroke(c);
    if(toggleclosest){
      line(this.pos.x,this.pos.y,plants[index].pos.x,plants[index].pos.y);
    }
    d = width+height;
    index = 0;
    for(int i = 0; i < pop; i++){
      if(agents[i] == this){
        continue;
      }
      float d2 = dist(agents[i].pos.x,agents[i].pos.y,this.pos.x,this.pos.y)-(agents[i].mass+this.mass)/2;
      if(d2 < d){
        d = d2;
        index = i;
      }
    }
    if(toggleclosest){
      line(this.pos.x,this.pos.y,agents[index].pos.x,agents[index].pos.y);
    }
    noStroke();
    net.inputs[2] = activate(agents[index].pos.x-this.pos.x);
    net.inputs[3] = activate(agents[index].pos.y-this.pos.y);
    net.inputs[4] = activate(this.mass-agents[index].mass);
    net.feedforward();
    if(net.outputs[0] > net.outputs[1] && net.outputs[0] > net.outputs[2] && net.outputs[0] > net.outputs[3]){
      this.pos.x+=agentspeed;
    }else if(net.outputs[1] > net.outputs[0] && net.outputs[1] > net.outputs[2] && net.outputs[1] > net.outputs[3]){
      this.pos.x-=agentspeed;
    }else if(net.outputs[2] > net.outputs[0] && net.outputs[2] > net.outputs[1] && net.outputs[2] > net.outputs[3]){
      this.pos.y+=agentspeed;
    }else if(net.outputs[3] > net.outputs[0] && net.outputs[3] > net.outputs[1] && net.outputs[3] > net.outputs[2]){
      this.pos.y-=agentspeed;
    }
    this.mass-=0.01*this.mass*decay;
    if(this.mass <= lowmass){ // || this.pos.x < 0 || this.pos.x > width || this.pos.y < 0 || this.pos.y > height (add into the if statement to make end of screen kill.
      death();
    }
    this.mass = constrain(this.mass,0,highmass);
    for(int i = 0; i < pop; i++){
      if(agents[i] == this){
        continue;
      }
      if(dist(this.pos.x,this.pos.y,agents[i].pos.x,agents[i].pos.y) < (agents[i].mass+this.mass)/2){
        if(agents[i].mass > this.mass){
          agents[i].mass+=this.mass*massgainagent;
          agents[i].score=constrain(agents[i].score+scoregainagent,1,highscore);
          
          death();
        }else{
          this.mass+=agents[i].mass*massgainagent;
          this.score=constrain(this.score+scoregainagent,1,highscore);
          agents[i].death();
        }
      }
    }
  }

//---------------------------------------------------------------------------------------------------------------------------------

  void death(){
    float total = 0;
    for(int i = 0; i < pop; i++){
      if(agents[i] == this){
        continue;
      }
      total+=agents[i].score;
    }
    float rnd = random(total);
    total = 0;
    int i;
    for(i = 0; total < rnd; i++){
      if(agents[i] == this){
        continue;
      }
      total+=agents[i].score;
    }
    //Sets roughly 50% of the net to be equal to the net that the genetic algorthim decided, 
    //I do this to try and keep variety in the neural networks. 
    this.net.adaptnet(agents[i-1]);
    this.mass = respmass;
    this.score = 1;
    this.c = color((red(agents[i-1].c)+red(this.c))/2+random(-40,40),(green(agents[i-1].c)+green(this.c))/2+random(-40,40),(blue(agents[i-1].c)+blue(this.c))/2+random(-40,40));
    this.net.mutate();
    this.gen++;
    boolean found = true;
    while(found){
      this.pos = new PVector(random(width),random(height));
      found = false;
      for(int n = 0; n < pop; n++){
        if(agents[n] == this){
          continue;
        }
        if(dist(this.pos.x,this.pos.y,agents[n].pos.x,agents[n].pos.y) <= (agents[n].mass+this.mass)/2+5){
          found = true;
        }
      }
      for(int n = 0; n < plantpop; n++){
        if(dist(this.pos.x,this.pos.y,plants[n].pos.x,plants[n].pos.y) <= this.mass/2 + 10){
          found = true;
        }
      }
    }
  }
}