import processing.serial.*;

import org.gicentre.utils.stat.*;

XYChart lineChart;

import cc.arduino.*;

import org.firmata.*;

Serial myPort;

String val;

int th = 0;

float x[] = new float[181]; 

float y[] = new float[181];

boolean firstContact = false;

void setup() {

  size(800, 400);

  //initialize
  myPort = new Serial(this, Serial.list()[0], 9600);


  myPort.bufferUntil('\n');

  //Line Chart Initialization

  lineChart = new XYChart(this);


  lineChart.showXAxis(true);


  lineChart.showYAxis(true);


  lineChart.setMaxY(250);


  lineChart.setMinY(0);


  lineChart.setMinX(-400);


  lineChart.setMaxX(400);

  x[0] = 0;

  y[0] = 0;

  lineChart.setData(x, y);


  lineChart.setPointColour(color(180, 50, 50, 100));


  lineChart.setPointSize(5);


  lineChart.setLineWidth(2);
}

void draw() {


  //serialEvent(myPort);


  background(255);

  textSize(9);


  lineChart.draw(0, 0, width-30, height-30);
}

void serialEvent(Serial myPort) {

  val = myPort.readStringUntil('\n');


  if (val!=null&th<=180) {


    if (firstContact == false) {


      if (val.equals("A")) {


        myPort.clear();


        myPort.write(th);


        firstContact = true;

        th++;
      }


      firstContact = true;
    } else {


      myPort.write(th);

      float d
        = float(val);

      float dx
        = d*cos((3.1415/180)*th);

      x[th] =
        dx;

      float dy
        = d*sin((3.1415/180)*th);

      y[th] =
        dy;


      println(dy);


      //lineChart.setData(x, y);


      if (th==180) {


        //println(


        lineChart.setData(x, y);


        //redraw();
      }

      th++;
    }
  }
}