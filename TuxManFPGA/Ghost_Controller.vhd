----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:06:08 12/06/2019 
-- Design Name: 
-- Module Name:    Ghost_Controller - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ghost_Controller is
    Port ( ghost_collision : in  STD_LOGIC;
           directions : out  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end Ghost_Controller;

architecture Behavioral of Ghost_Controller is

type T_STATE is (UP, LEFT, RIGHT, DOWN, RANDOM_SELECTION);
signal CURRENT_STATE, NEXT_STATE : T_STATE;

begin

	TRANSP : process (CURRENT_STATE, ghost_collision) 
		begin 
			case CURRENT_STATE is 
				when UP => 
				when LEFT => 
				when RIGHT => 
				when DOWN => 
				when RANDOM_SELECTION => 
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
		
	OUTP : process (CURRENT_STATE, ghost_collision)
		begin
			case CURRENT_STATE is 
				when UP => 
				when LEFT => 
				when RIGHT => 
				when DOWN => 
				when RANDOM_SELECTION => 
			end case;
	end process;


end Behavioral;