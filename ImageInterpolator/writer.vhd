----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:32:54 04/06/2016 
-- Design Name: 
-- Module Name:    writer - Behavioral 
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
use std.textio.all;
use ieee.std_logic_textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity writer is
	 GENERIC (
			  out_file : string := "interpolated.txt"
			  );
    Port ( clk : in STD_LOGIC;
			  outputReady : in  STD_LOGIC;
           outputRPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           outputGPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           outputBPixel : in  STD_LOGIC_VECTOR (15 downto 0));
end writer;

architecture Behavioral of writer is
file o_file: TEXT open write_mode is out_file;
begin
process(clk)
variable l : line;
begin
	if(clk'event and clk = '1') then
		if(outputReady = '1') then
			write(l,outputRPixel);
			write(l,outputGPixel);
			write(l,outputBPixel);
			writeline(o_file, l);
		end if;
	end if;
end process;
end Behavioral;

