package com.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.junit.runners.Parameterized.Parameters;

import com.entity.User;

public interface IndexMapper {
	/**
	 * 得到所有的数据选项
	 * @return
	 */
	String getIndex();
	
	String getSecretKey(@Param("userId")Integer userId, @Param("type")Integer type);
	
	/**
	 * 得到所有的年份
	 * @return
	 */
	List<Integer> getAllYear();
	
	/**
	 * 显示城市总体信息
	 * @param lon
	 * @param lat
	 * @param radius
	 * @param fld
	 * @param year
	 * @param accoutName
	 * @param accountPwd
	 * @return
	 */
	String showCityStatisticsByCircle(@Param("lon")Double lon, @Param("lat")Double lat, @Param("radius")Double radius,
			@Param("fld")String fld, @Param("year")Integer year , @Param("accoutName")String accoutName, @Param("accountPwd")String accountPwd);
	
	/**
	 * 显示城市总体信息
	 * @param lineStr
	 * @param fld
	 * @param year
	 * @param accoutName
	 * @param accountPwd
	 * @return
	 */
	String showCityStatisticsByPoly(@Param("lineStr") String lineStr, @Param("fld")String fld, @Param("year")Integer year , @Param("accoutName")String accoutName, @Param("accountPwd")String accountPwd);
	
	/**
	 * 显示城市总体信息
	 * @param min_lon
	 * @param min_lat
	 * @param max_lon
	 * @param max_lat
	 * @param fld
	 * @param year
	 * @param accoutName
	 * @param accountPwd
	 * @return
	 */
	String showCityStatisticsByRectangle(@Param("min_lon")Double min_lon, @Param("min_lat") Double min_lat, @Param("max_lon")Double max_lon, @Param("max_lat") Double max_lat,
			@Param("fld")String fld, @Param("year")Integer year , @Param("accoutName")String accoutName, @Param("accountPwd")String accountPwd);
	
	
	String showCityStatisticsByRegionId(@Param("regionId") Integer regionId, @Param("fld")String fld, @Param("year")Integer year ,
			@Param("accoutName")String accoutName, @Param("accountPwd")String accountPwd);
	/**
	 * 得到所有的省份
	 * @return
	 */
	String getProvince();
	
	/**
	 * 根据省份的编码得到所有的市
	 * @param provinceId
	 * @return
	 */
	String getCity(Integer provinceId);
	
	/**
	 * 根据市的编码得到所有的县
	 * @param cityId
	 * @return
	 */
	String getCounty(Integer cityId);
	
	String getExtentforRegion(Integer regionId);
	
	List<String> getFeaturesByRegionId(@Param("regionId") Integer regionId, @Param("fld")String fld, @Param("year")Integer year ,
			@Param("accoutName")String accoutName, @Param("accountPwd")String accountPwd);
	
	String getAreaforRegion(Integer regionId);
	
	/**
	 * @param min_lon
	 * @param min_lat
	 * @param max_lon
	 * @param max_lat
	 * @param fld
	 * @param year
	 * @param accoutName
	 * @param accountPwd
	 * @return 返回的环境的参数
	 * "env=s1:1;s2:28;s3:117;s4:327;s5:831;s6:2501"
	 */
	String getSLDAppendix_byRectangle(@Param("min_lon")Double min_lon, @Param("min_lat") Double min_lat, @Param("max_lon")Double max_lon, @Param("max_lat") Double max_lat,
			@Param("fld")String fld, @Param("year")Integer year , @Param("accoutName")String accoutName, @Param("accountPwd")String accountPwd);
	
	String getSLDAppendix_byPoly(@Param("lineStr") String lineStr, @Param("fld")String fld, @Param("year")Integer year , 
			@Param("accoutName")String accoutName, @Param("accountPwd")String accountPwd);
	
	String getSLDAppendix_byRadius(@Param("lon")Double lon, @Param("lat")Double lat, @Param("radius")Double radius,
			@Param("fld")String fld, @Param("year")Integer year , @Param("accoutName")String accoutName, @Param("accountPwd")String accountPwd);
	
	String getSLDAppendix_byRegionId(@Param("regionId") Integer regionId, @Param("fld")String fld, @Param("year")Integer year ,
			@Param("accoutName")String accoutName, @Param("accountPwd")String accountPwd);
}
