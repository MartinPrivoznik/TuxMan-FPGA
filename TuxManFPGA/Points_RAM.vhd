----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:32:03 10/24/2019 
-- Design Name: 
-- Module Name:    PointsRAM - Behavioral 
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

entity PointsRAM is
    Port ( pm_pos_x : in  STD_LOGIC_VECTOR (4 downto 0);
			  pm_pos_y : in  STD_LOGIC_VECTOR (4 downto 0);
           vga_pos_x : in  STD_LOGIC_VECTOR (4 downto 0);
           vga_pos_y : in  STD_LOGIC_VECTOR (4 downto 0);
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           add_point : out  STD_LOGIC;
           is_point : out  STD_LOGIC);
end PointsRAM;

architecture Behavioral of PointsRAM is

signal points_RAM : map_resolution;

begin

checking_pacman_point_collision : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				points_RAM <= points_default_data;
			else 
				add_point <= points_RAM(to_integer(unsigned(pm_pos_x)), to_integer(unsigned(pm_pos_y)));
				points_RAM(to_integer(unsigned(pm_pos_x)), to_integer(unsigned(pm_pos_y))) <= '0'; 
			end if;
		end if;
end process;

is_point <= points_RAM(to_integer(unsigned(vga_pos_x)), to_integer(unsigned(vga_pos_y)));

end Behavioral;

