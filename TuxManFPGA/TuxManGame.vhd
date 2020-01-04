----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:18:00 10/25/2019 
-- Design Name: 
-- Module Name:    TuxManGame - Behavioral 
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
use WORK.ROM_Textures.ALL; 
use WORK.ROM_Game_Data.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TuxManGame is
    Port ( ps2_clk : in  STD_LOGIC;
           ps2_data : in  STD_LOGIC;
           R,G : out STD_LOGIC_VECTOR(2 downto 0);
			  B : out STD_LOGIC_VECTOR(1 downto 0);
			  HSync : out STD_LOGIC;
			  VSync : out STD_LOGIC;
           active_segment_display : out  STD_LOGIC_VECTOR (3 downto 0);
           segment_display_value : out  STD_LOGIC_VECTOR (7 downto 0);
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC);
end TuxManGame;

architecture Behavioral of TuxManGame is

signal counter : STD_LOGIC_VECTOR(31 downto 0); --Used for slowing down clk signal
																--and performing a tuxman step
signal arbitr_counter : STD_LOGIC_VECTOR(1 downto 0);

signal step : STD_LOGIC;
signal step_edge_detection : STD_LOGIC;		

--Tuxman settings 
signal tuxman_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal tuxman_position_y : STD_LOGIC_VECTOR(4 downto 0); 

signal tuxman_new_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal tuxman_new_position_y : STD_LOGIC_VECTOR(4 downto 0);

signal tuxman_step_enable : STD_LOGIC;
signal collision : STD_LOGIC;
signal tuxman_directions : STD_LOGIC_VECTOR(1 downto 0);

signal tuxman_position_x_inc : STD_LOGIC_VECTOR(4 downto 0);
signal tuxman_position_x_dec : STD_LOGIC_VECTOR(4 downto 0);
signal tuxman_position_y_inc : STD_LOGIC_VECTOR(4 downto 0);
signal tuxman_position_y_dec : STD_LOGIC_VECTOR(4 downto 0);



--redghost settings 
signal redghost_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal redghost_position_y : STD_LOGIC_VECTOR(4 downto 0); 

signal redghost_new_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal redghost_new_position_y : STD_LOGIC_VECTOR(4 downto 0);

signal redghost_step_enable : STD_LOGIC;
signal redghost_collision : STD_LOGIC;
signal redghost_directions : STD_LOGIC_VECTOR(1 downto 0);

signal redghost_position_x_inc : STD_LOGIC_VECTOR(4 downto 0);
signal redghost_position_x_dec : STD_LOGIC_VECTOR(4 downto 0);
signal redghost_position_y_inc : STD_LOGIC_VECTOR(4 downto 0);
signal redghost_position_y_dec : STD_LOGIC_VECTOR(4 downto 0);

--blueghost settings 
signal blueghost_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal blueghost_position_y : STD_LOGIC_VECTOR(4 downto 0); 

signal blueghost_new_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal blueghost_new_position_y : STD_LOGIC_VECTOR(4 downto 0);

signal blueghost_step_enable : STD_LOGIC;
signal blueghost_collision : STD_LOGIC;
signal blueghost_directions : STD_LOGIC_VECTOR(1 downto 0);

signal blueghost_position_x_inc : STD_LOGIC_VECTOR(4 downto 0);
signal blueghost_position_x_dec : STD_LOGIC_VECTOR(4 downto 0);
signal blueghost_position_y_inc : STD_LOGIC_VECTOR(4 downto 0);
signal blueghost_position_y_dec : STD_LOGIC_VECTOR(4 downto 0);

--yellowghost settings 
signal yellowghost_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal yellowghost_position_y : STD_LOGIC_VECTOR(4 downto 0); 

signal yellowghost_new_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal yellowghost_new_position_y : STD_LOGIC_VECTOR(4 downto 0);

signal yellowghost_step_enable : STD_LOGIC;
signal yellowghost_collision : STD_LOGIC;
signal yellowghost_directions : STD_LOGIC_VECTOR(1 downto 0);

signal yellowghost_position_x_inc : STD_LOGIC_VECTOR(4 downto 0);
signal yellowghost_position_x_dec : STD_LOGIC_VECTOR(4 downto 0);
signal yellowghost_position_y_inc : STD_LOGIC_VECTOR(4 downto 0);
signal yellowghost_position_y_dec : STD_LOGIC_VECTOR(4 downto 0);

--greenghost settings 
signal greenghost_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal greenghost_position_y : STD_LOGIC_VECTOR(4 downto 0); 

signal greenghost_new_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal greenghost_new_position_y : STD_LOGIC_VECTOR(4 downto 0);

signal greenghost_step_enable : STD_LOGIC;
signal greenghost_collision : STD_LOGIC;
signal greenghost_directions : STD_LOGIC_VECTOR(1 downto 0);

signal greenghost_position_x_inc : STD_LOGIC_VECTOR(4 downto 0);
signal greenghost_position_x_dec : STD_LOGIC_VECTOR(4 downto 0);
signal greenghost_position_y_inc : STD_LOGIC_VECTOR(4 downto 0);
signal greenghost_position_y_dec : STD_LOGIC_VECTOR(4 downto 0);

--Map settings
signal map_active : STD_LOGIC;
signal is_wall : STD_LOGIC;
signal rom_output : STD_LOGIC;
signal arbitr_decoder_data : STD_LOGIC_VECTOR(3 downto 0);
signal selected_coords_x : STD_LOGIC_VECTOR(4 downto 0);
signal selected_coords_y : STD_LOGIC_VECTOR(4 downto 0);

--Character settings
signal is_tuxman : STD_LOGIC;
signal is_redghost : STD_LOGIC;
signal is_blueghost : STD_LOGIC;
signal is_yellowghost : STD_LOGIC;
signal is_greenghost : STD_LOGIC;
signal tuxman_open : STD_LOGIC;

component PS2 is
    Port ( ps2_data : in  STD_LOGIC;
           ps2_clk : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           key : out  STD_LOGIC_VECTOR (7 downto 0);
           strobe : out  STD_LOGIC;
           extended : out  STD_LOGIC);
end component PS2;

signal PS2_key : STD_LOGIC_VECTOR(7 downto 0);
signal PS2_strobe : STD_LOGIC;
signal PS2_extended : STD_LOGIC;

component VGA is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           VSync : out  STD_LOGIC;
           HSync : out  STD_LOGIC;
			  HPos_out : out STD_LOGIC_VECTOR(9 downto 0);
			  VPos_out : out STD_LOGIC_VECTOR(9 downto 0);
			  pos_active : out STD_LOGIC);
end component VGA;

signal VGA_HPos : STD_LOGIC_VECTOR(9 downto 0); --Detecting the actually colored part
signal VGA_VPos : STD_LOGIC_VECTOR(9 downto 0);
signal VGA_active : STD_LOGIC;

component PointsRAM is
    Port ( tm_pos_x : in  STD_LOGIC_VECTOR (4 downto 0);
			  tm_pos_y : in  STD_LOGIC_VECTOR (4 downto 0);
           vga_pos_x : in  STD_LOGIC_VECTOR (4 downto 0);
           vga_pos_y : in  STD_LOGIC_VECTOR (4 downto 0);
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           add_point : out  STD_LOGIC;
           is_point : out  STD_LOGIC);
end component PointsRAM;

signal Points_add_point : STD_LOGIC;
signal Points_is_point : STD_LOGIC;

component Segment_Display is
    Port ( in_1 : in  STD_LOGIC_VECTOR (3 downto 0);
           in_2 : in  STD_LOGIC_VECTOR (3 downto 0);
           in_3 : in  STD_LOGIC_VECTOR (3 downto 0);
           in_4 : in  STD_LOGIC_VECTOR (3 downto 0);
           active_display : out  STD_LOGIC_VECTOR (3 downto 0);
           display_value : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end component Segment_Display;

signal point_counter : STD_LOGIC_VECTOR(15 downto 0);


component Ghost_Controller is
    Port ( ghost_collision : in  STD_LOGIC;
           directions : out  STD_LOGIC_VECTOR (1 downto 0);
			  generator_seed : in STD_LOGIC_VECTOR(15 downto 0);
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end component Ghost_Controller;

begin

--vga coordinates settings
is_wall <= wall_data(to_integer(unsigned(VGA_HPos(8 downto 4))), to_integer(unsigned(VGA_VPos(8 downto 4)))) when map_active = '1' else '0';
is_tuxman <= '1' when (tuxman_position_x =  VGA_HPos(8 downto 4)) and (tuxman_position_y =  VGA_VPos(8 downto 4))
					  else '0';
is_redghost <= '1' when (redghost_position_x =  VGA_HPos(8 downto 4)) and (redghost_position_y =  VGA_VPos(8 downto 4))
					  else '0';
is_blueghost <= '1' when (blueghost_position_x =  VGA_HPos(8 downto 4)) and (blueghost_position_y =  VGA_VPos(8 downto 4))
					  else '0';
is_yellowghost <= '1' when (yellowghost_position_x =  VGA_HPos(8 downto 4)) and (yellowghost_position_y =  VGA_VPos(8 downto 4))
					  else '0';
is_greenghost <= '1' when (greenghost_position_x =  VGA_HPos(8 downto 4)) and (greenghost_position_y =  VGA_VPos(8 downto 4))
					  else '0';

red_ghost_control : Ghost_Controller port map (
	ghost_collision => redghost_collision,
	directions => redghost_directions,
	generator_seed => redghost_random_generator_seed,
	clk => clk,
	reset => reset
);

blue_ghost_control : Ghost_Controller port map (
	ghost_collision => blueghost_collision,
	directions => blueghost_directions,
	generator_seed => blueghost_random_generator_seed,
	clk => clk,
	reset => reset
);

yellow_ghost_control : Ghost_Controller port map (
	ghost_collision => yellowghost_collision,
	directions => yellowghost_directions,
	generator_seed => yellowghost_random_generator_seed,
	clk => clk,
	reset => reset
);

green_ghost_control : Ghost_Controller port map (
	ghost_collision => greenghost_collision,
	directions => greenghost_directions,
	generator_seed => greenghost_random_generator_seed,
	clk => clk,
	reset => reset
);

PS2_Module : PS2 port map (
	ps2_data => ps2_data,
	ps2_clk => ps2_clk,
	key => PS2_key,
	strobe => PS2_strobe,
	extended => PS2_extended,
	clk => clk, 
	reset => reset
);

VGA_Module : VGA port map (
	VSync => VSync,
	HSync => HSync,
	HPos_out => VGA_HPos,
	VPos_out => VGA_VPos,
	pos_active => VGA_active,
	clk => clk, 
	reset => reset
);

Points_RAM_Module : PointsRAM port map (
	tm_pos_x => tuxman_position_x,
	tm_pos_y => tuxman_position_y,
	vga_pos_x => VGA_HPos(8 downto 4),
	vga_pos_y => VGA_VPos(8 downto 4),
	add_point => Points_add_point,
	is_point => Points_is_point,
	clk => clk, 
	reset => reset
);

Segment_display_Module : Segment_Display port map (
	in_1 => point_counter(3 downto 0),
	in_2 => point_counter(7 downto 4),
	in_3 => point_counter(11 downto 8),
	in_4 => point_counter(15 downto 12),
	active_display => active_segment_display,
	display_value => segment_display_value,
	clk => clk,
	reset => reset
);

rom_arbitr_counter : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				arbitr_counter <= (others => '0');
			else 
				arbitr_counter <= arbitr_counter + 1;
			end if;
		end if;
end process;

counting_points : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				point_counter <= (others => '0');
			else 
				if Points_add_point = '1' then
					point_counter <= point_counter + 1;
				end if;
			end if;
		end if;
end process;

counting_game_step : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				counter <= (others => '0');
			else 
				counter <= counter + 1;
			end if;
		end if;
end process;

counter_rising_edge_detection : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				step_edge_detection <= '0';
			else 
				step_edge_detection <= counter(23);
			end if;
		end if;
end process;

--allowing step
step <= (not step_edge_detection) and counter(23);
tuxman_step_enable <= (not collision) and step;

setting_tuxman_directions : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				tuxman_directions <= "00";
			else 
				if (PS2_strobe = '1') and (PS2_extended = '1') then
					case PS2_key is 
						when "01110101" => tuxman_directions <= "00"; --Up
						when "01101011" => tuxman_directions <= "01"; --Left
						when "01110010" => tuxman_directions <= "10"; --Down
						when "01110100" => tuxman_directions <= "11"; --Right
						when others =>
					end case;
				end if;
			end if;
		end if;
		
end process;

redghost_step_enable <= (not redghost_collision) and step;
blueghost_step_enable <= (not blueghost_collision) and step;
yellowghost_step_enable <= (not yellowghost_collision) and step;
greenghost_step_enable <= (not greenghost_collision) and step;

--increased positions
tuxman_position_x_inc <=  tuxman_position_x + 1;
tuxman_position_x_dec <=  tuxman_position_x - 1;
tuxman_position_y_inc <=  tuxman_position_y + 1;
tuxman_position_y_dec <=  tuxman_position_y - 1;


redghost_position_x_inc <=  redghost_position_x + 1;
redghost_position_x_dec <=  redghost_position_x - 1;
redghost_position_y_inc <=  redghost_position_y + 1;
redghost_position_y_dec <=  redghost_position_y - 1;

blueghost_position_x_inc <=  blueghost_position_x + 1;
blueghost_position_x_dec <=  blueghost_position_x - 1;
blueghost_position_y_inc <=  blueghost_position_y + 1;
blueghost_position_y_dec <=  blueghost_position_y - 1;

yellowghost_position_x_inc <=  yellowghost_position_x + 1;
yellowghost_position_x_dec <=  yellowghost_position_x - 1;
yellowghost_position_y_inc <=  yellowghost_position_y + 1;
yellowghost_position_y_dec <=  yellowghost_position_y - 1;

greenghost_position_x_inc <=  greenghost_position_x + 1;
greenghost_position_x_dec <=  greenghost_position_x - 1;
greenghost_position_y_inc <=  greenghost_position_y + 1;
greenghost_position_y_dec <=  greenghost_position_y - 1;


--Setting positions
setting_tuxman_position : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				tuxman_position_x <= tuxman_default_position_x;
				tuxman_position_y <= tuxman_default_position_y;
			else 
				if tuxman_step_enable = '1' then
					if tuxman_new_position_x = map_resolution_x then -- From right to left
						tuxman_position_x <= "00000";
					elsif tuxman_new_position_x > map_resolution_x then --From left to right
						tuxman_position_x <= map_resolution_x(4 downto 0) - 1;
					else
						tuxman_position_x <= tuxman_new_position_x;
						tuxman_position_y <= tuxman_new_position_y;
					end if;
				end if;
			end if;
		end if;
end process;

checking_wall_before_tuxman : process(tuxman_position_x_inc, tuxman_position_x_dec, tuxman_position_y_inc, tuxman_position_y_dec, tuxman_position_x, tuxman_position_y, tuxman_directions)
	begin
		case tuxman_directions is
			when "00" => tuxman_new_position_y <= tuxman_position_y_dec; --Up
							 tuxman_new_position_x <= tuxman_position_x;
			when "01" => tuxman_new_position_x <= tuxman_position_x_dec; --Left
							 tuxman_new_position_y <= tuxman_position_y;
			when "10" => tuxman_new_position_y <= tuxman_position_y_inc; --Down
							 tuxman_new_position_x <= tuxman_position_x;
			when others => tuxman_new_position_x <= tuxman_position_x_inc; --Right
							   tuxman_new_position_y <= tuxman_position_y;
		end case;
end process;

setting_redghost_position : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				redghost_position_x <= redghost_default_position_x;
				redghost_position_y <= redghost_default_position_y;
			else 
				if redghost_step_enable = '1' then
					if redghost_new_position_x = map_resolution_x then -- From right to left
						redghost_position_x <= "00000";
					elsif redghost_new_position_x > map_resolution_x then --From left to right
						redghost_position_x <= map_resolution_x(4 downto 0) - 1;
					else
						redghost_position_x <= redghost_new_position_x;
						redghost_position_y <= redghost_new_position_y;
					end if;
				end if;
			end if;
		end if;
end process;

checking_wall_before_redghost : process(redghost_position_y, redghost_position_x, redghost_position_x_inc, redghost_position_x_dec, redghost_position_y_inc, redghost_position_y_dec, redghost_position_x, redghost_position_y, redghost_directions)
	begin
		case redghost_directions is
			when "00" => redghost_new_position_y <= redghost_position_y_dec; --Up
							 redghost_new_position_x <= redghost_position_x;
			when "01" => redghost_new_position_x <= redghost_position_x_dec; --Left
							 redghost_new_position_y <= redghost_position_y;
			when "10" => redghost_new_position_y <= redghost_position_y_inc; --Down
							 redghost_new_position_x <= redghost_position_x;
			when others => redghost_new_position_x <= redghost_position_x_inc; --Right
							   redghost_new_position_y <= redghost_position_y;
		end case;
end process;

setting_blueghost_position : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				blueghost_position_x <= blueghost_default_position_x;
				blueghost_position_y <= blueghost_default_position_y;
			else 
				if blueghost_step_enable = '1' then
					if blueghost_new_position_x = map_resolution_x then -- From right to left
						blueghost_position_x <= "00000";
					elsif blueghost_new_position_x > map_resolution_x then --From left to right
						blueghost_position_x <= map_resolution_x(4 downto 0) - 1;
					else
						blueghost_position_x <= blueghost_new_position_x;
						blueghost_position_y <= blueghost_new_position_y;
					end if;
				end if;
			end if;
		end if;
end process;

checking_wall_before_blueghost : process(blueghost_position_x, blueghost_position_y, blueghost_position_x_inc, blueghost_position_x_dec, blueghost_position_y_inc, blueghost_position_y_dec, blueghost_position_x, blueghost_position_y, blueghost_directions)
	begin
		case blueghost_directions is
			when "00" => blueghost_new_position_y <= blueghost_position_y_dec; --Up
							 blueghost_new_position_x <= blueghost_position_x;
			when "01" => blueghost_new_position_x <= blueghost_position_x_dec; --Left
							 blueghost_new_position_y <= blueghost_position_y;
			when "10" => blueghost_new_position_y <= blueghost_position_y_inc; --Down
							 blueghost_new_position_x <= blueghost_position_x;
			when others => blueghost_new_position_x <= blueghost_position_x_inc; --Right
							   blueghost_new_position_y <= blueghost_position_y;
		end case;
end process;

setting_yellowghost_position : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				yellowghost_position_x <= yellowghost_default_position_x;
				yellowghost_position_y <= yellowghost_default_position_y;
			else 
				if yellowghost_step_enable = '1' then
					if yellowghost_new_position_x = map_resolution_x then -- From right to left
						yellowghost_position_x <= "00000";
					elsif yellowghost_new_position_x > map_resolution_x then --From left to right
						yellowghost_position_x <= map_resolution_x(4 downto 0) - 1;
					else
						yellowghost_position_x <= yellowghost_new_position_x;
						yellowghost_position_y <= yellowghost_new_position_y;
					end if;
				end if;
			end if;
		end if;
end process;

checking_wall_before_yellowghost : process(yellowghost_position_x, yellowghost_position_y, yellowghost_position_x_inc, yellowghost_position_x_dec, yellowghost_position_y_inc, yellowghost_position_y_dec, yellowghost_position_x, yellowghost_position_y, yellowghost_directions)
	begin
		case yellowghost_directions is
			when "00" => yellowghost_new_position_y <= yellowghost_position_y_dec; --Up
							 yellowghost_new_position_x <= yellowghost_position_x;
			when "01" => yellowghost_new_position_x <= yellowghost_position_x_dec; --Left
							 yellowghost_new_position_y <= yellowghost_position_y;
			when "10" => yellowghost_new_position_y <= yellowghost_position_y_inc; --Down
							 yellowghost_new_position_x <= yellowghost_position_x;
			when others => yellowghost_new_position_x <= yellowghost_position_x_inc; --Right
							   yellowghost_new_position_y <= yellowghost_position_y;
		end case;
end process;

setting_greenghost_position : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				greenghost_position_x <= greenghost_default_position_x;
				greenghost_position_y <= greenghost_default_position_y;
			else 
				if greenghost_step_enable = '1' then
					if greenghost_new_position_x = map_resolution_x then -- From right to left
						greenghost_position_x <= "00000";
					elsif greenghost_new_position_x > map_resolution_x then --From left to right
						greenghost_position_x <= map_resolution_x(4 downto 0) - 1;
					else
						greenghost_position_x <= greenghost_new_position_x;
						greenghost_position_y <= greenghost_new_position_y;
					end if;
				end if;
			end if;
		end if;
end process;

checking_wall_before_greenghost : process(greenghost_position_x, greenghost_position_y, greenghost_position_x_inc, greenghost_position_x_dec, greenghost_position_y_inc, greenghost_position_y_dec, greenghost_position_x, greenghost_position_y, greenghost_directions)
	begin
		case greenghost_directions is
			when "00" => greenghost_new_position_y <= greenghost_position_y_dec; --Up
							 greenghost_new_position_x <= greenghost_position_x;
			when "01" => greenghost_new_position_x <= greenghost_position_x_dec; --Left
							 greenghost_new_position_y <= greenghost_position_y;
			when "10" => greenghost_new_position_y <= greenghost_position_y_inc; --Down
							 greenghost_new_position_x <= greenghost_position_x;
			when others => greenghost_new_position_x <= greenghost_position_x_inc; --Right
							   greenghost_new_position_y <= greenghost_position_y;
		end case;
end process;


Arbitr_one_of_N_decoder : process(arbitr_counter, step)
	begin
		case arbitr_counter is
			when "00" => arbitr_decoder_data(0) <= '1' and (not step);
							 arbitr_decoder_data(1) <= '0' and (not step);
							 arbitr_decoder_data(2) <= '0' and (not step);
							 arbitr_decoder_data(3) <= '0' and (not step);
							 
			when "01" => arbitr_decoder_data(0) <= '0' and (not step);
							 arbitr_decoder_data(1) <= '1' and (not step);
							 arbitr_decoder_data(2) <= '0' and (not step);
							 arbitr_decoder_data(3) <= '0' and (not step);
							 
			when "10" => arbitr_decoder_data(0) <= '0' and (not step);
							 arbitr_decoder_data(1) <= '0' and (not step);
							 arbitr_decoder_data(2) <= '1' and (not step);
							 arbitr_decoder_data(3) <= '0' and (not step);
							 
			when others => arbitr_decoder_data(0) <= '0' and (not step);
							 arbitr_decoder_data(1) <= '0' and (not step);
							 arbitr_decoder_data(2) <= '0' and (not step);
							 arbitr_decoder_data(3) <= '1' and (not step);
						 
		end case;
end process;

Arbitr_collector_rom_x : process (greenghost_new_position_x, yellowghost_new_position_x, redghost_new_position_x, blueghost_new_position_x, tuxman_new_position_x, arbitr_decoder_data, step)
	begin
		if step = '1' then
			selected_coords_x <= tuxman_new_position_x;
		else
			case arbitr_decoder_data is
				when "0001" => selected_coords_x <= redghost_new_position_x;
				when "0010" => selected_coords_x <= blueghost_new_position_x;
				when "0100" => selected_coords_x <= yellowghost_new_position_x;
				when "1000" => selected_coords_x <= greenghost_new_position_x;
				when others =>
			end case;
		end if;
end process;

Arbitr_collector_rom_y : process (greenghost_new_position_y, yellowghost_new_position_y, redghost_new_position_y, blueghost_new_position_y, tuxman_new_position_y, arbitr_decoder_data, step)
	begin
		if step = '1' then
			selected_coords_y <= tuxman_new_position_y;
		else
			case arbitr_decoder_data is
				when "0001" => selected_coords_y <= redghost_new_position_y;
				when "0010" => selected_coords_y <= blueghost_new_position_y;
				when "0100" => selected_coords_y <= yellowghost_new_position_y;
				when "1000" => selected_coords_y <= greenghost_new_position_y;
				when others =>
			end case;
		end if;
end process;

collision <= wall_data(to_integer(unsigned(selected_coords_x)), to_integer(unsigned(selected_coords_y)));

Arbitr_ghost_selection : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				redghost_collision <= '0';
				blueghost_collision <= '0';
				yellowghost_collision <= '0';
				greenghost_collision <= '0';
			else 
				case arbitr_decoder_data is
					when "0001" => redghost_collision <= collision;
					when "0010" => blueghost_collision <= collision;
					when "0100" => yellowghost_collision <= collision;
					when "1000" => greenghost_collision <= collision;
					when others =>
				end case;
			end if;
		end if;
end process;

--Checking map

opening_tuxman_mouth : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				tuxman_open <= '0';
			else 
				if step = '1' then
					tuxman_open <= not tuxman_open;
				end if;
			end if;
		end if;
end process;

TuxMan_Map_Activity : process(VGA_HPos, VGA_VPos)
	begin
		if ((VGA_HPos(9 downto 4) < map_resolution_x) and (VGA_VPos(9 downto 4) < map_resolution_y)) then
			map_active <= '1';
		else
			map_active <= '0';
		end if;
end process;

Monitor_Coloring_Mux : process(VGA_active, map_active, is_wall,VGA_HPos,VGA_VPos, is_tuxman, tuxman_open, is_redghost, is_blueghost, is_greenghost, is_yellowghost, Points_is_point) --Output setter
	begin
		if VGA_active = '1' then
			if map_active = '1' then
				if is_wall = '1' then
					R<= wall_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5);
					G<= wall_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
					B<= wall_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
				else
					if is_redghost = '1' then
						if tuxman_open = '1' then
								R<= redghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5);
								G<= redghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
								B<= redghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
						else			 
								R<= redghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5);
								G<= redghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
								B<= redghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
						end if;
					else
						if is_blueghost = '1' then
							if tuxman_open = '1' then
								R<= blueghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5); 
								G<= blueghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
								B<= blueghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
							else 
								R<= blueghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5);
								G<= blueghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
								B<= blueghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
							end if;
						else
							if is_yellowghost = '1' then
								if tuxman_open = '1' then
				               R<= yellowghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5); --Right
									G<= yellowghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
									B<= yellowghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
								else 
								   R<= yellowghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5);
									G<= yellowghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
									B<= yellowghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
								end if;
							else
								if is_greenghost = '1' then
									if tuxman_open = '1' then
										R<= greenghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5); 
										G<= greenghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
										B<= greenghost_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
										
									else
										R<= greenghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5);
										G<= greenghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
										B<= greenghost_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
									end if;
								else
									if is_tuxman = '1' then
										if tuxman_open = '1' then
											case tuxman_directions is 
												when "00" => R<= tuxman_open_texture(to_integer(unsigned("1111" - VGA_HPos(3 downto 0))),to_integer(unsigned("1111" - VGA_VPos(3 downto 0))))(7 downto 5); --Up
																 G<= tuxman_open_texture(to_integer(unsigned("1111" - VGA_HPos(3 downto 0))),to_integer(unsigned("1111" - VGA_VPos(3 downto 0))))(4 downto 2);
																 B<= tuxman_open_texture(to_integer(unsigned("1111" - VGA_HPos(3 downto 0))),to_integer(unsigned("1111" - VGA_VPos(3 downto 0))))(1 downto 0);
												
												when "01" => R<= tuxman_open_texture(to_integer(unsigned("1111" - VGA_VPos(3 downto 0))),to_integer(unsigned("1111" - VGA_HPos(3 downto 0))))(7 downto 5); --Left
																 G<= tuxman_open_texture(to_integer(unsigned("1111" - VGA_VPos(3 downto 0))),to_integer(unsigned("1111" - VGA_HPos(3 downto 0))))(4 downto 2);
																 B<= tuxman_open_texture(to_integer(unsigned("1111" - VGA_VPos(3 downto 0))),to_integer(unsigned("1111" - VGA_HPos(3 downto 0))))(1 downto 0);
												
												when "10" => R<= tuxman_open_texture(to_integer(unsigned(VGA_HPos(3 downto 0))),to_integer(unsigned(VGA_VPos(3 downto 0))))(7 downto 5); --Down
																 G<= tuxman_open_texture(to_integer(unsigned(VGA_HPos(3 downto 0))),to_integer(unsigned(VGA_VPos(3 downto 0))))(4 downto 2);
																 B<= tuxman_open_texture(to_integer(unsigned(VGA_HPos(3 downto 0))),to_integer(unsigned(VGA_VPos(3 downto 0))))(1 downto 0);
																 
												when others => R<= tuxman_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5); --Right
																	G<= tuxman_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
																	B<= tuxman_open_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
											end case;
											
										else
											case tuxman_directions is 
												when "00" => R<= tuxman_closed_texture(to_integer(unsigned("1111" - VGA_HPos(3 downto 0))),to_integer(unsigned("1111" - VGA_VPos(3 downto 0))))(7 downto 5); --Up
																 G<= tuxman_closed_texture(to_integer(unsigned("1111" - VGA_HPos(3 downto 0))),to_integer(unsigned("1111" - VGA_VPos(3 downto 0))))(4 downto 2);
																 B<= tuxman_closed_texture(to_integer(unsigned("1111" - VGA_HPos(3 downto 0))),to_integer(unsigned("1111" - VGA_VPos(3 downto 0))))(1 downto 0);
																 
												when "01" => R<= tuxman_closed_texture(to_integer(unsigned("1111" - VGA_VPos(3 downto 0))),to_integer(unsigned("1111" - VGA_HPos(3 downto 0))))(7 downto 5); --Left
																 G<= tuxman_closed_texture(to_integer(unsigned("1111" - VGA_VPos(3 downto 0))),to_integer(unsigned("1111" - VGA_HPos(3 downto 0))))(4 downto 2);
																 B<= tuxman_closed_texture(to_integer(unsigned("1111" - VGA_VPos(3 downto 0))),to_integer(unsigned("1111" - VGA_HPos(3 downto 0))))(1 downto 0);
												
												when "10" => R<= tuxman_closed_texture(to_integer(unsigned(VGA_HPos(3 downto 0))),to_integer(unsigned(VGA_VPos(3 downto 0))))(7 downto 5); --Down
																 G<= tuxman_closed_texture(to_integer(unsigned(VGA_HPos(3 downto 0))),to_integer(unsigned(VGA_VPos(3 downto 0))))(4 downto 2);
																 B<= tuxman_closed_texture(to_integer(unsigned(VGA_HPos(3 downto 0))),to_integer(unsigned(VGA_VPos(3 downto 0))))(1 downto 0);
																 
												when others => R<= tuxman_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5);
																	G<= tuxman_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
																	B<= tuxman_closed_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
											end case;
										end if;
									else
										if Points_is_point = '1' then
											R<= point_texture(to_integer(unsigned(VGA_HPos(3 downto 0))),to_integer(unsigned(VGA_VPos(3 downto 0))))(7 downto 5); --Down
											G<= point_texture(to_integer(unsigned(VGA_HPos(3 downto 0))),to_integer(unsigned(VGA_VPos(3 downto 0))))(4 downto 2);
											B<= point_texture(to_integer(unsigned(VGA_HPos(3 downto 0))),to_integer(unsigned(VGA_VPos(3 downto 0))))(1 downto 0);
										else
											R <= "000";
											G <= "000";
											B <= "00";
										end if;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			else
				R <= "000";
				G <= "000";
				B <= "00";
			end if;
		else
			R <= "000";
			G <= "000";
			B <= "00";
		end if;
end process;


end Behavioral;
