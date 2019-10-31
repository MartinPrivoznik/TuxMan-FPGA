----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:47:17 10/24/2019 
-- Design Name: 
-- Module Name:    Segment_Display - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Segment_Display is
    Port ( in_1 : in  STD_LOGIC_VECTOR (3 downto 0);
           in_2 : in  STD_LOGIC_VECTOR (3 downto 0);
           in_3 : in  STD_LOGIC_VECTOR (3 downto 0);
           in_4 : in  STD_LOGIC_VECTOR (3 downto 0);
           active_display : out  STD_LOGIC_VECTOR (3 downto 0);
           display_value : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end Segment_Display;

architecture Behavioral of Segment_Display is

signal counter : STD_LOGIC_VECTOR(31 downto 0); --Counter for slowing down clk signal

signal selected_value : STD_LOGIC_VECTOR(3 downto 0); --Actually selected by MUX

begin

counter_inc : process(clk)
	begin 
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				counter <= (others => '0');
			else 
				counter <= counter + 1;
			end if;
		end if;
end process;

display_selection : process(counter(17 downto 16)) -- 1 of N decoder
	begin
		case counter(17 downto 16) is
			when "00" => active_display <= "0111";
			when "01" => active_display <= "1011";
			when "10" => active_display <= "1101";
			when others => active_display <= "1110";
		end case;
end process; 

value_selection : process(counter(17 downto 16), in_1, in_2, in_3, in_4) --Passing value selection
	begin
		case counter(17 downto 16) is
			when "00" => selected_value <= in_1;
			when "01" => selected_value <= in_2;
			when "10" => selected_value <= in_3;
			when others => selected_value <= in_4; 
		end case;
end process;

seven_segment_display_decoding : process(selected_value) --Passing value selection
	begin
		case selected_value is
			 when "0000" => display_value <= "00000011"; -- "0"     
			 when "0001" => display_value <= "10011111"; -- "1" 
	   	 when "0010" => display_value <= "00100101"; -- "2" 
		    when "0011" => display_value <= "00001101"; -- "3" 
			 when "0100" => display_value <= "10011001"; -- "4" 
			 when "0101" => display_value <= "01001001"; -- "5" 
			 when "0110" => display_value <= "01000001"; -- "6" 
			 when "0111" => display_value <= "00011111"; -- "7" 
			 when "1000" => display_value <= "00000001"; -- "8"     
			 when "1001" => display_value <= "00001001"; -- "9" 
			 when "1010" => display_value <= "00000101"; -- a
			 when "1011" => display_value <= "11000001"; -- b
			 when "1100" => display_value <= "01100011"; -- C
			 when "1101" => display_value <= "10000101"; -- d
			 when "1110" => display_value <= "01100001"; -- E
			 when "1111" => display_value <= "01110001"; -- F
			 when others => display_value <= "11111111";
		end case;
end process;

end Behavioral;
