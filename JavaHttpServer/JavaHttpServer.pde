SimpleHttpServer server;

int PORT = 8080;

void setup() {
  HttpRequestHandler handler = new HttpRequestHandler();
  handler.setDocumentRoot(dataPath("www"));
  SimpleHttpServer simpleHttpServer = new SimpleHttpServer(PORT, "/", handler);
  simpleHttpServer.start();
  System.out.println("Server is started and listening on port "+ PORT);
}

void draw() {
}