----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:47:23 10/24/2019 
-- Design Name: 
-- Module Name:    PS2 - Behavioral 
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

entity PS2 is
    Port ( ps2_data : in  STD_LOGIC;
           ps2_clk : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           key : out  STD_LOGIC_VECTOR (7 downto 0);
           strobe : out  STD_LOGIC;
           extended : out  STD_LOGIC);
end PS2;

architecture Behavioral of PS2 is

signal of_flag : STD_LOGIC;
signal Key_Byte : STD_LOGIC_VECTOR (7 downto 0);

component PS2_Data_Path is
    Port ( ps2_data : in  STD_LOGIC;
           ps2_clk : in  STD_LOGIC;
           ps2_key : out  STD_LOGIC_VECTOR (7 downto 0);
			  of_flag : out STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end component PS2_Data_Path;

component PS2_Controller is
    Port ( strobe_in : in  STD_LOGIC;
           ps2_key : in  STD_LOGIC_VECTOR (7 downto 0);
           strobe : out  STD_LOGIC;
           extended_key : out  STD_LOGIC;
			  clk : in STD_LOGIC;
			  reset : in STD_LOGIC);
end component PS2_Controller;

begin
	
	Data : PS2_Data_Path port map (
		ps2_data => ps2_data,
		ps2_clk => ps2_clk,
		ps2_key => Key_Byte,
		of_flag => of_flag,
		clk => clk,
		reset => reset
	);
	Control : PS2_Controller port map (
		strobe_in => of_flag,
		ps2_key => Key_Byte,
		strobe => strobe,
		extended_key => extended,
		clk => clk,
		reset => reset
	);
	
	key <= Key_Byte;
end Behavioral;