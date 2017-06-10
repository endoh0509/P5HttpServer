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

//String loadBinaryImage(String text) throws Exception {
//  String encoded = Base64.getEncoder().encodeToString(text.getBytes());
//  return encoded;
//}

String loadBinaryImage(String filename, String extension) throws Exception {
  // ファイルインスタンスを取得し、ImageIOへ読み込ませる
  File f = new File(filename);
  BufferedImage image = ImageIO.read(f);
  ByteArrayOutputStream baos = new ByteArrayOutputStream();
  BufferedOutputStream bos = new BufferedOutputStream(baos);
  image.flush();

  // 読み終わった画像をバイト出力へ。
  ImageIO.write(image, extension, bos);
  bos.flush();
  bos.close();
  byte[] bImage = baos.toByteArray();

  // バイト配列→BASE64へ変換する
  String encoded = Base64.getEncoder().encodeToString(bImage);
  //String base64Image = new String(encoded);
  return encoded;
}

//public String getFileExtension(String fileName) {
//  if (fileName == null)
//    return null;
//  int point = fileName.lastIndexOf(".");
//  if (point != -1) {
//    return fileName.substring(point + 1);
//  }
//  return fileName;
//}

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