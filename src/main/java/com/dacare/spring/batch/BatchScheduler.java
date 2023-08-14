package com.dacare.spring.batch;

import org.springframework.stereotype.Component;

@Component
public class BatchScheduler {
	/*
	 * private SchedulerFactory schedulerFactory; private Scheduler scheduler;
	 *
	 * @Value("${batch.mode}") private boolean batchMode;
	 *
	 * @PostConstruct public void start() throws SchedulerException { if(batchMode)
	 * { schedulerFactory = new StdSchedulerFactory(); scheduler =
	 * schedulerFactory.getScheduler(); scheduler.start();
	 *
	 * //job 지정 JobDetail job =
	 * JobBuilder.newJob(BatchJob.class).withIdentity("setDelvStaCdJob").build();
	 *
	 * //trigger 생성 Trigger trigger =
	 * TriggerBuilder.newTrigger().withSchedule(CronScheduleBuilder.
	 * cronSchedule("0 0 0 1/1 * ? *")).build();
	 *
	 * scheduler.scheduleJob(job, trigger); } }
	 */
}
