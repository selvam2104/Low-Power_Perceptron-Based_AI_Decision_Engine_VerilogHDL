## Clock (50 MHz)
set_property -dict { PACKAGE_PIN N11    IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -period 20 [get_ports clk]

## Reset Button
set_property -dict { PACKAGE_PIN L5    IOSTANDARD LVCMOS33 } [get_ports { rst }];#LSB

## UART RX (from PC ? FPGA)
set_property -dict { PACKAGE_PIN D4 IOSTANDARD LVCMOS33 PULLUP true } [get_ports { rx }];

## UART TX (from FPGA ? PC)
set_property -dict { PACKAGE_PIN C4 IOSTANDARD LVCMOS33 } [get_ports { tx }];

# LEDs
set_property -dict { PACKAGE_PIN J3    IOSTANDARD LVCMOS33 } [get_ports { done }];#LSB

##set_property -dict { PACKAGE_PIN H3    IOSTANDARD LVCMOS33 } [get_ports { led[1] }];

set_property -dict { PACKAGE_PIN J1    IOSTANDARD LVCMOS33 } [get_ports { result[0] }];
set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { result[1] }];
set_property -dict { PACKAGE_PIN L3    IOSTANDARD LVCMOS33 } [get_ports { result[2] }];
set_property -dict { PACKAGE_PIN L2    IOSTANDARD LVCMOS33 } [get_ports { result[3] }];
set_property -dict { PACKAGE_PIN K3    IOSTANDARD LVCMOS33 } [get_ports { result[4] }];
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { result[5] }];
set_property -dict { PACKAGE_PIN K5    IOSTANDARD LVCMOS33 } [get_ports { result[6] }];
set_property -dict { PACKAGE_PIN P6    IOSTANDARD LVCMOS33 } [get_ports { result[7] }];

##set_property -dict { PACKAGE_PIN R7    IOSTANDARD LVCMOS33 } [get_ports { result[6] }];

set_property -dict { PACKAGE_PIN R6    IOSTANDARD LVCMOS33 } [get_ports { led_out }]; #11

##set_property -dict { PACKAGE_PIN T5    IOSTANDARD LVCMOS33 } [get_ports { led[12] }];

set_property -dict { PACKAGE_PIN R5    IOSTANDARD LVCMOS33 } [get_ports { decision_valid }]; #13

##set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[14] }];
##set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[15] }];#MSB
