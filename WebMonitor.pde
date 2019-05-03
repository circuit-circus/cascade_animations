import http.requests.*;

class WebMonitor {

  PostRequest postAlive;
  boolean debugMode;
  String serverAdress = "http://localhost:5000";

  WebMonitor(boolean debugMode) {
    this.debugMode = debugMode;
    if (!debugMode) {
      serverAdress = "test";
    }

    postAlive = new PostRequest(serverAdress + "/alive");
  };

  void sendAlive() {
    postAlive.send();
    println(postAlive.getContent());
    if(postAlive.getContent() != null) {
      println("Reponse Content: " + postAlive.getContent());
      println("Reponse Content-Length Header: " + postAlive.getHeader("Content-Length"));
    }
  }
    
}
