#!/usr/bin/env python

from prometheus_client import start_http_server, Summary, Gauge
from INA219 import INA219
import time
import random

ina=INA219(i2c_bus=1,addr=0x43)

busVoltage = Gauge('bus_voltage_v', 'Load Voltage')
busVoltage.set_function(lambda: ina.getBusVoltage_V())

shuntVoltage = Gauge('shunt_voltage_mv', 'Shunt Voltage')
shuntVoltage.set_function(lambda: ina.getShuntVoltage_mV())

power = Gauge('power_w', 'Power')
power = power.set_function(lambda: ina.getPower_W())

current = Gauge('current_ma', 'Current')
current = current.set_function(lambda: ina.getCurrent_mA())

if __name__ == '__main__':
    # Start up the server to expose the metrics.
    start_http_server(8000)
    while True:
        time.sleep(1)
