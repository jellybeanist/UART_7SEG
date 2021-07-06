library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY WORK;
USE WORK.BRAM_UART_DATA_TYPES.ALL;

entity TOP is
    Port 
    ( 
        CLK_100         : IN STD_LOGIC;
        RST             : IN STD_LOGIC;
        
        LED             : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        
        ANODE_ACTIVATE  : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        LED_OUT         : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0); 
                
        UART_TX_OUT     : OUT STD_LOGIC;
        UART_RX_IN      : IN STD_LOGIC
        
    );
end TOP;


architecture Behavioral of TOP is
    
    signal i_rst                : std_logic := '1';
    signal i_rst_n              : std_logic := '0'; 
    signal alive_counter        : std_logic_vector(31 downto 0) := (others => '0');
    
    signal reg_if_addr          : std_logic_vector(15 downto 0);
    signal reg_if_wr_data       : std_logic_vector(31 downto 0);
    signal reg_if_rd_data       : std_logic_vector(31 downto 0);
    signal reg_if_en            : std_logic;
    signal reg_if_wr_en         : std_logic_vector(3 downto 0);
    signal i_anode_activate     : std_logic_vector(3 downto 0);
    signal i_led_out            : std_logic_vector(6 downto 0);
    
    signal CTRL_REGS            : CONTROL_REGISTERS;
    signal STAT_REGS            : STAT_REGISTERS;
    
begin
    
    LED <= CTRL_REGS.ext_interface_leds;
    i_rst_n <= not i_rst;
    LED_OUT <= i_led_out;
    ANODE_ACTIVATE <= i_anode_activate;

    P1: process (CLK_100) begin
        if rising_edge(CLK_100) then
            if (RST = '0') then
                if (alive_counter = 100_000) then
                    alive_counter <= (others => '0');
                    i_rst <= '0';
                else
                    alive_counter <= alive_counter + 1;
                end if;
            else
                alive_counter <= (others => '0');
                i_rst <= '1';
            end if;
        end if;
    end process;
        
        
    U1: entity work.BD_wrapper
        port map
        (
            CLK_100             => CLK_100,
            RESET_N             => i_rst_n,
            REG_IF_addr         => reg_if_addr,
            REG_IF_clk          => open,
            REG_IF_din          => reg_if_wr_data,
            REG_IF_dout         => reg_if_rd_data,
            REG_IF_en           => reg_if_en,
            REG_IF_rst          => open,
            REG_IF_we           => reg_if_wr_en
            
        );
    
    U2: entity work.REG_IF
        port map
        (
            CLK                 =>  CLK_100,                   
            RST                 =>  i_rst,               
            
            EXT_REG_IF_ADDR     =>  reg_if_addr,        
            EXT_REG_IF_WR_DATA  =>  reg_if_wr_data,         
            EXT_REG_IF_RD_DATA  =>  reg_if_rd_data,          
            EXT_REG_IF_EN       =>  reg_if_en,        
            EXT_REG_IF_WR_EN    =>  reg_if_wr_en,  
                               
            CTRL_REGS           =>  CTRL_REGS,  
            STAT_REGS           =>  STAT_REGS                 
        );
    
    U3: entity work.UART_TRX
        port map 
        (
        
            CLK             =>    CLK_100,
            RST             =>    i_rst,
            
            CLK_DIV_BAUD    =>    CTRL_REGS.ext_interface_clk_div_baud_dbg,
            
            RX_IN           =>    UART_RX_IN,
            TX_OUT          =>    UART_TX_OUT,
     
            RX_BUF_EMPTY    =>    STAT_REGS.ext_interface_rx_buf_empty,
            RX_BUF_DATA     =>    STAT_REGS.ext_interface_rx_buf_data,
            RX_BUF_RDEN     =>    CTRL_REGS.ext_interface_rx_buf_rden,
     
            TX_BUF_DATA     =>    CTRL_REGS.ext_interface_tx_buf_data,
            TX_BUF_WREN     =>    CTRL_REGS.ext_interface_tx_buf_wren,
            TX_BUF_FULL     =>    STAT_REGS.ext_interface_tx_buf_full
        );

    U4: entity work.SEG_7
        port map 
        (
        
            CLK             =>    CLK_100,
            RST             =>    i_rst,
            
            SEVEN_SEG_EN    =>    CTRL_REGS.ext_interface_7seg_ctrl,
            SEVEN_SEG_DATA  =>    CTRL_REGS.ext_interface_7seg_data,
            
            ANODE_ACTIVATE  =>    i_anode_activate,
            LED_OUT         =>    i_led_out
        );
    
    
end Behavioral;
