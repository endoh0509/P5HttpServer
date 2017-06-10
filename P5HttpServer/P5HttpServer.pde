import processing.awt.PSurfaceAWT;
import processing.net.*;
import java.net.SocketException;
import java.net.URL;

import java.util.Base64;
import java.awt.image.BufferedImage;

import java.io.ByteArrayOutputStream;
import java.io.BufferedOutputStream;
import javax.imageio.ImageIO;
import java.util.Base64;

Server server;

String nr = "\n\r";

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
      String header = "HTTP/1.0 200 OK";

      HashMap<String, String> reqHeader = getHttpMap(req.split("\n"));
      String uri = reqHeader.get("URI");
      String filePath = "/index.html";

      //println(uri);
      if (!"/".equals(uri)) {
        filePath = uri;
      }

      // レスポンス
      //println(filePath);
      String[] lines = loadStrings("www" + filePath);
      if (lines == null) {
        header = "HTTP/1.0 404 NOT_FOUND\r\n\r\n";
        lines = loadStrings("www/404.html");
      } else if ("jpg".equals(getExtension(filePath))) {
        // TODO: 拡張子判定, Base64エンコーディング
        String code = String.join("", lines);
        String[] base64 = new String[1];
        base64[0] = "data:image/jpeg;base64," + loadBinaryImage(dataPath("www" + filePath), "jpeg");
        lines = base64;
        header += "Content-Type: image/jpeg";
      }
      String html = "";
      for (String line : lines) {
        html += nr + nr + line;
      }
      String res = header + html;
      server.write(res);

      println("****** req ******");
      println(req);
      println("****** res ******");
      println(res);

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