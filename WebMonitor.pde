import http.requests.*;

class WebMonitor {

  PostRequest postAlive;
  boolean debugMode;
  String serverAddress = "192.168.8.109:5000";

  WebMonitor(boolean debugMode) {
    this.debugMode = debugMode;
    if (!debugMode) {
      serverAddress = "test";
    }

    postAlive = new PostRequest(serverAddress + "/alive");
    postAlive.addUser("cascadepi", "Pz73kR@!CiTD");
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
