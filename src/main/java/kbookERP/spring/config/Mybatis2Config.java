package kbookERP.spring.config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.transaction.annotation.EnableTransactionManagement;

//@Configuration
//@MapperScan(value="com.asworld", sqlSessionFactoryRef="db2SqlSessionFactory")
//@EnableTransactionManagement
public class Mybatis2Config {
//
//	@Value("${spring.db2.datasource.driverClassName}")
//    private String driverClassName;
//	@Value("${spring.db2.datasource.jdbcUrl}")
//    private String db_url;
//    @Value("${spring.db2.datasource.username}")
//    private String db_username;
//    @Value("${spring.db2.datasource.password}")
//    private String db_password;
//
//
//    @Bean(name ="db2DataSource")
//    @ConfigurationProperties(prefix ="spring.db2.datasource")
//
//    public DataSource db2DataSource() {
//    	 return DataSourceBuilder.create()
//                 .url(db_url)
//                 .username(db_username)
//                 .password(db_password)
//                 .driverClassName(driverClassName)
//                 .build();
//    }
//
//    @Bean(name ="db2SqlSessionFactory")
//    public SqlSessionFactory db2SqlSessionFactory(@Qualifier("db2DataSource") DataSource db2DataSource, ApplicationContext applicationContext)throws Exception {
//        SqlSessionFactoryBean sqlSessionFactoryBean =new SqlSessionFactoryBean();
//        sqlSessionFactoryBean.setDataSource(db2DataSource);
//        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
//        sqlSessionFactoryBean.setMapperLocations(resolver.getResources("classpath:mapper_asworld/*.xml"));
//        sqlSessionFactoryBean.setConfigLocation(new ClassPathResource("mybatis-config.xml"));
//        return sqlSessionFactoryBean.getObject();
//    }
//
//    @Bean(name ="db2SqlSessionTemplate")
//    public SqlSessionTemplate db2SqlSessionTemplate(SqlSessionFactory db2SqlSessionFactory)throws Exception {
//
//        return new SqlSessionTemplate(db2SqlSessionFactory);
//    }
}
