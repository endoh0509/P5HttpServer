// https://examples.javacodegeeks.com/core-java/sun/net-sun/httpserver-net-sun/httpserver-net-sun-httpserver-net-sun/com-sun-net-httpserver-httpserver-example/

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.InputStream;
import java.io.FileInputStream;
import java.net.URI;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

@SuppressWarnings("restriction")
  public class HttpRequestHandler implements HttpHandler {

  private static final int HTTP_OK_STATUS = 200;
  private static final int HTTP_NOT_FOUND_STATUS = 404;
  private String documentRoot = "/"; 
  private static final byte[] NOT_FOUND = "<html><head><title>404 - Not Found</title></head><body>404 - Not Found</body></html>".getBytes();

  public void setDocumentRoot(String _documentRoot) {
    documentRoot = _documentRoot;
  }

  public void handle(HttpExchange t) throws IOException {
    URI uri = t.getRequestURI();

    File file = new File(documentRoot + t.getRequestURI());
    byte[] buf = "<html><head></head><body>Hello Processing HTTP Server!!</body></html>".getBytes();

    OutputStream os = t.getResponseBody();
    if (!file.exists()) {
      System.err.println("not found\n");
      t.sendResponseHeaders(HTTP_NOT_FOUND_STATUS, NOT_FOUND.length);
      os.write(NOT_FOUND);
    } else if (file.isFile()) {
      FileInputStream fis = new FileInputStream(file);
      buf = new byte[(int) file.length()];
      fis.read(buf);
      fis.close();

      t.sendResponseHeaders(200, buf.length);
      os.write(buf);
    } else if (file.isDirectory()) {
      file = new File(documentRoot + t.getRequestURI() + "/index.html");

      FileInputStream fis = new FileInputStream(file);
      buf = new byte[(int) file.length()];
      fis.read(buf);
      fis.close();

      t.sendResponseHeaders(HTTP_OK_STATUS, buf.length);
      os.write(buf);
    }

    os.close();
  }

  //private static final String AND_DELIMITER = "&";
  //private static final String EQUAL_DELIMITER = "=";
  //private static final int PARAM_NAME_IDX = 0;
  //private static final int PARAM_VALUE_IDX = 1;
  //private static final String F_NAME = "fname";
  //private static final String L_NAME = "lname";

  //private String createResponseFromQueryParams(URI uri) {
  //  String fName = "";
  //  String lName = "";
  //  String query = uri.getQuery();
  //  if (query != null) {
  //    System.out.println("Query: " + query);
  //    String[] queryParams = query.split(AND_DELIMITER);
  //    if (queryParams.length > 0) {
  //      for (String qParam : queryParams) {
  //        String[] param = qParam.split(EQUAL_DELIMITER);
  //        if (param.length > 0) {
  //          for (int i = 0; i < param.length; i++) {
  //            if (F_NAME.equalsIgnoreCase(param[PARAM_NAME_IDX])) {
  //              fName = param[PARAM_VALUE_IDX];
  //            }
  //            if (L_NAME.equalsIgnoreCase(param[PARAM_NAME_IDX])) {
  //              lName = param[PARAM_VALUE_IDX];
  //            }
  //          }
  //        }
  //      }
  //    }
  //  }

  //  return "Hello, " + fName + " " + lName;
  //}
}