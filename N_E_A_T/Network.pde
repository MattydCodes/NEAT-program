class network{
  //An attempt to produce a feedforward neural network.
  float[][] inhl, hlout, hlvals;
  float[][][] hlhl;
  float[] outputs, inputs;
  int in, hl, out, l;
  network(int i_, int h_, int o_, int l_){
    in = i_;
    hl = h_;
    out = o_;
    l = l_;
    inputs = new float[in];
    hlvals = new float[l][hl];
    outputs = new float[out];
    inhl = new float[in][hl];
    hlhl = new float[l][hl][hl];
    hlout = new float[hl][out];
    for(int x = 0; x < in; x++){
      for(int y = 0; y < hl; y++){
        this.inhl[x][y] = random(-1,1);
      }
    }
    for(int z = 0; z < l; z++){
      for(int x = 0; x < hl; x++){
        for(int y = 0; y < hl; y++){
          this.hlhl[z][x][y] = random(-1,1);
        }
      }
    }
    for(int x = 0; x < hl; x++){
      for(int y = 0; y < out; y++){
        this.hlout[x][y] = random(-1,1);
      }
    }    
  }

//---------------------------------------------------------------------------------------------------------------------------------

  void mutate(){
    for(int x = 0; x < in; x++){
      for(int y = 0; y < hl; y++){
        if(random(1) >= 0.75){
          this.inhl[x][y]+=random(-0.25,0.25);
        }
      }
    }
    for(int z = 0; z < this.l; z++){
      for(int x = 0; x < this.hl; x++){
        for(int y = 0; y < this.hl; y++){
          if(random(1) >= 0.75){
            this.hlhl[z][x][y]+=random(-0.25,0.25);
          }
        }
      }
    }
    for(int x = 0; x < this.hl; x++){
      for(int y = 0; y < this.out; y++){
        if(random(1) >= 0.75){
          this.hlout[x][y]+=random(-0.25,0.25);
        }
      }
    }
  }
  
//---------------------------------------------------------------------------------------------------------------------------------

  void feedforward(){
    for(int x = 0; x < this.hl; x++){
      float total = 0;
      for(int y = 0; y < this.in; y++){
        total+=this.inputs[y]*this.inhl[y][x];
      }
      this.hlvals[0][x] = activate(total); 
    }
    for(int z = 1; z < this.l; z++){
      for(int x = 0; x < this.hl; x++){
        float total = 0;
        for(int y = 0; y < this.hl; y++){
          total+=this.hlvals[z-1][y]*this.hlhl[z-1][x][y];
        }
        this.hlvals[z][x] = activate(total);
      }
    }
    for(int x = 0; x < this.out; x++){
      float total = 0;
      for(int y = 0; y < this.hl; y++){
        total+=this.hlvals[l-1][y]*this.hlout[y][x];
      }
      this.outputs[x] = total;
    }
  }
 
//---------------------------------------------------------------------------------------------------------------------------------

  void adaptnet(agent a){
    for(int x = 0; x < in; x++){
      for(int y = 0; y < hl; y++){
        if(random(1) >= 0.5){
          this.inhl[x][y]=a.net.inhl[x][y];
        }
      }
    }
    for(int z = 0; z < this.l; z++){
      for(int x = 0; x < this.hl; x++){
        for(int y = 0; y < this.hl; y++){
          if(random(1) >= 0.5){
            this.hlhl[z][x][y]=a.net.hlhl[z][x][y];
          }
        }
      }
    }
    for(int x = 0; x < this.hl; x++){
      for(int y = 0; y < this.out; y++){
        if(random(1) >= 0.5){
          this.hlout[x][y]=a.net.hlout[x][y];
        }
      }
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------

//Sigmoid logistic function (used as the activation function in this ffnn).
float activate(float x){
  float e = 2.7182818284590452353602874713527; //Eulers number.
  float l = 1; //Curves max value.
  float x0 = 0; //Mid point.
  float k = 1; //Steepness of the curve. (If exceeding 50 layers you may wish to increase this value to 2 
               //as the activation function produces a smaller and smaller value when going through the layers.
  return((l/(1+pow(e,-k*(x-x0)))-0.5)*2); 
}