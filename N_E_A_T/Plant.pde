class plant{
  PVector pos = new PVector(random(width),random(height));
  color c = color(65+random(-60,60),204+random(-60,60),55+random(-60,60));
 
//---------------------------------------------------------------------------------------------------------------------------------

  void display(){
    fill(c);
    ellipse(pos.x,pos.y,10,10);
  }
  
//---------------------------------------------------------------------------------------------------------------------------------

  void collision(){
    for(int i = 0; i < pop; i++){
      if(dist(this.pos.x,this.pos.y,agents[i].pos.x,agents[i].pos.y) < agents[i].mass/2+5){
        agents[i].mass=constrain(agents[i].mass+massgainplant,0,highmass);
        agents[i].score=constrain(agents[i].score+scoregainplant,1,highscore);
        pos = new PVector(random(width),random(height));
        boolean found = true;
        while(found){
          this.pos = new PVector(random(width),random(height));
          for(int n = 0; n < pop; n++){
            if(dist(this.pos.x,this.pos.y,agents[n].pos.x,agents[n].pos.y) >= agents[n].mass/2+5){
              found = false;
            }
          }
        }
      }
    }
  }
}