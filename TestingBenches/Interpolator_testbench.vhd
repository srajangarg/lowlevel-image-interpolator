--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:39:23 03/22/2016
-- Design Name:   
-- Module Name:   /home/anuj/DLDProject/ImageInterpolator/test456.vhd
-- Project Name:  ImageInterpolator
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: interpolator
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test456 IS
END test456;
 
ARCHITECTURE behavior OF test456 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT interpolator
    PORT(
         clk : IN  std_logic;
         currentPixel : IN  std_logic_vector(15 downto 0);
         leftPixel : IN  std_logic_vector(15 downto 0);
         rightPixel : IN  std_logic_vector(15 downto 0);
         upperPixel : IN  std_logic_vector(15 downto 0);
         lowerPixel : IN  std_logic_vector(15 downto 0);
         K : IN  std_logic_vector(15 downto 0);
         outputPixel : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal currentPixel : std_logic_vector(15 downto 0) := (others => '0');
   signal leftPixel : std_logic_vector(15 downto 0) := (others => '0');
   signal rightPixel : std_logic_vector(15 downto 0) := (others => '0');
   signal upperPixel : std_logic_vector(15 downto 0) := (others => '0');
   signal lowerPixel : std_logic_vector(15 downto 0) := (others => '0');
   signal K : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal outputPixel : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: interpolator PORT MAP (
          clk => clk,
          currentPixel => currentPixel,
          leftPixel => leftPixel,
          rightPixel => rightPixel,
          upperPixel => upperPixel,
          lowerPixel => lowerPixel,
          K => K,
          outputPixel => outputPixel
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		lowerPixel <=(others=>'0');
      upperPixel <=(others=>'0');
		leftPixel <=(15=>'1',others=>'0');
		rightPixel <=(others=>'0');
		currentPixel <=(13=>'1',others=>'0');
		K <= (others=>'1');
		wait for 100 ns;	
	
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
