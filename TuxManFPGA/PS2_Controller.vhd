  ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:43:44 10/24/2019 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
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

entity PS2_Controller is
    Port ( strobe_in : in  STD_LOGIC;
           ps2_key : in  STD_LOGIC_VECTOR (7 downto 0);
           strobe : out  STD_LOGIC;
           extended_key : out  STD_LOGIC;
			  clk : in STD_LOGIC;
			  reset : in STD_LOGIC);
end PS2_Controller;

architecture Behavioral of PS2_Controller is

type T_STATE is (IDLE, EXTENDED, RELEASED);
signal CURRENT_STATE, NEXT_STATE : T_STATE;

begin

	TRANSP : process (CURRENT_STATE, strobe_in, ps2_key) 
		begin 
			case CURRENT_STATE is 
				
				when IDLE => if strobe_in='1' then 
									if ps2_key = "11100000" then
										NEXT_STATE <= EXTENDED;
									elsif ps2_key = "11110000" then
										NEXT_STATE <= RELEASED;
									else 
										NEXT_STATE <= IDLE;
									end if;
								else 
									NEXT_STATE <= IDLE;
								end if;
				when EXTENDED => if strobe_in='1' then 
											if ps2_key = "11110000" then
												NEXT_STATE <= RELEASED;
											else 
												NEXT_STATE <= IDLE;
											end if;
									  else 
											NEXT_STATE <= EXTENDED;
									  end if;
				when RELEASED => if strobe_in='1' then 
											NEXT_STATE <= IDLE;
									  else 
											NEXT_STATE <= RELEASED;
									  end if;
				
			end case;
	end process;
		
	CLKP : process (clk)
		begin 
			if (clk'event and clk ='1') then 
				if (reset = '1') then
					CURRENT_STATE <= IDLE;
				else 
					CURRENT_STATE <= NEXT_STATE;
				end if;
			end if;
	end process;
		
	OUTP : process (CURRENT_STATE, strobe_in, ps2_key)
		begin
			strobe <= '0';
			extended_key <= '0';
			case CURRENT_STATE is 
				
				when IDLE => if strobe_in='1' then 
										if (ps2_key /= "11100000") and (ps2_key /= "11110000") then
											strobe <= '1';
										end if;
								end if;
				when EXTENDED => if strobe_in='1' then 
											if ps2_key /= "11110000" then
												strobe <= '1';
												extended_key <= '1';
											end if;
									end if;
				
				when RELEASED => 
				
			end case;
	end process;


end Behavioral;