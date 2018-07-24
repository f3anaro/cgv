#include "capture/capture_device.h"
#include "details/capture_device_impl.h"
#include "details/capture_driver.h"

namespace capture {


/// scan for supported capture devices with all registered drivers and return the number of found devices
unsigned scan_devices(bool scan_capabilities)
{

}

/// return the number of capture devices, if scan devices has not been called before, call it without scanning capabilities
unsigned get_nr_devices()
{

}

/// return the serial of the i-th capture device
const std::string& get_serial(int i)
{

}

/// return the capabilities of the i-th capture device
const device_capabilities& get_capabilities(int i)
{

}

}

#include <cgv/config/lib_end.h>
