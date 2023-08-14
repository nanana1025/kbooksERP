package com.dacare;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import com.dacare.core.mngm.MngmMapper;

//@ComponentScan(basePackages = {})
//@MapperScan("com.dangol365")
@Component
//@Service
public class TestInitializer implements ApplicationRunner {
    Logger logger = LoggerFactory.getLogger(TestInitializer.class);

    @Autowired
    MngmMapper mngmMapper;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        logger.info("*****************************************************");
        logger.info("***********  run initializer method      ************");
        logger.info("********** 1. 기본테이블 유무 확인       ************");
        logger.info("********** 2. 기본테이블 및 시퀀스 생성  ************");
        logger.info("*****************************************************");

    }
}
