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
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@MapperScan(value="kbookERP", sqlSessionFactoryRef="db1SqlSessionFactory")
@EnableTransactionManagement
public class MybatisConfig {

	@Value("${spring.db1.datasource.driverClassName}")
    private String driverClassName;
	@Value("${spring.db1.datasource.jdbcUrl}")
    private String db_url;
    @Value("${spring.db1.datasource.username}")
    private String db_username;
    @Value("${spring.db1.datasource.password}")
    private String db_password;


	@Bean(name ="db1DataSource")
    @Primary
    @ConfigurationProperties(prefix ="spring.db1.datasource")
    public DataSource db1DataSource() {
		 return DataSourceBuilder.create()
               .url(db_url)
               .username(db_username)
               .password(db_password)
               .driverClassName(driverClassName)
               .build();
    }

//	public DataSource db1DataSource() {
//		 return DataSourceBuilder.create().build();
//   }

    @Bean(name ="db1SqlSessionFactory")
    @Primary
    public SqlSessionFactory db1SqlSessionFactory(@Qualifier("db1DataSource") DataSource db1DataSource, ApplicationContext applicationContext)throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean =new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(db1DataSource);
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        sqlSessionFactoryBean.setMapperLocations(resolver.getResources("classpath:mapper/*.xml"));
        sqlSessionFactoryBean.setConfigLocation(new ClassPathResource("mybatis-config.xml"));
        return sqlSessionFactoryBean.getObject();
    }

    @Bean(name ="db1SqlSessionTemplate")
    @Primary
    public SqlSessionTemplate db1SqlSessionTemplate(SqlSessionFactory db1SqlSessionFactory)throws Exception {

        return new SqlSessionTemplate(db1SqlSessionFactory);
    }
}

