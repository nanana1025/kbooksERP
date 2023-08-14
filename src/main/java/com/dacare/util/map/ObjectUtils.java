package com.dacare.util.map;

import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ObjectUtils extends org.apache.commons.lang3.ObjectUtils {
    /**
     * Object 타입을 String[] 타입으로 변환한다.
     * 만약 src가 null인 경우 []을 반환한다.
     * @param src
     * @return
     */
    public static String[] toStringArray(Object src) {
        String[] dst = new String[0];
        if (src == null) return dst;
        try {
            if (src instanceof String) {
                dst = new String[1];
                dst[0] = ObjectUtils.toString(src);
            } else {
                dst = (String[])src;
            }
        } catch (Exception e) {
            // Exception ignore
        }
        return dst;
    }

    /**
     * Object 타입을 Integer 타입으로 변환한다.
     * 만약 src가 null인 경우 def값을 반환한다.
     * @param src
     * @param def 기본값
     * @return
     */
    public static int toInt(Object src, int def) {
        if (src == null) return def;
        return NumberUtils.toInt(src.toString(), def);
    }

    /**
     * Object 타입을 Integer 타입으로 변환한다.
     * 만약 src가 null인 경우 0을 반환한다.
     * @param src
     * @return
     */
    public static int toInt(Object src) {
        return ObjectUtils.toInt(src, 0);
    }

    /**
     * Object 타입을 Integer[] 타입으로 변환한다.
     * 만약 src가 null인 경우 []을 반환한다.
     * @param src
     * @return
     */
    public static int[] toIntArray(Object src) {
        int[] dst = new int[0];
        if (src == null) return dst;
        try {
            dst = (int[])src;
        } catch (Exception e) {
            // Exception ignore
        }
        return dst;
    }

    /**
     * Object 타입을 Integer 타입으로 변환한다.
     * 만약 src가 null인 경우 def값을 반환한다.
     * @param src
     * @param def 기본값
     * @return
     */
    public static long toLong(Object src, int def) {
        if (src == null) return def;
        return NumberUtils.toLong(src.toString(), def);
    }

    /**
     * Object 타입을 Integer 타입으로 변환한다.
     * 만약 src가 null인 경우 0을 반환한다.
     * @param src
     * @return
     */
    public static long toLong(Object src) {
        return ObjectUtils.toLong(src, 0);
    }

    /**
     * Object 타입을 List<T> 타입으로 변환한다.
     * 만약 src가 null인 경우 길이가 0인 List<T>를 반환한다.
     * @param <T>
     * @param src
     * @return
     */
    @SuppressWarnings("unchecked")
    public static <T> List<T> toList(Object src) {
        List<T> dstList = new ArrayList<>();
        if (src == null) return dstList;

        try {
            dstList = (List<T>)src;
        } catch (Exception e) {
            // Exception ignore
        }
        return dstList;
    }

    /**
     * Object 타입을 boolean 타입으로 변환한다.
     * null    = false
     * "true"  = true
     * "TRUE"  = true
     * "tRUe"  = true
     * "on"    = true
     * "yes"   = true
     * "false" = false
     * "x gti" = false
     * @param src
     * @return
     */
    public static boolean toBool(Object src) {
        return BooleanUtils.toBoolean(ObjectUtils.toString(src));
    }

    /**
     * double 변환
     * <pre>
     * (null, 1.1D)	= 1.1D
     * ("", 1.1D)	= 1.1D
     * (1.5, 1.1D)	= 1.5D
     * </pre>
     * @param src
     * @param def
     * @return
     */
    public static double toDouble(Object src, double def) {
        return NumberUtils.toDouble(ObjectUtils.toString(src), def);
    }

    /**
     * double 변환
     * <pre>
     * (null)	= 0D
     * ("")		= 0D
     * (1.5)	= 1.5D
     * </pre>
     * @param src
     * @return
     */
    public static double toDouble(Object src) {
        return NumberUtils.toDouble(ObjectUtils.toString(src), 0D);
    }

    /**
     * double 변환 + 소수점 자릿수 지정
     * <pre>
     * (null, 3)	= 0D
     * ("", 3)		= 0D
     * (1.123456, 3)= 1.123D
     * </pre>
     * @param src
     * @param point 소수점 자릿수
     * @return
     */
    public static double toDouble(Object src, int point) {
        String sSrc = StringUtils.EMPTY;
        String format = "%." + point + "f";
        if (src instanceof Float) {
            sSrc = String.format(format, (Float)src);
        } else if (src instanceof Double) {
            sSrc = String.format(format, (Double)src);
        } else if (src instanceof BigDecimal) {
            sSrc = String.format(format, (BigDecimal)src);
        }
        return ObjectUtils.toDouble(sSrc, 0D);
    }

    /**
     * HTMLTagFilter와 동일한 특수문자 처리를 한다.
     * .replace("&", "&amp;")
     * .replace("<", "&lt;")
     * .replace(">", "&gt;")
     * .replace("\"", "&quot;")
     * .replace("'", "&apos;")
     * @param src
     * @return
     */
    public static String escapeStr(Object src) {
        String str = ObjectUtils.toString(src);
        return str
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    /**
     * HTMLTagFilter에서 처리된 특수문자를 원복한다.
     * .replace("&amp;", "&")
     * .replace("&lt;", "<")
     * .replace("&gt;", ">")
     * .replace("&quot;", "\"")
     * .replace("&apos;", "'")
     * @param src
     * @return
     */
    public static String unescapeStr(Object src) {
        String str = ObjectUtils.toString(src);
        return str
                .replace("&amp;", "&")
                .replace("&lt;", "<")
                .replace("&gt;", ">")
                .replace("&quot;", "\"")
                .replace("&apos;", "'")
                .replace("&#39;", "'");
    }
}
