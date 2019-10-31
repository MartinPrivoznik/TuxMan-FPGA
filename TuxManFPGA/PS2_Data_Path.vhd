----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:41:17 10/24/2019 
-- Design Name: 
-- Module Name:    Data_Path - Behavioral 
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

entity PS2_Data_Path is
    Port ( ps2_data : in  STD_LOGIC;
           ps2_clk : in  STD_LOGIC;
           ps2_key : out  STD_LOGIC_VECTOR (7 downto 0);
			  of_flag : out STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end PS2_Data_Path;

architecture Behavioral of PS2_Data_Path is

signal compensed_signal_1 : STD_LOGIC; --PS/2 signals sync
signal compensed_signal_2 : STD_LOGIC;

signal ps2_data_synced : STD_LOGIC;
signal ps2_clk_synced : STD_LOGIC; -----------------------

signal falling_edge_detection : STD_LOGIC;

signal ps2_clk_edge_detected : STD_LOGIC;

signal counter_mod_11 : STD_LOGIC_VECTOR(3 downto 0);

signal shift_register_output : STD_LOGIC_VECTOR(10 downto 0);

begin

compensation_signal : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				compensed_signal_1 <= '0';
				compensed_signal_2 <= '0';
			else 
				compensed_signal_1 <= ps2_data;
				compensed_signal_2 <= ps2_clk;
			end if;
		end if;
end process;

synced_signal : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				ps2_data_synced <= '0';
				ps2_clk_synced <= '0';
			else 
				ps2_data_synced <= compensed_signal_1;
				ps2_clk_synced <= compensed_signal_2;
			end if;
		end if;
end process;

falling_edge_detector : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				falling_edge_detection <= '0';
			else 
				falling_edge_detection <= ps2_clk_synced;
			end if;
		end if;
end process;

ps2_clk_edge_detected <= (not ps2_clk_synced) and (falling_edge_detection);

whole_key_detection_counter : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK   
				of_flag <= '0';
				if(reset = '1') then -- reset
					counter_mod_11 <= (others => '0');
				else 
					if ps2_clk_edge_detected = '1' then
						if counter_mod_11 = "1010" then
							counter_mod_11 <= (others => '0');
							of_flag <= '1';
						else
							counter_mod_11 <= counter_mod_11 + 1;
						end if;
					end if;
				end if;
			end if;
end process;

shift_register_holding_key : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
				if(reset = '1') then -- reset
					shift_register_output <= (others => '0');
				else 
					if ps2_clk_edge_detected = '1' then
						shift_register_output <= ps2_data_synced & shift_register_output(10 downto 1);
					end if;
				end if;
		end if;
end process;

ps2_key <= shift_register_output(8 downto 1);

end Behavioral;
