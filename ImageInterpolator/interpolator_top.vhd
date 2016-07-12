----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:57:47 03/30/2016 
-- Design Name: 
-- Module Name:    interpolator_top - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity interpolator_top is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start : in  STD_LOGIC;
           RPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           GPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           BPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           outRPixel : inout  STD_LOGIC_VECTOR (15 downto 0);
           outGPixel : inout  STD_LOGIC_VECTOR (15 downto 0);
           outBPixel : inout  STD_LOGIC_VECTOR (15 downto 0);
           outputReady : inout  STD_LOGIC);
end interpolator_top;

architecture Behavioral of interpolator_top is

COMPONENT controller is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start : in  STD_LOGIC;
			  comp1 : in  STD_LOGIC; --variable independent of size of i & j
           comp2 : in  STD_LOGIC;
           comp3 : in  STD_LOGIC;
			  --i : in STD_LOGIC_VECTOR(7 downto 0);
			  --j : in STD_LOGIC_VECTOR(7 downto 0);
   		  loadABC : out STD_LOGIC;
           load : out  STD_LOGIC;
           update : out  STD_LOGIC;
           calc : out  STD_LOGIC;
           outputReady : out  STD_LOGIC);
END COMPONENT;
COMPONENT manipulator is 
	 Port ( clk : in STD_LOGIC;
			  reset : in  STD_LOGIC;
           load : in  STD_LOGIC;
			  inpixel : in  STD_LOGIC_VECTOR (15 downto 0);
			  i : in  STD_LOGIC_VECTOR (7 downto 0);
           j : in  STD_LOGIC_VECTOR (7 downto 0);
           centralPixel : out  STD_LOGIC_VECTOR (15 downto 0);
           leftPixel : out  STD_LOGIC_VECTOR (15 downto 0);
           rightPixel : out  STD_LOGIC_VECTOR (15 downto 0);
           upperPixel : out  STD_LOGIC_VECTOR (15 downto 0);
           lowerPixel : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT;

COMPONENT interpolator is
    Port ( clk : in STD_LOGIC;
			  calc : in STD_LOGIC;
			  centralPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           leftPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           rightPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           upperPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           lowerPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           K : in  STD_LOGIC_VECTOR (15 downto 0);
           outputPixel : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT;

COMPONENT loadConst is
    Port ( clk : STD_LOGIC;
			  loadABC : in  STD_LOGIC;
           Ain : in  STD_LOGIC_VECTOR (15 downto 0);
           Bin : in  STD_LOGIC_VECTOR (15 downto 0);
           Cin : in  STD_LOGIC_VECTOR (15 downto 0);
           A : out  STD_LOGIC_VECTOR (15 downto 0);
           B : out  STD_LOGIC_VECTOR (15 downto 0);
           C : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT;

COMPONENT UpdateIndex is
    Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  update : in STD_LOGIC;
			  i : inout  STD_LOGIC_VECTOR (7 downto 0);
           j : inout  STD_LOGIC_VECTOR (7 downto 0);
			  comp1 : out STD_LOGIC; -- variable independent of size of i & j
			  comp2 : out STD_LOGIC;
			  comp3 : out STD_LOGIC);
END COMPONENT;

COMPONENT writer is
	 GENERIC (
			  out_file : string := "interpolated.txt"
			  );
    Port ( clk : in STD_LOGIC;
			  outputReady : in  STD_LOGIC;
           outputRPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           outputGPixel : in  STD_LOGIC_VECTOR (15 downto 0);
           outputBPixel : in  STD_LOGIC_VECTOR (15 downto 0));
end COMPONENT;

signal loadABC :STD_LOGIC := '0';
signal load : STD_LOGIC := '0';
signal calc : STD_LOGIC := '0';
signal update : STD_LOGIC := '0';

signal i : STD_LOGIC_VECTOR(7 downto 0) := (others =>'0');
signal j : STD_LOGIC_VECTOR(7 downto 0) := (others =>'0');

signal A : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal B : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal C : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');

signal R_c : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal R_u : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal R_d : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal R_l : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal R_r : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');

signal G_c : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal G_u : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal G_d : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal G_L : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal G_r : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');

signal B_c : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal B_u : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal B_d : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal B_l : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal B_r : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');

signal comp_1: STD_LOGIC := '0';
signal comp_2: STD_LOGIC := '0';
signal comp_3: STD_LOGIC := '0';

begin

ImageController : controller
	PORT MAP(
		clk => clk,
		reset => reset,
		start => start,
		comp1 => comp_1,
		comp2 => comp_2,
		comp3 => comp_3,
		--i => i,
		--j => j,
		loadABC => loadABC,
		load => load,
		update => update,
		calc => calc,
		outputReady => outputReady
	);
	
RedManipulator : manipulator
	PORT MAP(
		clk => clk,
		reset => reset,
		load => load,
		inpixel => RPixel,
		i => i,
		j => j,
		centralpixel => R_c,
		leftpixel => R_l,
		rightpixel => R_r,
		upperpixel => R_u,
		lowerpixel =>R_d
	);
		
GreenManipulator : manipulator
	PORT MAP(
		clk => clk,
		reset => reset,
		load => load,
		inpixel => GPixel,
		i => i,
		j => j,
		centralpixel => G_c,
		leftpixel => G_l,
		rightpixel => G_r,
		upperpixel => G_u,
		lowerpixel => G_d
	);
	
BlueManipulator : manipulator
	PORT MAP(
		clk => clk,
		reset => reset,
		load => load,
		inpixel => BPixel,
		i => i,
		j => j,
		centralpixel => B_c,
		leftpixel => B_l,
		rightpixel => B_r,
		upperpixel => B_u,
		lowerpixel => B_d
	);
	
RedInterpolator : interpolator
	PORT MAP(
		clk => clk,
		calc => calc,
		centralPixel => R_c,
		leftPixel => R_l,
		rightPixel => R_r,
		upperPixel => R_u,
		lowerPixel => R_d,
		K => A,
		outputPixel => outRPixel
	);
	
GreenInterpolator : interpolator
	PORT MAP(
		clk => clk,
		calc => calc,
		centralPixel => G_c,
		leftPixel => G_l,
		rightPixel => G_r,
		upperPixel => G_u,
		lowerPixel => G_d,
		K => B,
		outputPixel => outGPixel
	);
	
BlueInterpolator : interpolator
	PORT MAP(
		clk => clk,
		calc => calc,
		centralPixel => B_c,
		leftPixel => B_l,
		rightPixel => B_r,
		upperPixel => B_u,
		lowerPixel => B_d,
		K => C,
		outputPixel => outBPixel
	);
	
LoadConstABC : LoadConst
	PORT MAP(
		clk => clk,
		loadABC => loadABC,
		Ain => RPixel,
		Bin => GPixel,
		Cin => BPixel,
		A => A,
		B => B,
		C => C
	);
	
Updateij : UpdateIndex
	PORT MAP(
		clk => clk,
		reset => reset,
		update => update,
		i => i,
		j => j,
		comp1 => comp_1,
		comp2 => comp_2,
		comp3 => comp_3
	);
	
writeImage : writer
	PORT MAP(
		clk => clk,
		outputReady => outputReady,
		outputRPixel => outRPixel,
		outputGPixel => outGPixel,
		outputBPixel => outBPixel
	);

end Behavioral;
