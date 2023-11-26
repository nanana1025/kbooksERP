package kbookERP.custom.common;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class CommonInfo {

	public static SimpleDateFormat DATEFORMAT = new SimpleDateFormat("yyyy-MM-dd");

	public static String[][] CHECKTABLE = {
			{"HOR01", "도서주문예정테이블",},
			{"HOR02", "도서입고예정테이블",},
			{"HRE02", "도서반품예정입력테이블",},
			{"HRE04", "도서반품예정확정테이블",},
			{"HIN02", "매입전표테이블",},
			{"HRE01", "반품전표테이블",},
			{"HSP06", "특판매출전표테이블",},
			{"HSP07", "증정전표테이블",},
			{"HSP09", "납품예정테이블",},
			{"HDP03", "폐기전표테이블",}
			};













	public static String portCategory1 = "5000,5001,5002,5003,5004,5005,5006,5007,5008,5009"; //g-high 1
	public static String portCategory2 = "5010,5011,5012,5013,5014";	//g-high 2
	public static String portCategory3 = "5020,5021,5022,5023,5024,5025";	//대전
	public static String portCategory4 = "5015,5016,5017,5018,5019"; //한신

	public static String[] CODE = {"CPU", "MBD", "MEM", "VGA", "STG", "MON", "PRD", "ODD", "CAS", "ADP", "POW", "KEY", "MOU", "FAN", "CAB", "BAT", "PKG", "AIR", "LIC", "PER", "ETC", "TBL"};

	public static String[] ASWORLDCODE = {"CPU", "M.B", "RAM", "VGA", "STG", "LED", "CAS", "ADP", "POWER" , "HDD", "SSD", "LED", "S.W", "노트북"};

	public static String[] PRINTCODE = {"MBD", "CPU", "MEM", "VGA", "STG", "MON", "PRD", "ODD", "CAS", "ADP", "POW", "KEY", "MOU", "FAN", "CAB", "BAT", "PKG", "AIR", "LIC", "PER", "ETC", "TBL"};

	public static String[] NTBSEQCODE = {"MBD", "CPU", "MEM", "STG", "MON"};

	public static String[] CODEABB = {"CP", "MB", "RM", "VG", "ST", "MT", "CS", "AD", "PW"};

	public static String[] STGCODE = {"SD", "HD"};

	public static String[] CPULAPTOPCHECK = { "FCBGA", "BGA", "RPGA", "478"};

	public static String[] TABLE = {"TN_CPU", "TN_MBD", "TN_MEM", "TN_VGA", "TN_STG", "TN_MON", "TN_PRD","TN_ODD", "TN_CAS", "TN_ADP", "TN_POW", "TN_KEY", "TN_MOU", "TN_FAN", "TN_CAB", "TN_BAT", "TN_PKG", "TN_AIR", "TN_LIC", "TN_PER", "TN_ETC", "TN_TBL"};

	public static List<String> LISTCONSIGNED = new ArrayList<String>(Arrays.asList("PRD","CAS", "ADP", "POW", "KEY", "MOU", "FAN", "CAB", "BAT", "PKG", "AIR", "LIC", "PER", "ETC"));

	public static List<String> LISTCONSIGNEDRESETCOMPONENT = new ArrayList<String>(Arrays.asList("MBD", "CPU", "MEM", "STG", "MON", "VGA", "ODD", "ADP", "BAT"));

	public static List<String> LISTMEMMANUFACTURERFILTER = new ArrayList<String>(Arrays.asList("Technology", "Memory", "Micosystems Ltd.", "Corporation", "Semiconductor", "Corp.", "Intl. Corp.", "CORP.", "Co., Ltd", "Group Inc.", "Information" ));

	public static List<String> LISTCPUFILTER = new ArrayList<String>(Arrays.asList("Intel", "AMD", "Core 2 Duo", "Core 2 Quad", "Core", "Pentium", "Mobile", "Celeron", "Xeon", "Ryzen", "Atom", "Athlon" ));

//	public static List<Integer> LISTPORTCATEGORY1 = Util.getListInt(portCategory1);
//	public static List<Integer> LISTPORTCATEGORY2 = Util.getListInt(portCategory2);
//	public static List<Integer> LISTPORTCATEGORY3= Util.getListInt(portCategory3);
//	public static List<Integer> LISTPORTCATEGORY4= Util.getListInt(portCategory4);

	public static String[] PRICECUSTOMTABLE = {"TN_CUSTOM_LT_PURCHASE_PRICE"
			, "TN_CUSTOM_DANAWA_PURCHASE_PRICE"
			, "TN_CUSTOM_LT_DEALER_PURCHASE_PRICE"
			, "TN_CUSTOM_LT_DEALER_SALE_PRICE"
			, "TN_CUSTOM_LT_EXPORT_SALE_PRICE"
			, "TN_CUSTOM_LT_SALE_PRICE"
			, "TN_CUSTOM_PH_SALE_PRICE"
			, "TN_CUSTOM_OTHER1_SALE_PRICE"
			, "TN_CUSTOM_OTHER2_SALE_PRICE"
			, "TN_CUSTOM_OTHER3_SALE_PRICE"
			};

	public static String[] PRICELTKEY = {"CUSTOM_LT_PURCHASE_PRICE_ID"
			, "CUSTOM_DANAWA_PURCHASE_PRICE_ID"
			, "CUSTOM_LT_DEALER_PURCHASE_PRICE_ID"
			, "CUSTOM_LT_DEALER_SALE_PRICE_ID"
			, "CUSTOM_LT_EXPORT_PRICE_ID"
			, "CUSTOM_LT_SALE_PRICE_ID"
			, "CUSTOM_PH_SALE_PRICE_ID"
			, "CUSTOM_OTHER1_SALE_PRICE_ID"
			, "CUSTOM_OTHER2_SALE_PRICE_ID"
			, "CUSTOM_OTHER3_SALE_PRICE_ID"
			};

	public static String[] PRICELTTABLEKEY = {"custom_lt_purchase_price"
			, "custom_danawa_purchase_price"
			, "custom_lt_dealer_purchase_price"
			, "custom_lt_dealer_sale_price"
			, "custom_lt_export_price"
			, "custom_lt_sale_price"
			, "custom_ph_sale_price"
			, "custom_other1_sale_price"
			, "custom_other2_sale_price"
			, "custom_other3_sale_price"
			};

	public static String[] PRICECOMPONENTTABLE = {"TN_COMPONENT_LT_PURCHASE_PRICE"
			, "TN_COMPONENT_DANAWA_PURCHASE_PRICE"
			, "TN_COMPONENT_LT_DEALER_PURCHASE_PRICE"
			, "TN_COMPONENT_LT_DEALER_SALE_PRICE"
			, "TN_COMPONENT_LT_EXPORT_SALE_PRICE"
			, "TN_COMPONENT_LT_SALE_PRICE"
			, "TN_COMPONENT_PH_SALE_PRICE"
			, "TN_COMPONENT_OTHER1_SALE_PRICE"
			, "TN_COMPONENT_OTHER2_SALE_PRICE"
			, "TN_COMPONENT_OTHER3_SALE_PRICE"
			};

	public static String[] PRICECOMPONENTKEY = {"COMPONENT_LT_PURCHASE_PRICE_ID"
			, "COMPONENT_DANAWA_PURCHASE_PRICE_ID"
			, "COMPONENT_LT_DEALER_PURCHASE_PRICE_ID"
			, "COMPONENT_LT_DEALER_SALE_PRICE_ID"
			, "COMPONENT_LT_EXPORT_PRICE_ID"
			, "COMPONENT_LT_SALE_PRICE_ID"
			, "COMPONENT_PH_SALE_PRICE_ID"
			, "COMPONENT_OTHER1_SALE_PRICE_ID"
			, "COMPONENT_OTHER2_SALE_PRICE_ID"
			, "COMPONENT_OTHER3_SALE_PRICE_ID"
			};

	public static String[] PRICECOMPONENTTABLETKEY = {"component_lt_purchase_price"
			, "component_danawa_purchase_price"
			, "component_lt_dealer_purchase_price"
			, "component_lt_dealer_sale_price"
			, "component_lt_export_price"
			, "component_lt_sale_price"
			, "component_ph_sale_price"
			, "component_other1_sale_price"
			, "component_other2_sale_price"
			, "component_other3_sale_price"
			};

	public static String[][] COL = {
		/*CPU*/	{"MANUFACTURE_NM", "CORE_CNT", "THREAD_CNT", "MODEL_NM", "CODE_NM", "SPEC_NM", "SOCKET_NM", "PC_TYPE"},
		/*MBD*/	{"MANUFACTURE_NM", "MODEL_NM", "NB_NM", "SB_NM", "MEM_TYPE", "MAX_MEM", "NO_OF_DIMM", "SKU_NM", "FAMILY_NM", "SERIAL_NO", "CODE_NM", "MBD_MODEL_NM", "PRODUCT_NAME", "REVISION", "SYSTEM_VERSION", "BIOS_VENDOR", "BIOS_VERSION", "BIOS_DATE", "UUID", "CHASSIS_MANUFACTURER", "CHASSIS_SN", "PROCESSOR_SOCKET", "MBD_SN", "SYSTEM_SN", "PC_TYPE", "MAC_ADDRESS"},
		/*MEM*/	{"MEM_TYPE", "MODULE_NM", "MANUFACTURE_NM", "CAPACITY", "CAPACITY_M", "BANDWIDTH", "VOLTAGE", "MODEL_NM", "MANUFACTURE_DT", "SERIAL_NO", "PC_TYPE"},
		/*VGA*/	{"MODEL_NM", "MANUFACTURE_NM", "REVISION", "CODE_NM", "CODE_FAMILY_NM", "MEM_TYPE", "CAPACITY", "BANDWIDTH", "TECH_NM", "VENDOR_NM", "SERIAL_NO", "PROCESS", "EX_TYPE", "PC_TYPE"},
		/*STG*/	{"MANUFACTURE_NM", "MODEL_NM", "REVISION", "CAPACITY", "CAPACITY_M", "STG_TYPE", "BUS_TYPE",  "SPEED", "FEATURE", "SERIAL_NO", "PC_TYPE"},
		/*MON*/	{"MANUFACTURE_NM", "MODEL_NM", "MODEL_ID", "MANUFACTURED_DT", "MON_TYPE", "SIZE", "RESOLUTION", "SERIAL_NO", "DEVICE_NAME", "GAMMA", "MAX_PIXEL", "WIDTH", "HEIGHT", "PC_TYPE"},
		/*PRD*/	{"MANUFACTURE_NM", "MODEL_NM", "SPEC_NM"},
		/*ODD*/	{"MANUFACTURE_NM", "MODEL_NM", "TYPE"},
		/*CAS*/	{"MANUFACTURE_NM", "MODEL_NM", "CASE_CAT","CASE_TYPE"},
		/*ADP*/	{"MANUFACTURE_NM", "MODEL_NM", "ADP_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT", "OUTPUT_TYPE", "ADP_CLASS","OUTPUT_WATT2", "ADP_JACK_SIZE"},
		/*POW*/	{"MANUFACTURE_NM", "MODEL_NM", "POW_CAT", "POW_TYPE", "OUTPUT_WATT", "POW_CLASS"},
		/*KEY*/	{"MANUFACTURE_NM", "MODEL_NM", "KEY_CAT", "KEY_TYPE", "KEY_CLASS"},
		/*MOU*/	{"MANUFACTURE_NM", "MODEL_NM", "MOU_CAT", "MOU_TYPE"},
		/*FAN*/	{"MANUFACTURE_NM", "MODEL_NM", "FAN_CAT", "FAN_TYPE"},
		/*CAB*/	{"MANUFACTURE_NM", "MODEL_NM", "CAB_CAT", "CAB_TYPE", "CAB_CLASS"},
		/*BAT*/	{"MANUFACTURE_NM", "MODEL_NM", "PRODUCT_MODEL_NM", "BAT_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT"},
		/*PKG*/ 	{"MANUFACTURE_NM", "MODEL_NM", "PACKAGE_TYPE", "CATEGORY", "SIZE"},
		/*AIR*/ 	{"MANUFACTURE_NM", "MODEL_NM", "TYPE", "CATEGORY", "SIZE"},
		/*LIC*/ 	{"MANUFACTURE_NM", "MODEL_NM", "PART_NAME", "TYPE", "ETC"},
		/*PER*/ 	{"MANUFACTURE_NM", "MODEL_NM", "PART_NAME", "TYPE", "ETC"},
		/*ETC*/ 	{"MANUFACTURE_NM", "MODEL_NM", "PRODUCT_MANUFACTURE_NM", "PRODUCT_MODEL_NM", "TYPE", "ETC"},
		/*TBL*/ 	{"MANUFACTURE_NM", "PRODUCT_NM", "MODEL_NM", "CAPACITY", "RESOLUTION","DISPLAY_SIZE", "SERIAL_NO"}
		};

	public static List<String> LISTEXCEPTCOL = new ArrayList<String>(Arrays.asList("SERIAL_NO", "MBD_SN", "SYSTEM_SN"));

	public static String[][] CHECK = {
			/*CPU*/	{"MODEL_NM", "SPEC_NM"},
			/*MBD*/	{"MODEL_NM", "SB_NM"},
			/*MEM*/	{"CAPACITY", "MODULE_NM","MODEL_NM"},
			/*VGA*/	{"MODEL_NM", "MANUFACTURE_NM"},
			/*STG*/	{"MODEL_NM", "CAPACITY"},
			/*MON*/	{"MODEL_ID", "SIZE"},
			/*PRD*/	{"MODEL_NM", "SPEC_NM"},
			/*ODD*/	{"MODEL_NM", "TYPE"},
			/*CAS*/	{"MODEL_NM","CASE_CAT","CASE_TYPE"},
			/*ADP*/	{"MODEL_NM", "ADP_CAT", "OUTPUT_WATT", "OUTPUT_AMPERE"},
			/*POW*/	{"MODEL_NM", "POW_CAT", "POW_TYPE", "POW_CLASS"},
			/*KEY*/	{"MODEL_NM", "KEY_CAT", "KEY_TYPE", "KEY_CLASS"},
			/*MOU*/	{"MODEL_NM", "MOU_CAT", "MOU_TYPE"},
			/*FAN*/	{"MODEL_NM", "FAN_CAT", "FAN_TYPE"},
			/*CAB*/	{"MODEL_NM", "CAB_CAT", "CAB_TYPE", "CAB_CLASS"},
			/*BAT*/	{"MODEL_NM", "BAT_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT"},
			/*PKG*/ 	{"MODEL_NM", "PACKAGE_TYPE", "CATEGORY", "SIZE"},
			/*AIR*/ 	{"MODEL_NM", "TYPE", "CATEGORY", "SIZE"},
			/*LIC*/		{"MODEL_NM", "TYPE"},
			/*PER*/	{"MODEL_NM", "TYPE"},
			/*PER*/	{"MODEL_NM", "PRODUCT_MODEL_NM", "TYPE"},
			/*TBL*/	{"MODEL_NM"},
			};

	public static String[][] SELECT_COL = {
			/*CPU*/	{"MANUFACTURE_NM",  "MODEL_NM",  "SPEC_NM"},
			/*MBD*/	{"MANUFACTURE_NM", "MBD_MODEL_NM", "PRODUCT_NAME", "MEM_TYPE" },
			/*MEM*/	{"MANUFACTURE_NM", "MODEL_NM", "BANDWIDTH",  "CAPACITY"},
			/*VGA*/	{"MANUFACTURE_NM", "MODEL_NM", "CAPACITY"},
			/*STG*/	{"MANUFACTURE_NM", "MODEL_NM", "CAPACITY"},
			/*MON*/	{"MANUFACTURE_NM", "MODEL_NM", "SIZE"},
			/*PRD*/	{"MANUFACTURE_NM", "MODEL_NM", "SPEC_NM"},
			/*ODD*/	{"MANUFACTURE_NM", "MODEL_NM", "TYPE"},
			/*CAS*/	{"MANUFACTURE_NM", "MODEL_NM", "CASE_CAT","CASE_TYPE"},
			/*ADP*/	{"MANUFACTURE_NM", "MODEL_NM", "ADP_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT"},
			/*POW*/	{"MANUFACTURE_NM", "MODEL_NM", "POW_CAT", "POW_TYPE", "POW_CLASS"},
			/*KEY*/	{"MANUFACTURE_NM", "MODEL_NM", "KEY_CAT", "KEY_TYPE", "KEY_CLASS"},
			/*MOU*/	{"MANUFACTURE_NM", "MODEL_NM", "MOU_CAT", "MOU_TYPE"},
			/*FAN*/	{"MANUFACTURE_NM", "MODEL_NM", "FAN_CAT", "FAN_TYPE"},
			/*CAB*/	{"MANUFACTURE_NM", "MODEL_NM", "CAB_CAT", "CAB_TYPE", "CAB_CLASS"},
			/*BAT*/	{"MANUFACTURE_NM", "MODEL_NM", "BAT_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT"},
			/*PKG*/ 	{"MANUFACTURE_NM", "MODEL_NM","PACKAGE_TYPE", "CATEGORY", "SIZE"},
			/*AIR*/ 	{"MANUFACTURE_NM", "MODEL_NM", "TYPE", "CATEGORY", "SIZE"},
			/*LIC*/ 	{"MANUFACTURE_NM", "MODEL_NM", "TYPE"},
			/*PER*/ 	{"MANUFACTURE_NM", "MODEL_NM", "TYPE"},
			/*ETC*/ 	{"MANUFACTURE_NM", "MODEL_NM", "PRODUCT_MODEL_NM", "TYPE"},
			/*TBL*/ 	{"MANUFACTURE_NM", "PRODUCT_NM", "MODEL_NM"}
			};

	public static String[][] MODEL_COL = {
			/*CPU*/	{"SPEC_NM"},
			/*MBD*/	{"MANUFACTURE_NM", "MODEL_NM", "SB_NM"},
			/*MEM*/	{"MANUFACTURE_NM", "MODULE_NM", "BANDWIDTH",  "CAPACITY"},
			/*VGA*/	{"MANUFACTURE_NM", "MODEL_NM", "CAPACITY"},
			/*STG*/	{"MODEL_NM", "STG_TYPE", "CAPACITY_M"},
			/*MON*/	{"MANUFACTURE_NM", "MODEL_ID", "SIZE"},
			/*PRD*/	{"MANUFACTURE_NM", "MODEL_NM", "SPEC_NM"},
			/*ODD*/	{"MANUFACTURE_NM", "MODEL_NM", "TYPE"},
			/*CAS*/	{"MANUFACTURE_NM", "MODEL_NM", "CASE_CAT","CASE_TYPE"},
			/*ADP*/	{"MANUFACTURE_NM", "MODEL_NM", "ADP_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT"},
			/*POW*/	{"MANUFACTURE_NM", "MODEL_NM", "POW_CAT", "POW_TYPE", "POW_CLASS"},
			/*KEY*/	{"MANUFACTURE_NM", "MODEL_NM", "KEY_CAT", "KEY_TYPE", "KEY_CLASS"},
			/*MOU*/	{"MANUFACTURE_NM", "MODEL_NM", "MOU_CAT", "MOU_TYPE"},
			/*FAN*/	{"MANUFACTURE_NM", "MODEL_NM", "FAN_CAT", "FAN_TYPE"},
			/*CAB*/	{"MANUFACTURE_NM", "MODEL_NM", "CAB_CAT", "CAB_TYPE", "CAB_CLASS"},
			/*BAT*/	{"MANUFACTURE_NM", "MODEL_NM", "BAT_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT"},
			/*PKG*/ 	{"MANUFACTURE_NM", "MODEL_NM","PACKAGE_TYPE", "CATEGORY", "SIZE"},
			/*AIR*/ 	{"MANUFACTURE_NM", "MODEL_NM", "TYPE", "CATEGORY", "SIZE"},
			/*LIC*/ 	{"MANUFACTURE_NM", "MODEL_NM", "TYPE"},
			/*PER*/ 	{"MANUFACTURE_NM", "MODEL_NM", "TYPE"},
			/*ETC*/ 	{"MANUFACTURE_NM", "MODEL_NM", "PRODUCT_MODEL_NM", "TYPE"},
			/*TBL*/ 	{"MANUFACTURE_NM", "PRODUCT_NM", "MODEL_NM"}
			};

	public static String[][] MODEL_MAPPING_COL = {
			/*CPU*/		{"MANUFACTURE_NM", "MODEL_NM", "SOCKET_NM", "CODE_NM"},
			/*MBD*/		{"MANUFACTURE_NM", "MODEL_NM", "PRODUCT_NAME", "SB_NM"},
			/*MEM*/	{"MANUFACTURE_NM", "BANDWIDTH", "CAPACITY", "VOLTAGE"},
			/*VGA*/		{"MANUFACTURE_NM", "MODEL_NM", "CAPACITY", "MEM_TYPE"},
			/*STG*/		{"MODEL_NM", "STG_TYPE", "CAPACITY_M", "BUS_TYPE"},
			/*MON*/	{"MANUFACTURE_NM", "MODEL_NM", "SIZE", "RESOLUTION"},
			/*PRD*/		{"MANUFACTURE_NM", "MODEL_NM", "SPEC_NM"},
			/*ODD*/		{"MANUFACTURE_NM", "MODEL_NM", "TYPE"},
			/*CAS*/		{"MANUFACTURE_NM", "MODEL_NM", "CASE_CAT","CASE_TYPE"},
			/*ADP*/		{"MANUFACTURE_NM", "MODEL_NM", "ADP_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT"},
			/*POW*/	{"MANUFACTURE_NM", "MODEL_NM", "POW_CAT", "POW_TYPE", "POW_CLASS"},
			/*KEY*/		{"MANUFACTURE_NM", "MODEL_NM", "KEY_CAT", "KEY_TYPE", "KEY_CLASS"},
			/*MOU*/	{"MANUFACTURE_NM", "MODEL_NM", "MOU_CAT", "MOU_TYPE"},
			/*FAN*/		{"MANUFACTURE_NM", "MODEL_NM", "FAN_CAT", "FAN_TYPE"},
			/*CAB*/		{"MANUFACTURE_NM", "MODEL_NM", "CAB_CAT", "CAB_TYPE", "CAB_CLASS"},
			/*BAT*/		{"MANUFACTURE_NM", "MODEL_NM", "BAT_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT"},
			/*PKG*/ 	{"MANUFACTURE_NM", "MODEL_NM","PACKAGE_TYPE", "CATEGORY", "SIZE"},
			/*AIR*/ 		{"MANUFACTURE_NM", "MODEL_NM", "TYPE", "CATEGORY", "SIZE"},
			/*LIC*/ 		{ "TYPE", "MANUFACTURE_NM", "MODEL_NM", "ETC"},
			/*PER*/ 	{ "TYPE", "MANUFACTURE_NM", "MODEL_NM", "ETC"},
			/*ETC*/ 	{ "TYPE", "MANUFACTURE_NM", "MODEL_NM", "ETC"},
			/*TBL*/ 		{ "MANUFACTURE_NM", "PRODUCT_NM", "MODEL_NM","CAPACITY"}
			};

	public static String[] NTBCOLNAME = {"case_destroyed","case_scratch","case_stabbed","case_pressed","case_discolored","case_hinge","display","battery","mousepad","keyboard","cam","usb","lan_wireless","lan_wired","hdd","odd","adapter","bios","os"};
	public static String[] NTBCOLNAME2ND = {"case_destroyed","case_scratch","case_stabbed","case_pressed","case_discolored","case_hinge","cooler","case_des","display","usb","mousepad","keyboard","battery","cam","odd","hdd","lan_wireless","lan_wired","bios","os","test_check"};
	public static String[] ALLINONECOLNAME = {"case_destroyed","case_scratch","case_stabbed","case_pressed","case_discolored","menu","etc_des","display","port","adapter","usb","mousepad","keyboard","cam","odd","hdd","lan_wireless","lan_wired","bios","os","test_check"};
	public static String[] MONCOLNAME = {"case_destroyed","case_scratch","case_stabbed","case_pressed","case_discolored","display","port","adapter"};
	public static String[] TABLETCOLNAME2ND = {"case_destroyed","case_scratch","case_stabbed","case_pressed","case_discolored","etc_des","display","battery","button","adapter","usb_port","usb_cable","pen","sd_card","software","cam","sound","ear_phone","mike","lan_wireless","test_check"};

	public static String[] SYMBOL = {"□","■","∨"} ;

	public static int[] BASE = {1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,131072,262144,524288,1048576};
	public static String[] CASE = {"파손", "스크래치", "찍힘", "눌림","변색"} ;
	public static String[] TABLETCASE = {"파손", "스크래치", "찍힘", "변색"} ;

	public static String[][] NTBCHECK = {
			/*케이스 파손~변색*/	{"1", "2", "3", "4"},
			/*액정*/				{"인식안됨", "파손", "스크래치","흰멍","빛샘","화면줄","터치스크린 인식"},
			/*배터리*/			{ "충전 안됨", "40%이하","80%이하","고정락 불량"},
			/*마우스패드*/	{"인식 안됨", "스크래치","좌우버튼 인식 안됨"},
			/*키보드*/			{"인식 안됨", "자판 빠짐 1개","자판 빠짐 2개","자판 빠짐 3개이상"},
			/*CAM*/			{"인식 안됨","없음"},
			/*USB*/				{"인식 안됨","파손"},
			/*LAN무선*/		{"인식 안됨", "없음"},
			/*LAN유선*/		{"인식 안됨", "파손"},
			/*HDD*/				{"인식 안됨", "가이드 없음", "가이드 파손","젠더 없음","젠더 파손"},
			/*ODD*/				{"인식 안됨", "ODD 없음", "ODD 파손","베젤 없음","베젤 파손"},
			/*아답터*/			{"인식 안됨", "없음", "단선"},
			/*BIOS*/			{"CMOS P/W", "CMOS 접근 안됨"},
			/*OS*/				{"전원 안켜짐", "부팅 안됨", "재부팅 현상","사용중 멈춤","화면 깨짐"},
			};

	public static String[][] NTBCHECK2ND = {
			/*0 케이스 파손~변색*/	{"1", "2", "3", "4"},
			/*1액정*/					{"인식안됨", "파손", "스크래치","흰멍","빛샘","화면줄","액정속 이물질","터치스크린 인식","키보드자국"},
			/*2 USB*/				{"인식 안됨","파손"},
			/*3 마우스패드*/		{"인식 안됨", "파손","좌우버튼 인식 안됨"},
			/*4 키보드*/				{"인식 안됨", "자판없음","자판 빠짐 1개","자판 빠짐 2개","자판 빠짐 3개이상"},
			/*5 배터리*/				{ "배터리없음","충전 안됨", "노화","파손","정상"},
			/*6 CAM*/				{"인식 안됨","파손","없음"},
			/*7 ODD*/				{"인식 안됨", "ODD 없음", "ODD 파손","베젤 없음","베젤 파손","멀티부스트"},
			/*8 HDD*/				{"인식 안됨", "가이드 없음", "가이드 파손","젠더 없음","젠더 파손","불량","정상"},
			/*9 LAN무선*/			{"인식 안됨", "없음"},
			/*10 LAN유선*/			{"인식 안됨", "파손"},
			/*11 BIOS*/				{"CMOS P/W", "CMOS 접근 안됨"},
			/*12 OS*/					{"윈도우 진입 불가"},
			/*13 검수*/				{"전원 안 켜짐", "사용중 멈춤","화면 안나옴","액정파손"},
			};

	public static String[][]  ALLINONECHECK = {
			/*케이스 파손~변색*/	{"전면", "후면", "받침"},
			/*1액정*/					{"인식안됨", "파손", "스크래치","흰멍","빛샘","화면줄","액정속 이물질","터치스크린 인식","키보드자국"},
			/*2 포트*/					{"RGB 인식 안됨","DVI 인식 안됨","HDMI 인식 안됨", "DP 인식 안됨"},
			/*3 아답터*/				{"인식 안됨", "없음", "단선"},
			/*4 USB*/				{"인식 안됨","파손"},
			/*5 마우스패드*/		{"인식 안됨", "파손","좌우버튼 인식 안됨"},
			/*6 키보드*/				{"인식 안됨", "자판없음","자판 빠짐 1개","자판 빠짐 2개","자판 빠짐 3개이상"},
			/*7 CAM*/				{"인식 안됨","파손","없음"},
			/*8 ODD*/				{"인식 안됨", "ODD 없음", "ODD 파손","베젤 없음","베젤 파손","멀티부스트"},
			/*9 HDD*/				{"인식 안됨", "가이드 없음", "가이드 파손","젠더 없음","젠더 파손"},
			/*10 LAN무선*/			{"인식 안됨", "없음"},
			/*11 LAN유선*/			{"인식 안됨", "파손"},
			/*12 BIOS*/				{"CMOS P/W", "CMOS 접근 안됨"},
			/*13 OS*/					{"윈도우 진입 불가"},
			/*14 검수*/				{"전원 안 켜짐", "사용중 멈춤","화면 안나옴","액정파손"},
			};

	public static String[][] TABLETCHECK = {
			/*0 자가진단*/			{"진동불량", "터치불량","펜 터치불량"},
			/*1 검수*/					{"전원 안 켜짐", "작동중 멈춤","화면 출력불가","구글락걸림", "액정파손"},
			/*2 케이스 파손~변색*/	{"1", "2"},
			/*3 액정*/					{"스크래치", "흰멍", "빛샘","화면줄","액정속 이물질","백라이트불량","파손", "기포"},
			/*4 배터리*/				{"충전 안됨", "부품"},
			/*5 버튼*/					{"전원버튼 불량", "볼륨버튼 불량", "홈버튼 불량"},
			/*6 USB_포트*/		{"인식안됨","파손"},
			/*7 PEN*/					{"버튼불량", "파손","없음"},
			/*8 SD 카드*/			{"파손","없음"},
			/*9 CAM*/				{"인식안됨[전면]","인식안됨[후면]","파손[전면]","파손[후면]"},
			/*10 SOUND*/			{"출력안됨", "출력이상"}

		};

//	public static String[][] TABLETCHECK = {
//			/*0 케이스 파손~변색*/	{"1", "2"},
//			/*1액정*/					{"스크래치", "흰멍", "빛샘","화면줄","액정속 이물질","터치스크린 인식","백화", "미세먼지"},
//			/*2 배터리*/				{"충전 안됨", "노화"},
//			/*3 어댑터*/				{"인식안됨", "없음"},
//			/*4 버튼*/					{"전원버튼 불량", "볼륨버튼 불량", "홈버튼 불량"},
//			/*5 USB_포트*/		{"인식안됨","파손","없음"},
//			/*6 USB_케이블*/		{"인식안됨","없음"},
//			/*7 PEN*/					{"해당없음", "파손","없음"},
//			/*8 SD 카드*/			{"인식안됨", "파손","없음"},
//			/*9 소프트웨어*/		{"계정초기화 안됨", "DISPLAY설정안됨","사운드 및 진동 설정 안됨"},
//			/*10 CAM*/				{"인식안됨[전면]","인식안됨[후면]","파손[전면]","파손[후면]"},
//			/*11 SOUND*/			{"출력안됨", "파손"},
//			/*12 이어폰*/			{"출력안됨", "파손", "없음"},
//			/*13 마이크*/			{"인식 안됨"},
//			/*14 LAN무선*/			{"인식 안됨"},
//			/*15 검수*/				{"전원 안 켜짐", "사용중 멈춤","화면 안나옴","액정파손"},
//			/*16 자가진단*/		{"RED", "GREEN","BLUE","DIMMING","MEGA CAM","SENSOR","TOUCH","SLEEP","SPEAKER(L)","SPEAKER(R)","SUB KEY","FRONT CAM","HALL IC","GRIP SENSOR","BLACK"}
//		};

	public static String[][] MONCHECK= {
			/*케이스 파손~변색*/	{"전면", "후면", "받침"},
			/*액정*/	{"인식안됨", "파손", "스크래치","흰멍","빛샘","화면줄","액정속 이물질", "불량화소","터치스크린 인식","검은멍"},
			/*포트*/	{"RGB 인식 안됨","DVI 인식 안됨","HDMI 인식 안됨", "DP 인식 안됨"},
			/*아답터*/	{"인식 안됨", "없음", "단선"}
			};


	//0 CPU, 1 MBD, 2 MEM, 3 VGA, 4 STG, 5 MON, 6 CAS, 7 ADP, 8 POW, 9 KEY, 10 MOU, 11 FAN, 12 CAB, 13 BAT, 14 ODD

	public static String[][] INVENTORYCHECK = {
			/*CPU*/	{"PIN 휨", "PCB 파손"},
			/*MBD*/	{"MAIN PCB 파손", "CPU PIN 휨", "RAM 슬롯 인식X","RAM 슬롯 파손","VGA 슬롯 인식X","VGA 슬롯 파손","SATA 인식X","SATA 파손","M.2/mSATA 인식X","M.2/mSATA 파손","USB 인식X","USB 파손","LAN 인식X","LAN 파손","사운드 인식X","사운드 파손"},
			/*MEM*/{"PCB 파손"},
			/*VGA*/	{"MAIN PCB 파손", "FAN 파손", "FAN  소음","RGB 인식 안됨","DVI 인식 안됨","HDMI 인식 안됨","DP 인식 안됨"},
			/*STG*/	{"MAIN PCB 파손", "배드 섹터 주의", "배드 섹터 위험", "디스크 소음"},
			/*MON*/{"별도 관리"},
			/*CAS*/	{"전면", "후면", "좌", "우"},
			/*ADP*/{"1"},
			/*POW*/{"PG 오류","FAN 소음"},
			/*KEY*/{"1"},
			/*MOU*/{"1"},
			/*FAN*/{"1"},
			/*CAB*/{"1"},
			/*BAT*/{"1"},
			/*ODD*/{"인식 안됨", "CD 읽기 안됨", "DOOR 불량"}
			};

	public static String[][] STGCHECK = {
			/*HDD*/	{"MAIN PCB 파손", "배드 섹터 주의", "배드 섹터 위험", "디스크 소음"},
			/*SSD*/	{"CRC 오류", "배드 섹터 주의", "배드 섹터 위험", "디스크 소음"}
			};

	public static String[] CONSIGNED_PART_COL = {
			/*CPU*/ "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.SPEC_NM, '') )",
			/*MBD*/ "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MBD_MODEL_NM, '') ,' / ',IFNULL( A.PRODUCT_NAME, '') ,' / ',IFNULL( A.MEM_TYPE, '') )",
			/*MEM*/ "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.BANDWIDTH, '') ,' / ',IFNULL( A.CAPACITY, '') )",
			/*VGA*/  "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.CAPACITY, '') )",
			/*STG*/  "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.CAPACITY, '') )",
			/*MON*/ "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.SIZE, '') )",
			/*PRD*/ "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.SPEC_NM, '') )",
			/*ODD*/ "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.TYPE, '') )",
			/*CAS*/  "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.CASE_CAT, '') ,' / ',IFNULL( A.CASE_TYPE, ''))",
			/*ADP*/  "A.MODEL_NM",
			/*POW*/ "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.POW_CAT, '') ,' / ',IFNULL( A.POW_TYPE, '') ,' / ',IFNULL( A.POW_CLASS, '') )",
			/*KEY*/  "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.KEY_CAT, '') ,' / ',IFNULL( A.KEY_TYPE, '') ,' / ',IFNULL( A.KEY_CLASS, '') )",
			/*MOU*/ "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.MOU_CAT, '') ,' / ',IFNULL( A.MOU_TYPE, '') )",
			/*FAN*/  "(SELECT MANUFACTURE_NM FROM TN_FAN C WHERE A.DATA_ID = B.DATA_ID)",
			/*CAB*/  "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.CAB_CAT, '') ,' / ',IFNULL( A.CAB_TYPE, '') ,' / ',IFNULL( A.CAB_CLASS, '') )",
			/*BAT*/  "A.MODEL_NM",
			/*PKG*/  "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.PACKAGE_TYPE, '') ,' / ',IFNULL( A.CATEGORY, '') ,' / ',IFNULL( A.SIZE, '') )",
			/*AIR*/   "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.TYPE, '') ,' / ',IFNULL( A.CATEGORY, '') ,' / ',IFNULL( A.SIZE, '') )",
			/*LIC*/   "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.TYPE, '') )",
			/*PER*/  "CONCAT(IFNULL( A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.TYPE, '') )",
			/*ETC*/   "CONCAT(IFNULL( IFNULL( A.TYPE, ''),' / ',A.MANUFACTURE_NM, '') ,' / ',IFNULL( A.MODEL_NM, '') ,' / ',IFNULL( A.PRODUCT_MODEL_NM, '') )"
			};
}

