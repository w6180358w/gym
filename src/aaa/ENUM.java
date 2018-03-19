package aaa;

public enum ENUM{
	test(0,"b");
	
	private int str;
	private String str1;
	
	ENUM(int str,String str1){
		this.str = str;
		this.str1 = str1;
	}

	public int getStr() {
		return str;
	}

	public String getStr1() {
		return str1;
	}
	
}
