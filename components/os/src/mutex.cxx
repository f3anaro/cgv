#include <cgv/os/mutex.h>
#ifdef _WIN32
#include <cgv/config/cpp_version.h>
#ifdef CPP11
#define USE_STD_THREAD
#endif
#else
#define USE_STD_THREAD
#endif

#ifdef USE_STD_THREAD
#include <cgv/os/mutex_std_thread.h>
#else
#include <cgv/os/mutex_pthread.h>
#endif
