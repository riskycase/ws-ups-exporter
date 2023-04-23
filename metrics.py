#!/usr/bin/env python

from prometheus_client import start_http_server, Summary,Gauge
from INA219 import INA219
import time
import random

ina=INA219(addr=0x42)

busVoltage = Gauge('bus_voltage_v', 'Load Voltage')
busVoltage.set_function(lambda: ina.getBusVoltage_V)

shuntVoltage = Gauge('shunt_voltage_mv', 'Shunt Voltage')
shuntVoltage.set_function(lambda: ina.getShuntVoltage_mV)

psuVoltage = Gauge('psu_voltage_mv', 'PSU Voltage')
psuVoltage.set_function(lambda: getPSUVoltage)

power = Gauge('power_w', 'Power')
power = power.set_function(lambda: ina.getPower_W)

current = Gauge('current_ma', 'Current')
current = current.set_function(lambda: ina.getCurrent_mA)

def getPSUVoltage():
    return ina.getBusVoltage_V() + ( ina.getShuntVoltage_mV() / 1000.0 )

if __name__ == '__main__':
    # Start up the server to expose the metrics.
    start_http_server(8000)
