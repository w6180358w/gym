package com.service.inter;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Collection;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

public interface POIService<T>{
	/**
	 * 获取工作簿
	 * @return
	 */
	public Workbook getWorkBook();
	
	/**
	 * 获取sheet总数
	 * @return
	 */
	public int getSheetCount();
	
	/**
	 * 获取当前sheet
	 * @return
	 */
	public Sheet getCurrentSheet();
	
	/**
	 * 获取当前sheet数据
	 * @param beginRowIndex 开始行数
	 * @param isNullColNum	根据列数判断空行
	 * @return
	 * @throws Exception 
	 */
	public List<List<String>> getCurrentSheetData (int beginRowIndex,int isNullColNum) throws Exception;	
	
	/**
	 * 获取某一行的数据类型
	 * @param rowNum
	 * @return
	 */
	public List<String> getTypeByRowNumber(int rowNum);
	
	/**
	 * 获取某一行的数据
	 * @param rowNum
	 * @return
	 */
	public List <String> getRowValues(int rowNum);
	
	/**
	 * 获取某个单元格的类型
	 * @param cell
	 * @return
	 */
	public String getCellType(Cell cell);	
	
	/**
	 * 获取excel的类型
	 * @return
	 */
	public String getType();
	
	/**
	 * 初始化服务类
	 * @param file
	 * @param type
	 * @throws IOException
	 */
	public void initial(File file, String type ) throws IOException;
	/**
	 * 初始化服务类
	 * @param is
	 * @param type
	 * @throws IOException
	 */
	public void initial(InputStream is, String type ) throws IOException;
	
	/**
	 * 定位当前sheet
	 * @param index
	 */
	public void setCurrentSheetIndex(int index);
	
	/**
	 * 设置自定义日期格式
	 * @param dateFormat
	 */
	public void setDefDateFormat(String dateFormat);
	
	/**
	 * 是否允许空行存在
	 * @param isAllow
	 */
	public void setAllowBlank(boolean isAllow);
	
	/**
	 * 数据导出
	 * @param dataSet 要导出的数据集
	 * @param dataFields bean属性集
	 * @param out	输出流
	 * @param columns excel列头
	 * @param timePattern 时间单元格样式
	 */
	void exportExcel(Collection<T> dataSet, String[] dataFields,
			OutputStream out, String[] columns, String timePattern);
	/**
	 * 数据导出流
	 * @param dataSet 要导出的数据集
	 * @param dataFields bean属性集
	 * @param out	输出流
	 * @param columns excel列头
	 * @param timePattern 时间单元格样式
	 */
	InputStream exportExcelInputStream(Collection<T> dataSet, String[] dataFields, String[] columns,
			String timePattern);
}
