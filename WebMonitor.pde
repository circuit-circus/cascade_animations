import http.requests.*;

class WebMonitor {

  PostRequest postAlive;
  boolean debugMode;
  String serverAddress = "https://cascade-monitor.herokuapp.com/";

  WebMonitor(boolean debugMode) {
    this.debugMode = debugMode;
    if (!debugMode) {
      serverAddress = "test";
    }

    postAlive = new PostRequest(serverAddress + "/alive");
    // Add the Cascade password here before exporting application
    // DON'T PUSH THE PASSWORD TO GITHUB OR BITBUCKET
    postAlive.addUser("cascadepi", "PASSWORD");
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
