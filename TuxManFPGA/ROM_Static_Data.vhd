--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package ROM_Game_Data is

type map_resolution is array (0 to 18, 0 to 20) of STD_LOGIC;

constant wall_data : map_resolution := 
(--0     1     2     3     4     5     6     7     8     9     10    11    12    13    14    15    16    17    18    19    20 
(('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1')),-- 0
(('1'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('1')),-- 1
(('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('1')),-- 2
(('1'),('0'),('1'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('0'),('1')),-- 3
(('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1')),-- 4
(('1'),('0'),('1'),('0'),('1'),('1'),('1'),('1'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1')),-- 5
(('1'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('1')),-- 6
(('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1')),-- 7
(('1'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('1')),-- 8
(('1'),('1'),('1'),('0'),('1'),('1'),('1'),('0'),('0'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('1'),('1'),('0'),('1')),-- 9
(('1'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('1')),-- 10
(('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1')),-- 11
(('1'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('1')),-- 12
(('1'),('0'),('1'),('0'),('1'),('1'),('1'),('1'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1')),-- 13
(('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1')),-- 14
(('1'),('0'),('1'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('0'),('1')),-- 15
(('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('1')),-- 16
(('1'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('1')),-- 17
(('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1')) -- 18
);

constant points_default_data : map_resolution := 
(--0     1     2     3     4     5     6     7     8     9     10    11    12    13    14    15    16    17    18    19    10 
(('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0')),-- 0
(('0'),('1'),('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('0'),('0'),('1'),('1'),('1'),('0')),-- 1
(('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('0')),-- 2
(('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('1'),('0')),-- 3
(('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0'),('1'),('0')),-- 4
(('0'),('1'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('1'),('0')),-- 5
(('0'),('1'),('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('0')),-- 6
(('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0')),-- 7
(('0'),('1'),('1'),('1'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('1'),('0'),('1'),('1'),('1'),('0')),-- 8
(('0'),('0'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0')),-- 9
(('0'),('1'),('1'),('1'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('1'),('0'),('1'),('1'),('1'),('0')),-- 10
(('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1'),('0'),('1'),('0'),('1'),('0')),-- 11
(('0'),('1'),('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('0')),-- 12
(('0'),('1'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('1'),('0')),-- 13
(('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0'),('1'),('0')),-- 14
(('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('0'),('0'),('1'),('0'),('1'),('0')),-- 15
(('0'),('1'),('0'),('1'),('0'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('1'),('1'),('1'),('0'),('1'),('0')),-- 16
(('0'),('1'),('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('0'),('0'),('1'),('1'),('1'),('0')),-- 17
(('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0')) -- 18
);

constant map_resolution_x : STD_LOGIC_VECTOR(5 downto 0) := "010011"; 
constant map_resolution_y : STD_LOGIC_VECTOR(5 downto 0) := "010101"; 

constant tuxman_default_position_x : STD_LOGIC_VECTOR(4 downto 0) := "01001";
constant tuxman_default_position_y : STD_LOGIC_VECTOR(4 downto 0) := "01111";

constant redghost_default_position_x : STD_LOGIC_VECTOR(4 downto 0) := "01001";
constant redghost_default_position_y : STD_LOGIC_VECTOR(4 downto 0) := "01001";

constant blueghost_default_position_x : STD_LOGIC_VECTOR(4 downto 0) := "01001";
constant blueghost_default_position_y : STD_LOGIC_VECTOR(4 downto 0) := "01001";

constant yellowghost_default_position_x : STD_LOGIC_VECTOR(4 downto 0) := "01001";
constant yellowghost_default_position_y : STD_LOGIC_VECTOR(4 downto 0) := "01001";

constant greenghost_default_position_x : STD_LOGIC_VECTOR(4 downto 0) := "01001";
constant greenghost_default_position_y : STD_LOGIC_VECTOR(4 downto 0) := "01001";

constant redghost_random_generator_seed : STD_LOGIC_VECTOR(15 downto 0) := "1010011010001110";
constant blueghost_random_generator_seed : STD_LOGIC_VECTOR(15 downto 0) := "1010011010001100";
constant greenghost_random_generator_seed : STD_LOGIC_VECTOR(15 downto 0) := "0001101010101011";
constant yellowghost_random_generator_seed : STD_LOGIC_VECTOR(15 downto 0) := "0110100011100011";

end ROM_Game_Data;
