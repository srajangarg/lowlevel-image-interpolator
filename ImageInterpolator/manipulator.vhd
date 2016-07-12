----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:30:06 03/30/2016 
-- Design Name: 
-- Module Name:    manipulator - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.MATH_REAL.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity manipulator is
	 Generic (
			  N : integer range 6 downto 0:= 4);
    Port ( clk : in STD_LOGIC;
			  inpixel : in  STD_LOGIC_VECTOR (15 downto 0);
           reset : in  STD_LOGIC;
           load : in  STD_LOGIC;			  
			  i : in  STD_LOGIC_VECTOR (7 downto 0);
           j : in  STD_LOGIC_VECTOR (7 downto 0);
           centralPixel : out  STD_LOGIC_VECTOR (15 downto 0);
           leftPixel : out  STD_LOGIC_VECTOR (15 downto 0);
           rightPixel : out  STD_LOGIC_VECTOR (15 downto 0);
           upperPixel : out  STD_LOGIC_VECTOR (15 downto 0);
           lowerPixel : out  STD_LOGIC_VECTOR (15 downto 0)
			  );
end manipulator;

architecture Behavioral of manipulator is
signal pixels: STD_LOGIC_VECTOR(64*N-1 downto 0) := (others => '0');
begin
process(clk)
variable k: integer:=0;
variable k_c: integer:=0;
variable k_d: integer:=0;
variable k_u: integer:=0;
variable i_t: integer:=0;
variable j_t: integer:=0;
begin
	if(clk'event and clk = '1') then
		
		-- reset
		
		if(reset='1') then
			pixels <= (others =>'0');
		end if;
		
		-- indexing
		
		i_t := to_integer(unsigned(i));
		j_t := to_integer(unsigned(j));
		k := 16*((i_t mod 4)*N+j_t);
		k_c := 16*(((i_t-2) mod 4)*N+j_t);
		k_u := 16*(((i_t-3) mod 4)*N+j_t);
		k_d := 16*(((i_t-1) mod 4)*N+j_t);
		
		-- loading input pixels
		
		if(load='1') then	
			pixels(k+15 downto k)<=inpixel;
		else
			pixels(k+15 downto k)<=(others=>'0');
		end if;
		
		-- assigning output pixels
		
		centralPixel <= pixels(k_c+15 downto k_c);
		upperPixel <= pixels(k_u+15 downto k_u);
		lowerPixel <= pixels(k_d+15 downto k_d);
		if(j_t = 0) then
			leftPixel <= (others=>'0');
		else
			leftPixel <= pixels(k_c-1 downto k_c-16);
		end if;
		
		if(j_t = N-1) then
			rightPixel <= (others=>'0');
		else
			rightPixel <= pixels(k_c+31 downto k_c+16);
		end if;

	end if;
end process;

end Behavioral;