----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:49:01 10/24/2019 
-- Design Name: 
-- Module Name:    VGA - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           VSync : out  STD_LOGIC;
           HSync : out  STD_LOGIC;
			  HPos_out : out STD_LOGIC_VECTOR(9 downto 0);
			  VPos_out : out STD_LOGIC_VECTOR(9 downto 0);
			  pos_active : out STD_LOGIC);
end VGA;

architecture Behavioral of VGA is

--Horizontal vga timing
constant hva : integer := 640;
constant hfp : integer := 16;
constant hsp : integer := 96;
constant hbp  : integer := 48;

--Vertical vga timing
constant vva : integer := 480;
constant vfp : integer := 10;
constant vsp : integer := 2;
constant vbp : integer := 33;

signal HPOS : integer range 0 to 800;
signal VPOS : integer range 0 to 525;

signal counter : STD_LOGIC;
signal active : STD_LOGIC;

begin

slowing_down_clk : process(clk)
	begin
		if(clk'event and clk='1') then -- rising edge on CLK          
			if(reset = '1') then -- reset
				counter <= '0';
			else 
				counter <= not counter;
			end if;
		end if;
end process;

VGA_Timing : process(CLK)
	begin
		if rising_edge(CLK) then
			if reset = '1' then
				HPOS <= 0;
				VPOS <= 0;
			else
				if counter = '1' then
					if HPOS < (hva+hfp+hsp+hbp - 1) then
						HPOS <= HPOS + 1;
				   else
					   HPOS <= 0;
						if VPOS < (vva+vfp+vsp+vbp - 1) then
							VPOS <= VPOS + 1;
						else
							VPOS <= 0;
						end if;
				   end if;
			  end if;
			end if;
		end if;
end process;

Generating_Sync_Signals : process(HPOS, VPOS)
	begin
		if HPOS > (hva+hfp) and HPOS < (hva+hfp+hsp) then
		  HSYNC <= '0';
		else
		  HSYNC <= '1';
		end if;
				  
		if VPOS > (vva+vfp) and VPOS < (vva+vfp+vsp) then
		  VSYNC <= '0';
		else
		  VSYNC <= '1';
		end if;
end process;

Activity_indicator : process(HPOS, VPOS)
	begin
		if (HPOS < hva) and (VPOS < vva) then
			active <= '1';
	  else
			active <= '0'; 
	  end if;
end process;

pos_active <= active;

HPos_out <= std_logic_vector(to_unsigned(HPOS, HPos_out'length)) WHEN active='1' ELSE (others=>'0');
VPos_out <= std_logic_vector(to_unsigned(VPOS, VPos_out'length)) WHEN active='1' ELSE (others=>'0');

end Behavioral;
