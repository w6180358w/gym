package com.service.impl;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFComment;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import com.service.inter.POIService;

@Service("POIService")
public class POIServiceImpl<T> implements POIService<T>{

	public static final String DATE="日期";
	public static final String DIGITAL="数字";
	public static final String INT="整数";
	public static final String DOUBLE="实数";
	public static final String STRING="字符";
	public static final String BOOLEAN="布尔";
	public static final String BLANK="空";
	public static final String FORMULA="公式";
	public static final String ERROR="错误";
	public static final String OTHER="其他";
	private Workbook workBook=null;
	private Sheet sheet = null;
	private String type=null;
	private int sheetCount;
	private String dateFormat="yyyy-MM-dd";
	private boolean isAllowBlankRow=false;
	
	@Override
	public void initial(File file, String type) throws IOException {
		InputStream  is = new FileInputStream(file);
		if ("xlsx".endsWith(type)) {
			workBook = new XSSFWorkbook(is);
			this.type=type;
		} else {
			workBook = new HSSFWorkbook(is);
			this.type="xls";
		}
		this.sheetCount = workBook.getNumberOfSheets();
		this.sheet=workBook.getSheetAt(0);
	}
	
	@Override
	public void initial(InputStream is, String type) throws IOException {
		if ("xlsx".endsWith(type)) {
			workBook = new XSSFWorkbook(is);
			this.type=type;
		} else {
			workBook = new HSSFWorkbook(is);
			this.type="xls";
		}
		this.sheetCount = workBook.getNumberOfSheets();
		this.sheet=workBook.getSheetAt(0);
	}
	
	@Override
	public Workbook getWorkBook() {
		return this.workBook;
	}

	@Override
	public int getSheetCount() {
		return this.sheetCount;
	}

	@Override
	public Sheet getCurrentSheet() {
		return this.sheet;
	}

	@Override
	public List<List<String>> getCurrentSheetData(int beginRowIndex,int isNullColNum) throws Exception {
		Row row = null;
		List<List<String>> list = new ArrayList<List<String>>();
		try {
			int num = sheet.getLastRowNum();
			int colNum = 0;
			if (0 <= beginRowIndex && beginRowIndex <= num) {
				List <String>rowList = null;
				for (int i = beginRowIndex; i <= num; i++) {
					row = sheet.getRow(i);
					String value = getCellValue(row.getCell(isNullColNum));
					if((!this.isAllowBlankRow&&(value==null || value.equals("")))||row==null)
						continue;
					colNum = sheet.getRow(0).getLastCellNum();
					rowList = new ArrayList<String>();
					if (row.getLastCellNum() >= 0) {
						for (int j = 0; j <=colNum; j++) {
							Cell cell=row.getCell(j);
							if(cell!=null)
								rowList.add(getCellValue(cell));
							else
								rowList.add("");
						}
					}
					list.add(rowList);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("获取excel数据错误",e);
		}
		return list;
	}

	@Override
	public void setCurrentSheetIndex(int index) {
		sheet=workBook.getSheetAt(index);
	}

	@Override
	public List<String> getTypeByRowNumber(int rowNum) {
		List<String> types = new ArrayList<String>();
		Row row=sheet.getRow(rowNum);				
		Short colnum=row.getLastCellNum();			
		for(Short i=0;i<colnum;i++){
			Cell cell=row.getCell(i);
			types.add(getCellType(cell));
		}		
		return types;
	}

	@Override
	public List <String> getRowValues(int rowNum) {
		List<String> values = new ArrayList<String>();
		Row row=sheet.getRow(rowNum);				
		Short colnum=row.getLastCellNum();			
		for(Short i=0;i<colnum;i++){
			Cell cell=row.getCell(i);
			values.add(getCellValue(cell));
		}		
		return values;
	}

	@Override
	public String getCellType(Cell cell) {
		String value = null;
		if(cell==null){
			return POIServiceImpl.BLANK;
		}
		switch (cell.getCellType()) {
			case Cell.CELL_TYPE_STRING:
				value = POIServiceImpl.STRING;
				break;
			case Cell.CELL_TYPE_NUMERIC:
				if (DateUtil.isCellDateFormatted(cell))   		        
			        value = POIServiceImpl.DATE;   
				else // 纯数字   
			    	value = POIServiceImpl.DIGITAL;   
				break;
			case Cell.CELL_TYPE_BLANK:
				value = POIServiceImpl.BLANK;
				break;
			case Cell.CELL_TYPE_FORMULA:
				value = POIServiceImpl.FORMULA;
				break;
			case Cell.CELL_TYPE_BOOLEAN://
				value = POIServiceImpl.BOOLEAN;
				break;
			case Cell.CELL_TYPE_ERROR:
				value = POIServiceImpl.ERROR;
				break;
			default:
				value = POIServiceImpl.OTHER;
				break;
		}
		return value;
	}
	
	@Override
	public String getType() {
		return this.type;
	}
	
	@Override
	public void setDefDateFormat(String dateFormat) {
		this.dateFormat=dateFormat;		
	}
	
	private String getCellValue(Cell cell) {
		String value = null;
		if(cell==null){
			return "";
		}		
		switch (cell.getCellType()) {
			case Cell.CELL_TYPE_STRING://
				value = cell.getRichStringCellValue().getString();
				break;
			case Cell.CELL_TYPE_NUMERIC://
				if (DateUtil.isCellDateFormatted(cell)) {    
				        //  如果是date类型则 ，获取该cell的date值   			    
				        Date date = DateUtil.getJavaDate(cell.getNumericCellValue()); 
				        SimpleDateFormat sdf=new SimpleDateFormat(this.dateFormat);
				        value=sdf.format(date);
				    } else { // 纯数字
				    	Double number=cell.getNumericCellValue();//科学计算法表示的，后面都添加了小数点
				    	String[] temp = String.valueOf(number).split("\\.");
				    	if(temp[1].equals("0")){
				    		value = temp[0];
				    	}else{
				    		value = String.valueOf(number);  
				    	}
				    }
				break;
			case Cell.CELL_TYPE_BLANK:
				value = "";
				break;
			case Cell.CELL_TYPE_FORMULA:
				value = String.valueOf(cell.getCellFormula());
				break;
			case Cell.CELL_TYPE_BOOLEAN://
				value = String.valueOf(cell.getBooleanCellValue());
				break;
			case Cell.CELL_TYPE_ERROR:
				value = String.valueOf(cell.getErrorCellValue());
				break;
			default:
				value = "";
				break;
		}
		return value;
	}

	@Override
	public void setAllowBlank(boolean isAllow) {
		this.isAllowBlankRow=isAllow;		
	}
	
	XSSFSheet export_sheet=null;// 表格
	XSSFCellStyle headStyle=null;//列头单元格样式
	XSSFCellStyle contentStyle=null;//内容单元格样式
	XSSFDrawing patriarch=null;//画图的顶级管理器
	XSSFWorkbook workbook=null;// 工作薄
	int rowCount=0;
	
	public void initService ()
	{		
		sheetCount=0;
		sheetCount++;
		workbook = new XSSFWorkbook();		
		export_sheet = workbook.createSheet("sheet"+sheetCount);	
		headStyle= workbook.createCellStyle();
		headStyle.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
		headStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		headStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		headStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		headStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		headStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		headStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);

		XSSFFont headfont = workbook.createFont();
		headfont.setColor(HSSFColor.VIOLET.index);
		headfont.setFontHeightInPoints((short) 12);
		headfont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		headStyle.setFont(headfont);

		contentStyle = workbook.createCellStyle();
		contentStyle.setFillForegroundColor(HSSFColor.WHITE.index);
		contentStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		contentStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		contentStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		contentStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		contentStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		contentStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		contentStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		XSSFFont contenFont = workbook.createFont();
		contenFont.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
		contentStyle.setFont(contenFont);

		// 创建一个画图的顶级管理器
		patriarch = export_sheet.createDrawingPatriarch();

		XSSFComment comment = patriarch.createCellComment(new XSSFClientAnchor(0,
				0, 0, 0, (short) 4, 2, (short) 6, 5));

		comment.setString(new XSSFRichTextString("可以在POI中添加注释！"));
		comment.setAuthor("leno");
	}
	
	
	@SuppressWarnings("deprecation")
	@Override
	public void exportExcel(Collection<T> dataSet, String[] dataFields,
			OutputStream out, String[] columns, String timePattern) {
		initService();
		int index = 0;
		XSSFFont font = workbook.createFont();
		font.setColor(HSSFColor.BLACK.index);
		XSSFRow row = export_sheet.createRow(0);
		setHeaders(columns, row);
		Iterator<T> it = dataSet.iterator();
		while (it.hasNext()) {
			rowCount++;
			if((rowCount%65536)==0)
			{
				index = 0;
				sheetCount++;
				export_sheet = workbook.createSheet("sheet"+sheetCount);
				XSSFRow row1 = export_sheet.createRow(0);
				setHeaders(columns, row1);
			}			
			index++;
			row = export_sheet.createRow(index);
			T t = (T) it.next();
			for (short i = 0; i < dataFields.length; i++) {
				XSSFCell cell = row.createCell(i);
				cell.setCellStyle(contentStyle);
				Field field = null;
				Class clazz = t.getClass();
				for(;clazz!=Object.class;clazz = clazz.getSuperclass()){
					try {
						field = clazz.getDeclaredField(dataFields[i].trim());
						break;
					} catch (NoSuchFieldException e) {
						
					}
				}
				String fieldName = field.getName();
				String getMethodName = "";
				try {
					Class<? extends Object> tCls = t.getClass();
					Method getMethod = null;
					String type = field.getGenericType().toString();
					/*if (type.equals("class java.lang.Boolean")|| type.equals("boolean"))
					{ 
						getMethodName = "is" + getMethodName(fieldName);
					} else {*/
					getMethodName = getMethodName(fieldName);
					//}
					
					try {
						getMethod = tCls.getMethod("is" + getMethodName, new Class[] {});
					} catch (Exception e) {
						getMethod = tCls.getMethod("get" + getMethodName, new Class[] {});
					}
					Object value = getMethod.invoke(t, new Object[] {});
					String textValue = null;
					if (value instanceof Boolean) {
						boolean bValue = (Boolean) value;
						/*textValue = "是";
						if (!bValue) {
							textValue = "否";
						}*/
						textValue = "1";
						if (!bValue) {
							textValue = "0";
						}
					} else if (value instanceof Date) {
						Date date = (Date) value;
						SimpleDateFormat sdf = new SimpleDateFormat(timePattern);
						textValue = sdf.format(date);
					} else if (value instanceof byte[]) {
						row.setHeightInPoints(60);
						export_sheet.setColumnWidth(i, (short) (35.7 * 80));
						byte[] bsValue = (byte[]) value;
						HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0,
								1023, 255, (short) 6, index, (short) 6, index);
						anchor.setAnchorType(2);
						patriarch.createPicture(anchor, workbook.addPicture(
								bsValue, HSSFWorkbook.PICTURE_TYPE_JPEG));
					} else {
						if(value==null)
							textValue="";
						else
							textValue = value.toString();
					}
					if (textValue != null) {
						Pattern p = Pattern.compile("^//d+(//.//d+)?{1}quot");
						Matcher matcher = p.matcher(textValue);
						if (matcher.matches()) {
							cell.setCellValue(Double.parseDouble(textValue));
						} else {
							XSSFRichTextString richString = new XSSFRichTextString(
									textValue);							
							richString.applyFont(font);
							cell.setCellValue(richString);
						}
					}
				} catch (SecurityException e) {
					e.printStackTrace();
				} catch (NoSuchMethodException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				} 
			}
		}
		try {
			workbook.write(out);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				workbook.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	@SuppressWarnings("deprecation")
	@Override
	public InputStream exportExcelInputStream(Collection<T> dataSet, String[] dataFields,
			String[] columns, String timePattern) {
		initService();
		int index = 0;
		XSSFFont font = workbook.createFont();
		font.setColor(HSSFColor.BLACK.index);
		XSSFRow row = export_sheet.createRow(0);
		setHeaders(columns, row);
		Iterator<T> it = dataSet.iterator();
		while (it.hasNext()) {
			rowCount++;
			if((rowCount%65536)==0)
			{
				index = 0;
				sheetCount++;
				export_sheet = workbook.createSheet("sheet"+sheetCount);
				XSSFRow row1 = export_sheet.createRow(0);
				setHeaders(columns, row1);
			}			
			index++;
			row = export_sheet.createRow(index);
			T t = (T) it.next();
			for (short i = 0; i < dataFields.length; i++) {
				XSSFCell cell = row.createCell(i);
				cell.setCellStyle(contentStyle);
				Field field = null;
				Class clazz = t.getClass();
				for(;clazz!=Object.class;clazz = t.getClass().getSuperclass()){
					try {
						field = clazz.getDeclaredField(dataFields[i].trim());
						break;
					} catch (NoSuchFieldException e) {
						
					}
				}
				String fieldName = field.getName();
				String getMethodName = "";
				try {
					Class<? extends Object> tCls = t.getClass();
					Method getMethod = null;
					String type = field.getGenericType().toString();
					/*if (type.equals("class java.lang.Boolean")|| type.equals("boolean"))
					{ 
						getMethodName = "is" + getMethodName(fieldName);
					} else {*/
					getMethodName = getMethodName(fieldName);
					//}
					
					try {
						getMethod = tCls.getMethod("is" + getMethodName, new Class[] {});
					} catch (Exception e) {
						getMethod = tCls.getMethod("get" + getMethodName, new Class[] {});
					}
					Object value = getMethod.invoke(t, new Object[] {});
					String textValue = null;
					if (value instanceof Boolean) {
						boolean bValue = (Boolean) value;
						/*textValue = "是";
						if (!bValue) {
							textValue = "否";
						}*/
						textValue = "1";
						if (!bValue) {
							textValue = "0";
						}
					} else if (value instanceof Date) {
						Date date = (Date) value;
						SimpleDateFormat sdf = new SimpleDateFormat(timePattern);
						textValue = sdf.format(date);
					} else if (value instanceof byte[]) {
						row.setHeightInPoints(60);
						export_sheet.setColumnWidth(i, (short) (35.7 * 80));
						byte[] bsValue = (byte[]) value;
						HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0,
								1023, 255, (short) 6, index, (short) 6, index);
						anchor.setAnchorType(2);
						patriarch.createPicture(anchor, workbook.addPicture(
								bsValue, HSSFWorkbook.PICTURE_TYPE_JPEG));
					} else {
						if(value==null)
							textValue="";
						else
							textValue = value.toString();
					}
					if (textValue != null) {
						Pattern p = Pattern.compile("^//d+(//.//d+)?{1}quot");
						Matcher matcher = p.matcher(textValue);
						if (matcher.matches()) {
							cell.setCellValue(Double.parseDouble(textValue));
						} else {
							XSSFRichTextString richString = new XSSFRichTextString(
									textValue);							
							richString.applyFont(font);
							cell.setCellValue(richString);
						}
					}
				} catch (SecurityException e) {
					e.printStackTrace();
				} catch (NoSuchMethodException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				} 
			}
		}
		ByteArrayOutputStream os = null;
		byte[] content = null;
	    InputStream is = null;
        try {
        	os = new ByteArrayOutputStream();
            workbook.write(os);
            content =  os.toByteArray();
            is = new ByteArrayInputStream(content);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
        	if(os!=null) {
        		try {
					os.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
        	}
        	try {
				workbook.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
        }

        return is;
	}

	private static String getMethodName(String fieldName) {
		byte[] items = fieldName.getBytes();
		items[0] = (byte) ((char) items[0] - 'a' + 'A');
		return new String(items);
	}
	
	/**
	 * 设置列头
	 * @param columns
	 * @param row
	 */
	@SuppressWarnings("deprecation")
	private void setHeaders(String[] columns,XSSFRow row)
	{
		for (short i = 0; i < columns.length; i++) {
			XSSFCell cell = row.createCell(i);
			cell.setCellStyle(headStyle);
			XSSFRichTextString text = new XSSFRichTextString(columns[i]);
			cell.setCellValue(text);
			export_sheet.setColumnWidth(i,(text.length()+2)*256*2);//以一个字符的1/256的宽度作为一个单位3000的话就是11.7左右，舍去小数点就是11个字符的宽度了。
		}
	}
}
