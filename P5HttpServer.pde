import processing.awt.PSurfaceAWT;
import processing.net.*;
import java.net.SocketException;
import java.net.URL;

Server server;

void setup() {
  // ウィンドウを隠す(隠す必要はないけど)
  PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
  smoothCanvas.getFrame().setVisible(false);

  // サーバを立ち上げる
  server = new Server(this, 8888);
}

void draw() {
  try {
    // リクエストが来たらとりあえず返す
    Client reqClient = server.available();
    if (reqClient != null) {
      String req = reqClient.readString();
      String header = "HTTP/1.0 200 OK\r\n\r\n";

      HashMap<String, String> reqHeader = getHttpMap(req.split("\n"));
      String uri = reqHeader.get("URI");
      String filePath = "/index.html";
      
      println(uri);
      if ("/\n".equals(uri)) {
        filePath = uri;
      }
      
      // レスポンス
      String[] lines = loadStrings("www" + filePath);
      if (lines == null) {
        lines = loadStrings("www/404.html");
      }
      String html = "";
      for (String line : lines) {
        html += line;
      }
      String res = header + html;
      server.write(res);

      //println("****** req ******");
      //println(req);
      //println("****** res ******");
      //println(res);

      // 接続終了
      reqClient.dispose();
      //server.dispose();
      //server.disconnect(reqClient);
    }
  }
  catch(Exception e) {
    println("err: " + e);
  }
}

HashMap<String, String> getHttpMap(String[] lines) {
  HashMap<String, String> header = new HashMap<String, String>();
  for (String line : lines) {
    if (line.indexOf(": ") != -1) {
      header.put(line.split(": ")[0], line.split(": ")[1]);
    } else if (line.indexOf(" ") != -1) {
      String[] params = line.split(" ");
      header.put("Method", params[0]);
      header.put("URI", params[1]);
      header.put("Version", params[2]);
    }
  }
  return header;
}

public static HashMap<String, String> getQueryMap(String uri) {
  HashMap<String, String> map = new HashMap<String, String>();
  String[] uriStrings = uri.split("\\?");
  if (uriStrings.length == 1) return map;

  String[] queryParams = uriStrings[1].split("&");
  for (String qp : queryParams) {
    String[] params = qp.split("=");

    if (params.length == 1) {
      map.put(params[0], null);
    } else {
      map.put(params[0], params[1]);
    }
  }
  return map;
}


void debugPrintURL(URL url) {
  System.out.println("protocol = "        + url.getProtocol() );
  System.out.println("UserInfo = "        + url.getUserInfo() );
  System.out.println("authority = "       + url.getAuthority() );
  System.out.println("host = "            + url.getHost() );
  System.out.println("port = "            + url.getPort() );
  System.out.println("path = "            + url.getPath() );
  System.out.println("query = "           + url.getQuery() );
  System.out.println("filename = "        + url.getFile() );
  System.out.println("ref = "             + url.getRef() );
}