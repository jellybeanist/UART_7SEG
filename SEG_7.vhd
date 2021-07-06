library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY WORK;
USE WORK.BRAM_UART_DATA_TYPES.ALL;

entity SEG_7 is
    Port 
    ( 
        CLK                         : IN    STD_LOGIC;
        RST                         : IN    STD_LOGIC;

        SEVEN_SEG_EN                : IN STD_LOGIC;
        SEVEN_SEG_DATA              : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        
        ANODE_ACTIVATE              : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        LED_OUT                     : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0)   

        
    );
end SEG_7;

architecture Behavioral of SEG_7 is

    signal LED_BCD                          : std_logic_vector(3 downto 0);
    signal refresh_counter                  : STD_LOGIC_VECTOR (19 downto 0); --for 10.5ms refresh period.
    signal LED_activating_counter           : std_logic_vector(1 downto 0);
    
begin
LED_activating_counter <= refresh_counter(19 downto 18);
    seven_segment_cases: 
        process(LED_BCD)
            begin
                case LED_BCD is
                    when "0000" => LED_OUT <= "0000001"; -- "0"     
                    when "0001" => LED_OUT <= "1001111"; -- "1" 
                    when "0010" => LED_OUT <= "0010010"; -- "2" 
                    when "0011" => LED_OUT <= "0000110"; -- "3" 
                    when "0100" => LED_OUT <= "1001100"; -- "4" 
                    when "0101" => LED_OUT <= "0100100"; -- "5" 
                    when "0110" => LED_OUT <= "0100000"; -- "6" 
                    when "0111" => LED_OUT <= "0001111"; -- "7" 
                    when "1000" => LED_OUT <= "0000000"; -- "8"     
                    when "1001" => LED_OUT <= "0000100"; -- "9" 
                    when "1010" => LED_OUT <= "0001000"; -- A
                    when "1011" => LED_OUT <= "1100000"; -- b
                    when "1100" => LED_OUT <= "0110001"; -- C "1110010" -- c
                    when "1101" => LED_OUT <= "1000010"; -- d
                    when "1110" => LED_OUT <= "0110000"; -- E
                    when "1111" => LED_OUT <= "0111000"; -- F
                
                    when others => LED_OUT <= "1111110"; -- --
                end case;
        end process;
        
    seven_segment_display: 
        process(LED_activating_counter)
            begin
                    case LED_activating_counter is
                        when "00" =>
                            ANODE_ACTIVATE <= "0111"; 
                            LED_BCD <= SEVEN_SEG_DATA(15 downto 12);
                        when "01" =>
                            ANODE_ACTIVATE <= "1011"; 
                            LED_BCD <= SEVEN_SEG_DATA(11 downto 8);
                        when "10" =>
                            ANODE_ACTIVATE <= "1101"; 
                            LED_BCD <= SEVEN_SEG_DATA(7 downto 4);
                        when "11" =>
                            ANODE_ACTIVATE <= "1110"; 
                            LED_BCD <= SEVEN_SEG_DATA(3 downto 0);
                    end case;
        end process; 
    led_count: 
        process(CLK,RST)
            begin 
                if(RST='1') then
                    refresh_counter <= (others => '0');
                elsif(rising_edge(CLK)) then
                    refresh_counter <= refresh_counter + 1;
                end if;
        end process;        

end Behavioral;
