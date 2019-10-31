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
signal step : STD_LOGIC;
signal step_edge_detection : STD_LOGIC;		

signal tuxman_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal tuxman_position_y : STD_LOGIC_VECTOR(4 downto 0); 

signal tuxman_new_position_x : STD_LOGIC_VECTOR(4 downto 0);
signal tuxman_new_position_y : STD_LOGIC_VECTOR(4 downto 0);

signal tuxman_step_enable : STD_LOGIC;
signal tuxman_collision : STD_LOGIC;
signal tuxman_directions : STD_LOGIC_VECTOR(1 downto 0);

signal tuxman_position_x_inc : STD_LOGIC_VECTOR(4 downto 0);
signal tuxman_position_x_dec : STD_LOGIC_VECTOR(4 downto 0);
signal tuxman_position_y_inc : STD_LOGIC_VECTOR(4 downto 0);
signal tuxman_position_y_dec : STD_LOGIC_VECTOR(4 downto 0);

signal map_active : STD_LOGIC;
signal is_wall : STD_LOGIC;
signal is_tuxman : STD_LOGIC;
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

begin

is_wall <= wall_data(to_integer(unsigned(VGA_HPos(8 downto 4))), to_integer(unsigned(VGA_VPos(8 downto 4)))) when map_active = '1' else '0';
is_tuxman <= '1' when (tuxman_position_x =  VGA_HPos(8 downto 4)) and (tuxman_position_y =  VGA_VPos(8 downto 4))
					  else '0';

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

step <= (not step_edge_detection) and counter(23);
tuxman_step_enable <= (not tuxman_collision) and step; 

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

tuxman_position_x_inc <=  tuxman_position_x + 1;
tuxman_position_x_dec <=  tuxman_position_x - 1;

tuxman_position_y_inc <=  tuxman_position_y + 1;
tuxman_position_y_dec <=  tuxman_position_y - 1;

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

checking_wall_before_tuxman : process(tuxman_position_x_inc, tuxman_position_x_dec, tuxman_position_y_inc, tuxman_position_y_dec, tuxman_directions)
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

tuxman_collision <= wall_data(to_integer(unsigned(tuxman_new_position_x)), to_integer(unsigned(tuxman_new_position_y)));

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

Monitor_Coloring_Mux : process(VGA_active, map_active, is_wall,VGA_HPos,VGA_VPos, is_tuxman, tuxman_open) --Output setter
	begin
		if VGA_active = '1' then
			if map_active = '1' then
				if is_wall = '1' then
					R<= wall_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(7 downto 5);
					G<= wall_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(4 downto 2);
					B<= wall_texture(to_integer(unsigned(VGA_VPos(3 downto 0))),to_integer(unsigned(VGA_HPos(3 downto 0))))(1 downto 0);
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
