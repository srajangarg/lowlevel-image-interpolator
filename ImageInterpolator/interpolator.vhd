----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:26:45 03/22/2016 
-- Design Name: 
-- Module Name:    interpolator - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity interpolator is
    Port ( clk : in STD_LOGIC;
			  calc : in STD_LOGIC;
			  centralPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           leftPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           rightPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           upperPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           lowerPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           K : in  STD_LOGIC_VECTOR (15 downto 0);
           outputPixel : out  STD_LOGIC_VECTOR (15 downto 0));
end interpolator;

architecture Behavioral of interpolator is
--signal b : unsigned (15 downto 0) :=(others=>'0');
--signal c : unsigned (14 downto 0) :=(others=>'0');
--signal p : unsigned (10 downto 0) :=(9=>'1',others=>'0');
constant four : unsigned(2 downto 0) :="100"; --signal
constant pow2_16 : unsigned(16 downto 0) :=(16=>'1',others=>'0');
constant zero_18 : unsigned(17 downto 0) :=(others=>'0');
begin

process(clk)
variable a: unsigned(34 downto 0);
variable temp : integer range 33 downto 0;
begin
	if(clk'event and clk = '1') then
		if(calc = '1') then
			--temp := 4*to_integer(unsigned(K))*to_integer(unsigned(centralPixel))
			--		+ to_integer(unsigned(pow2_16 - K))*
			--		  to_integer(unsigned(leftPixel + rightPixel + upperPixel + lowerPixel));
			--pixel <= std_logic_vector(to_unsigned(temp,34));
			--if(temp mod (4*to_integer(unsigned(pow2_16))) < 2*to_integer(unsigned(pow2_16))) then
			--	temp :=to_integer(to_unsigned(temp,34)/(4*unsigned(pow2_16)));
			--	outputPixel <= std_logic_vector(to_unsigned(temp,16));
			--else
			--	temp :=to_integer(to_unsigned(temp,34)/(4*unsigned(pow2_16)));
			--	outputPixel <= std_logic_vector(to_unsigned(temp,16))+ '1';
			--end if;
			
			a := four*unsigned(K)*unsigned(centralPixel) + (pow2_16 - unsigned(K))*(zero_18 + unsigned(leftPixel)+ unsigned(rightPixel) + unsigned(upperPixel) + unsigned(lowerPixel));
			if(a(17)='1') then
				outputPixel <= std_logic_vector(a(33 downto 18))+1;
			else
				outputPixel <= std_logic_vector(a(33 downto 18));
			end if;
			--a := p+p;
			--b<=a;
			--c<=a;
			--outputPixel <= std_logic_vector(a);
		else
			outputPixel <= (others=>'0');
		end if;
	end if;
end process;
end Behavioral;