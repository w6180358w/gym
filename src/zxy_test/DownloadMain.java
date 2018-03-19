package zxy_test;

import java.io.BufferedReader;
import java.io.FileReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class DownloadMain {
    public static List<String> json = new ArrayList<String>();
    public static List<String> url = new ArrayList<String>();
    public static List<String> parse(String jsonstring){
        JSONObject jb = JSONObject.fromObject(jsonstring);
        JSONArray ja = jb.getJSONArray("announcements"); 
        String pre = "http://three.cninfo.com.cn/new/announcement/download";
        try{
        for(int i=0;i<ja.size();i++){
            String id = ja.getJSONObject(i).getString("announcementId");
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            String time = ja.getJSONObject(i).getString("announcementTime");
            String title = ja.getJSONObject(i).getString("announcementTitle");
            String secname = ja.getJSONObject(i).getString("secName");
            if(title.contains("摘要")||title.contains("2009"))
                continue;
            long l = new Long(time);
            Date date = new Date(l);
            String t = formatter.format(date);

            String result = pre+"?bulletinId="+id+"&announceTime="+t;
            url.add(result);
            System.out.println(secname+":"+title);
        }}catch(Exception e){
            e.printStackTrace();
        }
        //System.out.println(ja.size());
        return url;
    }
    public static void readFile(String file){
        try{
            BufferedReader br = new BufferedReader(new FileReader(file));
            String str = br.readLine();
            while(str!=null){
                json.add(str);
                str = br.readLine();
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public static void main(String[] args){
        //下载pdf
        readFile("json/json");

        for(String s:json)
            parse(s);
        DownLoadThread t = new DownLoadThread(url,-1);
        System.out.println(t.url.size());
        ExecutorService fixedThreadPool = Executors.newFixedThreadPool(5);  
        for (int i=0;i < 1430; i++) { 
            fixedThreadPool.execute(t);  
        }
        /*for(String s:url){
            DownLoadFile.downloadFile(s,"AnnualReport//");
        }*/
    }
}
