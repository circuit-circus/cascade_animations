import http.requests.*;

class WebMonitor {

  PostRequest postAlive;
  WebMonitorConfig config;
  boolean debugMode;
  String serverAddress = "https://cascade-monitor.herokuapp.com/";

  WebMonitor(boolean debugMode) {
    this.config = new WebMonitorConfig();
    this.debugMode = debugMode;
    if (!debugMode) {
      serverAddress = "test";
    }

    postAlive = new PostRequest(serverAddress + "/alive");
    postAlive.addUser("cascadepi", this.config.Password);
};

  void sendAlive() {
    postAlive.send();
    println(postAlive.getContent());
    if(postAlive.getContent() != null) {
      println("Sent Alive");
      //println("Reponse Content: " + postAlive.getContent());
      //println("Reponse Content-Length Header: " + postAlive.getHeader("Content-Length"));
    }
  }
    
}
