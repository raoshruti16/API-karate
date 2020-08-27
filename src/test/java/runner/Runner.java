package runner;

import com.intuit.karate.junit5.Karate;


public class Runner {

	@Karate.Test
	Karate TestFullPath() {
		return Karate.run("classpath:features/reqres.feature");
	}
	
}