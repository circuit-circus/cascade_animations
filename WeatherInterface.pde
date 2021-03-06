import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Calendar;

class WeatherInterface {


  final String LAT = "55.6979606";
  final String LON = "12.5384718";

  XML xml;

  Calendar lastUpdatedTime;
  String tomorrowsTime;

  String latestTemperature = "25"; // in celcius
  String latestWindSpeed = "4.1"; // in mps
  String latestWindGust = "6.0"; // in mps
  String latestCloudiness = "50"; // in percentage
  String latestFog = "0"; // in percentage
  String latestPrecipitation = "2.2"; // in mm


  WeatherInterface() {
    update();
    printLastWeatherData();
  }
  
  void update(){
  thread("updateWeather");
  }
  
  void updateThread() {
    println("Updating weather interface");
    setTomorrowsTime();
    updateWeatherData();
  }

  // Calculate tomorrow at 14:00
  void setTomorrowsTime() {

    // Make a calendar object in order to calculate tomorrow
    Calendar c = Calendar.getInstance();
    // Set it to now
    c.setTime(new Date()); 
    // Clone it, so we can know when it was last updated
    lastUpdatedTime = (Calendar)c.clone(); 

    // Turn it into tomorrow at 14:00
    c.add(Calendar.DATE, 1);
    c.set(Calendar.HOUR_OF_DAY, 14);
    c.set(Calendar.MINUTE, 0);
    c.set(Calendar.SECOND, 0);
    Date tomorrow = c.getTime();

    // Format it in the same way that met.no does
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'"); //create new date format
    tomorrowsTime = format.format(tomorrow);
  }

  void updateWeatherData() {
    try {
      println("Updating weather XML");
      xml = loadXML("https://api.met.no/weatherapi/locationforecast/1.9/?lat=" + LAT + "&lon=" + LON + "&msl=20");
    } 
    catch(Exception e) {
      println(e);
    }

    if (xml != null) {
      XML prod = xml.getChild("product");
      if(prod != null) {
        XML[] timePoints = prod.getChildren("time");
        ArrayList<XML> tomorrowsTimePoints = new ArrayList<XML>();
        
        if(timePoints != null) {
          for (int i = 0; i < timePoints.length; i++) {
            if (timePoints[i].getString("to").trim().equals(tomorrowsTime) ) {
              XML dataPoint = timePoints[i];
              tomorrowsTimePoints.add(dataPoint);
    
              dataPoint = dataPoint.getChild("location");
              if(dataPoint != null) {
                latestTemperature = ( (dataPoint.getChild("temperature") != null && dataPoint.getChild("temperature").getString("value") != null) ) ? dataPoint.getChild("temperature").getString("value") : latestTemperature;
                latestWindSpeed = ( (dataPoint.getChild("windSpeed") != null && dataPoint.getChild("windSpeed").getString("mps") != null) ) ? dataPoint.getChild("windSpeed").getString("mps") : latestWindSpeed;
                latestWindGust = ( (dataPoint.getChild("windGust") != null && dataPoint.getChild("windGust").getString("mps") != null)) ? dataPoint.getChild("windGust").getString("mps") : latestWindGust;
                latestCloudiness = ( (dataPoint.getChild("cloudiness") != null && dataPoint.getChild("cloudiness").getString("percent") != null) ) ? dataPoint.getChild("cloudiness").getString("percent") : latestCloudiness;
                latestFog = ( (dataPoint.getChild("fog") != null && dataPoint.getChild("fog").getString("percent") != null) ) ? dataPoint.getChild("fog").getString("percent") : latestFog;
                latestPrecipitation = ( (dataPoint.getChild("precipitation") != null && dataPoint.getChild("precipitation").getString("value") != null) ) ? dataPoint.getChild("precipitation").getString("value") : latestPrecipitation;
              }
            }
          }
        }
      }
    }
  }

  void printLastWeatherData() {
    println("Temp: " + latestTemperature + "°C");
    println("Wind: " + latestWindSpeed + "m/s");
    println("Wind Gusts: " + latestWindGust + "m/s");
    println("Clouds: " + latestCloudiness + "%");
    println("Fog: " + latestFog + "%");
    println("Rain: " + latestPrecipitation + "mm");
  }

  int getLastUpdatedHour() {
    //return (int)lastUpdatedTime.get(Calendar.MINUTE);
    if(lastUpdatedTime != null) {
      return (int)lastUpdatedTime.get(Calendar.HOUR_OF_DAY);
    }
    else {
      return 0;
    }
  }

  float getLatestCloudiness() {
    float cloudiness = int(latestCloudiness);
    return cloudiness;
  }

  float getLatestTemperature() {
    float temperature = int(latestTemperature);
    return temperature;
  }

  float getLatestPrecipitation() {
    float precipitation = int(latestPrecipitation);
    return precipitation;
  }
  
  float getLatestWind() {
    float wind = int(latestWindSpeed);
    return wind;
  }
}
