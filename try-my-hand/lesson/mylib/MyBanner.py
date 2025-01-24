import time
import datetime

class MyBanner:
    s_time = 0
    @staticmethod
    def start():
    	MyBanner.s_time = time.perf_counter()
    	print("### START (%s) ###########" % (datetime.datetime.now()))

    @staticmethod
    def passing(message):
        n_time = time.perf_counter()
        print(">>> %s (lap time = %.2f sec)" % (message, n_time - MyBanner.s_time))

    @staticmethod
    def finish():
    	e_time = time.perf_counter()
    	print("### FINISH (%s > duration = %.2f sec) ###########" % (datetime.datetime.now(), e_time - MyBanner.s_time))
