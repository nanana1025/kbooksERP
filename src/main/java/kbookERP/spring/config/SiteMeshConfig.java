package kbookERP.spring.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SiteMeshConfig {
	
	@Value(value="${system.id}")
	private String systemId;
	 
	@Value(value="${system.xml.path}")
	private String menuPath;
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Bean
    public FilterRegistrationBean siteMeshFilter(){
		FilterRegistrationBean filter = new FilterRegistrationBean();
		SiteMeshFilter smf = new SiteMeshFilter(systemId, menuPath);
        filter.setFilter(smf);
   
        return filter;
    }
}
