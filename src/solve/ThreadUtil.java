package solve;

import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;

public class ThreadUtil {
	public ThreadUtil(io.usethesource.vallang.IValueFactory vf) {}
	
	public void sleep(io.usethesource.vallang.IInteger ms) {
		try {
			Thread.sleep(ms.longValue());
		} catch (InterruptedException e) {
			throw RuntimeExceptionFactory.javaException(e, null, null);
		}
	}
}
