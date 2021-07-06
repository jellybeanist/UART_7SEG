LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

package bram_uart_data_types is
    -- CPU -->> PL
    type CONTROL_REGISTERS is 
    record    
    
        --LEDs
        ext_interface_leds                      : std_logic_vector(15 downto 0);
        
        -- UART
        ext_interface_clk_div_baud_dbg          : std_logic_vector(31 downto 0);
        ext_interface_rx_buf_rden               : std_logic;
        ext_interface_tx_buf_wren               : std_logic;
        ext_interface_tx_buf_data               : std_logic_vector(7 downto 0);
        
        --7 Segment
        ext_interface_7seg_data                 : std_logic_vector(15 downto 0);
        ext_interface_7seg_ctrl                 : std_logic; 

    end record;
    -- PL -->> CPU    
    type STAT_REGISTERS is 
    record
        
        -- UART
        ext_interface_rx_buf_empty              : std_logic;
        ext_interface_rx_buf_data               : std_logic_vector(7 downto 0);
        ext_interface_tx_buf_full               : std_logic;
        
    end record;
end bram_uart_data_types;

package body bram_uart_data_types is

end bram_uart_data_types;