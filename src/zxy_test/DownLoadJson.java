package zxy_test;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;


public class DownLoadJson {
    public static int totalAnnouncement = 0;
    public static BufferedWriter bw = null;
    /* 下载 url 指向的网页 */
    public static void downloadFile(String urlStr,int pagenum) {
        try{
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            conn.setConnectTimeout(50000);
            //防止屏蔽程序抓取而返回403错误  
            conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36");  
            conn.setDoInput(true);
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setUseCaches(false);
            conn.setInstanceFollowRedirects(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setChunkedStreamingMode(5);
            conn.connect();
            DataOutputStream out = new DataOutputStream(conn.getOutputStream());

            String content = "stock=&searchkey=&plate=&category=category_ndbg_szsh;&trade="+URLEncoder.encode("信息传输、软件和信息技术服务业;", "utf-8")
                    +"&column=szse&columnTitle="+URLEncoder.encode("历史公告查询","utf-8")+"&pageNum="+pagenum+"&pageSize=30&tabName=fulltext&sortName=code&sortType=asc&limit=&showTitle="
                    +URLEncoder.encode("信息传输、软件和信息技术服务业/trade/信息传输、软件和信息技术服务业;category_ndbg_szsh/category/年度报告&seDate=请选择日期","utf-8");


            out.writeUTF(content);
            out.flush();
            out.close();
            /*Map<String,List<String>> map = conn.getHeaderFields();
            for(String s:map.keySet()){
                for(String t:map.get(s))
                    System.out.println(s+":"+t);
            }*/
            InputStream inputStream = conn.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(inputStream,"UTF-8"));

            String line = null;
            while((line=br.readLine())!=null){
                line = line.replace("“", "\'");
                line = line.replace("”", "\'");
                //line = new String(line.getBytes("GBK"),"UTF-8");
                bw.append(URLDecoder.decode(line, "utf-8"));
                bw.append("\n");

            }
            /*byte[] getData = readInputStream(inputStream);
            File saveDir = new File(savePath);
            if(!saveDir.exists())
                saveDir.mkdir();
            File file = new File(saveDir+File.separator+"json");      
            FileOutputStream fos = new FileOutputStream(file);       
            fos.write(getData);   
            if(fos!=null){  
                fos.close();    
            }  
            if(inputStream!=null){  
                inputStream.close();  
            }  */


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
     public static void main(String[] args){
         try{
             totalAnnouncement = 2880;
             bw = new BufferedWriter(new FileWriter("json//json",true));
             for(int i=1;i<totalAnnouncement/30+2;i++){
                 downloadFile("http://www.cninfo.com.cn/cninfo-new/announcement/query",i);
                 System.out.println(i);
             }
             bw.flush();
             bw.close();
         }catch(Exception e){
             e.printStackTrace();
         }

     }

}
