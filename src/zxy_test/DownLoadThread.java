package zxy_test;

import java.util.List;

public class DownLoadThread implements Runnable{
    public List<String> url;
    private int index = 0; 
    public DownLoadThread(List<String> l,int i){
        url = l;
        index = i;
    }
    public DownLoadThread(int i){
        index = i;
    }
    @Override
    public void run() {
        synchronized(this){
            index++;
        }
        DownLoadFile.downloadFile(url.get(index),"AnnualReport//");
        System.out.println(Thread.currentThread().getName()+":"+index);

    }

}