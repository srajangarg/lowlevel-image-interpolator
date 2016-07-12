----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:07:17 03/30/2016 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
	 Generic ( N: integer:= 100);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start : in  STD_LOGIC;
			  comp1 : in  STD_LOGIC;
           comp2 : in  STD_LOGIC;
           comp3 : in  STD_LOGIC;
			  --i : in STD_LOGIC_VECTOR(7 downto 0);
			  --j : in STD_LOGIC_VECTOR(7 downto 0);
   		  loadABC : out STD_LOGIC:='0';
           load : out  STD_LOGIC:='0';
           update : out  STD_LOGIC:='0';
           calc : out  STD_LOGIC:='0';
           outputReady : out  STD_LOGIC:='0');
end controller;

architecture Behavioral of controller is
signal state : STD_LOGIC_VECTOR(3 downto 0):="1111";
signal size : STD_LOGIC_VECTOR(7 downto 0) := std_logic_vector(to_unsigned(N-1,8));
begin
process(clk)
begin
	if(clk'event and clk='1') then
		case state is
			when "0000" =>
				if(reset='1') then
					state <= "0001";
				else
					state <= "1111";
				end if;
			when "0001" =>
				if(reset='0' and start='1') then
					state <= "0010";
					loadABC <= '1';
				end if;
			when "0010" =>
				if(reset='0' and start='1') then
					state <= "0011";
					loadABC <= '0';
					load <= '1';
					update <= '1';
				end if;
			when "0011" =>
				if(start='0') then
					state <= "0100";
				end if;
			when "0100" =>
				--if(i>"0000001") then
				if(comp1='1') then -- i>1
					state <= "0101";
					calc <= '1';
				end if;
			when "0101" =>
				state <= "0110";
				outputReady <= '1';
			when "0110" =>
				--if(i=size and j = "0000000") then
				if(comp2='1') then -- i=99 and j=0
					state <= "0111";
					load <= '0';
				end if;
			when "0111" =>
				--if(i>size + 2) then
				if(comp3='1') then -- i>101
					state <= "1000";
					calc <= '0';
				end if;
			when "1000" =>
				state <= "1111";
				outputReady <= '0';
			when "1111" =>
				loadABC <= '0';
				load <= '0';
				calc <='0';
				update <= '0';
				outputReady <= '0';
				if(reset = '1') then
					state <= "0000";
				end if;
			when others =>
		end case;
	end if;		
end process;
end Behavioral;