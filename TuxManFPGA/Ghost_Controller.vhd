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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.ROM_Game_Data.ALL;

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
			  generator_seed : in STD_LOGIC_VECTOR(15 downto 0);
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end Ghost_Controller;

architecture Behavioral of Ghost_Controller is

type T_STATE is (UP, LEFT, RIGHT, DOWN);
signal CURRENT_STATE, NEXT_STATE : T_STATE;
signal random_shift_reg : STD_LOGIC_VECTOR(15 downto 0);
signal random_directions : STD_LOGIC_VECTOR (1 downto 0);

signal counter : STD_LOGIC_VECTOR(1 downto 0);

signal new_random_generator_value : STD_LOGIC;
signal gen_val1 : STD_LOGIC;
signal gen_val2 : STD_LOGIC;

begin

	TRANSP : process (CURRENT_STATE, ghost_collision, random_directions, counter) 
		begin 
			case CURRENT_STATE is 
				when UP => if ((ghost_collision = '1') and (counter = "11")) then
									case random_directions is
										when "00" => NEXT_STATE <= UP;
										when "01" => NEXT_STATE <= LEFT;
										when "10" => NEXT_STATE <= DOWN;
										when others => NEXT_STATE <= RIGHT;
									end case;
								else 
									NEXT_STATE <= UP;
								end if;
				when LEFT => if ((ghost_collision = '1') and (counter = "11")) then
									case random_directions is
										when "00" => NEXT_STATE <= UP;
										when "01" => NEXT_STATE <= LEFT;
										when "10" => NEXT_STATE <= DOWN;
										when others => NEXT_STATE <= RIGHT;
									end case;
								else 
									NEXT_STATE <= LEFT;
								end if;
				when RIGHT => if ((ghost_collision = '1') and (counter = "11")) then
									case random_directions is
										when "00" => NEXT_STATE <= UP;
										when "01" => NEXT_STATE <= LEFT;
										when "10" => NEXT_STATE <= DOWN;
										when others => NEXT_STATE <= RIGHT;
									end case;
								else 
									NEXT_STATE <= RIGHT;
								end if;
				when DOWN => if ((ghost_collision = '1') and (counter = "11")) then
									case random_directions is
										when "00" => NEXT_STATE <= UP;
										when "01" => NEXT_STATE <= LEFT;
										when "10" => NEXT_STATE <= DOWN;
										when others => NEXT_STATE <= RIGHT;
									end case;
								else 
									NEXT_STATE <= DOWN;
								end if;
			end case;
	end process;
		
	CLKP : process (clk)
		begin 
			if (clk'event and clk ='1') then 
				if (reset = '1') then
					CURRENT_STATE <= UP;
				else 
					CURRENT_STATE <= NEXT_STATE;
				end if;
			end if;
	end process;
		
	OUTP : process (CURRENT_STATE, ghost_collision, random_directions, counter)
		begin
			case CURRENT_STATE is 
				when UP => if ((ghost_collision = '1') and (counter = "11")) then
									directions <= random_directions;
								else
									directions <= "00";
								end if;
				when LEFT => if ((ghost_collision = '1') and (counter = "11")) then
									directions <= random_directions;
								 else
									directions <= "01";
								 end if;
				when RIGHT => if ((ghost_collision = '1') and (counter = "11")) then
									directions <= random_directions;
								  else
									directions <= "11";
								end if;
				when DOWN => if ((ghost_collision = '1') and (counter = "11")) then
									directions <= random_directions;
								 else
									directions <= "10";
								end if;
			end case;
	end process;
	
	gen_val1 <= random_shift_reg(0) XOR random_shift_reg(2);
	gen_val2 <= gen_val1 XOR random_shift_reg(3);
	new_random_generator_value <= gen_val2 XOR random_shift_reg(5);
	random_directions <= random_shift_reg(13) & random_shift_reg(15);
	
	random_num_generator : process(clk)
		begin
			if(clk'event and clk='1') then -- rising edge on CLK          
				if(reset = '1') then -- reset
					random_shift_reg <= generator_seed;
				else 
					random_shift_reg <= new_random_generator_value & random_shift_reg(15 downto 1);
				end if;
			end if;
		end process;
	
	waiting_for_actual_data : process(clk)
		begin
			if(clk'event and clk='1') then -- rising edge on CLK          
				if(reset = '1') then -- reset
					counter <= (others => '0');
				else 
					counter <= counter + 1;
				end if;
			end if;
		end process;

end Behavioral;