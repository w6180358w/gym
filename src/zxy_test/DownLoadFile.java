package zxy_test;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;


public class DownLoadFile {

    /* 下载 url 指向的网页 */
    public static void downloadFile(String urlStr, String savePath) {
        try{
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection)url.openConnection(); 
            conn.setConnectTimeout(500000);
            //防止屏蔽程序抓取而返回403错误  
            conn.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 5.0; Windows NT; DigExt)");  

         // 文件名
            String contentDisposition = new String(conn.getHeaderField("Content-Disposition").getBytes("ISO-8859-1"), "GBK");
            contentDisposition = URLDecoder.decode(contentDisposition,"utf-8");
            String filename = contentDisposition.substring(contentDisposition.indexOf('\"') + 1, contentDisposition.lastIndexOf("\""));

            File saveDir = new File(savePath);
            if(!saveDir.exists())
                saveDir.mkdir();
            filename = filename.replace("*", "");
            File file = new File(saveDir+File.separator+filename); 
            FileOutputStream fos = null;
            InputStream inputStream = null;
            if(!file.exists()){
                inputStream = conn.getInputStream();
                System.out.println(filename);
                byte[] getData = readInputStream(inputStream);
                fos = new FileOutputStream(file);       
                fos.write(getData);  
            }

            if(fos!=null){  
                fos.close();    
            }  
            if(inputStream!=null){  
                inputStream.close();  
            }  


        }catch(Exception e){
            e.printStackTrace();
        }

    }
     public static  byte[] readInputStream(InputStream inputStream) throws IOException {    
            byte[] buffer = new byte[1024];    
            int len = 0;    
            ByteArrayOutputStream bos = new ByteArrayOutputStream();    
            while((len = inputStream.read(buffer)) != -1) {    
                bos.write(buffer, 0, len);    
            }    
            bos.close();    
            return bos.toByteArray();    
        }    
}