library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
LIBRARY WORK;
USE WORK.BRAM_UART_DATA_TYPES.ALL;

entity REG_IF is
    port 
    (
        --CLK AND RESET
        CLK                         : IN    STD_LOGIC;
        RST                         : IN    STD_LOGIC;
        
        --EXT REGISTER
        EXT_REG_IF_ADDR             : IN    STD_LOGIC_VECTOR(15 DOWNTO 0);
        EXT_REG_IF_WR_DATA          : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
        EXT_REG_IF_RD_DATA          : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
        EXT_REG_IF_EN               : IN    STD_LOGIC;  
        EXT_REG_IF_WR_EN            : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);  
                       
        CTRL_REGS                   : OUT   CONTROL_REGISTERS;
        STAT_REGS                   : IN    STAT_REGISTERS
    );
end REG_IF;

architecture Behavioral of REG_IF is
    
    signal ext_interface_rx_buf_rden        : std_logic;
    signal ext_interface_rx_buf_rden_dl     : std_logic;
    signal ext_interface_tx_buf_wren        : std_logic;
    signal ext_interface_tx_buf_wren_dl     : std_logic;
    
begin

    write_registers_p : process (CLK)
    begin
        if rising_edge(CLK) then
            ext_interface_tx_buf_wren               <= '0';
            CTRL_REGS.ext_interface_7seg_ctrl       <= '0';
            ext_interface_tx_buf_wren_dl            <= ext_interface_tx_buf_wren;
            CTRL_REGS.ext_interface_tx_buf_wren     <= ext_interface_tx_buf_wren and (not ext_interface_tx_buf_wren_dl);
            
            if (EXT_REG_IF_EN = '1' and EXT_REG_IF_WR_EN = "1111") then
                case EXT_REG_IF_ADDR(13 downto 2) is
                    
                    -- UART
                    when x"000" => CTRL_REGS.ext_interface_clk_div_baud_dbg             <= EXT_REG_IF_WR_DATA;
                    when x"001" => CTRL_REGS.ext_interface_tx_buf_data                  <= EXT_REG_IF_WR_DATA(CTRL_REGS.ext_interface_tx_buf_data'range);
                                   ext_interface_tx_buf_wren                            <= '1';
                    when x"002" => CTRL_REGS.ext_interface_leds                         <= EXT_REG_IF_WR_DATA(CTRL_REGS.ext_interface_leds'range);
                    
                    -- 7 Segment
                    when x"003" => CTRL_REGS.ext_interface_7seg_data                    <= EXT_REG_IF_WR_DATA(CTRL_REGS.ext_interface_7seg_data'range);
                                   CTRL_REGS.ext_interface_7seg_ctrl                    <= '1';
                                   
                    
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    read_registers_p : process (CLK)
    begin
        if rising_edge(CLK) then
            ext_interface_rx_buf_rden               <= '0';
            ext_interface_rx_buf_rden_dl            <= ext_interface_rx_buf_rden;
            CTRL_REGS.ext_interface_rx_buf_rden     <= ext_interface_rx_buf_rden and (not ext_interface_rx_buf_rden_dl);
                        
            if (EXT_REG_IF_EN = '1' and EXT_REG_IF_WR_EN = "0000") then
                EXT_REG_IF_RD_DATA <= (others => '0');
                case EXT_REG_IF_ADDR(13 downto 2) is
                
                    -- UART
                    when x"800" => EXT_REG_IF_RD_DATA(0)                                            <= STAT_REGS.ext_interface_rx_buf_empty;
                    when x"801" => EXT_REG_IF_RD_DATA(STAT_REGS.ext_interface_rx_buf_data'range)    <= STAT_REGS.ext_interface_rx_buf_data;
                                   ext_interface_rx_buf_rden <= '1';
                    when x"802" => EXT_REG_IF_RD_DATA(0)                                            <= STAT_REGS.ext_interface_tx_buf_full;
                                                   
                    when others => null; 
                end case;
            end if;
        end if;
    end process;

end Behavioral;