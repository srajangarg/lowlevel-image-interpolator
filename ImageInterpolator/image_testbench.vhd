--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:29:08 04/02/2016
-- Design Name:   
-- Module Name:   /home/anuj/DLDProject/ImageInterpolator/image_testbench.vhd
-- Project Name:  ImageInterpolator
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: interpolator_top
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
 
ENTITY image_testbench IS
END image_testbench;
 
ARCHITECTURE behavior OF image_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT interpolator_top
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         start : IN  std_logic;
         RPixel : IN  std_logic_vector(15 downto 0);
         GPixel : IN  std_logic_vector(15 downto 0);
         BPixel : IN  std_logic_vector(15 downto 0);
         outRPixel : OUT  std_logic_vector(15 downto 0);
         outGPixel : OUT  std_logic_vector(15 downto 0);
         outBPixel : OUT  std_logic_vector(15 downto 0);
         outputReady : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';
   signal RPixel : std_logic_vector(15 downto 0) := (others => '0');
   signal GPixel : std_logic_vector(15 downto 0) := (others => '0');
   signal BPixel : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal outRPixel : std_logic_vector(15 downto 0);
   signal outGPixel : std_logic_vector(15 downto 0);
   signal outBPixel : std_logic_vector(15 downto 0);
   signal outputReady : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: interpolator_top PORT MAP (
          clk => clk,
          reset => reset,
          start => start,
          RPixel => RPixel,
          GPixel => GPixel,
          BPixel => BPixel,
          outRPixel => outRPixel,
          outGPixel => outGPixel,
          outBPixel => outBPixel,
          outputReady => outputReady
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
		reset<='1';
      wait for clk_period*5;
		reset<='0';
		start<='1';
		RPixel<="1000000000000000";
		GPixel<="1000000000000000";
		BPixel<="1000000000000000";
      wait for clk_period*2;
		start<='0';
		RPixel<="0000000000000100";
		GPixel<="0000000000000100";
		BPixel<="0000000000000100";
      -- insert stimulus here 

      wait;
   end process;

END;
