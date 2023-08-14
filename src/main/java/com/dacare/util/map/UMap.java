package com.dacare.util.map;

import java.lang.reflect.InvocationTargetException;
import java.security.InvalidParameterException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.apache.commons.lang3.math.NumberUtils;

import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * <pre>
 *  Class Name : UMap.java => UnionMap
 *  Description : 웹에서 request의 파라미터를 간편하게 사용할 수 있는 Map 클래스
 *                LinkedHashMap<String, Object>을 상속받았음 => FIFO 보장
 *  dependence : commons-lang-2.6.jar; commons-beanutils.jar;
 *  Modification Information
 *
 *     수정일     수정자                   수정내용
 *   -------        --------    ---------------------------
 *
 * </pre>
 *
 *  @author 박현준
 *  @created  2012. 7. 18.
 *  @version 1.0
 *  @see
 *
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UMap extends LinkedHashMap<String, Object> {

	private static final long serialVersionUID = -7197592549459458204L;

	/**
	 * 키값을 모두 대문자로 변환해서 저장합니다.
	 */
	public static final int UPPER_KEY = 1;
	/**
	 * 키값을 모두 소문자로 변환해서 저장합니다.
	 */
	public static final int LOWER_KEY = 2;
	/**
	 * 키값을 원래 대소문자로 저장합니다. 기본값입니다.
	 */
	public static final int NATIVE_KEY = 3;

	private HttpServletRequest request;

	private HttpSession session;

	public UMap(){
		super();
	}

	/**
	 * Map<?, ?> 인스턴스를 UMap에 담습니다.
	 * @param map
	 */
	@SuppressWarnings("unchecked")
	public UMap(Map<?, ?> map) {
		super();
		if (map != null) {
			this.putAll((Map<String, Object>)map);
		}
	}

	/**
	 * bean을 UMap에 담습니다.
	 *
	 * UMap params = new UMap(SessionInfo);
	 *
	 * @param bean
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public UMap(Object bean) throws IllegalAccessException, InvocationTargetException,NoSuchMethodException {
		super();
		if (bean instanceof Map) {
			this.putAll((Map<String, Object>)bean);
		} else if (bean != null) {
			this.putAll(BeanUtils.describe(bean));
		}
	}


	/**
	 * Map 에서 key 값명으로 값을 가져와서 셋팅
	 * @param key
	 * @param m
	 */
	public void putVal(UMap m, String... keys) {
		int len = keys.length;
		for(int i = 0 ; i < len ; i++) {
			this.put(keys[i], m.getStr(keys[i]));
		}
	}

	/**
	 * defaultValue = ""
	 * <pre>
     * (null)         = ""
     * ("")           = ""
     * ("bat")        = "bat"
     * (Boolean.TRUE) = "true"
     * </pre>
     *
	 * @param key
	 * @return
	 */
	public String getStr(String key) {
		return ObjectUtils.toString(this.get(key));
	}

	/**
	 * HTMLTagFilter와 동일한 특수문자 처리를 한다.
	 * .replace("&", "&amp;")
	 * .replace("<", "&lt;")
	 * .replace(">", "&gt;")
	 * .replace("\"", "&quot;")
	 * .replace("'", "&apos;")
	 * @param key
	 * @return
	 */
	public String getEscapeStr(String key) {
		return ObjectUtils.escapeStr(this.get(key));
	}

	/**
	 * HTMLTagFilter에서 처리된 특수문자를 원복한다.
	 * .replace("&amp;", "&")
	 * .replace("&lt;", "<")
	 * .replace("&gt;", ">")
	 * .replace("&quot;", "\"")
	 * .replace("&apos;", "'")
	 * .replace("&#39;", "'")
	 * @param key
	 * @return
	 */
	public String getUnescapeStr(String key) {
		return ObjectUtils.unescapeStr(this.get(key));
	}

	/**
     * <pre>
     * (null, null)           = null
     * (null, "null")         = "null"
     * ("", "null")           = ""
     * ("bat", "null")        = "bat"
     * (Boolean.TRUE, "null") = "true"
     * </pre>
     *
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public String getStr(String key, String defaultValue) {
		return ObjectUtils.toString(this.get(key), defaultValue);
	}

	/**
	 * Object 타입을 String[] 타입으로 변환한다.
	 * 만약 src가 null인 경우 []을 반환한다.
	 *
	 * @param src
	 * @return
	 */
	public String[] getStrArray(String key) {
		Object src = this.get(key);
		String[] dst = new String[0];

		if (src == null) return dst;

		try {
			if (src instanceof String && StringUtils.isNotEmpty(ObjectUtils.toString(src))) {
				dst = new String[1];
				dst[0] = ObjectUtils.toString(src);
			} else {
				dst = (String[])src;
			}
		} catch (IllegalArgumentException e) {
			System.out.println("IGNORED: " + e.getMessage());
		} catch(ClassCastException e){
			System.out.println("IGNORED: " + e.getMessage());
		}
		return dst;
	}

	/**
     * <pre>
     * (null, 1) = 1
     * ("", 1)   = 1
     * ("1", 0)  = 1
     * </pre>
	 *
	 * @param src
	 * @param defaultValue 기본값
	 * @return
	 */
	public int getInt(String key, int defaultValue) {
		return NumberUtils.toInt(this.getStr(key), defaultValue);
	}

	/**
	 * defaultValue = 0
     * <pre>
     * (null) = 0
     * ("")   = 0
     * ("1")  = 1
     * </pre>
     *
	 * @param src
	 * @return
	 */
	public int getInt(String key) {
		return this.getInt(key, 0);
	}

	public int getForcedInt(String key, int defaultValue) {
		return (int)(this.getDouble(key, defaultValue));
	}

	public int getForcedInt(String key) {
		return this.getForcedInt(key, 0);
	}
	/**
	 * <pre>
     * (null, 1.1d)   = 1.1d
     * ("", 1.1d)     = 1.1d
     * ("1.5", 0.0d)  = 1.5d
     * </pre>
     *
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public double getDouble(String key, double defaultValue) {
		return NumberUtils.toDouble(this.getStr(key), defaultValue);
	}

	/**
	 * defaultValue = 0D
	 * <pre>
     * (null)   = 0D
     * ("")     = 0D
     * ("1.5")  = 1.5d
     * </pre>
     *
	 * @param key
	 * @return
	 */
	public double getDouble(String key) {
		return this.getDouble(key, 0D);
	}

	/**
     * <pre>
     * (null, 1L) = 1L
     * ("", 1L)   = 1L
     * ("1", 0L)  = 1L
     * </pre>
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public long getLong(String key, long defaultValue) {
		return NumberUtils.toLong(this.getStr(key), defaultValue);
	}

	/**
	 * defaultValue = 0L
     * <pre>
     * null = 0L
     * ""   = 0L
     * "1"  = 1L
     * </pre>
	 * @param key
	 * @return
	 */
	public long getLong(String key) {
		return this.getLong(key, 0L);
	}

	/**
	 * Object 타입을 int[] 타입으로 변환한다.
	 * 만약 src가 null인 경우 []을 반환한다.
	 *
	 * @param src int, Integer, int[], Integer[], String[]
	 * @return
	 */
	public int[] getIntArray(String key) {
		Object src = this.get(key);
		int[] dst = new int[0];

		if (src == null) return dst;

		try {
			if(src instanceof Integer) {
				dst = new int[1];
				dst[0] = (Integer)src;
			} else if(ArrayUtils.isSameType(src, new int[] {})) {
				dst = (int[])src;
			} else if(ArrayUtils.isSameType(src, new Integer[] {})) {
				dst = ArrayUtils.toPrimitive((Integer[])src);
			} else if(src instanceof String || src instanceof String[]) {
				String[] sSrc = this.getStrArray(key);
				dst = new int[sSrc.length];

				for (int i = 0; i < sSrc.length; i++) {
					dst[i] = NumberUtils.toInt(sSrc[i]);
				}
			}
		} catch (IllegalArgumentException e) {
			System.out.println("IGNORED: " + e.getMessage());
		}catch(ClassCastException e){
			System.out.println("IGNORED: " + e.getMessage());
		}
		return dst;
	}

	/**
     * <pre>
     * null    = false
     * "true"  = true
     * "TRUE"  = true
     * "tRUe"  = true
     * "on"    = true
     * "yes"   = true
     * "false" = false
     * "x gti" = false
     * </pre>
     *
	 * @param src
	 * @return
	 */
	public boolean getBool(String key) {
		return BooleanUtils.toBoolean(this.getStr(key));
	}

	/**
	 * Date 값을 반환하며 값이 없는 경우는 null을 반환한다.
	 * @param key
	 * @return
	 */
	public Date getDate(String key) {
		Object src = this.get(key);
		if (src instanceof Date) {
			return (Date)src;
		} else {
			return null;
		}
	}

	/**
	 * 값이 Date객체인 경우 dateFormat대로 변환된다.
	 * @param key
	 * @return
	 */
	public String getDateStr(String key, String dateFormat) {
		Object src = this.get(key);
		if (src instanceof Date) {
			DateFormat sdf = new SimpleDateFormat(dateFormat);
			return sdf.format(src);
		} else {
			return StringUtils.EMPTY;
		}
	}

	/**
	 * 파라미터에 변수값이 할당 되었는지 확인한다.
	 *
	 * key 값은 여러개를 사용할 수 있으며 여러개의 키 값중에 하나라도 값이 없으면 true를 반환한다.
	 * if (uMap.isEmpty("id", "name", "email", ...)) {
	 * 		log.debug("입력 파라미터가 없습니다.");
	 * }
	 *
	 * <pre>
	 * []		= true;
	 * null		= true;
	 * ""		= true;
	 * "foo"	= false;
	 * 123		= false;
	 * </pre>
	 * @param keys
	 * @return boolean
	 */
	public boolean isEmpty(String... keys)
	{
		for (String key : keys) {
			key = key.trim();

			if (this.get(key) == null) {
				return true;
			/*} else if (this.get(key) instanceof Object[]) { // 배열인 경우
				if (ArrayUtils.isEmpty((Object[])this.get(key))) {
					return true;
				}*/
			} else if (StringUtils.isEmpty(this.getStr(key))) { // 기타는 String으로 체크
				return true;
			}
		}

		return false;
	}

	/**
	 * 파라미터에 변수값이 할당 되었는지 확인하고
	 * 값이 없는 경우 InvalidParameterException 예외를 발생시킵니다.
	 *
	 * key 값은 여러개를 사용할 수 있으며 여러개의 키 값중에 하나라도 값이 없으면 예외를 발생시킵니다.
	 * if (uMap.isEmpty("id", "name", "email", ...)) {
	 * 		log.debug("입력 파라미터가 없습니다.");
	 * }
	 *
	 * <pre>
	 * []		= true;
	 * null		= true;
	 * ""		= true;
	 * "foo"	= false;
	 * 123		= false;
	 * </pre>
	 * @param keys
	 * @return boolean
	 */
	public void ifEmptyThrowException(String... keys)
	{
		if (isEmpty(keys)) {
			throw new InvalidParameterException("[" + StringUtils.join(keys, ", ")
					+ "] 파라미터가 정의되지 않았습니다. " + this.toString());
		}
	}

	/**
	 * 파라미터에 변수값이 할당 되었는지 확인한다.
	 *
	 * key 값은 여러개를 사용할 수 있으며 여러개의 키 값중에 하나라도 값이 있으면 true를 반환한다.
	 * if (uMap.isAllEmpty("id", "name", "email", ...)) {
	 * 		log.debug("입력된 모든 파라미터에 값이 없습니다.");
	 * }
	 *
	 * <pre>
	 * []		= true;
	 * null		= true;
	 * ""		= true;
	 * "foo"	= false;
	 * 123		= false;
	 * </pre>
	 * @param keys
	 * @return boolean
	 */
	public boolean isAllEmpty(String... keys)
	{
		for (String key : keys) {
			key = key.trim();

			if (this.get(key) != null) {
				return false;
			} else if (this.get(key) instanceof Object[]) { // 배열인 경우
				if (!ArrayUtils.isEmpty((Object[])this.get(key))) {
					return false;
				}
			} else if (!StringUtils.isEmpty(this.getStr(key))) { // 기타는 String으로 체크
				return false;
			}
		}

		return true;
	}

	/**
	 * 파라미터에 변수값이 할당 되었는지 확인하고
	 * 값이 모두 없는 경우 InvalidParameterException 예외를 발생시킵니다.
	 *
	 * key 값은 여러개를 사용할 수 있으며 여러개의 키 값중에 모든 값이 없으면 예외를 발생시킵니다.
	 * ifAllEmptyThrowException("id", "name", "email", ...);
	 *
	 * <pre>
	 * []		= true;
	 * null		= true;
	 * ""		= true;
	 * "foo"	= false;
	 * 123		= false;
	 * </pre>
	 * @param keys
	 * @return boolean
	 */
	public void ifAllEmptyThrowException(String... keys)
	{
		if (isAllEmpty(keys)) {
			throw new InvalidParameterException("[" + StringUtils.join(keys, ", ")
					+ "] 파라미터가 모두 정의되지 않았습니다. " + this.toString());
		}
	}

	/**
	 * <pre>
	 * 배열로 담겨있는 파라미터들을 List<UMap> 형태로 변환해서 반환한다.
	 * ex) List<UMap> rowList = uMap.getListMap("OID", "DIC", "TITLE"); => [ { OID: 1, DIC: "test", TITLE: "title" }, { OID: 2, DIC: "test1", TITLE: "title1" } ]
	 * </pre>
	 *
	 * @param keys
	 * @return List<UMap>
	 */
	public List<UMap> getListMap(String... keys) {
		return getListPrefixMapPro("", keys);
	}

	/**
	 * @param prefix 가 붙은 key 값만 sub map 으로 추출
	 *        추출시 key 값은 prefix 제거한 key 값으로 추출
	 * @return
	 */
	public UMap getPrefixMap(String prefix) {
		UMap u = new UMap();
		List<String> keyList = this.toKeyList(prefix);
		for(int i = 0 ; i < keyList.size() ; i++ ) {
			String newKey = keyList.get(i);
			String oldKey = prefix.concat(newKey);
			u.put(newKey, this.getStr(oldKey));
		}
		return u;
	}

	/**
	 * <pre>
	 * 배열로 담겨있는 파라미터들을 List<UMap> 형태로 변환해서 반환한다.
	 * 단 원본의 key 에 prefix 를 제거해서 key를 생성한다.
	 * ex) List<UMap> rowList = uMap.getListPrefixMap("_ORDER_", "OID", "DIC", "TITLE"); => [ { OID: 1, DIC: "test", TITLE: "title" }, { OID: 2, DIC: "test1", TITLE: "title1" } ]
	 * </pre>
	 *
	 * @param keys
	 * @return List<UMap>
	 */
	public List<UMap> getListPrefixMapPro(String prefix, String... keys) {
		List<UMap> list = new ArrayList<UMap>();

		Map<String, String[]> values = new HashMap<String, String[]>();
		for (String newKey : keys) {
			String oldKey = prefix.concat(newKey);
			values.put(newKey, this.getStrArray(oldKey));
		}

		int rowCnt = values.get(keys[0]).length;
		for (int ri = 0; ri < rowCnt; ri++) {
			UMap map = new UMap();

			for (String key : keys) {
				if (values.get(key) == null || values.get(key).length <= ri) { continue; }

				map.put(key,  ObjectUtils.toString(values.get(key)[ri]));
			}

			list.add(map);
		}



		return list;
	}

	/**
	 * @param prefix
	 * @param mainKey
	 * @return
	 * @throws java.lang.ArrayIndexOutOfBoundsException mainKey가 잘못 지정될 경우 발생할 수 있음, prefix 및 mainKey 를 확인
	 */
	public List<UMap> getListPrefixMap(String prefix, String mainKey) {
		List<String> keyList = toKeyList(prefix);
		int idx = keyList.indexOf(mainKey);
		keyList.add(0, keyList.get(idx));
		keyList.remove(idx+1);
		String[] keys = new String[keyList.size()];
		return this.getListPrefixMapPro(prefix, keyList.toArray(keys));
	}

	/**
	 * <pre>
	 * Generic get 메서드
	 * 예)[Map]  String foo = (String)map.get("foo");
	 *    [UMap] String foo = umap.getStr("foo", "A"); or String foo = umap.getType("foo", "A");
	 * </pre>
	 *
	 * @param key
	 * @param defaultVal 기본값
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public <T> T getType(String key, T defaultVal) {
		Object val = this.get(key);
		if (val == null) {
			return defaultVal;
		} else {
			return (T)val;
		}
	}

	/**
	 * <pre>
	 * Generic get 메서드
	 * 예)[Map]  String foo = (String)map.get("foo");
	 *    [UMap] String foo = umap.getStr("foo"); or String foo = umap.getType("foo");
	 * </pre>
	 *
	 * @param key
	 * @return
	 */
	public <T> T getType(String key) {
		return this.getType(key, null);
	}

	/**
	 * <pre>
	 * toString 구현 메서드
	 *
	 * 예) umap.toString(false); UMap[sord=asc,OPR_DATE=2014-04-04,nd=1396593415948,_search=false]
	 *     umap.toString(true);  UMap[
	 *                             sord=asc,
	 *                             OPR_DATE=2014-04-04,
	 *                             nd=1396593415948,
	 *                             _search=false
	 *                           ]
	 * </pre>
	 *
	 * @param isPretty
	 * @return
	 */
	public String toString(boolean isPretty) {
		Set<Entry<String, Object>> entry = this.entrySet();

		ToStringStyle   tss = isPretty ? ToStringStyle.MULTI_LINE_STYLE : ToStringStyle.SHORT_PREFIX_STYLE;
		ToStringBuilder tsb = new ToStringBuilder(this, tss);
		for (Entry<String, Object> e : entry) {
			tsb.append(e.getKey(), e.getValue());
		}

		return tsb.toString();
	}

	@Override
	public String toString() {
		return this.toString(false);
	}

	/**
	 * UMap 의 Key 배열을 반환
	 * @return
	 */
	public List<Object> toValueList() {
		return new ArrayList<Object>(this.values());
	}

	/**
	 * UMap 의 Key 배열을 반환
	 * @return
	 */
	public List<String> toKeyList() {
		return new ArrayList<String>(this.keySet());
	}

	/**
	 * UMap 의 Key 배열을 반환 (prefix가 붙은 key 값만 반환)
	 * @return
	 */
	public List<String> toKeyList(String prefix) {
		List<String> list = this.toKeyList();
		for(int i = list.size() - 1 ; i >= 0; i--) {
			String key = list.get(i);
			if (key.startsWith(prefix)) {
				list.set(i, key.substring(prefix.length()));
			}
			else {
				list.remove(i);
			}
		}
		return list;
	}

	/**
	 * UMap 의 Upper Key 로 변환된 맵을 반환
	 *
	 * 예) UMap mUpp = map.toUpperKeyCase();
	 *
	 * @return
	 */
	public UMap toUpperKeyCase() {
		return this.toConvertKeyCase(UMap.UPPER_KEY);
	}

	/**
	 * UMap 의 Lower Key 로 변환된 맵을 반환
	 *
	 * 예) UMap mUpp = map.toLowerKeyCase();
	 *
	 * @return
	 */
	public UMap toLowerKeyCase() {
		return this.toConvertKeyCase(UMap.LOWER_KEY);
	}

	/**
	 * UMap 의 지정해준 Key Case 로 변환된 맵을 반환
	 *
	 * 예) UMap mUpp = map.toConvertKeyCase(UMap.UPPER_KEY);
	 *     UMap mLow = map.toConvertKeyCase(UMap.LOWER_KEY);
	 *
	 * @return
	 */
	public UMap toConvertKeyCase(int keyCase) {
		UMap m = new UMap();
		List<String> keyList = this.toKeyList();
		for(int i = 0 ; i < keyList.size() ; i++)
		{
			String oldKey = keyList.get(i);
			String newKey = oldKey;
			if (keyCase == UPPER_KEY) {
				newKey = oldKey.toUpperCase();
			} else if (keyCase == LOWER_KEY) {
				newKey = oldKey.toLowerCase();
			}
			m.put(newKey, this.getStr(oldKey));
		}
		return m;
	}


	/**
	 * 현재 Map 의 Key 값을 기준으로 현재 맵과 입력 받은 맵의 값을 비교하여 모두 동일한지 확인
	 *
	 * @param targetMap 비교대상이 되는 Map
	 * @param excludeKeys 비교대상에서 제외할 Key 값들
	 * @return
	 */
	public boolean isEqualValue(UMap targetMap, String... excludeKeys) {
		// key 리스트생성하고 제외될 키는 리스트에서 제거
		List<String> keylist = this.toKeyList();
		keylist.removeAll(Arrays.asList(excludeKeys));

		// key 배열에 해당되는 값을 비교
		boolean flag = true;
		for(int i = 0 ; i < keylist.size() ; i++ ) {
			String key = keylist.get(i);
			if (!StringUtils.deleteWhitespace(this.getStr(key)).equals(StringUtils.deleteWhitespace(targetMap.getStr(key)))) {
					flag = false;
					break;
			}
		}

		return flag;
	}

	/**
	 * 현재 Map 의 Key 값을 기준으로 현재 맵과 입력 받은 맵의 값을 비교하여 모두 동일한지 확인
	 *
	 * @param targetMap 비교대상이 되는 Map
	 * @param includeKeys 비교대상에서 포함할 Key 값들
	 * @return
	 */
	public boolean isEqualValueInclude(UMap targetMap, String... includeKeys) {
		// key 리스트생성하고 제외될 키는 리스트에서 제거
		List<String> keylist = Arrays.asList(includeKeys);

		// key 배열에 해당되는 값을 비교
		boolean flag = true;
		for(int i = 0 ; i < keylist.size() ; i++ ) {
			String key = keylist.get(i);
			// replaceAll("\r\n","\n") 추가		/* 2016.06.13 */
			if (!StringUtils.deleteWhitespace(this.getStr(key)).equals(StringUtils.deleteWhitespace(targetMap.getStr(key)))) {
				flag = false;
				break;
			}
		}

		return flag;
	}

	/**
	 * targetList 에서 선택된 key(AA, BB, CC) 값들로 AA#BB#CC 와 같은 key string 을 key 로 하는 맵을 생성
	 *
	 * 예) UMap um = UMap.makeKeyMap(list, "ESN", "OPR_DATE", "SEQ");
	 *
	 * @param targetList 대상이 되는 UMap list
	 * @param includeKeys key string 으로 사용될 key 값
	 * @return includeKeys를 key string 으로 하는 umap 반환
	 */
	public static UMap makeKeyMap(List<UMap> targetList, String... includeKeys) {
		UMap resultMap = new UMap();

		for(int i = 0 ; i < targetList.size() ; i++) {
			UMap m = targetList.get(i);

			// keyString 생성
			List<String> values = new ArrayList<String>();
			for(int j = 0 ; j < includeKeys.length ; j++) {
				values.add(m.getStr(includeKeys[j]));
			}
			String keyStr = StringUtils.join(values, "#");
			resultMap.put(keyStr, i);
		}

		return resultMap;
	}

	/**
	 * AA#BB#CC 와 같은 key string 을 생성
	 *
	 * 예) String keyStr = getKeyString(m, "ESN", "OPR_DATE", "SEQ");
	 *
	 * @param m
	 * @param includeKeys
	 * @return
	 */
	private static String getKeyString(UMap m, String... includeKeys) {
		List<String> values = new ArrayList<String>();
		for(int j = 0 ; j < includeKeys.length ; j++) {
			values.add(m.getStr(includeKeys[j]));
		}
		String keyStr = StringUtils.join(values, "#");
		return keyStr;
	}

	/**
	 * target1 과 target2 리스트의 key 값을 비교해서 key 값이 동일한 데이터는 제외
	 *
	 * 예) UMap.excludeSameKeyValue(list, list2, "ESN", "OPR_DATE", "SEQ");
	 *
	 * @param targetList 대상이 되는 UMap list
	 * @param includeKeys key string 으로 사용될 key 값
	 * @return includeKeys를 key string 으로 하는 umap 반환
	 */
	public static void excludeSameKeyValue(List<UMap> target1List, List<UMap> target2List, String... compareKeys) {
		UMap t2KeyMap = UMap.makeKeyMap(target2List, compareKeys);

		List<Integer> t2RemoveKeyList = new ArrayList<Integer>();
		for(int i = target1List.size()-1 ; i >= 0 ; i--) {
			UMap t1 = target1List.get(i);

			// keyString 생성
			String keyStr = getKeyString(t1, compareKeys);

			// 해당키의 값이 keyMap 에 존재하면 해당 데이터는 t1 에서 제거하고 t2 제거 리스트에 추가
			if (t2KeyMap.containsKey(keyStr)) {
				target1List.remove(i);

				int t2idx = t2KeyMap.getInt(keyStr);
				t2RemoveKeyList.add(t2idx);

				t2KeyMap.remove(keyStr);
			}
		}
		// 삭제할 리스트의 key 를 정렬
		Collections.sort(t2RemoveKeyList);

		// 기존의 리스트 index 에 변경이 없도록 역순으로 제거할 값들을 삭제
		for(int i = t2RemoveKeyList.size() - 1 ; i >= 0 ; i-- ) {
			target2List.remove(t2RemoveKeyList.get(i).intValue());
		}
	}

	/**
	 * target1 리스트의 UMap 의 key 값을 모두 UPPER CASE 로 변경
	 *
	 * @param targetList
	 */
	public static void convertUpperCaseKey(List<UMap> targetList) {
		for(int i = 0 ; i < targetList.size() ; i++) {
			UMap t = targetList.get(i).toUpperKeyCase();
			targetList.set(i, t);
		}
	}

	/**
	 * target1 리스트의 UMap 의 key 값을 모두 LOWER CASE 로 변경
	 *
	 * @param targetList
	 */
	public static void convertLowerCaseKey(List<UMap> targetList) {
		for(int i = 0 ; i < targetList.size() ; i++) {
			UMap t = targetList.get(i).toLowerKeyCase();
			targetList.set(i, t);
		}
	}

	/**
	 * target 리스트의 값을 key 값을 기준으로 숫자정렬
	 *
	 * @param targetList
	 */
	public static void sortForInt(List<UMap> targetList, final String sortKey) {
		Collections.sort(targetList, new Comparator<UMap>(){
			@Override
			public int compare(UMap o1, UMap o2) {
				return o1.getInt(sortKey) - o2.getInt(sortKey);
			}

		});
	}

	/**
	 * target 리스트의 값을 key 값을 기준으로 숫자정렬
	 *
	 * @param targetList
	 */
	public static void sortForDouble(List<UMap> targetList, final String sortKey) {
		Collections.sort(targetList, new Comparator<UMap>(){
			@Override
			public int compare(UMap o1, UMap o2) {
				return Double.compare(o1.getDouble(sortKey), o2.getDouble(sortKey));
			}

		});
	}

	/**
	 * target 리스트의 값을 key 값을 기준으로 문자정렬 (날짜값도 사용가능)
	 *
	 * @param targetList
	 */
	public static void sortForString(List<UMap> targetList, final String sortKey) {
			sortForString(targetList, sortKey, true);
	}

	/**
	 * target 리스트의 값을 key 값을 기준으로 문자정렬 (날짜값도 사용가능)
	 *
	 * @param targetList
	 */
	public static void sortForString(List<UMap> targetList, final String sortKey, final boolean isAsc) {
		Collections.sort(targetList, new Comparator<UMap>(){
			@Override
			public int compare(UMap o1, UMap o2) {
				if (isAsc) {
					return o1.getStr(sortKey).compareTo(o2.getStr(sortKey));
				}
				else {
					return o2.getStr(sortKey).compareTo(o1.getStr(sortKey));
				}
			}
		});
	}

	/**
	 * target 리스트의 값을 key 값을 기준으로 검색
	 *
	 * @param targetList
	 */
	public static UMap find(List<UMap> targetList, final String findKey, final Object findValue) {
		final String findVal = ObjectUtils.toString(findValue);
		int idx = -1;
		idx = Collections.binarySearch(targetList, null,  new Comparator<UMap>(){
			@Override
			public int compare(UMap o1, UMap o2) {
				return o1.getStr(findKey).compareTo(findVal);
			}
		});

		System.out.println(idx);

		if (idx >= 0) {
			return targetList.get(idx);
		}
		else {
			return null;
		}
	}

	/**
	 * 현재 Map 의 values가 모두 null값 인지 체크
	 *
	 * @param excludeKeys 비교대상에서 제외할 Key 값들
	 * @return boolean (모두 null일경우 true, 한개라도 값이 있을 시 false)
	 */
	public boolean isNullValue(String... excludeKeys) {
		// key 리스트생성하고 제외될 키는 리스트에서 제거
		List<String> keylist = this.toKeyList();
		keylist.removeAll(Arrays.asList(excludeKeys));

		// key 배열에 해당되는 값을 비교
		boolean flag = true;
		if(keylist != null){
			for(int i = 0 ; i < keylist.size() ; i++ ) {
				String key = keylist.get(i);
				if (!"".equals(this.getStr(key))) {
					flag = false;
				}
			}
		}
		return flag;
	}

	public boolean isAjax() {
		return StringUtils.equals(this.request.getHeader("X-Requested-With"), "XMLHttpRequest");
	}

	public <T> T getSessionValue(String key) {
		return this.getSessionValue(key, null);
	}

	@SuppressWarnings("unchecked")
	public <T> T getSessionValue(String key, T defaultVal) {
		Object val = this.session.getAttribute(key);
		if (val == null) {
			return defaultVal;
		} else {
			return (T) val;
		}
	}
	public void setSessionValue(String key, Object val) {
		this.session.setAttribute(key, val);
	}

	public HttpServletRequest getRequest() {
		return request;
	}

	public HttpSession getSession() {
		return session;
	}

	/**
	 * targetMap 에서 선택된 key(AA, BB, CC) 값이 있으면  HTMLTagFilter와 동일한 특수문자 처리를 한다.
	 *
	 * 예) UMap.escapeUMap(targetMap, "ESN", "OPR_DATE", "SEQ");
	 *
	 * @param targetMap 대상이 되는 UMap
	 * @param includeKeys key string 으로 사용될 key 값
	 * @return includeKeys를 key string 으로 하는 umap 반환
	 */
	public static void escapeUMap(UMap targetMap, String... includeKeys) {
		List<String> keyList = targetMap.toKeyList();

		if(includeKeys.length > 0){
			for(String inKey : includeKeys){
				if(!"".equals(targetMap.getStr(inKey))){
					targetMap.put(inKey, targetMap.getEscapeStr(inKey));
				}
			}
		} else {
			for(String key : keyList){
				targetMap.put(key, targetMap.getEscapeStr(key));
			}
		}
	}

	/**
	 * targetList 에서 선택된 key(AA, BB, CC) 값이 UMap 있으면  HTMLTagFilter와 동일한 특수문자 처리를 한다.
	 *
	 * 예) UMap.escapeList(targetList, "ESN", "OPR_DATE", "SEQ");
	 *
	 * @param targetMap 대상이 되는 UMap
	 * @param includeKeys key string 으로 사용될 key 값
	 * @return includeKeys를 key string 으로 하는 umap 반환
	 */
	public static void escapeList(List<UMap> targetList, String... includeKeys) {
		for(UMap targetMap : targetList){
			List<String> keyList = targetMap.toKeyList();

			if(includeKeys.length > 0){
				for(String inKey : includeKeys){
					if(!"".equals(targetMap.getStr(inKey))){
						targetMap.put(inKey, targetMap.getEscapeStr(inKey));
					}
				}
			} else {
				for(String key : keyList){
					targetMap.put(key, targetMap.getEscapeStr(key));
				}
			}
		}
	}

	/**
	 * UMap 의 데이터를 그대로 복사한 새로운 객체를 생성하고 리턴
	 * @return
	 */
	public UMap toMap() {
		UMap m = new UMap();
		List<String> keyList = this.toKeyList();
		for(int i = 0 ; i < keyList.size() ; i++)
		{
			String Key = keyList.get(i);
			m.put(Key, this.getStr(Key));
		}

		return m;
	}

	/**
	 * UMap 에서 주어진 key 값에 대한 리스트를 반환
	 *
	 * @param key 리스트로 반환할 key 값
	 * @return
	 */
	public static List<String> toValList(List<UMap> mapList, String key) {
		List<String> vList = new ArrayList<String>();

		for(int i = 0 ; i < mapList.size() ; i++)
		{
			UMap m = mapList.get(i);
			vList.add(m.getStr(key));
		}
		return vList;
	}

	/**
	 * UMap 에서 주어진 key 값에 대한 리스트를 반환
	 *
	 * @param key 리스트로 반환할 key 값
	 * @return
	 */
	public static String[] toValArray(List<UMap> mapList, String key) {
		String[] vArr = new String[mapList.size()];
		for(int i = 0 ; i < mapList.size() ; i++)
		{
			UMap m = mapList.get(i);
			vArr[i] = m.getStr(key);
		}
		return vArr;
	}
}