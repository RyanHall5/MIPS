#Required
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#Clock Speed
create_clock -period 25.000 -name sysclk -waveform {0.000 10.000} [get_ports clk]

set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports rst]


#Seven Seg Select

#Digit Select

#Switches

#Reset Buttons

